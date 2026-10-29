{ Apply one staged part; never retry or save the PCB. }
procedure RunBatch461;
var
    Lines, Status : TStringList;
    Row : String;
    Counts : array[1..6] of Integer;
    I, Separator, ParsedValue : Integer;
begin
    Lines := TStringList.Create;
    Status := TStringList.Create;
    try
        Batch461Stage('preflight');
        if not FileExists(Batch461Directory + '\batch.tsv') then Exit;
        Lines.LoadFromFile(Batch461Directory + '\batch.tsv');
        Batch461Stage('preflight_batch_header');
        if Lines.Count <> 2 then Exit;
        if Lines.Strings[0] <> 'expected_tracks' + #9 + 'expected_vias' + #9 +
            'remove_rows' + #9 + 'track_rows' + #9 + 'track_adds' + #9 + 'via_rows' then Exit;
        Row := Lines.Strings[1];
        Batch461Stage('preflight_batch_numbers');
        for I := 1 to 5 do
        begin
            Separator := Pos(#9, Row);
            if Separator = 0 then Exit;
            if not FullTracksInteger(Copy(Row, 1, Separator - 1), ParsedValue) then Exit;
            Counts[I] := ParsedValue;
            Delete(Row, 1, Separator);
        end;
        if not FullTracksInteger(Row, ParsedValue) then Exit;
        Counts[6] := ParsedValue;
        if (Counts[3] > 128) or (Counts[4] < 1) or (Counts[4] > 64) or
           (Counts[5] > Counts[4]) or (Counts[6] > 16) or (Counts[3] > Counts[1]) then Exit;
        Batch461Stage('preflight_board_counts');
        if not Batch461Counts(Counts[1], Counts[2]) then Exit;
        Batch461Stage('preflight_removal_request');
        if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',
            Counts[3], Counts[1], False) then Exit;
        Batch461Stage('preflight_track_request');
        if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',
            Counts[4], Counts[1] - Counts[3], True) then Exit;
        Batch461Stage('preflight_add_count');
        if Batch461Adds <> Counts[5] then Exit;
        Batch461Stage('preflight_via_request');
        if not Batch461Request(FullViaDirectory + '\add-vias.tsv',
            Counts[6], Counts[2], False) then Exit;
        { Overwrite every terminal record before the first mutation. }
        Status.Add('batch461_pending');
        Status.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-status.txt');
        Status.SaveToFile(FullTracksDirectory + '\full-tracks-status.txt');
        Status.SaveToFile(FullViaDirectory + '\full-via-status.txt');
        Status.SaveToFile(InventoryOutputDirectory + '\inventory-status.txt');
        if Counts[3] > 0 then
        begin
            Batch461Stage('removals');
            RemoveExplicitFullTracks;
            if not Batch461Success(FullTrackRemoveDirectory + '\full-track-remove-status.txt',
                'removed_batch_readback_ok_drc_not_checked', Counts[3]) then Exit;
        end;
        if not Batch461Counts(Counts[1] - Counts[3], Counts[2]) then Exit;
        Batch461Stage('tracks');
        ApplyExplicitFullTracks;
        if not Batch461Success(FullTracksDirectory + '\full-tracks-status.txt',
            'applied_batch_readback_ok_drc_not_checked', Counts[4]) then Exit;
        if not Batch461Counts(Counts[1] - Counts[3] + Counts[5], Counts[2]) then Exit;
        if Counts[6] > 0 then
        begin
            Batch461Stage('vias');
            AddExplicitFullVias;
            if not Batch461Success(FullViaDirectory + '\full-via-status.txt',
                'added_batch_readback_ok_drc_not_checked', Counts[6]) then Exit;
        end;
        if not Batch461Counts(Counts[1] - Counts[3] + Counts[5], Counts[2] + Counts[6]) then Exit;
        Batch461Stage('repour_export');
        RepourAndExportFullInventory;
        Lines.LoadFromFile(InventoryOutputDirectory + '\inventory-status.txt');
        if Lines.Count <> 1 then Exit;
        if Lines.Strings[0] <> 'complete' then Exit;
        if not Batch461Counts(Counts[1] - Counts[3] + Counts[5], Counts[2] + Counts[6]) then Exit;
        Batch461Stage('complete_readback_repour_export_native_acceptance_pending');
    finally
        Lines.Free;
        Status.Free;
    end;
