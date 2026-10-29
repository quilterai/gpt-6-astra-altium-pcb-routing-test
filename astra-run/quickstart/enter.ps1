# Load the workspace tools into the current PowerShell process.
# Usage from astra-run/: . .\quickstart\enter.ps1
#Requires -Version 5.1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
    throw 'This tool environment requires native Windows.'
}
$AstraToolchain = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'toolchain.psd1')
$AstraWorkspace = Split-Path -Parent $PSScriptRoot
$AstraTools = Join-Path $AstraWorkspace '.tools'
$AstraBins = @(
    (Join-Path $AstraTools "uv-$($AstraToolchain.Uv.Version)"),
    (Join-Path $AstraTools "git-lfs-$($AstraToolchain.GitLfs.Version)"),
    (Join-Path $AstraTools "node-$($AstraToolchain.Node.Version)"),
    (Join-Path $PSScriptRoot 'node_modules\.bin')
)
$env:PATH = ($AstraBins -join ';') + ';' + $env:PATH
$env:UV_CACHE_DIR = Join-Path $AstraTools 'uv-cache'
$env:UV_PYTHON_INSTALL_DIR = Join-Path $AstraTools 'python'
$env:UV_PYTHON = $AstraToolchain.Python
$env:UV_PYTHON_PREFERENCE = 'only-managed'
$env:UV_PROJECT_ENVIRONMENT = Join-Path $AstraWorkspace '.venv'
$env:npm_config_cache = Join-Path $AstraTools 'npm-cache'
