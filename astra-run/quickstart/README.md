# Windows quickstart

Setup scripts and dependency manifests for an Altium Windows VM. The workspace
is the parent `astra-run/` directory. See [status](../notes/STATUS.md) for the
original run's installation and desktop evidence; bootstrap success alone does
not qualify unattended operation on another VM.

## Existing VM

Use the desktop app with computer-use tools supported in your environment. Read
[the runbook](../RUNBOOK.md) and verify the unchanged input files before opening
a complete working copy of the input project.
The optional CLI launcher needs working computer-use tools before controlling
Altium. Keep one agent in control of the desktop.

From `astra-run/`, load the isolated tools in a PowerShell process:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
. .\quickstart\enter.ps1
uv run --locked --project .\quickstart python --version
```

`enter.ps1` changes the current process's environment; it does not install tools
or change the working directory. It points to `.tools/` and `.venv/` in
`astra-run/`; Node packages live in `quickstart/node_modules/`. Bootstrap creates
those directories and `.runtime/` locally. If they are absent, complete the
[fresh VM setup](#fresh-vm) first. They are ignored runtime artifacts, not
missing checked-in files.
Pass `--project .\quickstart` to uv from `astra-run/`. Run Python through
`uv run --locked`.

For work without an attached RDP client, read [persistent desktop setup](DESKTOP.md).
It records the original console display, disconnect recovery task, and DPI
checks. Qualify the current VM's display and capture behavior separately.

## Fresh VM

Use native x64 Windows, Git for Windows, and the interactive user account that
will run Altium. The user supplies Altium installation and license access.
Credentials stay outside Git.

Use the repository URL and branch you have permission to read. A short NTFS
checkout path avoids long-path problems:

```powershell
$AstraRepository = '<repository URL>'
$AstraBranch = '<branch>'
$env:GIT_LFS_SKIP_SMUDGE = '1'
git -c core.longpaths=true clone --single-branch --branch $AstraBranch $AstraRepository astra-routing-test
if ($LASTEXITCODE -ne 0) { throw 'Clone failed' }
Set-Location astra-routing-test\astra-run
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\quickstart\bootstrap.ps1
if (-not $?) { throw 'Bootstrap failed; inspect the error before continuing' }
. .\quickstart\enter.ps1
```

Bootstrap checks the standalone repository layout and the `origin` download
remote. It configures repository-local LFS filters, disables automatic smudge
downloads, fetches LFS objects under `speedrun-input/` and `astra-output/`,
enables long paths, and sets `push.default=nothing`. The repository's
`.gitattributes` selects which large files use LFS. Existing hook conflicts and
failed commands stop setup. Bootstrap does not push commits or upload files.

| Component | Purpose |
|---|---|
| uv and managed Python 3.13 | Isolated media helpers |
| Pillow and imageio-ffmpeg | Image processing and local video encoding |
| Git LFS | Downloading large project artifacts |
| Node.js, Codex CLI, and SDK | Optional local CLI tools |

Desktop control comes from the installed computer-use plugin. Altium scripts
support inspection and edits that need application APIs.

[toolchain.psd1](toolchain.psd1), [uv.lock](uv.lock), and
[package-lock.json](package-lock.json) in `quickstart/` pin downloads and dependencies.
Bootstrap validates archive hashes, executable versions, Python imports, FFmpeg,
and dependency consistency. It removes the previous `.runtime/bootstrap.json`
receipt before installing and writes a new receipt after its checks pass.
Stop running tools before reinstalling their binaries.

## Optional CLI session

From `astra-run/`, after loading `quickstart/enter.ps1`:

```powershell
codex.cmd login --device-auth
if ($LASTEXITCODE -ne 0) { throw 'Codex sign-in failed' }
codex.cmd login status
if ($LASTEXITCODE -ne 0) { throw 'Codex is not signed in' }
.\quickstart\start.ps1
```

The launcher requests GPT-6 Astra at Max effort with the `workspace-write`
sandbox and `on-request` command approvals. It starts in `astra-run/` and first
identifies the unchanged `../speedrun-input/` project, PCB, and input manifest.
It then qualifies the current workstation. Board routing requires a new explicit
instruction; [PROMPT.md](../PROMPT.md) contains the public routing instructions.
Historical status notes do not authorize resuming the original run.

For an isolated VM that you control, this explicit option restores unrestricted
local access and disables command approval prompts:

```powershell
.\quickstart\start.ps1 -AllowUnrestrictedIsolatedVm
```

The switch is an operator assertion, not an isolation check. It does not grant
publication permission. Desktop tools may require permissions beyond the default
sandbox; review each request or prepare the isolated VM before opting in.
See the [public CLI reference](https://developers.openai.com/codex/cli/reference)
for the permission flags. To resume a CLI session, use `codex.cmd resume` and
verify the tools, model, document state, and permissions before continuing.

## Recording

The [recorder guide](../recording/README.md) covers independent window capture,
start and stop commands, recovery, and local timelapse files. Run the recorder
from the interactive Windows session that owns Altium. Inspect a fresh frame
after a display or session change.

## Validation

Run from `astra-run/` after loading `quickstart/enter.ps1` on Windows:

```powershell
uv lock --check --project .\quickstart
uv sync --locked --project .\quickstart
uv pip check --project .\quickstart --python .\.venv\Scripts\python.exe
npm.cmd ci --dry-run --ignore-scripts --no-audit --no-fund --prefix .\quickstart
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\quickstart\bootstrap.Tests.ps1
```

The PowerShell tests use temporary archives and cover hashing, extraction,
repeat installation, and native command failures. They do not run bootstrap or
download tools. Use a PowerShell parser to check the other scripts without
launching an agent or installing workstation software.

The media tests also run on macOS and Linux. From the repository root:

```sh
uv lock --check --project astra-run/quickstart
uv run --locked --project astra-run/quickstart python -m unittest discover -s astra-run/recording -p 'test_*.py' -v
uv run --locked --project astra-run/quickstart python -m unittest discover -s astra-run/scripts -p 'test_*.py' -v
```

The platform marker installs `windows-capture` on Windows only. Native capture
and file-lock tests report explicit skips on other platforms. Live capture,
Altium control, and desktop recovery still require Windows qualification.
Research references are in [RESEARCH.md](RESEARCH.md).
