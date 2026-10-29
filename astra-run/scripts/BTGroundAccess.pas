{ One exact original Ground via; native qualification and fresh stage audit required. }
function Ground582Board : String;
begin
    Result := AstraWorkspacePath('BTGroundAccess.PrjScr', 'work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc');
end;

function Ground582Directory : String;
begin
    Result := AstraWorkspacePath('BTGroundAccess.PrjScr', 'runs\full-routing-2026-09-30\electrical');
end;

function Ground582SameEndpoints(A1,B1,A2,B2,C1,D1,C2,D2 : Integer) : Boolean;
begin
    Result := ((A1=C1) and (B1=D1) and (A2=C2) and (B2=D2)) or
        ((A1=C2) and (B1=D2) and (A2=C1) and (B2=D1));
end;

function Ground582Target(Via : IPCB_Via) : Boolean;
begin
    Result := False;
    if Via.Net = nil then Exit;
    Result := (Via.Net.Name='GND') and (Via.X=127072400) and (Via.Y=93901000) and
        (Via.Size=160000) and (Via.HoleSize=80000) and
        (Via.LowLayer=eTopLayer) and (Via.HighLayer=eBottomLayer);
end;

function Ground582NewTrackIndex(Track : IPCB_Track) : Integer;
begin
    Result := 0;
    if Track.Net = nil then Exit;
    if Track.Net.Name <> 'GND' then Exit;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127072400,93630300,127072400,93629800) then Result := 1;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127072400,93629800,127074400,93627800) then Result := 2;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127074400,93627800,127074400,93108800) then Result := 3;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127074400,93108800,127074884,93108800) then Result := 4;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127072400,94171600,127080400,94179600) then Result := 5;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127080400,94179600,127080400,94891600) then Result := 6;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127080400,94891600,127080200,94891800) then Result := 7;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127217500,93838200,127217300,93838200) then Result := 8;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127217300,93838200,127218300,93837200) then Result := 9;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127218300,93837200,127409300,93837200) then Result := 10;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127409300,93837200,127409300,94434200) then Result := 11;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127409300,94434200,127242300,94601200) then Result := 12;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127242300,94601200,127242300,94624200) then Result := 13;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127242300,94624200,127215300,94624200) then Result := 14;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127215300,94624200,127209300,94630200) then Result := 15;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127209300,94630200,127200300,94630200) then Result := 16;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127200300,94630200,127199300,94631200) then Result := 17;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127199300,94631200,126454300,94631200) then Result := 18;
    if (Track.Layer = 32) and (Track.Width = 50000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126454300,94631200,126454300,94397200) then Result := 19;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126454300,94397200,126454300,94397100) then Result := 20;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127074884,93108800,127074584,93109100) then Result := 21;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127074584,93109100,127073500,93109100) then Result := 22;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127073500,93109100,127073500,92474100) then Result := 23;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127073500,92474100,126613500,92014100) then Result := 24;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126613500,92014100,126583500,92014100) then Result := 25;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126583500,92014100,126578500,92009100) then Result := 26;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126578500,92009100,126233500,92009100) then Result := 27;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126233500,92009100,126233500,92129100) then Result := 28;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126233500,92129100,125938500,92129100) then Result := 29;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,125938500,92129100,125928500,92139100) then Result := 30;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,125928500,92139100,125928500,93039100) then Result := 31;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,125928500,93039100,126098500,93209100) then Result := 32;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126098500,93209100,126098400,93209100) then Result := 33;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,126098400,93209100,126097800,93209700) then Result := 34;
end;

function Ground582OldTrackIndex(Track : IPCB_Track) : Integer;
begin
    Result := 0;
    if Track.Net = nil then Exit;
    if Track.Net.Name <> 'GND' then Exit;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127072400,93630300,127072400,93901000) then Result := 1;
    if (Track.Layer = 32) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127113500,93859900,127113500,93860200) then Result := 2;
    if (Track.Layer = 32) and (Track.Width = 50000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127072400,93901000,127113500,93859900) then Result := 3;
    if (Track.Layer = 1) and (Track.Width = 100000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127072400,93901000,127072400,94171600) then Result := 4;
    if (Track.Layer = 32) and (Track.Width = 50000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127113500,93860200,127131500,93842200) then Result := 5;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127131500,93842200,127213500,93842200) then Result := 6;
    if (Track.Layer = 32) and (Track.Width = 30000) and
       Ground582SameEndpoints(Track.X1,Track.Y1,Track.X2,Track.Y2,127213500,93842200,127217500,93838200) then Result := 7;
end;


procedure Ground582ExactViaProcedure(Mutate : Boolean);
var
    Board,ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Via,TargetVia : IPCB_Via;
    Track : IPCB_Track;
    Status,Gate : TStringList;
    Tracks,Vias,Matches,Index,I : Integer;
    NewMatches : array[1..34] of Integer;
    OldMatches : array[1..7] of Integer;
    Attempted : Boolean;
    TargetAddress : Variant;
