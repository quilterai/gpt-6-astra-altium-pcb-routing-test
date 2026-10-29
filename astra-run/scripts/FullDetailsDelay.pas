{ Read installed pad/via delay getters; scripting access and units need qualification. }

function FullDelayExpectedBoard : String;
begin
    Result := AstraWorkspacePath('FullDetailsDelay.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function FullDelayOutputDirectory : String;
begin
    Result := AstraWorkspacePath('FullDetailsDelay.PrjScr', 'runs\full-routing-2026-09-30\quality\delay-details');
end;

{ Preserve a field on one TSV line. }
function FullDelayField(Value : String) : String;
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

{ Record the last stage without substituting values after a getter failure. }
procedure FullDelayStage(Status : TStringList; Stage : String);
begin
    if Status.Count > 0 then
        if Status.Strings[0] = Stage then Exit;
    Status.Clear;
    Status.Add(Stage);
    Status.SaveToFile(FullDelayOutputDirectory + '\delay-status.txt');
end;

{ Read existing CPU pads and DDR vias without changing the board. }
procedure ExportFullDelayDetails;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Pad : IPCB_Pad;
    Via : IPCB_Via;
    Pads, Vias, Identity, Status : TStringList;
    NetName : String;
    ObjectCount : Integer;
begin
    if not DirectoryExists(FullDelayOutputDirectory) then
    begin
        ShowMessage('Create the delay output directory first: ' + FullDelayOutputDirectory);
        Exit;
    end;
    Status := TStringList.Create;
    Pads := TStringList.Create;
    Vias := TStringList.Create;
    Identity := TStringList.Create;
    try
        FullDelayStage(Status, 'checking_board');
        Board := PCBServer.GetPCBBoardByPath(FullDelayExpectedBoard);
        if Board = nil then
        begin
            FullDelayStage(Status, 'refused_board_not_loaded');
            ShowMessage('The full-routing-2026-09-30 working PCB is not loaded.');
            Exit;
        end;
        if UpperCase(Board.FileName) <> UpperCase(FullDelayExpectedBoard) then
        begin
            FullDelayStage(Status, 'refused_board_path');
            ShowMessage('Refusing PCB: ' + Board.FileName);
            Exit;
        end;
        Pads.Add('refdes' + #9 + 'pad' + #9 + 'net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'layer_id' + #9 + 'propagation_delay_native');
        Vias.Add('net' + #9 + 'x_raw' + #9 + 'y_raw' + #9 + 'size_raw' + #9 + 'hole_size_raw' + #9 + 'low_layer_id' + #9 + 'high_layer_id' + #9 + 'propagation_delay_native' + #9 + 'delay_native');
        FullDelayStage(Status, 'create_iterator');
        Iterator := Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(ePadObject, eViaObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            ObjectCount := 0;
            Primitive := Iterator.FirstPCBObject;
            while Primitive <> nil do
            begin
                Inc(ObjectCount);
                if ObjectCount > 10000 then
                begin
                    FullDelayStage(Status, 'failed_object_limit');
                    ShowMessage('Pad/via iteration exceeded 10000 objects.');
                    Exit;
                end;
                NetName := '';
                if Primitive.Net <> nil then NetName := Primitive.Net.Name;
                if Primitive.ObjectId = ePadObject then
                begin
                    Pad := Primitive;
                    if Pad.Component <> nil then
                        if Pad.Component.Name.Text = 'U1' then
                        begin
                            FullDelayStage(Status, 'read_cpu_pad_delays');
                            Pads.Add('U1' + #9 + FullDelayField(Pad.Name) + #9 + FullDelayField(NetName) + #9 + IntToStr(Pad.X) + #9 + IntToStr(Pad.Y) + #9 + IntToStr(Pad.Layer) + #9 + FloatToStr(Pad.GetState_PropagationDelay));
                        end;
                end;
                if Primitive.ObjectId = eViaObject then
                    if (Copy(NetName, 1, 6) = 'DRAMA_') or (Copy(NetName, 1, 6) = 'DRAMB_') then
                    begin
                        Via := Primitive;
                        FullDelayStage(Status, 'read_ddr_via_delays');
                        Vias.Add(FullDelayField(NetName) + #9 + IntToStr(Via.X) + #9 + IntToStr(Via.Y) + #9 + IntToStr(Via.Size) + #9 + IntToStr(Via.HoleSize) + #9 + IntToStr(Via.LowLayer) + #9 + IntToStr(Via.HighLayer) + #9 + FloatToStr(Via.GetState_PropagationDelay) + #9 + FloatToStr(Via.GetState_Delay));
                    end;
                Primitive := Iterator.NextPCBObject;
            end;
        finally
            Board.BoardIterator_Destroy(Iterator);
        end;
        if Pads.Count = 1 then
        begin
            FullDelayStage(Status, 'failed_no_cpu_pads');
            ShowMessage('No pads with component designator U1 were found.');
            Exit;
        end;
        Identity.Add('field' + #9 + 'value');
        Identity.Add('board_file' + #9 + FullDelayField(Board.FileName));
        Identity.Add('internal_units_per_mil' + #9 + IntToStr(MilsToCoord(1)));
        Identity.Add('cpu_pad_count' + #9 + IntToStr(Pads.Count - 1));
        Identity.Add('ddr_via_count' + #9 + IntToStr(Vias.Count - 1));
        Identity.Add('delay_units' + #9 + 'native_double_not_yet_qualified');
        Identity.Add('via_net_scope' + #9 + 'DRAMA_ or DRAMB_ prefix');
        FullDelayStage(Status, 'write_delay_tables');
        Pads.SaveToFile(FullDelayOutputDirectory + '\pad-delays.tsv');
        Vias.SaveToFile(FullDelayOutputDirectory + '\via-delays.tsv');
        Identity.SaveToFile(FullDelayOutputDirectory + '\delay-board.tsv');
        FullDelayStage(Status, 'complete');
    finally
        Identity.Free;
        Vias.Free;
        Pads.Free;
        Status.Free;
    end;
end;
