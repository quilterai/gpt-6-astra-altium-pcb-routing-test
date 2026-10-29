# Set a stopped Altium instance's saved main window to the console work area.
#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$LayoutPath
)

$ErrorActionPreference = 'Stop'
if (Get-Process X2 -ErrorAction SilentlyContinue) {
    throw 'Close Altium before changing its saved layout.'
}
$resolvedLayout = (Resolve-Path -LiteralPath $LayoutPath).Path
if ([IO.Path]::GetFileName($resolvedLayout) -cne 'UserTools.TLT') {
    throw 'Use the live UserTools.TLT written by a clean Altium shutdown.'
}
if ((Split-Path -Leaf (Split-Path -Parent $resolvedLayout)) -eq 'ExportPreferences') {
    throw 'Do not modify the exported preference copy.'
}

# Latin-1 round-trips every byte outside the ASCII fields being replaced.
$encoding = [Text.Encoding]::GetEncoding(28591)
$original = [IO.File]::ReadAllBytes($resolvedLayout)
$layout = $encoding.GetString($original)
$rectanglePattern = "(?m)^    FormNormalRect='[^'\r\n]+'\r?$"
$maximizedPattern = '(?m)^    FormMaximized=(True|False)\r?$'
if ([regex]::Matches($layout, '(?m)^  FormLayout\r?$').Count -ne 1 -or
    [regex]::Matches($layout, $rectanglePattern).Count -ne 1 -or
    [regex]::Matches($layout, $maximizedPattern).Count -ne 1) {
    throw 'Expected one main form with explicit normal bounds and maximized state.'
}

$workspace = Split-Path -Parent $PSScriptRoot
$backupDirectory = Join-Path $workspace ('.runtime/altium-layout/' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ'))
New-Item -ItemType Directory -Path $backupDirectory | Out-Null
[IO.File]::WriteAllBytes((Join-Path $backupDirectory 'UserTools.TLT'), $original)
$layout = [regex]::Replace($layout, $rectanglePattern, {
    param($match)
    "    FormNormalRect='0.00, 0.00, 100.00, 97.51'" + $(if ($match.Value.EndsWith("`r")) { "`r" })
})
$layout = [regex]::Replace($layout, $maximizedPattern, {
    param($match)
    '    FormMaximized=True' + $(if ($match.Value.EndsWith("`r")) { "`r" })
})
[IO.File]::WriteAllBytes($resolvedLayout, $encoding.GetBytes($layout))
Write-Output "Updated the 3364 x 1924 console layout. Backup: $backupDirectory"