begin
    Attempted := False;
    Status := TStringList.Create;
    Gate := TStringList.Create;
    try
        try
        Status.Add('pending_preflight_not_mutated');
        Status.SaveToFile(Ground582Directory+'\electrical582-via-remove-status.txt');
        Board := PCBServer.GetCurrentPCBBoard;
        if Board=nil then Exit;
        if UpperCase(Board.FileName)<>UpperCase(Ground582Board) then Exit;
        Gate.LoadFromFile(Ground582Directory+'\electrical582-Ground-stage-accepted.txt');
        if Gate.Values['ground_stage_exact_audit']<>'PASS' then Exit;
        if UpperCase(Gate.Values['board_path'])<>UpperCase(Ground582Board) then Exit;
        if (Gate.Values['track_count']<>'8897') or (Gate.Values['via_count']<>'959') or
           (Gate.Values['ground_remaining']<>'0') then Exit;
        Tracks:=0;Vias:=0;Matches:=0;TargetVia:=nil;
        for I:=1 to 34 do NewMatches[I]:=0;
        for I:=1 to 7 do OldMatches[I]:=0;
        Iterator:=Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eTrackObject,eViaObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Primitive:=Iterator.FirstPCBObject;
            while Primitive<>nil do
            begin
                if Primitive.ObjectId=eTrackObject then
                begin
                    Track:=Primitive;Inc(Tracks);
                    Index:=Ground582NewTrackIndex(Track);
                    if Index>0 then NewMatches[Index]:=NewMatches[Index]+1;
                    Index:=Ground582OldTrackIndex(Track);
                    if Index>0 then OldMatches[Index]:=OldMatches[Index]+1;
                end;
                if Primitive.ObjectId=eViaObject then
                begin
                    Via:=Primitive;Inc(Vias);
                    if Ground582Target(Via) then begin Inc(Matches);TargetVia:=Via;end;
                end;
                Primitive:=Iterator.NextPCBObject;
            end;
        finally Board.BoardIterator_Destroy(Iterator);end;
        if (Tracks<>8897) or (Vias<>959) or (Matches<>1) or (TargetVia=nil) then Exit;
        for I:=1 to 34 do if NewMatches[I]<>1 then Exit;
        for I:=1 to 7 do if OldMatches[I]<>0 then Exit;
        ActiveBoard:=PCBServer.GetCurrentPCBBoard;
        if ActiveBoard=nil then Exit;
        if UpperCase(ActiveBoard.FileName)<>UpperCase(Ground582Board) then Exit;
        if not Ground582Target(TargetVia) then Exit;
        if not Mutate then
        begin
            Status.Clear;Status.Add('preflight_only_ok_not_mutated');
            Status.SaveToFile(Ground582Directory+'\electrical582-via-remove-status.txt');
            Exit;
        end;
        TargetAddress:=TargetVia.I_ObjectAddress;
        Status.Clear;Status.Add('removing_exact_original_Ground_via_partial_changes_possible');
        Status.SaveToFile(Ground582Directory+'\electrical582-via-remove-status.txt');
        Attempted:=True;
        PCBServer.PreProcess;
        try
            Board.RemovePCBObject(TargetVia);
            PCBServer.SendMessageToRobots(Board.I_ObjectAddress,c_Broadcast,
                PCBM_BoardRegisteration,TargetAddress);
        finally PCBServer.PostProcess;end;
        Tracks:=0;Vias:=0;Matches:=0;
        Iterator:=Board.BoardIterator_Create;
        try
            Iterator.AddFilter_ObjectSet(MkSet(eTrackObject,eViaObject));
            Iterator.AddFilter_LayerSet(AllLayers);
            Iterator.AddFilter_Method(eProcessAll);
            Primitive:=Iterator.FirstPCBObject;
            while Primitive<>nil do
            begin
                if Primitive.ObjectId=eTrackObject then Inc(Tracks);
                if Primitive.ObjectId=eViaObject then
                begin
                    Via:=Primitive;Inc(Vias);
                    if Ground582Target(Via) then Inc(Matches);
                end;
                Primitive:=Iterator.NextPCBObject;
            end;
        finally Board.BoardIterator_Destroy(Iterator);end;
        Status.Clear;
        if (Tracks=8897) and (Vias=958) and (Matches=0) then
            Status.Add('removed_exact_Ground_via_readback_ok')
        else Status.Add('failed_readback_inspect_partial_changes');
        Status.Add('track_count='+IntToStr(Tracks));
        Status.Add('via_count='+IntToStr(Vias));
        Status.Add('target_matches='+IntToStr(Matches));
        Status.SaveToFile(Ground582Directory+'\electrical582-via-remove-status.txt');
    except
        Status.Clear;
        if Attempted then Status.Add('exception_after_mutation_inspect')
        else Status.Add('exception_before_mutation');
        Status.SaveToFile(Ground582Directory+'\electrical582-via-remove-status.txt');
        raise;
        end;
    finally Gate.Free;Status.Free;end;
end;

procedure Preflight582OriginalGroundVia;
begin Ground582ExactViaProcedure(False);end;

procedure Remove582OriginalGroundVia;
begin Ground582ExactViaProcedure(True);end;
