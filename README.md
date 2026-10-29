# GPT-6 Astra PCB Routing Test: 62 Hours in Altium

This repository contains the prompt, input design, and output files from
Quilter's test of OpenAI's GPT-6 Astra routing an 8-layer LPDDR4
system-on-module in Altium Designer. The full write-up is
[GPT-6 Astra in Altium: 62 Hours on an 8-Layer PCB](https://www.quilter.ai/blog/gpt-6-astra-altium-pcb-routing-test).

The board is the system-on-module from
[Project Speedrun](https://www.quilter.ai/project-speedrun), an 8-layer
high-density interconnect (HDI) board with an NXP i.MX 8M Mini BGA and LPDDR4
memory.

## What did GPT-6 Astra complete?

- **Starting point:** fixed placement and partial BGA fanout, with 252 of
  1,109 required connections complete and 857 open.
- **Result:** Astra closed 836 of the 857 open connections, bringing the board
  to 1,088 of 1,109 (98.1%). There were 21 open connections when the run stopped.
- **Rule checks:** the final native DRC reported 3,569 violations and zero
  waived findings. The layout failed the configured DDR delay, matching, and
  uncoupled-length rules, and it had tracks on ground and power layers.
- **Time:** about 62 elapsed hours, from September 30 to October 2, 2026,
  after about 4 hours of tool building.
- **Reported cost:** about $2,900 in API usage: $400 for setup and tool
  building and $2,500 for the run.

The [final report](astra-output/FINAL_ROUTING_REPORT.md) explains the
connectivity measure, native DRC findings, and remaining electrical work.
The connectivity percentage does not measure electrical or manufacturing
acceptance.

## How was the test run?

Astra worked from the Codex desktop app on a Windows virtual machine on
Amazon EC2. It operated Altium Designer through computer-use tools and scripts
it wrote itself. Altium's Situs autorouter and Auto Route commands were
prohibited. Read the [routing prompt](astra-run/PROMPT.md)
for the run's instructions and constraints. It starts from the unchanged
input files. This public edition adapts paths and removes private operational
details; it is not a verbatim transcript.

The run notes describe supporting agents assigned to bounded geometry and
electrical reviews and monitoring, with the main controller as the sole live
Altium writer. This was not a controlled experiment isolating each agent's
contribution.

The maintained tools include post-run portability and safety changes. They are
distinct from the historical source copies in the evidence, and their current
versions were not all used during the test. Text evidence has identifying paths
removed; the native design files remain unchanged. Current Windows/Altium runtime
behavior is not established by the offline checks.

Patrick Poage, Senior Technical Program Manager at Quilter, ran the test.

## What is in this repository?

| Folder | Contents |
| --- | --- |
| [speedrun-input/](speedrun-input/) | The input Altium project, with fixed placement and partial BGA fanout |
| [astra-output/](astra-output/) | The final Altium project, final report, and saved validation evidence |
| [astra-run/](astra-run/) | The prompt, working notes, Altium scripts, and Windows setup and recording tools |

Open
[the input project](speedrun-input/QCMI_SOM8MM.PrjPcb) or
[the final project](astra-output/QCMI_SOM8MM.PrjPcb) in Altium Designer.
Keep each project with its neighboring schematics, libraries, and output jobs.
Use a separate copy before editing a design. The 24 included input files retain
their original bytes and hashes; three historical autosave backups are omitted,
not substituted for changed input files. The
[input manifest](astra-run/notes/input-manifest.json) lists both sets.

## Get the files

Install Git and [Git LFS](https://git-lfs.com/) before cloning:

```sh
git clone https://github.com/quilterai/gpt-6-astra-altium-pcb-routing-test.git
cd gpt-6-astra-altium-pcb-routing-test
git lfs install --local
git lfs pull
```

Files at least 10 MiB use Git LFS and are listed explicitly in
[.gitattributes](.gitattributes). Smaller files, including scripts and reports,
use ordinary Git. `git lfs ls-files` lists the LFS files. If a downloaded
design contains a short `version https://git-lfs.github.com/spec/v1` text
record, run `git lfs pull` to get its contents.

Opening the supplied projects does not require the agent's toolchain. To
inspect or run the Windows tools, start with the
[run workspace](astra-run/README.md) and
[quickstart guide](astra-run/quickstart/README.md).

## Known limitations

- This is one run on one board. It is not a benchmark of GPT-6 Astra.
- The layout was not cleaned up, fabricated, or tested. Turning it into a
  working board was outside the test's scope.
- The final saved board was not independently closed and reopened after its
  final save. The report records the saved-file identity and validation limits.
- The run used the input file's design rules, which have small differences
  from the rules in Quilter's Project Speedrun job. The write-up explains the
  difference.

## Related reading

- [GPT-6 Astra in Altium: 62 Hours on an 8-Layer PCB](https://www.quilter.ai/blog/gpt-6-astra-altium-pcb-routing-test)
  (Part 3, the write-up of this test)
- [From Freerouting to DRC: Eight Public GPT-6 Astra PCB Tests](https://www.quilter.ai/blog/gpt-6-astra-pcb-test-results)
  (Part 2)
- [Can LLMs Design PCBs? GPT-6 Astra and AI PCB Layout Automation](https://www.quilter.ai/blog/llm-pcb-layout-gpt-6-astra)
  (Part 1)
- [Project Speedrun design files](https://www.quilter.ai/project-speedrun/download)

## License

The files use three licenses, with the scope defined in [LICENSE](LICENSE):

- **Prompt, final report, documentation, and exported validation evidence:**
  [CC BY 4.0](LICENSES/CC-BY-4.0.txt).
- **Source scripts and software configuration:**
  [MIT License](LICENSES/MIT.txt), including archived helper source files.
- **Altium designs and supplied engineering reference files in
  `speedrun-input/` and `astra-output/`:**
  [CC BY-NC 4.0](LICENSES/CC-BY-NC-4.0.txt), which allows reuse with credit for
  noncommercial purposes.

## How to cite

Poage, Patrick, and Iryna Zhuravel. "GPT-6 Astra in Altium: 62 Hours on an
8-Layer PCB." Quilter, October 29, 2026.
[Read the article](https://www.quilter.ai/blog/gpt-6-astra-altium-pcb-routing-test).
Machine-readable citation metadata is in [CITATION.cff](CITATION.cff).

## About Quilter

[Quilter](https://www.quilter.ai) builds physics-driven AI for PCB layout
automation and works with Altium, Cadence, Siemens, and KiCad designs.
