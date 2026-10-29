{ Apply at most 64 explicit track endpoint edits and additions after preflight. }

const
    FullTracksL2Layer = 2; { L2_GND_1, limited to reviewed additions. }
    FullTracksL3Layer = 3; { L3_IN1, legacy MidLayer2 on the guarded board. }
    FullTracksL4Layer = 4; { Positive copper, empty in saved checkpoint 034. }
    FullTracksL6Layer = 6; { L6_PWR_2, legacy MidLayer5 on the guarded board. }
    FullTracksL7Layer = 7; { L7_GND_3, limited to reviewed additions. }
    FullTracksExpectedBoard = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    FullTracksDirectory = 'recorded-workspace\runs\full-routing-2026-09-30\quality\full-tracks';

{ Native width229 confirms 3.2-10 mil on L6 for these exact nets. }
function FullTracksL6Net(NetName : String) : Boolean;
begin
    Result := (NetName = 'BT_WAKE_DEV') or
        (NetName = 'CLKIN2') or
        (NetName = 'CLKOUT1') or
        (NetName = 'CLKOUT2') or
        (NetName = 'CLK_32K_OUT') or
        (NetName = 'DRAMA_CA4') or
        (NetName = 'DRAMA_CA5') or
        (NetName = 'DRAMA_CKE0') or
        (NetName = 'DRAMA_CKE1') or
        (NetName = 'DRAMA_DATA1') or
        (NetName = 'DRAMA_DATA3') or
        (NetName = 'DRAMA_DATA5') or
        (NetName = 'DRAMA_nCS0') or
        (NetName = 'DRAMB_CA4') or
        (NetName = 'DRAMB_CA5') or
        (NetName = 'DRAMB_CKE0') or
        (NetName = 'DRAMB_CKE1') or
        (NetName = 'DRAMB_DATA0') or
        (NetName = 'DRAMB_DATA1') or
        (NetName = 'DRAMB_DATA10') or
        (NetName = 'DRAMB_DATA11') or
        (NetName = 'DRAMB_DATA5') or
        (NetName = 'DRAMB_nCS0') or
        (NetName = 'DRAM_NRESET') or
        (NetName = 'ECSPI2_MISO') or
        (NetName = 'ECSPI2_MOSI') or
        (NetName = 'ECSPI2_SCLK') or
        (NetName = 'ECSPI2_SS0') or
        (NetName = 'ENET_MDC') or
        (NetName = 'ENET_RD2') or
        (NetName = 'ENET_RD3') or
        (NetName = 'ENET_RXC') or
        (NetName = 'ENET_TD0') or
        (NetName = 'ENET_TD1') or
        (NetName = 'ENET_TD2') or
        (NetName = 'ENET_TD3') or
        (NetName = 'GPIO1_IO05') or
        (NetName = 'GPIO1_IO07') or
        (NetName = 'GPIO1_IO09') or
        (NetName = 'I2C3_SDA') or
        (NetName = 'JTAG_TCK') or
        (NetName = 'JTAG_TDO') or
        (NetName = 'NetR30_1') or
        (NetName = 'NetR7_2') or
        (NetName = 'PDM_CLK') or
        (NetName = 'PDM_DATA3') or
        (NetName = 'PMIC_STBY_REQ') or
        (NetName = 'QSPIA_NSS0') or
        (NetName = 'QSPIA_SCLK') or
        (NetName = 'RTC_RESET_B') or
        (NetName = 'SAI1_MCLK') or
        (NetName = 'SAI1_RXC') or
        (NetName = 'SAI1_RXD0') or
        (NetName = 'SAI1_RXD1') or
        (NetName = 'SAI1_RXD3') or
        (NetName = 'SAI1_RXD4') or
        (NetName = 'SAI1_RXD5') or
        (NetName = 'SAI1_RXD6') or
        (NetName = 'SAI1_RXD7') or
        (NetName = 'SAI1_RXFS') or
        (NetName = 'SAI1_TXD0') or
        (NetName = 'SAI1_TXD1') or
        (NetName = 'SAI1_TXD2') or
        (NetName = 'SAI1_TXD3') or
        (NetName = 'SAI1_TXD4') or
        (NetName = 'SAI1_TXD5') or
        (NetName = 'SAI1_TXD7') or
        (NetName = 'SAI2_MCLK') or
        (NetName = 'SAI2_RXC') or
        (NetName = 'SAI2_RXD') or
        (NetName = 'SAI2_RXFS') or
        (NetName = 'SAI2_TXC') or
        (NetName = 'SAI2_TXD') or
        (NetName = 'SAI2_TXFS') or
        (NetName = 'SAI3_MCLK') or
        (NetName = 'SAI3_TXFS') or
        (NetName = 'SAI5_MCLK') or
        (NetName = 'SAI5_RXFS') or
        (NetName = 'SD1_DATA0') or
        (NetName = 'SD1_DATA1') or
        (NetName = 'SD1_DATA3') or
        (NetName = 'SD1_STROBE') or
        (NetName = 'SD2_CLK') or
        (NetName = 'SD2_CMD') or
        (NetName = 'SD2_DATA3') or
        (NetName = 'SD2_NCD') or
        (NetName = 'SD2_NRST') or
        (NetName = 'SD3_CLK') or
        (NetName = 'SD3_CMD') or
        (NetName = 'SD3_DATA1') or
        (NetName = 'SD3_DATA2') or
        (NetName = 'SD3_DATA3') or
        (NetName = 'SD3_DATA4') or
        (NetName = 'SD3_DATA6') or
        (NetName = 'SYS_STATUS') or
        (NetName = 'UART1_RTS') or
        (NetName = 'UART1_RXD') or
        (NetName = 'UART3_RTS') or
        (NetName = 'UART3_TXD') or
        (NetName = 'VDDA_1V8') or
        (NetName = 'NVCC_SNVS_1V8') or
        (NetName = 'WL_WAKE_HOST') or
        (NetName = 'XTALI_24M') or
        (NetName = 'XTALI_32K') or
        (NetName = 'XTALO_24M') or
        (NetName = 'XTALO_32K');
