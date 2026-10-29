const
    Batch461Directory = 'recorded-workspace\runs\full-routing-2026-09-30\quality\batch461-draft';
{ Remove at most 128 exact tracks, then verify every target in one native scan. }

const
    FullTrackRemoveL3Layer = 3; { L3_IN1, legacy MidLayer2 on the guarded board. }
    FullTrackRemoveL6Layer = 6; { Bounded control-path rollback. }
    FullTrackRemoveExpectedBoard = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    FullTrackRemoveDirectory = 'recorded-workspace\runs\full-routing-2026-09-30\quality\full-track-remove';

{ Parse unsigned decimal integers without overflow or other numeric syntax. }

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

{ Add at most 16 planned through vias after validating the complete request. }

const
    FullViaExpectedBoard = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    FullViaDirectory = 'recorded-workspace\runs\full-routing-2026-09-30\quality\full-via';

{ Parse decimal integers without accepting fractions, exponents, or overflow. }

{ One exact original Ground via; native qualification and fresh stage audit required. }
const
    Ground582Board = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    Ground582Directory = 'recorded-workspace\runs\full-routing-2026-09-30\electrical';


{ Inventory, selection, and guarded polygon refresh for the full-run working PCB. }

const
    InventoryExpectedBoard = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    InventoryOutputDirectory = 'recorded-workspace\runs\full-routing-2026-09-30\current-inspection';

{ Find the loaded trial by its full path, even while the script editor is active. }

var Batch461Adds : Integer;

function FullTrackRemoveInteger(Text : String; var Value : Integer) : Boolean;
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
function FullTrackRemoveSameEndpoints(AX1, AY1, AX2, AY2,
    BX1, BY1, BX2, BY2 : Integer) : Boolean;
begin
    Result := ((AX1 = BX1) and (AY1 = BY1) and (AX2 = BX2) and (AY2 = BY2)) or
        ((AX1 = BX2) and (AY1 = BY2) and (AX2 = BX1) and (AY2 = BY1));
end;

{ Exact run-added tracks replaced for Ethernet transmit access. }
function FullTrackRemove571Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 200000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126873500,91684100,127183500,91994100)) or
        ((NetName = 'SD2_DATA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127113500,91844100,127273500,92004100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127183500,91994100,127233500,92044100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 50000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127233500,92044100,127263500,92074100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127263500,92069100,127343500,92069100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127261000,92066600,127263500,92069100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127251000,92066600,127261000,92066600)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127246000,92061600,127251000,92066600)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127221000,92061600,127246000,92061600)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127263500,92074100,127293500,92104100)) or
        ((NetName = 'ENET_TX_CTL') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126982700,91897100,127611900,91897100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127193500,92034100,127221000,92061600)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126933500,91774100,127193500,92034100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127343500,92069100,127343500,92344100)) or
        ((NetName = 'SAI1_RXD5') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127383500,91199100,127383500,92874100)) or
        ((NetName = 'ENET_RXC') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127213500,92204100,127518500,91899100)) or
        ((NetName = 'SD2_DATA3') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127213500,91884100,127413500,91884100)) or
        ((NetName = 'SD2_DATA3') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127203500,91874100,127213500,91884100));
end;

{ Exact run-added tracks replaced for the Ethernet receive connection. }
function FullTrackRemove566Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'ENET_MDC') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127641500,92621500,134898900,92621500)) or
        ((NetName = 'ENET_RD1') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127441500,92424600,127761500,92424600));
end;

{ Exact run-added tracks replaced for DSI data access. }
function FullTrackRemove563Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'CSI_D0_P') and (LayerId = 2) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123733500,96904100,124533500,96904100)) or
        ((NetName = 'I2C4_SDA') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123967600,95689710,123967600,100669929)) or
        ((NetName = 'I2C2_SCL') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122810200,101910300,123352519,101910300)) or
        ((NetName = 'I2C1_SDA') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123905600,96143200,123905600,98523237)) or
        ((NetName = 'I2C1_SCL') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123843600,96288600,123843600,98414850)) or
        ((NetName = 'UART1_TXD') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123483500,96721600,124328500,96721600)) or
        ((NetName = 'UART4_TXD') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,121109891,101853808,123740908,101853808)) or
        ((NetName = 'DRAMA_CKE1') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123868500,95794100,123868500,100869100)) or
        ((NetName = 'I2C3_SDA') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123978500,95939100,123978500,101309100));
end;

{ Exact run-added tracks replaced for the WL wake connection. }
function FullTrackRemove552Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'NVCC_ENET') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126428500,93464100,127923500,93464100)) or
        ((NetName = 'SD1_CLK') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127471500,93505900,127828887,93505900)) or
        ((NetName = 'SAI1_RXD7') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126813500,93444100,128713500,93444100)) or
        ((NetName = 'SD2_WP') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127715500,93110118,127715500,93778310)) or
        ((NetName = 'BT_WAKE_HOST') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127441500,93408900,127681500,93408900)) or
        ((NetName = 'BT_WAKE_HOST') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127681500,93408900,127841500,93248900)) or
        ((NetName = 'SD2_CLK') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126654100,93394100,127813500,93394100)) or
        ((NetName = 'NVCC_SD2') and (LayerId = 4) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127756500,93495100,128482500,93495100)) or
        ((NetName = 'NVCC_SD2') and (LayerId = 4) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127756500,93495100,127756500,93615100)) or
        ((NetName = 'SAI2_RXC') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126828500,93379100,128118500,93379100)) or
        ((NetName = 'SD2_NRST') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127543500,93379100,128718500,93379100)) or
        ((NetName = 'WL_REG_ON') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127313500,93998582,131866783,89445299)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127600500,93354100,127763500,93354100)) or
        ((NetName = 'SD1_CMD') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127441500,93605700,127841500,93605700)) or
        ((NetName = 'BT_WAKE_HOST') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127841500,93248900,127851318,93248900)) or
        ((NetName = 'BT_WAKE_HOST') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127851318,93248900,127936918,93334500));
end;

{ Exact run-added tracks replaced for the SD1 DATA3 connection. }
function FullTrackRemove554Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'QSPIA_DATA0') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126832500,94393100,127433500,93792100)) or
        ((NetName = 'UART1_CTS') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127148500,94099100,127463500,93784100)) or
        ((NetName = 'WL_REG_ON') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127249017,93998583,127313500,93998583)) or
        ((NetName = 'WL_REG_ON') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127133500,94114100,127249017,93998583)) or
        ((NetName = 'WL_REG_ON') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127313500,93998582,127313500,93998299)) or
        ((NetName = 'WL_REG_ON') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127313500,93998299,127692500,93619299)) or
        ((NetName = 'GND') and (LayerId = 32) and (Width = 50000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127113500,93859900,127315000,93859900)) or
        ((NetName = 'GND') and (LayerId = 32) and (Width = 50000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127315000,93687200,127315000,93859900));
