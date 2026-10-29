{ Add at most 16 planned through vias after validating the complete request. }

const
    FullViaExpectedBoard = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    FullViaDirectory = 'recorded-workspace\runs\full-routing-2026-09-30\quality\full-via';

{ Parse decimal integers without accepting fractions, exponents, or overflow. }
function FullViaInteger(Text : String; var Value : Integer) : Boolean;
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

{ Record the last reached stage and the number of completed readbacks. }
procedure FullViaStage(Status : TStringList; StageName : String;
    RowIndex, Completed : Integer);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.Add('expected_board=' + FullViaExpectedBoard);
    Status.Add('row=' + IntToStr(RowIndex));
    Status.Add('completed_readbacks=' + IntToStr(Completed));
    Status.SaveToFile(FullViaDirectory + '\full-via-status.txt');
end;

{ Count vias using the same iterator scope as the qualified single-via helper. }
function FullViaCount(Board : IPCB_Board) : Integer;
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

{ Build an audit row; a negative after-count means the edit has not been counted. }
function FullViaAuditRow(BoardName : String; RowIndex : Integer;
    NetName : String; XRaw, YRaw, SizeRaw, HoleRaw, LowLayer, HighLayer,
    BeforeCount, AfterCount : Integer; ResultName : String) : String;
begin
    Result := BoardName + #9 + IntToStr(RowIndex) + #9 + NetName + #9 +
        IntToStr(XRaw) + #9 + IntToStr(YRaw) + #9 + IntToStr(SizeRaw) + #9 +
        IntToStr(HoleRaw) + #9 + IntToStr(LowLayer) + #9 +
        IntToStr(HighLayer) + #9 + IntToStr(BeforeCount) + #9;
    if AfterCount >= 0 then Result := Result + IntToStr(AfterCount);
    Result := Result + #9 + ResultName;
end;

{ Validate all rows before adding individually undo-registered Top-Bottom vias. }
procedure AddExplicitFullVias;
var
    Board, ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net : IPCB_Net;
    ExistingVia, NewVia : IPCB_Via;
    Pad : IPCB_Pad;
    Lines, Fields, Status, Audit : TStringList;
    NetNames : array[1..16] of String;
    XRaw, YRaw, SizeRaw, HoleRaw, ExpectedCounts : array[1..16] of Integer;
    NetMatches : array[1..16] of Integer;
    TargetNets : array[1..16] of IPCB_Net;
    CoordinateOccupied : array[1..16] of Boolean;
    OffsetPadMatches : array[1..16] of Integer;
    Row, ActualNetName, ResultName : String;
    Separator, I, J, RowCount, BeforeCount, AfterCount, Completed, ParsedValue : Integer;
    ReadbackMatches : Boolean;