end;


{ Finish only the two DATA2 vias after the pad-name guard stopped insertion. }
procedure FinishSD3608;
var
    Lines : TStringList;
begin
    if not Batch461Counts(9348, 976) then Exit;
    if not Batch461Success(FullTrackRemoveDirectory + '\full-track-remove-status.txt',
        'removed_batch_readback_ok_drc_not_checked', 32) then Exit;
    if not Batch461Success(FullTracksDirectory + '\full-tracks-status.txt',
        'applied_batch_readback_ok_drc_not_checked', 64) then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv', 2, 976, False) then Exit;
    Batch461Stage('sd3608_vias');
    AddExplicitFullVias;
    if not Batch461Success(FullViaDirectory + '\full-via-status.txt',
        'added_batch_readback_ok_drc_not_checked', 2) then Exit;
    if not Batch461Counts(9348, 978) then Exit;
    Batch461Stage('sd3608_repour_export');
    RepourAndExportFullInventory;
    Lines := TStringList.Create;
    try
        Lines.LoadFromFile(InventoryOutputDirectory + '\inventory-status.txt');
        if Lines.Count <> 1 then Exit;
        if Lines.Strings[0] <> 'complete' then Exit;
        if not Batch461Counts(9348, 978) then Exit;
        Batch461Stage('complete_readback_repour_export_native_acceptance_pending');
    finally Lines.Free; end;
end;

{ Finish the exact GPIO batch after its own-pad via guard stopped before mutation. }
procedure FinishGPIO500;
var
    Lines : TStringList;
begin
    if not Batch461Counts(7480, 891) then Exit;
    if not Batch461Success(FullTrackRemoveDirectory + '\full-track-remove-status.txt',
        'removed_batch_readback_ok_drc_not_checked', 5) then Exit;
    if not Batch461Success(FullTracksDirectory + '\full-tracks-status.txt',
        'applied_batch_readback_ok_drc_not_checked', 35) then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv', 2, 891, False) then Exit;
    Batch461Stage('gpio500_vias');
    AddExplicitFullVias;
    if not Batch461Success(FullViaDirectory + '\full-via-status.txt',
        'added_batch_readback_ok_drc_not_checked', 2) then Exit;
    if not Batch461Counts(7480, 893) then Exit;
    Batch461Stage('gpio500_repour_export');
    RepourAndExportFullInventory;
    Lines := TStringList.Create;
    try
        Lines.LoadFromFile(InventoryOutputDirectory + '\inventory-status.txt');
        if Lines.Count <> 1 then Exit;
        if Lines.Strings[0] <> 'complete' then Exit;
        if not Batch461Counts(7480, 893) then Exit;
        Batch461Stage('complete_readback_repour_export_native_acceptance_pending');
    finally Lines.Free; end;
end;

{ Shift only the three exact run-added ENET_TD0 objects to reopen a power neck. }
procedure RepairPower464;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Track, TopTrack, InnerTrack : IPCB_Track;
    ViaMatches, TopMatches, InnerMatches : Integer;
    Occupied : Boolean;