end;

{ Exact run-added tracks replaced for the SAI1 TXD7 connection. }
function FullTrackRemove557Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SAI1_TXD6') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126654000,91474400,129699000,88429400)) or
        ((NetName = 'SD2_DATA2') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127233500,91294100,130453500,88074100));
end;

{ Exact run-added tracks replaced for the CSI clock connection. }
function FullTrackRemove559Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125343500,96796600,125343500,96871600)) or
        ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125343500,96796600,125343500,96796746)) or
        ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125343500,96796746,125343754,96797000)) or
        ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125293754,96797000,125343754,96797000)) or
        ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125293500,96796746,125293754,96797000)) or
        ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125293500,96796600,125293500,96796746)) or
        ((NetName = 'UART1_CTS') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125163500,96926600,125293500,96796600)) or
        ((NetName = 'VDD_SOC_0V8') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125193500,96704100,125403500,96914100)) or
        ((NetName = 'VDD_SOC_0V8') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125193500,96629100,125193500,96704100)) or
        ((NetName = 'VDD_SOC_0V8') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125146000,96581600,125193500,96629100));
end;

{ Exact run-added tracks replaced for the CLKIN2 connection. }
function FullTrackRemove562Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'QSPIA_DATA3') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127773500,95434100,128173500,95434100)) or
        ((NetName = 'QSPIA_DATA2') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127833500,95294100,129373500,96834100)) or
        ((NetName = 'UART1_RTS') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127728500,95424100,128083500,95424100)) or
        ((NetName = 'NVCC_SNVS_1V8') and (LayerId = 6) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127803500,95424100,128163500,95424100));
end;

{ Exact run-added tracks replaced for the ENET TD2 connection. }
function FullTrackRemove586Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'ENET_TX_CTL') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126982700,91622100,126982700,91897100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 200000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126833500,91684100,126873500,91684100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126933500,91474100,126933500,91774100)) or
        ((NetName = 'SAI1_TXD0') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126733500,91694100,127133500,91694100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126793500,91844100,127033500,91844100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 200000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126793500,91644100,126833500,91684100)) or
        ((NetName = 'SD2_DATA3') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126868500,91874100,127203500,91874100)) or
        ((NetName = 'SD2_DATA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127113500,91634100,127113500,91844100)) or
        ((NetName = 'ENET_TX_CTL') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126982700,91622100,127470700,91622100));
end;

{ Exact run-added tracks replaced for the ENET TD3 connection. }
function FullTrackRemove588Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SAI1_TXD4') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126457200,91525400,129868500,88114100)) or
        ((NetName = 'SAI1_TXD1') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126733500,91363800,129452900,88644400)) or
        ((NetName = 'QSPIA_DATA3') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126493500,91414100,129213500,88694100));
end;

{ Exact RXD0 access replacements, including the reviewed RXD1 antenna. }
function FullTrackRemove589Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'QSPIA_DATA3') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124743500,92134100,129243500,87634100)) or
        ((NetName = 'SAI1_RXD1') and (LayerId = 1) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125179100,91834000,125179100,91931100)) or
        ((NetName = 'GPIO1_IO12') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125191300,91689533,125191300,92134533)) or
        ((NetName = 'SAI5_RXFS') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125198400,89056800,125198400,92071800)) or
        ((NetName = 'SAI1_RXD1') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125059200,92030900,125213500,91876600)) or
        ((NetName = 'SAI1_RXD1') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125213500,90064100,125213500,91876600)) or
        ((NetName = 'VDD_DRAM&PU_0V9') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124768500,91734100,125718500,91734100)) or
        ((NetName = 'SAI5_MCLK') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125223500,90419100,125223500,92359100)) or
        ((NetName = 'VDDA_1V8') and (LayerId = 32) and (Width = 50000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125238200,91632700,125238200,91982400)) or
        ((NetName = 'SAI1_RXD1') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128893500,86634100,130450800,85076800)) or
        ((NetName = 'SAI1_MCLK') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130208500,84549100,130208500,85699100)) or
        ((NetName = 'SAI1_RXC') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130138500,85229100,130188500,85179100)) or
        ((NetName = 'SAI1_RXC') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130188500,84654100,130188500,85179100)) or
        ((NetName = 'SAI5_RXFS') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129748400,85311800,131138400,85311800));
end;

{ Exact run-added tracks replaced for the SD3 DATA1 connection. }
function FullTrackRemove592Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SD3_DATA7') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132963500,97169100,132983500,97189100)) or
        ((NetName = 'SD3_DATA7') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,131218500,97169100,132963500,97169100)) or
        ((NetName = 'QSPIA_DATA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127638500,95149100,127783500,95294100)) or
        ((NetName = 'QSPIA_DATA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127106600,95149100,127638500,95149100)) or
        ((NetName = 'QSPIA_DATA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126961600,95294100,127106600,95149100)) or
        ((NetName = 'QSPIA_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126926700,95034100,127493500,95034100)) or
        ((NetName = 'GND') and (LayerId = 32) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127080200,94891800,127197200,95008800)) or
        ((NetName = 'GND') and (LayerId = 32) and (Width = 50000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127197200,95008800,127197200,95188400)) or
        ((NetName = 'VDD_1V8') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126428500,95139100,128908500,95139100)) or
        ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127298500,95099100,127508500,95099100)) or
        ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127208500,95189100,127298500,95099100)) or
        ((NetName = 'SD2_WP') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127793500,93374100,129278500,94859100)) or
        ((NetName = 'SD2_WP') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129278500,94859100,129278500,95089100)) or
        ((NetName = 'SD2_WP') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129278500,95089100,129283500,95094100)) or
        ((NetName = 'SD2_WP') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129283500,95094100,129283500,100499100)) or
        ((NetName = 'QSPIA_DATA3') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128173500,94974100,128173500,95434100)) or
        ((NetName = 'QSPIA_DATA3') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128173500,94414100,128173500,94974100)) or
        ((NetName = 'SD3_DATA7') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127908500,95119100,129033500,95119100));
end;

{ Exact run-added inner tracks replaced for NetR7 access. }
function FullTrackRemove621Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'DRAMA_nCS0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,121988500,94489100,122593500,95094100)) or
        ((NetName = 'DRAMA_CA5') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,121508500,94034100,122573500,95099100));