begin
    Lines := TStringList.Create;
    Fields := TStringList.Create;
    Status := TStringList.Create;
    Audit := TStringList.Create;
    Completed := 0;
    try
        { File errors stop execution before geometry changes; the directory must exist. }
        FullViaStage(Status, 'validating_request', 0, Completed);
        Audit.Add('board' + #9 + 'row' + #9 + 'net' + #9 + 'x_raw' + #9 +
            'y_raw' + #9 + 'size_raw' + #9 + 'hole_size_raw' + #9 +
            'low_layer_id' + #9 + 'high_layer_id' + #9 + 'before_via_count' +
            #9 + 'after_via_count' + #9 + 'result');
        Audit.SaveToFile(FullViaDirectory + '\full-via-audit.tsv');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then
        begin
            FullViaStage(Status, 'refused_no_active_pcb', 0, Completed);
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullViaExpectedBoard) then
        begin
            FullViaStage(Status, 'refused_wrong_board', 0, Completed);
            Exit;
        end;
        if not FileExists(FullViaDirectory + '\add-vias.tsv') then
        begin
            FullViaStage(Status, 'refused_missing_request', 0, Completed);
            Exit;
        end;
        Lines.LoadFromFile(FullViaDirectory + '\add-vias.tsv');
        Lines.SaveToFile(FullViaDirectory + '\full-via-request.tsv');
        if (Lines.Count < 2) or (Lines.Count > 17) then
        begin
            FullViaStage(Status, 'refused_row_count', 0, Completed);
            Exit;
        end;
        if Lines.Strings[0] <> 'net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 +
            'size_raw' + #9 + 'hole_size_raw' + #9 + 'expected_via_count' then
        begin
            FullViaStage(Status, 'refused_header', 0, Completed);
            Exit;
        end;
        RowCount := Lines.Count - 1;
        for I := 1 to RowCount do
        begin
            FullViaStage(Status, 'validating_row', I, Completed);
            Fields.Clear;
            Row := Lines.Strings[I];
            for J := 1 to 5 do
            begin
                Separator := Pos(#9, Row);
                if Separator = 0 then
                begin
                    FullViaStage(Status, 'refused_columns', I, Completed);
                    Exit;
                end;
                Fields.Add(Copy(Row, 1, Separator - 1));
                Row := Copy(Row, Separator + 1, Length(Row));
            end;
            Fields.Add(Row);
            if Pos(#9, Row) > 0 then
            begin
                FullViaStage(Status, 'refused_extra_columns', I, Completed);
                Exit;
            end;
            NetNames[I] := Fields.Strings[0];
            if (NetNames[I] = '') or (NetNames[I] <> Trim(NetNames[I])) then
            begin
                FullViaStage(Status, 'refused_net_field', I, Completed);
                Exit;
            end;
            for J := 1 to 5 do
            begin
                if not FullViaInteger(Fields.Strings[J], ParsedValue) then
                begin
                    FullViaStage(Status, 'refused_numeric_field', I, Completed);
                    Exit;
                end;
                case J of
                    1: XRaw[I] := ParsedValue;
                    2: YRaw[I] := ParsedValue;
                    3: SizeRaw[I] := ParsedValue;
                    4: HoleRaw[I] := ParsedValue;
                    5: ExpectedCounts[I] := ParsedValue;
                end;
            end;
            if (XRaw[I] <= 0) or (YRaw[I] <= 0) or (SizeRaw[I] <= 0) or
               (HoleRaw[I] <= 0) or (HoleRaw[I] >= SizeRaw[I]) or
               (ExpectedCounts[I] > 2147483647 - RowCount) then
            begin
                FullViaStage(Status, 'refused_dimensions', I, Completed);
                Exit;
            end;
            if ExpectedCounts[I] <> ExpectedCounts[1] then
            begin
                FullViaStage(Status, 'refused_inconsistent_before_count', I, Completed);
                Exit;
            end;
            for J := 1 to I - 1 do
                if (XRaw[I] = XRaw[J]) and (YRaw[I] = YRaw[J]) then
                begin
                    FullViaStage(Status, 'refused_duplicate_center', I, Completed);
                    Exit;
                end;
            NetMatches[I] := 0;
            TargetNets[I] := nil;
            CoordinateOccupied[I] := False;
            OffsetPadMatches[I] := 0;
        end;

        FullViaStage(Status, 'checking_all_nets_and_centers', 0, Completed);
        BeforeCount := 0;
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
                        for I := 1 to RowCount do
                            if Net.Name = NetNames[I] then
                            begin
                                TargetNets[I] := Net;
                                NetMatches[I] := NetMatches[I] + 1;
                            end;
                    end;
                    eViaObject:
                    begin
                        ExistingVia := Primitive;
                        Inc(BeforeCount);
                        for I := 1 to RowCount do
                            if (ExistingVia.X = XRaw[I]) and (ExistingVia.Y = YRaw[I]) then
                                CoordinateOccupied[I] := True;
                    end;
                    ePadObject:
                    begin
                        Pad := Primitive;
                        for I := 1 to RowCount do
                            if (NetNames[I] = 'PCIE_TX_N') and
                               (XRaw[I] = 126371500) and (YRaw[I] = 101324600) and
                               (Pad.Name = '69') and (Pad.Layer = eBottomLayer) and
                               (Pad.X = 126368500) and (Pad.Y = 101294600) and
                               (Pad.HoleSize = 0) and (Pad.Net <> nil) then
                                if Pad.Net.Name = 'PCIE_TX_N' then
                                    OffsetPadMatches[I] := OffsetPadMatches[I] + 1;
                        for I := 1 to RowCount do
                            if (NetNames[I] = 'SD3_DATA2') and
                               (XRaw[I] = 133053200) and (YRaw[I] = 97257200) and
                               (Pad.Name = 'A5') and (Pad.Layer = eTopLayer) and
                               (Pad.X = 133053200) and (Pad.Y = 97226200) and
                               (Pad.HoleSize = 0) and (Pad.Net <> nil) then
                                if Pad.Net.Name = 'SD3_DATA2' then
                                    OffsetPadMatches[I] := OffsetPadMatches[I] + 1;
                        for I := 1 to RowCount do
                            if (Pad.X = XRaw[I]) and (Pad.Y = YRaw[I]) then
                            begin
                                { These pad centers have reviewed access; fill and cap remain unverified. }
                                if Pad.Net = nil then CoordinateOccupied[I] := True
                                else if not ((Pad.Net.Name = NetNames[I]) and
                                    ((((Pad.Name = 'B4') and (Pad.Layer = eTopLayer)) and
                                      (((NetNames[I] = 'SD3_DATA5') and
                                        (XRaw[I] = 132856300) and (YRaw[I] = 97029400)) or
                                       ((NetNames[I] = 'DRAMB_DATA6') and
                                        (XRaw[I] = 118854200) and (YRaw[I] = 91962000)))) or
                                     ((Pad.Name = 'V2') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'DRAMB_DATA4') and
                                      (XRaw[I] = 122520200) and (YRaw[I] = 93605700)) or
                                     ((Pad.Name = 'A4') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'SD3_DATA1') and
                                      (XRaw[I] = 132856300) and (YRaw[I] = 97226200)) or
                                     ((Pad.Name = 'B9') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'DSI_D0_P') and
                                      (XRaw[I] = 123898200) and (YRaw[I] = 96755300)) or
                                     ((Pad.Name = '50') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'POR_B') and
                                      (XRaw[I] = 124793700) and (YRaw[I] = 102371600)) or
                                     ((Pad.Name = 'AC26') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'ENET_RD3') and
                                      (XRaw[I] = 127244600) and (YRaw[I] = 92621500)) or
                                     ((Pad.Name = 'AB26') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'SD2_NRST') and
                                      (XRaw[I] = 127244600) and (YRaw[I] = 92818300)) or
                                     ((Pad.Name = '16') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'ECSPI2_MISO') and
                                      (XRaw[I] = 122116500) and (YRaw[I] = 102371600)) or
                                     ((Pad.Name = 'J26') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'CLKOUT2') and
                                      (XRaw[I] = 127244600) and (YRaw[I] = 95377300)) or
                                     ((Pad.Name = 'AF10') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'GPIO1_IO09') and
                                      (XRaw[I] = 124095000) and (YRaw[I] = 92030900)) or
                                     ((Pad.Name = 'AF11') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'GPIO1_IO07') and
                                      (XRaw[I] = 124291800) and (YRaw[I] = 92030900)) or
                                     ((Pad.Name = 'R1') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'DRAM_NRESET') and
                                      (XRaw[I] = 122323300) and (YRaw[I] = 94196300)) or
                                     ((Pad.Name = '56') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'GPIO1_IO07') and
                                      (XRaw[I] = 128566100) and (YRaw[I] = 85226800)) or
                                     ((Pad.Name = '62') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'GPIO1_IO05') and
                                      (XRaw[I] = 129038500) and (YRaw[I] = 85226800)) or
                                     ((Pad.Name = 'M26') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'SD3_DATA0') and
                                      (XRaw[I] = 127244600) and (YRaw[I] = 94786800)) or
                                     ((Pad.Name = '55') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SAI3_RXD') and
                                      (XRaw[I] = 128566100) and (YRaw[I] = 86439400)) or
                                     ((Pad.Name = '51') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SAI3_RXFS') and
                                      (XRaw[I] = 128251100) and (YRaw[I] = 86439400)) or
                                     ((Pad.Name = '84') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SD2_DATA0') and
                                      (XRaw[I] = 127470800) and (YRaw[I] = 102371600)) or
                                     ((Pad.Name = 'C5') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'GND') and
                                      (XRaw[I] = 123110800) and (YRaw[I] = 96558500)) or
                                     ((Pad.Name = 'B17') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'CSI_D2_P') and
                                      (XRaw[I] = 125473000) and (YRaw[I] = 96755300)) or
                                     ((Pad.Name = '1') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'XTALO_24M') and
                                      (XRaw[I] = 130092000) and (YRaw[I] = 97189400)) or
                                     ((Pad.Name = '23') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SAI2_RXD') and
                                      (XRaw[I] = 134539800) and (YRaw[I] = 88028000)) or
                                     ((Pad.Name = '90') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SAI1_RXD5') and
                                      (XRaw[I] = 131243300) and (YRaw[I] = 85226800)) or
                                     ((Pad.Name = '86') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SAI1_RXD3') and
                                      (XRaw[I] = 130928300) and (YRaw[I] = 85226800)) or
                                     ((Pad.Name = 'M6') and (Pad.Layer = eTopLayer) and
                                      (NetNames[I] = 'SD3_CLK') and
                                      (XRaw[I] = 133250000) and (YRaw[I] = 95060900)) or
                                     ((Pad.Name = '66') and (Pad.Layer = eBottomLayer) and
                                      (NetNames[I] = 'SAI2_MCLK') and
                                      (XRaw[I] = 129353500) and (YRaw[I] = 85226800)) or
                                     ((Pad.Layer = eBottomLayer) and (NetNames[I] = 'GND') and
                                      (XRaw[I] = 134539800) and
                                      (((Pad.Name = '19') and (YRaw[I] = 88342900)) or
                                       ((Pad.Name = '9') and (YRaw[I] = 89130300))))) and
                                    (Pad.HoleSize = 0) and
                                    (SizeRaw[I] = 160000) and (HoleRaw[I] = 80000)) then
                                    CoordinateOccupied[I] := True;
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
            FullViaStage(Status, 'refused_stale_via_count', 0, Completed);
            Status.Add('expected_via_count=' + IntToStr(ExpectedCounts[1]));
            Status.Add('actual_via_count=' + IntToStr(BeforeCount));
            Status.SaveToFile(FullViaDirectory + '\full-via-status.txt');
            Exit;
        end;
        for I := 1 to RowCount do
        begin
            if (NetMatches[I] <> 1) or (TargetNets[I] = nil) then
            begin
                FullViaStage(Status, 'refused_net_resolution', I, Completed);
                Exit;
            end;
            if (NetNames[I] = 'SD3_DATA2') and
               (XRaw[I] = 133053200) and (YRaw[I] = 97257200) and
               ((OffsetPadMatches[I] <> 1) or (SizeRaw[I] <> 160000) or (HoleRaw[I] <> 80000)) then
            begin
                FullViaStage(Status, 'refused_data2_offset_pad_guard', I, Completed);
                Exit;
            end;
            if (NetNames[I] = 'PCIE_TX_N') and
               (XRaw[I] = 126371500) and (YRaw[I] = 101324600) and
               ((OffsetPadMatches[I] <> 1) or (SizeRaw[I] <> 160000) or (HoleRaw[I] <> 80000)) then
            begin
                FullViaStage(Status, 'refused_pcie_offset_pad_guard', I, Completed);
                Exit;
            end;
            if CoordinateOccupied[I] then
            begin
                FullViaStage(Status, 'refused_occupied_coordinate', I, Completed);
                Exit;
            end;
        end;
        for I := 1 to RowCount do
            Audit.Add(FullViaAuditRow(Board.FileName, I, NetNames[I], XRaw[I],
                YRaw[I], SizeRaw[I], HoleRaw[I], eTopLayer, eBottomLayer,
                BeforeCount + I - 1, -1, 'pending_not_started'));
        Audit.SaveToFile(FullViaDirectory + '\full-via-audit.tsv');

        for I := 1 to RowCount do
        begin
            FullViaStage(Status, 'checking_before_row', I, Completed);
            ActiveBoard := PCBServer.GetCurrentPCBBoard;
            if ActiveBoard = nil then
            begin
                FullViaStage(Status, 'stopped_no_active_pcb_inspect_board', I, Completed);
                Exit;
            end;
            if UpperCase(ActiveBoard.FileName) <> UpperCase(FullViaExpectedBoard) then
            begin
                FullViaStage(Status, 'stopped_wrong_board_inspect_board', I, Completed);
                Exit;
            end;
            if FullViaCount(Board) <> BeforeCount + I - 1 then
            begin
                FullViaStage(Status, 'stopped_count_changed_inspect_board', I, Completed);
                Exit;
            end;
            Audit.Strings[I] := FullViaAuditRow(Board.FileName, I, NetNames[I],
                XRaw[I], YRaw[I], SizeRaw[I], HoleRaw[I], eTopLayer, eBottomLayer,
                BeforeCount + I - 1, -1, 'creating_inspect_on_interruption');
            Audit.SaveToFile(FullViaDirectory + '\full-via-audit.tsv');
            FullViaStage(Status, 'create_via', I, Completed);
            PCBServer.PreProcess;
            try
                NewVia := PCBServer.PCBObjectFactory(eViaObject, eNoDimension, eCreate_Default);
                if NewVia = nil then
                begin
                    FullViaStage(Status, 'failed_factory_inspect_board', I, Completed);
                    Exit;
                end;
                NewVia.X := XRaw[I];
                NewVia.Y := YRaw[I];
                NewVia.Size := SizeRaw[I];
                NewVia.HoleSize := HoleRaw[I];
                NewVia.LowLayer := eTopLayer;
                NewVia.HighLayer := eBottomLayer;
                NewVia.Net := TargetNets[I];
                FullViaStage(Status, 'add_and_register_via', I, Completed);
                Board.AddPCBObject(NewVia);
                PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast,
                    PCBM_BoardRegisteration, NewVia.I_ObjectAddress);
            finally
                PCBServer.PostProcess;
            end;
            FullViaStage(Status, 'verify_via', I, Completed);
            AfterCount := FullViaCount(Board);
            ActualNetName := '';
            if NewVia.Net <> nil then ActualNetName := NewVia.Net.Name;
            ReadbackMatches := (AfterCount = BeforeCount + I) and
                (NewVia.X = XRaw[I]) and (NewVia.Y = YRaw[I]) and
                (NewVia.Size = SizeRaw[I]) and (NewVia.HoleSize = HoleRaw[I]) and
                (NewVia.LowLayer = eTopLayer) and (NewVia.HighLayer = eBottomLayer) and
                (ActualNetName = NetNames[I]);
            ResultName := 'failed_readback_inspect_board';
            if ReadbackMatches then ResultName := 'added_readback_ok_drc_not_checked';
            Audit.Strings[I] := FullViaAuditRow(Board.FileName, I, ActualNetName,
                NewVia.X, NewVia.Y, NewVia.Size, NewVia.HoleSize,
                NewVia.LowLayer, NewVia.HighLayer, BeforeCount + I - 1,
                AfterCount, ResultName);
            Audit.SaveToFile(FullViaDirectory + '\full-via-audit.tsv');
            if not ReadbackMatches then
            begin
                FullViaStage(Status, ResultName, I, Completed);
                Exit;
            end;
            Inc(Completed);
            FullViaStage(Status, 'row_readback_ok_drc_not_checked', I, Completed);
        end;
        FullViaStage(Status, 'added_batch_readback_ok_drc_not_checked', RowCount, Completed);
    finally
        Lines.Free;
        Fields.Free;
        Status.Free;
        Audit.Free;
    end;