begin
    Batch461Stage('power464_preflight');
    if not Batch461Counts(7207, 868) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    ViaMatches := 0; TopMatches := 0; InnerMatches := 0;
    TargetVia := nil; TopTrack := nil; InnerTrack := nil; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if (Via.X = 127283500) and (Via.Y = 91754100) then Occupied := True;
            if (Via.X = 127253500) and (Via.Y = 91754100) and
               (Via.Size = 160000) and (Via.HoleSize = 80000) and
               (Via.LowLayer = eTopLayer) and (Via.HighLayer = eBottomLayer) then
                if Via.Net <> nil then
                    if Via.Net.Name = 'ENET_TD0' then
                    begin TargetVia := Via; Inc(ViaMatches); end;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Track := Iterator.FirstPCBObject;
        while Track <> nil do
        begin
            if FullTrackRemoveNetName(Track) = 'ENET_TD0' then
            begin
                if (Track.Layer = 1) and (Track.Width = 41000) and
                   FullTrackRemoveSameEndpoints(Track.X1, Track.Y1, Track.X2, Track.Y2,
                     127244600, 91834000, 127253500, 91754100) then
                begin TopTrack := Track; Inc(TopMatches); end;
                if (Track.Layer = 4) and (Track.Width = 32000) and
                   FullTrackRemoveSameEndpoints(Track.X1, Track.Y1, Track.X2, Track.Y2,
                     127253500, 91754100, 127373500, 91874100) then
                begin InnerTrack := Track; Inc(InnerMatches); end;
            end;
            Track := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (ViaMatches <> 1) or (TopMatches <> 1) or (InnerMatches <> 1) then Exit;
    Batch461Stage('power464_mutating_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try TargetVia.X := 127283500;
        finally PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
        PCBServer.SendMessageToRobots(TopTrack.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try
            TopTrack.X1 := 127244600; TopTrack.Y1 := 91834000;
            TopTrack.X2 := 127283500; TopTrack.Y2 := 91754100;
        finally PCBServer.SendMessageToRobots(TopTrack.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
        PCBServer.SendMessageToRobots(InnerTrack.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try
            InnerTrack.X1 := 127283500; InnerTrack.Y1 := 91754100;
            InnerTrack.X2 := 127373500; InnerTrack.Y2 := 91874100;
        finally PCBServer.SendMessageToRobots(InnerTrack.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(7207,868) then Exit;
    if (TargetVia.X <> 127283500) or (TargetVia.Y <> 91754100) or
       (TargetVia.Size <> 160000) or (TargetVia.HoleSize <> 80000) or
       (TargetVia.LowLayer <> eTopLayer) or (TargetVia.HighLayer <> eBottomLayer) or
       (TargetVia.Net.Name <> 'ENET_TD0') then Exit;
    if not FullTrackRemoveSameEndpoints(TopTrack.X1,TopTrack.Y1,TopTrack.X2,TopTrack.Y2,
        127244600,91834000,127283500,91754100) then Exit;
    if not FullTrackRemoveSameEndpoints(InnerTrack.X1,InnerTrack.Y1,InnerTrack.X2,InnerTrack.Y2,
        127283500,91754100,127373500,91874100) then Exit;
    if (TopTrack.Width <> 41000) or (TopTrack.Layer <> 1) or
       (FullTrackRemoveNetName(TopTrack) <> 'ENET_TD0') or
       (InnerTrack.Width <> 32000) or (InnerTrack.Layer <> 4) or
       (FullTrackRemoveNetName(InnerTrack) <> 'ENET_TD0') then Exit;
    Batch461Stage('power464_readback_ok_repour_export');
    RepourAndExportFullInventory;
    Batch461Stage('power464_complete_native_acceptance_pending');
end;


{ Restore the three exact ENET_TD0 objects after an unsuccessful power-neck trial. }
procedure RevertPower464;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Track, TopTrack, InnerTrack : IPCB_Track;
    ViaMatches, TopMatches, InnerMatches : Integer;
    Occupied : Boolean;
begin
    Batch461Stage('power464_revert_preflight');
    if not Batch461Counts(7207, 868) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    ViaMatches := 0; TopMatches := 0; InnerMatches := 0;
    TargetVia := nil; TopTrack := nil; InnerTrack := nil; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if (Via.X = 127253500) and (Via.Y = 91754100) then Occupied := True;
            if (Via.X = 127283500) and (Via.Y = 91754100) and
               (Via.Size = 160000) and (Via.HoleSize = 80000) and
               (Via.LowLayer = eTopLayer) and (Via.HighLayer = eBottomLayer) then
                if Via.Net <> nil then
                    if Via.Net.Name = 'ENET_TD0' then
                    begin TargetVia := Via; Inc(ViaMatches); end;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Track := Iterator.FirstPCBObject;
        while Track <> nil do
        begin
            if FullTrackRemoveNetName(Track) = 'ENET_TD0' then
            begin
                if (Track.Layer = 1) and (Track.Width = 41000) and
                   FullTrackRemoveSameEndpoints(Track.X1, Track.Y1, Track.X2, Track.Y2,
                     127244600, 91834000, 127283500, 91754100) then
                begin TopTrack := Track; Inc(TopMatches); end;
                if (Track.Layer = 4) and (Track.Width = 32000) and
                   FullTrackRemoveSameEndpoints(Track.X1, Track.Y1, Track.X2, Track.Y2,
                     127283500, 91754100, 127373500, 91874100) then
                begin InnerTrack := Track; Inc(InnerMatches); end;
            end;
            Track := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (ViaMatches <> 1) or (TopMatches <> 1) or (InnerMatches <> 1) then Exit;
    Batch461Stage('power464_revert_mutating_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try TargetVia.X := 127253500;
        finally PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
        PCBServer.SendMessageToRobots(TopTrack.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try
            TopTrack.X1 := 127244600; TopTrack.Y1 := 91834000;
            TopTrack.X2 := 127253500; TopTrack.Y2 := 91754100;
        finally PCBServer.SendMessageToRobots(TopTrack.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
        PCBServer.SendMessageToRobots(InnerTrack.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try
            InnerTrack.X1 := 127253500; InnerTrack.Y1 := 91754100;
            InnerTrack.X2 := 127373500; InnerTrack.Y2 := 91874100;
        finally PCBServer.SendMessageToRobots(InnerTrack.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(7207,868) then Exit;
    if (TargetVia.X <> 127253500) or (TargetVia.Y <> 91754100) or
       (TargetVia.Size <> 160000) or (TargetVia.HoleSize <> 80000) or
       (TargetVia.LowLayer <> eTopLayer) or (TargetVia.HighLayer <> eBottomLayer) or
       (TargetVia.Net.Name <> 'ENET_TD0') then Exit;
    if not FullTrackRemoveSameEndpoints(TopTrack.X1,TopTrack.Y1,TopTrack.X2,TopTrack.Y2,
        127244600,91834000,127253500,91754100) then Exit;
    if not FullTrackRemoveSameEndpoints(InnerTrack.X1,InnerTrack.Y1,InnerTrack.X2,InnerTrack.Y2,
        127253500,91754100,127373500,91874100) then Exit;
    if (TopTrack.Width <> 41000) or (TopTrack.Layer <> 1) or
       (FullTrackRemoveNetName(TopTrack) <> 'ENET_TD0') or
       (InnerTrack.Width <> 32000) or (InnerTrack.Layer <> 4) or
       (FullTrackRemoveNetName(InnerTrack) <> 'ENET_TD0') then Exit;
    Batch461Stage('power464_revert_readback_ok_repour_export');
    RepourAndExportFullInventory;
    Batch461Stage('power464_revert_complete_native_acceptance_pending');
end;

{ Match one run-added through via without changing its other properties. }
function Batch479ViaMatches(Via : IPCB_Via; NetName : String; X, Y : Integer) : Boolean;
begin
    Result := False;
    if Via = nil then Exit;
    if Via.Net = nil then Exit;
    Result := (Via.Net.Name = NetName) and (Via.X = X) and (Via.Y = Y) and
        (Via.Size = 160000) and (Via.HoleSize = 80000) and
        (Via.LowLayer = eTopLayer) and (Via.HighLayer = eBottomLayer);
end;

{ Move two exact vias, then apply the staged first part without saving. }
procedure RunSAI479Part1;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, FirstVia, SecondVia : IPCB_Via;
    FirstMatches, SecondMatches : Integer;
    Occupied : Boolean;
    Receipt : TStringList;
begin
    Batch461Stage('sai479_preflight');
    if not Batch461Counts(7290,876) then Exit;
    if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',37,7290,False) then Exit;
    if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',63,7253,True) then Exit;
    if Batch461Adds <> 63 then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    FirstVia := nil; SecondVia := nil;
    FirstMatches := 0; SecondMatches := 0; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if Batch479ViaMatches(Via,'SAI1_RXD5',125709800,91990900) then
            begin FirstVia := Via; Inc(FirstMatches); end;
            if (Via.X = 125663000) and (Via.Y = 92021100) then Occupied := True;
            if Batch479ViaMatches(Via,'SAI1_TXD1',126103500,91990900) then
            begin SecondVia := Via; Inc(SecondMatches); end;
            if (Via.X = 126105400) and (Via.Y = 91990900) then Occupied := True;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (FirstMatches <> 1) or (SecondMatches <> 1) then Exit;
    Batch461Stage('sai479_moving_vias_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(FirstVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try FirstVia.X := 125663000; FirstVia.Y := 92021100;
        finally PCBServer.SendMessageToRobots(FirstVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
        PCBServer.SendMessageToRobots(SecondVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try SecondVia.X := 126105400; SecondVia.Y := 91990900;
        finally PCBServer.SendMessageToRobots(SecondVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(7290,876) then Exit;
    if not Batch479ViaMatches(FirstVia,'SAI1_RXD5',125663000,92021100) then Exit;
    if not Batch479ViaMatches(SecondVia,'SAI1_TXD1',126105400,91990900) then Exit;
    Receipt := TStringList.Create;
    try
        Receipt.Add('both_exact_via_moves_readback_ok');
        Receipt.Add('expected_board=' + FullTracksExpectedBoard);
        Receipt.Add('SAI1_RXD5 125709800,91990900 -> 125663000,92021100 160000/80000 Top/Bottom');
        Receipt.Add('SAI1_TXD1 126103500,91990900 -> 126105400,91990900 160000/80000 Top/Bottom');
        Receipt.SaveToFile(Batch461Directory + '\sai479-via-moves.txt');
    finally Receipt.Free; end;
    RunBatch461;
end;

{ Move the exact run-added clock via, then apply its connected replacement paths. }
procedure RunClock485;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Matches : Integer;
    Occupied : Boolean;
    Receipt : TStringList;
begin
    Batch461Stage('clock485_preflight');
    if not Batch461Counts(7357,879) then Exit;
    if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',9,7357,False) then Exit;
    if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',26,7348,True) then Exit;
    if Batch461Adds <> 26 then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv',2,879,False) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    TargetVia := nil; Matches := 0; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if Batch479ViaMatches(Via,'XTALO_32K',127303500,97139100) then
            begin TargetVia := Via; Inc(Matches); end;
            if (Via.X = 127303500) and (Via.Y = 97279100) then Occupied := True;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (Matches <> 1) then Exit;
    Batch461Stage('clock485_moving_via_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try TargetVia.X := 127303500; TargetVia.Y := 97279100;
        finally PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(7357,879) then Exit;
    if not Batch479ViaMatches(TargetVia,'XTALO_32K',127303500,97279100) then Exit;
    Receipt := TStringList.Create;
    try
        Receipt.Add('exact_via_move_readback_ok');
        Receipt.Add('expected_board=' + FullTracksExpectedBoard);
        Receipt.Add('XTALO_32K 127303500,97139100 -> 127303500,97279100 160000/80000 Top/Bottom');
        Receipt.SaveToFile(Batch461Directory + '\clock485-via-move.txt');
    finally Receipt.Free; end;
    RunBatch461;
end;

{ Move the exact run-added QSPI via, then apply its connected replacement paths. }
procedure RunSAI522;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Matches : Integer;
    Occupied : Boolean;
    Receipt : TStringList;
begin
    Batch461Stage('sai522_preflight');
    if not Batch461Counts(7958,917) then Exit;
    if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',69,7958,False) then Exit;
    if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',42,7889,True) then Exit;
    if Batch461Adds <> 42 then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv',1,917,False) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    TargetVia := nil; Matches := 0; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if Batch479ViaMatches(Via,'QSPIA_DATA0',129513500,84934100) then
            begin TargetVia := Via; Inc(Matches); end;
            if (Via.X = 129513500) and (Via.Y = 84924100) then Occupied := True;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (Matches <> 1) then Exit;
    Batch461Stage('sai522_moving_via_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try TargetVia.X := 129513500; TargetVia.Y := 84924100;
        finally PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(7958,917) then Exit;
    if not Batch479ViaMatches(TargetVia,'QSPIA_DATA0',129513500,84924100) then Exit;
    Receipt := TStringList.Create;
    try
        Receipt.Add('exact_via_move_readback_ok');
        Receipt.Add('expected_board=' + FullTracksExpectedBoard);
        Receipt.Add('QSPIA_DATA0 129513500,84934100 -> 129513500,84924100 160000/80000 Top/Bottom');
        Receipt.SaveToFile(Batch461Directory + '\sai522-via-move.txt');
    finally Receipt.Free; end;
    RunBatch461;
end;

{ Move the exact run-added TDI via, then apply its connected replacement paths. }
procedure RunJTAG534Part1;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Matches : Integer;
    Occupied : Boolean;
    Receipt : TStringList;
begin
    Batch461Stage('jtag534_preflight');
    if not Batch461Counts(8080,926) then Exit;
    if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',10,8080,False) then Exit;
    if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',64,8070,True) then Exit;
    if Batch461Adds <> 64 then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv',0,926,False) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    TargetVia := nil; Matches := 0; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if Batch479ViaMatches(Via,'JTAG_TDI',127641500,96164700) then
            begin TargetVia := Via; Inc(Matches); end;
            if (Via.X = 127941500) and (Via.Y = 96164700) then Occupied := True;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (Matches <> 1) then Exit;
    Batch461Stage('jtag534_moving_via_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try TargetVia.X := 127941500; TargetVia.Y := 96164700;
        finally PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(8080,926) then Exit;
    if not Batch479ViaMatches(TargetVia,'JTAG_TDI',127941500,96164700) then Exit;
    Receipt := TStringList.Create;
    try
        Receipt.Add('exact_via_move_readback_ok');
        Receipt.Add('expected_board=' + FullTracksExpectedBoard);
        Receipt.Add('JTAG_TDI 127641500,96164700 -> 127941500,96164700 160000/80000 Top/Bottom');
        Receipt.SaveToFile(Batch461Directory + '\jtag534-via-move.txt');
    finally Receipt.Free; end;
    RunBatch461;
end;

{ Move the exact run-added BT via to open the reviewed WL access. }
procedure RunWL546Part1;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, TargetVia : IPCB_Via;
    Matches : Integer;
    Occupied : Boolean;
    Receipt : TStringList;
begin
    Batch461Stage('wl546_preflight');
    if not Batch461Counts(8272,934) then Exit;
    if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',16,8272,False) then Exit;
    if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',64,8256,True) then Exit;
    if Batch461Adds <> 64 then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv',0,934,False) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    TargetVia := nil; Matches := 0; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if Batch479ViaMatches(Via,'BT_WAKE_HOST',127841500,93248900) then
            begin TargetVia := Via; Inc(Matches); end;
            if (Via.X = 127666500) and (Via.Y = 93476500) then Occupied := True;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (Matches <> 1) then Exit;
    Batch461Stage('wl546_moving_via_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try TargetVia.X := 127666500; TargetVia.Y := 93476500;
        finally PCBServer.SendMessageToRobots(TargetVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(8272,934) then Exit;
    if not Batch479ViaMatches(TargetVia,'BT_WAKE_HOST',127666500,93476500) then Exit;
    Receipt := TStringList.Create;
    try
        Receipt.Add('exact_via_move_readback_ok');
        Receipt.Add('expected_board=' + FullTracksExpectedBoard);
        Receipt.Add('BT_WAKE_HOST 127841500,93248900 -> 127666500,93476500 160000/80000 Top/Bottom');
        Receipt.SaveToFile(Batch461Directory + '\wl546-via-move.txt');
    finally Receipt.Free; end;
    RunBatch461;
end;

{ Remove the exact Ground via and export its native repour result. }
procedure RunGround582Removal;
var Status : TStringList;
begin
    Status := TStringList.Create;
    try
        Batch461Stage('ground582_removal_preflight');
        Remove582OriginalGroundVia;
        Status.LoadFromFile(Ground582Directory + '\electrical582-via-remove-status.txt');
        if Status.Count < 1 then Exit;
        if Status.Strings[0] <> 'removed_exact_Ground_via_readback_ok' then Exit;
        if not Batch461Counts(8897, 958) then Exit;
        Status.Clear;
        Status.Add('ground582_export_pending');
        Status.SaveToFile(InventoryOutputDirectory + '\inventory-status.txt');
        Batch461Stage('ground582_repour_export');
        RepourAndExportFullInventory;
        Status.LoadFromFile(InventoryOutputDirectory + '\inventory-status.txt');
        if Status.Count <> 1 then Exit;
        if Status.Strings[0] <> 'complete' then Exit;
        if not Batch461Counts(8897, 958) then Exit;
        Batch461Stage('ground582_removal_complete_native_acceptance_pending');
    finally Status.Free; end;
end;

{ Move two exact vias, then apply the staged first part without saving. }
procedure RunSD3593Part1;
var
    Board : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Via, FirstVia, SecondVia : IPCB_Via;
    FirstMatches, SecondMatches : Integer;
    Occupied : Boolean;
    Receipt : TStringList;
begin
    Batch461Stage('sd3593_preflight');
    if not Batch461Counts(9316,976) then Exit;
    if not Batch461Request(FullTrackRemoveDirectory + '\remove-tracks.tsv',32,9316,False) then Exit;
    if not Batch461Request(FullTracksDirectory + '\track-changes.tsv',64,9284,True) then Exit;
    if Batch461Adds <> 64 then Exit;
    if not Batch461Request(FullViaDirectory + '\add-vias.tsv',2,976,False) then Exit;
    Board := PCBServer.GetCurrentPCBBoard;
    FirstVia := nil; SecondVia := nil;
    FirstMatches := 0; SecondMatches := 0; Occupied := False;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eViaObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Via := Iterator.FirstPCBObject;
        while Via <> nil do
        begin
            if Batch479ViaMatches(Via,'GND',128124200,94992400) then
            begin FirstVia := Via; Inc(FirstMatches); end;
            if (Via.X = 128158500) and (Via.Y = 94944100) then Occupied := True;
            if Batch479ViaMatches(Via,'SD3_DATA6',127933500,94984100) then
            begin SecondVia := Via; Inc(SecondMatches); end;
            if (Via.X = 127968500) and (Via.Y = 94944100) then Occupied := True;
            Via := Iterator.NextPCBObject;
        end;
    finally Board.BoardIterator_Destroy(Iterator); end;
    if Occupied or (FirstMatches <> 1) or (SecondMatches <> 1) then Exit;
    Batch461Stage('sd3593_moving_vias_inspect_on_interruption');
    PCBServer.PreProcess;
    try
        PCBServer.SendMessageToRobots(FirstVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try FirstVia.X := 128158500; FirstVia.Y := 94944100;
        finally PCBServer.SendMessageToRobots(FirstVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
        PCBServer.SendMessageToRobots(SecondVia.I_ObjectAddress,c_Broadcast,PCBM_BeginModify,c_NoEventData);
        try SecondVia.X := 127968500; SecondVia.Y := 94944100;
        finally PCBServer.SendMessageToRobots(SecondVia.I_ObjectAddress,c_Broadcast,PCBM_EndModify,c_NoEventData); end;
    finally PCBServer.PostProcess; end;
    if not Batch461Counts(9316,976) then Exit;
    if not Batch479ViaMatches(FirstVia,'GND',128158500,94944100) then Exit;
    if not Batch479ViaMatches(SecondVia,'SD3_DATA6',127968500,94944100) then Exit;
    Receipt := TStringList.Create;
    try
        Receipt.Add('both_exact_via_moves_readback_ok');
        Receipt.Add('expected_board=' + FullTracksExpectedBoard);
        Receipt.Add('GND 128124200,94992400 -> 128158500,94944100 160000/80000 Top/Bottom');
        Receipt.Add('SD3_DATA6 127933500,94984100 -> 127968500,94944100 160000/80000 Top/Bottom');
        Receipt.SaveToFile(Batch461Directory + '\sd3593-via-moves.txt');
    finally Receipt.Free; end;
    RunBatch461;
end;