end;

{ Exact run-added tracks replaced for the PCIe transmit connection. }
function FullTrackRemove634Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'CSI_D3_N') and (LayerId = 32) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125194800,97399100,125479800,97399100)) or
        ((NetName = 'CSI_D1_P') and (LayerId = 3) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125283500,97139100,125283500,97714100)) or
        ((NetName = 'CSI_D3_P') and (LayerId = 1) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125771100,96990300,125771100,97230300)) or
        ((NetName = 'CSI_D3_P') and (LayerId = 1) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125771100,97230300,125536100,97465300)) or
        ((NetName = 'POR_B') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126393500,98004100,126393500,102371600)) or
        ((NetName = 'CSI_D2_P') and (LayerId = 2) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126448500,98194100,126448500,101824100));
end;

{ Exact run-added tracks replaced for the RXD3 source access. }
function FullTrackRemove636Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'GPIO1_IO07') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124743500,91764100,128413500,88094100)) or
        ((NetName = 'GPIO1_IO06') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124737790,91760000,128723600,87774190)) or
        ((NetName = 'GPIO1_IO05') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124576700,92010900,128793500,87794100)) or
        ((NetName = 'PDM_DATA2') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125407700,90138146,125407700,91983400)) or
        ((NetName = 'GPIO1_IO05') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128793500,85471800,129038500,85226800)) or
        ((NetName = 'GPIO1_IO05') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128793500,85471800,128793500,87794100)) or
        ((NetName = 'GPIO1_IO05') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124488700,92010900,124576700,92010900));
end;

{ Exact run-added tracks replaced for the RXD3 connector access. }
function FullTrackRemove639Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SAI1_RXD4') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130883500,85294100,131083500,85094100)) or
        ((NetName = 'SAI1_RXD4') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130883500,85294100,130883500,86309100)) or
        ((NetName = 'SAI5_RXFS') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130275400,85323800,131126400,85323800)) or
        ((NetName = 'GND') and (LayerId = 32) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130770800,84986800,130770800,85226800));
end;

{ Exact run-added tracks replaced for the DDR DATA5 connection. }
function FullTrackRemove548Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122033500,93704150,122133500,93704150)) or
        ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,121452250,94285400,122033500,93704150)) or
        ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122133500,93704150,122263300,93704150)) or
        ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119277746,94285400,121552250,94285400)) or
        ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122263300,93704150,122421750,93704150)) or
        ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119061200,94068854,119277746,94285400)) or
        ((NetName = 'DRAMB_DATA4') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119061200,92936700,119061200,94068854)) or
        ((NetName = 'DRAMB_DATA0') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,118558500,92764100,119228500,92764100)) or
        ((NetName = 'DRAMB_CKE0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,118953500,92954100,119253500,93254100)) or
        ((NetName = 'DRAMB_CKE0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,118658500,92954100,118953500,92954100)) or
        ((NetName = 'DRAMB_CA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,118643500,92964100,119013500,92964100)) or
        ((NetName = 'DRAMB_CA2') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119013500,92964100,119273500,92704100)) or
        ((NetName = 'DRAMB_nCS1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122248500,93971600,122905900,93314200)) or
        ((NetName = 'DRAMB_nCS0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122118500,93709100,122598500,93709100));
end;

{ Exact run-added tracks replaced for SD3_DATA6 access. }
function FullTrackRemove540Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SD3_DATA5') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127548800,94894100,129033500,94894100)) or
        ((NetName = 'SD3_DATA7') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127527900,95094100,129033500,95094100)) or
        ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127553500,95084100,128448500,95084100)) or
        ((NetName = 'SD3_DATA7') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,133128200,97059400,133280000,97059400)) or
        ((NetName = 'SD3_DATA7') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,133013500,97174100,133128200,97059400)) or
        ((NetName = 'SD3_DATA7') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,131213500,97174100,133013500,97174100)) or
        ((NetName = 'SD2_NRST') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132983500,96774100,132983500,97444100));
end;

{ Match the ten reviewed run-added tracks in the JTAG escape replacement. }
function FullTrackRemove534Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'JTAG_TMS') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127721500,95967900,127967500,96213900)) or
        ((NetName = 'JTAG_TMS') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127967500,96213900,127967500,100067700)) or
        ((NetName = 'PMIC_ON_REQ') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127847500,95984781,128029500,96166781)) or
        ((NetName = 'PMIC_ON_REQ') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128029500,96166781,128029500,100366690)) or
        ((NetName = 'BOOT_MODE0') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127783387,95834887,128728387,96779887)) or
        ((NetName = 'SD3_STROBE') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129921500,94708100,129921500,96363100)) or
        ((NetName = 'SD2_NRST') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129290600,93877396,129290600,100981125)) or
        ((NetName = 'CLKIN1') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127786500,95564200,128471500,96249200)) or
        ((NetName = 'JTAG_TDI') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127441500,96164700,127641500,96164700)) or
        ((NetName = 'JTAG_TDI') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127380600,96425600,127641500,96164700));
end;

{ Exact run-added tracks replaced for SPI receive access. }
function FullTrackRemove526Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'CSI_D0_P') and (LayerId = 2) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123733500,96904100,123733500,100714100)) or
        ((NetName = 'I2C2_SDA') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123731800,96399800,123731800,98321296)) or
        ((NetName = 'POR_B') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123273500,97734100,123703500,97304100)) or
        ((NetName = 'POR_B') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123703500,97304100,124343500,97304100)) or
        ((NetName = 'POR_B') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123008500,97279100,124318500,97279100)) or
        ((NetName = 'UART3_CTS') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123504400,96952200,123504400,97752200)) or
        ((NetName = 'UART3_TXD') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123603500,96994100,123603500,97659100)) or
        ((NetName = 'ECSPI2_MOSI') and (LayerId = 1) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123798500,96994100,123798500,97849100)) or
        ((NetName = 'ECSPI2_SS0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,121809000,102364100,123063500,102364100));
end;

{ Exact run-added tracks replaced by the SD2 reset connection. }
function FullTrackRemove530Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126673500,92844100,127293500,92844100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127138500,92729100,127763500,93354100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127293500,92844100,127293500,93399100)) or
        ((NetName = 'SAI1_RXD5') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126423500,92874100,127383500,92874100)) or
        ((NetName = 'SD2_DATA0') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126860000,92903300,127500000,92903300)) or
        ((NetName = 'SD2_DATA0') and (LayerId = 32) and (Width = 41000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126860000,92903300,127535000,92903300)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126900954,93039646,127193500,92747100)) or
        ((NetName = 'SD2_DATA1') and (LayerId = 3) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127103500,92747100,127193500,92747100));
