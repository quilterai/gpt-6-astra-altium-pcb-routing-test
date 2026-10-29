{ Add one reviewed power or ground polygon; native repour is separate. }

function FullPolygonExpectedBoard : String;
begin
    Result := AstraWorkspacePath('FullPolygon.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function FullPolygonDirectory : String;
begin
    Result := AstraWorkspacePath('FullPolygon.PrjScr', 'runs\full-routing-2026-09-30\quality\full-polygon');
end;

{ Parse unsigned decimal integers without overflow or implicit conversions. }
function FullPolygonInteger(Text : String; var Value : Integer) : Boolean;
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

{ Preserve the last reached stage if an API or file call stops execution. }
procedure FullPolygonStage(Status : TStringList; StageName : String);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.Add('expected_board=' + FullPolygonExpectedBoard);
    Status.SaveToFile(FullPolygonDirectory + '\full-polygon-status.txt');
end;

{ Use consistent Boolean fields in the definition export. }
function FullPolygonBoolean(Value : Boolean) : String;
begin
    Result := 'false';
    if Value then Result := 'true';
end;

{ Export the boundary and pour settings without cached copper or selection. }
function FullPolygonDefinition(Polygon : IPCB_Polygon) : String;
var
    I : Integer;
    NetName : String;
    Segment : TPolySegment;
begin
    NetName := '';
    if Polygon.Net <> nil then NetName := Polygon.Net.Name;
    Result := NetName + #9 + IntToStr(Polygon.Layer) + #9 +
        IntToStr(Polygon.PolygonType) + #9 + IntToStr(Polygon.PolyHatchStyle) + #9 +
        IntToStr(Polygon.PourOver) + #9 + FullPolygonBoolean(Polygon.RemoveDead) + #9 +
        IntToStr(Polygon.PointCount) + #9 + IntToStr(Polygon.BorderWidth) + #9 +
        IntToStr(Polygon.Grid) + #9 + IntToStr(Polygon.TrackSize) + #9 +
        IntToStr(Polygon.MinTrack) + #9 + FullPolygonBoolean(Polygon.UseOctagons) + #9 +
        FullPolygonBoolean(Polygon.RemoveIslandsByArea) + #9 +
        FloatToStr(Polygon.IslandAreaThreshold) + #9 +
        FullPolygonBoolean(Polygon.RemoveNarrowNecks) + #9 +
        IntToStr(Polygon.NeckWidthThreshold) + #9 + IntToStr(Polygon.ArcApproximation) + #9;
    { The closing entry repeats vertex zero after the last boundary edge. }
    for I := 0 to Polygon.PointCount do
    begin
        Segment := Polygon.Segments[I];
        if I > 0 then Result := Result + ';';
        Result := Result + IntToStr(Segment.Kind) + ',' +
            IntToStr(Segment.vx) + ',' + IntToStr(Segment.vy) + ',' +
            IntToStr(Segment.cx) + ',' + IntToStr(Segment.cy) + ',' +
            IntToStr(Segment.Radius) + ',' + FloatToStr(Segment.Angle1) + ',' +
            FloatToStr(Segment.Angle2);
    end;
end;

{ Count all polygons and collect sorted definitions, optionally excluding one. }
function FullPolygonSnapshot(Board : IPCB_Board; Rows : TStringList;
    Excluded : IPCB_Polygon) : Integer;
var
    Iterator : IPCB_BoardIterator;
    Polygon : IPCB_Polygon;
    Include : Boolean;
begin
    Result := 0;
    Rows.Clear;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(ePolyObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Polygon := Iterator.FirstPCBObject;
        while Polygon <> nil do
        begin
            Inc(Result);
            Include := True;
            if Excluded <> nil then
                Include := Polygon.I_ObjectAddress <> Excluded.I_ObjectAddress;
            if Include then Rows.Add(FullPolygonDefinition(Polygon));
            Polygon := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
    Rows.Sort;
end;

{ Write the fixed export header without changing the comparison list. }
procedure FullPolygonSave(Rows : TStringList; FileName : String);
var
    Output : TStringList;
begin
    Output := TStringList.Create;
    try
        Output.Add('net' + #9 + 'layer_id' + #9 + 'polygon_type' + #9 +
            'hatch_style' + #9 + 'pour_over' + #9 + 'remove_dead' + #9 +
            'point_count' + #9 + 'border_width_raw' + #9 + 'grid_raw' + #9 +
            'track_size_raw' + #9 + 'min_track_raw' + #9 + 'use_octagons' + #9 +
            'remove_islands_by_area' + #9 + 'island_area_threshold_raw' + #9 +
            'remove_narrow_necks' + #9 + 'neck_width_threshold_raw' + #9 +
            'arc_approximation_raw' + #9 + 'segments');
        Output.AddStrings(Rows);
        Output.SaveToFile(FullPolygonDirectory + '\' + FileName);
    finally
        Output.Free;
    end;
end;

{ Inspect the exact loaded work PCB before qualifying polygon construction. }
procedure ExportFullPolygons;
var
    Board : IPCB_Board;
    Rows, Status : TStringList;
    Count : Integer;
begin
    Rows := TStringList.Create;
    Status := TStringList.Create;
    try
        FullPolygonStage(Status, 'inspect_board');
        Board := PCBServer.GetPCBBoardByPath(FullPolygonExpectedBoard);
        if Board = nil then
        begin
            FullPolygonStage(Status, 'refused_no_work_pcb');
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullPolygonExpectedBoard) then
        begin
            FullPolygonStage(Status, 'refused_wrong_board');
            Exit;
        end;
        FullPolygonStage(Status, 'read_polygon_definitions');
        Count := FullPolygonSnapshot(Board, Rows, nil);
        FullPolygonSave(Rows, 'polygons.tsv');
        FullPolygonStage(Status, 'export_complete_read_only');
        Status.Add('polygon_count=' + IntToStr(Count));
        Status.SaveToFile(FullPolygonDirectory + '\full-polygon-status.txt');
    finally
        Rows.Free;
        Status.Free;
    end;
end;

{ Accept only exact reviewed outlines and their required insertion order. }
function FullPolygonApprovedVertices(Row : String) : Integer;
begin
    Result := 0;
    if Row = 'NVCC_DRAM_1V1' + #9 + '5' + #9 + '10' + #9 + '115883500' + #9 + '89394100' + #9 +
        '124133500' + #9 + '89394100' + #9 + '124133500' + #9 + '97694100' + #9 + '115883500' + #9 +
        '97694100' then Result := 4;
    if Row = 'VDD_3V3' + #9 + '5' + #9 + '11' + #9 + '119633500' + #9 + '83694100' + #9 +
        '135633500' + #9 + '83694100' + #9 + '135633500' + #9 + '102644100' + #9 + '124183500' + #9 +
        '102644100' + #9 + '124183500' + #9 + '89394100' + #9 + '125633500' + #9 + '89394100' + #9 +
        '125633500' + #9 + '84894100' + #9 + '119633500' + #9 + '84894100' then Result := 8;
    if Row = 'VDD_SOC_0V8' + #9 + '6' + #9 + '12' + #9 + '121983500' + #9 + '87894100' + #9 +
        '129033500' + #9 + '87894100' + #9 + '129033500' + #9 + '94694100' + #9 + '125833500' + #9 +
        '94694100' + #9 + '125833500' + #9 + '95394100' + #9 + '125343500' + #9 + '95394100' + #9 +
        '125343500' + #9 + '94794100' + #9 + '124743500' + #9 + '94794100' + #9 + '124743500' + #9 +
        '94444100' + #9 + '125383500' + #9 + '94444100' + #9 + '125383500' + #9 + '93844100' + #9 +
        '125883500' + #9 + '93844100' + #9 + '125883500' + #9 + '94094100' + #9 + '128033500' + #9 +
        '94094100' + #9 + '128033500' + #9 + '88994100' + #9 + '121983500' + #9 + '88994100' then Result := 16;
    if Row = 'VDD_DRAM&PU_0V9' + #9 + '6' + #9 + '13' + #9 + '120333500' + #9 + '84944100' + #9 +
        '123183500' + #9 + '84944100' + #9 + '123183500' + #9 + '86044100' + #9 + '121033500' + #9 +
        '86044100' + #9 + '121033500' + #9 + '94994100' + #9 + '123883500' + #9 + '94994100' + #9 +
        '123883500' + #9 + '93444100' + #9 + '124433500' + #9 + '93444100' + #9 + '124433500' + #9 +
        '94864100' + #9 + '125033500' + #9 + '94864100' + #9 + '125033500' + #9 + '95394100' + #9 +
        '120333500' + #9 + '95394100' then Result := 12;
    if Row = 'VDD_ARM_0V9' + #9 + '6' + #9 + '14' + #9 + '121133500' + #9 + '89294100' + #9 +
        '122133500' + #9 + '89294100' + #9 + '122133500' + #9 + '90294100' + #9 + '126833500' + #9 +
        '92594100' + #9 + '126833500' + #9 + '93494100' + #9 + '125633500' + #9 + '93494100' + #9 +
        '125633500' + #9 + '93744100' + #9 + '125333500' + #9 + '93744100' + #9 + '125333500' + #9 +
        '94294100' + #9 + '124733500' + #9 + '94294100' + #9 + '124733500' + #9 + '93394100' + #9 +
        '125133500' + #9 + '93394100' + #9 + '125133500' + #9 + '92594100' + #9 + '121133500' + #9 +
        '90794100' then Result := 14;
    if Row = 'GND' + #9 + '32' + #9 + '15' + #9 +
        '115883500' + #9 + '83144100' + #9 + '128133500' + #9 + '83144100' + #9 +
        '128133500' + #9 + '97694100' + #9 + '124183500' + #9 + '97694100' + #9 +
        '124183500' + #9 + '90644100' + #9 + '115883500' + #9 + '90644100' then Result := 6;
    if Row =
        'VDD_1V8' + #9 + '6' + #9 + '16' + #9 + '116633500' + #9 + '83144100' + #9 + '120283500' + #9 +
        '83144100' + #9 + '120283500' + #9 + '95444100' + #9 + '125883500' + #9 + '95444100' + #9 + '125883500' + #9 +
        '94744100' + #9 + '129083500' + #9 + '94744100' + #9 + '129083500' + #9 + '83144100' + #9 + '135183500' + #9 +
        '83144100' + #9 + '135183500' + #9 + '102644100' + #9 + '116633500' + #9 + '102644100' + #9 + '115883500' + #9 +
        '101894100' + #9 + '115883500' + #9 + '83894100' then Result := 12;
    if Row = 'VSYS_5V' + #9 + '5' + #9 + '17' + #9 + '115883500' + #9 + '84944100' + #9 +
        '125583500' + #9 + '84944100' + #9 + '125583500' + #9 + '89344100' + #9 + '115883500' + #9 +
        '89344100' then Result := 4;
    if Row = 'VDD_1V8' + #9 + '4' + #9 + '18' + #9 + '116633500' + #9 + '94694100' + #9 +
        '120733500' + #9 + '94694100' + #9 + '120733500' + #9 + '96994100' + #9 + '116633500' + #9 +
        '96994100' then Result := 4;
    if Row = 'VDD_1V8' + #9 + '4' + #9 + '19' + #9 + '116633500' + #9 + '92394100' + #9 +
        '120733500' + #9 + '92394100' + #9 + '120733500' + #9 + '95094100' + #9 + '116633500' + #9 +
        '95094100' then Result := 4;
    if Row = 'VDD_DRAM&PU_0V9' + #9 + '4' + #9 + '20' + #9 + '120785500' + #9 + '84894100' + #9 +
        '129133500' + #9 + '84894100' + #9 + '129133500' + #9 + '97394100' + #9 + '120785500' + #9 +
        '97394100' then Result := 4;
    if Row = 'VDD_1V8' + #9 + '4' + #9 + '21' + #9 + '121233500' + #9 + '97494100' + #9 +
        '124133500' + #9 + '97494100' + #9 + '124133500' + #9 + '101294100' + #9 + '121233500' + #9 +
        '101294100' then Result := 4;
    if Row = 'NVCC_SNVS_1V8' + #9 + '4' + #9 + '22' + #9 + '116833500' + #9 + '83144100' + #9 +
        '131133500' + #9 + '83144100' + #9 + '131133500' + #9 + '98294100' + #9 + '127333500' + #9 +
        '98294100' + #9 + '127333500' + #9 + '97494100' + #9 + '129333500' + #9 + '97494100' + #9 +
        '129333500' + #9 + '84694100' + #9 + '118633500' + #9 + '84694100' + #9 + '118633500' + #9 +
        '88694100' + #9 + '116833500' + #9 + '88694100' then Result := 10;
end;

{ Validate one approved outline before adding an undo-registered object. }
procedure AddExplicitFullPolygon;
var
    Board, ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net, TargetNet : IPCB_Net;
    Polygon, NewPolygon : IPCB_Polygon;
    Segment : TPolySegment;
    Lines, Fields, Status, BeforeRows, AfterRows, NewRows : TStringList;
    Row, ActualNetName, RequestedNet, Header : String;
    Values : array[1..34] of Integer;
    XRaw, YRaw : array[0..16] of Integer;
    I, Separator, ParsedValue, NetMatches, LayerPolygons, BeforeCount, AfterCount,
        VertexCount, NumericCount : Integer;
    Matches : Boolean;
begin
    Lines := TStringList.Create;
    Fields := TStringList.Create;
    Status := TStringList.Create;
    BeforeRows := TStringList.Create;
    AfterRows := TStringList.Create;
    NewRows := TStringList.Create;
    try
        FullPolygonStage(Status, 'validate_request');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board = nil then
        begin
            FullPolygonStage(Status, 'refused_no_active_pcb');
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullPolygonExpectedBoard) then
        begin
            FullPolygonStage(Status, 'refused_wrong_board');
            Exit;
        end;
        if not FileExists(FullPolygonDirectory + '\add-polygon.tsv') then
        begin
            FullPolygonStage(Status, 'refused_missing_request');
            Exit;
        end;
        Lines.LoadFromFile(FullPolygonDirectory + '\add-polygon.tsv');
        Lines.SaveToFile(FullPolygonDirectory + '\full-polygon-request.tsv');
        if Lines.Count <> 2 then
        begin
            FullPolygonStage(Status, 'refused_row_count');
            Exit;
        end;
        Row := Lines.Strings[1];
        VertexCount := FullPolygonApprovedVertices(Row);
        if VertexCount = 0 then
        begin
            FullPolygonStage(Status, 'refused_fixed_geometry_or_count');
            Exit;
        end;
        Header := 'net' + #9 + 'layer_id' + #9 + 'expected_polygon_count';
        for I := 1 to VertexCount do
            Header := Header + #9 + 'x' + IntToStr(I) + '_raw' + #9 +
                'y' + IntToStr(I) + '_raw';
        if Lines.Strings[0] <> Header then
        begin
            FullPolygonStage(Status, 'refused_header');
            Exit;
        end;
        NumericCount := 2 + 2 * VertexCount;
        for I := 1 to NumericCount do
        begin
            Separator := Pos(#9, Row);
            if Separator = 0 then
            begin
                FullPolygonStage(Status, 'refused_columns');
                Exit;
            end;
            Fields.Add(Copy(Row, 1, Separator - 1));
            Row := Copy(Row, Separator + 1, Length(Row));
        end;
        Fields.Add(Row);
        if Pos(#9, Row) > 0 then
        begin
            FullPolygonStage(Status, 'refused_extra_columns');
            Exit;
        end;
        RequestedNet := Fields.Strings[0];
        for I := 1 to NumericCount do
        begin
            if not FullPolygonInteger(Fields.Strings[I], ParsedValue) then
            begin
                FullPolygonStage(Status, 'refused_numeric_field');
                Exit;
            end;
            Values[I] := ParsedValue;
        end;
        for I := 0 to VertexCount - 1 do
        begin
            XRaw[I] := Values[3 + I * 2];
            YRaw[I] := Values[4 + I * 2];
        end;
        XRaw[VertexCount] := XRaw[0];
        YRaw[VertexCount] := YRaw[0];
        FullPolygonStage(Status, 'preflight_native_objects');
        BeforeCount := FullPolygonSnapshot(Board, BeforeRows, nil);
        FullPolygonSave(BeforeRows, 'before-polygons.tsv');
        if BeforeCount <> Values[2] then
        begin
            FullPolygonStage(Status, 'refused_actual_polygon_count');
            Exit;
        end;
        TargetNet := nil;
        NetMatches := 0;
        LayerPolygons := 0;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eNetObject, ePolyObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Primitive := Iterator.FirstPCBObject;
            while Primitive <> nil do
            begin
                if Primitive.ObjectId = eNetObject then
                begin
                    Net := Primitive;
                    if Net.Name = RequestedNet then
                    begin
                        TargetNet := Net;
                        Inc(NetMatches);
                    end;
                end;
                if Primitive.ObjectId = ePolyObject then
                begin
                    Polygon := Primitive;
                    if (Polygon.Layer = Values[1]) and (Polygon.Net <> nil) then
                        if Polygon.Net.Name = RequestedNet then Inc(LayerPolygons);
                end;
                Primitive := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        { Reviewed VDD1V8 additions have exact count and outline guards. }
        Matches := (LayerPolygons = 0) or
            ((RequestedNet = 'VDD_1V8') and (Values[1] = 4) and
             (((BeforeCount = 19) and (LayerPolygons = 1)) or
              ((BeforeCount = 21) and (LayerPolygons = 2))));
        if (NetMatches <> 1) or (TargetNet = nil) or not Matches then
        begin
            FullPolygonStage(Status, 'refused_net_or_existing_same_net_layer_polygon');
            Exit;
        end;
        ActiveBoard := PCBServer.GetCurrentPCBBoard;
        if ActiveBoard = nil then
        begin
            FullPolygonStage(Status, 'refused_active_board_changed');
            Exit;
        end;
        if UpperCase(ActiveBoard.FileName) <> UpperCase(FullPolygonExpectedBoard) then
        begin
            FullPolygonStage(Status, 'refused_active_board_changed');
            Exit;
        end;
        FullPolygonStage(Status, 'construct_detached_polygon');
        PCBServer.PreProcess;
        try
            NewPolygon := PCBServer.PCBObjectFactory(ePolyObject, eNoDimension, eCreate_Default);
            if NewPolygon = nil then
            begin
                FullPolygonStage(Status, 'failed_factory_no_board_add');
                Exit;
            end;
            NewPolygon.Layer := Values[1];
            NewPolygon.Net := TargetNet;
            NewPolygon.SetState_PolygonType(eSignalLayerPolygon);
            NewPolygon.SetState_PolyHatchStyle(ePolySolid);
            NewPolygon.SetState_PourOver(ePolygonPourOver_SameNet);
            NewPolygon.SetState_RemoveDead(True);
            NewPolygon.SetState_PointCount(VertexCount);
            Segment := NewPolygon.Segments[0];
            Segment.Kind := ePolySegmentLine;
            Segment.cx := 0;
            Segment.cy := 0;
            Segment.Radius := 0;
            Segment.Angle1 := 0;
            Segment.Angle2 := 0;
            { The closing entry repeats vertex zero after the boundary edges. }
            for I := 0 to VertexCount do
            begin
                Segment.vx := XRaw[I];
                Segment.vy := YRaw[I];
                NewPolygon.SetState_Segments(I, Segment);
            end;
            FullPolygonStage(Status, 'verify_detached_polygon_before_add');
            Matches := (NewPolygon.PointCount = VertexCount) and (NewPolygon.Layer = Values[1]) and
                (NewPolygon.PolygonType = eSignalLayerPolygon) and
                (NewPolygon.PolyHatchStyle = ePolySolid) and
                (NewPolygon.PourOver = ePolygonPourOver_SameNet) and NewPolygon.RemoveDead;
            ActualNetName := '';
            if NewPolygon.Net <> nil then ActualNetName := NewPolygon.Net.Name;
            Matches := Matches and (ActualNetName = RequestedNet);
            for I := 0 to VertexCount do
            begin
                Segment := NewPolygon.Segments[I];
                Matches := Matches and (Segment.Kind = ePolySegmentLine) and
                    (Segment.vx = XRaw[I]) and (Segment.vy = YRaw[I]) and
                    (Segment.cx = 0) and (Segment.cy = 0) and (Segment.Radius = 0) and
                    (Segment.Angle1 = 0) and (Segment.Angle2 = 0);
            end;
            AfterCount := FullPolygonSnapshot(Board, AfterRows, nil);
            Matches := Matches and (AfterCount = BeforeCount) and
                (BeforeRows.Text = AfterRows.Text);
            if not Matches then
            begin
                FullPolygonStage(Status, 'refused_detached_readback_no_board_add');
                Exit;
            end;
            FullPolygonStage(Status, 'add_and_register_polygon_inspect_on_interruption');
            Board.AddPCBObject(NewPolygon);
            PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast,
                PCBM_BoardRegisteration, NewPolygon.I_ObjectAddress);
        finally
            PCBServer.PostProcess;
        end;
        FullPolygonStage(Status, 'verify_polygon_and_old_definitions');
        AfterCount := FullPolygonSnapshot(Board, AfterRows, NewPolygon);
        FullPolygonSave(AfterRows, 'after-old-polygons.tsv');
        NewRows.Add(FullPolygonDefinition(NewPolygon));
        FullPolygonSave(NewRows, 'added-polygon.tsv');
        ActualNetName := '';
        if NewPolygon.Net <> nil then ActualNetName := NewPolygon.Net.Name;
        Matches := (AfterCount = BeforeCount + 1) and (BeforeRows.Text = AfterRows.Text) and
            (ActualNetName = RequestedNet) and (NewPolygon.Layer = Values[1]) and
            (NewPolygon.PolygonType = eSignalLayerPolygon) and
            (NewPolygon.PolyHatchStyle = ePolySolid) and
            (NewPolygon.PourOver = ePolygonPourOver_SameNet) and NewPolygon.RemoveDead and
            (NewPolygon.PointCount = VertexCount);
        for I := 0 to VertexCount do
        begin
            Segment := NewPolygon.Segments[I];
            Matches := Matches and (Segment.Kind = ePolySegmentLine) and
                (Segment.vx = XRaw[I]) and (Segment.vy = YRaw[I]) and
                (Segment.cx = 0) and (Segment.cy = 0) and (Segment.Radius = 0) and
                (Segment.Angle1 = 0) and (Segment.Angle2 = 0);
        end;
        if not Matches then
        begin
            FullPolygonStage(Status, 'failed_readback_inspect_board');
            Exit;
        end;
        FullPolygonStage(Status, 'added_definition_readback_ok_pour_and_drc_not_checked');
        Status.Add('before_polygon_count=' + IntToStr(BeforeCount));
        Status.Add('after_polygon_count=' + IntToStr(AfterCount));
        Status.Add('old_exported_definitions_unchanged=true');
        Status.SaveToFile(FullPolygonDirectory + '\full-polygon-status.txt');
    finally
        Lines.Free;
        Fields.Free;
        Status.Free;
        BeforeRows.Free;
        AfterRows.Free;
        NewRows.Free;
    end;
end;
