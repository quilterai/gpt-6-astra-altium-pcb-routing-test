{ Write a stage that cannot be mistaken for a completed batch. }
procedure Batch461Stage(StageName : String);
var Status : TStringList;
begin
    Status := TStringList.Create;
    try
        Status.Add(StageName);
        Status.SaveToFile(Batch461Directory + '\batch461-status.txt');
    finally Status.Free; end;
end;

{ Require the guarded board and fresh whole-board primitive counts. }
function Batch461Counts(Tracks, Vias : Integer) : Boolean;
var Board : IPCB_Board; Audit : TStringList; ActualTracks, ActualVias : Integer;
begin
    Result := False;
    Board := PCBServer.GetCurrentPCBBoard;
    Audit := TStringList.Create;
    try
        if Board = nil then Audit.Add('current_board=nil')
        else
        begin
            Audit.Add('current_board=' + Board.FileName);
            ActualTracks := FullTrackRemoveCount(Board);
            ActualVias := FullViaCount(Board);
            Audit.Add('actual_tracks=' + IntToStr(ActualTracks));
            Audit.Add('actual_vias=' + IntToStr(ActualVias));
            Result := (UpperCase(Board.FileName) = UpperCase(FullTracksExpectedBoard)) and
                      (ActualTracks = Tracks) and (ActualVias = Vias);
        end;
        Audit.Add('expected_tracks=' + IntToStr(Tracks));
        Audit.Add('expected_vias=' + IntToStr(Vias));
        Audit.SaveToFile(Batch461Directory + '\count-guard.txt');
    finally Audit.Free; end;
end;

{ Check row counts and count guards before any helper can mutate copper. }
function Batch461Request(Path : String; Count, Guard : Integer; Tracks : Boolean) : Boolean;
var Lines : TStringList; Row : String; I, Separator, Value : Integer;
begin
    Result := False;
    if Count = 0 then begin Result := True; Exit; end;
    Lines := TStringList.Create;
    try
        if not FileExists(Path) then Exit;
        Lines.LoadFromFile(Path);
        if Lines.Count <> Count + 1 then Exit;
        if Tracks then Batch461Adds := 0;
        for I := 1 to Count do
        begin
            Row := Lines.Strings[I];
            if Tracks then
            begin
                if Copy(Row, 1, 4) = 'add' + #9 then Inc(Batch461Adds)
                else if Copy(Row, 1, 5) <> 'edit' + #9 then Exit;
            end;
            Separator := Pos(#9, Row);
            if Separator = 0 then Exit;
            while Separator > 0 do
            begin
                Delete(Row, 1, Separator);
                Separator := Pos(#9, Row);
            end;
            if not FullTracksInteger(Row, Value) then Exit;
            if Value <> Guard then Exit;
        end;
        Result := True;
    finally Lines.Free; end;
end;

{ Require the freshly rewritten terminal stage and every completed row. }
function Batch461Success(Path, StageName : String; Count : Integer) : Boolean;
var Lines : TStringList;
begin
    Result := False;
    Lines := TStringList.Create;
    try
        if not FileExists(Path) then Exit;
        Lines.LoadFromFile(Path);
        if Lines.Count < 4 then Exit;
        Result := (Lines.Strings[0] = StageName) and
            (Lines.Strings[1] = 'expected_board=' + FullTracksExpectedBoard) and
            (Lines.Strings[2] = 'row=' + IntToStr(Count)) and
            (Lines.Strings[3] = 'completed_readbacks=' + IntToStr(Count));
    finally Lines.Free; end;
end;
