# Full-board routing status

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

<!-- FINAL_STOP_STATUS -->
## Final stopped result — October 2, 2026

**1,088 / 1,109 required connections (98.11%); 21 named opens; 300 / 321 named nets
without a native open (93.46%).** Native DRC completed at 18:37:36 UTC with 3,569
violations and zero waived. Cached inventory reports 20 edges; the additional native
open is SD2_DATA0. The corrected result takes precedence over earlier provisional
counts.

The saved final PCB is
[astra-output/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc](../../astra-output/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc);
SHA-256 `ff874ed815ac5bb9d63cff1cab7cc17cf9abd1326e242108f2979e545f9b1e3d`. Rules
and pad/net-assignment records are unchanged. No routing was performed after the
stop request.

[Read the extensive final report](FINAL_ROUTING_REPORT.md), [all 3,569 native
findings](../../astra-output/evidence/final-validation/DRC_APPENDIX.md), and the
[recording limitations](MONITORING_FULL_RUN.md). Layer audit: 1,555 GND-layer
segments and 1,058 controlled-impedance PWR-layer segments. DDR timing and
electrical acceptance fail.

The recorder stopped intentionally at 18:55:27 UTC after the 18:52:02 final board capture. Raw recordings and monitoring archives are outside this public package. All earlier status paragraphs below are historical. The original run manifest
covered 27 files, including three History backups; the public input contains
the same 24 project source files without those backups.
<!-- END_FINAL_STOP_STATUS -->



Updated October 2, 2026 at 17:13 UTC.

**1,088 / 1,109 required connections routed (98.11%), 21 remaining.** Saved
checkpoint112 contains 300 of 321 named nets complete, 9,638 tracks, and 991 vias.

Batch634 completes PCIE_TX_N. Native readback matches all six run-added removals, 49
additions, and three vias. Every earlier connection remains complete. The PCB was
saved at 2026-10-02T17:04:15.906000+00:00; SHA-256
`10312ea517b193bd2aa60ae6d278f5c1ec92a16d67ae73fc00b713928abdfb4f`. All 169 project
files were verified. Error markers were reset before saving. All 27 original input
files remain unchanged. Final layer assignment, DDR timing, DRC, and reopen remain
pending.

**1,087 / 1,109 required connections routed (98.02%), 22 remaining.** Saved
checkpoint111 contains 299 of 321 named nets complete, 9,595 tracks, and 988 vias.

Native628 and633 extend the RXD3 source escape. Both terminal audits preserve all
affected pad and via contacts. The bounded inherited RXD3 tip replacement is
documented in `RXD3_NATIVE_633.md`. Altium's license was recovered before saving.
The PCB was saved at 2026-10-02T16:25:53.115000+00:00; SHA-256
`ff257c9ec2d543c11515bf7cf9ac493c64dc30b9d8dbb124dc963f75daac6631`. All 168 project
files were verified. Batch634 is applying the reviewed PCIE_TX_N connection; its
gain is not yet counted. Final layer assignment, DDR timing, DRC, and reopen remain
pending.

**1,087 / 1,109 required connections routed (98.02%), 22 remaining.** Saved
checkpoint110 contains 299 of 321 named nets complete, 9,554 tracks, and 988 vias.

Checkpoints109 and110 complete SAI1_RXFS and SAI1_RXD4. Exact native comparisons
match every requested track and via and preserve all earlier connections. The RXFS
batch replaces one run-added GPIO1_IO01 track with a connected detour. RXD4 uses
unchanged native width limits on L2, L3, L7, and Bottom. The PCB was saved at
2026-10-02T11:27:45.580000+00:00; SHA-256
9367142656d8405dd67600ba9e28a7b720a397b8a8576dbf0aaf62741124c08a. All 165 project
files were verified. Error markers were reset before saving. All 27 original input
files remain unchanged. Final GND/PWR layer assignment, DDR timing, DRC, and reopen
remain pending.

**1,085 / 1,109 required connections routed (97.84%), 24 remaining.** Saved
checkpoint108 contains 297 of 321 named nets complete, 9,492 tracks, and 981 vias.

Batch621 completes NetR7_2. The exact native comparison and repour preserve every
earlier connection. Eleven run-added tracks are replaced to retain neighboring DDR,
UART, and VDDA connections. The source includes 13.22 mil of 3 mil Top routing below
the existing 4.1 mil width rule; repair remains pending. Native617 and619 create the
RXFS and RXD4 source escapes and preserve all affected terminals, original copper,
pads, rules, and net assignments. Checkpoint108 was saved at
2026-10-02T11:11:00.599000+00:00; SHA-256
`a56e9415f3aa5795dceb4ba9637a77a0cee2a46a39f75b43e9685fb6cbc0d67f`. All 163 project
files were verified. Final layer assignment, DDR timing, DRC, and reopen remain
pending.

