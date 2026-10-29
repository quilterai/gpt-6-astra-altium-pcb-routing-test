{ Read component placement and legacy layer-stack properties without edits. }

function FullDetailsExpectedBoard : String;
begin
    Result := AstraWorkspacePath('FullDetails.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function FullDetailsOutputDirectory : String;
begin
    Result := AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\quality\details');
end;

{ Preserve a field on one TSV line. }
function FullDetailsField(Value : String) : String;
var
    I : Integer;
begin
    Result := '';
    for I := 1 to Length(Value) do
    begin
        if (Value[I] = #9) or (Value[I] = #13) or (Value[I] = #10) then
            Result := Result + ' '
        else
            Result := Result + Value[I];
    end;
end;

{ Leave a visible incomplete stage if a read fails. }
procedure FullDetailsStage(Status : TStringList; Name, Stage : String);
begin
    Status.Clear;
    Status.Add(Stage);
    Status.SaveToFile(FullDetailsOutputDirectory + '\' + Name + '-status.txt');
end;

{ Require the exact loaded working PCB even from the script editor. }
function FullDetailsBoard(Status : TStringList; Name : String) : IPCB_Board;
begin
    Result := nil;
    if not DirectoryExists(FullDetailsOutputDirectory) then
    begin
        ShowMessage('Create the details output directory first: ' + FullDetailsOutputDirectory);
        Exit;
    end;
    FullDetailsStage(Status, Name, 'checking_board');
    Result := PCBServer.GetPCBBoardByPath(FullDetailsExpectedBoard);
    if Result = nil then
    begin
        FullDetailsStage(Status, Name, 'refused_board_not_loaded');
        ShowMessage('The full-routing-2026-09-30 working PCB is not loaded.');
        Exit;
    end;
    if UpperCase(Result.FileName) <> UpperCase(FullDetailsExpectedBoard) then
    begin
        FullDetailsStage(Status, Name, 'refused_board_path');
        ShowMessage('Refusing PCB: ' + Result.FileName);
        Result := nil;
    end;
end;

{ Record exact board identity and coordinate units beside each export. }
procedure FullDetailsIdentity(Board : IPCB_Board; Report : TStringList; CountName : String; Count : Integer);
begin
    Report.Add('field' + #9 + 'value');
    Report.Add('board_file' + #9 + FullDetailsField(Board.FileName));
    Report.Add('internal_units_per_mil' + #9 + IntToStr(MilsToCoord(1)));
    Report.Add('x_origin_raw' + #9 + IntToStr(Board.XOrigin));
    Report.Add('y_origin_raw' + #9 + IntToStr(Board.YOrigin));
    Report.Add(CountName + #9 + IntToStr(Count));
end;

{ Export component reference positions and rotations without changing selection. }
procedure ExportFullPlacement;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Component : IPCB_Component;
    Components, Identity, Status : TStringList;
begin
    Status := TStringList.Create;
    Components := TStringList.Create;
    Identity := TStringList.Create;
    try
        Board := FullDetailsBoard(Status, 'placement');
        if Board = nil then Exit;
        Components.Add('refdes' + #9 + 'comment' + #9 + 'footprint' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'rotation_degrees' + #9 + 'layer_id' + #9 + 'layer');
        FullDetailsStage(Status, 'placement', 'read_components');
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eComponentObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Component := Iterator.FirstPCBObject;
            while Component <> nil do
            begin
                if Components.Count > 10000 then
                begin
                    FullDetailsStage(Status, 'placement', 'failed_component_limit');
                    ShowMessage('Component iteration exceeded 10000 objects.');
                    Exit;
                end;
                Components.Add(FullDetailsField(Component.Name.Text) + #9 + FullDetailsField(Component.Comment.Text) + #9 + FullDetailsField(Component.Pattern) + #9 + IntToStr(Component.X) + #9 + IntToStr(Component.Y) + #9 + FloatToStr(Component.Rotation) + #9 + IntToStr(Component.Layer) + #9 + Layer2String(Component.Layer));
                Component := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        FullDetailsIdentity(Board, Identity, 'component_count', Components.Count - 1);
        FullDetailsStage(Status, 'placement', 'write_components');
        Components.SaveToFile(FullDetailsOutputDirectory + '\components.tsv');
        Identity.SaveToFile(FullDetailsOutputDirectory + '\placement-board.tsv');
        FullDetailsStage(Status, 'placement', 'complete');
    finally
        Identity.Free;
        Components.Free;
        Status.Free;
    end;
end;

{ Export the documented legacy stack view without inferring reference continuity. }
procedure ExportFullStackup;
var
    Board : IPCB_Board;
    Stack : IPCB_LayerStack;
    LayerObject : IPCB_LayerObject;
    Dielectric : IPCB_DielectricObject;
    Layers, SeenLayers, Identity, Status : TStringList;
    Row, LayerID : String;
    LayerCount : Integer;
begin
    Status := TStringList.Create;
    Layers := TStringList.Create;
    SeenLayers := TStringList.Create;
    Identity := TStringList.Create;
    try
        Board := FullDetailsBoard(Status, 'stackup');
        if Board = nil then Exit;
        FullDetailsStage(Status, 'stackup', 'read_legacy_stack');
        Stack := Board.LayerStack;
        if Stack = nil then
        begin
            FullDetailsStage(Status, 'stackup', 'failed_no_legacy_stack');
            ShowMessage('The working PCB returned no legacy layer stack.');
            Exit;
        end;
        Layers.Add('stack_index' + #9 + 'layer_id' + #9 + 'layer_name' + #9 + 'copper_thickness_raw' + #9 + 'dielectric_status' + #9 + 'dielectric_type_id' + #9 + 'dielectric_material' + #9 + 'dielectric_height_raw' + #9 + 'dielectric_constant');
        LayerCount := 0;
        LayerObject := Stack.FirstLayer;
        while LayerObject <> nil do
        begin
            LayerID := IntToStr(LayerObject.LayerID);
            if (LayerCount >= 64) or (SeenLayers.IndexOf(LayerID) >= 0) then
            begin
                FullDetailsStage(Status, 'stackup', 'failed_layer_iteration');
                ShowMessage('Layer iteration repeated an ID or exceeded 64 layers.');
                Exit;
            end;
            SeenLayers.Add(LayerID);
            Inc(LayerCount);
            Row := IntToStr(LayerCount) + #9 + LayerID + #9 + FullDetailsField(LayerObject.Name) + #9 + IntToStr(LayerObject.CopperThickness);
            Dielectric := LayerObject.Dielectric;
            if Dielectric = nil then
                Row := Row + #9 + 'no_object' + #9 + #9 + #9 + #9
            else
                Row := Row + #9 + 'read' + #9 + IntToStr(Dielectric.DielectricType) + #9 + FullDetailsField(Dielectric.DielectricMaterial) + #9 + IntToStr(Dielectric.DielectricHeight) + #9 + FloatToStr(Dielectric.DielectricConstant);
            Layers.Add(Row);
            LayerObject := Stack.NextLayer(LayerObject);
        end;
        if LayerCount = 0 then
        begin
            FullDetailsStage(Status, 'stackup', 'failed_empty_legacy_stack');
            ShowMessage('The legacy layer stack returned zero layers.');
            Exit;
        end;
        FullDetailsIdentity(Board, Identity, 'legacy_layer_count', LayerCount);
        Identity.Add('scope' + #9 + 'legacy_stack_properties_not_reference_continuity');
        FullDetailsStage(Status, 'stackup', 'write_layers');
        Layers.SaveToFile(FullDetailsOutputDirectory + '\layers.tsv');
        Identity.SaveToFile(FullDetailsOutputDirectory + '\stackup-board.tsv');
        FullDetailsStage(Status, 'stackup', 'complete');
    finally
        Identity.Free;
        SeenLayers.Free;
        Layers.Free;
        Status.Free;
    end;
end;

{ Export the dominant width rule and its L6 limits without changing the PCB. }
procedure ExportWidth226;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Track : IPCB_Track;
    RuleWidth : IPCB_MaxMinWidthConstraint;
    Report : TStringList;
    ExpectedBoard, OutputFile : String;
begin
    ExpectedBoard := AstraWorkspacePath('FullDetails.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
    OutputFile := AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width226-native.tsv');
    Board := PCBServer.GetPCBBoardByPath(ExpectedBoard);
    if Board = nil then Exit;
    if UpperCase(Board.FileName) <> UpperCase(ExpectedBoard) then Exit;
    Report := TStringList.Create;
    try
        Report.Add('field' + #9 + 'value');
        Report.Add('board_file' + #9 + Board.FileName);
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Track := Iterator.FirstPCBObject;
            while Track <> nil do
            begin
                if Track.Net <> nil then
                    if Track.Net.Name = 'RTC_RESET_B' then
                    begin
                        RuleWidth := Board.FindDominantRuleForObject(Track, eRule_MaxMinWidth);
                        if RuleWidth = nil then Exit;
                        Report.Add('net' + #9 + Track.Net.Name);
                        Report.Add('rule_name' + #9 + RuleWidth.Name);
                        Report.Add('object_layer_id' + #9 + IntToStr(Track.Layer));
                        Report.Add('object_x1_raw' + #9 + IntToStr(Track.X1));
                        Report.Add('object_y1_raw' + #9 + IntToStr(Track.Y1));
                        Report.Add('L6_layer_id' + #9 + IntToStr(eMidLayer5));
                        Report.Add('L6_min_width_raw' + #9 + IntToStr(RuleWidth.MinWidth(eMidLayer5)));
                        Report.Add('L6_favored_width_raw' + #9 + IntToStr(RuleWidth.FavoredWidth(eMidLayer5)));
                        Report.Add('L6_max_width_raw' + #9 + IntToStr(RuleWidth.MaxWidth(eMidLayer5)));
                        if RuleWidth.ImpedanceDriven then Report.Add('impedance_driven' + #9 + 'true') else Report.Add('impedance_driven' + #9 + 'false');
                        Report.Add('min_impedance' + #9 + FloatToStr(RuleWidth.MinImpedance));
                        Report.Add('favored_impedance' + #9 + FloatToStr(RuleWidth.FavoredImpedance));
                        Report.Add('max_impedance' + #9 + FloatToStr(RuleWidth.MaxImpedance));
                        Report.SaveToFile(OutputFile);
                        Exit;
                    end;
                Track := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
    finally
        Report.Free;
    end;
end;

{ Read dominant L6 width constraints for remaining low-speed controls. }
procedure ExportWidth228;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Track : IPCB_Track;
    Via : IPCB_Via;
    Pad : IPCB_Pad;
    RuleWidth : IPCB_MaxMinWidthConstraint;
    Names, Report : TStringList;
    ExpectedBoard, OutputFile, NetName, Row : String;
    I : Integer;
    Found : Boolean;
begin
    ExpectedBoard := AstraWorkspacePath('FullDetails.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
    OutputFile := AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width228-native.tsv');
    Board := PCBServer.GetPCBBoardByPath(ExpectedBoard);
    if Board = nil then Exit;
    if UpperCase(Board.FileName) <> UpperCase(ExpectedBoard) then Exit;
    Names := TStringList.Create;
    Report := TStringList.Create;
    try
        Names.Add('BT_WAKE_DEV');
        Names.Add('GPIO1_IO05');
        Names.Add('GPIO1_IO07');
        Names.Add('GPIO1_IO09');
        Names.Add('I2C3_SDA');
        Names.Add('NetR30_1');
        Names.Add('NetR7_2');
        Names.Add('PMIC_STBY_REQ');
        Names.Add('RTC_RESET_B');
        Names.Add('SD2_NCD');
        Names.Add('SD2_NRST');
        Names.Add('SYS_STATUS');
        Names.Add('UART1_RTS');
        Names.Add('UART1_RXD');
        Names.Add('UART3_RTS');
        Names.Add('UART3_TXD');
        Names.Add('WL_WAKE_HOST');
        Report.Add('net' + #9 + 'status' + #9 + 'object_id' + #9 + 'object_layer_id' + #9 + 'rule_name' + #9 + 'L6_min_width_raw' + #9 + 'L6_favored_width_raw' + #9 + 'L6_max_width_raw' + #9 + 'impedance_driven' + #9 + 'min_impedance' + #9 + 'favored_impedance' + #9 + 'max_impedance');
        for I := 0 to Names.Count - 1 do
        begin
            Found := False;
            Iterator := Board.BoardIterator_Create;
            try
                Iterator.AddFilter_ObjectSet(MkSet(eTrackObject, eViaObject, ePadObject));
                Iterator.AddFilter_LayerSet(AllLayers);
                Iterator.AddFilter_Method(eProcessAll);
                Primitive := Iterator.FirstPCBObject;
                while Primitive <> nil do
                begin
                    NetName := '';
                    if Primitive.ObjectId = eTrackObject then
                    begin
                        Track := Primitive;
                        if Track.Net <> nil then NetName := Track.Net.Name;
                    end;
                    if Primitive.ObjectId = eViaObject then
                    begin
                        Via := Primitive;
                        if Via.Net <> nil then NetName := Via.Net.Name;
                    end;
                    if Primitive.ObjectId = ePadObject then
                    begin
                        Pad := Primitive;
                        if Pad.Net <> nil then NetName := Pad.Net.Name;
                    end;
                    if NetName = Names[I] then
                    begin
                        RuleWidth := Board.FindDominantRuleForObject(Primitive, eRule_MaxMinWidth);
                        if RuleWidth <> nil then
                        begin
                            Row := NetName + #9 + 'read' + #9 + IntToStr(Primitive.ObjectId) + #9 + IntToStr(Primitive.Layer) + #9 + RuleWidth.Name;
                            Row := Row + #9 + IntToStr(RuleWidth.MinWidth(eMidLayer5)) + #9 + IntToStr(RuleWidth.FavoredWidth(eMidLayer5)) + #9 + IntToStr(RuleWidth.MaxWidth(eMidLayer5));
                            if RuleWidth.ImpedanceDriven then Row := Row + #9 + 'true' else Row := Row + #9 + 'false';
                            Row := Row + #9 + FloatToStr(RuleWidth.MinImpedance) + #9 + FloatToStr(RuleWidth.FavoredImpedance) + #9 + FloatToStr(RuleWidth.MaxImpedance);
                            Report.Add(Row);
                        end
                        else Report.Add(NetName + #9 + 'no_dominant_width_rule');
                        Found := True;
                        Break;
                    end;
                    Primitive := Iterator.NextPCBObject;
                end;
            finally
                Board.BoardIterator_Destroy(Iterator);
            end;
            if not Found then Report.Add(Names[I] + #9 + 'no_existing_primitive');
        end;
        Report.SaveToFile(OutputFile);
    finally
        Names.Free;
        Report.Free;
    end;
end;

{ Read dominant width constraints on one layer for the inspected nets. }
procedure ExportWidthForLayer(QueryLayer : Integer; OutputFile, OnlyNet : String);
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Track : IPCB_Track;
    Via : IPCB_Via;
    Pad : IPCB_Pad;
    RuleWidth : IPCB_MaxMinWidthConstraint;
    Names, Report : TStringList;
    ExpectedBoard, NetName, Row : String;
    I : Integer;
    Found : Boolean;
begin
    ExpectedBoard := AstraWorkspacePath('FullDetails.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
    Board := PCBServer.GetPCBBoardByPath(ExpectedBoard);
    if Board = nil then Exit;
    if UpperCase(Board.FileName) <> UpperCase(ExpectedBoard) then Exit;
    Names := TStringList.Create;
    Report := TStringList.Create;
    try
        Names.Add('BT_WAKE_DEV');
        Names.Add('CLKIN2');
        Names.Add('CLKOUT1');
        Names.Add('CLKOUT2');
        Names.Add('CLK_32K_OUT');
        Names.Add('CSI_CK_N');
        Names.Add('CSI_CK_P');
        Names.Add('CSI_D0_N');
        Names.Add('CSI_D0_P');
        Names.Add('CSI_D1_N');
        Names.Add('CSI_D1_P');
        Names.Add('CSI_D2_N');
        Names.Add('CSI_D2_P');
        Names.Add('CSI_D3_N');
        Names.Add('CSI_D3_P');
        Names.Add('DRAMA_CA4');
        Names.Add('DRAMA_CA5');
        Names.Add('DRAMA_CKE0');
        Names.Add('DRAMA_CKE1');
        Names.Add('DRAMA_CK_T');
        Names.Add('DRAMA_DATA1');
        Names.Add('DRAMA_DATA3');
        Names.Add('DRAMA_DATA5');
        Names.Add('DRAMA_SDQS0_C');
        Names.Add('DRAMA_SDQS0_T');
        Names.Add('DRAMA_nCS0');
        Names.Add('DRAMB_CA4');
        Names.Add('DRAMB_CA5');
        Names.Add('DRAMB_CKE0');
        Names.Add('DRAMB_CKE1');
        Names.Add('DRAMB_CK_C');
        Names.Add('DRAMB_DATA0');
        Names.Add('DRAMB_DATA1');
        Names.Add('DRAMB_DATA10');
        Names.Add('DRAMB_DATA11');
        Names.Add('DRAMB_DATA5');
        Names.Add('DRAMB_SDQS1_C');
        Names.Add('DRAMB_SDQS1_T');
        Names.Add('DRAMB_nCS0');
        Names.Add('DRAM_NRESET');
        Names.Add('DSI_CK_N');
        Names.Add('DSI_CK_P');
        Names.Add('DSI_D0_N');
        Names.Add('DSI_D0_P');
        Names.Add('DSI_D1_N');
        Names.Add('DSI_D1_P');
        Names.Add('DSI_D2_N');
        Names.Add('DSI_D2_P');
        Names.Add('DSI_D3_N');
        Names.Add('DSI_D3_P');
        Names.Add('ECSPI2_MISO');
        Names.Add('ECSPI2_MOSI');
        Names.Add('ECSPI2_SCLK');
        Names.Add('ECSPI2_SS0');
        Names.Add('ENET_RD2');
        Names.Add('ENET_RD3');
        Names.Add('ENET_RXC');
        Names.Add('ENET_TD0');
        Names.Add('ENET_TD1');
        Names.Add('ENET_TD2');
        Names.Add('ENET_TD3');
        Names.Add('GPIO1_IO05');
        Names.Add('GPIO1_IO07');
        Names.Add('GPIO1_IO09');
        Names.Add('I2C3_SDA');
        Names.Add('JTAG_TCK');
        Names.Add('JTAG_TDO');
        Names.Add('NVCC_ENET');
        Names.Add('NVCC_SD2');
        Names.Add('NVCC_SNVS_1V8');
        Names.Add('NetR30_1');
        Names.Add('NetR7_2');
        Names.Add('PCIE_CLK_N');
        Names.Add('PCIE_CLK_P');
        Names.Add('PCIE_RX_N');
        Names.Add('PCIE_RX_P');
        Names.Add('PCIE_TX_N');
        Names.Add('PCIE_TX_P');
        Names.Add('PDM_CLK');
        Names.Add('PDM_DATA3');
        Names.Add('PMIC_STBY_REQ');
        Names.Add('QSPIA_NSS0');
        Names.Add('QSPIA_SCLK');
        Names.Add('RTC_RESET_B');
        Names.Add('SAI1_MCLK');
        Names.Add('SAI1_RXC');
        Names.Add('SAI1_RXD0');
        Names.Add('SAI1_RXD1');
        Names.Add('SAI1_RXD3');
        Names.Add('SAI1_RXD4');
        Names.Add('SAI1_RXD5');
        Names.Add('SAI1_RXD6');
        Names.Add('SAI1_RXD7');
        Names.Add('SAI1_RXFS');
        Names.Add('SAI1_TXD0');
        Names.Add('SAI1_TXD1');
        Names.Add('SAI1_TXD2');
        Names.Add('SAI1_TXD3');
        Names.Add('SAI1_TXD4');
        Names.Add('SAI1_TXD5');
        Names.Add('SAI1_TXD7');
        Names.Add('SAI2_MCLK');
        Names.Add('SAI2_RXC');
        Names.Add('SAI2_RXD');
        Names.Add('SAI2_RXFS');
        Names.Add('SAI2_TXC');
        Names.Add('SAI2_TXD');
        Names.Add('SAI2_TXFS');
        Names.Add('SAI3_MCLK');
        Names.Add('SAI3_TXFS');
        Names.Add('SAI5_MCLK');
        Names.Add('SAI5_RXFS');
        Names.Add('SD1_DATA0');
        Names.Add('SD1_DATA1');
        Names.Add('SD1_DATA3');
        Names.Add('SD1_STROBE');
        Names.Add('SD2_CLK');
        Names.Add('SD2_CMD');
        Names.Add('SD2_DATA3');
        Names.Add('SD2_NCD');
        Names.Add('SD2_NRST');
        Names.Add('SD3_CLK');
        Names.Add('SD3_CMD');
        Names.Add('SD3_DATA1');
        Names.Add('SD3_DATA2');
        Names.Add('SD3_DATA3');
        Names.Add('SD3_DATA4');
        Names.Add('SD3_DATA6');
        Names.Add('SWOUT_3V3');
        Names.Add('SYS_STATUS');
        Names.Add('UART1_RTS');
        Names.Add('UART1_RXD');
        Names.Add('UART3_RTS');
        Names.Add('UART3_TXD');
        Names.Add('USB1_DN');
        Names.Add('USB1_DP');
        Names.Add('USB1_VBUS');
        Names.Add('USB2_DN');
        Names.Add('USB2_DP');
        Names.Add('VDDA_1V8');
        Names.Add('VDD_1V8');
        Names.Add('VDD_PHY_0V9');
        Names.Add('VDD_SNVS_0V8');
        Names.Add('WL_WAKE_HOST');
        Names.Add('XTALI_24M');
        Names.Add('XTALI_32K');
        Names.Add('XTALO_24M');
        Names.Add('XTALO_32K');
        if OnlyNet <> '' then
        begin
            Names.Clear;
            Names.Add(OnlyNet);
        end;
        Report.Add('net' + #9 + 'status' + #9 + 'object_id' + #9 + 'object_layer_id' + #9 + 'rule_name' + #9 + 'L' + IntToStr(QueryLayer) + '_min_width_raw' + #9 + 'L' + IntToStr(QueryLayer) + '_favored_width_raw' + #9 + 'L' + IntToStr(QueryLayer) + '_max_width_raw' + #9 + 'impedance_driven' + #9 + 'min_impedance' + #9 + 'favored_impedance' + #9 + 'max_impedance');
        for I := 0 to Names.Count - 1 do
        begin
            Found := False;
            Iterator := Board.BoardIterator_Create;
            try
                Iterator.AddFilter_ObjectSet(MkSet(eTrackObject, eViaObject, ePadObject));
                Iterator.AddFilter_LayerSet(AllLayers);
                Iterator.AddFilter_Method(eProcessAll);
                Primitive := Iterator.FirstPCBObject;
                while Primitive <> nil do
                begin
                    NetName := '';
                    if Primitive.ObjectId = eTrackObject then
                    begin
                        Track := Primitive;
                        if Track.Net <> nil then NetName := Track.Net.Name;
                    end;
                    if Primitive.ObjectId = eViaObject then
                    begin
                        Via := Primitive;
                        if Via.Net <> nil then NetName := Via.Net.Name;
                    end;
                    if Primitive.ObjectId = ePadObject then
                    begin
                        Pad := Primitive;
                        if Pad.Net <> nil then NetName := Pad.Net.Name;
                    end;
                    if NetName = Names[I] then
                    begin
                        RuleWidth := Board.FindDominantRuleForObject(Primitive, eRule_MaxMinWidth);
                        if RuleWidth <> nil then
                        begin
                            Row := NetName + #9 + 'read' + #9 + IntToStr(Primitive.ObjectId) + #9 + IntToStr(Primitive.Layer) + #9 + RuleWidth.Name;
                            Row := Row + #9 + IntToStr(RuleWidth.MinWidth(QueryLayer)) + #9 + IntToStr(RuleWidth.FavoredWidth(QueryLayer)) + #9 + IntToStr(RuleWidth.MaxWidth(QueryLayer));
                            if RuleWidth.ImpedanceDriven then Row := Row + #9 + 'true' else Row := Row + #9 + 'false';
                            Row := Row + #9 + FloatToStr(RuleWidth.MinImpedance) + #9 + FloatToStr(RuleWidth.FavoredImpedance) + #9 + FloatToStr(RuleWidth.MaxImpedance);
                            Report.Add(Row);
                        end
                        else Report.Add(NetName + #9 + 'no_dominant_width_rule');
                        Found := True;
                        Break;
                    end;
                    Primitive := Iterator.NextPCBObject;
                end;
            finally
                Board.BoardIterator_Destroy(Iterator);
            end;
            if not Found then Report.Add(Names[I] + #9 + 'no_existing_primitive');
        end;
        Report.SaveToFile(OutputFile);
    finally
        Names.Free;
        Report.Free;
    end;
end;

{ Read the existing L6 width scope. }
procedure ExportWidth229;
begin
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width229-native.tsv'), '');
end;

{ Read L4 widths without changing rules or geometry. }
procedure ExportWidth337;
begin
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width337-native.tsv'), '');
end;

{ Read L2 widths without changing rules or geometry. }
procedure ExportWidth351;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width351-native.tsv'), '');
end;

{ Read L5 and L7 widths without changing rules or geometry. }
procedure ExportWidth366;
begin
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width366-L5-native.tsv'), '');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width366-L7-native.tsv'), '');
end;

{ Read the USB identification net's existing L2 width constraint. }
procedure ExportUsbIdWidth403;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width403-USB1_ID-L2-native.tsv'), 'USB1_ID');
end;

{ Read surface widths for the remaining pad escapes. }
procedure ExportWidth442;
begin
    ExportWidthForLayer(eTopLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width442-Top-native.tsv'), '');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width442-Bottom-native.tsv'), '');
end;

{ Read the existing L2 width for the SAI transmit clock repair. }
procedure ExportWidth455;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width455-SAI1_TXC-L2-native.tsv'), 'SAI1_TXC');
end;

{ Read the SD2 replacement widths without changing the board. }
procedure ExportWidth482;
begin
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width482-SD2_DATA2-L5-native.tsv'), 'SD2_DATA2');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width482-SD2_DATA2-L7-native.tsv'), 'SD2_DATA2');
end;

{ Read the existing PDM data width scopes. }
procedure ExportWidth459;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width459-PDM_DATA0-L2-native.tsv'), 'PDM_DATA0');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width459-PDM_DATA0-L7-native.tsv'), 'PDM_DATA0');
end;

{ Read the existing JTAG input width for the clock access repair. }
procedure ExportWidth485;
begin
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width485-JTAG_TDI-L3-native.tsv'), 'JTAG_TDI');
end;

{ Read the existing GPIO replacement and reset path widths. }
procedure ExportWidth493;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width493-GPIO1_IO10-L2-native.tsv'), 'GPIO1_IO10');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width493-GPIO1_IO11-L7-native.tsv'), 'GPIO1_IO11');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width493-DRAM_NRESET-L5-native.tsv'), 'DRAM_NRESET');
end;

{ Read the existing GPIO replacement width on L5. }
procedure ExportWidth500;
begin
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width500-GPIO1_IO08-L5-native.tsv'), 'GPIO1_IO08');
end;

{ Read dominant differential gap constraints for remaining pair nets. }
procedure ExportDiffForNets(OnlyDDR_B0 : Boolean; OutputFile : String);
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Track : IPCB_Track;
    Via : IPCB_Via;
    Pad : IPCB_Pad;
    RuleGap : IPCB_DifferentialPairsRoutingRule;
    LayerIndex : Integer;
    QueryLayer : TLayer;
    Names, Report : TStringList;
    ExpectedBoard, NetName, Row : String;
    I : Integer;
    Found : Boolean;
begin
    ExpectedBoard := AstraWorkspacePath('FullDetails.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
    Board := PCBServer.GetPCBBoardByPath(ExpectedBoard);
    if Board = nil then Exit;
    if UpperCase(Board.FileName) <> UpperCase(ExpectedBoard) then Exit;
    Names := TStringList.Create;
    Report := TStringList.Create;
    try
        Names.Add('CSI_CK_N');
        Names.Add('CSI_CK_P');
        Names.Add('CSI_D0_N');
        Names.Add('CSI_D0_P');
        Names.Add('CSI_D1_N');
        Names.Add('CSI_D1_P');
        Names.Add('CSI_D2_N');
        Names.Add('CSI_D2_P');
        Names.Add('CSI_D3_N');
        Names.Add('CSI_D3_P');
        Names.Add('DRAMA_CK_T');
        Names.Add('DRAMA_SDQS0_C');
        Names.Add('DRAMA_SDQS0_T');
        Names.Add('DRAMB_CK_C');
        Names.Add('DRAMB_SDQS1_C');
        Names.Add('DRAMB_SDQS1_T');
        Names.Add('DSI_CK_N');
        Names.Add('DSI_CK_P');
        Names.Add('DSI_D0_N');
        Names.Add('DSI_D0_P');
        Names.Add('DSI_D1_N');
        Names.Add('DSI_D1_P');
        Names.Add('DSI_D2_N');
        Names.Add('DSI_D2_P');
        Names.Add('DSI_D3_N');
        Names.Add('DSI_D3_P');
        Names.Add('PCIE_CLK_N');
        Names.Add('PCIE_CLK_P');
        Names.Add('PCIE_RX_N');
        Names.Add('PCIE_RX_P');
        Names.Add('PCIE_TX_N');
        Names.Add('PCIE_TX_P');
        Names.Add('USB1_DN');
        Names.Add('USB1_DP');
        Names.Add('USB2_DN');
        Names.Add('USB2_DP');
        if OnlyDDR_B0 then
        begin
            Names.Clear;
            Names.Add('DRAMB_SDQS0_C');
            Names.Add('DRAMB_SDQS0_T');
        end;
        Report.Add('net' + #9 + 'status' + #9 + 'object_id' + #9 + 'object_layer_id' + #9 + 'rule_name' + #9 + 'rule_uid' + #9 + 'queried_layer_id' + #9 + 'min_gap_raw' + #9 + 'preferred_gap_raw' + #9 + 'max_gap_raw' + #9 + 'scope1' + #9 + 'summary');
        for I := 0 to Names.Count - 1 do
        begin
            Found := False;
            Iterator := Board.BoardIterator_Create;
            try
                Iterator.AddFilter_ObjectSet(MkSet(eTrackObject, eViaObject, ePadObject));
                Iterator.AddFilter_LayerSet(AllLayers);
                Iterator.AddFilter_Method(eProcessAll);
                Primitive := Iterator.FirstPCBObject;
                while Primitive <> nil do
                begin
                    NetName := '';
                    if Primitive.ObjectId = eTrackObject then
                    begin
                        Track := Primitive;
                        if Track.Net <> nil then NetName := Track.Net.Name;
                    end;
                    if Primitive.ObjectId = eViaObject then
                    begin
                        Via := Primitive;
                        if Via.Net <> nil then NetName := Via.Net.Name;
                    end;
                    if Primitive.ObjectId = ePadObject then
                    begin
                        Pad := Primitive;
                        if Pad.Net <> nil then NetName := Pad.Net.Name;
                    end;
                    if NetName = Names[I] then
                    begin
                        RuleGap := Board.FindDominantRuleForObject(Primitive, eRule_DifferentialPairsRouting);
                        if RuleGap <> nil then
                        begin
                            for LayerIndex := 0 to 7 do
                            begin
                                case LayerIndex of
                                    0 : QueryLayer := eTopLayer;
                                    1 : QueryLayer := eMidLayer1;
                                    2 : QueryLayer := eMidLayer2;
                                    3 : QueryLayer := eMidLayer3;
                                    4 : QueryLayer := eMidLayer4;
                                    5 : QueryLayer := eMidLayer5;
                                    6 : QueryLayer := eMidLayer6;
                                    7 : QueryLayer := eBottomLayer;
                                end;
                                Row := NetName + #9 + 'read' + #9 + IntToStr(Primitive.ObjectId) + #9 + IntToStr(Primitive.Layer) + #9 + RuleGap.Name + #9 + RuleGap.UniqueId + #9 + IntToStr(QueryLayer);
                                Row := Row + #9 + IntToStr(RuleGap.GetState_MinGap(QueryLayer)) + #9 + IntToStr(RuleGap.GetState_PreferedGap(QueryLayer)) + #9 + IntToStr(RuleGap.GetState_MaxGap(QueryLayer));
                                Row := Row + #9 + RuleGap.Scope1Expression + #9 + RuleGap.GetState_DataSummaryString;
                                Report.Add(Row);
                            end;
                        end
                        else Report.Add(NetName + #9 + 'no_dominant_differential_rule');
                        Found := True;
                        Break;
                    end;
                    Primitive := Iterator.NextPCBObject;
                end;
            finally
                Board.BoardIterator_Destroy(Iterator);
            end;
            if not Found then Report.Add(Names[I] + #9 + 'no_existing_primitive');
        end;
        Report.SaveToFile(OutputFile);
    finally
        Names.Free;
        Report.Free;
    end;
end;

{ Read the remaining pair gaps without changing their rules. }
procedure ExportDiff242;
begin
    ExportDiffForNets(False, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\quality\diff242-native.tsv'));
end;

{ Read widths and gaps for the next clock and DDR candidates. }
procedure ExportDiff506;
begin
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width503-QSPIA_DATA3-L5-native.tsv'), 'QSPIA_DATA3');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width503-TS_RES_EXT-L3-native.tsv'), 'TS_RES_EXT');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width503-NVCC_SNVS_1V8-L2-native.tsv'), 'NVCC_SNVS_1V8');
    ExportDiffForNets(True, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\diff506-B0-native.tsv'));
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width506-B0-C-Bottom-native.tsv'), 'DRAMB_SDQS0_C');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width506-B0-T-Bottom-native.tsv'), 'DRAMB_SDQS0_T');
end;

{ Read the existing PMIC control width on L5. }
procedure ExportWidth507;
begin
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width507-PMIC_ON_REQ-L5-native.tsv'), 'PMIC_ON_REQ');
end;

{ Read widths for the DDRB DATA11 preservation paths. }
procedure ExportWidth510;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width510-UART1_CTS-L2-native.tsv'), 'UART1_CTS');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width510-DRAMB_DATA3-L5-native.tsv'), 'DRAMB_DATA3');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width510-I2C1_SCL-L5-native.tsv'), 'I2C1_SCL');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width510-UART1_TXD-L7-native.tsv'), 'UART1_TXD');
end;

{ Read widths for the USB and SAI preservation paths. }
procedure ExportWidth514;
begin
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width514-PMIC_ON_REQ-L3-native.tsv'), 'PMIC_ON_REQ');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width514-USB2_ID-Bottom-native.tsv'), 'USB2_ID');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width513-QSPIA_DATA3-L3-native.tsv'), 'QSPIA_DATA3');
end;

{ Read the PCIe clock widths on its proposed layers. }
procedure ExportWidth516;
begin
    ExportWidthForLayer(eTopLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width516-PCIE_CLK_P-Top-native.tsv'), 'PCIE_CLK_P');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width516-PCIE_CLK_P-Bottom-native.tsv'), 'PCIE_CLK_P');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width516-PCIE_CLK_P-L4-native.tsv'), 'PCIE_CLK_P');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width516-PCIE_CLK_P-L7-native.tsv'), 'PCIE_CLK_P');
end;

{ Read the existing power width on L4. }
procedure ExportWidth517;
begin
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width517-VDD_3V3-L4-native.tsv'), 'VDD_3V3');
end;

{ Read the reset width used by the PCIe clock preservation path. }
procedure ExportWidth521;
begin
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width521-POR_B-L4-native.tsv'), 'POR_B');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width528-GND-Bottom-native.tsv'), 'GND');
end;

{ Read the existing ground width on L6. }
procedure ExportWidth524;
begin
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width524-GND-L6-native.tsv'), 'GND');
end;

{ Read widths for the SAI2 receive frame access and its neighboring repairs. }
procedure ExportWidth522;
begin
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width522-SAI2_RXFS-L3-native.tsv'), 'SAI2_RXFS');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width522-QSPIA_DATA0-L3-native.tsv'), 'QSPIA_DATA0');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width522-GPIO1_IO01-Bottom-native.tsv'), 'GPIO1_IO01');
    ExportWidthForLayer(eTopLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width522-QSPIA_DATA3-Top-native.tsv'), 'QSPIA_DATA3');
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width522-SAI1_RXC-L6-native.tsv'), 'SAI1_RXC');
end;

procedure ExportWidth465;
begin
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width465-PDM_DATA1-L5-native.tsv'), 'PDM_DATA1');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width465-PDM_DATA2-L7-native.tsv'), 'PDM_DATA2');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width465-SAI1_RXD5-L5-native.tsv'), 'SAI1_RXD5');
end;

{ Read the provisional DDR and SD2 L5 widths without changing rules. }
procedure ExportWidth544;
begin
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width579-QSPIA_DATA1-L3-native.tsv'), 'QSPIA_DATA1');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width579-SD3_DATA7-L3-native.tsv'), 'SD3_DATA7');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width579-VDD_1V8-L4-native.tsv'), 'VDD_1V8');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width583-VDD_3V3-L5-native.tsv'), 'VDD_3V3');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width573-VDD_3V3-L7-native.tsv'), 'VDD_3V3');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width571-VDD_ARM_0V9-L5-native.tsv'), 'VDD_ARM_0V9');
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width566-ENET_MDC-L6-native.tsv'), 'ENET_MDC');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-I2C4_SDA-L2-native.tsv'), 'I2C4_SDA');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-I2C4_SDA-L5-native.tsv'), 'I2C4_SDA');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-I2C1_SDA-L5-native.tsv'), 'I2C1_SDA');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-I2C1_SCL-L5-native.tsv'), 'I2C1_SCL');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-I2C2_SCL-L5-native.tsv'), 'I2C2_SCL');
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-DRAMA_CKE1-L6-native.tsv'), 'DRAMA_CKE1');
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-I2C3_SDA-L6-native.tsv'), 'I2C3_SDA');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-UART1_TXD-Bottom-native.tsv'), 'UART1_TXD');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width563-UART4_TXD-Bottom-native.tsv'), 'UART4_TXD');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width562-QSPIA_DATA2-L4-native.tsv'), 'QSPIA_DATA2');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width555-VDD_ARM_0V9-L4-native.tsv'), 'VDD_ARM_0V9');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width544-DRAMB_DATA4-L5-native.tsv'), 'DRAMB_DATA4');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width544-DRAMB_nCS1-L5-native.tsv'), 'DRAMB_nCS1');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width546-SD2_WP-L5-native.tsv'), 'SD2_WP');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width550-NVCC_DRAM_1V1-L2-native.tsv'), 'NVCC_DRAM_1V1');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width554-QSPIA_DATA0-L2-native.tsv'), 'QSPIA_DATA0');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width554-QSPIA_DATA0-L4-native.tsv'), 'QSPIA_DATA0');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width554-UART1_CTS-L7-native.tsv'), 'UART1_CTS');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width554-WL_REG_ON-L4-native.tsv'), 'WL_REG_ON');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width554-WL_REG_ON-L5-native.tsv'), 'WL_REG_ON');
end;

