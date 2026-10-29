{ Select one exact inherited no-net track without changing copper. }

function FullViaSelectExpectedBoard : String;
begin
    Result := AstraWorkspacePath('FullViaSelect.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function FullViaSelectDirectory : String;
begin
    Result := AstraWorkspacePath('FullViaSelect.PrjScr', 'runs\full-routing-2026-09-30\quality\full-via');
end;

{ Record the selection stage without dialogs or redraw commands. }
procedure FullViaSelectStage(Status : TStringList; StageName, Candidate : String);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.Add('expected_board=' + FullViaSelectExpectedBoard);
    Status.Add('candidate=' + Candidate);
    Status.Add('exclusive_selection_checked=false');
    Status.SaveToFile(FullViaSelectDirectory + '\full-track-selection-status.txt');
end;

{ Match one Top track before selecting it; existing selections remain unchanged. }
procedure FullViaSelectExactTrack(Candidate : String;
    X1Raw, Y1Raw, X2Raw, Y2Raw, WidthRaw : Integer);
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Track, TargetTrack : IPCB_Track;
    Status, Audit : TStringList;
    Matches : Integer;
    EndpointsMatch, HasEmptyNet : Boolean;
begin
    Status := TStringList.Create;
    Audit := TStringList.Create;
    try
        FullViaSelectStage(Status, 'matching_candidate', Candidate);
        Audit.Add('board' + #9 + 'candidate' + #9 + 'net' + #9 + 'x1_raw' +
            #9 + 'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 +
            'width_raw' + #9 + 'layer_id' + #9 + 'result');
        Audit.SaveToFile(FullViaSelectDirectory + '\full-track-selection-audit.tsv');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then
        begin
            FullViaSelectStage(Status, 'refused_no_active_pcb', Candidate);
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullViaSelectExpectedBoard) then
        begin
            FullViaSelectStage(Status, 'refused_wrong_board', Candidate);
            Exit;
        end;
        Matches := 0;
        TargetTrack := nil;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Track := Iterator.FirstPCBObject;
            while Track <> nil do
            begin
                EndpointsMatch :=
                    ((Track.X1 = X1Raw) and (Track.Y1 = Y1Raw) and
                     (Track.X2 = X2Raw) and (Track.Y2 = Y2Raw)) or
                    ((Track.X2 = X1Raw) and (Track.Y2 = Y1Raw) and
                     (Track.X1 = X2Raw) and (Track.Y1 = Y2Raw));
                if EndpointsMatch and (Track.Width = WidthRaw) and
                   (Track.Layer = eTopLayer) then
                begin
                    HasEmptyNet := Track.Net = nil;
                    if Track.Net <> nil then HasEmptyNet := Track.Net.Name = '';
                    if HasEmptyNet then
                    begin
                        TargetTrack := Track;
                        Inc(Matches);
                    end;
                end;
                Track := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        if Matches <> 1 then
        begin
            FullViaSelectStage(Status, 'refused_match_count', Candidate);
            Status.Add('matches=' + IntToStr(Matches));
            Status.SaveToFile(FullViaSelectDirectory + '\full-track-selection-status.txt');
            Exit;
        end;
        FullViaSelectStage(Status, 'selecting_candidate', Candidate);
        TargetTrack.Selected := True;
        if not TargetTrack.Selected then
        begin
            FullViaSelectStage(Status, 'failed_selection_readback', Candidate);
            Exit;
        end;
        Audit.Add(Board.FileName + #9 + Candidate + #9 + '' + #9 +
            IntToStr(TargetTrack.X1) + #9 + IntToStr(TargetTrack.Y1) + #9 +
            IntToStr(TargetTrack.X2) + #9 + IntToStr(TargetTrack.Y2) + #9 +
            IntToStr(TargetTrack.Width) + #9 + IntToStr(TargetTrack.Layer) +
            #9 + 'selected_candidate_only');
        Audit.SaveToFile(FullViaSelectDirectory + '\full-track-selection-audit.tsv');
        FullViaSelectStage(Status, 'selected_candidate_only', Candidate);
    finally
        Status.Free;
        Audit.Free;
    end;
end;

{ Select the recorded unassigned Top segment touching U1-M2. }
procedure SelectFullInheritedU1M2Track;
begin
    FullViaSelectExactTrack('U1-M2', 122421750, 94885250, 122520200, 94786800, 30000);
end;

{ Select the recorded unassigned Top segment touching U1-N2. }
procedure SelectFullInheritedU1N2Track;
begin
    FullViaSelectExactTrack('U1-N2', 122421750, 94688350, 122520200, 94589900, 30000);
end;

{ Select the recorded unassigned Top segment touching U4-K5. }
procedure SelectFullInheritedU4K5Track;
begin
    FullViaSelectExactTrack('U4-K5', 133053200, 95454600, 133230700, 95277100, 100000);
end;