**1,084 / 1,109 required connections routed (97.75%), 25 remaining.** Saved
checkpoint107 contains 296 of 321 named nets complete, 9,393 tracks, and 978 vias.

Checkpoint107 completes SD3_DATA2. Batch608 matches its exact copper requests and
preserves every neighboring net. Native single-net cleanup in batch615 closes the
stale DATA2 airwire by splitting and joining collinear segments; the spatial copper
footprint and all other connection records remain unchanged. The PCB was saved at
2026-10-02T10:16:42.944000+00:00; SHA-256
`2c35010129bbce0167a69108caa322c8762ec55b12347f9c7ff269ddecf883c6`. All 161 project
files were verified. Error markers were reset before saving. All 27 original input
files remain unchanged. Native617 adds the RXFS source escape with no
touched-terminal loss. Native619 adds the RXD4 source escape; its completed audit
preserves all affected terminals. Final layer assignment, DDR timing, DRC, and final
reopen remain pending.

**1,083 / 1,109 required connections routed (97.66%), 26 remaining.** Saved
checkpoint106 contains 295 of 321 named nets complete, 9,316 tracks, and 976 vias.

Checkpoint106 completes SAI1_TXD5 and SAI1_RXD6. Aggregate607 checks every scripted
addition and the terminal proofs for native Push edits; all earlier connections and
inherited copper remain intact. Batch604 restores the GND and VDDA contacts exposed
by repour and a moved via. The PCB was saved at 2026-10-02T09:30:21.598000+00:00;
SHA-256 `f9cd0866f66336d5903cc4bea628d6166f84c57c9d49729512f1fe5e90c97342`. All 159
project files were verified. Error markers were reset before saving. SD3_DATA2 is
next; final layer assignment, DDR timing, DRC, and reopen remain pending.

All 27 original input files remain unchanged.

Batch592 completes SD3_DATA1; batch594 restores the two VDD_3V3 connections exposed
by repour. Aggregate595 verifies every requested track and via and preserves all
earlier connections, pads, rules, and net assignments. Checkpoint105 was saved at
2026-10-02T08:29:13.448000+00:00; SHA-256
`93e7574fe615463b70e3eab0de78995377ef10183a4ce8bdf216e8855a929b31`. All 157 project
files were verified. Error markers were reset before saving. The supply repair
includes 332.5 mil of 3 mil L6 copper within the native width rule; current capacity
remains unresolved. SD3_DATA2 and remaining source escapes are next. Final layer
assignment, DDR timing, DRC, and reopen remain pending.

Batch589 completes SAI1_RXD0 and preserves every neighboring connection. Both native
passes match their exact requests; pads, rules, and net assignments remain
unchanged. Its inherited RXD1 antenna trim is documented in
`SAI1_RXD0_ACCESS_589.md`. Checkpoint104 was saved at
2026-10-02T07:51:36.398000+00:00; SHA-256
`3b08df26e4d0a65e934dd4360dfd10dbc279e9e94021bca8566d06b421398ef9`. All 156 project
files were verified. Error markers were reset before saving. Checkpoint103 retains
the native TXD5 source escape, with no complete-net gain and a 2.79 mil clearance
debt documented in `TXD5_NATIVE_591.md`. Batch592 SD3_DATA1 is next. Final layer
assignment, current capacity, DDR timing, DRC, and reopen remain pending.

Batch588 completes ENET_TD3 with 71 added tracks, three run-added removals, and
three vias. Native comparison verifies every requested primitive and preserves all
other net connections. Checkpoint102 was saved at 2026-10-02T06:59:03.928000+00:00;
SHA-256 `8e1e057d4f54664d6386fdd08256f71e45739ebfe736f7407b1a6aec46255e65`. All 154
project files were verified. Error markers were reset before saving. The 4,064 mil
TD3 L7 trunk is temporary GND-layer routing; timing, reference continuity, and
source via fabrication remain unresolved. Proposal587 remains unapplied because its
TXFS replacement is incomplete. Planners589 and590 continue RXD0 and NetR7_2
connectivity.

All 27 original input files remain unchanged.

Batch586 completes ENET_TD2 and preserves all six affected neighboring nets. Its
exact native comparison accepts one inherited ENET_TX_CTL antenna trim documented in
`ENET_TD2_ACCESS_586.md`. Checkpoint101 was saved at
2026-10-02T06:34:34.693000+00:00; SHA-256
`fca4432fe0e27705b285773c6b6d663f32fe2b5f6d14d55275f58489628ea1be`. All 153 project
files were verified. Error markers were reset before saving. Batch588 is in a
two-pass native TD3 trial; it is not yet accepted. RXD2 layer alternatives have
fresh native width receipts for planner587. Final layer cleanup, DDR matching, and
DRC remain pending.

