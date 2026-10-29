# Check installer failure behavior without downloading or executing Windows tools.
#Requires -Version 5.1
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Tokens = $null
$ParseErrors = $null
$Ast = [System.Management.Automation.Language.Parser]::ParseFile(
    (Join-Path $PSScriptRoot 'bootstrap.ps1'), [ref]$Tokens, [ref]$ParseErrors)
if ($ParseErrors.Count) { throw ($ParseErrors | Out-String) }
# Load only the two helpers, never bootstrap's platform checks or installation.
foreach ($Statement in $Ast.EndBlock.Statements) {
    if ($Statement -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
        . ([scriptblock]::Create($Statement.Extent.Text))
    }
}

$TestRoot = Join-Path ([IO.Path]::GetTempPath()) ("astra-bootstrap-test-" + [Guid]::NewGuid())
$AstraTools = Join-Path $TestRoot 'tools'
$Downloads = Join-Path $TestRoot 'downloads'
$Source = Join-Path $TestRoot 'source'
New-Item -ItemType Directory -Path $AstraTools, $Downloads, $Source | Out-Null
try {
    $Nested = Join-Path $Source 'vendor'
    New-Item -ItemType Directory -Path $Nested | Out-Null
    Set-Content -LiteralPath (Join-Path $Nested 'tool.exe') -Value 'fixture; never executed'
    Set-Content -LiteralPath (Join-Path $Nested 'support.txt') -Value 'required adjacent file'
    $Archive = Join-Path $Downloads 'fixture-1.zip'
    Compress-Archive -Path $Nested -DestinationPath $Archive
    $Release = @{
        Version = '1'
        Url = 'https://invalid.example/never-requested.zip'
        Sha256 = (Get-FileHash -LiteralPath $Archive -Algorithm SHA256).Hash
    }
    Install-Archive $Release 'fixture' 'tool.exe'
    if (-not (Test-Path -LiteralPath (Join-Path $AstraTools 'fixture-1/support.txt'))) {
        throw 'Installation lost an executable-adjacent file.'
    }
    Install-Archive $Release 'fixture' 'tool.exe'
    Write-Output 'PASS: nested archive and repeat installation preserve adjacent files'

    $Release.Sha256 = '0' * 64
    $Rejected = $false
    try { Install-Archive $Release 'fixture' 'tool.exe' } catch {
        if ($_.Exception.Message -notmatch 'Checksum mismatch') { throw }
        $Rejected = $true
    }
    if (-not $Rejected) { throw 'Corrupt archive was accepted.' }
    Write-Output 'PASS: corrupt archive stops installation'

    $Release.Sha256 = (Get-FileHash -LiteralPath $Archive -Algorithm SHA256).Hash
    $Rejected = $false
    try { Install-Archive $Release 'fixture' 'missing.exe' } catch {
        if ($_.Exception.Message -notmatch 'Expected exactly one') { throw }
        $Rejected = $true
    }
    if (-not $Rejected) { throw 'Archive missing its executable was accepted.' }
    Write-Output 'PASS: missing executable stops installation'

    $Shell = (Get-Process -Id $PID).Path
    $Output = Invoke-Checked $Shell @('-NoProfile', '-Command', 'Write-Output success; exit 0')
    if ($Output -cne 'success') { throw 'Native command output was not preserved.' }
    $Rejected = $false
    try { Invoke-Checked $Shell @('-NoProfile', '-Command', 'exit 7') } catch {
        if ($_.Exception.Message -notmatch 'exited with code 7') { throw }
        $Rejected = $true
    }
    if (-not $Rejected) { throw 'Nonzero native exit was accepted.' }
    Write-Output 'PASS: native success output and failure exit handling'
} finally {
    $ResolvedTestRoot = (Resolve-Path -LiteralPath $TestRoot).Path
    $TempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar)
    if (-not $ResolvedTestRoot.StartsWith($TempRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Test cleanup must remain within the temporary directory.'
    }
    Remove-Item -LiteralPath $ResolvedTestRoot -Recurse -Force
}
