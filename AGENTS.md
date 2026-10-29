# Repository guidance

- Publish repository content, LFS objects, and releases only with the repository
  owner's express approval for that publication.
- Preserve every file in `speedrun-input/` and the saved native Altium designs.
  Run experiments on copies.
- Keep credentials and authentication data out of tracked files and command
  output. Review the proposed export, including its history, before publication.
- The top-level folders are `speedrun-input/`, `astra-output/`, and `astra-run/`.
  Maintained tools are in `astra-run/`. Public evidence copies redact local paths
  and internal operations; preserve their engineering findings and native hashes.
- Describe supporting-agent roles and later tool adaptations accurately. Do not
  infer model identities from informal names in historical notes.
- Use LFS only for files at least 10 MiB. Add explicit paths to `.gitattributes`
  when adding large files; preserve the bytes of saved design files.
- Run the checks documented beside the tools. Distinguish local syntax and unit
  checks from Windows/Altium runtime verification.
- Do not add test files or test cases beyond those in the source branch.