Batch582 completes BT_WAKE_DEV. All three native stages preserve Ground
connectivity, and the exact final request and all-net comparison pass. Its two
inherited Ground tracks and one inherited Ground via are the documented local
exception in `BT_ACCESS_582.md`. Checkpoint100 was saved at
2026-10-02T06:17:17.564000+00:00; SHA-256
`463f69cd164075de91041dec42c4ff29b97a64640adb901ae06e4932f9277d4b`. All 152 project
files were verified. Error markers were reset before saving. Batch586's complete TD2
proposal passed independent geometry review and is next for native insertion. Final
GND/PWR layer cleanup, DDR grouping and delay matching, capacity, reference
coverage, and DRC remain pending.

All 27 original input files remain unchanged. Proposal579 is unapplied: its C9
ground connection requires a replacement before a native trial. Proposal582 has a
bounded BT access alternative with explicit ground preservation.

Batch566 completes ENET_RD2 with 35 additions, two run-added removals, and three
vias. Checkpoint097 was saved at 2026-10-02T04:34:50.699000+00:00; SHA-256
`4bcd3c967897976686cd5c22906656f2a182ef67dadbfeb5557fe5058f5c1fd1`. All 149 project
files were verified.

Batch563 completes DSI_D0_P; batch573 restores the VDD_3V3 branch exposed by repour.
Aggregate576 matches every requested track and via and preserves all earlier
connections. Checkpoint098 was saved at 2026-10-02T04:58:56.593000+00:00; SHA-256
`b0d401f98833fe3839cf081dea0ee6f38f2b7d42b43d4853068aa269afc4886e`. All 150 project
files were verified. Error markers were reset before saving. The 3 mil supply repair
is within the native width rule; current capacity remains unresolved.

Batch571 completes ENET_TD1. Batch580's short Top link does not restore the VDD_3V3
connection exposed by repour; batch583 restores it with 38 L5 tracks between
existing vias. Aggregate584 matches every requested track and via and preserves all
earlier connections. Checkpoint099 was saved at 2026-10-02T05:32:03.489000+00:00;
SHA-256 `e911b4435620fffbdf7d11a394fced23777ccf141c196c5f61a0f2d4b8d74d5e`. All 151
project files were verified. Error markers were reset before saving. Supply current
capacity remains unresolved. Eleven reconciliation tests pass. Planner579's
SD3_DATA1 candidate requires an SD2_WP repair before application; planner582
prepares BT access. Incomplete574/575/577/578 proposals remain unapplied.

Batch557 completes SAI1_TXD7 with 32 additions, two run-added removals, and two
vias. Checkpoint094 was saved at 2026-10-02T03:37:05.847000+00:00; SHA-256
`b177f93c478f6b8f44a9c7300ee9b2bf3967f3ecd3364fb1378c49956529def8`. All 146 project
files were verified.

Batch559 completes CSI_CK_P and batch564 restores the VDD_3V3 branch opened by
repour. Aggregate565 matches the exact requests and preserves every earlier
connection, inherited copper, pads, rules, and net assignments. Checkpoint095 was
saved at 2026-10-02T03:58:45.044000+00:00; SHA-256
`89b5d9fb37ad4bc5a8d7d635427cc2326546ad7b3d9fe24d7bc2827f75d7963c`. All 147 project
files were verified. The supply repair uses 571.659 mil of 10 mil Top copper;
current capacity remains pending.

Batch562 completes CLKIN2 with 84 additions, four run-added removals, and three
vias. Both passes match their exact requests, with no all-net connectivity
regression. Checkpoint096 was saved at 2026-10-02T04:20:16.289000+00:00; SHA-256
`eefa35403b3cfef103b99e9f04a64e325589640417cea21588b664f0d1ab85d9`. All 148 project
files were verified. Error markers were reset at 04:20 UTC. Batch566 ENET_RD2 is
running; batch563 DSI_D0_P follows in two parts. Its native width queries are
verified. Planners571/572 search independent residual nets. At 04:29 UTC the
recorder heartbeat and captures were current, with no errors and 23.15 GiB free on
C:.

Batch548 completes DRAMB_DATA5; batch550 restores the NVCC_DRAM_1V1 connection
opened by repour. Aggregate553 matches the exact requests and preserves every
earlier net connection. Checkpoint091 was saved at 2026-10-02T02:26:27.506000+00:00,
SHA-256 `55f854cb2726162cf2f1da628b0a8dd2ad6a55e89474eac4335ac393a700754a`; all 143
project files were hash-verified. Error markers were reset at 02:25 UTC.

Batch552 completes WL_WAKE_HOST with 110 additions, 16 exact run-added removals, two
new vias, and one guarded BT_WAKE_HOST via move. A file-lock interruption stopped
its second pass after 15 tracks; a native export proved the exact applied prefix
before the remaining 31 tracks and two vias were added. Whole-batch reconciliation
passes with no connectivity regressions. Checkpoint092 was saved at
2026-10-02T02:45:00.085000+00:00, SHA-256
`5c74f98e79e9d3b8e688ffe45764701b24e9afba30950f8908ff2c62387015c8`; all 144 project
files were verified.

