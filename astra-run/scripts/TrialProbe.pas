{ Check read-only PCB access before loading the full inventory script. }

function ProbeExpectedBoard : String;
begin
    Result := AstraWorkspacePath('TrialProbe.PrjScr', 'trials\routing-50-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function ProbeOutputDirectory : String;
begin
    Result := AstraWorkspacePath('TrialProbe.PrjScr', 'runs\current-inspection');
end;

{ Export the current filename only when the exact trial PCB is active. }
procedure ProbeTrialBoard;
var
    Board : IPCB_Board;
    Report : TStringList;
begin
    Board := PCBServer.GetCurrentPCBBoard;
    if Board = nil then
    begin
        ShowMessage('No PCB is active. Activate the routing-50 trial PCB.');
        Exit;
    end;
    if UpperCase(Board.FileName) <> UpperCase(ProbeExpectedBoard) then
    begin
        ShowMessage('Refusing PCB: ' + Board.FileName);
        Exit;
    end;
    if not DirectoryExists(ProbeOutputDirectory) then
    begin
        ShowMessage('Create the output directory first: ' + ProbeOutputDirectory);
        Exit;
    end;
    Report := TStringList.Create;
    try
        Report.Add('board_file' + #9 + Board.FileName);
        Report.Add('probe' + #9 + 'read_only_ok');
        Report.SaveToFile(ProbeOutputDirectory + '\probe.tsv');
    finally
        Report.Free;
    end;
    ShowMessage('Probe written to ' + ProbeOutputDirectory + '\probe.tsv');
end;
