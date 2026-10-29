# Install and verify the standalone Windows toolchain; does not start a routing run.
#Requires -Version 5.1
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT -or
    -not [Environment]::Is64BitProcess -or $env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
    throw 'Run this script in native 64-bit PowerShell on an x64 Windows VM.'
}

# Stop on native command failures in Windows PowerShell 5.1 as well as PowerShell 7.
function Invoke-Checked {
    param([string]$Program, [string[]]$Arguments)
    & $Program @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Program exited with code $LASTEXITCODE. Bootstrap stopped."
    }
}

# Extract a pinned archive after verifying its publisher-provided SHA-256.
function Install-Archive {
    param([hashtable]$Release, [string]$Name, [string]$Executable)
    $Destination = Join-Path $AstraTools "$Name-$($Release.Version)"
    $Archive = Join-Path $Downloads "$Name-$($Release.Version).zip"
    if (-not (Test-Path -LiteralPath $Archive)) {
        $Partial = "$Archive.partial"
        Invoke-WebRequest -UseBasicParsing -Uri $Release.Url -OutFile $Partial
        if ((Get-FileHash -LiteralPath $Partial -Algorithm SHA256).Hash -ne $Release.Sha256) {
            throw "Checksum mismatch for $Name. No files were installed from this download."
        }
        Move-Item -LiteralPath $Partial -Destination $Archive -Force
    }
    if ((Get-FileHash -LiteralPath $Archive -Algorithm SHA256).Hash -ne $Release.Sha256) {
        throw "Checksum mismatch in cached archive $Archive. Remove it before retrying."
    }
    $Extracted = Join-Path $Downloads "$Name-$($Release.Version)"
    Expand-Archive -LiteralPath $Archive -DestinationPath $Extracted -Force
    $Candidates = @(Get-ChildItem -LiteralPath $Extracted -Recurse -File -Filter $Executable)
    if ($Candidates.Count -ne 1) {
        throw "Expected exactly one $Executable in $Archive; found $($Candidates.Count)."
    }
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Copy-Item -Path (Join-Path $Candidates[0].Directory.FullName '*') -Destination $Destination -Recurse -Force
}

$Git = (Get-Command git.exe -ErrorAction Stop).Source
$Config = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'toolchain.psd1')
$Repository = Invoke-Checked $Git @('-C', $PSScriptRoot, 'rev-parse', '--show-toplevel')
if (-not (Test-Path -LiteralPath (Join-Path $Repository 'astra-run\quickstart\toolchain.psd1'))) {
    throw 'Run bootstrap from the astra-run/quickstart directory in a repository checkout.'
}
$Branch = Invoke-Checked $Git @('-C', $PSScriptRoot, 'branch', '--show-current')
$null = Invoke-Checked $Git @('-C', $PSScriptRoot, 'remote', 'get-url', 'origin')

. (Join-Path $PSScriptRoot 'enter.ps1')
$Receipt = Join-Path $AstraWorkspace '.runtime\bootstrap.json'
if (Test-Path -LiteralPath $Receipt) {
    Remove-Item -LiteralPath $Receipt
}
$Downloads = Join-Path $AstraTools 'downloads'
New-Item -ItemType Directory -Path $Downloads -Force | Out-Null
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host 'Installing pinned uv, Git LFS, and Node.js in .tools...'
Install-Archive $Config.Uv 'uv' 'uv.exe'
Install-Archive $Config.GitLfs 'git-lfs' 'git-lfs.exe'
Install-Archive $Config.Node 'node' 'node.exe'

$Uv = Join-Path $AstraBins[0] 'uv.exe'
$Lfs = Join-Path $AstraBins[1] 'git-lfs.exe'
$Node = Join-Path $AstraBins[2] 'node.exe'
$Npm = Join-Path $AstraBins[2] 'npm.cmd'
Invoke-Checked $Uv @('--version')
Invoke-Checked $Lfs @('version')
Invoke-Checked $Node @('--version')

Push-Location $PSScriptRoot
try {
    Invoke-Checked $Git @('config', '--local', 'core.longpaths', 'true')
    Invoke-Checked $Git @('config', '--local', 'push.default', 'nothing')
    Invoke-Checked $Lfs @('install', '--local', '--skip-smudge')
    Invoke-Checked $Git @('config', '--local', 'lfs.fetchinclude', $Config.LfsInclude)
    Invoke-Checked $Git @('lfs', 'pull', "--include=$($Config.LfsInclude)", '--exclude=', 'origin')
    Invoke-Checked $Uv @('python', 'install', $Config.Python)
    Invoke-Checked $Uv @('sync', '--locked', '--project', $PSScriptRoot)
    Invoke-Checked $Npm @('ci', '--include=optional', '--ignore-scripts', '--no-audit', '--no-fund')
    Invoke-Checked (Join-Path $PSScriptRoot 'node_modules\.bin\codex.cmd') @('--version')
    # FFmpeg comes from the locked wheel; desktop control uses the installed plugin.
    $Probe = "import sys, subprocess, PIL, imageio_ffmpeg; print(sys.version); subprocess.run([imageio_ffmpeg.get_ffmpeg_exe(), '-version'], check=True)"
    Invoke-Checked $Uv @('run', '--locked', '--project', $PSScriptRoot, 'python', '-c', $Probe)
    Invoke-Checked $Uv @('pip', 'check', '--python', (Join-Path $AstraWorkspace '.venv\Scripts\python.exe'))

    $Runtime = Join-Path $AstraWorkspace '.runtime'
    New-Item -ItemType Directory -Path $Runtime -Force | Out-Null
    @{
        completed_utc = [DateTime]::UtcNow.ToString('o')
        commit = (Invoke-Checked $Git @('rev-parse', 'HEAD'))
        branch = $Branch
        python = $Config.Python
        uv = $Config.Uv.Version
        git_lfs = $Config.GitLfs.Version
        node = $Config.Node.Version
        altium_qualified = $false
    } | ConvertTo-Json | Set-Content -LiteralPath $Receipt -Encoding UTF8
} finally {
    Pop-Location
}

Write-Host 'Software bootstrap passed. Altium and unattended operation still need qualification.'
Write-Host 'Next: follow astra-run/RUNBOOK.md in the desktop app. The CLI launcher is optional.'