end;

{ Parse unsigned decimal integers without overflow or other numeric syntax. }
function FullTracksInteger(Text : String; var Value : Integer) : Boolean;
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
function FullTracksSameEndpoints(AX1, AY1, AX2, AY2,
    BX1, BY1, BX2, BY2 : Integer) : Boolean;
begin
    Result := ((AX1 = BX1) and (AY1 = BY1) and (AX2 = BX2) and (AY2 = BY2)) or
        ((AX1 = BX2) and (AY1 = BY2) and (AX2 = BX1) and (AY2 = BY1));
end;

{ Return an empty name for an unassigned track. }
function FullTracksNetName(Track : IPCB_Track) : String;
begin
    Result := '';
    if Track.Net <> nil then Result := Track.Net.Name;
end;

{ Record the last stage and the number of completed readbacks. }
procedure FullTracksStage(Status : TStringList; StageName : String;
    RowIndex, Completed : Integer);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.Add('expected_board=' + FullTracksExpectedBoard);
    Status.Add('row=' + IntToStr(RowIndex));
    Status.Add('completed_readbacks=' + IntToStr(Completed));
    Status.SaveToFile(FullTracksDirectory + '\full-tracks-status.txt');
end;

{ Count tracks using the qualified inventory's legacy iterator scope. }
function FullTracksCount(Board : IPCB_Board) : Integer;
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

{ Build an audit row; a negative after-count means the batch count is pending. }
function FullTracksAuditRow(BoardName : String; RowIndex : Integer;
    Action, NetName : String; X1, Y1, X2, Y2, Width, Layer,
    BeforeCount, AfterCount : Integer; ResultName : String) : String;
begin
    Result := BoardName + #9 + IntToStr(RowIndex) + #9 + Action + #9 + NetName +
        #9 + IntToStr(X1) + #9 + IntToStr(Y1) + #9 + IntToStr(X2) + #9 +
        IntToStr(Y2) + #9 + IntToStr(Width) + #9 + IntToStr(Layer) + #9 +
        IntToStr(BeforeCount) + #9;
    if AfterCount >= 0 then Result := Result + IntToStr(AfterCount);
    Result := Result + #9 + ResultName;
end;

{ Preflight every row, then edit endpoints or add one registered track per step. }
procedure ApplyExplicitFullTracks;
var
    Board, ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net : IPCB_Net;
    Track, ChangedTrack : IPCB_Track;
    Lines, Fields, Status, Audit : TStringList;
    Actions, NetNames : array[1..64] of String;
    OldX1, OldY1, OldX2, OldY2 : array[1..64] of Integer;
    NewX1, NewY1, NewX2, NewY2 : array[1..64] of Integer;
    Widths, Layers, ExpectedCounts, NetMatches, TrackMatches : array[1..64] of Integer;
    TargetNets : array[1..64] of IPCB_Net;
    TargetTracks : array[1..64] of IPCB_Track;
    DestinationOccupied : array[1..64] of Boolean;
    Row, ResultName, ScanNetName : String;
    I, J, Separator, RowCount, BeforeCount, CurrentCount, AfterCount, ParsedValue : Integer;
    Completed, PlannedAdds, AppliedAdds : Integer;
    ScanLayer, ScanWidth, ScanX1, ScanY1, ScanX2, ScanY2 : Integer;
    ReadbackMatches : Boolean;
begin
    Lines := TStringList.Create;
    Fields := TStringList.Create;
    Status := TStringList.Create;
    Audit := TStringList.Create;
    Completed := 0;
    PlannedAdds := 0;
    AppliedAdds := 0;
    try
        { A missing or unwritable output directory fails before any geometry write. }
        FullTracksStage(Status, 'validating_request', 0, Completed);
        Audit.Add('board' + #9 + 'row' + #9 + 'action' + #9 + 'net' + #9 +
            'x1_raw' + #9 + 'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 +
            'width_raw' + #9 + 'layer_id' + #9 + 'batch_before_track_count' + #9 +
            'batch_after_track_count' + #9 + 'result');
        Audit.SaveToFile(FullTracksDirectory + '\full-tracks-audit.tsv');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then
        begin
            FullTracksStage(Status, 'refused_no_active_pcb', 0, Completed);
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullTracksExpectedBoard) then
        begin
            FullTracksStage(Status, 'refused_wrong_board', 0, Completed);
            Exit;
        end;
        if not FileExists(FullTracksDirectory + '\track-changes.tsv') then
        begin
            FullTracksStage(Status, 'refused_missing_request', 0, Completed);
            Exit;
        end;
        Lines.LoadFromFile(FullTracksDirectory + '\track-changes.tsv');
        Lines.SaveToFile(FullTracksDirectory + '\full-tracks-request.tsv');
        if (Lines.Count < 2) or (Lines.Count > 65) then
        begin
            FullTracksStage(Status, 'refused_row_count', 0, Completed);
            Exit;
        end;
        if Lines.Strings[0] <> 'action' + #9 + 'net' + #9 + 'old_x1_raw' +
            #9 + 'old_y1_raw' + #9 + 'old_x2_raw' + #9 + 'old_y2_raw' + #9 +
            'new_x1_raw' + #9 + 'new_y1_raw' + #9 + 'new_x2_raw' + #9 +
            'new_y2_raw' + #9 + 'width_raw' + #9 + 'layer_id' + #9 +
            'expected_track_count' then
        begin
            FullTracksStage(Status, 'refused_header', 0, Completed);
            Exit;
        end;
        RowCount := Lines.Count - 1;
        for I := 1 to RowCount do
        begin
            FullTracksStage(Status, 'validating_row', I, Completed);
            Fields.Clear;
            Row := Lines.Strings[I];
            for J := 1 to 12 do
            begin
                Separator := Pos(#9, Row);
                if Separator = 0 then
                begin
                    FullTracksStage(Status, 'refused_columns', I, Completed);
                    Exit;
                end;
                Fields.Add(Copy(Row, 1, Separator - 1));
                Row := Copy(Row, Separator + 1, Length(Row));
            end;
            Fields.Add(Row);
            if Pos(#9, Row) > 0 then
            begin
                FullTracksStage(Status, 'refused_extra_columns', I, Completed);
                Exit;
            end;
            Actions[I] := Fields.Strings[0];
            NetNames[I] := Fields.Strings[1];
            if (Actions[I] <> 'edit') and (Actions[I] <> 'add') then
            begin
                FullTracksStage(Status, 'refused_action', I, Completed);
                Exit;
            end;
            if (NetNames[I] = '') or (NetNames[I] <> Trim(NetNames[I])) then
            begin
                FullTracksStage(Status, 'refused_net_field', I, Completed);
                Exit;
            end;
            for J := 2 to 12 do
            begin
                if not FullTracksInteger(Fields.Strings[J], ParsedValue) then
                begin
                    FullTracksStage(Status, 'refused_numeric_field', I, Completed);
                    Exit;
                end;
                case J of
                    2: OldX1[I] := ParsedValue;
                    3: OldY1[I] := ParsedValue;
                    4: OldX2[I] := ParsedValue;
                    5: OldY2[I] := ParsedValue;
                    6: NewX1[I] := ParsedValue;
                    7: NewY1[I] := ParsedValue;
                    8: NewX2[I] := ParsedValue;
                    9: NewY2[I] := ParsedValue;
                    10: Widths[I] := ParsedValue;
                    11: Layers[I] := ParsedValue;
                    12: ExpectedCounts[I] := ParsedValue;
                end;
            end;
            if (NewX1[I] <= 0) or (NewY1[I] <= 0) or (NewX2[I] <= 0) or
               (NewY2[I] <= 0) or (Widths[I] <= 0) or
               ((NewX1[I] = NewX2[I]) and (NewY1[I] = NewY2[I])) or
               ((Layers[I] <> eTopLayer) and (Layers[I] <> FullTracksL3Layer) and
                (Layers[I] <> eBottomLayer) and
                not ((Layers[I] = FullTracksL2Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'SD2_CMD') or (NetNames[I] = 'QSPIA_SCLK') or
                      (NetNames[I] = 'DRAMA_CA4') or (NetNames[I] = 'DRAMA_CA5') or
                      (NetNames[I] = 'DRAMB_CKE1') or (NetNames[I] = 'DRAMB_CA5') or
                      (NetNames[I] = 'DRAMB_DATA10') or (NetNames[I] = 'DRAMA_DATA1') or
                      (NetNames[I] = 'SAI2_RXC') or (NetNames[I] = 'SAI2_TXD') or
                      (NetNames[I] = 'USB1_ID') or (NetNames[I] = 'SAI1_TXD0') or
                      (NetNames[I] = 'SAI2_MCLK') or (NetNames[I] = 'SYS_STATUS') or
                      (NetNames[I] = 'DRAMA_DATA5') or (NetNames[I] = 'SD3_CLK') or
                      (NetNames[I] = 'JTAG_TDO') or (NetNames[I] = 'SAI1_TXC') or
                      (NetNames[I] = 'SAI1_RXD5') or (NetNames[I] = 'SAI1_RXD1') or
                      (NetNames[I] = 'SAI5_RXFS') or (NetNames[I] = 'SAI1_RXD7') or
                      (NetNames[I] = 'GPIO1_IO10') or (NetNames[I] = 'GPIO1_IO09') or
                      (NetNames[I] = 'DRAMB_DATA0') or (NetNames[I] = 'DRAMA_DATA3') or
                      (NetNames[I] = 'UART1_CTS') or (NetNames[I] = 'SD2_DATA3') or
                      (NetNames[I] = 'SAI1_TXD4') or (NetNames[I] = 'SAI1_TXD2') or
                      (NetNames[I] = 'SD3_DATA6') or (NetNames[I] = 'SD1_DATA3') or
                      (NetNames[I] = 'QSPIA_DATA0') or (NetNames[I] = 'SAI1_TXD7') or
                      (NetNames[I] = 'CLKIN2') or (NetNames[I] = 'I2C4_SDA') or
                      (NetNames[I] = 'ENET_TD2') or (NetNames[I] = 'SAI1_RXD4')) and
                     (Widths[I] >= 32000) and (Widths[I] <= 100000)) and
                not ((Layers[I] = FullTracksL2Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'NVCC_SNVS_1V8') or
                      (NetNames[I] = 'NVCC_DRAM_1V1')) and
                     (Widths[I] >= 30000) and (Widths[I] <= 1000000)) and
                not ((Layers[I] = FullTracksL2Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'DSI_D3_P') or (NetNames[I] = 'CSI_D0_P') or
                      (NetNames[I] = 'CSI_D2_P')) and
                     (Widths[I] = 150000)) and
                not ((Layers[I] = FullTracksL4Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'XTALO_24M') or (NetNames[I] = 'POR_B') or
                      (NetNames[I] = 'SD2_NRST') or (NetNames[I] = 'JTAG_TCK')) and
                     (Widths[I] = 32000)) and
                not ((Layers[I] = FullTracksL4Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'ENET_TD0') or (NetNames[I] = 'SAI1_RXD7') or
                      (NetNames[I] = 'ENET_RD3') or (NetNames[I] = 'QSPIA_DATA0') or
                      (NetNames[I] = 'WL_REG_ON') or (NetNames[I] = 'QSPIA_DATA2') or
                      (NetNames[I] = 'ENET_RD2') or (NetNames[I] = 'ENET_TD1')) and
                     (Widths[I] = 32000)) and
                not (((Layers[I] = FullTracksL4Layer) or (Layers[I] = 5)) and
                     (Actions[I] = 'add') and (NetNames[I] = 'BT_WAKE_DEV') and
                     (Widths[I] = 32000)) and
                not ((Layers[I] = FullTracksL7Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'DSI_D0_P') and (Widths[I] = 150000)) and
                not (((Layers[I] = FullTracksL4Layer) or (Layers[I] = FullTracksL7Layer)) and
                     (Actions[I] = 'add') and (NetNames[I] = 'PCIE_CLK_P') and
                     (Widths[I] = 150000)) and
                not (((Layers[I] = FullTracksL2Layer) or (Layers[I] = FullTracksL4Layer)) and
                     (Actions[I] = 'add') and (NetNames[I] = 'PCIE_CLK_N') and
                     (Widths[I] = 150000)) and
                not ((Layers[I] = 5) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'USB1_DN') or (NetNames[I] = 'CSI_CK_P') or
                      (NetNames[I] = 'PCIE_TX_N')) and
                     (Widths[I] = 150000)) and
                not ((Layers[I] = FullTracksL7Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'POR_B') and (Widths[I] = 32000)) and
                not ((Layers[I] = FullTracksL6Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'VDD_3V3') and
                     (Widths[I] >= 30000) and (Widths[I] <= 200000)) and
                not ((Layers[I] = 5) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'VDD_1V8') or (NetNames[I] = 'NVCC_SNVS_1V8') or
                      (NetNames[I] = 'VDD_ARM_0V9') or (NetNames[I] = 'VDD_3V3')) and
                     (Widths[I] >= 30000) and (Widths[I] <= 200000)) and
                not ((Layers[I] = 5) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'PDM_DATA1') or (NetNames[I] = 'SAI1_RXD5') or
                      (NetNames[I] = 'SD2_DATA2') or (NetNames[I] = 'XTALO_32K') or
                      (NetNames[I] = 'GPIO1_IO07') or (NetNames[I] = 'DRAM_NRESET') or
                      (NetNames[I] = 'UART3_RTS') or (NetNames[I] = 'GPIO1_IO08') or
                      (NetNames[I] = 'QSPIA_DATA3') or (NetNames[I] = 'CLKOUT2') or
                      (NetNames[I] = 'PMIC_ON_REQ') or (NetNames[I] = 'DRAMB_DATA3') or
                      (NetNames[I] = 'I2C1_SCL') or (NetNames[I] = 'SAI1_TXD4') or
                      (NetNames[I] = 'SAI1_TXD2') or (NetNames[I] = 'SD2_CLK') or
                      (NetNames[I] = 'ECSPI2_MISO') or (NetNames[I] = 'DRAMB_DATA4') or
                      (NetNames[I] = 'DRAMB_nCS1') or (NetNames[I] = 'SD2_WP') or
                      (NetNames[I] = 'WL_WAKE_HOST') or (NetNames[I] = 'WL_REG_ON') or
                      (NetNames[I] = 'I2C4_SDA') or (NetNames[I] = 'I2C1_SDA') or
                      (NetNames[I] = 'I2C2_SCL') or (NetNames[I] = 'SD3_DATA1') or (NetNames[I] = 'SD3_DATA2') or
                      (NetNames[I] = 'SAI1_RXD0') or (NetNames[I] = 'SAI1_RXD6')) and
                     (Widths[I] >= 32000) and (Widths[I] <= 100000)) and
                not ((Layers[I] = FullTracksL7Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'SAI2_RXD') or (NetNames[I] = 'SAI2_TXC') or
                      (NetNames[I] = 'UART1_RXD') or (NetNames[I] = 'UART1_RTS') or
                      (NetNames[I] = 'SAI5_RXFS') or (NetNames[I] = 'SAI1_TXD1') or
                      (NetNames[I] = 'PDM_DATA2') or (NetNames[I] = 'PDM_DATA0') or
                      (NetNames[I] = 'SD2_DATA2') or (NetNames[I] = 'XTALI_32K') or
                      (NetNames[I] = 'ENET_RXC') or (NetNames[I] = 'GPIO1_IO11') or
                      (NetNames[I] = 'DRAMB_DATA1') or (NetNames[I] = 'CLKOUT1') or
                      (NetNames[I] = 'DRAMB_DATA11') or (NetNames[I] = 'UART1_TXD') or
                      (NetNames[I] = 'SAI1_RXD1') or (NetNames[I] = 'JTAG_TCK') or
                      (NetNames[I] = 'UART1_CTS') or (NetNames[I] = 'SD2_DATA1') or
                      (NetNames[I] = 'ENET_TD3') or (NetNames[I] = 'SAI1_TXD5') or
                      (NetNames[I] = 'SAI1_RXFS') or (NetNames[I] = 'SAI1_RXD4') or
                      (NetNames[I] = 'GPIO1_IO05')) and
                     (Widths[I] >= 32000) and (Widths[I] <= 100000)) and
                not ((Layers[I] = FullTracksL7Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'VDD_3V3') and (Widths[I] = 30000)) and
                not ((Layers[I] = FullTracksL7Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'GND') and
                     (Widths[I] >= 30000) and (Widths[I] <= 100000)) and
                not ((Layers[I] = FullTracksL4Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'VDD_3V3') and (Widths[I] = 200000)) and
                not ((Layers[I] = FullTracksL4Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'VDD_ARM_0V9') or
                      (NetNames[I] = 'VDD_SOC_0V8') or
                      (NetNames[I] = 'VDD_DRAM&PU_0V9') or
                      (NetNames[I] = 'VDD_1V8') or
                      (NetNames[I] = 'NVCC_SD2')) and
                     (Widths[I] >= 30000) and (Widths[I] <= 1000000)) and
                not ((Layers[I] = FullTracksL6Layer) and (Actions[I] = 'add') and
                     (NetNames[I] = 'GND') and
                     (Widths[I] >= 50000) and (Widths[I] <= 100000)) and
                not ((Layers[I] = FullTracksL6Layer) and
                     FullTracksL6Net(NetNames[I]) and (Actions[I] = 'add') and
                     ((Widths[I] >= 32000) or
                      (((NetNames[I] = 'VDDA_1V8') or
                        (NetNames[I] = 'NVCC_SNVS_1V8')) and (Widths[I] >= 30000))) and
                     (Widths[I] <= 100000)) and
                not ((Layers[I] = FullTracksL6Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'VDD_SNVS_0V8') or
                      (NetNames[I] = 'NVCC_ENET') or
                      (NetNames[I] = 'NVCC_SD2') or
                      (NetNames[I] = 'VDD_PHY_0V9')) and
                     (Widths[I] >= 30000) and (Widths[I] <= 1000000)) and
                not ((Layers[I] = FullTracksL6Layer) and (Actions[I] = 'add') and
                     ((NetNames[I] = 'DRAMA_SDQS0_C') or
                      (NetNames[I] = 'DSI_D1_P') or
                      (NetNames[I] = 'DRAMA_CK_T') or
                      (NetNames[I] = 'DRAMB_SDQS1_C') or
                      (NetNames[I] = 'DRAMB_SDQS1_T') or
                      (NetNames[I] = 'DRAMB_CK_C')) and (Widths[I] = 150000))) or
               (ExpectedCounts[I] > 2147483647 - RowCount) then
            begin
                FullTracksStage(Status, 'refused_dimensions_or_layer', I, Completed);
                Exit;
            end;
            { Guard the exact reviewed inherited DATA2 fanout extension. }
            if (NetNames[I] = 'SD3_DATA2') and (Layers[I] = eTopLayer) and
               (Widths[I] = 30000) and
               not ((Actions[I] = 'edit') and
                    FullTracksSameEndpoints(OldX1[I],OldY1[I],OldX2[I],OldY2[I],
                        127344400,95080700,127441500,95080700) and
                    (NewX1[I] = 127344400) and (NewY1[I] = 95080700) and
                    (NewX2[I] = 127518500) and (NewY2[I] = 95080700)) then
            begin
                FullTracksStage(Status, 'refused_unreviewed_data2_neck', I, Completed);
                Exit;
            end;
            if ExpectedCounts[I] <> ExpectedCounts[1] then
            begin
                FullTracksStage(Status, 'refused_inconsistent_before_count', I, Completed);
                Exit;
            end;
            if Actions[I] = 'edit' then
            begin
                if (OldX1[I] <= 0) or (OldY1[I] <= 0) or (OldX2[I] <= 0) or
                   (OldY2[I] <= 0) or
                   ((OldX1[I] = OldX2[I]) and (OldY1[I] = OldY2[I])) or
                   FullTracksSameEndpoints(OldX1[I], OldY1[I], OldX2[I], OldY2[I],
                       NewX1[I], NewY1[I], NewX2[I], NewY2[I]) then
                begin
                    FullTracksStage(Status, 'refused_old_geometry_or_no_change', I, Completed);
                    Exit;
                end;
            end
            else
            begin
                if (OldX1[I] <> 0) or (OldY1[I] <> 0) or
                   (OldX2[I] <> 0) or (OldY2[I] <> 0) then
                begin
                    FullTracksStage(Status, 'refused_add_old_coordinates', I, Completed);
                    Exit;
                end;
                Inc(PlannedAdds);
            end;
            for J := 1 to I - 1 do
            begin
                if (Layers[I] = Layers[J]) and
                   FullTracksSameEndpoints(NewX1[I], NewY1[I], NewX2[I], NewY2[I],
                       NewX1[J], NewY1[J], NewX2[J], NewY2[J]) then
                begin
                    FullTracksStage(Status, 'refused_duplicate_destination', I, Completed);
                    Exit;
                end;
                if (Actions[I] = 'edit') and (Actions[J] = 'edit') and
                   (NetNames[I] = NetNames[J]) and (Widths[I] = Widths[J]) and
                   (Layers[I] = Layers[J]) and
                   FullTracksSameEndpoints(OldX1[I], OldY1[I], OldX2[I], OldY2[I],
                       OldX1[J], OldY1[J], OldX2[J], OldY2[J]) then
                begin
                    FullTracksStage(Status, 'refused_repeated_old_track', I, Completed);
                    Exit;
                end;
            end;
            NetMatches[I] := 0;
            TrackMatches[I] := 0;
            TargetNets[I] := nil;
            TargetTracks[I] := nil;
            DestinationOccupied[I] := False;
        end;

        FullTracksStage(Status, 'checking_all_targets', 0, Completed);
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
                        ScanNetName := Net.Name;
                        for I := 1 to RowCount do
                            if ScanNetName = NetNames[I] then
                            begin
                                TargetNets[I] := Net;
                                NetMatches[I] := NetMatches[I] + 1;
                            end;
                    end;
                    eTrackObject:
                    begin
                        Track := Primitive;
                        Inc(BeforeCount);
                        ScanLayer := Track.Layer;
                        ScanWidth := Track.Width;
                        ScanX1 := Track.X1;
                        ScanY1 := Track.Y1;
                        ScanX2 := Track.X2;
                        ScanY2 := Track.Y2;
                        ScanNetName := FullTracksNetName(Track);
                        for I := 1 to RowCount do
                            if ScanLayer = Layers[I] then
                            begin
                                if FullTracksSameEndpoints(ScanX1, ScanY1,
                                    ScanX2, ScanY2, NewX1[I], NewY1[I], NewX2[I], NewY2[I]) then
                                    DestinationOccupied[I] := True;
                                if (Actions[I] = 'edit') and (ScanWidth = Widths[I]) and
                                   (ScanNetName = NetNames[I]) and
                                   FullTracksSameEndpoints(ScanX1, ScanY1,
                                       ScanX2, ScanY2, OldX1[I], OldY1[I], OldX2[I], OldY2[I]) then
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
            FullTracksStage(Status, 'refused_stale_track_count', 0, Completed);
            Status.Add('expected_track_count=' + IntToStr(ExpectedCounts[1]));
            Status.Add('actual_track_count=' + IntToStr(BeforeCount));
            Status.SaveToFile(FullTracksDirectory + '\full-tracks-status.txt');
            Exit;
        end;
        for I := 1 to RowCount do
        begin
            if (NetMatches[I] <> 1) or (TargetNets[I] = nil) then
            begin
                FullTracksStage(Status, 'refused_net_resolution', I, Completed);
                Exit;
            end;
            if Actions[I] = 'edit' then
                if (TrackMatches[I] <> 1) or (TargetTracks[I] = nil) then
                begin
                    FullTracksStage(Status, 'refused_old_track_resolution', I, Completed);
                    Exit;
                end;
            if DestinationOccupied[I] then
            begin
                FullTracksStage(Status, 'refused_existing_destination', I, Completed);
                Exit;
            end;
        end;
        CurrentCount := BeforeCount;
        for I := 1 to RowCount do
        begin
            Audit.Add(FullTracksAuditRow(Board.FileName, I, Actions[I], NetNames[I],
                NewX1[I], NewY1[I], NewX2[I], NewY2[I], Widths[I], Layers[I],
                BeforeCount, -1, 'pending_not_started'));
            if Actions[I] = 'add' then Inc(CurrentCount);
        end;
        Audit.SaveToFile(FullTracksDirectory + '\full-tracks-audit.tsv');

        for I := 1 to RowCount do
        begin
            FullTracksStage(Status, 'checking_before_row', I, Completed);
            ActiveBoard := PCBServer.GetCurrentPCBBoard;
            if ActiveBoard = nil then
            begin
                FullTracksStage(Status, 'stopped_no_active_pcb_inspect_board', I, Completed);
                Exit;
            end;
            if UpperCase(ActiveBoard.FileName) <> UpperCase(FullTracksExpectedBoard) then
            begin
                FullTracksStage(Status, 'stopped_wrong_board_inspect_board', I, Completed);
                Exit;
            end;
            { The sole writer verifies the native total after all row readbacks. }
            CurrentCount := BeforeCount + AppliedAdds;
            if Actions[I] = 'edit' then
            begin
                ChangedTrack := TargetTracks[I];
                if (ChangedTrack.Width <> Widths[I]) or (ChangedTrack.Layer <> Layers[I]) or
                   (FullTracksNetName(ChangedTrack) <> NetNames[I]) or
                   not FullTracksSameEndpoints(ChangedTrack.X1, ChangedTrack.Y1,
                       ChangedTrack.X2, ChangedTrack.Y2, OldX1[I], OldY1[I], OldX2[I], OldY2[I]) then
                begin
                    FullTracksStage(Status, 'stopped_old_track_changed_inspect_board', I, Completed);
                    Exit;
                end;
            end;
            Audit.Strings[I] := FullTracksAuditRow(Board.FileName, I, Actions[I],
                NetNames[I], NewX1[I], NewY1[I], NewX2[I], NewY2[I], Widths[I],
                Layers[I], BeforeCount, -1, 'applying_inspect_on_interruption');
            Audit.SaveToFile(FullTracksDirectory + '\full-tracks-audit.tsv');
            FullTracksStage(Status, 'applying_row', I, Completed);
            PCBServer.PreProcess;
            try
                if Actions[I] = 'edit' then
                begin
                    PCBServer.SendMessageToRobots(ChangedTrack.I_ObjectAddress,
                        c_Broadcast, PCBM_BeginModify, c_NoEventData);
                    try
                        ChangedTrack.X1 := NewX1[I];
                        ChangedTrack.Y1 := NewY1[I];
                        ChangedTrack.X2 := NewX2[I];
                        ChangedTrack.Y2 := NewY2[I];
                    finally
                        PCBServer.SendMessageToRobots(ChangedTrack.I_ObjectAddress,
                            c_Broadcast, PCBM_EndModify, c_NoEventData);
                    end;
                end
                else
                begin
                    ChangedTrack := PCBServer.PCBObjectFactory(eTrackObject, eNoDimension, eCreate_Default);
                    if ChangedTrack = nil then
                    begin
                        FullTracksStage(Status, 'failed_factory_inspect_board', I, Completed);
                        Exit;
                    end;
                    ChangedTrack.X1 := NewX1[I];
                    ChangedTrack.Y1 := NewY1[I];
                    ChangedTrack.X2 := NewX2[I];
                    ChangedTrack.Y2 := NewY2[I];
                    ChangedTrack.Width := Widths[I];
                    ChangedTrack.Layer := Layers[I];
                    ChangedTrack.Net := TargetNets[I];
                    Board.AddPCBObject(ChangedTrack);
                    PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast,
                        PCBM_BoardRegisteration, ChangedTrack.I_ObjectAddress);
                end;
            finally
                PCBServer.PostProcess;
            end;
            FullTracksStage(Status, 'verify_track', I, Completed);
            if Actions[I] = 'add' then Inc(AppliedAdds);
            ReadbackMatches := (ChangedTrack.Width = Widths[I]) and (ChangedTrack.Layer = Layers[I]) and
                (FullTracksNetName(ChangedTrack) = NetNames[I]) and
                FullTracksSameEndpoints(ChangedTrack.X1, ChangedTrack.Y1,
                    ChangedTrack.X2, ChangedTrack.Y2, NewX1[I], NewY1[I], NewX2[I], NewY2[I]);
            ResultName := 'failed_readback_inspect_board';
            if ReadbackMatches then ResultName := 'properties_readback_ok_batch_count_pending';
            Audit.Strings[I] := FullTracksAuditRow(Board.FileName, I, Actions[I],
                FullTracksNetName(ChangedTrack), ChangedTrack.X1, ChangedTrack.Y1,
                ChangedTrack.X2, ChangedTrack.Y2, ChangedTrack.Width, ChangedTrack.Layer,
                BeforeCount, -1, ResultName);
            Audit.SaveToFile(FullTracksDirectory + '\full-tracks-audit.tsv');
            if not ReadbackMatches then
            begin
                FullTracksStage(Status, ResultName, I, Completed);
                Exit;
            end;
            Inc(Completed);
            TargetTracks[I] := ChangedTrack;
            FullTracksStage(Status, 'row_properties_readback_ok_batch_count_pending', I, Completed);
        end;
        if AppliedAdds <> PlannedAdds then
        begin
            FullTracksStage(Status, 'failed_add_total_inspect_board', RowCount, Completed);
            Exit;
        end;
        FullTracksStage(Status, 'verifying_native_batch_count', RowCount, Completed);
        AfterCount := FullTracksCount(Board);
        if AfterCount <> BeforeCount + AppliedAdds then
        begin
            FullTracksStage(Status, 'failed_native_batch_count_inspect_board', RowCount, Completed);
            Exit;
        end;
        for I := 1 to RowCount do
        begin
            ChangedTrack := TargetTracks[I];
            ReadbackMatches := (ChangedTrack.Width = Widths[I]) and
                (ChangedTrack.Layer = Layers[I]) and
                (FullTracksNetName(ChangedTrack) = NetNames[I]) and
                FullTracksSameEndpoints(ChangedTrack.X1, ChangedTrack.Y1,
                    ChangedTrack.X2, ChangedTrack.Y2, NewX1[I], NewY1[I], NewX2[I], NewY2[I]);
            if not ReadbackMatches then
            begin
                FullTracksStage(Status, 'failed_final_properties_inspect_board', I, Completed);
                Exit;
            end;
            Audit.Strings[I] := FullTracksAuditRow(Board.FileName, I, Actions[I],
                FullTracksNetName(ChangedTrack), ChangedTrack.X1, ChangedTrack.Y1,
                ChangedTrack.X2, ChangedTrack.Y2, ChangedTrack.Width, ChangedTrack.Layer,
                BeforeCount, AfterCount, 'applied_readback_ok_count_verified_at_batch_end_drc_not_checked');
        end;
        Audit.SaveToFile(FullTracksDirectory + '\full-tracks-audit.tsv');
        FullTracksStage(Status, 'applied_batch_readback_ok_drc_not_checked', RowCount, Completed);
    finally
        Lines.Free;
        Fields.Free;
        Status.Free;
        Audit.Free;
    end;
end;
