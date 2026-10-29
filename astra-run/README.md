# Astra run files

This directory contains the routing prompt, experiment notes, and tools from
the QCMI_SOM8MM Altium test. Read the [repository overview](../README.md) for
results and limitations. The test stopped with 21 open connections and unresolved
electrical and design-rule issues.

| Path | Contents |
|---|---|
| [Routing prompt](PROMPT.md) | Public instructions starting from the unchanged input files |
| [Final report](../astra-output/FINAL_ROUTING_REPORT.md) | Findings, remaining work, and validation limits |
| [Notes](notes/) | Historical status, decisions, constraints, and script qualification |
| [Scripts](scripts/README.md) | Altium DelphiScript helpers and offline comparison tools |
| [Quickstart](quickstart/README.md) | Windows toolchain and desktop setup |
| [Recording](recording/README.md) | Independent Altium-window capture and local timelapse |
| [Runbook](RUNBOOK.md) | Project copying, Altium control, checkpoints, and recovery |
| [Original input](../speedrun-input/) | Native Altium project supplied to the test |
| [Saved output](../astra-output/) | Native final project, report, and preserved audit evidence |

Open [the input project](../speedrun-input/QCMI_SOM8MM.PrjPcb) or
[the final project](../astra-output/QCMI_SOM8MM.PrjPcb) in Altium. Copy either
whole directory into a new local `astra-run/work/` or `astra-run/trials/`
directory before editing.
Preserve the input and output designs as recorded artifacts. The 24 included
input files retain their original bytes and hashes; see the
[input manifest](notes/input-manifest.json).

The [prompt](PROMPT.md) is an edited public version of the routing instructions,
not a verbatim transcript. The run notes describe supporting agents assigned to
bounded geometry and electrical reviews and monitoring, with the main controller
as the sole live Altium writer. The record does not isolate each agent's
contribution.

The maintained tools include post-run path portability and launch-safety changes.
Historical source copies under [the output evidence](../astra-output/evidence/)
record the earlier helpers with identifying paths removed. Neither those records
nor local unit and syntax checks establish current Windows/Altium runtime behavior.

The Windows tools use `astra-run/` as their workspace. Unless a command states
otherwise, run it from that directory. Bootstrap creates the local `.tools/`,
`.venv/`, `.runtime/`, and `quickstart/node_modules/` tool directories. Operators
create working copies under `work/` or `trials/`; tools and operators create
`runs/` and `results/` as needed. These ignored runtime directories and the
historical captures/checkpoints they held are not bundled in the repository.
The isolated Python environment is defined in
[quickstart/pyproject.toml](quickstart/pyproject.toml).
Follow each tool's README for its commands and validation requirements.

Git LFS tracking is defined by the repository-root `.gitattributes`; only files
at least 10 MiB use LFS. Run `git lfs install` and `git lfs pull` from the repository
root after cloning. Small source files, reports, and supporting design documents
use ordinary Git.

The notes describe the original 2026 test environment, including tools and
intermediate checkpoints that are outside this repository. They provide a
historical record, not evidence that an unattended Altium session is running.
See [AGENTS.md](../AGENTS.md) for the current contribution and publication rules.
