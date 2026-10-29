{ Apply at most 16 explicit width changes to exact existing tracks. }

function FullTrackWidthsExpectedBoard : String;
begin
    Result := AstraWorkspacePath('FullTrackWidths.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function FullTrackWidthsDirectory : String;
begin
    Result := AstraWorkspacePath('FullTrackWidths.PrjScr', 'runs\full-routing-2026-09-30\quality\full-track-widths');
end;

{ Parse unsigned decimal integers without overflow or other numeric syntax. }
function FullTrackWidthsInteger(Text : String; var Value : Integer) : Boolean;
var
    I, Digit : Integer;
begin
    Result := False;
    Value := 0;
    if (Text = '') or (Length(Text) > 10) then Exit;
    for I := 1 to Length(Text) do
    begin
        if (Text[I] < '0') or (Text[I] > '9') then Exit;
        Digit := StrToInt(Copy(Text, I, 1));
        if Value > (2147483647 - Digit) div 10 then Exit;
        Value := Value * 10 + Digit;
    end;
    Result := True;
end;

{ Compare unordered endpoints without depending on Altium's stored direction. }
function FullTrackWidthsSameEndpoints(AX1, AY1, AX2, AY2,
    BX1, BY1, BX2, BY2 : Integer) : Boolean;
begin
    Result := ((AX1 = BX1) and (AY1 = BY1) and (AX2 = BX2) and (AY2 = BY2)) or
        ((AX1 = BX2) and (AY1 = BY2) and (AX2 = BX1) and (AY2 = BY1));
end;

{ Return an empty name for an unassigned track. }
function FullTrackWidthsNetName(Track : IPCB_Track) : String;
begin
    Result := '';
    if Track.Net <> nil then Result := Track.Net.Name;
end;

{ Record the last stage and the number of completed readbacks. }
procedure FullTrackWidthsStage(Status : TStringList; StageName : String;
    RowIndex, Completed : Integer);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.Add('expected_board=' + FullTrackWidthsExpectedBoard);
    Status.Add('row=' + IntToStr(RowIndex));
    Status.Add('completed_readbacks=' + IntToStr(Completed));
    Status.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-status.txt');
end;

{ Count tracks using the qualified inventory's legacy iterator scope. }
function FullTrackWidthsCount(Board : IPCB_Board) : Integer;
var
    Iterator : IPCB_BoardIterator;
    Track : IPCB_Track;
begin
    Result := 0;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Track := Iterator.FirstPCBObject;
        while Track <> nil do
        begin
            Inc(Result);
            Track := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
end;

{ Use negative readback values only before a row finishes. }
function FullTrackWidthsAuditRow(BoardName : String; RowIndex : Integer;
    NetName : String; X1, Y1, X2, Y2, OldWidth, NewWidth, Layer,
    ActualWidth, BeforeCount, AfterCount : Integer; ResultName : String) : String;
begin
    Result := BoardName + #9 + IntToStr(RowIndex) + #9 + NetName +
        #9 + IntToStr(X1) + #9 + IntToStr(Y1) + #9 + IntToStr(X2) + #9 +
        IntToStr(Y2) + #9 + IntToStr(OldWidth) + #9 + IntToStr(NewWidth) +
        #9 + IntToStr(Layer) + #9;
    if ActualWidth >= 0 then Result := Result + IntToStr(ActualWidth);
    Result := Result + #9 + IntToStr(BeforeCount) + #9;
    if AfterCount >= 0 then Result := Result + IntToStr(AfterCount);
    Result := Result + #9 + ResultName;
end;

{ Preflight every row, then change only Width with a separate modification per row. }
procedure ApplyExplicitFullTrackWidths;
var
    Board, ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net : IPCB_Net;
    Track, ChangedTrack : IPCB_Track;
    Lines, Fields, Status, Audit : TStringList;
    NetNames : array[1..16] of String;
    X1s, Y1s, X2s, Y2s : array[1..16] of Integer;
    OldWidths, NewWidths, Layers, ExpectedCounts : array[1..16] of Integer;
    NetMatches, TrackMatches : array[1..16] of Integer;
    TargetTracks : array[1..16] of IPCB_Track;
    NewWidthOccupied : array[1..16] of Boolean;
    Row, ResultName : String;
    I, J, Separator, RowCount, BeforeCount, CurrentCount, AfterCount : Integer;
    ParsedValue, Completed : Integer;
    ReadbackMatches : Boolean;
begin
    Lines := TStringList.Create;
    Fields := TStringList.Create;
    Status := TStringList.Create;
    Audit := TStringList.Create;
    Completed := 0;
    try
        { An unwritable output directory fails before any board write. }
        FullTrackWidthsStage(Status, 'validating_request', 0, Completed);
        Audit.Add('board' + #9 + 'row' + #9 + 'net' + #9 + 'x1_raw' + #9 +
            'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 + 'old_width_raw' +
            #9 + 'new_width_raw' + #9 + 'layer_id' + #9 + 'actual_width_raw' +
            #9 + 'before_track_count' + #9 + 'after_track_count' + #9 + 'result');
        Audit.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-audit.tsv');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then
        begin
            FullTrackWidthsStage(Status, 'refused_no_active_pcb', 0, Completed);
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullTrackWidthsExpectedBoard) then
        begin
            FullTrackWidthsStage(Status, 'refused_wrong_board', 0, Completed);
            Exit;
        end;
        if not FileExists(FullTrackWidthsDirectory + '\track-widths.tsv') then
        begin
            FullTrackWidthsStage(Status, 'refused_missing_request', 0, Completed);
            Exit;
        end;
        Lines.LoadFromFile(FullTrackWidthsDirectory + '\track-widths.tsv');
        Lines.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-request.tsv');
        if (Lines.Count < 2) or (Lines.Count > 17) then
        begin
            FullTrackWidthsStage(Status, 'refused_row_count', 0, Completed);
            Exit;
        end;
        if Lines.Strings[0] <> 'net' + #9 + 'x1_raw' + #9 + 'y1_raw' + #9 +
            'x2_raw' + #9 + 'y2_raw' + #9 + 'old_width_raw' + #9 +
            'new_width_raw' + #9 + 'layer_id' + #9 + 'expected_track_count' then
        begin
            FullTrackWidthsStage(Status, 'refused_header', 0, Completed);
            Exit;
        end;
        RowCount := Lines.Count - 1;
        for I := 1 to RowCount do
        begin
            FullTrackWidthsStage(Status, 'validating_row', I, Completed);
            Fields.Clear;
            Row := Lines.Strings[I];
            for J := 1 to 8 do
            begin
                Separator := Pos(#9, Row);
                if Separator = 0 then
                begin
                    FullTrackWidthsStage(Status, 'refused_columns', I, Completed);
                    Exit;
                end;
                Fields.Add(Copy(Row, 1, Separator - 1));
                Row := Copy(Row, Separator + 1, Length(Row));
            end;
            Fields.Add(Row);
            if Pos(#9, Row) > 0 then
            begin
                FullTrackWidthsStage(Status, 'refused_extra_columns', I, Completed);
                Exit;
            end;
            NetNames[I] := Fields.Strings[0];
            if (NetNames[I] = '') or (NetNames[I] <> Trim(NetNames[I])) then
            begin
                FullTrackWidthsStage(Status, 'refused_net_field', I, Completed);
                Exit;
            end;
            for J := 1 to 8 do
            begin
                if not FullTrackWidthsInteger(Fields.Strings[J], ParsedValue) then
                begin
                    FullTrackWidthsStage(Status, 'refused_numeric_field', I, Completed);
                    Exit;
                end;
                case J of
                    1: X1s[I] := ParsedValue;
                    2: Y1s[I] := ParsedValue;
                    3: X2s[I] := ParsedValue;
                    4: Y2s[I] := ParsedValue;
                    5: OldWidths[I] := ParsedValue;
                    6: NewWidths[I] := ParsedValue;
                    7: Layers[I] := ParsedValue;
                    8: ExpectedCounts[I] := ParsedValue;
                end;
            end;
            if (X1s[I] <= 0) or (Y1s[I] <= 0) or (X2s[I] <= 0) or
               (Y2s[I] <= 0) or (OldWidths[I] <= 0) or (NewWidths[I] <= 0) or
               (OldWidths[I] = NewWidths[I]) or (ExpectedCounts[I] <= 0) or
               ((X1s[I] = X2s[I]) and (Y1s[I] = Y2s[I])) or
               ((Layers[I] <> eTopLayer) and (Layers[I] <> eBottomLayer)) then
            begin
                FullTrackWidthsStage(Status, 'refused_dimensions_or_layer', I, Completed);
                Exit;
            end;
            if ExpectedCounts[I] <> ExpectedCounts[1] then
            begin
                FullTrackWidthsStage(Status, 'refused_inconsistent_before_count', I, Completed);
                Exit;
            end;
            for J := 1 to I - 1 do
                if (Layers[I] = Layers[J]) and
                   FullTrackWidthsSameEndpoints(X1s[I], Y1s[I], X2s[I], Y2s[I],
                       X1s[J], Y1s[J], X2s[J], Y2s[J]) then
                begin
                    FullTrackWidthsStage(Status, 'refused_repeated_track_geometry', I, Completed);
                    Exit;
                end;
            NetMatches[I] := 0;
            TrackMatches[I] := 0;
            TargetTracks[I] := nil;
            NewWidthOccupied[I] := False;
        end;

        FullTrackWidthsStage(Status, 'checking_all_targets', 0, Completed);
        BeforeCount := 0;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eNetObject, eTrackObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Primitive := Iterator.FirstPCBObject;
            while Primitive <> nil do
            begin
                case Primitive.ObjectId of
                    eNetObject:
                    begin
                        Net := Primitive;
                        for I := 1 to RowCount do
                            if Net.Name = NetNames[I] then
                                NetMatches[I] := NetMatches[I] + 1;
                    end;
                    eTrackObject:
                    begin
                        Track := Primitive;
                        Inc(BeforeCount);
                        for I := 1 to RowCount do
                            if (Track.Layer = Layers[I]) and
                               FullTrackWidthsSameEndpoints(Track.X1, Track.Y1,
                                   Track.X2, Track.Y2, X1s[I], Y1s[I], X2s[I], Y2s[I]) then
                            begin
                                if Track.Width = NewWidths[I] then
                                    NewWidthOccupied[I] := True;
                                if (Track.Width = OldWidths[I]) and
                                   (FullTrackWidthsNetName(Track) = NetNames[I]) then
                                begin
                                    TargetTracks[I] := Track;
                                    TrackMatches[I] := TrackMatches[I] + 1;
                                end;
                            end;
                    end;
                end;
                Primitive := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        if BeforeCount <> ExpectedCounts[1] then
        begin
            FullTrackWidthsStage(Status, 'refused_stale_track_count', 0, Completed);
            Status.Add('expected_track_count=' + IntToStr(ExpectedCounts[1]));
            Status.Add('actual_track_count=' + IntToStr(BeforeCount));
            Status.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-status.txt');
            Exit;
        end;
        for I := 1 to RowCount do
        begin
            if NetMatches[I] <> 1 then
            begin
                FullTrackWidthsStage(Status, 'refused_net_resolution', I, Completed);
                Exit;
            end;
            if (TrackMatches[I] <> 1) or (TargetTracks[I] = nil) then
            begin
                FullTrackWidthsStage(Status, 'refused_old_track_resolution', I, Completed);
                Exit;
            end;
            if NewWidthOccupied[I] then
            begin
                FullTrackWidthsStage(Status, 'refused_existing_new_width_geometry', I, Completed);
                Exit;
            end;
        end;
        for I := 1 to RowCount do
            Audit.Add(FullTrackWidthsAuditRow(Board.FileName, I, NetNames[I],
                X1s[I], Y1s[I], X2s[I], Y2s[I], OldWidths[I], NewWidths[I],
                Layers[I], -1, BeforeCount, -1, 'pending_not_started'));
        Audit.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-audit.tsv');

        for I := 1 to RowCount do
        begin
            FullTrackWidthsStage(Status, 'checking_before_row', I, Completed);
            ActiveBoard := PCBServer.GetCurrentPCBBoard;
            if ActiveBoard = nil then
            begin
                FullTrackWidthsStage(Status, 'stopped_no_active_pcb_inspect_board', I, Completed);
                Exit;
            end;
            if UpperCase(ActiveBoard.FileName) <> UpperCase(FullTrackWidthsExpectedBoard) then
            begin
                FullTrackWidthsStage(Status, 'stopped_wrong_board_inspect_board', I, Completed);
                Exit;
            end;
            CurrentCount := FullTrackWidthsCount(Board);
            if CurrentCount <> BeforeCount then
            begin
                FullTrackWidthsStage(Status, 'stopped_count_changed_inspect_board', I, Completed);
                Exit;
            end;
            ChangedTrack := TargetTracks[I];
            if (ChangedTrack.Width <> OldWidths[I]) or (ChangedTrack.Layer <> Layers[I]) or
               (FullTrackWidthsNetName(ChangedTrack) <> NetNames[I]) or
               not FullTrackWidthsSameEndpoints(ChangedTrack.X1, ChangedTrack.Y1,
                   ChangedTrack.X2, ChangedTrack.Y2, X1s[I], Y1s[I], X2s[I], Y2s[I]) then
            begin
                FullTrackWidthsStage(Status, 'stopped_old_track_changed_inspect_board', I, Completed);
                Exit;
            end;
            Audit.Strings[I] := FullTrackWidthsAuditRow(Board.FileName, I, NetNames[I],
                X1s[I], Y1s[I], X2s[I], Y2s[I], OldWidths[I], NewWidths[I],
                Layers[I], -1, CurrentCount, -1, 'applying_inspect_on_interruption');
            Audit.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-audit.tsv');
            FullTrackWidthsStage(Status, 'applying_row', I, Completed);
            PCBServer.PreProcess;
            try
                PCBServer.SendMessageToRobots(ChangedTrack.I_ObjectAddress,
                    c_Broadcast, PCBM_BeginModify, c_NoEventData);
                try
                    ChangedTrack.Width := NewWidths[I];
                finally
                    PCBServer.SendMessageToRobots(ChangedTrack.I_ObjectAddress,
                        c_Broadcast, PCBM_EndModify, c_NoEventData);
                end;
            finally
                PCBServer.PostProcess;
            end;
            FullTrackWidthsStage(Status, 'verify_track', I, Completed);
            AfterCount := FullTrackWidthsCount(Board);
            ReadbackMatches := (AfterCount = BeforeCount) and
                (ChangedTrack.Width = NewWidths[I]) and (ChangedTrack.Layer = Layers[I]) and
                (FullTrackWidthsNetName(ChangedTrack) = NetNames[I]) and
                FullTrackWidthsSameEndpoints(ChangedTrack.X1, ChangedTrack.Y1,
                    ChangedTrack.X2, ChangedTrack.Y2, X1s[I], Y1s[I], X2s[I], Y2s[I]);
            ResultName := 'failed_readback_inspect_board';
            if ReadbackMatches then ResultName := 'applied_readback_ok_drc_not_checked';
            Audit.Strings[I] := FullTrackWidthsAuditRow(Board.FileName, I,
                FullTrackWidthsNetName(ChangedTrack), ChangedTrack.X1, ChangedTrack.Y1,
                ChangedTrack.X2, ChangedTrack.Y2, OldWidths[I], NewWidths[I], ChangedTrack.Layer,
                ChangedTrack.Width, CurrentCount, AfterCount, ResultName);
            Audit.SaveToFile(FullTrackWidthsDirectory + '\full-track-widths-audit.tsv');
            if not ReadbackMatches then
            begin
                FullTrackWidthsStage(Status, ResultName, I, Completed);
                Exit;
            end;
            Inc(Completed);
            FullTrackWidthsStage(Status, 'row_readback_ok_drc_not_checked', I, Completed);
        end;
        FullTrackWidthsStage(Status, 'applied_batch_readback_ok_drc_not_checked', RowCount, Completed);
    finally
        Lines.Free;
        Fields.Free;
        Status.Free;
        Audit.Free;
    end;
end;
