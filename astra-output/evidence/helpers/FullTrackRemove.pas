{ Remove at most 128 exact tracks, then verify every target in one native scan. }

const
    FullTrackRemoveL3Layer = 3; { L3_IN1, legacy MidLayer2 on the guarded board. }
    FullTrackRemoveL6Layer = 6; { Bounded control-path rollback. }
    FullTrackRemoveExpectedBoard = 'recorded-workspace\projects\work\full-routing-2026-09-30\QCMI_SOM8MM\IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc';
    FullTrackRemoveDirectory = 'recorded-workspace\runs\full-routing-2026-09-30\quality\full-track-remove';

{ Parse unsigned decimal integers without overflow or other numeric syntax. }
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
