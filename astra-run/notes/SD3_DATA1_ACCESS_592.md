# SD3_DATA1 access

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Batch592 connects SD3_DATA1 while replacing eighteen exact run-added
tracks with 99 additions and three 16/8 mil vias. Checkpoint104 preserves
the starting board. Inherited copper, components, and rules stay unchanged.

C9's Ground pad has an explicit Bottom path to a new Ground via, then an
L7 connection to its original Ground via. The geometry proof retains all
176 existing physical Ground pads and vias in that connected component,
and all terminals of every displaced signal and VDD_1V8 branch. The
existing Ground L7 rule permits 3 to 100 mil, confirmed by
`width592-GND-L7-native.tsv`; this request uses 3 to 10 mil.

Minimum added track, via, and hole gaps are 3.081557, 3.051145, and
11.088054 mil. Two passes add 64 tracks, then 35 tracks and three vias,
with all removals in the first pass. Expected final counts are 9,210
tracks and 971 vias. Both native passes match the request exactly, and
SD3_DATA1 has no remaining connection. Repour opens two VDD_3V3 edges,
so batch592 alone is not an accepted connectivity checkpoint. Batch594
adds seven supply tracks and restores both edges. Aggregate595 matches
the exact requests and preserves all earlier connections. Checkpoint105
was saved at 08:29:13 UTC with 1,081 of 1,109 connections routed,
28 remaining, 9,217 tracks, and 971 vias; all 157 project files were
hash-verified. Original copper, pads, rules, and net assignments remain
unchanged by batches592 and594.

The 821.209 mil SD3_DATA1 L5 path and 1,711.980 mil SD2_WP L5
replacement require final layer and timing review. GND-layer routing must
be removed after connectivity completion, and controlled impedance paths
must leave PWR layers. VDD_1V8's 428.021 mil section at 3.2 mil requires
current-capacity review. DDR matching, reference continuity, via fabrication,
and final DRC remain pending.

The VDD_3V3 repair uses two 20 mil Top segments and five L6 segments.
Its 332.5 mil section at 3 mil fits the native Width rule confirmed in
`width594-VDD_3V3-L6-native.tsv`, but current capacity and voltage drop
remain unresolved. Minimum added copper spacing is 3.650 mil.
