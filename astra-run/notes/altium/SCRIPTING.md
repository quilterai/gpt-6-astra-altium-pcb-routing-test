# Scripting and native reports

> Public edition of a historical engineering record from the 2026 experiment.
> Dated runtime paths can refer to intermediate checkpoints not included here.
> Private destinations and workstation identifiers are omitted; this is not
> evidence of a currently running session.

Research date: 2026-09-30. **Research only; the calls below are untried in this
VM.** Evidence comes from official Altium documentation and the installed
AD26 `.INS`/`.RCS` definitions. Legacy API documentation does not establish
compatibility with every AD26 method. No script, board, or settings changes
were made for this research.

The controller's existing inventory opened the intended board through
`GetPCBBoardByPath` and reported 321 nets with `ConnectivelyInvalid=True` and
857 connection objects. Those results have not been reconciled with a native
report. The API flag alone does not establish how many connections remain.

## First candidate: validate connectivity

The official `IPCB_Board` reference documents this no-argument method:

```pascal
Board.ConnectivelyValidateNets;
```

Its stated purpose is to validate board net connectivity. On the disposable
trial board, record the inventory before this call, then create fresh iterators
and record it again. Compare the result with a native Routing Information report
before treating connection objects as a completion measure.

`Board.CleanNet(Net)` is a separate documented operation that reorganizes net
topology. Do not substitute it for validation. `Net.Rebuild` and
`Net.ConnectivelyInValidate` appear in the API reference, but their descriptions
are empty. Their presence alone does not justify a repair sequence.
[Board API](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-system-interfaces-reference)
[Net API](https://www.altium.com/documentation/altium-dxp-developer/pcb-api-design-objects-interfaces-reference)

Redrawing the view is a separate operation: `PCB:Zoom`, `Action=Redraw` is
documented for display refresh. It is not evidence that connectivity was
recalculated.

## Process calls and the active document

For a DelphiScript process call, use `ResetParameters`, then the required
`AddStringParameter` calls, then `RunProcess`. Reset before **each** process;
running one does not empty its parameter buffer. The same documentation warns
that `RunCommand` is not properly supported by scripting, despite its use in
compiled extension examples.
[Script process API](https://www.altium.com/documentation/altium-dxp-developer/system-api)

Board-specific methods operate on the captured board interface. The process
commands below come from editor launchers; qualify them with the intended PCB
or OutJob active. `GetPCBBoardByPath` success does not prove that a subsequent
process targets that document. Confirm its full path before and after the call.

## Installed command evidence

The following paths are inside `C:\Program Files\Altium\AD26\System\`.
Line numbers refer to files inspected on the research date. Parameters are the
literal installed launcher values; `(empty)` means no parameters.

| Purpose | Process | Parameters | Evidence |
|---|---|---|---|
| Fit selected objects | `PCB:Zoom` | `Action= Selected` | `AdvPcb.rcs:189`, also `:756`, `:761` |
| Fit filtered objects | `PCB:Zoom` | `Action= Filtered` | `AdvPcb.rcs:190` |
| Redraw | `PCB:Zoom` | `Action = Redraw` | `AdvPcb.rcs:225` |
| Board Report dialog | `PCB:ReportBoardSpecs` | `(empty)` | `AdvPcb.rcs:833`; Reports menu link `:2019`; `advpcb.ins:763` |
| Board Information launcher | `PCB:BoardInformation` | `(empty)` | `AdvPcb.rcs:615`; `advpcb.ins:674` |
| Netlist status report | `PCB:ReportNetlistStatus` | `(empty)` | `AdvPcb.rcs:616`; `advpcb.ins:765` |
| Design Rule Checker dialog | `PCB:DesignRuleCheck` | `(empty)` | `AdvPcb.rcs:408`; `advpcb.ins:692` |
| Generate selected OutJob outputs | `WorkspaceManager:GenerateReport` | `Action=Run\|ObjectKind=OutputSelected` | `WorkspaceManager.rcs:21`; `WorkspaceManager.ins:785` |
| Run OutJob batch | `WorkspaceManager:GenerateReport` | `Action=Run\|ObjectKind=OutputBatch` | `WorkspaceManager.rcs:41`; `WorkspaceManager.ins:785` |

### Selection zoom

`IPCB_Primitive.Selected` is a documented writable Boolean. Select only the
intended objects, activate their PCB view, then try:

```pascal
ResetParameters;
AddStringParameter('Action', 'Selected');
RunProcess('PCB:Zoom');
```

The `Selected` parameter is supported by the installed definitions above. A
successful call still needs a fresh view check. Preserve and restore the prior
selection when using this only for inspection.
[Selection API](https://www.altium.com/documentation/altium-dxp-developer/delphi-sdk-how-to-faq)

## Native Board Information export

The current **Reports > Board Information** menu is linked to
`PCB:ReportBoardSpecs`. It opens **Board Report**, where **Routing Information**
includes total, completed, and remaining connections and a completion percentage.
Disable **Selected objects only** for a whole-board baseline, enable Routing
Information, and use **Report**.

Current documentation names the output `<PCBDocumentName>.txt` and/or
`<PCBDocumentName>.htm` in the PCB document's directory. Format and automatic
display are controlled under **Preferences > PCB Editor > Reports**. Record
the actual generated paths and timestamps when tested. No silent export
parameter or destination parameter was found for these PCB report commands.
Do not infer one from the general report-generation API.
[Board Report contents and output](https://www.altium.com/documentation/altium-designer/pcb/environment-setup)
[Report preferences](https://www.altium.com/documentation/altium-designer/preferences/pcb-editor)

## Batch DRC and report generation

`PCB:DesignRuleCheck` with no parameters opens the checker dialog. The inspected
definitions do not establish a direct silent batch flag. The documented UI
sequence is to configure the required **Batch** checks, enable **Create Report
File**, then use **Run Design Rule Check**. For a connectivity baseline, include
**Un-Routed Net** and **Sub-Net Details**, and record the stop-after-violations
limit so a truncated report is not mistaken for a complete result.

TXT/HTML DRC reports use the project's configured Output Path; XML uses the
project directory. Names are `Design Rule Check - <PCBDocumentName>.drc`,
`Design Rule Check - <PCBDocumentName>.html`, and `<PCBDocumentName>.xml`.
[DRC setup and reports](https://www.altium.com/documentation/altium-designer/pcb/drc/setting-up-running)

An OutJob provides a documented batch route: add **Validation Outputs > Design
Rules Check** with the intended PCB as its source. It uses that PCB's checker
settings. A dedicated local OutJob containing only this validation is a useful
qualification candidate. Activate it, then try the installed `OutputSelected`
or `OutputBatch` command from the table. The batch form is also shown in Altium's
published scripting example:

```pascal
ResetParameters;
AddStringParameter('ObjectKind', 'OutputBatch');
AddStringParameter('Action', 'Run');
RunProcess('WorkspaceManager:GenerateReport');
```

No completion timing or return-value contract was established for this call.
Verify a fresh report, its board identity, enabled checks, and completion before
accepting it. OutJob invocation reduces repeated dialog input only after its
settings and behavior have been qualified in the restored desktop session.
[DRC validation in OutJobs](https://www.altium.com/documentation/altium-designer/pcb/drc)
[Altium scripting example, published 2019](https://resources.altium.com/p/continuous-integration-implementation-using-altium-designer)

## Qualification order

1. Recover the desktop and identify the disposable PCB by its full path.
2. Compare inventories before and after `ConnectivelyValidateNets`.
3. Generate a whole-board Routing Information report and reconcile the counts.
4. Qualify selection zoom on one known pad or track.
5. Configure and run DRC manually, then repeat through the dedicated OutJob.
6. Record actual files, timing, dialogs, failures, and save/reopen results before
   adding any call to unattended work.
