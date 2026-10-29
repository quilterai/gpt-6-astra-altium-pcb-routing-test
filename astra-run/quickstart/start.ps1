# Start the workstation-qualification task in the dedicated Windows VM.
#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$AllowUnrestrictedIsolatedVm
)

. (Join-Path $PSScriptRoot 'enter.ps1')
$null = & git.exe -C $PSScriptRoot rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw 'Start requires a repository checkout.'
}
if (-not (Test-Path -LiteralPath (Join-Path $AstraWorkspace '.runtime\bootstrap.json'))) {
    throw 'Run bootstrap.ps1 successfully before starting Codex.'
}
$Prompt = @'
Start with the unchanged input files in ../speedrun-input/; all paths here are
relative to the astra-run/ workspace. The Altium project is
../speedrun-input/QCMI_SOM8MM.PrjPcb and the PCB is
../speedrun-input/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc.
Verify the included files against notes/input-manifest.json. Preserve the input
bytes and use a complete copy under work/<board>/ for any later design edits.

Read ../AGENTS.md, README.md, RUNBOOK.md, and PROMPT.md. Qualify this Windows
workstation and its current desktop tools before attempting Altium control.
Historical notes describe the original experiment, not this machine's live state
or permission to resume that run. Record current qualification results under
runs/<run-id>/. Board routing requires a new explicit user instruction with its
input project, objective, and constraints; this setup task does not start it.
'@
$Sandbox = 'workspace-write'
$Approval = 'on-request'
if ($AllowUnrestrictedIsolatedVm) {
    Write-Warning 'Unrestricted mode disables sandbox and command approvals. Use only in an isolated VM you control; this script does not verify isolation.'
    $Sandbox = 'danger-full-access'
    $Approval = 'never'
}
& (Join-Path $AstraBins[2] 'node.exe') `
    (Join-Path $PSScriptRoot 'node_modules\@openai\codex\bin\codex.js') `
    --cd $AstraWorkspace --model gpt-6-astra `
    --config "model_reasoning_effort='max'" `
    --sandbox $Sandbox --ask-for-approval $Approval $Prompt
if ($LASTEXITCODE -ne 0) {
    throw "Codex exited with code $LASTEXITCODE. Inspect the session before resuming."
}