{ Read the supply L6 width without changing rules. }
procedure ExportAAAWidth594;
begin
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width594-VDD_3V3-L6-native.tsv'), 'VDD_3V3');
end;

{ Read the Ground L7 width without changing rules. }
procedure ExportAAWidth592;
begin
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width592-GND-L7-native.tsv'), 'GND');
end;

{ Read the SAI access widths without changing rules. }
procedure ExportAWidth587;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_TXD6-L2-native.tsv'), 'SAI1_TXD6');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-L2-native.tsv'), 'SAI1_RXD2');
end;

{ Read the RXFS signal layer width without changing rules. }
procedure ExportAWidth609;
begin
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width635-SD3_DATA3-L6-native.tsv'), 'SD3_DATA3');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width634-POR_B-L7-native.tsv'), 'POR_B');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width634-PCIE_TX_N-L5-native.tsv'), 'PCIE_TX_N');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width634-CSI_D2_P-L2-native.tsv'), 'CSI_D2_P');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width627-SAI1_TXD3-L2-native.tsv'), 'SAI1_TXD3');
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width627-SAI1_TXD3-L6-native.tsv'), 'SAI1_TXD3');
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width623-SAI1_RXD4-L2-native.tsv'), 'SAI1_RXD4');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width612-SAI1_RXD4-L3-native.tsv'), 'SAI1_RXD4');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width609-SAI1_RXFS-L3-native.tsv'), 'SAI1_RXFS');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width609-GPIO1_IO01-L3-native.tsv'), 'GPIO1_IO01');
end;