end;

{ Exact run-added tracks replaced for PCIe negative clock access. }
function FullTrackRemove521Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'VDD_1V8') and (LayerId = 4) and (Width = 200000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,123683500,97584100,126003500,97584100)) or
        ((NetName = 'SD2_CLK') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126844900,100245500,126844900,102358600));
end;

{ Identify the exact run-added inner tracks replaced for SAI2 receive frame access. }
function FullTrackRemove522Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SAI1_RXD1') and (LayerId = 2) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129528500,85089100,129743500,85089100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129528500,85089100,129528500,85424100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130453600,85079100,130455900,85076800) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130453500,85079100,130453600,85079100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130453500,85079100,130453500,85119100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129783500,85119100,130453500,85119100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129778500,85114100,129783500,85119100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129743500,85114100,129778500,85114100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129743500,85089100,129743500,85114100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129528500,85424100,131438500,85424100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,131438500,84519100,131438500,85424100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129748500,84519100,131438500,84519100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129738500,84529100,129748500,84519100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129723500,84529100,129738500,84529100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,129703500,84549100,129723500,84529100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128963500,84549100,129703500,84549100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128248500,85264100,128963500,84549100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128248500,85264100,128248500,85899100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127518500,86629100,128248500,85899100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127083500,86629100,127518500,86629100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127083500,86629100,127083500,87064100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126923500,87224100,127083500,87064100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124818500,87224100,126923500,87224100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124818500,87224100,124818500,89444100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124818500,89444100,124943500,89569100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124943500,89569100,124943500,90179100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124938500,90184100,124943500,90179100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124933500,90184100,124938500,90184100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124873500,90244100,124933500,90184100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124873500,90244100,124873500,91844100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,124873500,91844100,125058500,92029100) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125058500,92029100,125058500,92030200) or
            FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125058500,92030200,125059200,92030900))) or
        ((NetName = 'SAI1_RXC') and (LayerId = 6) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128943500,85084100,129668500,85084100)));
end;

{ Identify the run-added supply track replaced for PCIe clock access. }
function FullTrackRemove516Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := (NetName = 'VDD_1V8') and (LayerId = 4) and (Width = 200000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126443500,96497850,126443500,97184100);
end;

{ Identify the run-added inner tracks replaced for SAI1 TXD2 access. }
function FullTrackRemove515Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := (Width = 32000) and (
        ((NetName = 'PDM_DATA0') and (LayerId = 7) and
        (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126234600,91766600,126434600,91566600) or
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125542100,91766600,126234600,91766600))) or
        ((NetName = 'SAI1_RXD5') and (LayerId = 5) and
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,131044500,86694300,131044500,87471800)) or
        ((NetName = 'PDM_DATA1') and (LayerId = 5) and
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125467400,91854100,126373500,91854100)));
end;

{ Identify the run-added inner tracks replaced for SAI1 TXD4 access. }
function FullTrackRemove513Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SAI1_TXD1') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126105400,91991900,129452900,88644400)) or
        ((NetName = 'PDM_DATA1') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125467400,91854100,126797400,91854100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 200000) and
        (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126362287,91622887,126383500,91644100) or
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126383500,91644100,126793500,91644100)));
end;

{ Identify the run-added inner tracks replaced for USB1 DN access. }
function FullTrackRemove514Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'NetR30_1') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126583500,96909100,126968500,97294100)) or
        ((NetName = 'JTAG_TDO') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126693500,96984100,127383500,97674100));
end;

{ Identify the run-added inner tracks replaced for DDRB DATA11 access. }
function FullTrackRemove510Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SD2_DATA3') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122368500,92124100,122368500,92614100)) or
        ((NetName = 'VDD_SOC_0V8') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122368500,92124100,122368500,92764100));
end;

{ Identify the run-added UART track replaced for CLKOUT1 access. }
function FullTrackRemove507Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := (NetName = 'UART1_RTS') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127193500,95509100,127643500,95509100);
end;

{ Identify the run-added clock-enable track replaced for DDRA DATA3 access. }
function FullTrackRemove508Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := (NetName = 'DRAMA_CKE0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119943500,96464100,121903500,96464100);
end;

{ Identify the run-added chip-select track replaced for DDRB DATA1 access. }
function FullTrackRemove506Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := (NetName = 'DRAMB_nCS0') and (LayerId = 6) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119963500,93359100,121978500,93359100);
end;

{ Identify the run-added inner tracks replaced for CLKOUT2 access. }
function FullTrackRemove503Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'NVCC_SNVS_1V8') and (LayerId = 6) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126643500,95414100,127793500,95414100)) or
        ((NetName = 'UART1_RTS') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126193500,95424100,128083500,95424100));
end;

{ Identify the six run-added tracks replaced for DDRB DATA0 access. }
function FullTrackRemove504Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'VDD_SOC_0V8') and (LayerId = 4) and (Width = 200000) and
        (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122448500,92844100,122448500,93944100) or
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122368500,92764100,122448500,92844100))) or
        ((NetName = 'DRAMB_CKE0') and (LayerId = 6) and (Width = 32000) and
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,120053500,92859100,122898500,92859100)) or
        ((NetName = 'SD2_DATA3') and (LayerId = 6) and (Width = 32000) and
        (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122368500,92614100,122513500,92759100) or
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,122513500,92759100,122988500,92759100))) or
        ((NetName = 'DRAMB_CA5') and (LayerId = 2) and (Width = 32000) and
         FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,119713500,92879100,122648500,92879100));
end;

{ Allow only the exact run-added inner tracks in the SAI preservation batch. }
function FullTrackRemove479Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'SAI1_TXD1') and (LayerId = 7) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130933300,86439400,130933500,86439200) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130933500,86439100,130933500,86439200) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130933500,86439100,130933500,88924100) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,130283500,89574100,130933500,88924100) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128518500,89574100,130283500,89574100) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126103500,91989100,128518500,89574100) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126103500,91989100,126103500,91990900))) or
        ((NetName = 'SAI1_RXD5') and (LayerId = 5) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125709800,91990900,125709800,91991800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125709800,91991800,125709800,92976800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125709800,92976800,126084800,92976800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126084800,92976800,126089800,92971800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126089800,92971800,126124800,92971800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126124800,92971800,126144800,92951800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126144800,92951800,126219800,92951800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126219800,92951800,126379800,92791800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126379800,92791800,127389800,92791800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127389800,86686800,127389800,92791800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127389800,86686800,127484800,86591800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127484800,86591800,127514800,86591800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127514800,86591800,128749800,85356800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128749800,85356800,131114800,85356800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,131114800,85356800,131244800,85226800) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,131243300,85226800,131244800,85226800))) or
        ((NetName = 'SAI1_TXC') and (LayerId = 2) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125576300,91259100,125576300,92304100))) or
        ((NetName = 'SAI1_MCLK') and (LayerId = 6) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125573500,91229100,125573500,92274100))) or
        ((NetName = 'VDDA_1V8') and (LayerId = 6) and (Width = 30000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125838500,91728600,125838500,92043600) or
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125718500,92163600,125838500,92043600))) or
        ((NetName = 'SAI2_MCLK') and (LayerId = 2) and (Width = 32000) and (FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,125953500,91524100,125953500,92297300)));
