# PCIe transmit access

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Checkpoint112 completes PCIE_TX_N. Batch634 replaces six exact run-added tracks with 49 tracks and adds three 16/8 mil vias. Native readback matches every request and preserves all earlier connections.

The terminal proof retains every prior pad and via contact on PCIE_TX_N, CSI_D1_P, CSI_D2_P, CSI_D3_P, CSI_D3_N, and POR_B. Inherited copper, component positions, pads, rules, and net assignments remain unchanged.

PCIE_TX_N uses 4.2 mil outer-layer tracks and 15 mil L5 tracks under the existing pair rule. Native receipt634 confirms POR_B L7 width from 3.2 through 10 mil; the replacement uses 3.2 mil. Its offset connector via requires the exact J4-69 Bottom pad and guarded center.

The combined geometric minimum is 3.008767 mil; native final DRC remains pending. GND/PWR layer assignment, PCIe and CSI coupling, timing, reference continuity, and via fill and cap remain unresolved.