end;

{ Relocate the reviewed ENET_RX_CTL access via with exact identity and count guards. }
procedure RepairEthernetAccessVia;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Status : TStringList;
    Matches : Integer;
    Occupied : Boolean;
begin
    Status := TStringList.Create;
    try
        Status.Add('validating_exact_repair');
        Status.SaveToFile(FullViaDirectory + '\repair041-status.txt');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then Exit;
        if UpperCase(Board.FileName) <> UpperCase(FullViaExpectedBoard) then Exit;
        if FullViaCount(Board) <> 583 then Exit;
        TargetVia := nil;
        Matches := 0;
        Occupied := False;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Via := Iterator.FirstPCBObject;
            while Via <> nil do
            begin
                if (Via.X = 135088400) and (Via.Y = 91451100) then Occupied := True;
                if (Via.X = 135168400) and (Via.Y = 91511100) and
                   (Via.Size = 160000) and (Via.HoleSize = 80000) and
                   (Via.LowLayer = eTopLayer) and (Via.HighLayer = eBottomLayer) then
                    if Via.Net <> nil then
                        if Via.Net.Name = 'ENET_RX_CTL' then
                        begin
                            TargetVia := Via;
                            Inc(Matches);
                        end;
                Via := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        if (Matches <> 1) or Occupied then
        begin
            Status.Add('refused_identity_or_occupied_center');
            Status.SaveToFile(FullViaDirectory + '\repair041-status.txt');
            Exit;
        end;
        Status.Add('moving_inspect_on_interruption');
        Status.SaveToFile(FullViaDirectory + '\repair041-status.txt');
        PCBServer.PreProcess;
        try
            PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,
                c_Broadcast, PCBM_BeginModify, c_NoEventData);
            try
                TargetVia.X := 135088400;
                TargetVia.Y := 91451100;
            finally
                PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,
                    c_Broadcast, PCBM_EndModify, c_NoEventData);
            end;
        finally
            PCBServer.PostProcess;
        end;
        if (FullViaCount(Board) = 583) and
           (TargetVia.X = 135088400) and (TargetVia.Y = 91451100) and
           (TargetVia.Size = 160000) and (TargetVia.HoleSize = 80000) and
           (TargetVia.LowLayer = eTopLayer) and (TargetVia.HighLayer = eBottomLayer) and
           (TargetVia.Net.Name = 'ENET_RX_CTL') then
            Status.Add('moved_readback_ok_drc_not_checked')
        else
            Status.Add('failed_readback_inspect_board');
        Status.SaveToFile(FullViaDirectory + '\repair041-status.txt');
    finally
        Status.Free;
    end;
end;
