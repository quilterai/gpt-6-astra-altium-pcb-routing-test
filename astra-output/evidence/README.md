# Published validation evidence

These public copies contain reports, inventories, audit outputs, and helper
source from the 2026 routing experiment. Workstation and private repository
paths use the neutral `recorded-workspace` prefix. The remaining subpaths describe
the original working copies and run directories, not the location of the input
project in this repository. Some intermediate checkpoints are not included.

The HTML reports omit local file links and Altium desktop action links. Their
visible measurements and findings are unchanged. Numerical JSON and inventory
values, timestamps, and saved design hashes are preserved. Original reports
remain in the private experiment record.

Hashes inside historical records identify the original recorded artifacts.
The current [output manifest](../manifest.json) identifies the public copies,
whose bytes can differ because of these redactions.

The maintained tools and current instructions are in
[astra-run/scripts](../../astra-run/scripts/README.md). Source files captured here
are historical copies with redacted paths; use the maintained tools for new
analysis. Private package and dashboard publication scripts are omitted. The
[output overview](../README.md) identifies the final project's current location
and its validation limits.

The archived [geometry audit](electrical/geometry_review.py) uses the public
[`olefile` package](https://olefile.readthedocs.io/en/latest/olefile.html) for binary
reads. It also requires the original run's `Components6.json` and intermediate
directory layout, which are not included in this package.
