# TXD5 source escape

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Native Interactive Routing in Push Obstacles mode extends the inherited
SAI1_TXD5 Top tip from (1092.21, 893.99) to (1095, 855) mil. The two
4.1 mil segments total 40.146 mil. Checkpoint102 preserves the prior board.

The native operation adds 29 tracks, replaces 16 tracks, and moves two
existing vias. Its exact inventory is in batch591. Local inherited TXD1
and TXD3 fanout segments and TXD2/TXD4 vias move within this source area.
The explicit conductor audit preserves every previously connected pad and
via on all nine changed nets. Pads and rules are unchanged; 30 connections
remain. This is a provisional source escape with no completed-net gain.

The new TXD5 vertical segment has a 2.79 mil gap to fixed U1-AG23, below
the 3 mil clearance requirement. Final clearance repair remains required.
No batch DRC ran. Checkpoint103 preserves this reviewed native geometry
before the RXD0 insertion; checkpoint102 remains the rollback reference.