{ Read the remaining RXD2 alternatives from the existing width rule. }
procedure ExportBWidth587;
begin
    ExportWidthForLayer(eTopLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-Top-native.tsv'), 'SAI1_RXD2');
    ExportWidthForLayer(eMidLayer2, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-L3-native.tsv'), 'SAI1_RXD2');
    ExportWidthForLayer(eMidLayer3, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-L4-native.tsv'), 'SAI1_RXD2');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-L5-native.tsv'), 'SAI1_RXD2');
    ExportWidthForLayer(eMidLayer5, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-L6-native.tsv'), 'SAI1_RXD2');
    ExportWidthForLayer(eMidLayer6, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-L7-native.tsv'), 'SAI1_RXD2');
    ExportWidthForLayer(eBottomLayer, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_RXD2-Bottom-native.tsv'), 'SAI1_RXD2');
end;

{ Read the TXFS preservation widths without changing rules. }
procedure ExportCWidth587;
begin
    ExportWidthForLayer(eMidLayer1, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_TXFS-L2-native.tsv'), 'SAI1_TXFS');
    ExportWidthForLayer(eMidLayer4, AstraWorkspacePath('FullDetails.PrjScr', 'runs\full-routing-2026-09-30\electrical\width587-SAI1_TXFS-L5-native.tsv'), 'SAI1_TXFS');
end;
