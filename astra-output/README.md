# Saved Astra output

This directory contains the final saved routing result from October 2, 2026.
Open [QCMI_SOM8MM.PrjPcb](QCMI_SOM8MM.PrjPcb) in Altium. The native project
files are directly in this directory; its supporting documents remain alongside
the project. Copy the whole directory before editing.

Native Altium DRC completed October 2, 2026 at 18:37:36 UTC with **3,569 violations
and zero waived**. Conservative connectivity is **1,088/1,109 required connections
(98.11%)**, with **21 named opens** and **300/321 named nets without a native open
finding**. The cached inventory reports one fewer open; SD2_DATA0 is the documented
discrepancy.

Read the [full narrative report](FINAL_ROUTING_REPORT.md),
[all native DRC findings](evidence/final-validation/DRC_APPENDIX.md), and
[native HTML report](evidence/final-validation/final-native.html).
The [audit evidence](evidence/README.md) includes exact GND/PWR layer and electrical
findings. `evidence/pre-drc-checkpoint113.PcbDoc` preserves the earlier saved board.

[The manifest](manifest.json) records the files and hashes in this public
package. [The verification record](verification.json) identifies the saved PCB
and records the original validation limits. Text reports and source copies have
identifying paths and private operational references removed. The native design
files are unchanged; report redactions do not represent routing repairs or a
new Altium validation run.

This result is not manufacturing ready. Prohibited layer routing, DDR matching,
pair coupling, width, clearance, and inherited findings remain unresolved.
Routing stopped before these repairs. Exported pad/rule/net-assignment records
are unchanged from baseline; limited original copper edits are listed in the
reports. The final save was not independently reopened. Generated project caches
and Altium autosave history files were omitted from the saved package.
