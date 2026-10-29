# RXD3 source escape

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Native Interactive Routing in Push Obstacles mode extends SAI1_RXD3
from its inherited Top fanout to (977.42, 828.58) mil at 4.1 mil width.
The source via is still absent; RXD3 remains one of 22 open connections.
Checkpoint110 preserves the preceding published board.

Batch628 replaces 55 tracks with 85 tracks and moves four run-added vias.
Its explicit conductor audit preserves every previously connected pad and
via on all 15 affected nets. One inherited RXD3 segment is resegmented:
raw (125570000,91834000)-(125570000,91933900), width30000, becomes
(125570000,91850100)-(125570000,91933900), width30000. The removed
1.61 mil tip is replaced by connected 4.1 mil native copper. This bounded
fanout adjustment keeps the original pad connection and advances access.

Batch633 replaces eleven run-added tracks with 22 tracks and moves no vias.
Its explicit conductor audit preserves all terminals on RXC, RXD2, RXD3,
RXD4, and RXFS. Original copper, pads, rules, and net assignments are
unchanged in this second operation. Both operations retain all previously
completed connections. The recovered license allowed the working PCB to
be saved; error markers were reset after inventory export.

The inventories and terminal proofs are in batches628/633 and
quality/native628-source-audit.json and quality/native633-source-audit.json.
Final DRC, layer assignment, timing, and reopen remain pending.
