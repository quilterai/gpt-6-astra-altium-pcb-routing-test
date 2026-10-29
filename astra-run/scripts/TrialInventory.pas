{ Inventory, selection, and guarded polygon refresh for the full-run working PCB. }

function InventoryExpectedBoard : String;
begin
    Result := AstraWorkspacePath('TrialInventory.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function InventoryOutputDirectory : String;
begin
    Result := AstraWorkspacePath('TrialInventory.PrjScr', 'runs\full-routing-2026-09-30\current-inspection');
end;

{ Find the loaded trial by its full path, even while the script editor is active. }
function InventoryTrialBoard : IPCB_Board;
begin
    Result := PCBServer.GetPCBBoardByPath(InventoryExpectedBoard);
    if Result = nil then
    begin
        ShowMessage('The full-run working PCB is not open. Open the exact working PCB first.');
        Exit;
    end;
    if UpperCase(Result.FileName) <> UpperCase(InventoryExpectedBoard) then
    begin
        ShowMessage('Refusing PCB: ' + Result.FileName);
        Result := nil;
        Exit;
    end;
    if not DirectoryExists(InventoryOutputDirectory) then
    begin
        ShowMessage('Create the output directory first: ' + InventoryOutputDirectory);
        Result := nil;
    end;
end;

{ Keep one TSV field on one line. }
function InventoryField(Value : String) : String;
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

{ Preserve the current stage if an API call stops the export. }
procedure InventoryStage(Status : TStringList; StageName : String);
begin
    if Status.Count > 0 then
        if Status.Strings[0] = StageName then Exit;
    Status.Clear;
    Status.Add(StageName);
    Status.SaveToFile(InventoryOutputDirectory + '\inventory-status.txt');
end;

{ Use explicit text for Boolean values in exported files. }
function InventoryBoolean(Value : Boolean) : String;
begin
    Result := 'false';
    if Value then Result := 'true';
end;

{ Read a primitive's net without assigning or rebuilding connectivity. }
function InventoryNetName(Primitive : IPCB_Primitive) : String;
begin
    Result := '';
    if Primitive.Net <> nil then Result := InventoryField(Primitive.Net.Name);
end;

{ Export live database values without changing or saving the board. }
procedure ExportTrialInventory;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net : IPCB_Net;
    Pad : IPCB_Pad;
    Track : IPCB_Track;
    Via : IPCB_Via;
    Connection : IPCB_Connection;
    Rule : IPCB_Rule;
    Summary, Nets, Pads, Tracks, Vias, Connections, Rules, Status : TStringList;
    Refdes, ModeName : String;
    RatsnestCount, RedundantCount, InvalidNetCount : Integer;
begin
    Board := InventoryTrialBoard;
    if Board = nil then Exit;
    Summary := TStringList.Create;
    Nets := TStringList.Create;
    Pads := TStringList.Create;
    Tracks := TStringList.Create;
    Vias := TStringList.Create;
    Connections := TStringList.Create;
    Rules := TStringList.Create;
    Status := TStringList.Create;
    try
        InventoryStage(Status, 'prepare_headers');
        Nets.Add('net' + #9 + 'pin_count' + #9 + 'via_count' + #9 + 'routed_length_raw' + #9 + 'connectivity_invalid' + #9 + 'connections_visible');
        Pads.Add('refdes' + #9 + 'pad' + #9 + 'net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'layer_id' + #9 + 'layer' + #9 + 'rotation_degrees' + #9 + 'top_x_size_raw' + #9 + 'top_y_size_raw' + #9 + 'hole_size_raw' + #9 + 'selected');
        Tracks.Add('net' + #9 + 'x1_raw' + #9 + 'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 + 'width_raw' + #9 + 'layer_id' + #9 + 'layer' + #9 + 'selected');
        Vias.Add('net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'size_raw' + #9 + 'hole_size_raw' + #9 + 'low_layer_id' + #9 + 'high_layer_id' + #9 + 'selected');
        Connections.Add('net' + #9 + 'x1_raw' + #9 + 'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 + 'layer1_id' + #9 + 'layer2_id' + #9 + 'mode' + #9 + 'redundant' + #9 + 'selected');
        Rules.Add('name' + #9 + 'kind_id' + #9 + 'priority' + #9 + 'drc_enabled' + #9 + 'scope1' + #9 + 'scope2' + #9 + 'summary');
        RatsnestCount := 0;
        RedundantCount := 0;
        InvalidNetCount := 0;
        InventoryStage(Status, 'create_iterator');
        Iterator := Board.BoardIterator_Create;
        try
            InventoryStage(Status, 'configure_iterator');
            Iterator.AddFilter_ObjectSet(MkSet(eNetObject, ePadObject, eTrackObject, eViaObject, eConnectionObject, eRuleObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            InventoryStage(Status, 'first_object');
            Primitive := Iterator.FirstPCBObject;
            while Primitive <> nil do
            begin
                case Primitive.ObjectId of
                    eNetObject:
                    begin
                        InventoryStage(Status, 'read_nets');
                        Net := Primitive;
                        Nets.Add(InventoryField(Net.Name) + #9 + IntToStr(Net.PinCount) + #9 + IntToStr(Net.ViaCount) + #9 + IntToStr(Net.RoutedLength) + #9 + InventoryBoolean(Net.ConnectivelyInvalid) + #9 + InventoryBoolean(Net.ConnectsVisible));
                        if Net.ConnectivelyInvalid then Inc(InvalidNetCount);
                    end;
                    ePadObject:
                    begin
                        InventoryStage(Status, 'read_pads');
                        Pad := Primitive;
                        Refdes := '';
                        if Pad.Component <> nil then Refdes := InventoryField(Pad.Component.Name.Text);
                        Pads.Add(Refdes + #9 + InventoryField(Pad.Name) + #9 + InventoryNetName(Pad) + #9 + IntToStr(Pad.X) + #9 + IntToStr(Pad.Y) + #9 + IntToStr(Pad.Layer) + #9 + Layer2String(Pad.Layer) + #9 + FloatToStr(Pad.Rotation) + #9 + IntToStr(Pad.TopXSize) + #9 + IntToStr(Pad.TopYSize) + #9 + IntToStr(Pad.HoleSize) + #9 + InventoryBoolean(Pad.Selected));
                    end;
                    eTrackObject:
                    begin
                        InventoryStage(Status, 'read_tracks');
                        Track := Primitive;
                        Tracks.Add(InventoryNetName(Track) + #9 + IntToStr(Track.X1) + #9 + IntToStr(Track.Y1) + #9 + IntToStr(Track.X2) + #9 + IntToStr(Track.Y2) + #9 + IntToStr(Track.Width) + #9 + IntToStr(Track.Layer) + #9 + Layer2String(Track.Layer) + #9 + InventoryBoolean(Track.Selected));
                    end;
                    eViaObject:
                    begin
                        InventoryStage(Status, 'read_vias');
                        Via := Primitive;
                        Vias.Add(InventoryNetName(Via) + #9 + IntToStr(Via.X) + #9 + IntToStr(Via.Y) + #9 + IntToStr(Via.Size) + #9 + IntToStr(Via.HoleSize) + #9 + IntToStr(Via.LowLayer) + #9 + IntToStr(Via.HighLayer) + #9 + InventoryBoolean(Via.Selected));
                    end;
                    eConnectionObject:
                    begin
                        InventoryStage(Status, 'read_connections');
                        Connection := Primitive;
                        ModeName := 'other';
                        if Connection.Mode = eRatsNestConnection then ModeName := 'ratsnest';
                        if Connection.Mode = eBrokenNetMarker then ModeName := 'broken_net_marker';
                        Connections.Add(InventoryNetName(Connection) + #9 + IntToStr(Connection.X1) + #9 + IntToStr(Connection.Y1) + #9 + IntToStr(Connection.X2) + #9 + IntToStr(Connection.Y2) + #9 + IntToStr(Connection.Layer1) + #9 + IntToStr(Connection.Layer2) + #9 + ModeName + #9 + InventoryBoolean(Connection.IsRedundant) + #9 + InventoryBoolean(Connection.Selected));
                        if Connection.IsRedundant then Inc(RedundantCount)
                        else if Connection.Mode = eRatsNestConnection then Inc(RatsnestCount);
                    end;
                    eRuleObject:
                    begin
                        InventoryStage(Status, 'read_rules');
                        Rule := Primitive;
                        Rules.Add(InventoryField(Rule.Name) + #9 + IntToStr(Rule.RuleKind) + #9 + IntToStr(Rule.Priority) + #9 + InventoryBoolean(Rule.DRCEnabled) + #9 + InventoryField(Rule.Scope1Expression) + #9 + InventoryField(Rule.Scope2Expression) + #9 + InventoryField(Rule.GetState_DataSummaryString));
                    end;
                end;
                Primitive := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        InventoryStage(Status, 'build_summary');
        Summary.Add('field' + #9 + 'value');
        Summary.Add('board_file' + #9 + InventoryField(Board.FileName));
        Summary.Add('coordinate_units' + #9 + 'Altium internal units');
        Summary.Add('internal_units_per_mil' + #9 + IntToStr(MilsToCoord(1)));
        Summary.Add('x_origin_raw' + #9 + IntToStr(Board.XOrigin));
        Summary.Add('y_origin_raw' + #9 + IntToStr(Board.YOrigin));
        Summary.Add('net_count' + #9 + IntToStr(Nets.Count - 1));
        Summary.Add('pad_count' + #9 + IntToStr(Pads.Count - 1));
        Summary.Add('track_segment_count' + #9 + IntToStr(Tracks.Count - 1));
        Summary.Add('via_count' + #9 + IntToStr(Vias.Count - 1));
        Summary.Add('connection_object_count' + #9 + IntToStr(Connections.Count - 1));
        Summary.Add('nonredundant_ratsnest_connections' + #9 + IntToStr(RatsnestCount));
        Summary.Add('redundant_connection_objects' + #9 + IntToStr(RedundantCount));
        Summary.Add('connectivity_invalid_nets' + #9 + IntToStr(InvalidNetCount));
        Summary.Add('rule_count' + #9 + IntToStr(Rules.Count - 1));
        InventoryStage(Status, 'write_nets');
        Nets.SaveToFile(InventoryOutputDirectory + '\nets.tsv');
        InventoryStage(Status, 'write_pads');
        Pads.SaveToFile(InventoryOutputDirectory + '\pads.tsv');
        InventoryStage(Status, 'write_tracks');
        Tracks.SaveToFile(InventoryOutputDirectory + '\tracks.tsv');
        InventoryStage(Status, 'write_vias');
        Vias.SaveToFile(InventoryOutputDirectory + '\vias.tsv');
        InventoryStage(Status, 'write_connections');
        Connections.SaveToFile(InventoryOutputDirectory + '\connections.tsv');
        InventoryStage(Status, 'write_rules');
        Rules.SaveToFile(InventoryOutputDirectory + '\rules.tsv');
        InventoryStage(Status, 'write_summary');
        Summary.SaveToFile(InventoryOutputDirectory + '\board.tsv');
        InventoryStage(Status, 'complete');
    finally
        Summary.Free;
        Nets.Free;
        Pads.Free;
        Tracks.Free;
        Vias.Free;
        Connections.Free;
        Rules.Free;
        Status.Free;
    end;
end;

{ Replace selection from a validated net list, optionally using only airwires. }
procedure SelectAllowlistedObjects(ConnectionsOnly : Boolean);
var
    Board : IPCB_Board;
    ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net : IPCB_Net;
    Lines, Allowed, Known : TStringList;
    Name, AllowlistPath, ObjectLabel : String;
    I, SelectedCount : Integer;
begin
    Board := InventoryTrialBoard;
    if Board = nil then Exit;
    ActiveBoard := PCBServer.GetCurrentPCBBoard;
    if ActiveBoard = nil then
    begin
        ShowMessage('Activate the routing-50 trial PCB before changing selection.');
        Exit;
    end;
    if UpperCase(ActiveBoard.FileName) <> UpperCase(InventoryExpectedBoard) then
    begin
        ShowMessage('The active PCB is not the routing-50 trial. Selection unchanged.');
        Exit;
    end;
    AllowlistPath := InventoryOutputDirectory + '\select-nets.txt';
    if not FileExists(AllowlistPath) then
    begin
        ShowMessage('Missing net allowlist: ' + AllowlistPath);
        Exit;
    end;
    Lines := TStringList.Create;
    Allowed := TStringList.Create;
    Known := TStringList.Create;
    try
        Allowed.CaseSensitive := True;
        Known.CaseSensitive := True;
        Lines.LoadFromFile(AllowlistPath);
        for I := 0 to Lines.Count - 1 do
        begin
            Name := Trim(Lines.Strings[I]);
            if Name <> '' then
                if Copy(Name, 1, 1) <> '#' then
                    if Allowed.IndexOf(Name) < 0 then Allowed.Add(Name);
        end;
        if (Allowed.Count = 0) or (Allowed.Count > 50) then
        begin
            ShowMessage('Allowlist must contain between 1 and 50 exact net names.');
            Exit;
        end;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eNetObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Net := Iterator.FirstPCBObject;
            while Net <> nil do
            begin
                Known.Add(Net.Name);
                Net := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        for I := 0 to Allowed.Count - 1 do
            if Known.IndexOf(Allowed.Strings[I]) < 0 then
            begin
                ShowMessage('Unknown net; selection unchanged: ' + Allowed.Strings[I]);
                Exit;
            end;
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
        SelectedCount := 0;
        Iterator := Board.BoardIterator_Create;
        try
            if ConnectionsOnly then
                Iterator.AddFilter_ObjectSet(MkSet(eConnectionObject))
            else
                Iterator.AddFilter_ObjectSet(MkSet(ePadObject, eTrackObject, eViaObject, eArcObject, eConnectionObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Primitive := Iterator.FirstPCBObject;
            while Primitive <> nil do
            begin
                if Primitive.Net <> nil then
                    if Allowed.IndexOf(Primitive.Net.Name) >= 0 then
                    begin
                        Primitive.Selected := True;
                        Inc(SelectedCount);
                    end;
                Primitive := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        Client.SendMessage('PCB:Zoom', 'Action=Redraw', 255, Client.CurrentView);
        ObjectLabel := ' primitives';
        if ConnectionsOnly then ObjectLabel := ' connections';
        ShowMessage('Selected ' + IntToStr(SelectedCount) + ObjectLabel + ' from ' + IntToStr(Allowed.Count) + ' allowlisted nets.');
    finally
        Lines.Free;
        Allowed.Free;
        Known.Free;
    end;
end;

{ Select electrical primitives for each exact requested net. }
procedure SelectAllowlistedNets;
begin
    SelectAllowlistedObjects(False);
end;

{ Select airwires without existing track widths influencing ActiveRoute. }
procedure SelectAllowlistedConnections;
begin
    SelectAllowlistedObjects(True);
end;

{ Select exact source pads only after every requested pad and net is validated. }
procedure SelectAllowlistedSourcePads;
var
    Board, ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Pad : IPCB_Pad;
    Lines, Keys, Nets, Found, Audit : TStringList;
    InputPath, AuditPath, Row, Refdes, PadName, NetName, Key : String;
    I, Separator, MatchIndex, SelectedCount : Integer;
begin
    Board := InventoryTrialBoard;
    if Board = nil then Exit;
    ActiveBoard := PCBServer.GetCurrentPCBBoard;
    if ActiveBoard = nil then
    begin
        ShowMessage('Activate the routing-50 trial PCB before changing selection.');
        Exit;
    end;
    if UpperCase(ActiveBoard.FileName) <> UpperCase(InventoryExpectedBoard) then
    begin
        ShowMessage('The active PCB is not the routing-50 trial. Selection unchanged.');
        Exit;
    end;
    InputPath := InventoryOutputDirectory + '\select-pads.tsv';
    AuditPath := InventoryOutputDirectory + '\selected-source-pads.tsv';
    if not FileExists(InputPath) then
    begin
        ShowMessage('Missing source-pad allowlist: ' + InputPath);
        Exit;
    end;
    Lines := TStringList.Create;
    Keys := TStringList.Create;
    Nets := TStringList.Create;
    Found := TStringList.Create;
    Audit := TStringList.Create;
    try
        Keys.CaseSensitive := True;
        Nets.CaseSensitive := True;
        Found.CaseSensitive := True;
        Lines.LoadFromFile(InputPath);
        if (Lines.Count < 2) or (Lines.Count > 51) then
        begin
            ShowMessage('Source-pad TSV needs a header and 1-50 rows. Selection unchanged.');
            Exit;
        end;
        if Lines.Strings[0] <> 'refdes' + #9 + 'pad' + #9 + 'net' then
        begin
            ShowMessage('Expected TSV header: refdes, pad, net, separated by tabs. Selection unchanged.');
            Exit;
        end;
        for I := 1 to Lines.Count - 1 do
        begin
            Row := Lines.Strings[I];
            Separator := Pos(#9, Row);
            if Separator = 0 then
            begin
                ShowMessage('Missing TSV columns at line ' + IntToStr(I + 1) + '. Selection unchanged.');
                Exit;
            end;
            Refdes := Copy(Row, 1, Separator - 1);
            Row := Copy(Row, Separator + 1, Length(Row));
            Separator := Pos(#9, Row);
            if Separator = 0 then
            begin
                ShowMessage('Missing TSV columns at line ' + IntToStr(I + 1) + '. Selection unchanged.');
                Exit;
            end;
            PadName := Copy(Row, 1, Separator - 1);
            NetName := Copy(Row, Separator + 1, Length(Row));
            if (Refdes = '') or (PadName = '') or (NetName = '') or
               (Refdes <> Trim(Refdes)) or (PadName <> Trim(PadName)) or
               (NetName <> Trim(NetName)) or (Pos(#9, NetName) > 0) then
            begin
                ShowMessage('Expected three exact nonempty TSV fields at line ' + IntToStr(I + 1) + '. Selection unchanged.');
                Exit;
            end;
            Key := Refdes + #9 + PadName;
            if Keys.IndexOf(Key) >= 0 then
            begin
                ShowMessage('Duplicate source pad: ' + Refdes + '-' + PadName + '. Selection unchanged.');
                Exit;
            end;
            if Nets.IndexOf(NetName) >= 0 then
            begin
                ShowMessage('Choose only one source pad per net: ' + NetName + '. Selection unchanged.');
                Exit;
            end;
            Keys.Add(Key);
            Nets.Add(NetName);
        end;

        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(ePadObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Pad := Iterator.FirstPCBObject;
            while Pad <> nil do
            begin
                if Pad.Component <> nil then
                begin
                    Key := Pad.Component.Name.Text + #9 + Pad.Name;
                    MatchIndex := Keys.IndexOf(Key);
                    if MatchIndex >= 0 then
                    begin
                        if Found.IndexOf(Key) >= 0 then
                        begin
                            ShowMessage('Ambiguous source pad: ' + InventoryField(Key) + '. Selection unchanged.');
                            Exit;
                        end;
                        if Pad.Net = nil then
                        begin
                            ShowMessage('Source pad has no net: ' + InventoryField(Key) + '. Selection unchanged.');
                            Exit;
                        end;
                        if Pad.Net.Name <> Nets.Strings[MatchIndex] then
                        begin
                            ShowMessage('Source-pad net mismatch: ' + InventoryField(Key) + '. Selection unchanged.');
                            Exit;
                        end;
                        Found.Add(Key);
                    end;
                end;
                Pad := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        for I := 0 to Keys.Count - 1 do
            if Found.IndexOf(Keys.Strings[I]) < 0 then
            begin
                ShowMessage('Unknown source pad: ' + InventoryField(Keys.Strings[I]) + '. Selection unchanged.');
                Exit;
            end;

        Audit.Add('refdes' + #9 + 'pad' + #9 + 'net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'layer_id' + #9 + 'layer' + #9 + 'selected');
        Audit.SaveToFile(AuditPath);
        { This existing deselection scope omits some extended mechanical layers. }
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
        SelectedCount := 0;
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(ePadObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Pad := Iterator.FirstPCBObject;
            while Pad <> nil do
            begin
                if Pad.Component <> nil then
                begin
                    Key := Pad.Component.Name.Text + #9 + Pad.Name;
                    if Keys.IndexOf(Key) >= 0 then
                    begin
                        Pad.Selected := True;
                        if Pad.Selected then Inc(SelectedCount);
                        Audit.Add(InventoryField(Pad.Component.Name.Text) + #9 + InventoryField(Pad.Name) + #9 + InventoryNetName(Pad) + #9 + IntToStr(Pad.X) + #9 + IntToStr(Pad.Y) + #9 + IntToStr(Pad.Layer) + #9 + Layer2String(Pad.Layer) + #9 + InventoryBoolean(Pad.Selected));
                    end;
                end;
                Pad := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        Audit.SaveToFile(AuditPath);
        Client.SendMessage('PCB:Zoom', 'Action=Redraw', 255, Client.CurrentView);
        if SelectedCount <> Keys.Count then
        begin
            ShowMessage('Source-pad selection count did not match the allowlist. Inspect the audit before routing.');
            Exit;
        end;
        ShowMessage('Selected ' + IntToStr(SelectedCount) + ' source pads. Inspect the whole-canvas selection before Interactive Multi-Routing.');
    finally
        Lines.Free;
        Keys.Free;
        Nets.Free;
        Found.Free;
        Audit.Free;
    end;
end;

{ Export the current trial, then select the next explicit net group. }
procedure ExportAndSelectAllowlistedNets;
begin
    ExportTrialInventory;
    SelectAllowlistedNets;
    Client.SendMessage('PCB:Zoom', 'Action=Selected', 255, Client.CurrentView);
end;

{ Export the selected airwires so the routing scope can be checked before use. }
procedure SelectConnectionsAndExport;
begin
    SelectAllowlistedConnections;
    ExportTrialInventory;
    Client.SendMessage('PCB:Zoom', 'Action=Selected', 255, Client.CurrentView);
end;

{ Repour the active work board before reading its current connectivity. }
procedure RepourAndExportFullInventory;
var
    Board : IPCB_Board;
begin
    Board := PCBServer.GetCurrentPCBBoard;
    if Board = nil then Exit;
    if UpperCase(Board.FileName) <> UpperCase(InventoryExpectedBoard) then
    begin
        ShowMessage('Activate the exact full-run working PCB before repouring.');
        Exit;
    end;
    Client.SendMessage('PCB:ChangeObject', 'ContextObject=Polygon|Action=RepourAllPolygons', 255, Client.CurrentView);
    ExportTrialInventory;
end;
