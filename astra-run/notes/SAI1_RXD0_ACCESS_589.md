# SAI1_RXD0 access

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Batch589 connects SAI1_RXD0 with 82 added tracks and two 16/8 mil vias.
Checkpoint103 preserves the starting board. The request removes thirteen
run-added tracks and trims one inherited RXD1 free-end antenna by removing
one segment and shortening its adjoining segment. Both exact identities
and the retained terminal proof are frozen with the batch.

The removed RXD1 Top segment is 9.71 mil long at 3 mil width, raw endpoints
(125179100, 91834000) and (125179100, 91931100). The adjoining 3 mil
segment retains its (125079200, 92030900) endpoint and ends at
(125147500, 91962668). This retains 9.65427 mil of its 14.12092 mil length.
The short RXD0 transition preserves the neighboring GPIO1_IO01 and
REF_CLK_32K Top access paths. Every RXD1 pad and via stays connected.

The complete geometry preserves the terminals of all nine displaced nets.
Minimum added-track clearance is 3.028935 mil; minimum via clearance is
3.048599 mil and minimum hole gap is 11.284154 mil. Rules and placement
remain unchanged. The RXD0 L5 width uses the existing 3.2 to 10 mil rule
recorded in width366-L5-native.tsv.

Two ordered passes apply 64 request rows (one edit and 63 additions), then
19 additions and two vias. Full inventory comparisons check exact tracks,
vias, pads, rules, and all-net connectivity after the native operation.
The projected final count is 9,129 tracks and 968 vias; completion requires
the native export to show no RXD0 airwire and no connection regression.

Final electrical review remains pending. The RXD0 L5 path uses a PWR layer
and must be reassigned. The DRAM/PU supply has a 95.704 mil section at
3 mil, and VDDA has a 35 mil Bottom section at 3 mil; current capacity
requires review. Layer assignment, return paths, DDR timing, and batch DRC
remain end-of-connectivity work.
