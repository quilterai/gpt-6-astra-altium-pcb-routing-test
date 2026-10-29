# Workstation research

Bootstrap research from 2026-09-29. These links provide background; historical
instance evidence is in [status](../notes/STATUS.md) and the
[runbook](../RUNBOOK.md). The installed computer-use plugin is the desktop
control entry point. Package availability alone does not qualify a control path.
Filenames below are relative to this `quickstart/` directory. Local `.tools/`,
`.venv/`, and `.runtime/` directories are created under its parent `astra-run/`
by setup; the original VM's runtime files are not bundled here.

| Area | Finding and setup decision | Primary source |
|---|---|---|
| Native agent | Codex supports native Windows/PowerShell. Keep the agent and desktop executor in Windows. Account/model access remains an instance check. | [Windows sandbox](https://developers.openai.com/codex/windows) |
| CLI and authentication | Install a pinned CLI locally. Device login supports remote setup; credentials stay outside the repository. | [CLI](https://developers.openai.com/codex/cli/reference), [authentication](https://developers.openai.com/codex/auth) |
| Permissions | The launcher defaults to workspace-limited writes and command approvals. Unrestricted access requires an explicit isolated-VM option. Publication still needs owner approval. | [CLI commands](https://developers.openai.com/codex/cli/reference) |
| Runtime integration | Codex offers an app-server protocol for sessions and events; its docs recommend the SDK for job automation. The supervisor is a later Windows qualification step. | [App server](https://developers.openai.com/codex/app-server) |
| uv | Standalone Windows binaries and managed Python avoid requiring system Python or winget. A standalone workspace keeps media dependencies separate. | [Installation](https://docs.astral.sh/uv/getting-started/installation/), [workspaces](https://docs.astral.sh/uv/concepts/projects/workspaces/) |
| Git LFS | Local installation configures filters/hooks. Skip-smudge plus a scoped pull avoids downloading unrelated board/toolchain assets. Existing hook conflicts should be resolved explicitly. | [LFS install](https://github.com/git-lfs/git-lfs/blob/main/docs/man/git-lfs-install.adoc) |
| Altium scripting | DelphiScript and the application APIs can inspect/modify design objects and invoke commands. Altium warns its API reference is older; command coverage is not established here. | [Scripting overview](https://www.altium.com/documentation/altium-designer/scripting/overview-setup), [running scripts](https://www.altium.com/documentation/altium-designer/scripting/running-scripts) |
| Desktop persistence | Remote-desktop minimize/disconnect can invalidate an automation desktop. Test the chosen remote-display configuration rather than assume disconnect is harmless. | [pywinauto remote execution](https://pywinauto.readthedocs.io/en/latest/remote_execution.html) |
| Input | Use the installed computer-use plugin's current skill. Screenshot capture and input were exercised on the original VM; broader coverage remains a qualification task. | [Instance status](../notes/STATUS.md) |
| Capture | Use plugin screenshots for interactive work. Select any independent recorder after testing the actual desktop and disconnect behavior. | [Runbook](../RUNBOOK.md#timelapse) |
| EC2 GPU | AWS publishes GRID drivers by instance/OS. G6 requires GRID 17.1 or later; GRID 17+ excludes Server 2019. Match the AMI and driver on the actual instance. | [AWS GRID drivers](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvidia-GRID-driver.html) |

## Pinned downloads

[toolchain.psd1](toolchain.psd1) records the Windows x64 archive URLs and publisher
SHA-256 values for uv 0.12.20, Git LFS 3.8.0, and Node.js 24.21.0. These were obtained from the
publishers' release metadata and Node's checksum list:

- [uv release](https://github.com/astral-sh/uv/releases/tag/0.12.20)
- [Git LFS release](https://github.com/git-lfs/git-lfs/releases/tag/v3.8.0)
- [Node checksums](https://nodejs.org/dist/v24.21.0/SHASUMS256.txt)
- [Managed Python build](https://github.com/astral-sh/python-build-standalone/releases/tag/20260929)

The public npm registry reported Codex CLI and SDK 0.159.0. Their lockfile includes
the Windows x64 optional executable package and integrity hashes. The bootstrap
uses `npm ci --include=optional --ignore-scripts`; the CLI package has no required
installation script. Python dependencies use the committed uv lockfile. New
versions require an explicit manifest/lock update and another bootstrap check.

## Remaining implementation questions

- Which Altium process commands expose the needed routing interactions in the
  installed version? Do not infer that a routing-options interface implements
  a complete programmatic interactive router.
- Which capture method returns correct, unobscured Altium frames on this GPU and
  desktop? Which remote connection preserves input/capture after disconnect?
- What notification destination and credentials will the user designate?
- How should the chosen account/runtime report usage and recover the exact
  session after process interruption? Test this before adding unattended restart.
