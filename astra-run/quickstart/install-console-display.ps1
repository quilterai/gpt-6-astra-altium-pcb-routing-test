# Install a local DCV console display with a fixed layout on a fresh Windows VM.
#Requires -Version 5.1
#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateRange(1280, 4096)][int]$Width = 3364,
    [ValidateRange(720, 2160)][int]$Height = 1924
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
if (-not [Environment]::Is64BitProcess -or $env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
    throw 'Run native x64 PowerShell.'
}
if (@(Get-Service | Where-Object Name -eq 'DCVServer').Count -ne 0) {
    throw 'DCVServer already exists. Inspect the existing installation before changing its display.'
}
$AstraOwner = Get-LocalUser -Name 'Administrator'
if (-not $AstraOwner.Enabled) { throw 'The local Administrator account is disabled.' }
$AstraVcRuntime = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64'
if ($AstraVcRuntime.Installed -ne 1) { throw 'Install the x64 Visual C++ runtime before DCV.' }
if (-not $PSCmdlet.ShouldProcess('This VM', "Install DCV core/IDD and a ${Width}x${Height} loopback console display")) {
    return
}

$AstraWorkspace = Split-Path -Parent $PSScriptRoot
$AstraDownloads = Join-Path $AstraWorkspace '.tools\downloads'
$AstraRuntime = Join-Path $AstraWorkspace '.runtime\console-display'
New-Item -ItemType Directory -Path $AstraDownloads, $AstraRuntime -Force | Out-Null
$AstraStamp = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ')
$AstraMsiName = 'nice-dcv-server-x64-Release-2025.0-20103.msi'
$AstraMsi = Join-Path $AstraDownloads $AstraMsiName
$AstraMsiUrl = "https://d1uj6qtbmh3dt5.cloudfront.net/2025.0/Servers/$AstraMsiName"
$AstraSha256 = '593E2B78CD41B64FAC255F303E48B1E7F73129969279BA2EAE067E519F962067'
# SHA-256 published at the MSI URL plus .sha256sum; features inspected in this MSI.
if (-not (Test-Path -LiteralPath $AstraMsi)) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -UseBasicParsing -Uri $AstraMsiUrl -OutFile "$AstraMsi.partial"
    if ((Get-FileHash -LiteralPath "$AstraMsi.partial" -Algorithm SHA256).Hash -ne $AstraSha256) {
        throw 'DCV download checksum mismatch. Nothing was installed.'
    }
    Move-Item -LiteralPath "$AstraMsi.partial" -Destination $AstraMsi
}
if ((Get-FileHash -LiteralPath $AstraMsi -Algorithm SHA256).Hash -ne $AstraSha256) {
    throw 'Cached DCV installer checksum mismatch. Nothing was installed.'
}
$AstraSignature = Get-AuthenticodeSignature -LiteralPath $AstraMsi
if ($AstraSignature.Status -ne 'Valid' -or
    $AstraSignature.SignerCertificate.Subject -notmatch 'Amazon Web Services') {
    throw 'DCV installer signature is not valid for Amazon Web Services.'
}

# Keep the service stopped until loopback binding and the console layout are set.
# https://docs.aws.amazon.com/dcv/latest/adminguide/setting-up-installing-windows-installation.html
$AstraMsiLog = Join-Path $AstraRuntime "$AstraStamp-msi.log"
$AstraMsiArguments = @(
    '/i', "`"$AstraMsi`"", '/quiet', '/norestart',
    'ADDLOCAL=server,iddDriver',
    'REMOVE=audioMicDriver,audioSpkDriver,printerDriver,usbDriver,webcamDriver,gamepadDriver,webClient,webauthn,webrtc,virtualSmartcardDriver',
    'DISABLE_FIREWALL=1', 'DISABLE_SERVER_AUTOSTART=1',
    'DISABLE_AUTOMATIC_SESSION_CREATION=1',
    '/l*v', "`"$AstraMsiLog`""
)
$AstraInstaller = Start-Process -FilePath "$env:SystemRoot\System32\msiexec.exe" -ArgumentList $AstraMsiArguments -WindowStyle Hidden -Wait -PassThru
if ($AstraInstaller.ExitCode -notin @(0, 3010)) {
    throw "DCV installer failed with code $($AstraInstaller.ExitCode). Inspect $AstraMsiLog."
}

$AstraRegistryRoot = 'Registry::HKEY_USERS\S-1-5-18\Software\GSettings\com\nicesoftware\dcv'
$AstraSettings = @(
    @{ Key='connectivity'; Name='web-listen-endpoints'; Type='String'; Value="['127.0.0.1:8443']" },
    @{ Key='connectivity'; Name='enable-quic-frontend'; Type='DWord'; Value=0 },
    @{ Key='session-management'; Name='create-session'; Type='DWord'; Value=1 },
    @{ Key='session-management\automatic-console-session'; Name='owner'; Type='String'; Value='Administrator' },
    @{ Key='display'; Name='console-session-default-layout'; Type='String'; Value="[{'w':<$Width>, 'h':<$Height>, 'x':<0>, 'y':<0>}]" },
    @{ Key='display'; Name='enable-client-resize'; Type='DWord'; Value=0 }
)
foreach ($AstraSetting in $AstraSettings) {
    $AstraKey = Join-Path $AstraRegistryRoot $AstraSetting.Key
    if (-not (Test-Path -LiteralPath $AstraKey)) {
        New-Item -Path $AstraKey -Force | Out-Null
    }
    New-ItemProperty -LiteralPath $AstraKey -Name $AstraSetting.Name -PropertyType $AstraSetting.Type -Value $AstraSetting.Value -Force | Out-Null
}
Set-Service -Name 'DCVServer' -StartupType Automatic
if ($AstraInstaller.ExitCode -eq 3010) {
    throw "DCV requires a restart; none was requested. Service was not started. Inspect $AstraMsiLog before continuing."
}

Start-Service -Name 'DCVServer'
$AstraService = Get-Service -Name 'DCVServer'
$AstraService.WaitForStatus([ServiceProcess.ServiceControllerStatus]::Running, [TimeSpan]::FromSeconds(30))
$AstraDcv = Join-Path $env:ProgramFiles 'NICE\DCV\Server\bin\dcv.exe'
& $AstraDcv describe-session console
if ($LASTEXITCODE -ne 0) {
    throw 'DCV started, but console session inspection failed. Inspect its logs before retrying.'
}
Get-CimInstance Win32_VideoController | Select-Object Name, CurrentHorizontalResolution, CurrentVerticalResolution
Write-Host "DCV installed; verify fresh Altium capture, input, recorder frames, and RDP disconnect behavior. MSI log: $AstraMsiLog"