Batch554 completes SD1_DATA3 with 140 additions, eight run-added removals, and six
vias. All three passes and the whole batch match the exact native geometry;
neighboring connections remain complete. Checkpoint093 was saved at
2026-10-02T03:28:56.793000+00:00, SHA-256
`635cfbbb1a3b919c059272107dd83dd48f87244938670a39995b58fb90e01663`; all 145 project
files were verified. Incomplete555/556/558/560/567 proposals remain unapplied.
Trial545 Top-only ActiveRoute made no geometry change.

After 100% connectivity, the required next phase removes routing from GND layers,
moves controlled-impedance routing off PWR layers, and verifies DDR grouping, layer
assignment, and delay matching against device requirements and the applicable DDR
standard. Current layer use is provisional and does not satisfy this final gate.
Final DRC and reopen remain pending; component positions and rules remain unchanged.

Checkpoint085 completes both PCIe clock nets and SAI2_RXFS. Batches528 and532
restore GND and VDD_1V8 connections exposed by repour; aggregate529 passes with no
connectivity regressions. Checkpoint086 completes SD2_NRST and restores the exposed
NVCC_SNVS_1V8 edge with two 20 mil L5 segments. Aggregate537 matches the exact
requests with no regressions. Checkpoint087 completes ECSPI2_MISO and preserves all
seven affected neighboring nets. Its 42 additions, nine run-added removals, and two
vias match the native inventory exactly. The PCB was saved at
2026-10-02T01:00:43.307000+00:00, SHA-256
`2c96b2b1d2a560c1fd845b59dee52b033c5a49d9e7c246cab00a64a8876f426e`; all 138 project
files were copied and hash-verified.

Agents continue the remaining crowded fanouts. Final DRC and reopen remain pending;
component positions and rules remain unchanged. Error markers were reset at 01:05
UTC.

Checkpoint084 completes USB1_DN, SAI1_TXD4, and SAI1_TXD2. Batch517 restores the
VDD_3V3 section disconnected by batch514's repour. The cumulative exact comparison
preserves every earlier net's connectivity, inherited copper, pads, rules, and net
assignments. The PCB was saved at 2026-10-01T23:03:18.033000+00:00, SHA-256
`235e33358522f6f9f0bc648e6f2f8251d7bb3a4943fe57369e7306f294f44526`; all 132 project
files were copied and hash-verified. The VDD_3V3 repair contains 863.138 mil of 20
mil copper; capacity remains unresolved.

The disk audit found repeated immutable Altium History and library copies, rather
than growing video copies. On October 1 at 23:09 UTC, 2,834 byte-identical files
were shared through NTFS hard links, recovering 12.39 GiB and increasing free space
from 13.64 to 26.03 GiB. Every saved path and file hash remains intact. The copy
helper reuses verified saved History and library bytes for future checkpoints while
copying working design documents independently. All four storage tests passed.
Captures, videos, original inputs, and the working project were preserved.

Checkpoint083 completes DRAMB_DATA11 and preserves all seven affected neighboring
nets. Its 150 additions, nine run-added removals, and three vias match the native
inventory exactly. Pads, rules, net assignments, and inherited copper are unchanged
by this batch. The PCB was saved at 2026-10-01T22:34:07.255000+00:00, SHA-256
`2711fba9c36580be796c2239344cc0e0a01fd70786136be50e253bd74a4c7bc0`; all 131 project
files were copied and hash-verified. The SOC replacement includes 130.907 mil below
10 mil width; current capacity remains pending. Long UART and SD2 replacements also
need timing and reference review.

Checkpoints 077 through 082 complete GPIO1_IO09, DRAMB_DATA0, CLKOUT2, DRAMB_DATA1,
DRAMA_DATA3, and CLKOUT1. Every native request matches its readback, and all other
nets preserve their earlier connectivity after repour. These batches preserve
inherited copper, pads, rules, and net assignments. DRAMB_DATA11 is prepared next.
The DATA0 SOC detour includes 110 mil of 3.2 mil copper whose capacity remains
unresolved. DATA1's B0-strobe replacements preserve connectivity but have a sampled
maximum companion gap of 25.0601 mil versus the fixed 4.8 mil native rule. DATA3's
CPU via is 68.7313 mil from the nearest modeled ground via; reference continuity
needs review.

Checkpoint082 was saved at 2026-10-01T22:14:26.842000+00:00; PCB SHA-256
`a4ac7707910d4b938ae53857375eba88039c6ce4023c9ee61ae2970b025e7619`. All 130 project
files were copied and hash-verified. Error markers were reset at 21:53 UTC. Reopen
and final DRC remain pending. Included DRC reports predate this board. Timing,
impedance, return paths, supply capacity, via fill and cap, and earlier electrical
findings remain unresolved.