end;

{ Allow only the exact inner tracks replaced by the Ethernet receive clock batch. }
function FullTrackRemove489Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 200000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126873500,91684100,127293500,92104100)) or
        ((NetName = 'VDD_ARM_0V9') and (LayerId = 4) and (Width = 100000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127293500,92104100,127033500,91844100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,134649800,88167800,134649800,88185400)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,134649800,88167800,134673500,88144100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,134673500,87964100,134673500,88144100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,134603500,87894100,134673500,87964100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132073500,87894100,134603500,87894100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128413500,91554100,132073500,87894100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127123500,91554100,128413500,91554100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126285500,92392100,127123500,91554100)) or
        ((NetName = 'SAI2_TXC') and (LayerId = 7) and (Width = 32000) and FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,126285500,92392100,126285500,92473400));
end;

{ Exact run-added DATA2 access replacements. }
function FullTrackRemove593Target(NetName : String; LayerId, Width, X1, Y1, X2, Y2 : Integer) : Boolean;
begin
    Result := ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127903500,94789100,128448500,94789100)) or
        ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128448500,94789100,128448500,95084100)) or
        ((NetName = 'UART1_RXD') and (LayerId = 7) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128213500,95134100,134374800,88972800)) or
        ((NetName = 'GND') and (LayerId = 7) and (Width = 100000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,128123500,94991700,128124200,94992400)) or
        ((NetName = 'SD3_DATA6') and (LayerId = 2) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127933500,94984100,128158500,94759100)) or
        ((NetName = 'SD2_NRST') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132983500,97279100,133068500,97194100)) or
        ((NetName = 'SD2_WP') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132983500,97194100,133413500,97194100)) or
        ((NetName = 'SD2_NRST') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,133068500,97194100,133408500,97194100)) or
        ((NetName = 'SD2_WP') and (LayerId = 5) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132983500,97194100,132983500,100504100)) or
        ((NetName = 'SD2_NRST') and (LayerId = 4) and (Width = 32000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,132983500,97279100,132983500,97444100)) or
        ((NetName = 'GND') and (LayerId = 7) and (Width = 30000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127826000,94694100,128123500,94991600)) or
        ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127898500,94794100,127903500,94789100)) or
        ((NetName = 'USB1_DN') and (LayerId = 5) and (Width = 150000) and
        FullTrackRemoveSameEndpoints(X1,Y1,X2,Y2,127848500,94794100,127898500,94794100));
end;

{ Return an empty name for an unassigned track. }
function FullTrackRemoveNetName(Track : IPCB_Track) : String;
begin
    Result := '';
    if Track.Net <> nil then Result := Track.Net.Name;
end;

{ Record the last stage and the number of completed readbacks. }
procedure FullTrackRemoveStage(Status : TStringList; StageName : String;
    RowIndex, Completed : Integer);
begin
    Status.Clear;
    Status.Add(StageName);
    Status.Add('expected_board=' + FullTrackRemoveExpectedBoard);
    Status.Add('row=' + IntToStr(RowIndex));
    Status.Add('completed_readbacks=' + IntToStr(Completed));
    Status.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-status.txt');
end;

