# Keep this user's existing desktop on the console after an RDP disconnect.
#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Install', 'Recover', 'Status', 'Remove')]
    [string]$Action,
    [string]$ExpectedUserSid
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$TaskName = 'AstraRouter-ConsoleRecovery'
$Runtime = Join-Path (Split-Path $PSScriptRoot -Parent) '.runtime\desktop'
$Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$UserSid = $Identity.User.Value
$SessionId = (Get-Process -Id $PID).SessionId

if ($Action -eq 'Status') {
    Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName, State, Principal, Triggers
    Get-ScheduledTaskInfo -TaskName $TaskName
    & "$env:SystemRoot\System32\query.exe" session
    $Log = Join-Path $Runtime 'recovery.jsonl'
    if (Test-Path -LiteralPath $Log) { Get-Content -LiteralPath $Log -Tail 5 }
    exit
}

$Principal = New-Object Security.Principal.WindowsPrincipal($Identity)
if (-not $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run from an elevated PowerShell process as the user who owns Altium.'
}
if ($SessionId -le 0) { throw 'A logged-in interactive user session is required.' }

if ($Action -eq 'Remove') {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    exit
}

if ($Action -eq 'Install') {
    $Script = [Security.SecurityElement]::Escape($PSCommandPath)
    $ShellPath = [Security.SecurityElement]::Escape("$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe")
    $Xml = @"
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo><Description>Return the existing Altium user's disconnected RDP session to the console.</Description></RegistrationInfo>
  <Triggers><SessionStateChangeTrigger><Enabled>true</Enabled><StateChange>RemoteDisconnect</StateChange><UserId>$UserSid</UserId></SessionStateChangeTrigger></Triggers>
  <Principals><Principal id="Owner"><UserId>$UserSid</UserId><LogonType>InteractiveToken</LogonType><RunLevel>HighestAvailable</RunLevel></Principal></Principals>
  <Settings><MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy><DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries><StopIfGoingOnBatteries>false</StopIfGoingOnBatteries><StartWhenAvailable>true</StartWhenAvailable><ExecutionTimeLimit>PT1M</ExecutionTimeLimit><Enabled>true</Enabled></Settings>
  <Actions Context="Owner"><Exec><Command>$ShellPath</Command><Arguments>-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File &quot;$Script&quot; -Action Recover -ExpectedUserSid $UserSid</Arguments></Exec></Actions>
</Task>
"@
    New-Item -ItemType Directory -Path $Runtime -Force | Out-Null
    $Existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($Existing) {
        $ExistingUser = $Existing.Principal.UserId
        if ($ExistingUser -match '^S-1-') {
            $ExistingSid = New-Object Security.Principal.SecurityIdentifier($ExistingUser)
        } else {
            $ExistingAccount = New-Object Security.Principal.NTAccount($ExistingUser)
            $ExistingSid = $ExistingAccount.Translate([Security.Principal.SecurityIdentifier])
        }
        if ($ExistingSid.Value -ne $UserSid) {
            throw 'The existing recovery task belongs to another user.'
        }
    }
    Register-ScheduledTask -TaskName $TaskName -Xml $Xml -Force | Select-Object TaskName, State
    $Xml | Set-Content -LiteralPath (Join-Path $Runtime 'task.xml') -Encoding UTF8
    Write-Output "Installed for $($Identity.Name); no password or automatic sign-in is configured."
    exit
}

if (-not $ExpectedUserSid -or $ExpectedUserSid -ne $UserSid) {
    throw 'Recovery requires the exact user SID recorded by Install.'
}

# WTS state avoids parsing localized query.exe output or stale SESSIONNAME values.
Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
// Read this process's Terminal Services state without desktop input.
public static class AstraSessionState {
    [DllImport("kernel32.dll")]
    public static extern uint WTSGetActiveConsoleSessionId();
    [DllImport("wtsapi32.dll", SetLastError = true)]
    private static extern bool WTSQuerySessionInformation(IntPtr server, int session, int field, out IntPtr buffer, out int length);
    [DllImport("wtsapi32.dll")]
    private static extern void WTSFreeMemory(IntPtr buffer);
    // Return WTS_CONNECTSTATE_CLASS for a session owned by this process.
    public static int ConnectionState(int session) {
        IntPtr buffer;
        int length;
        if (!WTSQuerySessionInformation(IntPtr.Zero, session, 8, out buffer, out length))
            throw new Win32Exception(Marshal.GetLastWin32Error());
        try { return Marshal.ReadInt32(buffer); }
        finally { WTSFreeMemory(buffer); }
    }
}
'@

New-Item -ItemType Directory -Path $Runtime -Force | Out-Null
$Record = [ordered]@{
    started_utc = [DateTime]::UtcNow.ToString('o')
    user_sid = $UserSid
    session_id = $SessionId
    result = 'pending'
}
try {
    $Record.state_before = [AstraSessionState]::ConnectionState($SessionId)
    $Record.console_before = [AstraSessionState]::WTSGetActiveConsoleSessionId()
    if ($Record.console_before -eq $SessionId) {
        $Record.result = 'already-console'
    } elseif ($Record.state_before -ne 4) {
        # A reconnect may have completed before the scheduled task started.
        $Record.result = 'skipped-not-disconnected'
    } else {
        $Output = & "$env:SystemRoot\System32\tscon.exe" $SessionId /dest:console /v 2>&1
        $Record.tscon_exit_code = $LASTEXITCODE
        $Record.tscon_output = ($Output | Out-String).Trim()
        if ($LASTEXITCODE -ne 0) { throw "tscon failed with exit code $LASTEXITCODE." }
        for ($Attempt = 0; $Attempt -lt 20; $Attempt++) {
            if ([AstraSessionState]::WTSGetActiveConsoleSessionId() -eq $SessionId -and
                [AstraSessionState]::ConnectionState($SessionId) -eq 0) { break }
            Start-Sleep -Milliseconds 250
        }
        if ([AstraSessionState]::WTSGetActiveConsoleSessionId() -ne $SessionId -or
            [AstraSessionState]::ConnectionState($SessionId) -ne 0) {
            throw 'The session did not become active on the console.'
        }
        $Record.result = 'recovered-console'
    }
} catch {
    $Record.result = 'failed'
    $Record.error = $_.Exception.Message
    throw
} finally {
    $Record.finished_utc = [DateTime]::UtcNow.ToString('o')
    try {
        $Record.console_after = [AstraSessionState]::WTSGetActiveConsoleSessionId()
        $Record.state_after = [AstraSessionState]::ConnectionState($SessionId)
    } catch {
        $Record.final_state_error = $_.Exception.Message
    }
    $Record | ConvertTo-Json -Compress | Add-Content -LiteralPath (Join-Path $Runtime 'recovery.jsonl') -Encoding UTF8
}