The recorder resumed the same run at 20:14 UTC after an MP4 replacement error. All
earlier frame records and playback choices are preserved. The video reached 400
frames at 20:59:48 UTC with no error. The shared bounded Windows replacement retry
passed all 25 recorder tests and the pinned Black, isort, and Ruff checks. A later
low-disk capture pause was resolved by sharing 3,721 hash-verified identical
immutable checkpoint history and library files. Free space increased from 4.91 to
20.72 GiB. No frame or checkpoint contents were removed.

The main controller alone operated live Altium and integrated code changes. A
monitoring agent maintained the progress record. Two supporting review agents plan
bounded local copper replacements for the remaining crowded fanouts; components and
rules remain fixed.

## Earlier checkpoint 014

Checkpoint `014-nvcc-plane` preserves **495 remaining connections, 614/1,109 routed
(55.37%), and 72/321 whole nets connected (22.43%)**. It contains 3,822 tracks and
560 vias. Batches 027 and 028 completed 12 buck-source connections; the qualified L5
supply polygon completed 42 more. Native inventory proves unchanged existing copper,
pads, rules, and net assignments across the polygon addition. All 10 prior polygon
definitions remain byte-identical. The PCB was saved at 19:54:45.410 UTC, 8,489,472
bytes, SHA-256 `0bc7239cc4d11b295454477650befda4a9c3eddd95b9aadd24ba668762407939`.
All 48 checkpoint files match their sources. The saved board was closed and
reopened; a fresh inventory verifies exact geometry and connectivity.

Native DRC at 19:52 UTC reports 3,978 findings: clearance 913, shorts three, width
413, antennas 126, and unrouted 507 (495 connections plus 12 inherited items).
Relative to checkpoint 013, 75 findings disappeared (44 airwires and 31 antennas);
two changed airwire endpoints appeared. No physical findings were added. Error
markers were reset before saving. The report has no dedicated thermal or island
check sections. Rail capacity, DDR timing, and inherited defects remain open; this
is a provisional checkpoint, not electrical sign-off.

