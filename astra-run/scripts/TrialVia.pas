{ Add an explicit via or one fixed LED stub to a disposable trial PCB. }

function TrialViaExpectedBoard : String;
begin
    Result := AstraWorkspacePath('TrialVia.PrjScr', 'trials\routing-50-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function TrialViaDirectory : String;
begin
    Result := AstraWorkspacePath('TrialVia.PrjScr', 'runs\current-inspection');
end;

{ Parse decimal integers without accepting fractions, exponents, or overflow. }
function TrialViaInteger(Text : String; var Value : Integer) : Boolean;
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

{ Select the one trial PMIC_NINT segment identified by the native DRC report. }
procedure SelectTrialDrcFailureTracks;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Track, TargetTrack : IPCB_Track;
    Matches : Integer;
    EndpointsMatch : Boolean;
begin
    Board := PCBServer.GetCurrentPCBBoard;
    if Board = nil then
    begin
        ShowMessage('Activate the routing-50 trial PCB. Selection unchanged.');
        Exit;
    end;
    if UpperCase(Board.FileName) <> UpperCase(TrialViaExpectedBoard) then
    begin
        ShowMessage('The active PCB is not the exact routing-50 trial. Selection unchanged.');
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
                ((Track.X1 = 124701782) and (Track.Y1 = 91731029) and
                 (Track.X2 = 124785100) and (Track.Y2 = 91834000)) or
                ((Track.X2 = 124701782) and (Track.Y2 = 91731029) and
                 (Track.X1 = 124785100) and (Track.Y1 = 91834000));
            if EndpointsMatch and (Track.Width = 41000) and
               (Track.Layer = eTopLayer) then
                if Track.Net <> nil then
                    if Track.Net.Name = 'PMIC_NINT' then
                    begin
                        TargetTrack := Track;
                        Inc(Matches);
                    end;
            Track := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
    if Matches <> 1 then
    begin
        ShowMessage('Expected exactly one matching PMIC_NINT DRC segment. Selection unchanged.');
        Exit;
    end;
    { Use native Deselect All first: AllLayers omits some mechanical layers. }
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(AllPrimitives);
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Primitive := Iterator.FirstPCBObject;
        while Primitive <> nil do
        begin
            Primitive.Selected := False;
            Primitive := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
    TargetTrack.Selected := True;
    Client.SendMessage('PCB:Zoom', 'Action=Redraw', 255, Client.CurrentView);
    if not TargetTrack.Selected then
    begin
        ShowMessage('The PMIC_NINT segment selection did not read back. Inspect selection before continuing.');
        Exit;
    end;
    ShowMessage('Selected 1 exact PMIC_NINT DRC segment. No geometry changed or saved.');
end;

{ Join only the verified D1-C pad and its explicit trial via with one Top segment. }
procedure ConnectTrialLedViaToPad;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Pad, LedPad : IPCB_Pad;
    Via, LedVia : IPCB_Via;
    Net, TargetNet : IPCB_Net;
    Track, NewTrack : IPCB_Track;
    PadMatches, ViaMatches, NetMatches, ViaCount : Integer;
    BeforeTracks, AfterTracks, LengthRaw : Integer;
    ExistingTrackFound, EndpointsMatch : Boolean;
    Audit : TStringList;
    AuditRow : String;
begin
    Board := PCBServer.GetCurrentPCBBoard;
    if Board = nil then
    begin
        ShowMessage('Activate the routing-50 trial PCB. No geometry changed.');
        Exit;
    end;
    if UpperCase(Board.FileName) <> UpperCase(TrialViaExpectedBoard) then
    begin
        ShowMessage('The active PCB is not the exact routing-50 trial. No geometry changed.');
        Exit;
    end;
    if not DirectoryExists(TrialViaDirectory) then
    begin
        ShowMessage('Missing trial inspection directory. No geometry changed.');
        Exit;
    end;
    LedPad := nil;
    LedVia := nil;
    TargetNet := nil;
    PadMatches := 0;
    ViaMatches := 0;
    NetMatches := 0;
    ViaCount := 0;
    BeforeTracks := 0;
    ExistingTrackFound := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(ePadObject, eViaObject, eNetObject, eTrackObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Primitive := Iterator.FirstPCBObject;
        while Primitive <> nil do
        begin
            case Primitive.ObjectId of
                ePadObject:
                begin
                    Pad := Primitive;
                    if Pad.Component <> nil then
                        if (Pad.Component.Name.Text = 'D1') and (Pad.Name = 'C') then
                        begin
                            LedPad := Pad;
                            Inc(PadMatches);
                        end;
                end;
                eViaObject:
                begin
                    Via := Primitive;
                    Inc(ViaCount);
                    if (Via.X = 131936400) and (Via.Y = 99451500) then
                    begin
                        LedVia := Via;
                        Inc(ViaMatches);
                    end;
                end;
                eNetObject:
                begin
                    Net := Primitive;
                    if Net.Name = 'NetD1_C' then
                    begin
                        TargetNet := Net;
                        Inc(NetMatches);
                    end;
                end;
                eTrackObject:
                begin
                    Track := Primitive;
                    Inc(BeforeTracks);
                    if Track.Net <> nil then
                        if Track.Net.Name = 'NetD1_C' then ExistingTrackFound := True;
                    if (Track.X1 = 131936400) and (Track.X2 = 131936400) then
                        if ((Track.Y1 = 99951500) and (Track.Y2 = 99451500)) or
                           ((Track.Y1 = 99451500) and (Track.Y2 = 99951500)) then
                            ExistingTrackFound := True;
                end;
            end;
            Primitive := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
    if (PadMatches <> 1) or (ViaMatches <> 1) or (NetMatches <> 1) or
       (ViaCount <> 373) or ExistingTrackFound then
    begin
        ShowMessage('Expected one D1-C pad, one chosen via, one NetD1_C net, 373 total vias, and no existing LED track. No geometry changed.');
        Exit;
    end;
    if (LedPad.Net = nil) or (LedVia.Net = nil) then
    begin
        ShowMessage('The LED pad and via must both have nets. No geometry changed.');
        Exit;
    end;
    if (LedPad.Net.Name <> 'NetD1_C') or (LedVia.Net.Name <> 'NetD1_C') or
       (LedPad.Layer <> eTopLayer) or (LedPad.X <> 131936400) or
       (LedPad.Y <> 99951500) or (LedVia.Size <> 160000) or
       (LedVia.HoleSize <> 80000) or (LedVia.LowLayer <> eTopLayer) or
       (LedVia.HighLayer <> eBottomLayer) then
    begin
        ShowMessage('The exact LED pad/via geometry or net does not match. No geometry changed.');
        Exit;
    end;
    LengthRaw := LedPad.Y - LedVia.Y;
    if (LedPad.X <> LedVia.X) or (LengthRaw <= 0) or (LengthRaw > 600000) then
    begin
        ShowMessage('Expected a positive vertical segment no longer than 60 mil. No geometry changed.');
        Exit;
    end;
    Audit := TStringList.Create;
    try
        Audit.Add('board' + #9 + 'net' + #9 + 'x1_raw' + #9 + 'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 + 'width_raw' + #9 + 'layer_id' + #9 + 'before_track_count' + #9 + 'after_track_count' + #9 + 'result');
        AuditRow := Board.FileName + #9 + 'NetD1_C' + #9 + '131936400' + #9 + '99951500' + #9 + '131936400' + #9 + '99451500' + #9 + '41000' + #9 + '1' + #9 + IntToStr(BeforeTracks);
        Audit.Add(AuditRow + #9 + '' + #9 + 'pending');
        Audit.SaveToFile(TrialViaDirectory + '\led-stub-audit.tsv');
        PCBServer.PreProcess;
        try
            NewTrack := PCBServer.PCBObjectFactory(eTrackObject, eNoDimension, eCreate_Default);
            if NewTrack = nil then
            begin
                ShowMessage('The track factory returned nil. No track was added.');
                Exit;
            end;
            NewTrack.X1 := LedPad.X;
            NewTrack.Y1 := LedPad.Y;
            NewTrack.X2 := LedVia.X;
            NewTrack.Y2 := LedVia.Y;
            NewTrack.Width := 41000;
            NewTrack.Layer := eTopLayer;
            NewTrack.Net := TargetNet;
            Board.AddPCBObject(NewTrack);
            PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast,
                PCBM_BoardRegisteration, NewTrack.I_ObjectAddress);
        finally
            PCBServer.PostProcess;
        end;
        AfterTracks := 0;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Track := Iterator.FirstPCBObject;
            while Track <> nil do
            begin
                Inc(AfterTracks);
                Track := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        { Altium can reverse a track's endpoints when it adds the object. }
        EndpointsMatch := (NewTrack.X1 = 131936400) and (NewTrack.X2 = 131936400) and
            (((NewTrack.Y1 = 99951500) and (NewTrack.Y2 = 99451500)) or
             ((NewTrack.Y1 = 99451500) and (NewTrack.Y2 = 99951500)));
        AuditRow := Board.FileName + #9;
        if NewTrack.Net <> nil then AuditRow := AuditRow + NewTrack.Net.Name;
        AuditRow := AuditRow + #9 + IntToStr(NewTrack.X1) + #9 + IntToStr(NewTrack.Y1) + #9 + IntToStr(NewTrack.X2) + #9 + IntToStr(NewTrack.Y2) + #9 + IntToStr(NewTrack.Width) + #9 + IntToStr(NewTrack.Layer) + #9 + IntToStr(BeforeTracks);
        Audit.Strings[1] := AuditRow + #9 + IntToStr(AfterTracks) + #9 + 'added_pending_validation';
        Audit.SaveToFile(TrialViaDirectory + '\led-stub-audit.tsv');
        if (AfterTracks <> BeforeTracks + 1) or not EndpointsMatch or
           (NewTrack.Width <> 41000) or
           (NewTrack.Layer <> eTopLayer) or (NewTrack.Net = nil) then
        begin
            ShowMessage('LED track readback failed after the edit. Inspect the board before continuing.');
            Exit;
        end;
        if NewTrack.Net.Name <> 'NetD1_C' then
        begin
            ShowMessage('LED track net readback failed after the edit. Inspect the board before continuing.');
            Exit;
        end;
        Audit.Strings[1] := AuditRow + #9 + IntToStr(AfterTracks) + #9 + 'added_readback_ok_drc_not_checked';
        Audit.SaveToFile(TrialViaDirectory + '\led-stub-audit.tsv');
        Board.ViewManager_FullUpdate;
        Client.SendMessage('PCB:Zoom', 'Action=Redraw', 255, Client.CurrentView);
        ShowMessage('Added one 50 mil, 4.1 mil wide Top LED stub. The complete net is not yet verified. No routing or save command ran.');
    finally
        Audit.Free;
    end;
end;

{ Record the last reached stage, including failures before a geometry edit. }
procedure TrialViaStage(Status : TStringList; StageName : String);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.SaveToFile(TrialViaDirectory + '\trial-via-status.txt');
end;

{ Count existing vias using the same iterator scope as the qualified inventory. }
function TrialViaCount(Board : IPCB_Board) : Integer;
var
    Iterator : IPCB_BoardIterator;
    Via : IPCB_Via;
begin
    Result := 0;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            Inc(Result);
            Via := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
end;

{ Validate one request, then add one undo-registered via without routing or saving. }
procedure AddExplicitTrialVia;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    TargetNet, Net : IPCB_Net;
    ExistingVia, NewVia : IPCB_Via;
    Pad : IPCB_Pad;
    Lines, Fields, Status, Audit : TStringList;
    Row, NetName, AuditRow : String;
    Separator, I, XRaw, YRaw, SizeRaw, HoleRaw : Integer;
    ExpectedCount, BeforeCount, AfterCount, NetMatches : Integer;
    CoordinateOccupied : Boolean;
begin
    if not DirectoryExists(TrialViaDirectory) then
    begin
        ShowMessage('Missing trial inspection directory. No geometry changed.');
        Exit;
    end;
    Lines := TStringList.Create;
    Fields := TStringList.Create;
    Status := TStringList.Create;
    Audit := TStringList.Create;
    try
        TrialViaStage(Status, 'validating');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then
        begin
            TrialViaStage(Status, 'refused_no_active_pcb');
            ShowMessage('Activate the routing-50 trial PCB. No geometry changed.');
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(TrialViaExpectedBoard) then
        begin
            TrialViaStage(Status, 'refused_wrong_board');
            ShowMessage('The active PCB is not the exact routing-50 trial. No geometry changed.');
            Exit;
        end;
        if not FileExists(TrialViaDirectory + '\add-via.tsv') then
        begin
            TrialViaStage(Status, 'refused_missing_request');
            ShowMessage('Missing add-via.tsv. No geometry changed.');
            Exit;
        end;
        Lines.LoadFromFile(TrialViaDirectory + '\add-via.tsv');
        if Lines.Count <> 2 then
        begin
            TrialViaStage(Status, 'refused_row_count');
            ShowMessage('add-via.tsv requires exactly one header and one data row. No geometry changed.');
            Exit;
        end;
        if Lines.Strings[0] <> 'net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'size_raw' + #9 + 'hole_size_raw' + #9 + 'expected_via_count' then
        begin
            TrialViaStage(Status, 'refused_header');
            ShowMessage('Unexpected add-via.tsv header. No geometry changed.');
            Exit;
        end;
        Row := Lines.Strings[1];
        for I := 1 to 5 do
        begin
            Separator := Pos(#9, Row);
            if Separator = 0 then
            begin
                TrialViaStage(Status, 'refused_columns');
                ShowMessage('Expected exactly six tab-separated fields. No geometry changed.');
                Exit;
            end;
            Fields.Add(Copy(Row, 1, Separator - 1));
            Row := Copy(Row, Separator + 1, Length(Row));
        end;
        Fields.Add(Row);
        if Pos(#9, Row) > 0 then
        begin
            TrialViaStage(Status, 'refused_extra_columns');
            ShowMessage('Expected exactly six tab-separated fields. No geometry changed.');
            Exit;
        end;
        NetName := Fields.Strings[0];
        if (NetName = '') or (NetName <> Trim(NetName)) then
        begin
            TrialViaStage(Status, 'refused_net_field');
            ShowMessage('An exact nonempty net name is required. No geometry changed.');
            Exit;
        end;
        if not TrialViaInteger(Fields.Strings[1], XRaw) or
           not TrialViaInteger(Fields.Strings[2], YRaw) or
           not TrialViaInteger(Fields.Strings[3], SizeRaw) or
           not TrialViaInteger(Fields.Strings[4], HoleRaw) or
           not TrialViaInteger(Fields.Strings[5], ExpectedCount) then
        begin
            TrialViaStage(Status, 'refused_numeric_field');
            ShowMessage('Raw values and count must be decimal integers from 0 through 2147483647. No geometry changed.');
            Exit;
        end;
        if (XRaw <= 0) or (YRaw <= 0) or (SizeRaw <= 0) or
           (HoleRaw <= 0) or (HoleRaw >= SizeRaw) or
           (ExpectedCount = 2147483647) then
        begin
            TrialViaStage(Status, 'refused_dimensions');
            ShowMessage('Coordinates and dimensions must be positive; the hole must be smaller than the diameter. No geometry changed.');
            Exit;
        end;

        TargetNet := nil;
        NetMatches := 0;
        BeforeCount := 0;
        CoordinateOccupied := False;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eNetObject, eViaObject, ePadObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Primitive := Iterator.FirstPCBObject;
            while Primitive <> nil do
            begin
                case Primitive.ObjectId of
                    eNetObject:
                    begin
                        Net := Primitive;
                        if Net.Name = NetName then
                        begin
                            TargetNet := Net;
                            Inc(NetMatches);
                        end;
                    end;
                    eViaObject:
                    begin
                        ExistingVia := Primitive;
                        Inc(BeforeCount);
                        if (ExistingVia.X = XRaw) and (ExistingVia.Y = YRaw) then
                            CoordinateOccupied := True;
                    end;
                    ePadObject:
                    begin
                        Pad := Primitive;
                        if (Pad.X = XRaw) and (Pad.Y = YRaw) then
                            CoordinateOccupied := True;
                    end;
                end;
                Primitive := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        if NetMatches <> 1 then
        begin
            TrialViaStage(Status, 'refused_net_resolution');
            ShowMessage('The exact net must resolve to one existing net. No geometry changed.');
            Exit;
        end;
        if BeforeCount <> ExpectedCount then
        begin
            TrialViaStage(Status, 'refused_stale_via_count');
            ShowMessage('Expected ' + IntToStr(ExpectedCount) + ' vias but found ' + IntToStr(BeforeCount) + '. No geometry changed.');
            Exit;
        end;
        if CoordinateOccupied then
        begin
            TrialViaStage(Status, 'refused_occupied_coordinate');
            ShowMessage('A via or pad already has this center coordinate. No geometry changed.');
            Exit;
        end;

        Audit.Add('board' + #9 + 'net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'size_raw' + #9 + 'hole_size_raw' + #9 + 'low_layer_id' + #9 + 'high_layer_id' + #9 + 'before_via_count' + #9 + 'after_via_count' + #9 + 'result');
        AuditRow := Board.FileName + #9 + NetName + #9 + IntToStr(XRaw) + #9 + IntToStr(YRaw) + #9 + IntToStr(SizeRaw) + #9 + IntToStr(HoleRaw) + #9 + '1' + #9 + '32' + #9 + IntToStr(BeforeCount);
        Audit.Add(AuditRow + #9 + '' + #9 + 'pending');
        Audit.SaveToFile(TrialViaDirectory + '\trial-via-audit.tsv');
        TrialViaStage(Status, 'create_via');
        PCBServer.PreProcess;
        try
            NewVia := PCBServer.PCBObjectFactory(eViaObject, eNoDimension, eCreate_Default);
            if NewVia = nil then
            begin
                TrialViaStage(Status, 'failed_factory');
                ShowMessage('The via factory returned nil. No via was added.');
                Exit;
            end;
            NewVia.X := XRaw;
            NewVia.Y := YRaw;
            NewVia.Size := SizeRaw;
            NewVia.HoleSize := HoleRaw;
            NewVia.LowLayer := eTopLayer;
            NewVia.HighLayer := eBottomLayer;
            NewVia.Net := TargetNet;
            TrialViaStage(Status, 'add_and_register_via');
            Board.AddPCBObject(NewVia);
            PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast,
                PCBM_BoardRegisteration, NewVia.I_ObjectAddress);
        finally
            PCBServer.PostProcess;
        end;
        TrialViaStage(Status, 'verify_via');
        AfterCount := TrialViaCount(Board);
        if (AfterCount <> BeforeCount + 1) or (NewVia.X <> XRaw) or
           (NewVia.Y <> YRaw) or (NewVia.Size <> SizeRaw) or
           (NewVia.HoleSize <> HoleRaw) or (NewVia.LowLayer <> eTopLayer) or
           (NewVia.HighLayer <> eBottomLayer) or (NewVia.Net = nil) then
        begin
            TrialViaStage(Status, 'failed_readback_inspect_board');
            ShowMessage('Via readback or count failed after the edit. Inspect the board and qualify Undo before continuing.');
            Exit;
        end;
        if NewVia.Net.Name <> NetName then
        begin
            TrialViaStage(Status, 'failed_net_readback_inspect_board');
            ShowMessage('Via net readback failed after the edit. Inspect the board before continuing.');
            Exit;
        end;
        Audit.Strings[1] := AuditRow + #9 + IntToStr(AfterCount) + #9 + 'added_readback_ok';
        Audit.SaveToFile(TrialViaDirectory + '\trial-via-audit.tsv');
        TrialViaStage(Status, 'added_readback_ok_drc_not_checked');
        Board.ViewManager_FullUpdate;
        Client.SendMessage('PCB:Zoom', 'Action=Redraw', 255, Client.CurrentView);
        ShowMessage('Added one through via on ' + NetName + '. Geometry, DRC, Undo, and save verification are still required.');
    finally
        Lines.Free;
        Fields.Free;
        Status.Free;
        Audit.Free;
    end;
end;