{ Count tracks using the qualified inventory's legacy iterator scope. }
function FullTrackRemoveCount(Board : IPCB_Board) : Integer;
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

{ Build an audit row; a negative after-count means readback has not completed. }
function FullTrackRemoveAuditRow(BoardName : String; RowIndex : Integer;
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

{ Verify the target is absent without reading a removed object's properties. }
procedure FullTrackRemoveReadback(Board : IPCB_Board; NetName : String;
    X1, Y1, X2, Y2, Width, Layer : Integer; var Total, Matches : Integer);
var
    Iterator : IPCB_BoardIterator;
    Track : IPCB_Track;
begin
    Total := 0;
    Matches := 0;
    Iterator := Board.BoardIterator_Create;
    try
        Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
        Iterator.AddFilter_LayerSet(AllLayers);
        Iterator.AddFilter_Method(eProcessAll);
        Track := Iterator.FirstPCBObject;
        while Track <> nil do
        begin
            Inc(Total);
            if (Track.Layer = Layer) and (Track.Width = Width) and
               (FullTrackRemoveNetName(Track) = NetName) and
               FullTrackRemoveSameEndpoints(Track.X1, Track.Y1, Track.X2, Track.Y2,
                   X1, Y1, X2, Y2) then Inc(Matches);
            Track := Iterator.NextPCBObject;
        end;
    finally
        Board.BoardIterator_Destroy(Iterator);
    end;
end;

{ Validate all rows before removing one registered track per native Undo step. }
procedure RemoveExplicitFullTracks;
var
    Board, ActiveBoard : IPCB_Board;
    Iterator : IPCB_BoardIterator;
    Primitive : IPCB_Primitive;
    Net : IPCB_Net;
    Track, RemovedTrack : IPCB_Track;
    Lines, Fields, Status, Audit : TStringList;
    NetNames : array[1..128] of String;
    X1, Y1, X2, Y2, Widths, Layers, ExpectedCounts : array[1..128] of Integer;
    NetMatches, TrackMatches : array[1..128] of Integer;
    TargetTracks : array[1..128] of IPCB_Track;
    Row, ResultName, ScanNetName : String;
    ScanLayer, ScanWidth, ScanX1, ScanY1, ScanX2, ScanY2 : Integer;
    I, J, Separator, RowCount, BeforeCount, CurrentCount, AfterCount : Integer;
    ParsedValue, RemainingMatches, Completed : Integer;
    MutationAttempted : Boolean;
begin
    Lines := TStringList.Create;
    Fields := TStringList.Create;
    Status := TStringList.Create;
    Audit := TStringList.Create;
    I := 0;
    Completed := 0;
    MutationAttempted := False;
    try
        try
            FullTrackRemoveStage(Status, 'validating_request', 0, Completed);
            Audit.Add('board' + #9 + 'row' + #9 + 'action' + #9 + 'net' + #9 +
                'x1_raw' + #9 + 'y1_raw' + #9 + 'x2_raw' + #9 + 'y2_raw' + #9 +
                'width_raw' + #9 + 'layer_id' + #9 + 'before_track_count' + #9 +
                'after_track_count' + #9 + 'result');
            Audit.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-audit.tsv');
            Board := PCBServer.GetCurrentPCBBoard;
            if Board = nil then
            begin
                FullTrackRemoveStage(Status, 'refused_no_active_pcb', 0, Completed);
                Exit;
            end;
            if UpperCase(Board.FileName) <> UpperCase(FullTrackRemoveExpectedBoard) then
            begin
                FullTrackRemoveStage(Status, 'refused_wrong_board', 0, Completed);
                Exit;
            end;
            if not FileExists(FullTrackRemoveDirectory + '\remove-tracks.tsv') then
            begin
                FullTrackRemoveStage(Status, 'refused_missing_request', 0, Completed);
                Exit;
            end;
            Lines.LoadFromFile(FullTrackRemoveDirectory + '\remove-tracks.tsv');
            Lines.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-request.tsv');
            if (Lines.Count < 2) or (Lines.Count > 129) then
            begin
                FullTrackRemoveStage(Status, 'refused_row_count', 0, Completed);
                Exit;
            end;
            if Lines.Strings[0] <> 'net' + #9 + 'x1_raw' + #9 + 'y1_raw' + #9 +
                'x2_raw' + #9 + 'y2_raw' + #9 + 'width_raw' + #9 + 'layer_id' +
                #9 + 'expected_track_count' then
            begin
                FullTrackRemoveStage(Status, 'refused_header', 0, Completed);
                Exit;
            end;
            RowCount := Lines.Count - 1;
            for I := 1 to RowCount do
            begin
                FullTrackRemoveStage(Status, 'validating_row', I, Completed);
                Fields.Clear;
                Row := Lines.Strings[I];
                for J := 1 to 7 do
                begin
                    Separator := Pos(#9, Row);
                    if Separator = 0 then
                    begin
                        FullTrackRemoveStage(Status, 'refused_columns', I, Completed);
                        Exit;
                    end;
                    Fields.Add(Copy(Row, 1, Separator - 1));
                    Row := Copy(Row, Separator + 1, Length(Row));
                end;
                Fields.Add(Row);
                if Pos(#9, Row) > 0 then
                begin
                    FullTrackRemoveStage(Status, 'refused_extra_columns', I, Completed);
                    Exit;
                end;
                NetNames[I] := Fields.Strings[0];
                if (NetNames[I] = '') or (NetNames[I] <> Trim(NetNames[I])) then
                begin
                    FullTrackRemoveStage(Status, 'refused_net_field', I, Completed);
                    Exit;
                end;
                for J := 1 to 7 do
                begin
                    if not FullTrackRemoveInteger(Fields.Strings[J], ParsedValue) then
                    begin
                        FullTrackRemoveStage(Status, 'refused_numeric_field', I, Completed);
                        Exit;
                    end;
                    case J of
                        1: X1[I] := ParsedValue;
                        2: Y1[I] := ParsedValue;
                        3: X2[I] := ParsedValue;
                        4: Y2[I] := ParsedValue;
                        5: Widths[I] := ParsedValue;
                        6: Layers[I] := ParsedValue;
                        7: ExpectedCounts[I] := ParsedValue;
                    end;
                end;
                if (X1[I] <= 0) or (Y1[I] <= 0) or (X2[I] <= 0) or (Y2[I] <= 0) or
                   (Widths[I] <= 0) or ((X1[I] = X2[I]) and (Y1[I] = Y2[I])) or
                   ((Layers[I] <> eTopLayer) and (Layers[I] <> FullTrackRemoveL3Layer) and
                    (Layers[I] <> eBottomLayer) and
                    not FullTrackRemove479Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove489Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove504Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove503Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove506Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove508Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove507Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove510Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove514Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove513Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove515Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove516Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove521Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove530Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove534Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove552Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove554Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove557Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove559Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove562Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove563Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove566Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove571Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove586Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove588Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove589Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove592Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove593Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove621Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove634Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove636Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove639Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove548Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove540Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove526Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not FullTrackRemove522Target(NetNames[I],Layers[I],Widths[I],X1[I],Y1[I],X2[I],Y2[I]) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'PMIC_STBY_REQ') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124093500, 91534100, 124093500, 93614100)) and
                    not ((Layers[I] = 7) and (NetNames[I] = 'GPIO1_IO11') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124083500, 90174100, 124083500, 92413600)) and
                    not ((Layers[I] = 2) and (NetNames[I] = 'GPIO1_IO10') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124083500, 90144100, 124083500, 92201700)) and
                    not ((Layers[I] = 4) and (NetNames[I] = 'VDD_DRAM&PU_0V9') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124138500, 91764100, 124138500, 93434100)) and
                    not ((Layers[I] = 5) and (NetNames[I] = 'GPIO1_IO07') and
                         (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124476700, 92030900, 128413500, 88094100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124291800, 92030900, 124476700, 92030900))) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'ECSPI2_SCLK') and
                         (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             123292600, 96197700, 123292600, 96765000) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122983500, 97074100, 123292600, 96765000))) and
                    not ((Layers[I] = 2) and (NetNames[I] = 'DRAMA_DATA5') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             123253500, 96424100, 123253500, 96864100)) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'DRAMB_CA4') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122068500, 94234100, 122898500, 94234100)) and
                    not ((Layers[I] = 4) and (NetNames[I] = 'VDD_SOC_0V8') and
                         (Widths[I] = 200000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122448500, 92844100, 122448500, 96374100)) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'SAI1_RXC') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127538500, 85144100, 128883500, 85144100)) and
                    not ((Layers[I] = 4) and (NetNames[I] = 'VDD_ARM_0V9') and
                         (Widths[I] = 200000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127293500, 92104100, 127293500, 93399100)) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'SAI2_TXFS') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             126662400, 92599100, 127483500, 92599100)) and
                    not ((Layers[I] = 7) and (NetNames[I] = 'SAI5_RXFS') and
                         (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125133500, 91354100, 125133500, 92710500) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129663500, 85226800, 129663500, 85554100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129383500, 85834100, 129663500, 85554100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129383500, 85834100, 129383500, 87104100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125133500, 91354100, 129383500, 87104100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125133500, 92710500, 125258400, 92835400))) and
                    not ((Layers[I] = 2) and (NetNames[I] = 'SAI1_RXD5') and
                         (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125123500, 93359100, 125123500, 92074100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125123500, 92074100, 125348500, 92074100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             131243300, 85226800, 131243500, 85227000) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             131243500, 85227000, 131243500, 85229100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129893500, 85229100, 131243500, 85229100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129778500, 85114100, 129893500, 85229100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129743500, 85114100, 129778500, 85114100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129743500, 85089100, 129743500, 85114100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129203500, 85089100, 129743500, 85089100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129203500, 85089100, 129203500, 85794100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             128833500, 86164100, 129203500, 85794100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             128833500, 86164100, 128833500, 88499100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127568500, 88499100, 128833500, 88499100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127563500, 88504100, 127568500, 88499100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127543500, 88504100, 127563500, 88504100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127533500, 88514100, 127543500, 88504100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127353500, 88514100, 127533500, 88514100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127353500, 88514100, 127353500, 89914100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127348500, 89914100, 127353500, 89914100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127123500, 90139100, 127348500, 89914100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125348500, 90139100, 127123500, 90139100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125348500, 90139100, 125348500, 92074100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125123500, 93359100, 125508500, 93359100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125508500, 93359100, 125518500, 93349100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125518500, 93349100, 125708500, 93349100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125708500, 91989100, 125708500, 93349100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125708500, 91989100, 125708500, 91989600) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125708500, 91989600, 125709800, 91990900))) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'PDM_CLK') and
                         (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125158500, 89049100, 125158500, 92279100))) and
                    not ((Layers[I] = 2) and (NetNames[I] = 'SAI1_TXC') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125626300, 92489100, 125626300, 91209100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'VDDA_1V8') and (Widths[I] = 30000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125723500, 91613600, 125723500, 93644100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'SAI1_MCLK') and (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125608500, 91194100, 125608500, 92309100)) and
                    not ((Layers[I] = 2) and (NetNames[I] = 'DRAMA_DATA1') and
                         (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             117728500, 96689100, 122438500, 96689100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'DRAMA_SDQS0_C') and (Widths[I] = 150000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122288500, 96779100, 122543500, 96779100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             120873500, 98194100, 122288500, 96779100))) and
                    not ((Layers[I] = 2) and (NetNames[I] = 'DSI_D3_P') and
                         (Widths[I] = 150000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125058500, 96794100, 124723500, 96794100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125058500, 97659100, 125058500, 96794100))) and
                    not ((Layers[I] = 4) and (NetNames[I] = 'VDD_SOC_0V8') and
                         (Widths[I] = 100000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124673500, 96629100, 125193500, 96629100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125193500, 96629100, 125373500, 96809100))) and
                    not ((Layers[I] = 6) and (NetNames[I] = 'VDD_PHY_0V9') and
                         (Widths[I] = 50000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125033500, 95554100, 125033500, 101989100)) and
                    not ((Layers[I] = 4) and (NetNames[I] = 'VDD_ARM_0V9') and
                         (Widths[I] = 200000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125893500, 91154100, 126383500, 91644100)) and
                    not ((Layers[I] = 4) and (NetNames[I] = 'VDD_SOC_0V8') and
                         (Widths[I] = 200000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             123088500, 96804100, 124333500, 96804100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             123048500, 96764100, 123088500, 96804100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             123013500, 96764100, 123048500, 96764100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122903500, 96654100, 123013500, 96764100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122448500, 96614100, 122903500, 96614100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122448500, 89229100, 122448500, 96614100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122448500, 89229100, 122448500, 96374100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             124338500, 96809100, 125703500, 96809100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             125373500, 96809100, 125703500, 96809100))) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'NVCC_SD2') and (Widths[I] = 50000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             134688500, 85124100, 134688500, 88819100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'NVCC_SD2') and (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             134003500, 88819100, 134688500, 88819100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'NVCC_SD2') and (Widths[I] = 50000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             134688500, 88819100, 134833500, 88674100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'SAI1_RXC') and (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             129668500, 84774100, 129668500, 85139100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             127538500, 85139100, 129668500, 85139100))) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'SD1_STROBE') and (Widths[I] = 32000) and
                         FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             126933500, 94274100, 128033500, 94274100)) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         (NetNames[I] = 'SD2_DATA3') and (Widths[I] = 32000) and
                         (FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             122513500, 87079100, 122513500, 92759100) or
                          FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                             126848500, 91854100, 127413500, 91854100))) and
                    not ((Layers[I] = FullTrackRemoveL6Layer) and
                         ((NetNames[I] = 'RTC_RESET_B') or
                          (NetNames[I] = 'PMIC_STBY_REQ') or
                          (NetNames[I] = 'DRAMA_nCS0')) and
                         (Widths[I] = 32000))) or
                   (ExpectedCounts[I] < RowCount) then
                begin
                    FullTrackRemoveStage(Status, 'refused_dimensions_layer_or_count', I, Completed);
                    Exit;
                end;
                if ExpectedCounts[I] <> ExpectedCounts[1] then
                begin
                    FullTrackRemoveStage(Status, 'refused_inconsistent_before_count', I, Completed);
                    Exit;
                end;
                for J := 1 to I - 1 do
                    if (NetNames[I] = NetNames[J]) and (Widths[I] = Widths[J]) and
                       (Layers[I] = Layers[J]) and
                       FullTrackRemoveSameEndpoints(X1[I], Y1[I], X2[I], Y2[I],
                           X1[J], Y1[J], X2[J], Y2[J]) then
                    begin
                        FullTrackRemoveStage(Status, 'refused_repeated_target', I, Completed);
                        Exit;
                    end;
                NetMatches[I] := 0;
                TrackMatches[I] := 0;
                TargetTracks[I] := nil;
            end;
            FullTrackRemoveStage(Status, 'checking_all_targets', 0, Completed);
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
                                    NetMatches[I] := NetMatches[I] + 1;
                        end;
                        eTrackObject:
                        begin
                            Track := Primitive;
                            Inc(BeforeCount);
                            ScanLayer := Track.Layer; ScanWidth := Track.Width;
                            ScanX1 := Track.X1; ScanY1 := Track.Y1;
                            ScanX2 := Track.X2; ScanY2 := Track.Y2;
                            ScanNetName := FullTrackRemoveNetName(Track);
                            for I := 1 to RowCount do
                                if (ScanLayer = Layers[I]) and (ScanWidth = Widths[I]) and
                                   (ScanNetName = NetNames[I]) and
                                   FullTrackRemoveSameEndpoints(ScanX1, ScanY1,
                                       ScanX2, ScanY2, X1[I], Y1[I], X2[I], Y2[I]) then
                                begin
                                    TargetTracks[I] := Track;
                                    TrackMatches[I] := TrackMatches[I] + 1;
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
                FullTrackRemoveStage(Status, 'refused_stale_track_count', 0, Completed);
                Status.Add('expected_track_count=' + IntToStr(ExpectedCounts[1]));
                Status.Add('actual_track_count=' + IntToStr(BeforeCount));
                Status.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-status.txt');
                Exit;
            end;
            for I := 1 to RowCount do
            begin
                if NetMatches[I] <> 1 then
                begin
                    FullTrackRemoveStage(Status, 'refused_net_resolution', I, Completed);
                    Exit;
                end;
                if (TrackMatches[I] <> 1) or (TargetTracks[I] = nil) then
                begin
                    FullTrackRemoveStage(Status, 'refused_target_resolution', I, Completed);
                    Exit;
                end;
            end;
            for I := 1 to RowCount do
                Audit.Add(FullTrackRemoveAuditRow(Board.FileName, I, 'remove', NetNames[I],
                    X1[I], Y1[I], X2[I], Y2[I], Widths[I], Layers[I],
                    BeforeCount - I + 1, -1, 'pending_not_started'));
            Audit.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-audit.tsv');

            for I := 1 to RowCount do
            begin
                FullTrackRemoveStage(Status, 'checking_before_row', I, Completed);
                ActiveBoard := PCBServer.GetCurrentPCBBoard;
                if ActiveBoard = nil then
                begin
                    FullTrackRemoveStage(Status, 'stopped_no_active_pcb_inspect_partial_changes', I, Completed);
                    Exit;
                end;
                if UpperCase(ActiveBoard.FileName) <> UpperCase(FullTrackRemoveExpectedBoard) then
                begin
                    FullTrackRemoveStage(Status, 'stopped_wrong_board_inspect_partial_changes', I, Completed);
                    Exit;
                end;
                CurrentCount := BeforeCount - I + 1;
                RemovedTrack := TargetTracks[I];
                if (RemovedTrack.Width <> Widths[I]) or (RemovedTrack.Layer <> Layers[I]) or
                   (FullTrackRemoveNetName(RemovedTrack) <> NetNames[I]) or
                   not FullTrackRemoveSameEndpoints(RemovedTrack.X1, RemovedTrack.Y1,
                       RemovedTrack.X2, RemovedTrack.Y2, X1[I], Y1[I], X2[I], Y2[I]) then
                begin
                    FullTrackRemoveStage(Status, 'stopped_target_changed_inspect_partial_changes', I, Completed);
                    Exit;
                end;
                Audit.Strings[I] := FullTrackRemoveAuditRow(Board.FileName, I, 'remove',
                    NetNames[I], X1[I], Y1[I], X2[I], Y2[I], Widths[I], Layers[I],
                    CurrentCount, -1, 'removing_inspect_on_interruption');
                Audit.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-audit.tsv');
                FullTrackRemoveStage(Status, 'removing_row_partial_changes_possible', I, Completed);
                MutationAttempted := True;
                PCBServer.PreProcess;
                try
                    Board.RemovePCBObject(RemovedTrack);
                    PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast,
                        PCBM_BoardRegisteration, RemovedTrack.I_ObjectAddress);
                finally
                    PCBServer.PostProcess;
                end;
                FullTrackRemoveStage(Status, 'removed_row_batch_readback_pending', I, 0);
            end;
            { Scan surviving copper once; never dereference removed objects. }
            FullTrackRemoveStage(Status, 'checking_removed_batch', RowCount, 0);
            for I := 1 to RowCount do TrackMatches[I] := 0;
            AfterCount := 0;
            Iterator := Board.BoardIterator_Create;
            try
                Iterator.AddFilter_ObjectSet(MkSet(eTrackObject));
                Iterator.AddFilter_LayerSet(AllLayers);
                Iterator.AddFilter_Method(eProcessAll);
                Track := Iterator.FirstPCBObject;
                while Track <> nil do
                begin
                    Inc(AfterCount);
                    ScanLayer := Track.Layer; ScanWidth := Track.Width;
                    ScanX1 := Track.X1; ScanY1 := Track.Y1;
                    ScanX2 := Track.X2; ScanY2 := Track.Y2;
                    ScanNetName := FullTrackRemoveNetName(Track);
                    for I := 1 to RowCount do
                        if (ScanLayer = Layers[I]) and (ScanWidth = Widths[I]) and
                           (ScanNetName = NetNames[I]) and
                           FullTrackRemoveSameEndpoints(ScanX1,ScanY1,ScanX2,ScanY2,
                               X1[I],Y1[I],X2[I],Y2[I]) then TrackMatches[I] := TrackMatches[I] + 1;
                    Track := Iterator.NextPCBObject;
                end;
            finally Board.BoardIterator_Destroy(Iterator); end;
            if AfterCount <> BeforeCount - RowCount then
            begin
                FullTrackRemoveStage(Status, 'failed_final_count_inspect_partial_changes', RowCount, 0);
                Exit;
            end;
            for I := 1 to RowCount do
                if TrackMatches[I] <> 0 then
                begin
                    FullTrackRemoveStage(Status, 'failed_final_target_readback_inspect_partial_changes', I, 0);
                    Exit;
                end;
            for I := 1 to RowCount do
                Audit.Strings[I] := FullTrackRemoveAuditRow(Board.FileName, I, 'remove',
                    NetNames[I], X1[I], Y1[I], X2[I], Y2[I], Widths[I], Layers[I],
                    BeforeCount, AfterCount, 'removed_batch_readback_ok_drc_not_checked');
            Audit.SaveToFile(FullTrackRemoveDirectory + '\full-track-remove-audit.tsv');
            Completed := RowCount;
            FullTrackRemoveStage(Status, 'removed_batch_readback_ok_drc_not_checked', RowCount, Completed);
        except
            if MutationAttempted then
                FullTrackRemoveStage(Status, 'failed_exception_inspect_partial_changes', I, Completed)
            else
                FullTrackRemoveStage(Status, 'failed_exception_before_mutation', I, Completed);
            raise;
        end;
    finally
        Lines.Free;
        Fields.Free;
        Status.Free;
        Audit.Free;
    end;
end;

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