Batch 029 improves DDRB strobe coupling, with exact geometry verified after
save/reopen, but timing remains provisional. Further length tuning is deferred while
larger connection-completion batches proceed. The first 28-net ActiveRoute pass
produced no paths; checked local connections and additional layer access are next.
The working PCB is
`work/full-routing-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.

The main controller alone operated live Altium and integrated code changes. A
monitoring agent maintained the progress record; two supporting agents performed
bounded, read-only electrical and evidence reviews. Review tasks were bounded and
did not block controller work. The following dated recovery record retains the
earlier checkpoint evidence.

Checkpoint `009-local-power-ground` preserves batch 022: **623 remaining
connections, 486/1,109 routed (43.82%), and 72/321 whole nets connected (22.43%)**.
These are provisional connectivity measurements. Its PCB was saved at 09:49:20.619
UTC, 8,326,144 bytes, SHA-256
`687a45c8278ecb8377dca6d21ee83b400c1d54c19978f28be9f59e0d337c16c0`. All 44 project
files were copied and hash-verified. The board was closed and reopened; native Board
Information at 09:51:41 confirms 486 routed and 623 remaining. Exact reopened
inventory completed at 17:26:26 UTC with zero geometry, rule, net-assignment, or
connectivity-count changes. The live disk PCB hash still matches. Batch 023 is
applying 66 reviewed Bottom GND segments to connect 33 capacitor returns to existing
vias; native validation is pending.

Batches 021 and 022 completed 30 and 39 connections respectively. The final
inventory has 3,597 tracks and 526 vias. Independent exact review passed all 47
batch-022 requests/readbacks and preserved existing copper and immutable records.
Native DRC at 09:46:38–43 reports 4,129 findings: clearance 913, shorts 3, width
413, and 635 unrouted findings (623 connections plus 12 inherited items). The 25
added identities versus batch 019 are 21 changed airwires and four known GPIO/UART
access antennas. There are no added clearance, short, width, via, or other
copper-rule findings in that comparison. Error markers were reset before saving. DDR
widths/timing and TEST_MODE clearance remain open.

Dashboard and recorder resumed at 17:07 UTC with all 142 earlier captures unchanged.
A fresh PNG and 143-frame MP4 passed content, HTTP, and decode checks in the
historical monitoring record. The real 16:22:17–17:07:47 capture gap remains
visible. Duplicate playback ranges 65–99 and 101–141 are approved for omission; raw
captures, the original video, distinct states 64/100, and progress history remain
preserved. Deployment completed at 17:17 UTC: the live API reports 145 raw captures,
69 video frames, 76 omitted duplicates, no pending rebuild, and no errors. The
edited 68-frame pre-resume MP4 decoded successfully; the first resumed capture and
cumulative 69-frame video are available. Both prior manifest/video backups and the
unchanged progress file were verified.

Human intervention restored Altium's license. The 17:12:48 recorder frame shows
the complete Altium Home page without the No License suffix, at 3362 × 1874 window
pixels, DPI 96, on the 3364 × 1924 console display. Desktop control was temporarily
interrupted and resumed at 17:18 UTC, with the licensed work PCB and full window
verified. The main controller remained the sole Altium writer; the status
observer owns monitor processes and `.runtime/status.json`.

The earlier queue was to validate batch 023 and preserve checkpoint 009; complete
three local sense nets and two ordinary signals; apply the independently reviewed
six-via/fourteen-track NVCC/C324 request; qualify the bounded L5 NVCC polygon;
continue power distribution and DDR repairs. The dated entries below retain earlier
evidence and do not supersede this current result.

## Objective and fixed constraints

Route QCMI_SOM8MM from preserved original copper within the supplied design. All
design rules and component positions remain unchanged. Preserve stackup, net
assignments, shape, fanout, and inherited copper. Situs and all Auto Route scopes
are prohibited. Use the [routing plan](ROUTING_PLAN.md) and [full routing
prompt](FULL_ROUTING_PROMPT.md).

## Recorded ownership and earlier routing work

- Sole Altium/desktop writer: main controller.
- Progress/recording observer: monitoring agent.
- Monitor recovery and all code edits: main controller.
- Bounded electrical review: electrical reviewer.
- Bounded evidence review: evidence reviewer.
- Phase: checked local power/GND batches, with ordinary signal access ready.
- Full-run accepted copper: eight completed PMIC connections, 33 Top tracks,
  no new vias. Rules, pad positions, and baseline copper are unchanged.
- Fresh full-path inventory and native reports verify the working PCB identity. Online DRC is enabled globally and for clearance, shorts, width, and vias.
- Saved DDR candidate: 837 remaining connections, 2,944 tracks, 372 vias. DDR A byte 1
  connected eight nets and DDR B byte 0 connected four. These groups are not
  accepted: seven extended CPU stubs add 42 mil of undersized copper and timing
  work remains. The checked CPU approach repairs removed all 16 new clearance
  findings and the new short. Native DRC at 05:55 reports 4,305 findings, with
  baseline counts of 911 clearance, three shorts, and 413 width findings. The same width count does not mean the new extensions comply with the rule.
- Explicit via qualification passed invalid-request rejection and native
  Undo/Redo with exact inventories. Six strobe/return vias and nine Top leads
  were added. Native Repour All removed their eight cached-polygon shorts.
- Batches 006 and 007 reduced remaining connections from 837 to 818, with
  36/321 whole nets connected (11.21%) and 291/1,109 connections routed (26.24%). These are provisional connectivity measures. Batch 008 added no copper. Native DRC at 06:33 reports 915 clearance, four short, and 413 width findings:
  two TESTMODE CPU clearances and two connector collisions remain new. DDR
  pair coupling and timing also remain open. Original rule constraints are fixed.
- Batch 009 added exactly 16 checked ordinary signal vias and 21 Top leads. Batch 010 added 14 Bottom tracks and completed four more nets: JTAG_MOD,
  NetD1_C, SYS_NRST, and TEST_MODE. The live board has 3,095 tracks, 394 vias,
  and 814 remaining connections: 40/321 whole nets connected (12.46%) and
  295/1,109 connections routed (26.60%). These remain provisional measures. Native DRC at 06:53 preserves the prior clearance, short, and width findings;
  changed findings are unfinished-access antennas and unrouted endpoints.
- Batch 011 added 16 GND vias and applied 22 checked track changes. GND
  remaining edges decreased by 16; both connector clearances and the short
  were removed. Native DRC at 07:12 reports 913 clearance, three short, and
  413 width findings. The board has 3,113 tracks, 410 vias, and 798 remaining
  connections. Reopened Board Information at 07:20:54 confirms 311/1,109 routed
  (28.04%); 40/321 whole nets are connected (12.46%). The fresh reopened
  inventory has zero geometry or immutable-record changes from batch 011.
- Batch 012 added exactly 40 vias and 47 tracks; all 87 native audit rows match. Repour and inventory confirm 782 remaining connections, with GND alone
  decreasing from 197 to 181. No existing copper or immutable records changed.
- Batch 013 completed BOOT_MODE1 with two 3.2 mil L3 tracks, 737.166 mil total. Its Bottom gloss merged two segments with identical physical copper. The
  actual path stays outside the DDR corridor; modeled clearance is 4.316 mil,
  and the current L2 ground reference was inspected under the whole path. Native DRC preserves all clearance, short, and width findings. DDR geometry
  is unchanged; small timing display changes remain unexplained.
- Batch 014 completed all 14 selected ordinary signals on L3. The 07:54:28
  inventory has 3,218 tracks, 450 vias, and 767 remaining connections:
  342/1,109 connections routed (30.84%) and 55/321 whole nets (17.13%). Exact review confirms 57 new 3.2 mil L3 segments, no physical copper loss,
  and unchanged immutable records. Native DRC has zero new findings compared
  with batch 013; 14 unrouted and 22 antenna findings were removed. The closest
  new copper remains 14.23 mil outside the reserved DDR rectangle. Reopened Board Information at 08:06:22 confirms those connection counts;
  the 08:07:47 inventory matches the saved geometry exactly.
- Batch 015 added exactly 39 vias and 48 short leads for 22 signal access
  points, 17 GND points, and an existing SYS_STATUS via. The export has 3,266
  tracks, 489 vias, and 749 remaining connections. Native DRC preserves every
  clearance, short, width, and DDR finding; changes are pending access antennas
  and 18 fewer unrouted findings.
- Batch 016 added 159 L3 tracks and reduced remaining connections to 729:
  380/1,109 routed (34.27%) and 67/321 whole nets connected (20.87%). All old
  tracks and immutable records remain unchanged. Native DRC found three new
  clearances and three shorts at one PMIC_ON_REQ/BOOT_MODE1 crossing. Batch
  018 removed these six findings. Significant L3 paths occupy the
  initial DDR rectangle. Electrical review permits provisional retention under
  a Top/Bottom DDR allocation, except one UART3_RXD diagonal that obstructs
  planned DDR through-vias. Batch 018 added the checked local detour.
- Batch 017 added exactly 20 Bottom tracks and completed eight GND and two ZQ
  connections. Batch 018 changed two previously added L3 tracks and added five
  segments. Exact seven-row reconciliation passed at 09:04:29: 3,450 tracks,
  489 vias, and 719 remaining connections. This is 390/1,109 connections routed
  (35.17%) and 69/321 complete nets (21.50%). Native DRC reports 4,232 findings,
  including 913 clearances, three shorts, and 413 width findings, with no new
  copper faults. Native L2 inspection shows continuous reference copper beneath
  both repaired paths. Saved checkpoint 008-l3-repair has 43 hash-verified files;
  its PCB was saved at 09:06:29 UTC. Reopen verification remains pending.
- Batch 019 added 11 GND vias and 30 tracks. Exact combined review confirms all
  41 native readbacks and unchanged old copper, rules, pads, and net assignments. Remaining connections decreased 719 to 705; I2C2/3/4_SCL are complete. Native
  DRC at 09:15 reports 4,215 findings, with no added non-airwire findings and
  unchanged clearance, short, width, and DDR findings. Error markers were reset.
- Batch 020 added 16 vias and 20 tracks for ground returns and GPIO1_IO08/
  UART3_CTS access. The 09:27:56 inventory has 3,500 tracks, 516 vias, and 692
  remaining connections: 417/1,109 routed (37.60%) and 72/321 complete nets
  (22.43%). Thirteen GND connections were completed. Independent review confirms
  all 36 additions/readbacks and unchanged old copper and immutable records. Native DRC remains pending. Batches 019/020 are not yet saved.
- Batch 021 is applying the first 60 checked Bottom supply segments for 30
  capacitor pads. Batch 022 is prepared with the remaining 18 supply segments,
  four connector power-bank tracks, 15 GND leads, and ten GND vias. Native
  readbacks, connectivity, DRC, and a saved/reopened checkpoint are required.
- UART1_CTS and UART1_TXD paths from batch 007 enter the reserved DDR corridor. They need an eastern or Top reroute before further DDR pair work.
- All 228 native component records match the original exactly in designator,
  footprint, coordinates, rotation, and layer. Rules and pad tables also match.
- Reset error markers after reviewing and preserving each native DRC report.

Working project: `work/full-routing-2026-09-30/QCMI_SOM8MM/QCMI_SOM8MM.PrjPcb`.
Working PCB:
`work/full-routing-2026-09-30/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc`.
Runtime paths in these notes are relative to `astra-run/`.

All 27 original input-manifest files passed SHA-256 checks. Whole-directory work and
unopened-baseline copies each contain 28 identical files, including one additional
generated `QCMI_SOM8MM.PrjPcbStructure`. All 18 project document paths resolve
inside each copy. The original PCB SHA-256 remains
`2669fca73471169e5c4cf80b3dcd25790dd246219bd2cbc23c6c1044637d6f2b`. Copy evidence:
`runs/full-routing-2026-09-30/working-copy-manifest.json` and
`baseline-unopened-manifest.json`; unopened project under
`runs/full-routing-2026-09-30/baseline-unopened/QCMI_SOM8MM/`.

Full-run checkpoint `001-pmic8`: native remaining connections 857 to 849, eight
newly complete nets, native DRC 4,320 to 4,312 with zero added findings. The working
PCB was saved, closed without a prompt, and reopened. Board Information at 05:09:32
UTC confirms 1,109 total / 260 routed / 849 remaining (23.44%). Saved PCB SHA-256:
`377e657218207b35ea7aefae81fbc32d2dc8ef6822c961fa886a7bcaf75660b9`. Whole-project
copy: `runs/full-routing-2026-09-30/checkpoints/001-pmic8/`. Acceptance evidence:
`runs/full-routing-2026-09-30/batches/001-pmic8/`; its reopened Board Information is
newer than the report in the project copy.

Native Save All wrote the PCB at 07:16:57.238 UTC; all 40 copied files match
SHA-256. PCB hash:
`971e992bf517a2a776542ea4dcfdb069f684a1c552c361448688e941c39e81d3`. This
798-remaining copy passed save/reopen equality at 07:27. Electrical acceptance
remains open for DDR timing, stub widths, and TESTMODE clearance. All 19 project
document paths resolve and schematics are unchanged. The earlier 837-remaining
CPU-repair copy remains in checkpoint 003, with its exact reconciliation, native
DRC, and 05:59:30 Board Information in batch 004.

Latest saved and reopened provisional copy:
`runs/full-routing-2026-09-30/checkpoints/006-ordinary-l3-provisional/`. The PCB was
saved at 07:59:34.029 UTC, 8,220,160 bytes; all 41 copied files match. PCB SHA-256:
`ca6bafebe57f6087602aef6e29cb4f197b0b3bfad039679ec425cc8959cc673d`. The 08:07:47
reopened export has zero geometry or immutable-record changes. Native Board
Information confirms 767 remaining connections.

Saved recovery copy before the local L3 repair:
`runs/full-routing-2026-09-30/checkpoints/007-ordinary16-before-repair/`. The PCB
was saved at 08:34:41.157 UTC, 8,295,936 bytes; all 42 copied files match. PCB
SHA-256: `aeed91b8b3966674c90ea42d0049ca1d11d64b7da015d6c422871e28a842a1f4`. This is
a recovery copy with the batch016 defects above, without reopen acceptance. It does
not replace checkpoint006's validation evidence.

Preserved setup result: `results/setup-trial-2026-09-30/`, PCB hash
`cf8253b370543494b4f429fb7b368ae060b40e27bc1054c65916a7e33f0bd655`. That separate
trial has 18 newly complete nets, 20 fewer remaining connections, 837 remaining, and
three inherited shorts. See [final trial DRC](FINAL_DRC.md) and [independent
audit](FULL_RUN_QUALITY.md).

## Monitoring

Historical recording run: `full-routing-2026-09-30`. Setup monitor stopped
gracefully with 49 frames retained. New WGC frames and MP4 are verified; the
05:02:09 frame shows new PMIC copper. A Windows manifest replacement denial stopped
the recorder at 06:52:12 UTC. Recording resumed at 06:56:08 with the original 28
frames intact and the gap recorded explicitly. The 07:01 scheduled capture and video
reached 30 frames without errors. Directory permission checks and 20 Python
atomic-replacement probes passed. At 08:05, the observer reported a current
heartbeat and 42 frames. The 09:23:19 check confirms heartbeat 09:23:17, 58 captures
and 58 video frames, and no errors. All 54 earlier hashed frames are unchanged; all
58 files match recorded sizes. Both process identities were verified at that
recorded check. The status observer retains sole recorder ownership and health
watch. See [monitor evidence](MONITORING_FULL_RUN.md). Recorder liveness does not
establish routing or automatic agent continuation.

## Earlier continuation queue

1. Complete batches 021/022's local supply and ground connections, then the
   three local Bottom sense nets and two ordinary L3 nets. Save and reopen
   the next milestone. Qualify the explicit L5 power polygon for NVCC_DRAM
   after preserving that checkpoint and reviewing its source access. Repair the two UART1 paths that enter
   the DDR corridor using the bounded removal helper after native qualification.
2. Inspect native Differential Pairs Routing batch coverage and qualify one
   width-only edit. Stored Top impedance widths are 4.1 mil, so the global
   3.2 mil minimum alone does not establish acceptance.
3. Inspect reference copper continuity and native timing, then route remaining
   pairs, data, CA/CS/CKE and calibration connections. Package delay appears
   already stored on CPU pads; do not add it twice.
4. Preserve verified whole-project checkpoints, the complete original input,
   and the associated validation evidence.
5. Use online DRC during ordinary routing, full DRC at meaningful milestones,
   and the fast comparator for each measured batch; do not repeat setup.

The all-net register is reconciled with the fresh baseline. Notes:
[NET_PLAN.tsv](NET_PLAN.tsv), [constraints](CONSTRAINTS.md), [DDR
plan](DDR_PLAN.md).
