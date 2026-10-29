# Preserved routing input

[The original input](../../speedrun-input/) contains the PCB, project, ten
schematics, libraries, output jobs, layer-stack report, and length-tuning reports.
All 18 document paths declared by the project resolve inside its directory.

The [SHA-256 manifest](input-manifest.json) records the 24 included source files
and their original hashes from September 30, 2026. It lists three omitted
`History/` records separately. The clone contains the 24 project source files,
not those historical backups.

Git LFS tracking follows the repository-root `.gitattributes`, rather than a rule
for the whole input directory. Run `git lfs pull` after cloning. Before editing,
copy the whole input directory to a new local `astra-run/work/<board>/` or
`astra-run/trials/<experiment>/` directory and compare file hashes. Preserve the
published input files unchanged.
