.bank $02
.org $0000 ;$C20000
.base $c0


func_C20000:
	php
	sep #$30 ;AXY->8
	lda.b #$00
	ldx.b #$13
@lbl_C20007:
	sta.l wCharHP,x
	dex
	bpl @lbl_C20007
	sta.l $7E8979
	sta.l $7E89B8
	lda.b #$FF
	sta.l $7E897A
	plp
	rtl

func_C2001E:
	php 
	sep #$30 ;AXY->8
	ldx.b #$12
@lbl_C20023:
	lda.l $7E85F1,x
	beq @lbl_C20037
	dex 
	bpl @lbl_C20023
	ldx.b #$12
@lbl_C2002E:
	lda.l $7E8835,x
	beq @lbl_C20039
	dex 
	bpl @lbl_C2002E
@lbl_C20037:
	plp 
	rtl
@lbl_C20039:
	lda.l $7E8759,x
	bmi @lbl_C2004D
	sta.b wTemp00
	phx
	jsl.l func_C306F4
	plx
	lda.b #$FF
	sta.l $7E8759,x
@lbl_C2004D:
	stx.b wTemp00
	jsl.l func_C20F35
	plp
	rtl

func_C20055:
	php
	sep #$30 ;AXY->8
	lda.b #$06
	sta.b wTemp02
	lda.b #$28
	sta.b wTemp03
	lda.b #$01
	sta.b wTemp04
	stz.b $05
	jsl.l func_C20072
	lda.b #$04
	sta.l $7E89B8
	plp
	rtl

func_C20072:
	php 
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp05
	bra func_C200B0

func_C2007D:
	php
	sep #$30 ;AXY->8
	lda.b #$01
	sta.b wTemp04
	bra func_C20089

func_C20086:
	php
	sep #$30 ;AXY->8
func_C20089:
	bankswitch 0x7E
	ldy.b #$13
@lbl_C2008F:
	lda.w wCharHP,y
	beq @lbl_C2009D
	dey
	bpl @lbl_C2008F
@lbl_C20097:
	ldy.b #$FF
	sty.b wTemp00
	plp
	rtl
@lbl_C2009D:
	cpy.w $89B8
	bcc @lbl_C20097
	lda.l $7ED5EE
	cmp.b #$0C
	bne func_C200B0
;C200AA
	.db $C0,$0C,$B0,$02,$80,$E7
func_C200B0:
	lda.b wTemp04
	sec
	sbc.b #$03
	beq @lbl_C200DB
	bcc @lbl_C200DB
	.db $48,$A9,$03,$85,$04,$22,$E1,$00,$C2,$A6,$00,$22,$3A,$25,$C6,$68   ;C200B9
	.db $86,$00,$85,$01,$DA,$22,$79,$35,$C2,$FA,$22,$45,$25,$C6,$86,$00   ;C200C9  
	.db $28,$6B                           ;C200D9
@lbl_C200DB:
	jsl.l func_C200E1
	plp
	rtl

func_C200E1:
	php
	sep #$30 ;AXY->8
	stz.w $89B9
	lda.b wTemp00
	sta.w wCharXPos,y
	lda.b wTemp01
	sta.w wCharYPos,y
	lda.b wTemp02
	sta.w wCharDir,y
	sta.w wCharAutoDir,y
	lda.b wTemp03
	sta.w wCharType,y
	sta.w wCharAppearance,y
	lda.b wTemp04
	sta.w wCharLevel,y
	sta.w wCharTrueLevel,y
	jsl.l func_C359AF
	lda.b wTemp02
	sta.w wCharUnderfootTerrainType,y
	jsr.w GetEnemyStats
	lda.w wCharType,y
	tax
	lda.b #$00
	sta.w wCharRemainingBlindlessTurns,y
	sta.w wCharRemainingConfusedTurns,y
	sta.w wCharRemainingPuzzledTurns,y
	sta.w wCharRemainingSleepTurns,y
	sta.w wCharRemaningDoubleSpeedTurns,y
	sta.w wCharInvisible,y
	sta.w wCharNPCFlags,y
	sta.w wCharOverrideState,y
	sta.w wCharUnk885D,y
	sta.w wCharEventFlags,y
	sta.w wCharTrapsActivated,y
	sta.w wCharIsKigny,y
	sta.w wCharIgnoreShiren,y
	sta.w wCharNumOfAttacks,y
	sta.w wCharLastAttackedMonsterType,y
	sta.w wCharLastAttackedMonsterLevel,y
	lda.b #$01
	sta.w wCharSpeed,y
	sta.w wCharDeadEndWaitingTurn,y
	lda.b #$FF
	sta.w wCharAttackTarget,y
	sta.w wCharTargetXPos,y
	sta.w wCharTargetYPos,y
	sta.w wCharUnk87F9,y
	lda.b #$00
	sta.w wCharRemainingTigerTrapTurns,y
	sta.w wCharIsSealed,y
	sta.w wCharAttackedByShiren,y
	jsl.l Random
	lda.b wTemp00
	and.b #$01
	sta.w wCharIsAwake,y
	lda.b #$FF
	sta.w wCharHeldItem,y
	jsl.l Random
	lda.b wTemp00
	and.b #$3F
	cmp.l Level1EnemyItemDropRateStatTable,x
	bcs @lbl_C201A1
	lda.l $7ED5EE
	cmp.b #$08
	beq @lbl_C201A1
	phx
	phy
	call_savebank func_C303D0
	ply
	plx
	lda.b wTemp00
	sta.w wCharHeldItem,y
@lbl_C201A1:
	phy
	pea.w $01AF
	lda.l DATA8_C20277,x
	pha
	lda.l DATA8_C201B7,x
	pha
	rts
	sep #$10 ;XY->8
	ply
	sty.b wTemp00
	plp
	rtl

DATA8_C201B7:
	.db $36,$47,$53                       ;C201B7
	.db $6B                               ;C201BA
	.db $91,$99                           ;C201BB
	.db $91,$AF                           ;C201BD  
	.db $DA                               ;C201BF
	.db $DB                               ;C201C0
	.db $77                               ;C201C1
	.db $F5,$8D,$0B,$13,$23               ;C201C2  
	.db $2B,$2C                           ;C201C7
	.db $35,$91,$35,$90                   ;C201C9  
	.db $35,$4A                           ;C201CD
	.db $A7,$3D,$B7                       ;C201CF  
	.db $57                               ;C201D2
	.db $51                               ;C201D3  
	.db $C9                               ;C201D4
	.db $B7                               ;C201D5  
	.db $35                               ;C201D6
	.db $35                               ;C201D7  
	.db $35                               ;C201D8
	.db $98                               ;C201D9
	.db $91,$35                           ;C201DA
	.db $66                               ;C201DC  
	.db $35                               ;C201DD
	.db $16,$78,$4A                       ;C201DE  
	.db $23                               ;C201E1
	.db $35                               ;C201E2  
	.db $B7,$35                           ;C201E3
	.db $38,$80,$80,$80,$80,$80,$80,$80   ;C201E5
	.db $80,$80                           ;C201ED  
	.db $47,$47                           ;C201EF
	.db $47,$47                           ;C201F1  
	.db $B9,$B9,$DF,$DF                   ;C201F3
	.db $90                               ;C201F7  
	.db $53                               ;C201F8
	.db $7B                               ;C201F9
	.db $53,$CB,$53,$53,$38,$17,$53       ;C201FA
	.db $BF,$B8,$C0                       ;C20201  
	.db $DC,$FE,$FE,$0F,$B9,$03,$53,$A7   ;C20204
	.db $74                               ;C2020C  
	.db $65,$53                           ;C2020D
	.db $90                               ;C2020F  
	.db $A7,$53                           ;C20210
	.db $9E,$B3,$F1,$12,$74               ;C20212  
	.db $3F,$97                           ;C20217
	.db $90,$A7,$10,$10,$10,$D3,$D2,$D2   ;C20219  
	.db $D2,$D2,$D2                       ;C20221  
	.db $FE,$FE                           ;C20224
	.db $7B,$A7,$A7                       ;C20226
	.db $53,$53,$B9,$53,$FE,$53           ;C20229
	.db $FE                               ;C2022F  
	.db $FE                               ;C20230
	.db $FE                               ;C20231  
	.db $FE,$FE,$FE,$FE,$86,$53,$53,$53   ;C20232
	.db $53,$53,$53,$53                   ;C2023A
	.db $FE                               ;C2023E  
	.db $53,$53,$53,$53,$53,$FE,$FE       ;C2023F
	.db $53,$53,$53,$53,$FE,$FE,$10,$53,$FE,$FE,$A7,$FE,$FE,$10,$10,$10   ;C20246  
	.db $34,$22,$22,$10,$22               ;C20256
	.db $10,$90                           ;C2025B  
	.db $22                               ;C2025D
	.db $10                               ;C2025E  
	.db $10                               ;C2025F
	.db $10,$10,$10,$10,$10,$90,$90,$90   ;C20260  
	.db $90,$90                           ;C20268  
	.db $53                               ;C2026A
	.db $53                               ;C2026B  
	.db $53,$FE,$FE,$53,$53               ;C2026C
	.db $A7,$A7                           ;C20271  
	.db $FE                               ;C20273
	.db $10,$FE,$41                       ;C20274  

DATA8_C20277:
	.db $03,$04,$04                       ;C20277
	.db $04                               ;C2027A  
	.db $04,$04                           ;C2027B
	.db $04,$04                           ;C2027D  
	.db $04                               ;C2027F
	.db $04                               ;C20280  
	.db $04                               ;C20281
	.db $04,$05,$05,$05,$05               ;C20282  
	.db $05,$05                           ;C20287
	.db $05,$04,$05,$06                   ;C20289  
	.db $05,$04                           ;C2028D
	.db $05,$05,$05                       ;C2028F  
	.db $06                               ;C20292
	.db $05                               ;C20293  
	.db $05                               ;C20294
	.db $06                               ;C20295  
	.db $05                               ;C20296
	.db $05                               ;C20297  
	.db $05                               ;C20298
	.db $05                               ;C20299  
	.db $04,$05                           ;C2029A
	.db $05                               ;C2029C  
	.db $05                               ;C2029D
	.db $06,$06,$06                       ;C2029E  
	.db $06                               ;C202A1
	.db $05                               ;C202A2  
	.db $06,$05                           ;C202A3
	.db $06,$06,$06,$06,$06,$06,$06,$06   ;C202A5  
	.db $06,$06                           ;C202AD  
	.db $04,$04                           ;C202AF
	.db $04,$04                           ;C202B1  
	.db $07,$07,$0A,$0A                   ;C202B3
	.db $08                               ;C202B7
	.db $07                               ;C202B8
	.db $09                               ;C202B9
	.db $07,$07,$07,$07,$0B,$0B,$07       ;C202BA
	.db $06,$06,$06                       ;C202C1  
	.db $06,$06,$06,$0A,$07,$08,$08,$07   ;C202C4
	.db $08                               ;C202CC
	.db $07,$07                           ;C202CD
	.db $08                               ;C202CF
	.db $07,$07                           ;C202D0
	.db $08,$08,$08,$09,$08               ;C202D2
	.db $09,$09                           ;C202D7
	.db $08,$07,$07,$07,$07,$09,$0A,$0A   ;C202D9
	.db $0A,$0A,$0A                       ;C202E1
	.db $06,$06                           ;C202E4
	.db $09,$07,$07                       ;C202E6
	.db $07,$07,$07,$07,$06,$07           ;C202E9
	.db $06                               ;C202EF  
	.db $06                               ;C202F0
	.db $06                               ;C202F1  
	.db $06,$06,$06,$06,$07,$07,$07,$07   ;C202F2
	.db $07,$07,$07,$07                   ;C202FA
	.db $06                               ;C202FE  
	.db $07,$07,$07,$07,$07,$06,$06       ;C202FF
	.db $07,$07,$07,$07,$06,$06,$07,$07,$06,$06,$07,$06,$06,$07,$07,$07   ;C20306  
	.db $07,$07,$07,$07,$07               ;C20316
	.db $07,$08                           ;C2031B  
	.db $07                               ;C2031D
	.db $07                               ;C2031E  
	.db $07                               ;C2031F
	.db $07,$07,$07,$07,$07,$08,$08,$08   ;C20320  
	.db $08,$08                           ;C20328
	.db $07                               ;C2032A
	.db $07                               ;C2032B  
	.db $07,$06,$06,$07,$07               ;C2032C
	.db $07,$07                           ;C20331  
	.db $06                               ;C20333
	.db $07,$06,$07                       ;C20334

	sep #$30 ;AXY->8
	lda.b #$08
	sta.w wShirenStatus.strength
	sta.w wShirenStatus.maxStrength
	stz.w $897E
	stz.w wShirenStatus.gitan
	stz.w $8940
	stz.w $8941
	stz.w $8942
	lda.b #$9C
	sta.w $8976
	rep #$20 ;A->16
	lda.w #$03E8
	sta.w wShirenStatus.hunger
	sta.w wShirenStatus.maxHunger
	sep #$20 ;A->8
	stz.w $8949
	stz.w $894A
	stz.w $894B
	stz.w $894C
	stz.w $894D
	stz.w $894E
	lda.b #$01
	sta.w $8794
	sta.w $8948
	stz.w $8975
	stz.w $8983
	stz.w $8984
	stz.w $8985
	stz.w $8986
	stz.w $8987
	stz.w $8988
	stz.w $8989
	stz.w $898A
	stz.w $898B
	stz.w $898C
	stz.w $898D
	stz.w $898E
	stz.w $8998
	stz.w $899B
	stz.w $8997
	stz.w $89A6
	stz.w $89A7
	stz.w $89B2
	stz.w $89B3
	stz.w $89B4
	stz.w wShirenStatus.cantPickUpItems
	stz.w $89BA
	stz.w $89B7
	stz.w $89B8
	stz.w $89A2
	stz.w $89A3
	stz.w $89A4
	stz.w $89A5
	stz.w $8977
	stz.w $8978
	lda.b #$01
	sta.w wCharLevel,y
	sta.w wCharTrueLevel,y
	lda.b #$01
	sta.w $8947
	stz.w $897B
	stz.w $8980
	stz.w $899C
	stz.w $8974
	lda.b #$07
	sta.w $8999
	lda.b #$13
	sta.w $899A
	lda.b #$00
	sta.w wCharIsAwake,y
	sta.w wCharDoubleSpeedExtraAttacksNum,y
	lda.b #$FF
	sta.w $897C
	sta.w $898F
	sta.w $8996
	sta.w $89A0
	sta.w $89A1
	sta.w $89A8
	stz.w $8990
	stz.w $8991
	stz.w $8992
	stz.w $8993
	stz.w $8994
	stz.w $8995
	sta.w wShirenStatus.categoryShortcutItemIds
	sta.w wShirenStatus.categoryShortcutItemIds+1
	sta.w wShirenStatus.categoryShortcutItemIds+2
	sta.w wShirenStatus.categoryShortcutItemIds+3
	sta.w $897F
	ldx.b #$20
@lbl_C2043B:
	sta.w $894F,x
	dex
	bpl @lbl_C2043B
	stz.b wTemp00
	jsl.l func_C2342B
	rts
	sep #$30 ;AXY->8
	rts
	sep #$20 ;A->8
	lda.b #$01
	sta.w wCharIsSealed,y
	rts
	.db $60                               ;C20453
	sep #$20 ;A->8
	lda.b #$02
	sta.w wCharSpeed,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.w wCharLevel,y
	dec a
	bne @lbl_C2046B
	lda.b #$01
	sta.w wCharNumOfAttacks,y
@lbl_C2046B:
	rts
	.db $60,$A9,$02,$99,$31,$87,$A9,$01   ;C2046C
	.db $99,$81,$87,$60                   ;C20474  
	sep #$30 ;AXY->8
	phy
	call_savebank func_C3041A
	ply
	lda.b wTemp00
	sta.w wCharHeldItem,y
	lda.b #$04
	sta.w wCharIsAwake,y
	lda.b #$03
	sta.w wCharIsSealed,y
	rts
	sep #$20 ;A->8
	lda.b #$01
	sta.w wCharIsSealed,y
	rts
	sep #$30 ;AXY->8
	phy
	call_savebank func_C30630
	ply
	lda.b wTemp00
	sta.w wCharHeldItem,y
	lda.b #$03
	sta.w wCharIsSealed,y
	rts
	.db $60,$E2,$20,$A9,$01,$99,$81,$87,$60,$E2,$30,$A9,$2A,$85,$00,$5A   ;C204AF
	.db $8B,$22,$5D,$03,$C3,$AB,$7A,$A5,$00,$99,$59,$87,$A9,$00,$99,$31   ;C204BF
	.db $87,$A9,$01,$99,$81,$87,$A9,$02   ;C204CF  
	.db $99,$6D,$87,$60                   ;C204D7  
	rts
	.db $E2,$20,$A9,$01,$99,$81,$87,$60,$E2,$20,$A9,$01,$99,$81,$87,$A9   ;C204DC
	.db $02,$99,$31,$87,$A9,$02,$99,$6D,$87,$60,$E2,$20,$A9,$00,$99,$31   ;C204EC
	.db $87,$A9,$01,$99,$81,$87,$60,$60,$E2,$20,$A9,$01,$99,$81,$87,$60   ;C204FC  
	.db $E2,$20,$A9,$01,$99,$81,$87,$60,$E2,$20,$A9,$01,$99,$09,$87,$99   ;C2050C
	.db $81,$87,$A9,$00,$99,$31,$87,$60,$E2,$20,$A9,$02,$99,$31,$87,$60   ;C2051C  
	rts
	sep #$20 ;A->8
	lda.b #$01
	sta.w wCharIsSealed,y
	rts
	.db $60                               ;C20535
	sep #$20 ;A->8
	lda.b #$01
	sta.w wCharIsSealed,y
	rts
	.db $E2,$30,$A9,$01,$99,$81,$87,$B9,$19,$86,$C9,$03,$90,$05,$A9,$02   ;C2053E
	.db $99,$6D,$87,$60,$E2,$20,$A9,$01,$99,$D5,$88,$A9,$01,$99,$81,$87   ;C2054E  
	.db $60,$E2,$20,$A9,$02,$99,$6D,$87   ;C2055E
	.db $60                               ;C20566
	sep #$20 ;A->8
	lda.b #$01
	sta.w wCharIsSealed,y
	jsl.l Random
	lda.b wTemp00
	and.b #$3F
	cmp.b #$08
	bcs @lbl_C2058D
	.db $A9,$83,$85,$00,$5A,$8B,$22,$5D,$03,$C3,$AB,$7A,$A5,$00,$30,$03   ;C2057A
	.db $99,$59,$87                       ;C2058A  
@lbl_C2058D:
	rts
	.db $E2,$30,$A9,$01,$99,$81,$87,$99,$AD,$88,$60,$E2,$30,$B9,$19,$86   ;C2058E
	.db $3A,$99,$6D,$87,$A9,$01,$99,$81   ;C2059E
	.db $87,$60                           ;C205A6  
	sep #$30 ;AXY->8
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	sta.w wCharIgnoreShiren,y
	rts
	.db $E2,$30,$A9,$00,$99,$31,$87,$A9,$02,$99,$6D,$87,$A9,$01,$99,$CD   ;C205B8
	.db $86,$60                           ;C205C8  
	sep #$30 ;AXY->8
	lda.w wCharLevel,y
	cmp.b #$03
	bcs @lbl_C20603
	jsl.l Random
	lda.b wTemp00
	lsr a
	lda.w wCharLevel,y
	dec a
	rol a
	tax
	lda.l DATA8_C20611,x
	sta.b wTemp00
	phy
	call_savebank func_C3035D
	ply
@lbl_C205EE:
	lda.b wTemp00
	sta.w wCharHeldItem,y
	lda.b #$80
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$02
	sta.w wCharSpeed,y
	rts
@lbl_C20603:
	lda.b #$01
	sta.b wTemp00
	phy
	call_savebank func_C303E9
	ply
	bra @lbl_C205EE

DATA8_C20611:
	.db $AE,$AE                           ;C20611
	.db $AF,$AF,$B1,$B2,$E2,$30,$A9,$03,$99,$81,$87,$A9,$00,$99,$31,$87   ;C20613  
	.db $60                               ;C20623
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharIsSealed,y
	sta.w wCharNumOfAttacks,y
	lda.b #$02
	sta.w wCharSpeed,y
	lda.b #$04
	sta.w wCharIsAwake,y
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$02
	sta.w wCharSpeed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	rts
	sep #$30 ;AXY->8
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.w wCharLevel,y
	dec a
	bne @lbl_C2066F
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
@lbl_C2066F:
	lda.w wCharUnderfootTerrainType,y
	sta.b wTemp00
	jsl.l func_C366C4
	rts
	.db $E2,$30,$A9,$00,$99,$31,$87,$60,$E2,$30,$A9,$00,$99,$31,$87,$A9   ;C20679
	.db $01,$99,$81,$87,$99,$5D,$88,$60,$E2,$30,$A9,$01,$99,$81,$87,$22   ;C20689  
	.db $5F,$F6,$C3,$A5,$00,$29,$3F,$C9,$04,$B0,$13,$A9,$0A,$85,$00,$5A   ;C20699  
	.db $8B,$22,$5D,$03,$C3,$AB,$7A,$A5   ;C206A9
	.db $00,$30,$03,$99,$59,$87,$60       ;C206B1
	rts
	.db $E2,$30,$A9,$02,$99,$6D,$87,$60,$E2,$30,$A9,$01,$99,$35,$88,$99   ;C206B9
	.db $81,$87,$A9,$00,$99,$31,$87,$B9,$B5,$85,$99,$D1,$87,$B9,$C9,$85   ;C206C9  
	.db $99,$E5,$87,$60                   ;C206D9  
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharNPCFlags,y
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.w wCharXPos,y
	sta.w wCharTargetXPos,y
	sta.w wCharIsSealed,y
	lda.w wCharYPos,y
	sta.w wCharTargetYPos,y
	sta.w wCharEventFlags,y
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
	rts
	sep #$30 ;AXY->8
	lda.b #$09
	sta.w wCharNPCFlags,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	rts
	sep #$30 ;AXY->8
	lda.b #$09
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	rts
	sep #$30 ;AXY->8
	lda.b #$09
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	rts
	.db $E2,$30,$A9,$01,$99,$35,$88,$A9,$01,$99,$81,$87,$A9,$80,$99,$31   ;C20742
	.db $87,$60                           ;C20752  
	sep #$30 ;AXY->8
	lda.b #$05
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
	rts
	sep #$30 ;AXY->8
	lda.b #$05
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
	GetEventPushY Event1F
	sta.w wCharEventFlags,y
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
	GetEventPushY Event20
	sta.w wCharEventFlags,y
	rts
	sep #$30 ;AXY->8
	lda.b #$03
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
	rts
	sep #$30 ;AXY->8
	lda.b #$07
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	lda.b #$80
	sta.w wCharRemainingTigerTrapTurns,y
	rts
	sep #$30 ;AXY->8
	lda.b #$05
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	GetEventPushY Event_Gaibara
	cmp.b #$03
	bcc @lbl_C207F7
	.db $A9,$09,$99,$35,$88,$A9,$00,$99   ;C207E8
	.db $31,$87,$A9,$00,$99,$6D,$87       ;C207F0  
@lbl_C207F7:
	lda.b #$01
	sta.b wTemp02
	lda.b #Event87
	sta.b wTemp00
	jsl.l _SetEvent
	rts
	sep #$30 ;AXY->8
	lda.b #$08
	sta.w wCharNPCFlags,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$01
	sta.b wTemp02
	lda.b #Event_Naoki_88
	sta.b wTemp00
	phy
	call_savebank _SetEvent
	ply
	GetEventPushY Event_Naoki
	sta.w wCharEventFlags,y
	cmp.b #$03
	bne @lbl_C20843
	.db $3A,$85,$02,$A9,$09,$85,$00
	jsl.l _SetEvent
@lbl_C20843:
	rts

func_C20844:
	GetEventPushY Event_Naoki
	sta.w wCharEventFlags,y
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharNPCFlags,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	jsr.w func_C20844
	lda.w wCharEventFlags,y
	cmp.b #$02
	bne @lbl_C20874
;C2086F
	.db $A9,$03,$99,$35,$88
@lbl_C20874:
	rts
	.db $E2,$30,$A9,$01,$99,$35,$88,$A9,$40,$99,$31,$87,$20,$44,$08,$B9   ;C20875
	.db $71,$88,$C9,$02,$D0,$05,$A9,$03,$99,$35,$88,$60,$E2,$30,$A9,$07   ;C20885  
	.db $99,$35,$88,$A9,$40,$99,$31,$87,$80,$A5,$E2,$30,$A9,$09,$99,$35   ;C20895  
	.db $88,$A9,$01,$99,$81,$87,$99,$A5,$86,$A9,$00,$99,$31,$87,$60,$E2   ;C208A5
	.db $30,$A9,$01,$99,$81,$87,$A9,$00,$99,$31,$87,$A9,$80,$85,$00,$5A   ;C208B5  
	jsl.l _GetEvent
	.db $7A,$A5,$00,$C9,$02,$F0,$0B,$A9,$09,$99,$35,$88   ;C208C5  
	.db $A9,$00,$99,$6D,$87,$60,$A9,$01,$99,$35,$88,$A9,$01,$99,$71,$88   ;C208D5
	.db $A9,$80,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $60,$E2,$30,$A9   ;C208E5
	.db $09,$99,$35,$88,$A9,$01,$99,$81,$87,$A9,$00,$99,$31,$87,$A9,$01   ;C208F5
	.db $85,$00,$5A
	jsl.l _GetEvent
	.db $7A,$A5,$00,$99,$71,$88,$60,$E2,$30   ;C20905  
	.db $A9,$09,$99,$35,$88,$A9,$01,$99,$81,$87,$99,$A5,$86,$A9,$00,$99   ;C20915
	.db $31,$87,$A9,$02,$85,$00,$5A
	jsl.l _GetEvent
	.db $7A,$A5,$00,$99,$71   ;C20925  
	.db $88,$C9,$02,$D0,$05,$A9,$00,$99   ;C20935
	.db $A5,$86,$60                       ;C2093D  
	sep #$30 ;AXY->8
	lda.b #$08
	sta.w wCharNPCFlags,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	GetEventPushY Event_Surala
	sta.w wCharEventFlags,y
	cmp.b #$01
	bne @lbl_C2096F
	.db $3A,$85,$02,$A9,$0C,$85,$00
	jsl.l _SetEvent
@lbl_C2096F:
	lda.b #$01
	sta.b wTemp02
	lda.b #Event_Surala_89
	sta.b wTemp00
	jsl.l _SetEvent
	rts
	.db $E2,$30,$A9,$01,$99,$35,$88,$A9,$40,$99,$31,$87,$A9,$0C,$85,$00   ;C2097C
	.db $5A
	jsl.l _GetEvent
	.db $7A,$A5,$00   ;C2098C
	.db $99,$71,$88,$60                   ;C20994  
	sep #$30 ;AXY->8
	lda.b #$08
	sta.w wCharNPCFlags,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	GetEventPushY Event_Oryu
	sta.w wCharEventFlags,y
	cmp.b #$05
	bne @lbl_C209C7
	.db $3A,$85,$02,$A9,$03,$85,$00
	jsl.l _SetEvent
@lbl_C209C7:
	lda.b #$01
	sta.b wTemp02
	lda.b #Event83
	sta.b wTemp00
	jsl.l _SetEvent
	rts
	sep #$30 ;AXY->8
	lda.b #$0B
	sta.w wCharNPCFlags,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	GetEventPushY Event_Kechi
	sta.w wCharEventFlags,y
	cmp.b #$04
	bne @lbl_C20A03
	.db $3A,$85,$02,$A9,$05,$85,$00
	jsl.l _SetEvent
@lbl_C20A03:
	lda.b #$01
	sta.b wTemp02
	lda.b #Event_Kechi_85
	sta.b wTemp00
	jsl.l _SetEvent
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharNPCFlags,y
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	GetEventPushY Event_Pekeji
	sta.w wCharEventFlags,y
	cmp.b #$06
	bne @lbl_C20A48
	.db $3A,$85,$02,$A9,$06,$85,$00,$5A,$8B
	jsl.l _SetEvent
	.db $AB,$7A,$A9   ;C20A34
	.db $88,$99,$35,$88                   ;C20A44
@lbl_C20A48:
	lda.b #$01
	sta.b wTemp02
	lda.b #Event_Pekeji_86
	sta.b wTemp00
	phy
	call_savebank _SetEvent
	ply
	GetEventPushY Event_Pekeji2
	cmp.b #$02
	bcs @lbl_C20A69
	rts
@lbl_C20A69:
	cmp #$04                                ;C20A69
	bcs @lbl_C20AA0                         ;C20A6B
	lda $C29A32                             ;C20A6D
	sta $8605,y                             ;C20A71
	sta $85F1,y                             ;C20A74
	lda $C29AF2                             ;C20A77
	sta $867D,y                             ;C20A7B
	lda $C29BB2                             ;C20A7E
	sta $8691,y                             ;C20A82
	lda $C29D32                             ;C20A85
	sta $8641,y                             ;C20A89
	lda $C29DF2                             ;C20A8C
	sta $8655,y                             ;C20A90
	lda $C29EB2                             ;C20A93
	sta $8669,y                             ;C20A97
	lda #$02                                ;C20A9A
	sta $8781,y                             ;C20A9C
	rts                                     ;C20A9F
@lbl_C20AA0:
	lda $C29F72                             ;C20AA0
	sta $8605,y                             ;C20AA4
	sta $85F1,y                             ;C20AA7
	lda $C2A032                             ;C20AAA
	sta $867D,y                             ;C20AAE
	lda $C2A0F2                             ;C20AB1
	sta $8691,y                             ;C20AB5
	lda $C2A272                             ;C20AB8
	sta $8641,y                             ;C20ABC
	lda $C2A332                             ;C20ABF
	sta $8655,y                             ;C20AC3
	lda $C2A3F2                             ;C20AC6
	sta $8669,y                             ;C20ACA
	lda #$03                                ;C20ACD
	sta $8781,y                             ;C20ACF
	rts                                     ;C20AD2
	sep #$30 ;AXY->8
	lda.b #$03
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	rts
	sep #$30 ;AXY->8
	lda.b #$05
	sta.w wCharNPCFlags,y
	lda.b #$40
	sta.w wCharIsAwake,y
	GetEventPushY Event_Oryu
	sta.w wCharEventFlags,y
	cmp.b #$01
	beq @lbl_C20B08
	cmp.b #$02
	beq @lbl_C20B08
	cmp.b #$03
	beq @lbl_C20B08
	rts
@lbl_C20B08:
	lda.b #$01
	sta.w wCharIsSealed,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$03
	sta.w wCharNPCFlags,y
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.w wCharNPCFlags,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	GetEventPushY Event_Gaibara
	sta.w wCharEventFlags,y
	rts
	sep #$30 ;AXY->8
	lda.b #$05
	sta.w wCharNPCFlags,y
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharIsSealed,y
	rts

func_C20B4B:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
@lbl_C20B51:
	sep #$30 ;AXY->8
	lda.b wTemp01,s
	pha
	jsl.l GetCurrentDungeon
	pla
	ldx.b wTemp00
	cmp.l UNREACH_C20BBA,x
	bcc @lbl_C20B67
;C20B63  
	.db $BF,$BA,$0B,$C2
@lbl_C20B67:
	tay
	txa
	asl a
	tax
	rep #$30 ;AXY->16
	lda.l UNREACH_C20BA0,x
	tax
	sep #$20 ;A->8
@lbl_C20B74:
	inx
	lda.l FloorEnemySpawnTableRate,x
	bne @lbl_C20B74
	dey
	bne @lbl_C20B74
	jsl.l Random
	lda.b wTemp00
@lbl_C20B84:
	dex
	cmp.l FloorEnemySpawnTableRate,x
	bcc @lbl_C20B84
	lda.l FloorEnemySpawnTableType,x
	cmp.l $7E8996
	beq @lbl_C20B51
	sta.b wTemp00
	lda.l FloorEnemySpawnTableLevel,x
	sta.b wTemp01
	pla
	plp
	rtl

UNREACH_C20BA0:
	.db $6B,$0C,$00,$00,$DF,$00,$CD,$04,$DF,$08,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

UNREACH_C20BBA:
	.db $0A,$1E,$63,$63,$63,$20,$20,$20,$20,$20,$20,$20,$20


func_C20BC7:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b wTemp00
	phy
	lda.b wTemp02
	pha
	lda.b wTemp03
	pha
@lbl_C20BD5:
	lda.b $02,s
	sta.b wTemp00
	jsl.l func_C20B4B
	lda.b wTemp00
	cmp.b $01,s
	beq @lbl_C20BD5
	plx
	jmp.w func_C20BF9

func_C20BE7:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b wTemp00
	phy
	jsl.l GetCurrentFloor
	jsl.l func_C20B4B
	lda.b wTemp00
func_C20BF9:
	pha
	lda.b wTemp01
	pha
	jsl.l Random
	lda.b wTemp00
	and.b #$07
	sta.b wTemp02
	pla
	sta.b wTemp04
	pla
	ply
	sty.b wTemp00
	sta.b wTemp03
	jsl.l func_C20086
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$BF,$59,$87,$7E,$30,$0E,$85,$00,$DA,$22,$F4   ;C20C16
	.db $06,$C3,$FA,$A9,$FF,$9F,$59,$87,$7E,$86,$00,$DA,$22,$35,$0F,$C2   ;C20C26  
	.db $FA,$BF,$C9,$85,$7E,$EB,$BF,$B5,$85,$7E,$C2,$10,$AA,$86,$00,$DA   ;C20C36
	.db $22,$AF,$59,$C3,$FA,$A5,$01,$C9,$80,$D0,$40,$64,$00,$A9,$0C,$85   ;C20C46  
	.db $01,$DA,$22,$9F,$F6,$C3,$FA,$A5,$00,$C9,$0A,$D0,$0C,$DA,$22,$82   ;C20C56  
	.db $D2,$C3,$FA,$A5,$00,$30,$E4,$A9,$0A,$85,$01,$64,$02,$A9,$E7,$85   ;C20C66  
	.db $00,$DA,$22,$95,$02,$C3,$FA,$A5,$00,$C9,$FF,$F0,$0E,$85,$02,$86   ;C20C76
	.db $00,$22,$A2,$5B,$C3,$A9,$00,$8F,$B9,$89,$7E,$A9,$FF,$85,$00,$28   ;C20C86
	.db $6B,$C2,$20,$E2,$10,$A5,$00,$48,$A5,$02,$48,$22,$AF,$59,$C3,$A4   ;C20C96
	.db $02,$30,$1A,$84,$00,$22,$28,$65,$C3,$A4,$00,$F0,$10,$68,$85,$02   ;C20CA6
	.db $68,$85,$00,$A0,$0C,$84,$03,$22,$7D,$00,$C2,$28,$6B,$68,$85,$02   ;C20CB6
	.db $68,$85,$00,$A5,$00,$48,$64,$02,$22,$D1,$59,$C3,$E2,$20,$A5,$00   ;C20CC6
	.db $05,$02,$A2,$0C,$89,$07,$F0,$12,$A2,$18,$89,$1C,$F0,$0C,$A2,$24   ;C20CD6  
	.db $89,$70,$F0,$06,$A2,$30,$89,$C1,$D0,$36,$CA,$E2,$20,$BF,$2F,$0D   ;C20CE6
	.db $C2,$85,$02,$A9,$0C,$85,$03,$CA,$CA,$C2,$20,$A3,$01,$18,$7F,$2F   ;C20CF6
	.db $0D,$C2,$85,$00,$48,$DA,$22,$7D,$00,$C2,$FA,$68,$A4,$00,$30,$10   ;C20D06  
	.db $85,$00,$84,$02,$DA,$22,$7A,$5B,$C3,$FA,$BF,$2F,$0D,$C2,$D0,$CA   ;C20D16  
	.db $C2,$20,$68,$A0,$FF,$84,$00,$28,$6B,$00,$00,$01,$01,$00,$03,$00   ;C20D26
	.db $FF,$07,$01,$FF,$05,$00,$00,$03,$FF,$FF,$01,$00,$FF,$05,$FF,$FE   ;C20D36  
	.db $07,$00,$00,$05,$FF,$FF,$07,$00,$01,$03,$FF,$00,$01,$00,$00,$07   ;C20D46  
	.db $01,$00,$05,$00,$01,$01,$01,$01,$03,$C2,$20,$E2,$10,$A5,$00,$48   ;C20D56  
	.db $E2,$20,$A3,$01,$85,$00,$A3,$02,$3A,$83,$02,$85,$01,$22,$AF,$59   ;C20D66
	.db $C3,$A5,$00,$10,$06,$A5,$02,$89,$90,$F0,$E7,$A3,$02,$1A,$83,$02   ;C20D76  
	.db $A3,$01,$85,$00,$A3,$02,$85,$01,$22,$AF,$59,$C3,$A5,$00,$10,$33   ;C20D86  
	.db $A5,$02,$89,$90,$D0,$2D,$A3,$01,$85,$00,$A3,$02,$85,$01,$A9,$06   ;C20D96  
	.db $85,$02,$A9,$29,$85,$03,$22,$7D,$00,$C2,$A5,$00,$30,$15,$85,$02   ;C20DA6  
	.db $A3,$01,$85,$00,$A3,$02,$85,$01,$22,$7A,$5B,$C3,$A3,$02,$1A,$83   ;C20DB6  
	.db $02,$80,$BD,$68,$68,$A0,$FF,$84   ;C20DC6
	.db $00,$28,$6B                       ;C20DCE

func_C20DD1:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp02
	sta.l wCharXPos,x
	sta.b wTemp00
	lda.b wTemp03
	sta.l wCharYPos,x
	sta.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	sta.l wCharUnderfootTerrainType,x
	plp
	rtl

func_C20DF4:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b wTemp00
	jsl.l func_C359AF
	lda.b wTemp00
	bmi @lbl_C20E19
	.db $48,$84,$00,$22,$1A,$63,$C3,$A4,$00,$30,$0A,$A3,$01,$85,$00,$84   ;C20E03
	.db $02,$22,$51,$79,$C2,$68           ;C20E13
@lbl_C20E19:
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$A9,$FF,$9F,$81,$87,$7E,$BF,$59,$87,$7E,$30   ;C20E1B
	.db $0C,$85,$00,$A9,$FF,$9F,$59,$87   ;C20E2B  
	.db $7E,$22,$F4,$06,$C3,$28,$6B       ;C20E33  

func_C20E3A:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharIsSealed,x
	sta.b wTemp00
	plp
	rtl

func_C20E47:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharUnk885D,x
	beq @lbl_C20E5A
;C20E52
	.db $A9,$FF,$85,$00,$86,$01,$28,$6B
@lbl_C20E5A:
	lda.l wCharType,x
	cmp.b #$0B
	plp
	rtl
	.db $BF,$81,$87,$7E,$F0,$F8,$30,$0C,$BF,$31,$87,$7E,$D0,$06,$9F,$81   ;C20E62  
	.db $87,$7E,$80,$EA,$A9,$FF,$85,$00,$28,$6B,$08,$E2,$30,$A6,$00,$A5   ;C20E72  
	.db $01,$9F,$DD,$85,$7E,$28,$6B       ;C20E82  

func_C20E89:
	php
	sep #$30 ;AXY->8
	lda.l $7E8975
	and.b #$FE
	sta.l $7E8975
	lda.l $7E898D
	and.b #$FE
	sta.l $7E898D
	lda.b #$00
	sta.l $7E8758
	sta.l $7E894E
	sta.l $7E8990
	sta.l $7E8991
	sta.l $7E8992
	sta.l $7E8993
	sta.l $7E8994
	sta.l $7E8995
	sta.l $7E8997
	sta.l wShirenStatus.cantPickUpItems
	sta.l $7E89B7
	sta.l $7E89B8
	sta.l $7E894D
	sta.l $7E894C
	lda.b #$01
	sta.l $7E8794
	sta.l $7E8948
	sta.l $7E8947
	lda.b #$FF
	sta.l $7E897F
	sta.l $7E898F
	sta.l $7E89A8
	lda.l $7E899B
	bpl @lbl_C20F05
	.db $A9,$01,$8F,$9B,$89,$7E,$20,$F6   ;C20EFC
	.db $30                               ;C20F04  
@lbl_C20F05:
	ldx.b #$7E
@lbl_C20F07:
	stx.b wTemp00
	lda.b #$00
	sta.b wTemp01
	phx
	jsl.l func_C33A92
	plx
	dex
	bpl @lbl_C20F07
	lda.b #$13
	sta.l $7E899A
	lda.b #$12
@lbl_C20F1E:
	sta.b wTemp00
	pha
	jsl.l func_C20F35
	pla
	dec a
	bpl @lbl_C20F1E
	lda.b #$00
	sta.l $7E8980
	sta.l $7E899C
	plp
	rtl

func_C20F35:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wCharHP,y
	beq @lbl_C20F94
	lda.b #$00
	sta.w wCharHP,y
	lda.w wCharYPos,y
	xba
	lda.w wCharXPos,y
	rep #$20 ;A->16
	ldx.w wCharHeldItem,y
	bmi @lbl_C20F64
	stx.b wTemp00
	sta.b wTemp02
	pha
	phy
	call_savebank func_C330D1
	ply
	pla
@lbl_C20F64:
	sta.b wTemp00
	ldx.b #$80
	stx.b wTemp02
	jsl.l func_C35B7A
	cpy.b #$13
	beq @lbl_C20FA9
	sep #$20 ;A->8
	cpy.w $899A
	bne @lbl_C20F7E
	lda.b #$13
	sta.w $899A
@lbl_C20F7E:
	cpy.w $89A8
	bne @lbl_C20F88
	lda.b #$FF
	sta.w $89A8
@lbl_C20F88:
	lda.w wCharIsSealed,y
	beq @lbl_C20F94
	lda.w wCharType,y
	cmp.b #$17
	beq @lbl_C20F96
@lbl_C20F94:
	plp
	rtl
@lbl_C20F96:
	lda.w wCharXPos,y
	sta.w $8981
	lda.w wCharYPos,y
	sta.w $8982
	lda.b #$05
	sta.w $8980
	plp
	rtl
@lbl_C20FA9:
	sep #$20 ;A->8
	sty.b wTemp00
	lda.b #$05
	sta.b wTemp02
	jsl.l func_C62550
	lda.l $7E87BC
	cmp.b #$17
	bne @lbl_C20FC0
;C20FBD  
	.db $4C,$58,$10
@lbl_C20FC0:
	cmp.b #$1D
	bne @lbl_C20FE3
	.db $AF,$2C,$86,$7E,$AA,$BF,$06,$10,$C2,$85,$00,$22,$5D,$03,$C3,$AF   ;C20FC4  
	.db $C8,$85,$7E,$85,$02,$AF,$DC,$85   ;C20FD4
	.db $7E,$85,$03,$22,$D1,$30,$C3       ;C20FDC  
@lbl_C20FE3:
	lda.b #$2F
	sta.b wTemp00
	jsl.l func_C248B2
	lda.b wTemp00
	bpl @lbl_C2100A
	lda.l $7E897D
	cmp.b #$50
	bne @lbl_C21003
	.db $A9,$54,$85,$00,$A9,$07,$85,$01   ;C20FF7
	jsl.l DisplayMessage
@lbl_C21003:
	jsl.l func_C62456
;C21007
	.db $AE,$AF,$B2
@lbl_C2100A:
	sep #$30 ;AXY->8
	pha
	lda.l $7E897D
	cmp.b #$C0
	bne @lbl_C21019
;C21015  
	.db $22,$28,$24,$C6
@lbl_C21019:
	jsl.l func_C62405
	lda.b wTemp01,s
	sta.b wTemp03
	lda.b #$3A
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$13
	sta.b wTemp02
	jsl.l DisplayMessage
	jsl.l func_C62405
	pla
	sta.b wTemp00
	jsl.l func_C312DE
	lda.l $7E8618
	sta.l $7E8604
	lda.l $7E85C8
	sta.b wTemp00
	lda.l $7E85DC
	sta.b wTemp01
	lda.b #$13
	sta.b wTemp02
	jsl.l func_C35B7A
	plp
	rtl
	.db $E2,$30,$AF,$7D,$89,$7E,$C9,$C0,$D0,$04,$22,$28,$24,$C6,$22,$05   ;C21058
	.db $24,$C6,$A9,$12,$85,$00,$A9,$01,$85,$01,$A9,$13,$85,$02,$A9,$18   ;C21068  
	.db $85,$03
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$AF,$18,$86,$7E,$8F,$04   ;C21078  
	.db $86,$7E,$AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85,$7E,$85,$01,$A9,$13   ;C21088  
	.db $85,$02,$22,$7A,$5B,$C3,$A9,$18,$85,$00,$A9,$01,$85,$01,$22,$67   ;C21098  
	.db $41,$C2,$28,$6B                   ;C210A8  

; Returns the selected character's X/Y position, direction, type, and appearance
; in wTemp00-wTemp04.
GetCharacterMapInfo:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	stz.b wTemp01
	ldx.b wTemp00
	lda.w wCharXPos,x
	sta.b wTemp00
	lda.w wCharYPos,x
	sta.b wTemp01
	lda.w wCharDir,x
	sta.b wTemp02
	lda.w wCharType,x
	sta.b wTemp03
	lda.w wCharAppearance,x
	sta.b wTemp04
	plp
	rtl

func_C210D4:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	stz.b wTemp01
	ldx.b wTemp00
	lda.l wCharHP,x
	sta.b wTemp00
	beq @lbl_C210FD
	lda.l wCharAppearance,x
	sta.b wTemp01
	lda.l wCharDir,x
	sta.b wTemp03
	lda.l wCharXPos,x
	sta.b wTemp04
	lda.l wCharYPos,x
	sta.b wTemp05
@lbl_C210FD:
	plp
	rtl

func_C210FF:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	stz.b wTemp01
	ldx.b wTemp00
	lda.l wCharAppearance,x
	sta.b wTemp01
	lda.l wCharDir,x
	sta.b wTemp03
	lda.l wCharXPos,x
	sta.b wTemp04
	lda.l wCharYPos,x
	sta.b wTemp05
	lda.l wCharType,x
	sta.b wTemp06
	plp
	rtl

func_C21128:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	stz.b wTemp01
	ldx.b wTemp00
	lda.w wCharHP,x
	sta.b wTemp00
	lda.w wCharMaxHP,x
	sta.b wTemp01
	lda.w wCharExpByte0,x
	sta.b wTemp02
	lda.w wCharExpByte1,x
	sta.b wTemp03
	lda.w wCharExpByte2,x
	sta.b wTemp04
	lda.w wCharLevel,x
	sta.b wTemp05
	lda.w wCharDefense,x
	sta.b wTemp06
	lda.w wCharAttack,x
	cpx.w #$0013
	bne @lbl_C21163
	lda.w $8974
@lbl_C21163:
	sta.b wTemp07
	plp
	rtl

func_C21167:
	php
	rep #$20 ;A->16
	lda.l wShirenStatus.strength
	sta.b wTemp00
	lda.l wShirenStatus.gitan
	sta.b wTemp02
	lda.l $7E8941
	sta.b wTemp04
	lda.l wShirenStatus.hunger
	sta.b wTemp06
	plp
	rtl

func_C21184:
	php
	sep #$20 ;A->8
	lda.l $7E89B4
	sta.b wTemp00
	lda.l wShirenStatus.cantPickUpItems
	sta.b wTemp01
	plp
	rtl
	.db $08,$E2,$20,$C2,$10,$AF,$B4,$89,$7E,$F0,$0F,$A9,$00,$8F,$B4,$89   ;C21195
	.db $7E,$A2,$31,$00,$86,$00
	jsl.l DisplayMessage
	.db $AF,$B6,$89,$7E,$F0,$0F   ;C211A5  
	.db $A9,$00,$8F,$B6,$89,$7E,$A2,$06,$01,$86,$00
	jsl.l DisplayMessage
	.db $28   ;C211B5
	.db $6B                               ;C211C5

func_C211C6:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
@lbl_C211CF:
	lda.w wCharHP,y
	bne @lbl_C211DB
@lbl_C211D4:
	dey
	bpl @lbl_C211CF
	sty.b wTemp00
	plp
	rtl
@lbl_C211DB:
	lda.w wCharAttackTarget,y
	bmi @lbl_C211D4
	sty.b wTemp00
	plp
	rtl

func_C211E4:
	php
	sep #$30 ;AXY->8
	lda.l $7E897F
	bmi @lbl_C21216
	tax
	lda.l wCharNPCFlags,x
	bne @lbl_C21216
	lda.l wCharHP,x
	beq @lbl_C21216
	bankswitch 0x7E
	phx
	txy
	jsr.w func_C25CE6
	plx
	lda.l wCharAttackTarget,x
	bmi @lbl_C21216
	stx.b wTemp00
	jsl.l func_C2121A
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C21216:
	stz.b wTemp00
	plp
	rtl

func_C2121A:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b wTemp00
	lda.w wCharHP,x
	beq @lbl_C2126D
	lda.w wCharAttackTarget,x
	bmi @lbl_C2126D
	sta.b wTemp01
	lda.b #$FF
	sta.w wCharAttackTarget,x
	lda.b wTemp01
	and.b #$3F
	tay
	lda.w wCharHP,y
	beq @lbl_C2126D
	lda.w wCharType,x
	sta.w $897D
	lda.w wCharLevel,x
	sta.w $89BB
	lda.w wCharType,y
	sta.w wCharLastAttackedMonsterType,x
	lda.w wCharLevel,y
	sta.w wCharLastAttackedMonsterLevel,x
	lda.l wCharRemainingConfusedTurns,x
	ora.l wCharRemainingBlindlessTurns,x
	ora.l wCharIsKigny,x
	bne @lbl_C21269
	lda.w wCharIsSealed,x
	bne @lbl_C2126F
@lbl_C21269:
	jsl.l PrintAttackEffect
@lbl_C2126D:
	plp
	rtl
@lbl_C2126F:
	tdc
	lda.w wCharType,x
	rep #$30 ;AXY->16
	asl a
	tax
	lda.b wTemp00
	pha
	lda.l DATA8_C21295,x
	phk
	pea.w $1283
	pha
	rts
	rep #$20 ;A->16
	sep #$10 ;XY->8
	pla
	ldx.b wTemp00
	beq @lbl_C21293
	sta.b wTemp00
	jsl.l PrintAttackEffect
@lbl_C21293:
	plp
	rtl

DATA8_C21295:
	.db $14,$14                           ;C21295
	.db $14,$14                           ;C21297  
	.db $14,$14                           ;C21299
	.db $14,$14                           ;C2129B  
	.db $07,$1C                           ;C2129D
	.db $0C,$21,$BC,$1D,$C7,$1F,$14,$14   ;C2129F  
	.db $6B,$20                           ;C212A7
	.db $A3,$21                           ;C212A9
	.db $6C,$22,$14,$14,$CE,$22,$AA,$15   ;C212AB  
	.db $14,$14,$14,$14                   ;C212B3  
	.db $10,$23                           ;C212B7
	.db $73,$24,$62,$1C,$D2,$24,$AA,$15   ;C212B9  
	.db $EF,$17                           ;C212C1
	.db $14,$14,$06,$16,$14,$14,$14,$14   ;C212C3  
	.db $14,$14                           ;C212CB
	.db $14,$14,$42,$20,$14,$14           ;C212CD  
	.db $83,$1A                           ;C212D3
	.db $86,$18,$14,$14,$B7,$1E           ;C212D5  
	.db $FC,$1C,$C8,$19                   ;C212DB
	.db $5F,$1E                           ;C212DF  
	.db $00,$24                           ;C212E1
	.db $2B,$19,$14,$14,$14,$14           ;C212E3
	.db $3C,$17                           ;C212E9
	.db $93,$17,$14,$14                   ;C212EB  
	.db $79,$16                           ;C212EF
	.db $07,$1C,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C212F1  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21301  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21311  
	.db $14,$14,$D6,$25                   ;C21321  
	.db $EF,$25                           ;C21325
	.db $14,$14,$14,$14,$14,$14,$14,$14   ;C21327  
	.db $14,$14,$14,$14,$14,$14           ;C2132F  
	.db $25,$26                           ;C21335
	.db $14,$14,$A8,$26,$CD,$27,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21337  
	.db $14,$14,$14,$14,$14,$14,$BC,$25,$14,$14,$14,$14,$14,$14,$BE,$27   ;C21347  
	.db $DC,$27,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$08,$26,$14,$14   ;C21357  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21367  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21377  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21387  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C21397  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C213A7  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C213B7  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C213C7  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C213D7  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C213E7  
	.db $14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14,$14   ;C213F7  
	.db $14,$14,$14,$14,$14,$14,$14,$14   ;C21407  
	.db $14,$14,$14,$14,$B7,$26           ;C2140F  

.include "code/ai/attack_ai.asm"

func_C2286F:
	php
	sep #$30 ;AXY->8
	lda.b #$70
	sta.b wTemp02
	jmp.w func_C2287C

func_C22879:
	php
	sep #$30 ;AXY->8

func_C2287C:
	ldx.b wTemp00
	ldy.b wTemp01
	lda.b #$00
	sta.l wCharIsAwake,x
	lda.b #$01
	sta.l wCharAttackedByShiren,x
	lda.l $7E899A
	cmp.b #$13
	bne @lbl_C228AE
	lda.l $7E871C
	ora.l wCharIgnoreShiren,x
	bne @lbl_C228AE
	lda.l $7E85C8
	sta.l wCharTargetXPos,x
	lda.l $7E85DC
	sta.l wCharTargetYPos,x
@lbl_C228AE:
	lda.b wTemp02
	pha
	jsl.l Random
	pla
	sta.b wTemp01
	lda.b wTemp00
	and.b #$7F
	cmp.b wTemp01
	bcs @lbl_C228C6
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C228C6:
	stx.b wTemp00
	lda.b #$08
	sta.b wTemp02
	jsl.l func_C62550
	stz.b wTemp00
	plp
	rtl
	.db $08,$E2,$20,$A5,$00,$8F,$99,$89   ;C228D4
	.db $7E,$28,$6B                       ;C228DC  

func_C228DF:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	ldx.b wTemp01
	lda.b wTemp02
	jmp.w func_C22A25

func_C228EF:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	ldx.b wTemp01
	lda.b wTemp02
	pha
	jsl.l Random
	lda.b wTemp00
	and.b #$1F
	clc
	adc.b #$70
	sta.b wTemp00
	pla
	sta.b wTemp01
	jsl.l func_C3E3CB
	rep #$20 ;A->16
	phx
	ldx.w wCharDefense,y
	bra @lbl_C22928
@lbl_C22919:
	lda.b wTemp00
	lsr a
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF
	sec
	adc.b wTemp00
	sta.b wTemp00
	dex
@lbl_C22928:
	bne @lbl_C22919
	plx
	lda.b wTemp00
	asl a
	bcc @lbl_C22933
;C22930
	.db $A9,$00,$FF
@lbl_C22933:
	sep #$20 ;A->8
	xba
	pha
	cpx.b #$13
	bne @lbl_C22958
	lda.l $7E89BA
	beq @lbl_C22958
	lda.w wCharType,y
	tax
	lda.l UNREACH_C284C8,x
	ldx.b #$13
	and.l $7E89A2
	beq @lbl_C22958
;C22951
	.db $68,$0A,$90,$02,$A9,$FF,$48
@lbl_C22958:
	lda.w $8988
	beq @lbl_C22969
	.db $9C,$88,$89,$A3,$01,$0A,$90,$02   ;C2295D  
	.db $A9,$FF,$83,$01                   ;C22965
@lbl_C22969:
	lda.w wCharAppearance,y
	cmp.b #$1E
	bne @lbl_C22985
	.db $B9,$DD,$85,$38,$FD,$DD,$85,$38,$E9,$03,$29,$07,$C9,$03,$90,$05   ;C22970  
	.db $B9,$F1,$85,$83,$01               ;C22980  
@lbl_C22985:
	lda.w wCharType,y
	cmp.b #$18
	bne @lbl_C229A6
	.db $E0,$13,$D0,$0E,$AF,$BA,$89,$7E,$F0,$08,$AF,$A2,$89,$7E,$89,$02   ;C2298C
	.db $D0,$08,$A3,$01,$F0,$04,$A9,$01   ;C2299C  
	.db $83,$01                           ;C229A4  
@lbl_C229A6:
	pla
	pha
	phx
	phy
	jsl.l func_C22A24
	plx
	ply
	cpx.b #$13
	bne @lbl_C22A21
	lda.w $899B
	bne @lbl_C229C8
	lda.w $8971
	bmi @lbl_C229C8
	sta.b wTemp00
	phy
	call_savebank func_C32FC0
	ply
@lbl_C229C8:
	lda.w $89A4
	bit.b #$20
	beq @lbl_C22A21
	.db $A3,$01,$F0,$4E,$B9,$F1,$85,$F0,$49,$84,$00,$5A,$8B,$22,$F8,$77   ;C229CF  
	.db $C2,$AB,$7A,$A5,$00,$C9,$01,$D0,$39,$5A,$8B,$22,$05,$24,$C6,$AB   ;C229DF
	.db $7A,$A9,$2D,$85,$00,$64,$01,$AD,$71,$89,$85,$02,$84,$03,$5A,$8B   ;C229EF
	jsl.l DisplayMessage
	.db $AB,$7A,$68,$85,$00,$A9,$55,$85,$01,$22,$CB,$E3   ;C229FF  
	.db $C3,$06,$00,$A5,$01,$69,$00,$D0,$01,$1A,$A2,$13,$22,$24,$2A,$C2   ;C22A0F  
	.db $28,$6B                           ;C22A1F
@lbl_C22A21:
	pla
	plp
	rtl

func_C22A24:
	php

func_C22A25:
	sep #$30 ;AXY->8
	pha
	cpy.b #$13
	bne @lbl_C22A35
	lda.w $89A6
	beq @lbl_C22A35
;C22A31
	.db $A9,$00,$83,$01
@lbl_C22A35:
	lda.w wCharOverrideState,y
	beq @lbl_C22A45
	.db $A9,$00,$99,$49,$88,$B9,$A1,$85   ;C22A3A
	.db $99,$A9,$87                       ;C22A42  
@lbl_C22A45:
	lda.l $7E8989
	beq @lbl_C22A5C
	.db $E0,$13,$F0,$04,$C0,$13,$D0,$09,$A3,$01,$0A,$90,$02,$A9,$FF,$83   ;C22A4B
	.db $01                               ;C22A5B  
@lbl_C22A5C:
	cpx.b #$13
	bne @lbl_C22A87
	cpy.b #$13
	beq @lbl_C22A87
	lda.l $7E8997
	beq @lbl_C22A87
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp01
	beq @lbl_C22A7C
;C22A78
	.db $A9,$FF,$85,$00
@lbl_C22A7C:
	lda.b wTemp00
	lsr a
	adc.b wTemp01,s
	bcc @lbl_C22A85
;C22A83
	.db $A9,$FF
@lbl_C22A85:
	sta.b wTemp01,s
@lbl_C22A87:
	lda.b #$00
	sta.w wCharIsAwake,y
	lda.b #$01
	sta.w wCharAttackedByShiren,y
	sty.b wTemp00
	lda.b #$40
	sta.b wTemp02
	phx
	phy
	call_savebank func_C62550
	ply
	plx
	rep #$20 ;A->16
	lda.b wTemp01,s
	sta.b wTemp02
	lda.w #$0009
	cpy.b #$13
	bne @lbl_C22AB1
	lda.w #$0008
@lbl_C22AB1:
	sta.b wTemp00
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	sep #$20 ;A->8
	lda.b wTemp01,s
	rep #$20 ;A->16
	and.w #$00FF
	eor.w #$FFFF
	inc a
	sta.b wTemp02
	sep #$20 ;A->8
	sty.b wTemp00
	phx
	phy
	call_savebank func_C23209
	ply
	plx
	cpy.b #$13
	bne @lbl_C22B1D
	lda.w $89A8
	bmi @lbl_C22B1D
	cmp.b #$13
	beq @lbl_C22B1D
	phx
	phy
	call_savebank func_C62405
	ply
	plx
	lda.w $89A8
	sta.b wTemp02
	lda.b #$FF
	sta.b wTemp00
	lda.b #$00
	sta.b wTemp01
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.w $89A8
	sta.b wTemp00
	sty.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp02
	phx
	phy
	call_savebank func_C228DF
	ply
	plx
@lbl_C22B1D:
	pla
	lda.w wCharHP,y
	beq @lbl_C22B2D
	sty.b wTemp00
	stx.b wTemp01
	jsl.l func_C22C1C
	plp
	rtl
@lbl_C22B2D:
	sty.b wTemp00
	lda.b #$05
	sta.b wTemp02
	phx
	phy
	call_savebank func_C62565
	ply
	plx
	lda.b #$3D
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.w wCharExpByte0,y
	sta.b wTemp02
	lda.w wCharExpByte1,y
	sta.b wTemp03
	lda.w wCharExpByte2,y
	sta.b wTemp04
	stx.b wTemp00
	phx
	phy
	jsl.l func_C234DF
	ply
	plx
	cpx.b #$13
	bne @lbl_C22BC8
	lda.l $7E89BA
	beq @lbl_C22B82
	lda.l $7E89A2
	bit.b #$10
	beq @lbl_C22B82
;C22B7A  
	.db $84,$00,$5A,$22,$D4,$2B,$C2,$7A
@lbl_C22B82:
	lda.l $7E87BC
	cmp.b #$23
	bne @lbl_C22BC8
	.db $AF,$2C,$86,$7E,$3A,$D0,$0A,$22,$5F,$F6,$C3,$A5,$00,$C9,$40,$B0   ;C22B8A  
	.db $2D,$A9,$AE,$85,$00,$AF,$2C,$86,$7E,$C9,$03,$D0,$04,$A9,$AF,$85   ;C22B9A  
	.db $00,$5A,$22,$5D,$03,$C3,$7A,$A5,$00,$30,$13,$BB,$BF,$B5,$85,$7E   ;C22BAA
	.db $85,$02,$BF,$C9,$85,$7E,$85,$03   ;C22BBA  
	.db $5A,$22,$D1,$30,$C3,$7A           ;C22BC2
@lbl_C22BC8:
	sty.b wTemp00
	ldx.b #$13
	stx.b wTemp01
	jsl.l func_C22C1C
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$BF,$A1,$85,$7E,$C9,$3C,$B0,$39,$C9,$28,$F0   ;C22BD4
	.db $35,$22,$5F,$F6,$C3,$A5,$00,$30,$2A,$A9,$E0,$85,$00,$BF,$A1,$85   ;C22BE4  
	.db $7E,$85,$01,$BF,$19,$86,$7E,$85,$02,$DA,$22,$95,$02,$C3,$FA,$A5   ;C22BF4  
	.db $00,$30,$10,$BF,$B5,$85,$7E,$85,$02,$BF,$C9,$85,$7E,$85,$03,$22   ;C22C04
	.db $D1,$30,$C3,$20,$56,$50,$28,$6B   ;C22C14  

func_C22C1C:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	bne @lbl_C22C3F
	lda.l $7E87BC
	cmp.b #$1D
	bne @lbl_C22C3F
	.db $AF,$2C,$86,$7E,$C9,$02,$D0,$0A,$A9,$13,$85,$00,$22,$90,$43,$C2   ;C22C2D  
	.db $28,$6B                           ;C22C3D
@lbl_C22C3F:
	lda.l wCharIsSealed,x
	beq @lbl_C22C9A
	lda.l wCharHP,x
	beq @lbl_C22C9A
	lda.l wCharType,x
	cmp.b #$4C
	beq @lbl_C22C57
	cmp.b #$4D
	bne @lbl_C22C6C
@lbl_C22C57:
	lda.b wTemp01
	cmp.b #$13
	bne @lbl_C22C69
	lda.b #$00
	sta.l wCharNPCFlags,x
	sta.l wCharIsSealed,x
	plp
	rtl
@lbl_C22C69:
	.db $4C,$9C,$2C
@lbl_C22C6C:
	cmp.b #$0A
	beq @lbl_C22C74
	cmp.b #$09
	bne @lbl_C22C7A
@lbl_C22C74:
	jsl.l func_C22CF1
	plp
	rtl
@lbl_C22C7A:
	cmp.b #$18
	bne @lbl_C22C90
	.db $22,$5F,$F6,$C3,$A5,$00,$C9,$20,$B0,$06,$86,$00,$22,$90,$43,$C2   ;C22C7E  
	.db $28,$6B                           ;C22C8E
@lbl_C22C90:
	cmp.b #$19
	bne @lbl_C22C9A
;C22C94  
	.db $22,$92,$69,$C2,$28,$6B
@lbl_C22C9A:
	plp
	rtl
	.db $E2,$30,$A9,$00,$9F,$95,$87,$7E,$BF,$81,$87,$7E,$9F,$D1,$87,$7E   ;C22C9C
	.db $BF,$71,$88,$7E,$9F,$E5,$87,$7E,$A4,$01,$DA,$5A,$22,$B3,$77,$C2   ;C22CAC  
	.db $7A,$FA,$A5,$00,$C9,$01,$D0,$0E,$A5,$01,$9F,$DD,$85,$7E,$86,$00   ;C22CBC
	.db $84,$01,$22,$15,$14,$C2,$28,$6B,$08,$E2,$30,$A6,$00,$BF,$F1,$85   ;C22CCC  
	.db $7E,$F0,$10,$22,$5F,$F6,$C3,$A5,$00,$89,$03,$D0,$06,$86,$00,$22   ;C22CDC  
	.db $6C,$81,$C2,$28,$6B               ;C22CEC  

func_C22CF1:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharLevel,x
	dec a
	beq @lbl_C22D01
;C22CFD  
	.db $22,$D4,$2C,$C2
@lbl_C22D01:
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$BF,$F1,$85,$7E,$F0,$0A,$C9,$0A,$B0,$06,$64   ;C22D03
	.db $01,$22,$15,$82,$C2,$28,$6B       ;C22D13  

func_C22D1A:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	lda.b wTemp01
	pha
	lda.b wTemp02
	sta.b wTemp00
	jsl.l func_C23456
	lda.b wTemp00
	sta.b wTemp02
	pla
	sta.b wTemp01
	pla
	sta.b wTemp00
	jsl.l func_C228EF
	plp
	rtl

func_C22D3B:
	jsr.w func_C22D42
	jsr.w func_C22DEF
	rtl

func_C22D42:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.w $8995
	beq @lbl_C22D50
	plp
	rts
@lbl_C22D50:
	lda.w $898F
	cmp.w $87D0
	beq @lbl_C22D6E
	cmp.b #$0A
	bcs @lbl_C22D70
	sta.b wTemp00
	lda.w $87D0
	sta.w $898F
	jsl.l func_C366B7
	lda.b wTemp00
	bit.b #$20
	bne @lbl_C22D78
@lbl_C22D6E:
	plp
	rts
@lbl_C22D70:
	lda.w $87D0
	sta.w $898F
	plp
	rts
@lbl_C22D78:
	lda.l $7E8990
	beq @lbl_C22DE1
	ldx.b #$7E
@lbl_C22D80:
	stx.b wTemp00
	lda.b #$00
	sta.b wTemp01
	phx
	jsl.l func_C33A92
	plx
	dex
	bpl @lbl_C22D80
	lda.b #$00
	sta.l $7E8990
	sta.l $7E8991
	sta.l $7E8992
	sta.l $7E8993
	sta.l $7E8994
	lda.l $7E871C
	bne @lbl_C22DE1
	lda.b #$01
	sta.l $7E8995
	ldx.b #$0A
@lbl_C22DB3:
	lda.l $7E8978
	clc
	adc.b #$10
	sta.l $7E8978
	phx
	jsl.l func_C23173
	plx
	dex
	bne @lbl_C22DB3
	lda.b #$24
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l func_C62AEE
	lda.b #$78
	sta.b wTemp00
	lda.b #$06
	sta.b wTemp01
	jsl.l DisplayMessage
	plp
	rts
@lbl_C22DE1:
	stz.b wTemp00
	lda.b #$02
	sta.b wTemp01
	call_savebank func_C62AEE
	plp
	rts

func_C22DEF:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.w $87D0
	cmp.b #$0A
	bcs @lbl_C22E2B
	sta.b wTemp00
	jsl.l func_C366B7
	lda.b wTemp00
	bit.b #$01
	beq @lbl_C22E2B
	ldx.b #$12
@lbl_C22E0B:
	lda.w wCharHP,x
	beq @lbl_C22E1F
	lda.w wCharType,x
	cmp.b #$1B
	bne @lbl_C22E1F
	lda.w wCharUnderfootTerrainType,x
	cmp.w $87D0
	beq @lbl_C22E2B
@lbl_C22E1F:
	dex
	bpl @lbl_C22E0B
	lda.w $87D0
	sta.b wTemp00
	jsl.l func_C366D5
@lbl_C22E2B:
	plp
	rts

func_C22E2D:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.w $899C
	beq @lbl_C22E55
	.db $C9,$40,$D0,$0A,$22,$5F,$F6,$C3,$A5,$00,$29,$1F,$80,$04,$3A,$8D   ;C22E39
	.db $9C,$89,$D0,$08,$A9,$FF,$8D,$9C   ;C22E49  
	.db $89,$9C,$77,$89                   ;C22E51
@lbl_C22E55:
	lda.w $899B
	bne @lbl_C22E63
	lda.w $87D0
	asl a
	and.w $87D0
	bmi @lbl_C22EA0
@lbl_C22E63:
	lda.l wIsInTown
	beq @lbl_C22EE8
	lda.w wShirenStatus.hunger
	ora.w $8944
	beq @lbl_C22EBD
	lda.w $8985
	bne @lbl_C22ED8
	lda.w $89B4
	bne @lbl_C22E9E
	lda.w $8618
	clc
	adc.w $8976
	bcc @lbl_C22E9B
@lbl_C22E84:
	pha
	lda.b #$13
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp02
	stz.b wTemp03
	call_savebank func_C23209
	pla
	sec
	sbc.b #$96
	bcs @lbl_C22E84
@lbl_C22E9B:
	sta.w $8976
@lbl_C22E9E:
	bra @lbl_C22EE8
@lbl_C22EA0:
	.db $A9,$C8,$8F,$7D,$89,$7E,$A9,$13,$85,$00,$A9,$F6,$85,$02,$A9,$FF   ;C22EA0
	.db $85,$03,$8B,$22,$09,$32,$C2,$AB   ;C22EB0  
	.db $9C,$77,$89,$80,$2B               ;C22EB8  
@lbl_C22EBD:
	.db $A9,$C0,$8F,$7D,$89,$7E,$A9,$13,$85,$00,$A9,$FF,$85,$02,$85,$03   ;C22EBD
	.db $8B,$22,$09,$32,$C2,$AB,$9C,$77   ;C22ECD
	.db $89,$80,$10                       ;C22ED5
@lbl_C22ED8:
	.db $A9,$13,$85,$00,$A9,$05,$85,$02,$64,$03,$8B,$22,$09,$32,$C2,$AB
@lbl_C22EE8:
	lda.w $89B4
	beq @lbl_C22F12
	.db $3A,$8D,$B4,$89,$A9,$00,$38,$ED,$B5,$89,$F0,$19,$85,$02,$A9,$FF   ;C22EED
	.db $85,$03,$A9,$13,$85,$00,$A9,$DD,$8F,$7D,$89,$7E,$8B,$22,$09,$32   ;C22EFD  
	.db $C2,$AB,$9C,$77,$89               ;C22F0D
@lbl_C22F12:
	lda.w $86B8
	beq @lbl_C22F38
	dec a
	sta.w $86B8
	bne @lbl_C22F38
	stz.w $8977
	lda.b #$13
	sta.b wTemp00
	stz.b wTemp01
	call_savebank func_C240A7
	lda.b #$6E
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C22F38:
	lda.w $86CC
	beq @lbl_C22F4F
	dec a
	sta.w $86CC
	bne @lbl_C22F4F
	lda.b #$67
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C22F4F:
	lda.w $86E0
	beq @lbl_C22F69
	dec a
	sta.w $86E0
	bne @lbl_C22F69
	stz.w $8977
	lda.b #$6C
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C22F69:
	lda.w $8758
	beq @lbl_C22F80
	dec a
	sta.w $8758
	bne @lbl_C22F80
	lda.b #$6F
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C22F80:
	lda.w $8708
	beq @lbl_C22F9F
	dec a
	sta.w $8708
	bne @lbl_C22F9F
	lda.b #$01
	sta.w $8780
	stz.w $8977
	lda.b #$5D
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C22F9F:
	lda.w $89A6
	beq @lbl_C22FB9
;C22FA4
	.db $3A,$8D,$A6,$89,$D0,$0F,$9C,$77,$89,$A9,$F6,$85,$00,$64,$01,$8B
	jsl.l DisplayMessage
	.db $AB               ;C22FB4  
@lbl_C22FB9:
	lda.w $8998
	beq @lbl_C22FD3
	dec a
	sta.w $8998
	stz.w $8977
	bne @lbl_C22FD3
	lda.b #$5D
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C22FD3:
	lda.w $885C
	beq @lbl_C22FE3
	dec a
	sta.w $885C
	bne @lbl_C22FE3
	lda.b #$00
	sta.w $87BC
@lbl_C22FE3:
	lda.w $88C0
	beq @lbl_C22FFC
	.db $3A,$8D,$C0,$88,$D0,$0E,$A9,$01,$85,$00,$A9,$01,$85,$01,$8B
	jsl.l DisplayMessage
	.db $AB                   ;C22FF8  
@lbl_C22FFC:
	lda.w $8744
	beq @lbl_C2301B
	lda.w $89B2
	dec a
	sta.w $89B2
	bne @lbl_C2301B
	.db $9C,$44,$87,$A9,$01,$85,$00,$A9,$01,$85,$01,$8B
	jsl.l DisplayMessage
	.db $AB                               ;C2301A
@lbl_C2301B:
	jsr.w func_C230F6
	inc.w $8978
	lda.l wIsInTown
	beq @lbl_C23054
	lda.w $8978
	and.w $89A4
	and.b #$01
	bne @lbl_C23054
	lda.b #$FF
	xba
	lda.w $8947
	eor.b #$FF
	rep #$20 ;A->16
	inc a
	sta.b wTemp00
	sep #$20 ;A->8
	lda.w $8985
	beq @lbl_C23047
;C23045  
	.db $06,$00
@lbl_C23047:
	lda.w $89A4
	bit.b #$02
	beq @lbl_C23050
;C2304E  
	.db $06,$00
@lbl_C23050:
	jsl.l func_C233BE
@lbl_C23054:
	lda.l $7E86B8
	bne @lbl_C2305E
	jsl.l func_C25C3C
@lbl_C2305E:
	lda.l $7E8995
	lsr a
	lda.b #$3F
	bcc @lbl_C23069
	lda.b #$0F
@lbl_C23069:
	and.l $7E8978
	bne @lbl_C23085
	lda.l wIsInTown
	ora.l $7E8995
	beq @lbl_C23085
	lda.l $7ED5EE
	cmp.b #$08
	beq @lbl_C23085
	jsl.l func_C23173
@lbl_C23085:
	lda.l $7E8980
	beq @lbl_C230D6
	dec a
	sta.l $7E8980
	bne @lbl_C230D6
	lda.l $7E8981
	sta.b wTemp00
	lda.l $7E8982
	sta.b wTemp01
	jsl.l func_C3631A
	lda.b wTemp00
	bmi @lbl_C230CE
	lda.b #$18
	cmp.l $7E8996
	beq @lbl_C230D6
	sta.b wTemp03
	lda.l $7E85F0
	sta.b wTemp02
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	jsl.l func_C2007D
	pla
	ldx.b wTemp00
	bmi @lbl_C230D6
	sta.b wTemp00
	stx.b wTemp02
	jsl.l func_C35B7A
	bra @lbl_C230D6
@lbl_C230CE:
	.db $E2,$20,$A9,$01,$8F,$80,$89,$7E
@lbl_C230D6:
	sep #$20 ;A->8
	lda.l $7E8984
	beq @lbl_C230F4
	.db $AF,$F8,$D5,$7E,$F0,$10,$A9,$13,$85,$00,$A9,$01,$85,$02,$64,$03   ;C230DE  
	.db $64,$04,$22,$D3,$34,$C2           ;C230EE  
@lbl_C230F4:
	plp
	rtl

func_C230F6:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.w $899B
	beq @lbl_C2316C
	bmi @lbl_C2316C
	dec a
	sta.w $899B
	bne @lbl_C2316C
	lda.b #$00
	sta.w $87BC
	lda.b #$01
	sta.w $8780
	stz.w $871C
	stz.w $8998
	stz.w $885C
	stz.w $8977
	lda.w $894A
	and.b #$FD
	sta.w $894A
	call_savebank func_C35E1B
	rep #$20 ;A->16
	lda.w $89AD
	sta.w $89A2
	lda.w $89AF
	sta.w $89A4
	sep #$20 ;A->8
	lda.w $89B1
	sta.w $862C
	lda.w $89AA
	sta.w $86A4
	stz.b wTemp00
	call_savebank func_C2342B
	lda.b #$13
	sta.b wTemp00
	lda.b #$0C
	sta.b wTemp02
	call_savebank func_C62550
	lda.b #$5E
	sta.b wTemp00
	stz.b wTemp01
	call_savebank DisplayMessage
@lbl_C2316C:
	ldy.b #$13
	jsr.w func_C236CD
	plp
	rts

func_C23173:
	php
	sep #$30 ;AXY->8
	lda.b #$14
@lbl_C23178:
	pha
	jsl.l func_C360D7
	lda.b wTemp00
	sec
	sbc.l $7E85C8
	bpl @lbl_C23189
	eor.b #$FF
	inc a
@lbl_C23189:
	sta.b wTemp02
	lda.b wTemp01
	sec
	sbc.l $7E85DC
	bpl @lbl_C23197
	eor.b #$FF
	inc a
@lbl_C23197:
	clc
	adc.b wTemp02
	sta.b wTemp02
	pla
	dec a
	cmp.b wTemp02
	bcs @lbl_C23178
	lda.l $7E8995
	rep #$20 ;A->16
	beq @lbl_C231C5
	lda.l $7E8978
	and.w #$0010
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$4A06
	sta.b wTemp02
	lda.b wTemp00
	pha
	jsl.l func_C2007D
	pla
	bra @lbl_C231CD
@lbl_C231C5:
	lda.b wTemp00
	pha
	jsl.l func_C20BE7
	pla
@lbl_C231CD:
	ldx.b wTemp00
	bmi @lbl_C23207
	stx.b wTemp02
	sta.b wTemp00
	pha
	phx
	jsl.l func_C35B7A
	plx
	pla
	stx.b wTemp00
	sta.b wTemp02
	phx
	jsl.l func_C27951
	plx
	sep #$20 ;A->8
	lda.l wCharIsAwake,x
	and.b #$FE
	sta.l wCharIsAwake,x
	lda.l wCharUnderfootTerrainType,x
	cmp.l $7E87D0
	bne @lbl_C23207
	lda.l wCharIsAwake,x
	and.b #$FB
	sta.l wCharIsAwake,x
@lbl_C23207:
	plp
	rtl

func_C23209:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.b #$00
	xba
	lda.w wCharHP,y
	rep #$20 ;A->16
	clc
	adc.b wTemp02
	sep #$20 ;A->8
	bmi @lbl_C23236
	beq @lbl_C23236
	xba
	bne @lbl_C2322C
	xba
	cmp.w wCharMaxHP,y
	bcc @lbl_C23231
@lbl_C2322C:
	lda.w wCharMaxHP,y
	beq @lbl_C23236
@lbl_C23231:
	sta.w wCharHP,y
	plp
	rtl
@lbl_C23236:
	jsl.l func_C20F35
	plp
	rtl

func_C2323C:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.b #$00
	xba
	lda.w wCharMaxHP,y
	rep #$20 ;A->16
	clc
	adc.b wTemp02
	sep #$20 ;A->8
	beq @lbl_C23256
	bpl @lbl_C2325A
@lbl_C23256:
	.db $A9,$01,$80,$0A
@lbl_C2325A:
	xba
	bne @lbl_C23262
	xba
	cmp.b #$FA
	bcc @lbl_C23264
@lbl_C23262:
	.db $A9,$FA
@lbl_C23264:
	sta.w wCharMaxHP,y
	rep #$20 ;A->16
	stz.b wTemp02
	jsl.l func_C23209
	plp
	rtl

func_C23271:
	php
	sep #$30 ;AXY->8
	lda.l wShirenStatus.strength
	pha
	lda.b wTemp00
	bpl @lbl_C23285
	tay
	lda.l $7E894C
	bne @lbl_C232B0
	tya
@lbl_C23285:
	clc
	adc.l wShirenStatus.strength
	bvs @lbl_C23298
	cmp.b #$01
	bpl @lbl_C23292
;C23290
	.db $A9,$01
@lbl_C23292:
	cmp.l wShirenStatus.maxStrength
	bmi @lbl_C2329C
@lbl_C23298:
	lda.l wShirenStatus.maxStrength
@lbl_C2329C:
	sta.l wShirenStatus.strength
	stz.b wTemp00
	jsl.l func_C2342B
	pla
	sec
	sbc.l wShirenStatus.strength
	sta.b wTemp00
	plp
	rtl
@lbl_C232B0:
	.db $68,$A9,$A5,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B       ;C232B8  

func_C232BF:
	php
	sep #$30 ;AXY->8
	lda.l wShirenStatus.maxStrength
	pha
	lda.b wTemp00
	bpl @lbl_C232D3
;C232CB
	.db $A8,$AF,$4C,$89,$7E,$D0,$28,$98
@lbl_C232D3:
	clc
	adc.l wShirenStatus.maxStrength
	bvs @lbl_C232E4
	cmp.b #$01
	bpl @lbl_C232E0
;C232DE
	.db $A9,$01
@lbl_C232E0:
	cmp.b #$63
	bmi @lbl_C232E6
@lbl_C232E4:
	.db $A9,$63
@lbl_C232E6:
	sta.l wShirenStatus.maxStrength
	stz.b wTemp00
	jsl.l func_C23271
	pla
	sec
	sbc.l wShirenStatus.maxStrength
	sta.b wTemp00
	plp
	rtl
	.db $68,$A9,$A5,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B,$08   ;C232FA
	.db $E2,$20,$A5,$00,$8F,$49,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00,$8F   ;C2330A
	.db $4A,$89,$7E,$22,$1B,$5E,$C3,$28,$6B,$08,$E2,$20,$A5,$00,$8F,$4B   ;C2331A
	.db $89,$7E,$28,$6B,$08,$E2,$20,$A5,$00,$8F,$4C,$89,$7E,$28,$6B,$08   ;C2332A
	.db $E2,$20,$A5,$00,$8F,$4D,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00,$8F   ;C2333A
	.db $8E,$89,$7E,$28,$6B               ;C2334A  

func_C2334F:
	php
	sep #$20 ;A->8
	lda.l $7E898E
	sta.b wTemp00
	plp
	rtl
	.db $08,$E2,$20,$A5,$00,$49,$01,$8F   ;C2335A
	.db $94,$87,$7E,$28,$6B               ;C23362  

func_C23367:
	php
	sep #$20 ;A->8
	lda.l $7E8794
	eor.b #$01
	sta.b wTemp00
	plp
	rtl
	.db $08,$E2,$20,$A5,$00,$8F,$48,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00   ;C23374
	.db $8F,$47,$89,$7E,$28,$6B           ;C23384  

func_C2338A:
	php
	rep #$20 ;A->16
	lda.l wShirenStatus.maxHunger
	sta.b wTemp00
	plp
	rtl

func_C23395:
	php
	rep #$30 ;AXY->16
	lda.l wShirenStatus.maxHunger
	clc
	adc.b wTemp00
	bpl @lbl_C233A4
;C233A1
	.db $A9,$00,$00
@lbl_C233A4:
	cmp.w #$07D0
	bcc @lbl_C233AC
;C233A9
	.db $A9,$D0,$07
@lbl_C233AC:
	sta.l wShirenStatus.maxHunger
	stz.b wTemp00
	jsl.l func_C233BE
	lda.l wShirenStatus.maxHunger
	sta.b wTemp00
	plp
	rtl

func_C233BE:
	php
	rep #$30 ;AXY->16
	lda.l wShirenStatus.hunger
	tay
	clc
	adc.b wTemp00
	beq @lbl_C23420
	bmi @lbl_C23420
	cmp.l wShirenStatus.maxHunger
	bcc @lbl_C233D7
	lda.l wShirenStatus.maxHunger
@lbl_C233D7:
	sta.l wShirenStatus.hunger
	beq @lbl_C23420
	cmp.w #$00C8
	bcc @lbl_C233E4
	plp
	rtl
@lbl_C233E4:
	.db $C9,$64,$00,$90,$0A,$C0,$C8,$00,$90,$F4,$A9,$44,$00,$80,$15,$C9   ;C233E4
	.db $04,$00,$90,$0A,$C0,$64,$00,$90,$E5,$A9,$45,$00,$80,$06,$0A,$AA   ;C233F4  
	.db $BF,$18,$34,$C2,$85,$00
	jsl.l DisplayMessage
	.db $E2,$20,$A9,$00,$8F,$77   ;C23404  
	.db $89,$7E,$28,$6B,$00,$00,$48,$00   ;C23414
	.db $47,$00,$46,$00                   ;C2341C  
@lbl_C23420:
	.db $C2,$20,$A9,$00,$00,$8F,$43,$89   ;C23420
	.db $7E,$28,$6B                       ;C23428  

func_C2342B:
	php
	sep #$30 ;AXY->8
	lda.l $7E899B
	bne @lbl_C23454
	lda.l $7E8974
	clc
	adc.b wTemp00
	sta.l $7E8974
	clc
	adc.l wShirenStatus.strength
	bpl @lbl_C23448
;C23446
	.db $A9,$7F
@lbl_C23448:
	sta.b wTemp00
	jsl.l func_C23456
	lda.b wTemp00
	sta.l $7E8690
@lbl_C23454:
	plp
	rtl

;player total attack calculation function?
func_C23456:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	sec
	sbc.b #$08
	php
	bpl @lbl_C23464
	eor.b #$FF
	inc a
@lbl_C23464:
	sta.b wTemp00
	lda.l $7E862C
	tax
	lda.l $7E899B
	beq @lbl_C23476
;C23471  
	.db $AF,$B1,$89,$7E,$AA
@lbl_C23476:
	lda.l PlayerStrengthStatTable,x
	pha
	sta.b wTemp01
	jsl.l func_C3E3CB
	rep #$20 ;A->16
	lda.b wTemp00
	lsr a
	lsr a
	lsr a
	lsr a
	adc.w #$0000
	cmp.w #$0100
	sep #$20 ;A->8
	bcc @lbl_C23495
;C23493
	.db $A9,$FF
@lbl_C23495:
	sta.b wTemp00
	pla
	plp
	bmi @lbl_C234A4
	clc
	adc.b wTemp00
	bcc @lbl_C234A2
;C234A0
	.db $A9,$FF
@lbl_C234A2:
	bra @lbl_C234A7
@lbl_C234A4:
	sec
	sbc.b wTemp00
@lbl_C234A7:
	sta.b wTemp00
	plp
	rtl

func_C234AB:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wCharAttack,y
	clc
	adc.b wTemp01
	sta.w wCharAttack,y
	plp
	rtl

func_C234BF:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wCharDefense,y
	clc
	adc.b wTemp01
	sta.w wCharDefense,y
	plp
	rtl
	.db $08,$E2,$30,$A9,$7E,$48,$AB,$A4   ;C234D3
	.db $00,$4C,$1A,$35                   ;C234DB

func_C234DF:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wCharHP,y
	bne @lbl_C234EF
;C234ED
	.db $28,$6B
@lbl_C234EF:
	lda.w wCharNPCFlags,y
	bit.b #$80
	beq @lbl_C234F8
;C234F6
	.db $A0,$13
@lbl_C234F8:
	cpy.b #$13
	bne @lbl_C23518
	lda.b #$07
	sta.b wTemp00
	stz.b wTemp01
	rep #$20 ;A->16
	lda.b wTemp02
	pha
	lda.b wTemp04
	pha
	phy
	call_savebank DisplayMessage
	ply
	pla
	sta.b wTemp04
	pla
	sta.b wTemp02
@lbl_C23518:
	sep #$20 ;A->8
	cpy.b #$13
	beq @lbl_C23528
	lda.b #$01
	sta.b wTemp01
	jsl.l func_C23579
	plp
	rtl
@lbl_C23528:
	clc
	lda.w wCharExpByte0,y
	adc.b wTemp02
	sta.b wTemp02
	lda.w wCharExpByte1,y
	adc.b wTemp03
	sta.b wTemp03
	lda.w wCharExpByte2,y
	adc.b wTemp04
	sta.b wTemp04
	bpl @lbl_C23548
;C23540  
	.db $64,$02,$64,$03,$64,$04,$80,$1A
@lbl_C23548:
	lda.b #$3F
	cmp.b wTemp02
	lda.b #$42
	sbc.b wTemp03
	lda.b #$0F
	sbc.b wTemp04
	bpl @lbl_C23562
	.db $A9,$3F,$85,$02,$A9,$42,$85,$03   ;C23556
	.db $A9,$0F,$85,$04                   ;C2355E
@lbl_C23562:
	lda.b wTemp02
	sta.w wCharExpByte0,y
	lda.b wTemp03
	sta.w wCharExpByte1,y
	lda.b wTemp04
	sta.w wCharExpByte2,y
	sty.b wTemp00
	jsl.l func_C23684
	plp
	rtl

func_C23579:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	cpy.b #$13
	bne @lbl_C235D9
	.db $A5,$01,$30,$22,$18,$79,$2D,$86,$C9,$46,$30,$02,$A9,$46,$AA,$BF   ;C23586  
	.db $03,$CA,$C2,$99,$41,$86,$BF,$4A,$CA,$C2,$99,$55,$86,$BF,$91,$CA   ;C23596  
	.db $C2,$99,$69,$86,$80,$27,$18,$79,$2D,$86,$C9,$01,$10,$02,$A9,$01   ;C235A6
	.db $AA,$BF,$04,$CA,$C2,$38,$E9,$01,$99,$41,$86,$BF,$4B,$CA,$C2,$E9   ;C235B6
	.db $00,$99,$55,$86,$BF,$92,$CA,$C2,$E9,$00,$99,$69,$86,$22,$84,$36   ;C235C6
	.db $C2,$28,$6B                       ;C235D6
@lbl_C235D9:
	sep #$30 ;AXY->8
	lda.w wCharType,y
	cmp.b #$3C
	bcc @lbl_C235E4
;C235E2
	.db $28,$6B
@lbl_C235E4:
	lda.w wCharTrueLevel,y
	clc
	adc.b wTemp01
	bpl @lbl_C235EE
;C235EC
	.db $A9,$00
@lbl_C235EE:
	cmp.b #$64
	bcc @lbl_C235F4
;C235F2
	.db $A9,$63
@lbl_C235F4:
	sta.w wCharTrueLevel,y
	ldx.b #$00
	bra @lbl_C23624
@lbl_C235FB:
	cmp.w wCharType,y
	bne @lbl_C23621
@lbl_C23600:
	lda.w wCharTrueLevel,y
	cmp.l EnemyLevelLimits+1,x
	bcs @lbl_C23610
	lda.l EnemyLevelLimits+1,x
	sta.w wCharTrueLevel,y
@lbl_C23610:
	lda.l EnemyLevelLimits+2,x
	cmp.w wCharTrueLevel,y
	bcs @lbl_C2361C
	sta.w wCharTrueLevel,y
@lbl_C2361C:
	jsr.w func_C236CD
	plp
	rtl
@lbl_C23621:
	inx
	inx
	inx
@lbl_C23624:
	lda.l EnemyLevelLimits,x
	bpl @lbl_C235FB
	bra @lbl_C23600

;0: enemy id, 1: lower level limit, 2: upper level limit
EnemyLevelLimits:
	.db Char_BabyTank,0,3
	.db Char_PopsterTank,0,3
	.db Char_Kigny,1,99
	.db Char_Inferno,1,99
	.db Char_DeadSoldier,1,1
	.db Char_AirDevil,1,1
	.db Char_TwistyHani,1,1
	.db Char_Parthenos,1,1
	.db Char_FluffyBunny,1,1
	.db Char_Mecharoid,1,1
	.db Char_Hen,1,2
	.db Char_DarkOwl,1,1
	.db Char_TaintedInsect,1,1
	.db $FF,1,3 ;others

func_C23656:
	.db $08,$E2,$30,$A9,$7E,$48,$AB,$A4
	.db $00,$A2,$01,$B9,$41,$86,$DF,$04
	.db $CA,$C2,$B9,$55,$86,$FF,$4B,$CA
	.db $C2,$B9,$69,$86,$FF,$92,$CA,$C2
	.db $30,$03,$E8,$80,$E6,$8A,$99,$19
	.db $86,$99,$2D,$86,$28,$6B

;$00: character table index
func_C23684:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	ldx.w wCharTrueLevel,y
@lbl_C23690:
	lda.w wCharExpByte0,y
	cmp.l LevelExpTableLowByte,x
	lda.w wCharExpByte1,y
	sbc.l LevelExpTableMiddleByte,x
	lda.w wCharExpByte2,y
	sbc.l LevelExpTableHighByte,x
	bmi @lbl_C236AA
	inx
	bra @lbl_C23690
@lbl_C236AA:
	lda.w wCharExpByte0,y
	cmp.l LevelExpTableLowByte-1,x
	lda.w wCharExpByte1,y
	sbc.l LevelExpTableMiddleByte-1,x
	lda.w wCharExpByte2,y
	sbc.l LevelExpTableHighByte-1,x
	bpl @lbl_C236C4
;C236C1
	.db $CA,$80,$E6
@lbl_C236C4:
	txa
	sta.w wCharTrueLevel,y
	jsr.w func_C236CD
	plp
	rtl

func_C236CD:
	php
	sep #$30 ;AXY->8
	cpy.b #$13
	bne @lbl_C236DC
	lda.w $894B
	ora.w $899B
	bne @lbl_C23722
@lbl_C236DC:
	lda.w wCharTrueLevel,y
	cmp.w wCharLevel,y
	bne @lbl_C236E6
	plp
	rts
@lbl_C236E6:
	cpy.b #$13
	beq @lbl_C23718
	lda.w wCharTrueLevel,y
	cmp.w wCharLevel,y
	bcc @lbl_C23706
	lda.b #$2C
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	sty.b wTemp02
	phy
	call_savebank DisplayMessage ;print Text300
	ply
	bra @lbl_C23718
@lbl_C23706:
	lda.b #$2E
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	sty.b wTemp02
	phy
	call_savebank DisplayMessage
	ply
@lbl_C23718:
	lda.w wCharTrueLevel,y
	cmp.w wCharLevel,y
	bcc @lbl_C2378A
	bne @lbl_C23725
@lbl_C23722:
	jmp.w func_C237D9
@lbl_C23725:
	phy
	call_savebank func_C23935
	ply
	lda.b wTemp00
	sta.b wTemp02
	stz.b wTemp03
	sty.b wTemp00
	pha
	phy
	call_savebank func_C2323C
	ply
	pla
	sta.b wTemp02
	stz.b wTemp03
	sty.b wTemp00
	phy
	call_savebank func_C23209
	ply
	lda.w wCharAttack,y
	lsr a
	lsr a
	adc.w wCharAttack,y
	bcc @lbl_C23759
;C23757
	.db $A9,$FF
@lbl_C23759:
	sta.w wCharAttack,y
	lda.w wCharLevel,y
	inc a
	pha
	cpy.b #$13
	bne @lbl_C23780
	cmp.w wCharTrueLevel,y
	bne @lbl_C2377E
	sta.b wTemp03
	lda.b #$38
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
@lbl_C2377E:
	bra @lbl_C23780
@lbl_C23780:
	pla
	sta.w wCharLevel,y
	stz.w $8977
	jmp.w @lbl_C23718
@lbl_C2378A:
	phy
	call_savebank func_C23935
	ply
	lda.b #$00
	sec
	sbc.b wTemp00
	sta.b wTemp02
	lda.b #$FF
	sta.b wTemp03
	sty.b wTemp00
	phy
	call_savebank func_C2323C
	ply
	lda.w wCharAttack,y
	lsr a
	adc.b #$00
	sta.w wCharAttack,y
	lda.w wCharLevel,y
	dec a
	pha
	cpy.b #$13
	bne @lbl_C237D2
	.db $D9,$2D,$86,$D0,$12,$85,$03,$A9,$37,$85,$00,$64,$01,$84,$02,$5A   ;C237B9  
	.db $8B
	jsl.l DisplayMessage
	.db $AB,$7A,$80   ;C237C9
	.db $00                               ;C237D1
@lbl_C237D2:
	pla
	sta.w wCharLevel,y
	jmp.w @lbl_C23718

func_C237D9:
	cpy.b #$13
	beq @lbl_C237E5
	jsr.w func_C2389E
	jsr.w GetEnemyStats
	plp
	rts
@lbl_C237E5:
	stz.b wTemp00
	jsl.l func_C2342B
	plp
	rts

;gets the stats for the given enemy (or npc?)
;the results are stored in variables in ram
GetEnemyStats:
	php
	sep #$30 ;AXY->8
	lda.w wCharType,y
	cmp.b #$08
	beq @lbl_C237FB
	cmp.b #$0C
	bne @lbl_C23804
@lbl_C237FB:
	lda.w wCharLevel,y
	cmp.b #$04
	bcc @lbl_C23804
;C23802
	.db $28,$60
@lbl_C23804:
	lda.w wCharType,y
	tax
	lda.w wCharLevel,y
	dec a
	bne .notLevel1
	lda.l Level1EnemyHPStatTable,x
	sta.w wCharHP,y
	sta.w wCharMaxHP,y
	lda.l Level1EnemyStrengthStatTable,x
	sta.w wCharAttack,y
	lda.l Level1EnemyDefenseStatTable,x
	sta.w wCharDefense,y
	lda.l Level1EnemyExpTableLowByte,x
	sta.w wCharExpByte0,y
	lda.l Level1EnemyExpTableMiddleByte,x
	sta.w wCharExpByte1,y
	lda.l Level1EnemyExpTableHighByte,x
	sta.w wCharExpByte2,y
	plp
	rts
.notLevel1
	dec a
	bne .level3
	lda.l Level2EnemyHPStatTable,x
	sta.w wCharHP,y
	sta.w wCharMaxHP,y
	lda.l Level2EnemyStrengthStatTable,x
	sta.w wCharAttack,y
	lda.l Level2EnemyDefenseStatTable,x
	sta.w wCharDefense,y
	lda.l Level2EnemyExpTableLowByte,x
	sta.w wCharExpByte0,y
	lda.l Level2EnemyExpTableMiddleByte,x
	sta.w wCharExpByte1,y
	lda.l Level2EnemyExpTableHighByte,x
	sta.w wCharExpByte2,y
	plp
	rts
.level3
	lda.l Level3EnemyHPStatTable,x
	sta.w wCharHP,y
	sta.w wCharMaxHP,y
	lda.l Level3EnemyStrengthStatTable,x
	sta.w wCharAttack,y
	lda.l Level3EnemyDefenseStatTable,x
	sta.w wCharDefense,y
	lda.l Level3EnemyExpTableLowByte,x
	sta.w wCharExpByte0,y
	lda.l Level3EnemyExpTableMiddleByte,x
	sta.w wCharExpByte1,y
	lda.l Level3EnemyExpTableHighByte,x
	sta.w wCharExpByte2,y
	plp
	rts

func_C2389E:
	php
	sep #$30 ;AXY->8
	ldx.b #0
	bra @lbl_C238D2
@lbl_C238A5:
	cmp.w wCharType,y
	bne @lbl_C238CE
	lda.l MonsterEvolutionTable+1,x
	cmp.w wCharLevel,y
	bne @lbl_C238CE
	.db $84,$00,$BF,$EE,$38,$C2,$85,$01,$BF,$EF,$38,$C2,$85,$02,$5A,$8B   ;C238B3  
	.db $22,$D4,$80,$C2,$AB,$7A,$28,$68   ;C238C3  
	.db $68,$80,$0A                       ;C238CB
@lbl_C238CE:
	inx
	inx
	inx
	inx
@lbl_C238D2:
	lda.l MonsterEvolutionTable,x
	bpl @lbl_C238A5
	lda.b #$2D
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	sty.b wTemp02
	phy
	call_savebank DisplayMessage
	ply
	plp
	rts

;c238ec
;Specifies special cases where monsters turn into different ones
;based on level
;Mainly used for Bowboy -> Baby Tank -> Popster Tank evolution
MonsterEvolutionTable:
	.db Char_Bowboy,$03,Char_BabyTank,$01
	.db Char_BabyTank,$00,Char_Bowboy,$02
	.db Char_BabyTank,$03,Char_PopsterTank,$01
	.db Char_PopsterTank,$00,Char_BabyTank,$02
	.db Char_PopsterTank,$01,Char_PopsterTank,$01
	.db Char_PopsterTank,$02,Char_PopsterTank,$02
	.db Char_PopsterTank,$03,Char_PopsterTank,$03
	.db Char_DeathReaper,$01,Char_DeathReaper,$01
	.db Char_DeathReaper,$02,Char_DeathReaper,$02
	.db Char_EggThing,$01,Char_EggThing,$01
	.db Char_EggThing,$02,Char_EggThing,$02
	.db Char_EggThing,$03,Char_EggThing,$03
	.db Char_MasterHen,$01,Char_Hen,$01
	.db Char_Hen,$02,Char_MasterHen,$02
	.db Char_MasterHen,$02,Char_MasterHen,$02
	.db Char_MasterHen,$03,Char_MasterHen,$03
	.db Char_DarkOwl,$01,Char_DarkOwl,$01
	.db Char_DarkOwl,$02,Char_DarkOwl,$02
	.db $FF

func_C23935:
	php
	sep #$30 ;AXY->8
	stz.b wTemp00
	ldy.b #$02
	sty.b wTemp01
	jsl.l func_C3F69F
	lda.b wTemp00
	stz.b wTemp00
	ldy.b #$02
	sty.b wTemp01
	pha
	jsl.l func_C3F69F
	pla
	clc
	adc.b wTemp00
	adc.b #$02
	sta.b wTemp00
	plp
	rtl

func_C23959:
	php
	sep #$30 ;AXY->8
	ldy.b wTemp00
	phy
	jsl.l func_C30710
	ply
	lda.b wTemp00
	cmp.b #$04
	bne @lbl_C239D2
	sty.b wTemp00
	phx
	phy
	jsl.l func_C33AD5
	ply
	plx
	lda.b wTemp00
	cmp.b #$00
	bne @lbl_C239CC
	phy
	ldy.b wTemp01
	ldx.b #$FF
@lbl_C2397F:
	inx
	lda.l wShirenStatus.itemAmounts,x
	bmi @lbl_C239CB
	sta.b wTemp00
	phx
	phy
	jsl.l func_C33AD5
	ply
	plx
	lda.b wTemp00
	cmp.b #$00
	bne @lbl_C2397F
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	phx
	phy
	jsl.l func_C30710
	ply
	plx
	cpy.b wTemp01
	bne @lbl_C2397F
	ply
	sty.b wTemp02
	lda.b #$1C
	sta.b wTemp00
	stz.b wTemp01
	phx
	phy
	jsl.l DisplayMessage
	ply
	plx
	sty.b wTemp01
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	phx
	jsl.l func_C33B61
	plx
	stx.b wTemp00
	plp
	rtl
@lbl_C239CB:
	ply
@lbl_C239CC:
	lda.b #$FF
	sta.b wTemp00
	plp
	rtl
@lbl_C239D2:
	cmp.b #$08
	beq @lbl_C239DC
	lda.b #$FF
	sta.b wTemp00
	plp
	rtl
@lbl_C239DC:
	rep #$20 ;A->16
	lda.b wTemp02
	sta.b wTemp00
	sep #$20 ;A->8
	stz.b wTemp02
	jsl.l func_C25BE0
	sty.b wTemp02
	lda.b #$1E
	sta.b wTemp00
	stz.b wTemp01
	phy
	jsl.l DisplayMessage
	ply
	sty.b wTemp00
	jsl.l func_C306F4
	stz.b wTemp00
	plp
	rtl

; Validate the selected item source and insert it into inventory, handling the
; special blank-scroll rejection path reused by the ground-item exchange flow.
TryAddSelectedItemToInventory:
	php
	sep #$30 ;AXY->8
	ldy.b wTemp00
	phy
	jsl.l func_C23959
	ply
	ldx.b wTemp00
	bmi @lbl_C23A15
	stx.b wTemp00
	plp
	rtl
@lbl_C23A15:
	sty.b wTemp00
	phy
	; Reject one special blank-scroll case before continuing with the broader
	; selection flow that this helper feeds.
	jsl.l func_C30824
	ply
	lda.b wTemp00
	bne @lbl_C23A2F
	.db $84,$02,$A9,$C6,$85,$00,$64,$01   ;C23A21  
	jsl.l DisplayMessage
	.db $80,$10  ;C23A29  
@lbl_C23A2F:
	lda.l $7E8962
	bmi @lbl_C23A45
	lda.b #$88
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	lda.b #$FF
	sta.b wTemp00
	plp
	rtl
@lbl_C23A45:
	sty.b wTemp00
	phy
	jsl.l func_C30823
	ply
	sty.b wTemp00
	phy
	jsl.l func_C33AD5
	ply
	lda.b wTemp00
	cmp.b #$00
	beq @lbl_C23A74
	ldx.b #255
@lbl_C23A5D:
	inx
	lda.l wShirenStatus.itemAmounts,x
	pha
	tya
	sta.l wShirenStatus.itemAmounts,x
	ply
	bpl @lbl_C23A5D
	ldx.b #$00
	lda.l wShirenStatus.itemAmounts
	tay
	bra @lbl_C23A82
@lbl_C23A74:
	ldx.b #255
@lbl_C23A76:
	inx
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C23A76
	tya
	sta.l wShirenStatus.itemAmounts,x
@lbl_C23A82:
	sty.b wTemp00
	stz.b wTemp01
	phx
	phy
	jsl.l func_C25AFD
	ply
	plx
	sty.b wTemp02
	lda.b #$1C
	sta.b wTemp00
	stz.b wTemp01
	phx
	phy
	jsl.l DisplayMessage
	ply
	plx
	sty.b wTemp00
	phx
	jsl.l func_C6274A
	plx
	stx.b wTemp00
	plp
	rtl
	php                                     ;C23AAA
	sep #$30                                ;C23AAB
	jsl $C30630                             ;C23AAD
	ldx $00                                 ;C23AB1
	bmi @lbl_C23B16                         ;C23AB3
	phx                                     ;C23AB5
	jsl $C30710                             ;C23AB6
	plx                                     ;C23ABA
	sec                                     ;C23ABB
	lda $7E893F                             ;C23ABC
	sbc $02                                 ;C23AC0
	pha                                     ;C23AC2
	lda $7E8940                             ;C23AC3
	sbc $03                                 ;C23AC7
	pha                                     ;C23AC9
	lda $7E8941                             ;C23ACA
	sbc #$00                                ;C23ACE
	bcc @lbl_C23AE4                         ;C23AD0
	sta $7E8941                             ;C23AD2
	pla                                     ;C23AD6
	sta $7E8940                             ;C23AD7
	pla                                     ;C23ADB
	sta $7E893F                             ;C23ADC
	stx $00                                 ;C23AE0
	plp                                     ;C23AE2
	rtl                                     ;C23AE3
@lbl_C23AE4:
	pla                                     ;C23AE4
	pla                                     ;C23AE5
	stx $00                                 ;C23AE6
	jsl $C306F4                             ;C23AE8
	lda $7E893F                             ;C23AEC
	ora $7E8940                             ;C23AF0
	beq @lbl_C23B16                         ;C23AF4
	lda $7E893F                             ;C23AF6
	sta $01                                 ;C23AFA
	lda $7E8940                             ;C23AFC
	sta $02                                 ;C23B00
	lda #$00                                ;C23B02
	sta $7E893F                             ;C23B04
	sta $7E8940                             ;C23B08
	lda #$E5                                ;C23B0C
	sta $00                                 ;C23B0E
	jsl $C30295                             ;C23B10
	plp                                     ;C23B14
	rtl                                     ;C23B15
@lbl_C23B16:
	lda #$FF                                ;C23B16
	sta $00                                 ;C23B18
	plp                                     ;C23B1A
	rtl                                     ;C23B1B

func_C23B1C:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b #$00
	ldy.b #$FF
@lbl_C23B27:
	lda.w UNREACH_00894F,x
	bmi @lbl_C23B3F
	cmp.w UNREACH_008970
	beq @lbl_C23B3C
	cmp.w UNREACH_008971
	beq @lbl_C23B3C
	cmp.w UNREACH_008972
	beq @lbl_C23B3C
	iny
@lbl_C23B3C:
	inx
	bra @lbl_C23B27
@lbl_C23B3F:
	cpy.b #$00
	bpl @lbl_C23B47
;C23B43  
	.db $84,$00,$28,$6B
@lbl_C23B47:
	stz.b wTemp00
	sty.b wTemp01
	call_savebank func_C3F69F
	ldy.b wTemp00
	ldx.b #$00
@lbl_C23B55:
	lda.w UNREACH_00894F,x
	cmp.w UNREACH_008970
	beq @lbl_C23B6A
	cmp.w UNREACH_008971
	beq @lbl_C23B6A
	cmp.w UNREACH_008972
	beq @lbl_C23B6A
	dey
	bmi @lbl_C23B6D
@lbl_C23B6A:
	inx
	bra @lbl_C23B55
@lbl_C23B6D:
	stx.b wTemp00
	lda.w UNREACH_00894F,x
	pha
	jsl.l RemoveItemFromCategoryShortcutSlots
	pla
	sta.b wTemp00
	plp
	rtl

func_C23B7C:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	plp
	rtl

GetCategoryShortcutItemIds:
	php
	sep #$20 ;A->8
	lda.l wShirenStatus.categoryShortcutItemIds
	sta.b wTemp00
	lda.l wShirenStatus.categoryShortcutItemIds+1
	sta.b wTemp01
	lda.l wShirenStatus.categoryShortcutItemIds+2
	sta.b wTemp02
	lda.l wShirenStatus.categoryShortcutItemIds+3
	sta.b wTemp03
	plp
	rtl

func_C23BA6:
	php
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E897D
	lda.b #$01
	sta.l $7E89BB
	plp
	rtl

func_C23BB7:
	php
	sep #$20 ;A->8
	lda.l $7E897D
	sta.b wTemp00
	lda.l $7E89BB
	sta.b wTemp02
	lda.l $7E897E
	sta.b wTemp01
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$BF,$E9,$88,$7E,$85,$00,$BF,$FD,$88,$7E,$85   ;C23BCE
	.db $01,$28,$6B                       ;C23BDE  

ToggleArrowShortcutItem:
	php
	sep #$20 ;A->8
	lda.b wTemp00
	cmp.l wShirenStatus.categoryShortcutItemIds+3
	beq @lbl_C23BF6
	sta.l wShirenStatus.categoryShortcutItemIds+3
	lda.b #$02
	sta.b wTemp00
	plp
	rtl
@lbl_C23BF6:
	.db $A9,$FF,$8F,$73,$89,$7E,$A9,$01   ;C23BF6
	.db $85,$00,$28,$6B                   ;C23BFE  

ToggleWeaponShortcutItem:
	php
	sep #$30 ;AXY->8
	ldx.b #$00
	bra ToggleCategoryShortcutItemByIndex

ToggleArmbandShortcutItem:
	php
	sep #$30 ;AXY->8
	ldx.b #$02
	bra ToggleCategoryShortcutItemByIndex

ToggleShieldShortcutItem:
	php
	sep #$30 ;AXY->8
	ldx.b #$01
ToggleCategoryShortcutItemByIndex:
	ldy.b wTemp00
	lda.l wShirenStatus.categoryShortcutItemIds,x
	bmi @lbl_C23C42
	sta.b wTemp00
	phx
	phy
	jsl.l TryClearAssignedCategoryItem
	ply
	plx
	lda.b wTemp00
	bne @lbl_C23C2F
;C23C2B  
	.db $64,$00,$28,$6B
@lbl_C23C2F:
	tya
	cmp.l wShirenStatus.categoryShortcutItemIds,x
	bne @lbl_C23C42
	lda.b #$FF
	sta.l wShirenStatus.categoryShortcutItemIds,x
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C23C42:
	tya
	sta.l wShirenStatus.categoryShortcutItemIds,x
	lda.b #$02
	sta.b wTemp00
	plp
	rtl

RemoveItemFromCategoryShortcutSlots:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w $894F,y
	ldx.b #$03
@lbl_C23C5B:
	cmp.w wShirenStatus.categoryShortcutItemIds,x
	beq @lbl_C23C65
	dex
	bpl @lbl_C23C5B
	bra @lbl_C23C82
@lbl_C23C65:
	cpx.b #$03
	beq @lbl_C23C7D
	sta.b wTemp00
	phx
	phy
	call_savebank TryClearAssignedCategoryItem
	ply
	plx
	lda.b wTemp00
	bne @lbl_C23C7D
;C23C79  
	.db $64,$00,$28,$6B
@lbl_C23C7D:
	lda.b #$FF
	sta.w wShirenStatus.categoryShortcutItemIds,x
@lbl_C23C82:
	iny
	lda.w $894F,y
	sta.w $894E,y
	bpl @lbl_C23C82
	lda.b #$01
	sta.b wTemp00
	plp
	rtl

HandleCategoryShortcutSelectionAction:
	php
	sep #$30 ;AXY->8
	lda.b wTemp01
	bpl @lbl_C23C9B
	; Negative wTemp01 selects a nested/container item path.
	jmp.w HandleContainedItemSelectionAction
@lbl_C23C9B:
	bit.b #$40
	beq @lbl_C23CA2
	; Bit $40 in wTemp01 selects the special ground-item exchange path, distinct
	; from the regular inventory, contextual-map-item, and nested/container
	; modes. This path shares some helper logic with jar handling, but gameplay
	; confirms it is the generic underfoot-item exchange action.
	jmp.w @lbl_C23D1E
@lbl_C23CA2:
	ldx.b wTemp00
	cpx.b #$1F
	beq @lbl_C23CB5
	; Regular inventory-slot selection.
	jsl.l func_C14FD0
	lda.b wTemp02
	bne @lbl_C23CB3
	jsr.w AssignSelectedInventoryItemToCategoryShortcut
@lbl_C23CB3:
	plp
	rtl
@lbl_C23CB5:
	; Slot $1F is a contextual map item selection resolved from Shiren's current
	; position via the map-object lookup helpers below.
	ldy.b wTemp01
	lda.l $7E85C8
	sta.b wTemp00
	pha
	lda.l $7E85DC
	sta.b wTemp01
	pha
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp01
	cmp.b #$7F
	bcs @lbl_C23D1A
	sta.l $7E896E
	pha
	lda.b #$FF
	sta.b wTemp00
	lda.b wTemp03,s
	sta.b wTemp04
	lda.b wTemp02,s
	sta.b wTemp05
	phx
	phy
	jsl.l func_C62720
	ply
	plx
	pla
	lda.b #$85
	sta.b wTemp02
	lda.b wTemp02,s
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	phx
	jsl.l func_C35BA2
	plx
	stx.b wTemp00
	sty.b wTemp01
	jsr.w AssignSelectedInventoryItemToCategoryShortcut
	lda.l $7E896E
	bpl @lbl_C23D0C
	lda.b #$80
@lbl_C23D0C:
	sta.b wTemp02
	lda.b wTemp02,s
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	jsl.l func_C35BA2
@lbl_C23D1A:
	pla
	pla
	plp
	rtl
@lbl_C23D1E:
	and.b #$1F
	sta.b wTemp00
	tax
	; The exchange action needs to take the underfoot item into inventory, so it
	; is blocked while cantPickUpItems is active.
	lda.l wShirenStatus.cantPickUpItems
	beq @lbl_C23D2E
	lda.b #$2B
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage
	plp
	rtl
@lbl_C23D2E:
	; Resolve the current ground item under Shiren.
	lda.l wCharXPos+CharDataShirenIndex
	sta.b wTemp00
	lda.l wCharYPos+CharDataShirenIndex
	sta.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	ldy.b wTemp01
	sty.b wTemp00
	phx
	phy
	jsl.l func_C30824
	ply
	plx
	lda.b wTemp00
	bne @lbl_C23D5E
	; Reject one special blank-scroll case before continuing.
	sty.b wTemp02
	lda.b #$C6
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	plp
	rtl
@lbl_C23D5E:
	; Replace the ground item with the currently selected inventory item.
	lda.l wShirenStatus.itemAmounts,x
	pha
	stx.b wTemp00
	phx
	phy
	jsl.l RemoveItemFromCategoryShortcutSlots
	ply
	plx
	lda.b wTemp00
	bne @lbl_C23D74
	pla
	plp
	rtl
@lbl_C23D74:
	sty.b wTemp00
	phx
	phy
	jsl.l func_C30823
	ply
	plx
	lda.l wCharXPos+CharDataShirenIndex
	sta.b wTemp00
	lda.l wCharYPos+CharDataShirenIndex
	sta.b wTemp01
	lda.b $01,s
	sta.b wTemp02
	phx
	jsl.l func_C35BA2
	plx
	pla
	sta.b wTemp02
	sty.b wTemp03
	lda.b #$1D
	sta.b wTemp00
	stz.b wTemp01
	phx
	phy
	jsl.l DisplayMessage
	ply
	plx
	sty.b wTemp00
	stz.b wTemp01
	phx
	phy
	jsl.l func_C25AFD
	ply
	plx
	dex
@lbl_C23DB4:
	; Insert the old ground item into inventory, shifting later entries down.
	inx
	lda.l wShirenStatus.itemAmounts,x
	pha
	tya
	sta.l wShirenStatus.itemAmounts,x
	ply
	bpl @lbl_C23DB4
	plp
	rtl

HandleContainedItemSelectionAction:
	pha
	ldx.b wTemp00
	cpx.b #$1F
	beq @lbl_C23DDA
	lda.l wShirenStatus.itemAmounts,x
	bra @lbl_C23DEC
@lbl_C23DDA:
	.db $AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85,$7E,$85,$01,$22,$AF,$59,$C3   ;C23DDA  
	.db $A5,$01                           ;C23DEA  
@lbl_C23DEC:
	tax
	stx.b wTemp00
	phx
	jsl.l func_C30710
	plx
	lda.b wTemp01
	cmp.b #$BC
	bne @lbl_C23DFF
;C23DFB
	.db $68,$4C,$2E,$3F
@lbl_C23DFF:
	lda.b wTemp01,s
	; For contained items, the low 5 bits select the linked-list entry inside the
	; container and bits 5-6 select the action family:
	;   $00 = route into category shortcut/equip handling
	;   $20 = use the contained item
	;   $40 = place the contained item on the ground
	;   $60 = move the contained item into inventory
	and.b #$1F
	tay
	pla
	and.b #$60
	beq @lbl_C23E0C
;C23E09  
	.db $4C,$3A,$3E
@lbl_C23E0C:
	stx.b wTemp00
	sty.b wTemp01
	phx
	phy
	jsl.l GetContainedItemByIndex
	ply
	plx
	stx.b wTemp00
	sty.b wTemp01
	phx
	phy
	jsl.l RemoveContainedItemByIndex
	lda.b wTemp00
	sta.l $7E896E
	lda.b #$1F
	sta.b wTemp00
	lda.l $7E899F
	sta.b wTemp01
	jsr.w AssignSelectedInventoryItemToCategoryShortcut
	ply
	plx
	jmp.w func_C23E5F
	.db $C9,$20,$F0,$03,$4C,$71,$3E,$86,$00,$84,$01,$DA,$5A,$22,$01,$3B   ;C23E3A
	.db $C3,$7A,$FA,$A5,$00,$8F,$6E,$89,$7E,$A9,$1F,$85,$00,$DA,$5A,$22   ;C23E4A  
	.db $71,$46,$C2,$7A,$FA               ;C23E5A  

func_C23E5F:
	lda.l $7E896E
	bmi @lbl_C23E6F
	stx.b wTemp00
	sty.b wTemp01
	sta.b wTemp02
	jsl.l InsertContainedItemByIndex
@lbl_C23E6F:
	plp
	rtl
	.db $C9,$40,$F0,$03,$4C,$CC,$3E,$AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85   ;C23E71
	.db $7E,$85,$01,$DA,$22,$AF,$59,$C3,$FA,$A5,$02,$30,$06,$A5,$01,$C9   ;C23E81  
	.db $80,$F0,$0C,$A9,$54,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $28,$6B,$86   ;C23E91  
	.db $00,$84,$01,$22,$01,$3B,$C3,$A4,$00,$A9,$1F,$85,$00,$64,$01,$84   ;C23EA1
	.db $02,$5A
	jsl.l DisplayMessage
	.db $7A,$AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85   ;C23EB1
	.db $7E,$85,$01,$84,$02,$22,$A2,$5B,$C3,$28,$6B,$AF,$62,$89,$7E,$30   ;C23EC1  
	.db $0C,$A9,$88,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $28,$6B,$A9,$13,$85   ;C23ED1  
	.db $00,$A9,$C6,$85,$02,$DA,$5A,$22,$65,$25,$C6,$7A,$FA,$86,$00,$DA   ;C23EE1
	.db $5A,$22,$69,$2B,$C6,$7A,$FA,$86,$00,$84,$01,$DA,$22,$01,$3B,$C3   ;C23EF1
	.db $FA,$A4,$00,$86,$02,$84,$03,$A9,$CC,$85,$00,$64,$01,$5A
	jsl.l DisplayMessage
	.db $7A,$84,$00,$64,$01,$5A,$22,$FD,$5A,$C2,$7A,$A2,$FF,$E8   ;C23F11  
	.db $BF,$4F,$89,$7E,$10,$F9,$98,$9F   ;C23F21  
	.db $4F,$89,$7E,$28,$6B,$28,$6B       ;C23F29  

AssignSelectedInventoryItemToCategoryShortcut:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C23F3D
;C23F3B
	.db $28,$60
@lbl_C23F3D:
	ldy.b wTemp01
	sta.b wTemp00
	stz.b wTemp01
	pha
	phx
	phy
	jsl.l func_C25AFD
	ply
	plx
	pla
	sta.b wTemp00
	sty.b wTemp01
	lda.l $7E85C8
	sta.b wTemp02
	lda.l $7E85DC
	sta.b wTemp03
	lda.b #$13
	sta.b wTemp04
	phx
	; Route the selected inventory item into the category-based shortcut/equip path.
	jsl.l ExecuteSelectedItemActionByCategory
	plx
	lda.b wTemp00
	bne @lbl_C23F71
	stx.b wTemp00
	jsl.l RemoveItemFromCategoryShortcutSlots
@lbl_C23F71:
	dec a
	bne @lbl_C23F76
	plp
	rts
@lbl_C23F76:
	.db $86,$00,$22,$4D,$3C,$C2,$22,$CF   ;C23F76  
	.db $22,$C3,$28,$60                   ;C23F7E  

DropSelectedInventoryItem:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b wTemp00
	lda.w $894F,x
	bpl @lbl_C23F9A
	.db $22,$BC,$8F,$C2,$A9,$02,$85,$00   ;C23F90  
	.db $28,$6B                           ;C23F98
@lbl_C23F9A:
	lda.w $85C8
	sta.b wTemp00
	lda.w $85DC
	sta.b wTemp01
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	phx
	jsl.l func_C359AF
	plx
	pla
	ldy.b wTemp02
	bmi @lbl_C23FBA
	ldy.b wTemp01
	cpy.b #$80
	beq @lbl_C23FCE
@lbl_C23FBA:
	.db $A9,$54,$00,$85,$00
	jsl.l DisplayMessage
	.db $22,$BC,$8F,$C2,$A9,$02,$00   ;C23FBA
	.db $85,$00,$28,$6B                   ;C23FCA  
@lbl_C23FCE:
	stx.b wTemp00
	ldy.w $894F,x
	pha
	phy
	call_savebank RemoveItemFromCategoryShortcutSlots
	ply
	pla
	ldx.b wTemp00
	bne @lbl_C23FE5
;C23FE1  
	.db $64,$00,$28,$6B
@lbl_C23FE5:
	sta.b wTemp00
	sty.b wTemp02
	jsl.l func_C35BA2
	sep #$20 ;A->8
	sty.b wTemp02
	lda.b #$1F
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	stz.b wTemp00
	plp
	rtl

func_C23FFF:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp01
	beq @lbl_C24012
	cpx.b #$13
	bne @lbl_C24012
	lda.l $7E898C
	bne @lbl_C2401C
@lbl_C24012:
	lda.b wTemp01
	sta.l wCharRemainingConfusedTurns,x
	sta.b wTemp00
	plp
	rtl
@lbl_C2401C:
	.db $A9,$D8,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B           ;C24024  

func_C2402A:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b #$13
	bne @lbl_C24039
;C24033  
	.db $22,$FF,$3F,$C2,$28,$6B
@lbl_C24039:
	lda.l $7E899A
	cmp.b #$13
	beq @lbl_C24050
	.db $AA,$A9,$00,$9F,$B9,$86,$7E,$BF   ;C24041
	.db $A1,$85,$7E,$9F,$A9,$87,$7E       ;C24049  
@lbl_C24050:
	ldx.b wTemp00
	lda.b wTemp01
	sta.l wCharRemainingConfusedTurns,x
	lda.b #$00
	sta.l wCharAppearance,x
	lda.b #$00
	sta.l wCharOverrideState,x
	txa
	sta.l $7E899A
	lda.b #$01
	sta.b wTemp02
	jsl.l func_C62550
	plp
	rtl

func_C24073:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp01
	sta.l wCharRemainingPuzzledTurns,x
	plp
	rtl

func_C24080:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	bne @lbl_C2408F
	lda.l $7E894D
	bne @lbl_C24099
@lbl_C2408F:
	lda.b wTemp01
	sta.l wCharRemainingSleepTurns,x
	sta.b wTemp00
	plp
	rtl
@lbl_C24099:
	.db $A9,$A6,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B           ;C240A1  

func_C240A7:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp01
	sta.l wCharRemainingBlindlessTurns,x
	cpx.b #$13
	bne @lbl_C240BA
	jsl.l func_C35E1B
@lbl_C240BA:
	plp
	rtl

func_C240BC:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp01
	sta.l wCharRemaningDoubleSpeedTurns,x
	lda.l wCharSpeed,x
	cmp.b #$02
	beq @lbl_C240D4
	inc a
	sta.l wCharSpeed,x
@lbl_C240D4:
	plp
	rtl

func_C240D6:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	beq @lbl_C240EE
	lda.l wCharSpeed,x
	cmp.b #$00
	beq @lbl_C240EC
	dec a
	sta.l wCharSpeed,x
@lbl_C240EC:
	plp
	rtl
@lbl_C240EE:
	lda.b #$14
	sta.l $7E8998
	lda.b #$01
	sta.l $7E8780
	plp
	rtl

func_C240FC:
	php
	sep #$20 ;A->8
	lda.b #$14
	sta.l $7E885C
	lda.b #$36
	sta.l $7E87BC
	lda.b #$06
	sta.l $7E85F0
	ldx.b #$12
@lbl_C24113:
	stx.b wTemp00
	phx
	jsl.l func_C27C6D
	plx
	lda.b wTemp00
	beq @lbl_C24125
	lda.b #$06
	sta.l wCharDeadEndWaitingTurn,x
@lbl_C24125:
	dex
	bpl @lbl_C24113
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$A9,$36,$9F,$A9,$87,$7E,$A9,$01,$9F,$49,$88   ;C2412A
	.db $7E,$8A,$CF,$9A,$89,$7E,$D0,$06,$A9,$13,$8F,$9A,$89,$7E,$28,$6B   ;C2413A  

func_C2414A:
	php
	sep #$30 ;AXY->8
	jsl.l func_C24167
	lda.b #$13
	sta.b wTemp00
	lda.b #$0C
	sta.b wTemp02
	jsl.l func_C62550
	jsl.l func_C62405
	jsl.l func_C250F7
	plp
	rtl

;might be music related
func_C24167:
	php
	sep #$30 ;AXY->8
	lda.b #$00
	sta.l $7E88C0
	lda.l $7E899B
	bne @lbl_C241A5
	rep #$20 ;A->16
	lda.l $7E89A2
	sta.l $7E89AD
	lda.l $7E89A4
	sta.l $7E89AF
	lda.w #$0000
	sta.l $7E89A2
	sta.l $7E89A4
	sep #$20 ;A->8
	lda.l $7E86A4
	sta.l $7E89AA
	lda.l $7E862C
	sta.l $7E89B1
@lbl_C241A5:
	lda.b wTemp00
	sta.l $7E87BC
	tax
	lda.b wTemp01
	sta.l $7E862C
	lda.b #$FF
	sta.l $7E899B
	ldx.b wTemp00
	cpx.b #$19
	bne @lbl_C241C4
;C241BE  
	.db $A5,$01,$C9,$03,$F0,$1E
@lbl_C241C4:
	cpx.b #$22
	bne @lbl_C241CE
;C241C8  
	.db $A5,$01,$C9,$03,$F0,$14
@lbl_C241CE:
	cpx.b #$1D
	beq @lbl_C241E2
	cpx.b #$2A
	beq @lbl_C241E2
	cpx.b #$2E
	beq @lbl_C241E2
	cpx.b #$1A
	beq @lbl_C241E2
	cpx.b #$02
	bne @lbl_C241F2
@lbl_C241E2:
	lda.b #$00
	sta.l $7E8708
	lda.b #$02
	sta.l $7E8780
	jsl.l func_C25DA2
@lbl_C241F2:
	cpx.b #$15
	bne @lbl_C241FE
;C241F6
	.db $A9,$80,$8F,$A2,$89,$7E,$28,$6B
@lbl_C241FE:
	cpx.b #$22
	bne @lbl_C24217
	.db $AF,$2C,$86,$7E,$3A,$D0,$0C,$A9,$FF,$8F,$98,$89,$7E,$A9,$01,$8F   ;C24202  
	.db $80,$87,$7E,$28,$6B               ;C24212  
@lbl_C24217:
	cpx.b #$0C
	bne @lbl_C24225
	.db $A9,$32,$8F,$C0,$88,$7E,$8F,$9B   ;C2421B
	.db $89,$7E                           ;C24223
@lbl_C24225:
	cpx.b #$0E
	bne @lbl_C2423E
	.db $A9,$FF,$8F,$1C,$87,$7E,$AF,$2C,$86,$7E,$3A,$F0,$06,$A9,$80,$8F   ;C24229
	.db $A2,$89,$7E,$28,$6B               ;C24239
@lbl_C2423E:
	cpx.b #$2A
	bne @lbl_C24252
	lda.l $7E894A
	ora.b #$02
	sta.l $7E894A
	jsl.l func_C35E1B
	plp
	rtl
@lbl_C24252:
	cpx.b #$24
	bne @lbl_C242D4
	.db $A9,$00,$8F,$BC,$87,$7E,$22,$05,$24,$C6,$A9,$24,$8F,$BC,$87,$7E   ;C24256
	.db $A9,$FF,$48,$AF,$2C,$86,$7E,$3A,$D0,$09,$AF,$71,$89,$7E,$30,$01   ;C24266
	.db $48,$80,$34,$3A,$D0,$36,$AF,$70,$89,$7E,$30,$01,$48,$AF,$71,$89   ;C24276
	.db $7E,$30,$01,$48,$AF,$72,$89,$7E,$30,$01,$48,$80,$1A,$85,$00,$48   ;C24286  
	.db $22,$03,$40,$C3,$68,$A6,$00,$F0,$0E,$85,$02,$A9,$0E,$85,$00,$A9   ;C24296  
	.db $01,$85,$01
	jsl.l DisplayMessage
	.db $68,$10,$E3,$28,$6B,$68,$A2,$00,$80   ;C242A6  
	.db $09,$85,$00,$DA,$22,$03,$40,$C3,$FA,$E8,$BF,$4F,$89,$7E,$10,$F1   ;C242B6
	.db $A9,$0F,$85,$00,$A9,$01,$85,$01   ;C242C6
	jsl.l DisplayMessage
	.db $28,$6B           ;C242CE  
@lbl_C242D4:
	cpx.b #$1E
	bne @lbl_C242F6
	.db $AF,$A4,$86,$7E,$18,$69,$0B,$90,$02,$A9,$FF,$8F,$A4,$86,$7E,$AF   ;C242D8  
	.db $90,$86,$7E,$0A,$90,$02,$A9,$FF   ;C242E8  
	.db $8F,$90,$86,$7E,$28,$6B           ;C242F0  
@lbl_C242F6:
	cpx.b #$1A
	bne @lbl_C2430C
	.db $AF,$7C,$95,$C2,$8F,$90,$86,$7E,$AF,$3C,$96,$C2,$8F,$A4,$86,$7E   ;C242FA  
	.db $28,$6B                           ;C2430A
@lbl_C2430C:
	cpx.b #$1D
	bne @lbl_C2431A
	.db $AF,$7F,$95,$C2,$8F,$90,$86,$7E   ;C24310  
	.db $28,$6B                           ;C24318
@lbl_C2431A:
	cpx.b #$1B
	bne @lbl_C24338
	.db $A9,$13,$85,$00,$A9,$00,$85,$02,$22,$F6,$26,$C6,$22,$5A,$5E,$C3   ;C2431E
	.db $22,$6D,$5F,$C3,$22,$F8,$5E,$C3   ;C2432E  
	.db $28,$6B                           ;C24336
@lbl_C24338:
	plp
	rtl
	.db $08,$E2,$20,$A9,$37,$85,$00,$A9,$01,$85,$01,$22,$67,$41,$C2,$A9   ;C2433A
	.db $0A,$8F,$9B,$89,$7E,$A9,$13,$85,$00,$A9,$0C,$85,$02,$22,$50,$25   ;C2434A
	.db $C6,$28,$6B,$08,$E2,$20,$AF,$9B,$89,$7E,$85,$00,$28,$6B,$08,$E2   ;C2435A  
	.db $20,$AF,$95,$89,$7E,$85,$00,$28   ;C2436A  
	.db $6B                               ;C24372

func_C24373:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharNPCFlags,x
	sta.b wTemp00
	plp
	rtl

func_C24380:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	ldx.b wTemp00
	lda.b wTemp02
	sta.b wTemp00
	sep #$30 ;AXY->8
	jmp.w func_C24401

func_C24390:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b #$14
@lbl_C24397:
	pha
	phx
	jsl.l func_C360D7
	plx
	lda.b wTemp00
	sec
	sbc.l wCharXPos,x
	bpl @lbl_C243AA
	eor.b #$FF
	inc a
@lbl_C243AA:
	sta.b wTemp02
	lda.b wTemp01
	sec
	sbc.l wCharYPos,x
	bpl @lbl_C243B8
	eor.b #$FF
	inc a
@lbl_C243B8:
	clc
	adc.b wTemp02
	sta.b wTemp02
	pla
	dec a
	cmp.b wTemp02
	bcs @lbl_C24397
	cpx.b #$13
	bne func_C24401
	lda.l wIsInTown
	bne func_C24401
	.db $C2,$20,$A5,$00,$48,$DA,$22,$AF,$59,$C3,$FA,$68,$E2,$20,$A4,$02   ;C243CD
	.db $D0,$B6,$C2,$20,$85,$02,$86,$00,$E2,$20,$AF,$D0,$87,$7E,$F0,$0E   ;C243DD  
	.db $22,$80,$43,$C2,$22,$05,$24,$C6,$22,$A9,$08,$C6,$28,$6B,$22,$80   ;C243ED  
	.db $43,$C2,$28,$6B                   ;C243FD  
func_C24401:
	sep #$30 ;AXY->8
	lda.l wCharType,x
	tay
	rep #$20 ;A->16
	lda.b wTemp00
	sta.b wTemp06
	sep #$20 ;A->8
	stx.b wTemp00
	lda.l wCharAppearance,x
	sta.b wTemp01
	lda.b #$04
	sta.b wTemp02
	lda.l wCharDir,x
	sta.b wTemp03
	lda.l wCharXPos,x
	sta.b wTemp04
	lda.l wCharYPos,x
	sta.b wTemp05
	rep #$20 ;A->16
	lda.b wTemp06
	pha
	phx
	jsl.l func_C626A0
	plx
	pla
	stx.b wTemp00
	sta.b wTemp02
	phx
	jsl.l func_C27951
	plx
	sep #$20 ;A->8
	jsr.w func_C2452B
	plp
	rtl

func_C2444B:
	php
	sep #$30 ;AXY->8
	lda.b #$0A
	sta.b wTemp02
	jmp.w func_C24458
	.db $08,$E2,$30                       ;C24455

func_C24458:
	ldx.b wTemp00
	ldy.b wTemp01
	lda.b wTemp02
	pha
	lda.l wCharXPos,x
	sta.b wTemp00
	lda.l wCharYPos,x
	sta.b wTemp01
	lda.b #$80
	sta.b wTemp02
	phx
	jsl.l func_C35B7A
	plx
	sty.b wTemp00
	stx.b wTemp01
	phx
	phy
	jsl.l func_C277B3
	ply
	plx
	lda.b wTemp01
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	lda.l wCharXPos,x
	sta.b wTemp02
	lda.l wCharYPos,x
	sta.b wTemp03
	phx
	phy
	jsl.l func_C32FEE
	ply
	plx
	lda.b wTemp03
	sta.b wTemp07
	pha
	lda.b wTemp02
	sta.b wTemp06
	pha
	lda.b wTemp00
	pha
	stx.b wTemp00
	lda.l wCharAppearance,x
	sta.b wTemp01
	lda.b #$0B
	sta.b wTemp02
	lda.l wCharDir,x
	sta.b wTemp03
	lda.l wCharXPos,x
	sta.b wTemp04
	lda.l wCharYPos,x
	sta.b wTemp05
	phx
	phy
	jsl.l func_C626A0
	ply
	plx
	pla
	bmi @lbl_C244E3
;C244D3  
	.db $85,$00,$A9,$05,$85,$02,$84,$01,$DA,$5A,$22,$DF,$28,$C2,$7A,$FA
@lbl_C244E3:
	rep #$20 ;A->16
	lda.b wTemp01,s
	sta.b wTemp00
	phx
	phy
	jsl.l func_C3631A
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C244F7
	sta.b wTemp01,s
@lbl_C244F7:
	lda.b wTemp01,s
	sta.b wTemp00
	stx.b wTemp02
	phx
	jsl.l func_C35B7A
	plx
	stx.b wTemp00
	pla
	sta.b wTemp02
	phx
	phy
	jsl.l func_C20DD1
	ply
	plx
	sep #$20 ;A->8
	lda.b #$05
	sta.b wTemp02
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C228DF
	plx
	phx
	jsr.w func_C2455F
	plx
	jsr.w func_C2452B
	pla
	plp
	rtl

func_C2452B:
	php
	sep #$30 ;AXY->8
	cpx.b #$13
	bne @lbl_C24557
	lda.b #$00
	sta.l $7E8758
	lda.l $7E898F
	pha
	jsl.l func_C22D3B
	pla
	sta.l $7E898F
	jsl.l func_C35C9A
	ldx.b #$12
	lda.b #$FF
@lbl_C2454E:
	sta.l wCharAttackTarget,x
	dex
	bpl @lbl_C2454E
	plp
	rts
@lbl_C24557:
	lda.b #$FF
	sta.l wCharAttackTarget,x
	plp
	rts

func_C2455F:
	php
	sep #$30 ;AXY->8
	lda.l wCharHP,x
	beq @lbl_C24578
	lda.l wCharUnderfootTerrainType,x
	and.b #$F0
	cmp.b #$B0
	bne @lbl_C24578
;C24572  
	.db $86,$00,$22,$90,$43,$C2
@lbl_C24578:
	plp
	rts
	.db $08,$E2,$30,$A6,$00,$20,$5F,$45,$28,$6B,$08,$E2,$30,$A6,$00,$20   ;C2457A
	.db $2B,$45,$28,$6B                   ;C2458A

HandleArrowShortcutAction:
	php
	sep #$30 ;AXY->8
	lda.l $7E899B
	bne @lbl_C245C4
	; L-button action uses the arrow shortcut slot.
	lda.l wShirenStatus.categoryShortcutItemIds+3
	bpl @lbl_C245B1
	lda.b #$B5
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	jsl.l func_C28FBC
	lda.b #$02
	sta.b wTemp00
	plp
	rtl
@lbl_C245B1:
	ldx.b #$FF
@lbl_C245B3:
	inx
	cmp.l wShirenStatus.itemAmounts,x
	bne @lbl_C245B3
	stx.b wTemp00
	jsl.l ThrowSelectedItem
	stz.b wTemp00
	plp
	rtl
@lbl_C245C4:
	jsl.l func_C250F7
	stz.b wTemp00
	plp
	rtl

HandleThrowItemAction:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b #$1F
	beq @lbl_C245DB
	jsl.l ThrowSelectedItem
	plp
	rtl
@lbl_C245DB:
	.db $AF,$C8,$85,$7E,$85,$00,$48,$AF,$DC,$85,$7E,$85,$01,$48,$22,$AF   ;C245DB  
	.db $59,$C3,$A5,$01,$C9,$7F,$B0,$7A,$8F,$6E,$89,$7E,$85,$00,$22,$24   ;C245EB  
	.db $08,$C3,$A5,$00,$D0,$12,$AF,$6E,$89,$7E,$85,$02,$A9,$C6,$85,$00   ;C245FB
	.db $64,$01
	jsl.l DisplayMessage
	bra @lbl_C2466D                         ;C24611
	lda #$FF                                ;C24613
	sta $00                                 ;C24615
	lda $02,s                               ;C24617
	sta $04                                 ;C24619
	lda $01,s                               ;C2461B
	sta $05                                 ;C2461D
	jsl $C62720                             ;C2461F
	lda $7E896E                             ;C24623
	sta $00                                 ;C24627
	jsl $C30823                             ;C24629
	lda #$85                                ;C2462D
	sta $02                                 ;C2462F
	lda $02,s                               ;C24631
	sta $00                                 ;C24633
	lda $01,s                               ;C24635
	sta $01                                 ;C24637
	jsl $C35BA2                             ;C24639
	lda #$1F                                ;C2463D
	sta $00                                 ;C2463F
	jsl $C24671                             ;C24641
	lda $7E896E                             ;C24645
	bpl @lbl_C2465F                         ;C24649
	lda $02,s                               ;C2464B
	sta $00                                 ;C2464D
	lda $01,s                               ;C2464F
	sta $01                                 ;C24651
	jsl $C359AF                             ;C24653
	lda $01                                 ;C24657
	cmp #$85                                ;C24659
	bne @lbl_C2466D                         ;C2465B
	lda #$80                                ;C2465D
@lbl_C2465F:
	sta $02                                 ;C2465F
	lda $02,s                               ;C24661
	sta $00                                 ;C24663
	lda $01,s                               ;C24665
	sta $01                                 ;C24667
	jsl $C35BA2                             ;C24669
@lbl_C2466D:
	pla                                     ;C2466D
	pla                                     ;C2466E
	plp                                     ;C2466F
	rtl                                     ;C24670

ThrowSelectedItem:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7E85F0
	tay
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C24683
;C24681
	.db $28,$6B
@lbl_C24683:
	sta.b wTemp00
	phx
	phy
	jsl.l PrepareSelectedThrowableItem
	ply
	plx
	lda.b wTemp00
	stz.b wTemp01
	pha
	phx
	phy
	jsl.l func_C25AFD
	ply
	plx
	pla
	cmp.b #$7F
	beq @lbl_C246AD
	stx.b wTemp00
	pha
	phy
	jsl.l RemoveItemFromCategoryShortcutSlots
	ply
	pla
	ldx.b wTemp00
	beq @lbl_C246CB
@lbl_C246AD:
	sta.b wTemp00
	lda.l $7E85C8
	sta.b wTemp02
	lda.l $7E85DC
	sta.b wTemp03
	lda.b #$13
	sta.b wTemp04
	sty.b wTemp01
	lda.l $7E898A
	sta.b wTemp05
	jsl.l ExecutePreparedThrowEffect
@lbl_C246CB:
	plp
	rtl

func_C246CD:
	php
	sep #$30 ;AXY->8
	lda.b #$01
func_C246D2:
	sta.l $7E8979
	lda.l $7E85DC
	sta.b wTemp01
	lda.l $7E85C8
	sta.b wTemp00
	jsl.l func_C359AF
	ldy.b wTemp01
	cpy.b #$83
	bne @lbl_C2470C
	jsl.l func_C24E11
	lda.b wTemp00
	beq @lbl_C24714
	.db $AF,$7C,$89,$7E,$85,$00,$48,$22,$91,$15,$C2,$68,$85,$02,$A9,$22   ;C246F4  
	.db $85,$00,$64,$01
	jsl.l DisplayMessage
@lbl_C2470C:
	.db $A9,$00,$8F,$79,$89,$7E,$28,$6B
@lbl_C24714:
	lda.l $7E8979
	dec a
	bne @lbl_C24723
	lda.b #$00
	sta.l $7E897E
	bra @lbl_C24733
@lbl_C24723:
	lda.l $7E897E
	bne @lbl_C24733
	jsl.l Get7ED5EC
	lda.b wTemp00
	sta.l $7E897E
@lbl_C24733:
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bne @lbl_C24757
	jsl.l GetShuffleDungeonIndex
	lda.b wTemp00
	cmp.b #$13
	bne @lbl_C24757
	lda.b #$98
	sta.b wTemp00
	lda.b #$08
	sta.b wTemp01
	jsl.l DisplayMessage ;print Text2200
	jsl.l func_C62437
@lbl_C24757:
	jsl.l func_C6258F
	sep #$30 ;AXY->8
	ldx.b #$12
@lbl_C2475F:
	lda.l wCharHP,x
	beq @lbl_C247B3
	lda.l wCharNPCFlags,x
	bit.b #$80
	beq @lbl_C247B3
	lda $7E8731,x
	ora $7E86E1,x
	bne @lbl_C247B3
	stx.b wTemp00
	phx
	jsr.w func_C24837
	plx
	lda.b wTemp00
	beq @lbl_C247B3
	lda.l wCharType,x
	cmp.b #97
	bne @lbl_C2478F
	jsr.w func_C247CE
	bra @lbl_C247B3
@lbl_C2478F:
	cmp.b #103
	bne @lbl_C24798
	jsr.w func_C247E3
	bra @lbl_C247B3
@lbl_C24798:
	cmp.b #80
	bne @lbl_C247A1
	jsr.w func_C247F8
	bra @lbl_C247B3
@lbl_C247A1:
	cmp.b #82
	bne @lbl_C247AA
	jsr.w func_C2480D
	bra @lbl_C247B3
@lbl_C247AA:
	cmp.b #96
	bne @lbl_C247B3
	jsr.w func_C24822
	bra @lbl_C247B3
@lbl_C247B3:
	dex
	bpl @lbl_C2475F
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #8
	bne @lbl_C247CC
	SetEvent Event8A 2
@lbl_C247CC:
	plp
	rtl

func_C247CE:
	phx
	lda.l wCharEventFlags,x
	cmp.b #5
	bne @lbl_C247E1
	sta.b wTemp02
	lda.b #3
	sta.b wTemp00
	jsl.l _SetEvent
@lbl_C247E1:
	plx
	rts

func_C247E3:
	phx
	lda.l wCharEventFlags,x
	cmp.b #4
	bne @lbl_C247F6
	sta.b wTemp02
	lda.b #5
	sta.b wTemp00
	jsl.l _SetEvent
@lbl_C247F6:
	plx
	rts

func_C247F8:
	phx
	lda.l wCharEventFlags,x
	cmp.b #6
	bne @lbl_C2480B
	sta.b wTemp02
	lda.b #6
	sta.b wTemp00
	jsl.l _SetEvent
@lbl_C2480B:
	plx
	rts

func_C2480D:
	phx
	lda.l wCharEventFlags,x
	cmp.b #3
	bne @lbl_C24820
	sta.b wTemp02
	lda.b #9
	sta.b wTemp00
	jsl.l _SetEvent
@lbl_C24820:
	plx
	rts

func_C24822:
	phx
	lda.l wCharEventFlags,x
	cmp.b #$01
	bne @lbl_C24835
	sta.b wTemp02
	lda.b #$0C
	sta.b wTemp00
	jsl.l _SetEvent
@lbl_C24835:
	plx
	rts

func_C24837:
	php 
	sep #$30 ;AXY->8
	ldx.b wTemp00
	phx
	jsl.l func_C27C6D
	plx
	lda.b wTemp00
	beq func_C2484C
	lda.b #1
	sta.b wTemp00
	plp 
	rts

func_C2484C:
	lda.l $7E87D0
	cmp.b #16
	bne func_C24860
	cmp.l $7E87BD,x
	bne func_C24860
	lda.b #1
	sta.b wTemp00
	plp 
	rts

func_C24860:
	stx.b wTemp00
	jsl.l func_C277F8
	lda.b wTemp00
	cmp.b #5
	bcs @lbl_C24872
	lda.b #1
	sta.b wTemp00
	plp 
	rts
@lbl_C24872:
	stz.b wTemp00
	plp 
	rts

func_C24876:
	php 
	sep #$30 ;AXY->8
	lda.b #2
	jmp.w func_C246D2 

func_C2487E:
	php
	sep #$30 ;AXY->8
	stz.b wTemp00
	plp
	rtl
	.db $22,$E6,$27,$C6
	.db $A5,$00,$18,$69,$E1,$A8,$A2,$00,$BF,$4F,$89,$7E   ;C24885
	.db $30,$11,$85,$00,$DA,$5A,$22,$10,$07,$C3,$7A,$FA,$C4,$01,$F0,$07   ;C24895
	.db $E8,$80,$E9,$64,$00,$28,$6B,$A9   ;C248A5
	;C248AD
	.db $01,$85,$00,$28
	.db $6B

func_C248B2:
	php
	sep #$30 ;AXY->8
	ldx.b #$00
	ldy.b wTemp00
@lbl_C248B9:
	lda.l wShirenStatus.itemAmounts,x
	bmi @lbl_C248D2
	sta.b wTemp00
	pha
	phx
	phy
	jsl.l func_C30710
	ply
	plx
	pla
	cpy.b wTemp01
	beq @lbl_C248D2
	inx
	bra @lbl_C248B9
@lbl_C248D2:
	sta.b wTemp00
	stx.b wTemp01
	plp
	rtl

HandleUnderfootItemPickupAction:
	php
	sep #$30 ;AXY->8
	lda.l $7E85DC
	xba
	lda.l $7E85C8
	rep #$20 ;A->16
	sta.b wTemp00
	pha
	jsl.l func_C359AF
	pla
	ldy.b wTemp01
	bmi @lbl_C24908
	sty.b wTemp00
	stz.b wTemp01
	sta.b wTemp02
	jsl.l func_C2598A
	sep #$20 ;A->8
	lda.b wTemp01
	cmp.b #$02
	beq @lbl_C24941
	sta.b wTemp00
	plp
	rtl
@lbl_C24908:
	sep #$20 ;A->8
	tya
	cmp.b #$C0
	bcc @lbl_C24931
	.db $48,$09,$20,$85,$02,$AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85,$7E,$85   ;C2490F
	.db $01,$22,$A2,$5B,$C3,$68,$29,$1F,$85,$00,$22,$1F,$D4,$C3,$64,$00   ;C2491F  
	.db $28,$6B                           ;C2492F
@lbl_C24931:
	sep #$20 ;A->8
	cmp.b #$86
	beq @lbl_C2494D
	lda.b #$CA
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
@lbl_C24941:
	sep #$20 ;A->8
	jsl.l func_C28FBC
	lda.b #$02
	sta.b wTemp00
	plp
	rtl
@lbl_C2494D:
	.db $A9,$13,$85,$00,$A9,$10,$85,$02,$22,$F6,$26,$C6,$A9,$13,$85,$00   ;C2494D
	.db $22,$90,$43,$C2,$64,$00,$28,$6B   ;C2495D  

DispatchPlayerActionCommand:
	php
	sep #$30 ;AXY->8
	jsl.l HandlePlayerActionCommand
	lda.l $7E89B3
	beq @lbl_C2498A
	lda.b wTemp00
	pha
	lda.b #$00
	sta.l $7E89B3
	lda.b #$2F
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage
	pla
	sta.b wTemp00
@lbl_C2498A:
	plp
	rtl

HandlePlayerActionCommand:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.w $89B7
	beq @lbl_C249A9
	dec a
	bne @lbl_C249A2
;C2499B  
	.db $9C,$B7,$89,$64,$00,$28,$6B
@lbl_C249A2:
	stz.w $89B7
	lda.b #$18
	sta.b wTemp00
@lbl_C249A9:
	lda.w $8977
	beq @lbl_C249B1
	jmp.w @lbl_C24B24
@lbl_C249B1:
	lda.b wTemp02
	sta.w $899F
	ldx.w $86F4
	beq @lbl_C249DB
	.db $CA,$8E,$F4,$86,$F0,$0C,$A9,$3E,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $80,$0A,$A9,$6D,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B   ;C249CB  
@lbl_C249DB:
	lda.w $89B3
	beq @lbl_C249E5
	phb
	jsr.w func_C24D8B
	plb
@lbl_C249E5:
	lda.w $8998
	lsr a
	bcc @lbl_C249EF
	stz.b wTemp00
	plp
	rtl
@lbl_C249EF:
	lda.w $885C
	ora.w $8744
	beq @lbl_C249FB
	stz.b wTemp00
	plp
	rtl
@lbl_C249FB:
	lda.w $89A7
	beq @lbl_C24A3E
	.db $3A,$8D,$A7,$89,$F0,$1E,$A9,$F7,$85,$00,$64,$01,$A9,$13,$85,$02   ;C24A00
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$A9,$C3,$85,$02,$22,$65,$25,$C6   ;C24A10  
	.db $64,$00,$28,$6B,$A9,$F8,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $C2,$20   ;C24A20  
	.db $AF,$45,$89,$7E,$8F,$43,$89,$7E   ;C24A30  
	.db $E2,$20,$64,$00,$28,$6B           ;C24A38
@lbl_C24A3E:
	lda.w $88C0
	beq @lbl_C24A5C
	.db $A9,$13,$85,$00,$20,$44,$7D,$28,$6B,$A9,$01,$85,$00,$A9,$01,$85   ;C24A43
	.db $01
	jsl.l DisplayMessage
	.db $64,$00,$28   ;C24A53  
	.db $6B                               ;C24A5B
@lbl_C24A5C:
	lda.b wTemp00
	; Fixed commands use dedicated byte values. Other commands use a packed format:
	; upper 3 bits = action family, lower 5 bits = operand/direction.
	; Known fixed-command sources:
	; $1B = inventory sort action.
	; $18 = A-button action using the current facing.
	; $1C = A+B fixed action.
	; $1D = L-button fixed action.
	; $5F = context-sensitive underfoot-item pickup action from the X-button path.
	cmp.b #$1B
	bne @lbl_C24A6C
	jsl.l SortShirenInventory
	lda.b #$02
	sta.b wTemp00
	plp
	rtl
@lbl_C24A6C:
	cmp.b #$1C
	bne @lbl_C24A7A
	jsl.l func_C602A6
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C24A7A:
	cmp.b #$18
	bne @lbl_C24A84
	jsl.l func_C24E65
	bra @lbl_C24AF3
@lbl_C24A84:
	cmp.b #$5F
	bne @lbl_C24A8E
	jsl.l HandleUnderfootItemPickupAction
	plp
	rtl
@lbl_C24A8E:
	cmp.b #$19
	bne @lbl_C24AA3
	lda.l $7E899B
	beq @lbl_C24AA1
	lda.b #$01
	sta.l $7E899B
	jsr.w func_C230F6
@lbl_C24AA1:
	bra @lbl_C24AF3
@lbl_C24AA3:
	cmp.b #$1A
	bne @lbl_C24AAD
	jsl.l func_C246CD
	bra @lbl_C24AF3
@lbl_C24AAD:
	cmp.b #$1D
	bne @lbl_C24AB7
	jsl.l HandleArrowShortcutAction
	plp
	rtl
@lbl_C24AB7:
	tax
	and.b #$1F
	tay
	txa
	and.b #$E0
	cmp.b #$C0
	beq @lbl_C24AD5
	cmp.b #$A0
	beq @lbl_C24ACF
	cmp.b #$60
	bne @lbl_C24ADD
	; Shiren's requested move/facing direction is stored in his wCharDir slot.
	lda.w wCharDir+CharDataShirenIndex
	sta.b wTemp01
@lbl_C24ACF:
	lda.w wCharDir+CharDataShirenIndex
	sta.w $899F
@lbl_C24AD5:
	sty.b wTemp00
	jsl.l HandleCategoryShortcutSelectionAction
	bra @lbl_C24AF3
@lbl_C24ADD:
	cmp.b #$40
	bne @lbl_C24AE9
	sty.b wTemp00
	jsl.l DropSelectedInventoryItem
	plp
	rtl
@lbl_C24AE9:
	cmp.b #$80
	bne @lbl_C24AF7
	sty.b wTemp00
	jsl.l HandleThrowItemAction
@lbl_C24AF3:
	stz.b wTemp00
	plp
	rtl
@lbl_C24AF7:
	tya
	bit.b #$10
	beq @lbl_C24B0B
	; Packed direction|$10 means "change facing only" without committing movement.
	; Directions use the 0-7 enum in constants/npc.asm: even = cardinal, odd = diagonal.
	and.b #$07
	sta.w wCharDir+CharDataShirenIndex
	jsl.l func_C28FBC
	lda.b #$02
	sta.b wTemp00
	plp
	rtl
@lbl_C24B0B:
	ldx.w $86CC
	beq @lbl_C24B18
	jsl.l Random
	lda.b wTemp00
	and.b #$07
@lbl_C24B18:
	bit.b #$08
	beq @lbl_C24B21
	; Packed direction|$08 stores an alternate movement family in $8977 before
	; falling through to the normal movement resolution path.
	sta.w $8977
	and.b #$07
@lbl_C24B21:
	sta.w wCharDir+CharDataShirenIndex
@lbl_C24B24:
	lda.b #CharDataShirenIndex
	sta.b wTemp00
	call_savebank func_C2785E
	lda.b wTemp00
	bmi @lbl_C24B34
	bra @lbl_C24B94
@lbl_C24B34:
	lda.b wTemp02
	bmi @lbl_C24B3B
	jmp.w @lbl_C24BE8
@lbl_C24B3B:
	lda.b wTemp03
	bpl @lbl_C24B72
	lda.b wTemp02
	and.b #$F0
	cmp.b #$F0
	beq @lbl_C24B72
	ldy.w $87BC
	cpy.b #$21
	beq @lbl_C24B70
	cpy.b #$02
	bne @lbl_C24B59
;C24B52  
	.db $AC,$2C,$86,$C0,$03,$F0,$17
@lbl_C24B59:
	ldy.w $87D0
	bmi @lbl_C24B6E
	ldy.w $898E
	beq @lbl_C24B72
	.db $AC,$EE,$D5,$C0,$0A,$F0,$08,$C0   ;C24B63  
	.db $0C,$F0,$04                       ;C24B6B  
@lbl_C24B6E:
	.db $C9,$B0
@lbl_C24B70:
	beq @lbl_C24BE8
@lbl_C24B72:
	lda.w wCharDir+CharDataShirenIndex
	lsr a
	bcc @lbl_C24B92
	and.b #$03
	ldy.b wTemp06
	bmi @lbl_C24B80
	ora.b #$04
@lbl_C24B80:
	ldy.b wTemp07
	bmi @lbl_C24B86
	ora.b #$08
@lbl_C24B86:
	tax
	lda.l UNREACH_C24D7B,x
	bmi @lbl_C24B92
	sta.w wCharDir+CharDataShirenIndex
	bra @lbl_C24B24
@lbl_C24B92:
	bra @lbl_C24BD1
@lbl_C24B94:
	tax
	lda.w wCharNPCFlags,x
	bit.b #$08
	beq @lbl_C24BD1
	lda.w $8977
	bmi @lbl_C24BD1
	beq @lbl_C24BD1
	lda.w $8758
	bne @lbl_C24BD1
	stz.w $8977
	txa
	sta.w $897F
	lda.w wCharDir+CharDataShirenIndex
	clc
	adc.b #$04
	and.b #$07
	sta.w wCharDir,x
	phx
	lda.b #CharDataShirenIndex
	sta.b wTemp01
	stx.b wTemp00
	jsl.l func_C289F5
	plx
	lda.l wCharDir+CharDataShirenIndex
	sta.l wCharDir,x
	jmp.w func_C24DDD
@lbl_C24BD1:
	lda.w $8977
	stz.w $8977
	bmi @lbl_C24BE2
	lda.w $86CC
	bne @lbl_C24BE2
	jsl.l func_C28FBC
@lbl_C24BE2:
	lda.b #$02
	sta.b wTemp00
	plp
	rtl
@lbl_C24BE8:
	lda.w $8977
	beq @lbl_C24BF2
	lda.b #$FF
	sta.w $8977
@lbl_C24BF2:
	lda.w $8758
	beq @lbl_C24C08
	stz.w $8977
	lda.b #$80
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	stz.b wTemp00
	plp
	rtl
@lbl_C24C08:
	rep #$30 ;AXY->16
	ldy.b wTemp00
	lda.b wTemp02
	pha
	lda.b wTemp04
	pha
	phy
	call_savebank func_C24E11
	ply
	pla
	sta.b wTemp04
	pla
	sta.b wTemp02
	lda.b wTemp00
	sty.b wTemp00
	sep #$30 ;AXY->8
	cmp.b #$00
	beq @lbl_C24C49
	.db $9C,$77,$89,$AF,$7C,$89,$7E,$85,$00,$48,$22,$91,$15,$C2,$68,$85   ;C24C2A  
	.db $02,$A9,$22,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B       ;C24C42  
@lbl_C24C49:
	lda.w $8949
	beq @lbl_C24C6F
	.db $C2,$30,$A4,$00,$22,$5F,$F6,$C3,$A5,$00,$84,$00,$E2,$30,$29,$0F   ;C24C4E
	.db $D0,$0F,$9C,$77,$89,$A9,$13,$85,$00,$22,$90,$43,$C2,$64,$00,$28   ;C24C5E  
	.db $6B                               ;C24C6E
@lbl_C24C6F:
	rep #$20 ;A->16
	lda.b wTemp04
	ldx.b wTemp02
	ldy.b wTemp01
	bmi @lbl_C24CCC
	phx
	phy
	sty.b wTemp00
	pha
	phy
	jsl.l func_C33AD5
	ply
	pla
	ldx.b wTemp00
	cpx.b #$00
	beq @lbl_C24C9A
	ldx.w $899B
	bne @lbl_C24C93
	sty.w $897A
@lbl_C24C93:
	ldx.b #$00
	stx.w $8977
	bra @lbl_C24CCA
@lbl_C24C9A:
	ldx.w $87BC
	cpx.b #$2D
	bne @lbl_C24CAB
	.db $84,$00,$48,$8B,$22,$DE,$12,$C3   ;C24CA1  
	.db $AB,$68                           ;C24CA9
@lbl_C24CAB:
	sty.b wTemp00
	ldx.w $8977
	stx.b wTemp01
	sta.b wTemp02
	pha
	call_savebank func_C2598A
	pla
	ldx.b #$00
	stx.w $8977
	ldx.b wTemp00
	beq @lbl_C24CCA
;C24CC5
	.db $68,$64,$00,$28,$6B
@lbl_C24CCA:
	ply
	plx
@lbl_C24CCC:
	pha
	sep #$20 ;A->8
	txa
	bmi @lbl_C24CDD
	bit.b #$40
	beq @lbl_C24CE2
	lda.w $87D0
	bit.b #$10
	beq @lbl_C24CE2
@lbl_C24CDD:
	ldx.b #$00
	stx.w $8977
@lbl_C24CE2:
	cpy.b #$86
	beq @lbl_C24CF4
	cpy.b #$C0
	bcc @lbl_C24CF9
	ldx.w $894A
	bne @lbl_C24D09
	ldx.w $87BC
	bne @lbl_C24D09
@lbl_C24CF4:
	sty.w $897B
	bra @lbl_C24D09
@lbl_C24CF9:
	cpy.b #$84
	bne @lbl_C24D02
	sty.w $897B
	bra @lbl_C24D09
@lbl_C24D02:
	cpy.b #$83
	bne @lbl_C24D0E
	sty.w $897A
@lbl_C24D09:
	ldx.b #$00
	stx.w $8977
@lbl_C24D0E:
	rep #$20 ;A->16
	pla
	ldy.b #CharDataShirenIndex
	sty.b wTemp00
	sta.b wTemp02
	jsl.l func_C27951
	sep #$30 ;AXY->8
	lda.l $7E898B
	beq @lbl_C24D75
	.db $22,$5F,$F6,$C3,$A5,$00,$29,$0F,$D0,$48,$AF,$C8,$85,$7E,$85,$00   ;C24D23  
	.db $AF,$DC,$85,$7E,$85,$01,$22,$AF,$59,$C3,$A5,$01,$C9,$80,$D0,$32   ;C24D33  
	.db $A5,$02,$30,$2E,$22,$1C,$3B,$C2,$A4,$00,$C0,$FF,$F0,$24,$84,$02   ;C24D43  
	.db $AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85,$7E,$85,$01,$22,$A2,$5B,$C3   ;C24D53  
	.db $84,$02,$A9,$D9,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $A9,$00,$8F,$77   ;C24D63  
	.db $89,$7E                           ;C24D73
@lbl_C24D75:
	ldx.b #$01
	stx.b wTemp00
	plp
	rtl

UNREACH_C24D7B:
	.db $FF,$FF,$FF,$FF,$00               ;C24D7B  
	.db $04,$04,$00,$02,$02,$06           ;C24D80
	.db $06,$FF,$FF,$FF,$FF               ;C24D86  

func_C24D8B:
	php
	sep #$30 ;AXY->8
	ldx.b #$FF
@lbl_C24D90:
	inx
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C24D90
	dex
	bpl @lbl_C24DA2
;C24D9A
	.db $A9,$1C,$85,$00,$64,$01,$28,$60
@lbl_C24DA2:
	stz.b wTemp00
	stx.b wTemp01
	phx
	jsl.l func_C3F69F
	plx
	ldy.b wTemp00
	stz.b wTemp00
	stx.b wTemp01
	phy
	jsl.l func_C3F69F
	ply
	lda.b wTemp00
	tax
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	phx
	phy
	jsl.l func_C30710
	ply
	plx
	lda.b wTemp00
	cmp.b #$07
	bne @lbl_C24DD4
;C24DCF  
	.db $AF,$F0,$85,$7E,$A8
@lbl_C24DD4:
	txa
	ora.b #$A0
	sta.b wTemp00
	sty.b wTemp01
	plp
	rts

func_C24DDD:
	sep #$30 ;AXY->8
	jsr.w func_C24DE8
	lda.b #$03
	sta.b wTemp00
	plp
	rtl

func_C24DE8:
	php
	sep #$30 ;AXY->8
	lda.l $7E85C8
	sta.b wTemp00
	lda.l $7E85DC
	sta.b wTemp01
	jsl.l func_C359AF
	lda.b wTemp01
	cmp.b #$84
	bne @lbl_C24E07
;C24E01  
	.db $8F,$7B,$89,$7E,$28,$60
@lbl_C24E07:
	cmp.b #$83
	bne @lbl_C24E0F
;C24E0B  
	.db $8F,$7A,$89,$7E
@lbl_C24E0F:
	plp
	rts

func_C24E11:
	php
	sep #$30 ;AXY->8
	lda.l $7E897C
	bmi @lbl_C24E61
	.db $AA,$BF,$F1,$85,$7E,$F0,$3A,$BF,$A1,$85,$7E,$C9,$0B,$D0,$32,$BF   ;C24E1A
	.db $81,$87,$7E,$F0,$2C,$BF,$E1,$86,$7E,$1F,$31,$87,$7E,$1F,$B9,$86   ;C24E2A  
	.db $7E,$1F,$A5,$86,$7E,$1F,$CD,$86,$7E,$1F,$49,$88,$7E,$D0,$12,$86   ;C24E3A  
	.db $00,$22,$5E,$78,$C2,$A5,$00,$C9,$13,$D0,$06,$A9,$01,$85,$00,$28   ;C24E4A
	.db $6B,$A9,$FF,$8F,$7C,$89,$7E       ;C24E5A
@lbl_C24E61:
	stz.b wTemp00
	plp
	rtl

func_C24E65:
	php
	sep #$30 ;AXY->8
	lda.l $7E86CC
	beq @lbl_C24E7A
	.db $22,$5F,$F6,$C3,$A5,$00,$29,$07   ;C24E6E  
	.db $8F,$F0,$85,$7E                   ;C24E76  
@lbl_C24E7A:
	lda.l $7E87BC
	cmp.b #$00
	beq @lbl_C24E85
	jmp.w func_C25092
@lbl_C24E85:
	lda.l $7E89A3
	bit.b #$01
	bne @lbl_C24E90
	jmp.w func_C24F17
@lbl_C24E90:
	lda #$00                                ;C24E90
	pha                                     ;C24E92
	lda #$FF                                ;C24E93
	pha                                     ;C24E95
	lda #$FF                                ;C24E96
	pha                                     ;C24E98
	lda #$01                                ;C24E99
	pha                                     ;C24E9B
	bra @lbl_C24EE5                         ;C24E9C
@lbl_C24E9E:
	clc                                     ;C24E9E
	adc $7E85F0                             ;C24E9F
	and #$07                                ;C24EA3
	sta $7E85F0                             ;C24EA5
	lda #$13                                ;C24EA9
	sta $00                                 ;C24EAB
	jsl $C2785E                             ;C24EAD
	rep #$20                                ;C24EB1
	lda $04                                 ;C24EB3
	sta $00                                 ;C24EB5
	sep #$20                                ;C24EB7
	jsl $C359AF                             ;C24EB9
	lda $02                                 ;C24EBD
	asl a                                   ;C24EBF
	and $02                                 ;C24EC0
	bmi @lbl_C24EE5                         ;C24EC2
	lda $00                                 ;C24EC4
	bmi @lbl_C24EE5                         ;C24EC6
	tax                                     ;C24EC8
	lda $7E8835,x                           ;C24EC9
	bne @lbl_C24EE5                         ;C24ECD
	lda $7E89A0                             ;C24ECF
	sta $7E89A1                             ;C24ED3
	lda $7E8730                             ;C24ED7
	sta $7E89A0                             ;C24EDB
	lda $00                                 ;C24EDF
	sta $7E8730                             ;C24EE1
@lbl_C24EE5:
	pla                                     ;C24EE5
	bne @lbl_C24E9E                         ;C24EE6
	lda $7E85F0                             ;C24EE8
	inc a                                   ;C24EEC
	and #$07                                ;C24EED
	sta $7E85F0                             ;C24EEF
	lda $7E8730                             ;C24EF3
	.db $30,$1E   ;C24EF7
	sta $7E897F                             ;C24EF9
	jsl $C602A6                             ;C24EFD
	lda #$01                                ;C24F01
	sta $7E89BA                             ;C24F03
	lda #$13                                ;C24F07
	sta $00                                 ;C24F09
	jsl $C2121A                             ;C24F0B
	lda #$00                                ;C24F0F
	sta $7E89BA                             ;C24F11
	plp                                     ;C24F15
	rtl                                     ;C24F16

func_C24F17:
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2785E
	lda.b wTemp00
	bmi @lbl_C24F55
	tax
	lda.l wCharNPCFlags,x
	bne @lbl_C24F4D
	txa
	sta.l $7E8730
	sta.l $7E897F
	jsl.l func_C602A6
	lda.b #$01
	sta.l $7E89BA
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2121A
	lda.b #$00
	sta.l $7E89BA
	plp
	rtl
@lbl_C24F4D:
	stx.b wTemp00
	jsl.l func_C29005
	plp
	rtl
@lbl_C24F55:
	lda.b wTemp02
	cmp.b #$B0
	bne @lbl_C24F93
	lda.l wCharDir+CharDataShirenIndex
	; Bit 0 set means Shiren is facing diagonally.
	bit.b #$01
	bne @lbl_C24F93
	sta.b wTemp00
	lda.b #$02
	sta.b wTemp01
	lda.l wCharXPos+CharDataShirenIndex
	sta.b wTemp02
	lda.l wCharYPos+CharDataShirenIndex
	sta.b wTemp03
	jsl.l func_C32FEE
	ldx.b wTemp00
	bmi @lbl_C24F8B
	lda.l wCharNPCFlags,x
	beq @lbl_C24F8B
	stx.b wTemp00
	jsl.l func_C29005
	plp
	rtl
@lbl_C24F8B:
	lda.b #CharDataShirenIndex
	sta.b wTemp00
	jsl.l func_C2785E
@lbl_C24F93:
	lda.b wTemp01
	and.b #$E0
	cmp.b #$A0
	bne @lbl_C24FAF
	lda.l wCharDir+CharDataShirenIndex
	cmp.b #$02
	bne @lbl_C24FAF
	lda.b wTemp01
	and.b #$1F
	sta.b wTemp00
	jsl.l func_C14D64
	plp
	rtl
@lbl_C24FAF:
	ldx.b wTemp04
	ldy.b wTemp05
	lda.b wTemp01
	pha
	lda.b wTemp02
	pha
	lda.b #$13
	sta.b wTemp00
	lda.b #$82
	sta.b wTemp02
	lda.l $7E87BC
	cmp.b #$00
	beq @lbl_C24FCD
;C24FC9
	.db $A9,$00,$85,$02
@lbl_C24FCD:
	phx
	phy
	jsl.l func_C62550
	ply
	plx
	phx
	phy
	jsl.l func_C602A6
	ply
	plx
	pla
	bmi @lbl_C24FF7
	pla
	cmp.b #$C0
	bcc @lbl_C24FF5
	bit.b #$20
	bne @lbl_C24FF5
	.db $09,$20,$85,$02,$86,$00,$84,$01   ;C24FE9
	.db $22,$A2,$5B,$C3                   ;C24FF1  
@lbl_C24FF5:
	plp
	rtl
@lbl_C24FF7:
	pla
	lda.l $7E89A2
	and.b #$20
	beq @lbl_C25002
	lda.b #$01
@lbl_C25002:
	sta.b wTemp03
	stx.b wTemp00
	sty.b wTemp01
	lda.l wCharDir+CharDataShirenIndex
	sta.b wTemp02
	stz.b wTemp04
	jsr.w func_C2501C
	cpx.b #$02
	bcc @lbl_C2501A
	jsr.w func_C25056
@lbl_C2501A:
	plp
	rtl

func_C2501C:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	jsl.l func_C36829
	pla
	ldx.b wTemp00
	beq @lbl_C25051
	cpx.b #$03
	bne @lbl_C2503E
	.db $48,$A9,$37,$01,$85,$00,$DA
	jsl.l DisplayMessage
	.db $FA,$68               ;C25039  
@lbl_C2503E:
	sta.b wTemp04
	sta.b wTemp06
	lda.l func_C25052,x
	and.w #$00FF
	sta.b wTemp02
	phx
	jsl.l func_C626DF
	plx
@lbl_C25051:
	plp

func_C25052:
	rts
	.db $84                               ;C25053  
	.db $85,$86                           ;C25054

func_C25056:
	php
	sep #$30 ;AXY->8
	lda.l $7E8970
	sta.b wTemp00
	jsl.l func_C34044
	lda.b wTemp00
	bne @lbl_C25090
	.db $AF,$70,$89,$7E,$A2,$FF,$E8,$DF,$4F,$89,$7E,$D0,$F9,$86,$00,$48   ;C25067  
	.db $22,$4D,$3C,$C2,$68,$A2,$DA,$86,$00,$64,$01,$85,$02,$48
	jsl.l DisplayMessage
	.db $68,$85,$00,$22,$F4,$06   ;C25087  
	.db $C3                               ;C2508F  
@lbl_C25090:
	plp
	rts

func_C25092:
	sep #$30 ;AXY->8
	jsl.l func_C602A6
	lda.l $7E87BC
	cmp.b #$04
	beq func_C250F8
	cmp.b #$22
	beq func_C250F8
	cmp.b #$2E
	beq func_C250F8
	cmp.b #$1C
	beq func_C250F8
	cmp.b #$02
	beq func_C250F8
	cmp.b #$21
	beq func_C250F8
	cmp.b #$05
	beq func_C250F8
	cmp.b #$0A
	beq func_C250F8
	cmp.b #$09
	beq func_C250F8
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2785E
	lda.b wTemp00
	bpl func_C25140
	lda.b #$13
	sta.b wTemp00
	lda.b #$00
	sta.b wTemp02
	jsl.l func_C62550
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2785E
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	lda.l $7E85F0
	sta.b wTemp02
	stz.b wTemp03
	stz.b wTemp04
	jsr.w func_C2501C
	plp
	rtl

func_C250F7:
	php
func_C250F8:
	sep #$30 ;AXY->8
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2785E
	lda.b wTemp00
	pha
	jsr.w func_C25152
	sep #$30 ;AXY->8
	lda.b wTemp00
	bne @lbl_C25111
	pla
	plp
	rtl
@lbl_C25111:
	lda.l $7E86CC
	beq @lbl_C2512F
	.db $22,$5F,$F6,$C3,$A5,$00,$29,$07,$8F,$F0,$85,$7E,$A9,$13,$85,$00   ;C25117  
	.db $22,$5E,$78,$C2,$A5,$00,$83,$01   ;C25127  
@lbl_C2512F:
	pla
	bpl func_C25140
	lda.b #$13
	sta.b wTemp00
	lda.b #$00
	sta.b wTemp02
	jsl.l func_C62550
	plp
	rtl
func_C25140:
	sta.l $7E8730
	sta.l $7E897F
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2121A
	plp
	rtl

func_C25152:
	sep #$30 ;AXY->8
	lda.l $7E87BC
	cmp.b #$14
	bne @lbl_C25190
	.db $AF,$2C,$86,$7E,$3A,$D0,$0F,$A9,$FF,$85,$01,$A9,$13,$85,$00,$22   ;C2515C  
	.db $D3,$24,$C2,$64,$00,$60,$20,$DE,$58,$A6,$00,$30,$EA,$AF,$2C,$86   ;C2516C  
	.db $7E,$C9,$03,$B0,$0A,$DA,$22,$6D,$7C,$C2,$FA,$A5,$00,$F0,$D8,$8A   ;C2517C  
	.db $09,$40,$80,$D5                   ;C2518C
@lbl_C25190:
	cmp.b #$22
	bne @lbl_C2519F
	.db $A9,$13,$85,$00,$22,$B8,$1E,$C2   ;C25194
	.db $64,$00,$60                       ;C2519C  
@lbl_C2519F:
	cmp.b #$04
	beq @lbl_C251A7
	cmp.b #$2E
	bne @lbl_C251B2
@lbl_C251A7:
	.db $A9,$13,$85,$00,$22,$08,$1C,$C2   ;C251A7
	.db $64,$00,$60                       ;C251AF  
@lbl_C251B2:
	cmp.b #$25
	bne @lbl_C251C5
	.db $A9,$13,$85,$00,$A9,$40,$85,$01   ;C251B6
	.db $22,$60,$1E,$C2,$64,$00,$60       ;C251BE  
@lbl_C251C5:
	cmp.b #$2A
	bne @lbl_C2521E
	lda.l $7E85C8
	sta.b wTemp00
	lda.l $7E85DC
	sta.b wTemp01
	jsl.l func_C359AF
	lda.b wTemp01
	cmp.b #$C0
	bcs @lbl_C251E3
	cmp.b #$80
	bne @lbl_C25214
@lbl_C251E3:
	jsl.l func_C3D3AB
	lda.b wTemp00
	ora.b #$E0
	sta.b wTemp02
	lda.l $7E85C8
	sta.b wTemp00
	lda.l $7E85DC
	sta.b wTemp01
	jsl.l func_C35BA2
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C21591
	lda.b #$FD
	sta.b wTemp00
	lda.b #$00
	sta.b wTemp01
@lbl_C2520D:
	jsl.l DisplayMessage
	stz.b wTemp00
	rts
@lbl_C25214:
	lda.b #$FE
	sta.b wTemp00
	lda.b #$00
	sta.b wTemp01
	bra @lbl_C2520D
@lbl_C2521E:
	cmp.b #$16
	bne @lbl_C25261
	.db $A9,$13,$85,$00,$A9,$17,$85,$02,$22,$F6,$26,$C6,$A9,$13,$85,$00   ;C25222
	.db $22,$91,$15,$C2,$A9,$D6,$85,$00,$64,$01,$A9,$13,$85,$02,$85,$03   ;C25232  
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$AF,$2C,$86,$7E,$AA,$BF,$5D,$52   ;C25242  
	.db $C2,$85,$02,$64,$03,$22,$09,$32   ;C25252
	.db $C2,$64,$00,$60,$32,$32,$32       ;C2525A
@lbl_C25261:
	cmp.b #$2D
	bne @lbl_C252A4
	.db $A9,$13,$85,$00,$22,$91,$15,$C2,$A9,$40,$85,$00,$A9,$01,$85,$01   ;C25265
	.db $64,$02,$22,$51,$03,$C3,$A5,$00,$30,$22,$85,$00,$AF,$F0,$85,$7E   ;C25275  
	.db $85,$01,$AF,$C8,$85,$7E,$85,$02,$AF,$DC,$85,$7E,$85,$03,$A9,$13   ;C25285  
	.db $85,$04,$AF,$8A,$89,$7E,$85,$05   ;C25295  
	.db $22,$82,$33,$C3,$64,$00,$60       ;C2529D  
@lbl_C252A4:
	cmp.b #$0D
	bne @lbl_C252D5
	.db $A6,$00,$A9,$13,$85,$00,$DA,$22,$91,$15,$C2,$FA,$A9,$28,$85,$00   ;C252A8  
	.db $64,$01,$A9,$13,$85,$02,$DA
	jsl.l DisplayMessage
	.db $FA,$E0,$00,$30,$0A   ;C252B8  
	.db $86,$00,$A9,$FF,$85,$01,$22,$79   ;C252C8  
	.db $35,$C2,$64,$00,$60               ;C252D0  
@lbl_C252D5:
	cmp.b #$06
	bne @lbl_C25347
	jsr $58DE                               ;C252D9
	lda $00                                 ;C252DC
	bmi @lbl_C252FE                         ;C252DE
	lda $7E862C                             ;C252E0
	tax                                     ;C252E4
	lda $C25343,x                           ;C252E5
	cmp $01                                 ;C252E9
	bcc @lbl_C252FE                         ;C252EB
	lda $00                                 ;C252ED
	ora #$40                                ;C252EF
	sta $01                                 ;C252F1
	lda #$13                                ;C252F3
	sta $00                                 ;C252F5
	jsl $C21DBD                             ;C252F7
	stz $00                                 ;C252FB
	rts                                     ;C252FD
@lbl_C252FE:
	ldx #$13                                ;C252FE
	stx $00                                 ;C25300
	jsl $C21591                             ;C25302
	lda #$7F                                ;C25306
	sta $00                                 ;C25308
	lda #$0D                                ;C2530A
	sta $01                                 ;C2530C
	lda #$02                                ;C2530E
	sta $02                                 ;C25310
	lda $7E85F0                             ;C25312
	sta $03                                 ;C25316
	tax                                     ;C25318
	lda $7E85C8                             ;C25319
	sta $04                                 ;C2531D
	clc                                     ;C2531F
	adc $C27915,x                           ;C25320
	clc                                     ;C25324
	adc $C27915,x                           ;C25325
	sta $06                                 ;C25329
	lda $7E85DC                             ;C2532B
	sta $05                                 ;C2532F
	clc                                     ;C25331
	adc $C27917,x                           ;C25332
	clc                                     ;C25336
	adc $C27917,x                           ;C25337
	sta $07                                 ;C2533B
	jsl $C626CA                             ;C2533D
	stz $00                                 ;C25341
	rts                                     ;C25343
	.db $02   ;C25344
	ora $0A                                 ;C25345
@lbl_C25347:
	cmp.b #$29
	bne @lbl_C25376
	.db $A2,$13,$86,$00,$22,$91,$15,$C2,$A9,$13,$85,$00,$22,$5E,$78,$C2   ;C2534B
	.db $C2,$20,$A5,$04,$85,$00,$E2,$20,$AF,$F0,$85,$7E,$85,$02,$A9,$01   ;C2535B
	.db $85,$03,$85,$04,$22,$29,$68,$C3   ;C2536B  
	.db $64,$00,$60                       ;C25373  
@lbl_C25376:
	cmp.b #$11
	bne @lbl_C253C3
	.db $A9,$13,$85,$00,$22,$91,$15,$C2,$AF,$2C,$86,$7E,$AA,$BF,$BF,$53   ;C2537A
	.db $C2,$85,$00,$A9,$01,$85,$01,$64,$02,$22,$51,$03,$C3,$A5,$00,$30   ;C2538A
	.db $22,$85,$00,$AF,$F0,$85,$7E,$85,$01,$AF,$C8,$85,$7E,$85,$02,$AF   ;C2539A  
	.db $DC,$85,$7E,$85,$03,$A9,$13,$85,$04,$AF,$8A,$89,$7E,$85,$05,$22   ;C253AA  
	.db $82,$33,$C3,$64,$00,$60,$3D,$3E   ;C253BA  
	.db $3F                               ;C253C2  
@lbl_C253C3:
	cmp.b #$13
	bne @lbl_C2541D
	.db $A6,$00,$DA,$A9,$13,$85,$00,$22,$91,$15,$C2,$FA,$30,$45,$BF,$35   ;C253C7  
	.db $88,$7E,$D0,$3F,$BF,$59,$87,$7E,$C9,$FE,$F0,$37,$C9,$00,$30,$08   ;C253D7
	.db $85,$00,$DA,$22,$F4,$06,$C3,$FA,$A9,$FE,$9F,$59,$87,$7E,$DA,$20   ;C253E7  
	.db $55,$59,$FA,$A5,$00,$30,$1C,$AF,$F0,$85,$7E,$85,$01,$BF,$B5,$85   ;C253F7  
	.db $7E,$85,$02,$BF,$C9,$85,$7E,$85,$03,$A9,$13,$85,$04,$64,$05,$22   ;C25407  
	.db $82,$33,$C3,$64,$00,$60           ;C25417  
@lbl_C2541D:
	cmp.b #$1C
	bne @lbl_C2545B
	.db $A5,$00,$30,$31,$48,$AF,$2C,$86,$7E,$1A,$48,$A9,$13,$85,$00,$22   ;C25421  
	.db $5E,$78,$C2,$A5,$00,$C3,$02,$D0,$17,$8F,$30,$87,$7E,$A9,$13,$85   ;C25431  
	.db $00,$22,$1A,$12,$C2,$22,$05,$24,$C6,$A3,$01,$3A,$83,$01,$10,$DB   ;C25441
	.db $68,$68,$64,$00,$60,$A9,$01,$85   ;C25451
	.db $00,$60                           ;C25459
@lbl_C2545B:
	cmp.b #$2B
	bne @lbl_C2547C
	.db $A6,$00,$A9,$13,$85,$00,$DA,$22,$91,$15,$C2,$FA,$E0,$00,$30,$0A   ;C2545F  
	.db $86,$00,$A9,$13,$85,$01,$22,$4B   ;C2546F  
	.db $44,$C2,$64,$00,$60               ;C25477
@lbl_C2547C:
	cmp.b #$1D
	bne @lbl_C25498
	.db $AF,$2C,$86,$7E,$C9,$03,$D0,$0B,$A9,$13,$85,$00,$22,$90,$43,$C2   ;C25480  
	.db $64,$00,$60,$A9,$01,$85,$00,$60   ;C25490  
@lbl_C25498:
	cmp.b #$27
	beq @lbl_C2549F
	jmp.w func_C25520
@lbl_C2549F:
	.db $A5,$00,$48,$A9,$13,$85,$00,$22,$91,$15,$C2,$A9,$D3,$85,$00,$64   ;C2549F  
	.db $01,$A9,$13,$85,$02
	jsl.l DisplayMessage
	.db $FA,$30,$60,$BF,$35,$88,$7E   ;C254AF  
	.db $D0,$5A,$AF,$2C,$86,$7E,$3A,$D0,$0F,$C2,$20,$A9,$64,$00,$85,$00   ;C254BF  
	.db $E2,$20,$22,$BE,$33,$C2,$80,$26,$3A,$D0,$0F,$C2,$20,$A9,$2C,$01   ;C254CF
	.db $85,$00,$E2,$20,$22,$BE,$33,$C2,$80,$14,$C2,$30,$A9,$64,$00,$85   ;C254DF  
	.db $00,$22,$95,$33,$C2,$A2,$4E,$00,$AF,$45,$89,$7E,$80,$09,$C2,$30   ;C254EF
	.db $A2,$50,$00,$AF,$43,$89,$7E,$85,$00,$A9,$0A,$00,$85,$02,$22,$26   ;C254FF
	.db $E5,$C3,$A5,$00,$85,$02,$86,$00
	jsl.l DisplayMessage
	.db $64,$00,$60,$E2   ;C2550F  
	.db $30                               ;C2551F  

func_C25520:
	cmp.b #$12
	bne @lbl_C25578
	.db $A5,$00,$48,$A9,$13,$85,$00,$22,$91,$15,$C2,$FA,$30,$43,$A9,$27   ;C25524  
	.db $85,$00,$64,$01,$A9,$13,$85,$02,$DA
	jsl.l DisplayMessage
	.db $FA,$AF,$2C   ;C25534  
	.db $86,$7E,$3A,$D0,$16,$BF,$7D,$86,$7E,$4A,$4A,$69,$00,$49,$FF,$1A   ;C25544  
	.db $18,$7F,$7D,$86,$7E,$9F,$7D,$86,$7E,$80,$16,$3A,$D0,$0D,$BF,$7D   ;C25554
	.db $86,$7E,$4A,$69,$00,$9F,$7D,$86,$7E,$80,$06,$A9,$01,$9F,$7D,$86   ;C25564  
	.db $7E,$64,$00,$60                   ;C25574  
@lbl_C25578:
	cmp.b #$02
	bne @lbl_C255B9
	.db $AF,$2C,$86,$7E,$3A,$F0,$17,$3A,$D0,$19,$A5,$00,$30,$10,$8F,$30   ;C2557C  
	.db $87,$7E,$A9,$13,$85,$00,$22,$1A,$12,$C2,$22,$05,$24,$C6,$A9,$01   ;C2558C  
	.db $85,$00,$60,$A9,$13,$85,$00,$22,$5E,$78,$C2,$C2,$20,$A5,$04,$85   ;C2559C  
	.db $00,$E2,$20,$22,$AF,$59,$C3,$A5   ;C255AC
	.db $00,$83,$03,$80,$D1               ;C255B4
@lbl_C255B9:
	cmp.b #$20
	beq @lbl_C255C0
	jmp.w func_C25649
@lbl_C255C0:
	lda #$13                                ;C255C0
	sta $00                                 ;C255C2
	jsl $C2785E                             ;C255C4
	lda $02                                 ;C255C8
	bmi @lbl_C25646                         ;C255CA
	lda $7E85C8                             ;C255CC
	pha                                     ;C255D0
	lda $7E85DC                             ;C255D1
	pha                                     ;C255D5
	lda $04                                 ;C255D6
	sta $7E85C8                             ;C255D8
	lda $05                                 ;C255DC
	sta $7E85DC                             ;C255DE
	lda #$13                                ;C255E2
	sta $00                                 ;C255E4
	jsl $C2785E                             ;C255E6
	pla                                     ;C255EA
	sta $7E85DC                             ;C255EB
	pla                                     ;C255EF
	sta $7E85C8                             ;C255F0
	lda $02                                 ;C255F4
	bmi @lbl_C25646                         ;C255F6
	lda $00                                 ;C255F8
	bpl @lbl_C25646                         ;C255FA
	lda #$00                                ;C255FC
	sta $7E8758                             ;C255FE
	lda #$13                                ;C25602
	sta $00                                 ;C25604
	lda $7E87BC                             ;C25606
	sta $01                                 ;C2560A
	lda #$11                                ;C2560C
	sta $02                                 ;C2560E
	rep #$20                                ;C25610
	lda $04                                 ;C25612
	sta $06                                 ;C25614
	pha                                     ;C25616
	sep #$20                                ;C25617
	lda $7E85F0                             ;C25619
	sta $03                                 ;C2561D
	lda $7E85C8                             ;C2561F
	sta $04                                 ;C25623
	lda $7E85DC                             ;C25625
	sta $05                                 ;C25629
	jsl $C626A0                             ;C2562B
	rep #$20                                ;C2562F
	pla                                     ;C25631
	sta $02                                 ;C25632
	sep #$20                                ;C25634
	lda #$13                                ;C25636
	sta $00                                 ;C25638
	jsl $C2791F                             ;C2563A
	lda #$13                                ;C2563E
	sta $00                                 ;C25640
	jsl $C24584                             ;C25642
@lbl_C25646:
	stz $00                                 ;C25646
	rts                                     ;C25648

func_C25649:
	cmp.b #$18
	bne @lbl_C256B8
	ldx $00                                 ;C2564D
	phx                                     ;C2564F
	lda #$13                                ;C25650
	sta $00                                 ;C25652
	jsl $C21591                             ;C25654
	plx                                     ;C25658
	bmi @lbl_C256B5                         ;C25659
	lda $7E85A1,x                           ;C2565B
	cmp #$3C                                ;C2565F
	bcs @lbl_C256B5                         ;C25661
	cmp #$28                                ;C25663
	beq @lbl_C256B5                         ;C25665
	sta $00                                 ;C25667
	lda $7E8619,x                           ;C25669
	sta $01                                 ;C2566D
	phx                                     ;C2566F
	jsl $C24167                             ;C25670
	lda #$13                                ;C25674
	sta $00                                 ;C25676
	jsl $C2785E                             ;C25678
	rep #$20                                ;C2567C
	lda $04                                 ;C2567E
	sta $02                                 ;C25680
	sep #$20                                ;C25682
	lda #$13                                ;C25684
	sta $00                                 ;C25686
	jsl $C2791F                             ;C25688
	plx                                     ;C2568C
	lda #$00                                ;C2568D
	sta $7E8781,x                           ;C2568F
	stx $00                                 ;C25693
	jsl $C20F35                             ;C25695
	lda $7E85C8                             ;C25699
	sta $00                                 ;C2569D
	lda $7E85DC                             ;C2569F
	sta $01                                 ;C256A3
	lda #$13                                ;C256A5
	sta $02                                 ;C256A7
	jsl $C35B7A                             ;C256A9
	lda #$13                                ;C256AD
	sta $00                                 ;C256AF
	jsl $C24584                             ;C256B1
@lbl_C256B5:
	stz $00                                 ;C256B5
	rts                                     ;C256B7
@lbl_C256B8:
	cmp.b #$1F
	bne @lbl_C256D6
	.db $A9,$13,$85,$00,$22,$8E,$1B,$C2,$A5,$00,$D0,$03,$64,$00,$60,$A9   ;C256BC
	.db $13,$85,$00,$22,$91,$15,$C2,$64   ;C256CC  
	.db $00,$60                           ;C256D4
@lbl_C256D6:
	cmp.b #$26
	bne @lbl_C256F6
	.db $A5,$00,$30,$0D,$85,$01,$A9,$13,$85,$00,$22,$6A,$24,$C2,$64,$00   ;C256DA  
	.db $60,$A9,$13,$85,$00,$22,$91,$15   ;C256EA
	.db $C2,$64,$00,$60                   ;C256F2
@lbl_C256F6:
	cmp.b #$07
	bne @lbl_C2571E
	.db $A6,$00,$DA,$A9,$13,$85,$00,$22,$91,$15,$C2,$FA,$30,$13,$BF,$F1   ;C256FA  
	.db $85,$7E,$4A,$69,$00,$85,$02,$86,$00,$A9,$13,$85,$01,$22,$DF,$28   ;C2570A  
	.db $C2,$64,$00,$60                   ;C2571A
@lbl_C2571E:
	cmp.b #$21
	bne @lbl_C2573F
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2785E
	rep #$20 ;A->16
	lda.b wTemp04
	sta.b wTemp00
	sep #$20 ;A->8
	jsl.l func_C359AF
	lda.b wTemp00
	sta.b wTemp03,s
	lda.b #$01
	sta.b wTemp00
	rts
@lbl_C2573F:
	cmp #$0F                                ;C2573F
	bne @lbl_C25768                         ;C25741
	jsl $C240FC                             ;C25743
	lda #$2F                                ;C25747
	sta $00                                 ;C25749
	lda #$37                                ;C2574B
	sta $01                                 ;C2574D
	jsl $C3F69F                             ;C2574F
	lda $00                                 ;C25753
	sta $7E87BC                             ;C25755
	lda #$FF                                ;C25759
	sta $7E885C                             ;C2575B
	lda #$14                                ;C2575F
	sta $7E899B                             ;C25761
	stz $00                                 ;C25765
	rts                                     ;C25767
@lbl_C25768:
	cmp #$09                                ;C25768
	.db $D0,$5A   ;C2576A
	ldx $00                                 ;C2576C
	phx                                     ;C2576E
	lda #$13                                ;C2576F
	sta $00                                 ;C25771
	jsl $C21591                             ;C25773
	plx                                     ;C25777
	.db $30,$49   ;C25778
	lda $7E862C                             ;C2577A
	dec a                                   ;C2577E
	bne @lbl_C2579A                         ;C2577F
	lda $7E8691,x                           ;C25781
	sec                                     ;C25785
	sbc #$04                                ;C25786
	bcs @lbl_C2578C                         ;C25788
	lda #$00                                ;C2578A
@lbl_C2578C:
	sta $7E8691,x                           ;C2578C
	lda #$34                                ;C25790
	sta $00                                 ;C25792
	lda #$01                                ;C25794
	sta $01                                 ;C25796
	bra @lbl_C257BD                         ;C25798
@lbl_C2579A:
	dec a                                   ;C2579A
	bne @lbl_C257AD                         ;C2579B
	lda #$00                                ;C2579D
	sta $7E8691,x                           ;C2579F
	lda #$35                                ;C257A3
	sta $00                                 ;C257A5
	lda #$01                                ;C257A7
	sta $01                                 ;C257A9
	bra @lbl_C257BD                         ;C257AB
@lbl_C257AD:
	stx $00                                 ;C257AD
	phx                                     ;C257AF
	jsl $C28305                             ;C257B0
	plx                                     ;C257B4
	lda #$36                                ;C257B5
	sta $00                                 ;C257B7
	lda #$01                                ;C257B9
	sta $01                                 ;C257BB
@lbl_C257BD:
	stx $02                                 ;C257BD
	jsl.l DisplayMessage
	.db $64,$00,$60,$C9,$0A,$F0,$03,$4C,$58,$58,$A6,$00   ;C257BF  
	.db $DA,$A9,$13,$85,$00,$22,$91,$15,$C2,$FA,$30,$7A,$BF,$35,$88,$7E   ;C257CF
	.db $D0,$74,$AF,$62,$89,$7E,$30,$1C,$A9,$88,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $64,$00,$60,$A9,$03,$85,$00,$A9,$01,$85,$01
	jsl.l DisplayMessage
	.db $64,$00,$60,$BF,$59,$87,$7E,$C9,$FE,$F0,$E9,$C9,$00,$30,$08   ;C257FF  
	.db $85,$00,$DA,$22,$F4,$06,$C3,$FA,$A9,$FE,$9F,$59,$87,$7E,$DA,$22   ;C2580F  
	.db $1A,$04,$C3,$FA,$A5,$00,$30,$2E,$48,$85,$04,$A9,$13,$85,$02,$86   ;C2581F
	.db $03,$A9,$2B,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $22,$3A,$25,$C6,$68   ;C2582F  
	.db $85,$00,$22,$02,$3A,$C2,$22,$45,$25,$C6,$22,$05,$24,$C6,$A9,$13   ;C2583F  
	.db $85,$00,$22,$90,$43,$C2,$64,$00,$60,$C9,$05,$F0,$03,$4C,$D9,$58   ;C2584F  
	.db $A6,$00,$DA,$A9,$13,$85,$00,$22,$91,$15,$C2,$FA,$30,$69,$BF,$35   ;C2585F  
	.db $88,$7E,$D0,$63,$80,$0F,$A9,$03,$85,$00,$A9,$01,$85,$01
	jsl.l DisplayMessage
	.db $64,$00,$60,$BF,$59,$87,$7E,$C9,$FE,$F0,$E9,$C9,$00,$30   ;C2587F  
	.db $08,$85,$00,$DA,$22,$F4,$06,$C3,$FA,$A9,$FE,$9F,$59,$87,$7E,$DA   ;C2588F
	.db $22,$F3,$05,$C3,$FA,$A5,$00,$30,$2E,$48,$85,$04,$A9,$13,$85,$02   ;C2589F  
	.db $86,$03,$A9,$2B,$85,$00,$64,$01
	jsl.l DisplayMessage
	jsl $C6253A                             ;C258BB
	pla                                     ;C258BF
	sta $00                                 ;C258C0
	jsl $C23A02                             ;C258C2
	jsl $C62545                             ;C258C6
	jsl $C62405                             ;C258CA
	lda #$13                                ;C258CE
	sta $00                                 ;C258D0
	jsl $C24390                             ;C258D2
	stz $00                                 ;C258D6
	rts                                     ;C258D8
	lda #$01                                ;C258D9
	sta $00                                 ;C258DB
	rts                                     ;C258DD
	php                                     ;C258DE
	sep #$30                                ;C258DF
	lda #$FF                                ;C258E1
	pha                                     ;C258E3
	pha                                     ;C258E4
	pha                                     ;C258E5
	ldx #$12                                ;C258E6
@lbl_C258E8:
	lda $7E85F1,x                           ;C258E8
	beq @lbl_C25949                         ;C258EC
	lda $7E85C9,x                           ;C258EE
	beq @lbl_C25949                         ;C258F2
	stx $00                                 ;C258F4
	phx                                     ;C258F6
	jsl $C277F8                             ;C258F7
	plx                                     ;C258FB
	lda $01                                 ;C258FC
	asl a                                   ;C258FE
	bit #$02                                ;C258FF
	beq @lbl_C25918                         ;C25901
	ldy $02                                 ;C25903
	bne @lbl_C25918                         ;C25905
	dec a                                   ;C25907
	bit #$04                                ;C25908
	bne @lbl_C25912                         ;C2590A
	ldy $03                                 ;C2590C
	bne @lbl_C25916                         ;C2590E
	bra @lbl_C25918                         ;C25910
@lbl_C25912:
	ldy $03                                 ;C25912
	bne @lbl_C25918                         ;C25914
@lbl_C25916:
	inc a                                   ;C25916
	inc a                                   ;C25917
@lbl_C25918:
	sec                                     ;C25918
	sbc $7E85F0                             ;C25919
	sec                                     ;C2591D
	sbc $7E85F0                             ;C2591E
	and #$0F                                ;C25922
	eor #$08                                ;C25924
	bit #$08                                ;C25926
	beq @lbl_C2592D                         ;C25928
	eor #$0F                                ;C2592A
	inc a                                   ;C2592C
@lbl_C2592D:
	cmp #$03                                ;C2592D
	bcs @lbl_C25949                         ;C2592F
	tay                                     ;C25931
	lda $01,s                               ;C25932
	cmp $00                                 ;C25934
	bcc @lbl_C25949                         ;C25936
	bne @lbl_C2593F                         ;C25938
	tya                                     ;C2593A
	cmp $02,s                               ;C2593B
	bcs @lbl_C25949                         ;C2593D
@lbl_C2593F:
	tya                                     ;C2593F
	sta $02,s                               ;C25940
	lda $00                                 ;C25942
	sta $01,s                               ;C25944
	txa                                     ;C25946
	sta $03,s                               ;C25947
@lbl_C25949:
	dex                                     ;C25949
	bpl @lbl_C258E8                         ;C2594A
	pla                                     ;C2594C
	sta $01                                 ;C2594D
	pla                                     ;C2594F
	pla                                     ;C25950
	sta $00                                 ;C25951
	plp                                     ;C25953
	rts                                     ;C25954
	php                                     ;C25955
	sep #$30                                ;C25956
@lbl_C25958:
	jsl $C3041A                             ;C25958
	ldy $00                                 ;C2595C
	bmi @lbl_C25986                         ;C2595E
	phy                                     ;C25960
	jsl $C30710                             ;C25961
	ply                                     ;C25965
	ldx $00                                 ;C25966
	lda $7E862C                             ;C25968
	dec a                                   ;C2596C
	beq @lbl_C2597A                         ;C2596D
	dec a                                   ;C2596F
	beq @lbl_C25976                         ;C25970
	cpx #$06                                ;C25972
	beq @lbl_C25986                         ;C25974
@lbl_C25976:
	cpx #$03                                ;C25976
	beq @lbl_C25986                         ;C25978
@lbl_C2597A:
	cpx #$05                                ;C2597A
	beq @lbl_C25986                         ;C2597C
	sty $00                                 ;C2597E
	jsl $C306F4                             ;C25980
	bra @lbl_C25958                         ;C25984
@lbl_C25986:
	sty $00                                 ;C25986
	plp                                     ;C25988
	rts                                     ;C25989

func_C2598A:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp02
	ldy.b wTemp00
	ldx.b wTemp01
	pha
	phx
	phy
	jsl.l func_C30710
	ply
	plx
	pla
	stx.b wTemp02
	ldx.b wTemp01
	cpx.b #$E7
	bne @lbl_C259AA
;C259A7  
	.db $4C,$5C,$5A
@lbl_C259AA:
	ldx.b wTemp02
	beq @lbl_C259B1
	jmp.w @lbl_C25A48
@lbl_C259B1:
	sep #$20 ;A->8
	pha
	lda.l wShirenStatus.cantPickUpItems
	tax
	pla
	rep #$20 ;A->16
	cpx.b #$00
	beq @lbl_C259CE
	.db $A9,$2B,$01,$85,$00,$5A
	jsl.l DisplayMessage
	.db $7A,$4C,$54,$5A           ;C259C8  
@lbl_C259CE:
	sty.b wTemp00
	pha
	phy
	jsl.l TryAddSelectedItemToInventory
	ply
	pla
	ldx.b wTemp00
	bmi @lbl_C25A48
	sep #$20 ;A->8
	pha
	lda.l wShirenStatus.itemAmounts,x
	tay
	pla
	rep #$20 ;A->16
	sta.b wTemp00
	ldx.b #$80
	stx.b wTemp02
	pha
	jsl.l func_C35BA2
	pla
	sty.b wTemp00
	phy
	pha
	jsl.l func_C30710
	pla
	ldx.b wTemp01
	ldy.b wTemp00
	cpy.b #$0A
	bne @lbl_C25A25
	.db $85,$04,$85,$06,$A9,$13,$00,$85,$00,$A9,$C0,$06,$E0,$E1,$D0,$03   ;C25A04  
	.db $A9,$C1,$06,$85,$02,$22,$A0,$26,$C6,$E2,$20,$A9,$02,$8F,$79,$89   ;C25A14
	.db $7E                               ;C25A24  
@lbl_C25A25:
	sep #$20 ;A->8
	lda.l $7E87BC
	cmp.b #$0A
	bne @lbl_C25A35
;C25A2F
	.db $A9,$86,$8F,$7B,$89,$7E
@lbl_C25A35:
	ply
	lda.l $7E898D
	beq @lbl_C25A42
;C25A3C  
	.db $84,$00,$22,$92,$01,$C3
@lbl_C25A42:
	rep #$20 ;A->16
	stz.b wTemp00
	plp
	rtl
@lbl_C25A48:
	sty.b wTemp02
	stz.b wTemp00
	ldx.b #$13
	stx.b wTemp00
	jsl.l DisplayMessage
	stz.b wTemp00
	ldx.b #$02
	stx.b wTemp01
	plp
	rtl
	.db $48,$A6,$00,$A9,$64,$00,$E0,$0C,$D0,$03,$A9,$B8,$00,$A2,$0F,$86   ;C25A5C
	.db $02,$85,$00,$5A
	jsl.l DisplayMessage
	ply                                     ;C25A74
	sty $00                                 ;C25A75
	jsl $C306F4                             ;C25A77
	pla                                     ;C25A7B
	sta $00                                 ;C25A7C
	ldx #$80                                ;C25A7E
	stx $02                                 ;C25A80
	pha                                     ;C25A82
	jsl $C35BA2                             ;C25A83
	pla                                     ;C25A87
	sta $00                                 ;C25A88
	jsl $C3631A                             ;C25A8A
	lda $00                                 ;C25A8E
	bmi @lbl_C25AE4                         ;C25A90
	pha                                     ;C25A92
	jsl $C62771                             ;C25A93
	pla                                     ;C25A97
	ldx $00                                 ;C25A98
	ldy #$01                                ;C25A9A
	cpx #$14                                ;C25A9C
	bcc @lbl_C25AA6                         ;C25A9E
	iny                                     ;C25AA0
	cpx #$1E                                ;C25AA1
	bcc @lbl_C25AA6                         ;C25AA3
	iny                                     ;C25AA5
@lbl_C25AA6:
	sty $04                                 ;C25AA6
	sta $00                                 ;C25AA8
	ldx #$06                                ;C25AAA
	stx $02                                 ;C25AAC
	ldx #$0F                                ;C25AAE
	stx $03                                 ;C25AB0
	pha                                     ;C25AB2
	jsl $C20086                             ;C25AB3
	pla                                     ;C25AB7
	ldx $00                                 ;C25AB8
	bmi @lbl_C25AE4                         ;C25ABA
	sta $00                                 ;C25ABC
	stx $02                                 ;C25ABE
	phx                                     ;C25AC0
	jsl $C35B7A                             ;C25AC1
	plx                                     ;C25AC5
	stx $00                                 ;C25AC6
	ldy #$41                                ;C25AC8
	sty $02                                 ;C25ACA
	phx                                     ;C25ACC
	jsl $C62550                             ;C25ACD
	plx                                     ;C25AD1
	sep #$20                                ;C25AD2
	lda #$00                                ;C25AD4
	sta $7E8731,x                           ;C25AD6
	ldx #$01                                ;C25ADA
	stx $00                                 ;C25ADC
	ldx #$00                                ;C25ADE
	stx $01                                 ;C25AE0
	plp                                     ;C25AE2
	rtl                                     ;C25AE3
@lbl_C25AE4:
	rep #$20                                ;C25AE4
	lda #$00C8                              ;C25AE6
	sta $00                                 ;C25AE9
	ldx #$0F                                ;C25AEB
	stx $02                                 ;C25AED
	jsl.l DisplayMessage
	.db $A2,$01,$86,$00,$A2,$00,$86,$01,$28   ;C25AEC  
	.db $6B                               ;C25AFC

func_C25AFD:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.w #$0000
	pha
	ldx.b wTemp01
	phx
	phx
	pha
	pha
	pha
	pha
	ldy.b wTemp00
	phy
	jsl.l func_C30710
	ply
	ldx.b wTemp00
	cpx.b #$0B
	bne @lbl_C25B21
	lda.w #$0001
	sta.b w000b,s
@lbl_C25B21:
	sty.b wTemp00
@lbl_C25B23:
	phy
	jsl.l func_C33AD5
	ply
	ldx.b wTemp00
	cpx.b #$00
	beq @lbl_C25B6B
	sty.b wTemp00
	stz.b wTemp01
	phx
	phy
	jsl.l func_C33CA0
	ply
	plx
	lda.b wTemp01,s
	clc
	adc.b wTemp00
	sta.b wTemp01,s
	lda.b wTemp03,s
	adc.w #$0000
	sta.b wTemp03,s
	cpx.b #$02
	beq @lbl_C25B6B
	lda.b w0009,s
	bne @lbl_C25B6B
	lda.b wTemp05,s
	clc
	adc.b wTemp00
	sta.b wTemp05,s
	lda.b wTemp07,s
	adc.w #$0000
	sta.b wTemp07,s
	sty.b wTemp00
	ldx.b #$02
	stx.b wTemp01
	phy
	jsl.l func_C33A92
	ply
@lbl_C25B6B:
	lda.b w000b,s
	beq @lbl_C25B7B
	sty.b wTemp00
	jsl.l func_C33AE2
	ldy.b wTemp00
	cpy.b #$FF
	bne @lbl_C25B23
@lbl_C25B7B:
	lda.b wTemp01,s
	ora.b wTemp03,s
	beq @lbl_C25BA6
	lda.b wTemp05,s
	ora.b wTemp07,s
	beq @lbl_C25BA6
	lda.b wTemp01,s
	clc
	adc.l $7E8991
	sta.l $7E8991
	lda.b wTemp03,s
	adc.l $7E8993
	sta.l $7E8993
	sep #$20 ;A->8
	lda.b #$01
	sta.l $7E8990
	rep #$20 ;A->16
@lbl_C25BA6:
	lda.b wTemp01,s
	sta.b wTemp02
	lda.b wTemp03,s
	sta.b wTemp04
	pla
	pla
	pla
	pla
	plx
	plx
	pla
	plp
	rtl

func_C25BB7:
	php
	rep #$20 ;A->16
	lda.l wShirenStatus.gitan
	sec
	sbc.b wTemp00
	sta.b wTemp00
	lda.l $7E8941
	sbc.b wTemp02
	bpl @lbl_C25BD2
;C25BCB
	.db $A9,$FF,$FF,$85,$00,$28,$6B
@lbl_C25BD2:
	sta.l $7E8941
	lda.b wTemp00
	sta.l wShirenStatus.gitan
	stz.b wTemp00
	plp
	rtl

func_C25BE0:
	php
	sep #$20 ;A->8
	clc
	lda.l wShirenStatus.gitan
	adc.b wTemp00
	sta.l wShirenStatus.gitan
	lda.l $7E8940
	adc.b wTemp01
	sta.l $7E8940
	lda.l $7E8941
	adc.b wTemp02
	sta.l $7E8941
	bmi @lbl_C25C2C
	lda.b #$3F
	cmp.l wShirenStatus.gitan
	lda.b #$42
	sbc.l $7E8940
	lda.b #$0F
	sbc.l $7E8941
	bpl @lbl_C25C2A
	.db $A9,$3F,$8F,$3F,$89,$7E,$A9,$42,$8F,$40,$89,$7E,$A9,$0F,$8F,$41   ;C25C18
	.db $89,$7E                           ;C25C28
@lbl_C25C2A:
	plp
	rtl
@lbl_C25C2C:
	.db $A9,$00,$8F,$3F,$89,$7E,$8F,$40,$89,$7E,$8F,$41,$89,$7E,$28,$6B   ;C25C2C

func_C25C3C:
	php
	sep #$30 ;AXY->8
	lda.l $7E8977
	beq @lbl_C25C8C
	lda.l wCharXPos+CharDataShirenIndex
	sta.b wTemp00
	lda.l wCharYPos+CharDataShirenIndex
	sta.b wTemp01
	lda.l wCharDir+CharDataShirenIndex
	sta.b wTemp02
	jsl.l func_C359D1
	lda.b wTemp02
	eor.b #$FF
	and.b wTemp00
	bit.b #$C7
	bne @lbl_C25CA0
	lda.l wCharDir+CharDataShirenIndex
	lsr a
	bcs @lbl_C25C8E
	lda.b wTemp02
	eor.b #$FF
	and.b wTemp01
	bit.b #$45
	bne @lbl_C25CA0
	lda.b wTemp02
	bit.b #$01
	bne @lbl_C25CA0
	bit.b #$0A
	beq @lbl_C25C84
	bit.b #$04
	beq @lbl_C25CA0
@lbl_C25C84:
	bit.b #$A0
	beq @lbl_C25C8C
	bit.b #$40
	beq @lbl_C25CA0
@lbl_C25C8C:
	plp
	rtl
@lbl_C25C8E:
	lda.b wTemp02
	eor.b #$FF
	and.b wTemp01
	bit.b #$C7
	bne @lbl_C25CA0
	lda.b wTemp02
	bit.b #$83
	bne @lbl_C25CA0
	plp
	rtl
@lbl_C25CA0:
	lda.b #$00
	sta.l $7E8977
	plp
	rtl

func_C25CA8:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.w $899A
	cpy.b #$13
	beq @lbl_C25CBE
	cpy.w $897F
	beq @lbl_C25CBE
	jsr.w func_C25CE6
@lbl_C25CBE:
	ldy.b #$12
@lbl_C25CC0:
	lda.w wCharHP,y
	bne @lbl_C25CCF
@lbl_C25CC5:
	dey
	bpl @lbl_C25CC0
	lda.b #$FF
	sta.w $897F
	plp
	rtl
@lbl_C25CCF:
	tya
	cmp.w $897F
	bne @lbl_C25CDC
	lda.b #$FF
	sta.w $897F
	bra @lbl_C25CC5
@lbl_C25CDC:
	cmp.w $899A
	beq @lbl_C25CC5
	jsr.w func_C25CE6
	bra @lbl_C25CC5

func_C25CE6:
	lda.w $85C8
	pha
	lda.w $85DC
	pha
	lda.w $87D0
	pha
	ldx.w $899A
	lda.w wCharInvisible,x
	bne @lbl_C25D19
	cpx.b #$13
	bne @lbl_C25D05
	lda.w $885C
	bne @lbl_C25D19
	bra @lbl_C25D26
@lbl_C25D05:
	lda.w wCharXPos,x
	sta.w $85C8
	lda.w wCharYPos,x
	sta.w $85DC
	lda.w wCharUnderfootTerrainType,x
	sta.w $87D0
	bra @lbl_C25D26
@lbl_C25D19:
	lda.b #$00
	sta.w $85C8
	sta.w $85DC
	lda.b #$30
	sta.w $87D0
@lbl_C25D26:
	lda.w wCharXPos,y
	sta.b wTemp00
	lda.w wCharYPos,y
	sta.b wTemp01
	sty.b wTemp02
	jsl.l func_C35B7A
	lda.w wCharRemainingSleepTurns,y
	beq @lbl_C25D41
	dec a
	sta.w wCharRemainingSleepTurns,y
	bra @lbl_C25D89
@lbl_C25D41:
	lda.w wCharIsAwake,y
	bmi @lbl_C25D4B
	ora.w wCharOverrideState,y
	bne @lbl_C25D89
@lbl_C25D4B:
	lda.b #$00
	sta.w wCharDoubleSpeedExtraAttacksNum,y
	lda.w $8780
	sec
	sbc.w wCharSpeed,y
	beq @lbl_C25D7F
	bmi @lbl_C25D6B
	dec a
	bne @lbl_C25D62
	lda.b #$01
	bra @lbl_C25D64
@lbl_C25D62:
	lda.b #$03
@lbl_C25D64:
	and.w $8978
	bne @lbl_C25D89
	bra @lbl_C25D7F
@lbl_C25D6B:
	sty.b wTemp00
	phy
	call_savebank func_C25DB2
	ply
	lda.w wCharAttackTarget,y
	bpl @lbl_C25D8B
	lda.w wCharTrapsActivated,y
	bne @lbl_C25D89
@lbl_C25D7F:
	sty.b wTemp00
	phy
	call_savebank func_C25DB2
	ply
@lbl_C25D89:
	bra @lbl_C25D95
@lbl_C25D8B:
	lda.w wCharNumOfAttacks,y
	bne @lbl_C25D95
	lda.b #$01
	sta.w wCharDoubleSpeedExtraAttacksNum,y
@lbl_C25D95:
	pla
	sta.w $87D0
	pla
	sta.w $85DC
	pla
	sta.w $85C8
	rts

func_C25DA2:
	php
	sep #$20 ;A->8
	lda.l $7E8978
	and.b #$FC
	inc a
	sta.l $7E8978
	plp
	rtl

func_C25DB2:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharRemainingConfusedTurns,x
	beq @lbl_C25DE1
	dec a
	sta.l wCharRemainingConfusedTurns,x
	beq @lbl_C25DCA
	jsl.l func_C2628F
	plp
	rtl
@lbl_C25DCA:
	.db $8A,$CF,$9A,$89,$7E,$D0,$10,$A9,$13,$8F,$9A,$89,$7E,$BF,$A1,$85   ;C25DCA
	.db $7E,$9F,$A9,$87,$7E,$28,$6B       ;C25DDA  
@lbl_C25DE1:
	lda.l wCharRemainingPuzzledTurns,x
	beq @lbl_C25DED
	jsl.l func_C26087
	plp
	rtl
@lbl_C25DED:
	lda.l wCharRemainingBlindlessTurns,x
	beq @lbl_C25DFF
	.db $BF,$35,$88,$7E,$D0,$06,$22,$4A   ;C25DF3  
	.db $60,$C2,$28,$6B                   ;C25DFB
@lbl_C25DFF:
	lda.l wCharIsKigny,x
	beq @lbl_C25E0A
;C25E05
	.db $DA,$A9,$0C,$80,$11
@lbl_C25E0A:
	lda.l wCharIsSealed,x
	bne @lbl_C25E16
	jsl.l func_C25FBB
	plp
	rtl
@lbl_C25E16:
	phx
	lda.l wCharType,x
	rep #$30 ;AXY->16
	and.w #$00FF
	asl a
	tax
	lda.l UNREACH_C25E3B,x
	phk
	pea.w $5E2B
	pha
	rts
	sep #$30 ;AXY->8
	plx
	lda.b wTemp00
	beq @lbl_C25E39
	stx.b wTemp00
	jsl.l func_C25FBB
@lbl_C25E39:
	plp
	rtl

UNREACH_C25E3B:
	.db $00,$00,$BA,$5F                   ;C25E3B
	.db $E4,$64                           ;C25E3F
	.db $BA,$5F                           ;C25E41
	.db $3B,$6A,$3A,$65                   ;C25E43
	.db $80,$6A,$D4,$6A,$BA,$5F,$BA,$5F   ;C25E47  
	.db $8C,$66                           ;C25E4F
	.db $85,$6C,$D1,$6D,$BA,$5F,$D4,$62   ;C25E51  
	.db $BA,$5F,$BA,$5F                   ;C25E59
	.db $41,$6D                           ;C25E5D
	.db $BA,$5F,$BA,$5F,$E1,$69,$BA,$5F   ;C25E5F
	.db $BC,$68                           ;C25E67
	.db $BA,$5F,$FC,$6E,$BA,$5F,$BA,$5F   ;C25E69
	.db $21,$63                           ;C25E71
	.db $0D,$63                           ;C25E73  
	.db $CB,$6C                           ;C25E75
	.db $BA,$5F                           ;C25E77
	.db $BA,$5F                           ;C25E79
	.db $BA,$5F                           ;C25E7B
	.db $F2,$63                           ;C25E7D
	.db $E0,$6B                           ;C25E7F
	.db $BA,$5F,$BA,$5F                   ;C25E81
	.db $33,$6A                           ;C25E85  
	.db $BA,$5F                           ;C25E87
	.db $5B,$63,$BA,$5F,$DB,$60           ;C25E89
	.db $36,$63                           ;C25E8F
	.db $BA,$5F,$BA,$5F                   ;C25E91
	.db $C4,$67                           ;C25E95
	.db $52,$6B,$CD,$62,$CD,$62,$CD,$62,$CD,$62,$CD,$62,$CD,$62,$CD,$62   ;C25E97  
	.db $CD,$62,$CD,$62,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25EA7  
	.db $EA,$71,$EA,$71                   ;C25EB7
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25EBB
	.db $BA,$5F,$BA,$5F,$BA,$5F           ;C25EC3
	.db $71,$72,$3E,$72                   ;C25EC9
	.db $BA,$5F,$BA,$5F,$BA,$5F,$10,$70   ;C25ECD
	.db $75,$70                           ;C25ED5
	.db $BA,$5F,$BA,$5F                   ;C25ED7
	.db $58,$75                           ;C25EDB
	.db $BA,$5F                           ;C25EDD
	.db $5A,$76,$DB,$76                   ;C25EDF
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$4A,$71   ;C25EE3
	.db $7B,$71,$B1,$73,$4A,$71,$92,$71   ;C25EF3
	.db $A1,$71,$BE,$73                   ;C25EFB
	.db $BA,$5F,$BA,$5F,$B1,$73,$B1,$73,$B1,$73,$DD,$74,$BA,$5F,$BA,$5F   ;C25EFF
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F0F
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F1F
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F2F
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F3F
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F4F
	.db $BA,$5F,$BA,$5F,$BA,$5F,$B1,$73,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F5F
	.db $BA,$5F,$BA,$5F,$B1,$73,$B1,$73,$B1,$73,$BA,$5F,$BA,$5F,$B1,$73   ;C25F6F
	.db $B1,$73                           ;C25F7F
	.db $B1,$73,$B1,$73,$BA,$5F,$B1,$73   ;C25F81  
	.db $B1,$73                           ;C25F89  
	.db $B1,$73                           ;C25F8B
	.db $B1,$73,$B1,$73,$B1,$73,$B1,$73,$B1,$73,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F8D  
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25F9D
	.db $BA,$5F,$BA,$5F,$BA,$5F,$BA,$5F   ;C25FAD
	.db $B1,$73,$BA,$5F,$AC,$72           ;C25FB5  

.include "code/ai/movement_ai.asm"


func_C2778A:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharUnderfootTerrainType,x
	bit.b #$90
	bne @lbl_C277A3
	cmp.l $7E87D0
	bne @lbl_C277A3
@lbl_C2779D:
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C277A3:
	stx.b wTemp00
	jsl.l func_C277F8
	lda.b wTemp00
	cmp.b #$01
	beq @lbl_C2779D
	stz.b wTemp00
	plp
	rtl

func_C277B3:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b #$13
	beq @lbl_C277E8
	ldx.b wTemp01
	lda.l $7E85C8
	pha
	lda.l wCharXPos,x
	sta.l $7E85C8
	lda.l $7E85DC
	pha
	lda.l wCharYPos,x
	sta.l $7E85DC
	jsl.l func_C277F8
	pla
	sta.l $7E85DC
	pla
	sta.l $7E85C8
	plp
	rtl
@lbl_C277E8:
	lda.b wTemp01
	sta.b wTemp00
	jsl.l func_C277F8
	lda.b wTemp01
	eor.b #$04
	sta.b wTemp01
	plp
	rtl

func_C277F8:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	stz.b wTemp02
	stz.b wTemp03
	ldx.b #$00
	lda.w $85C8
	sec
	sbc.w wCharXPos,y
	beq @lbl_C27819
	ldx.b #$01
	bcs @lbl_C27819
	eor.b #$FF
	inc a
	ldx.b #$02
@lbl_C27819:
	sta.b wTemp00
	stx.b wTemp01
	ldx.b #$00
	lda.w $85DC
	sec
	sbc.w wCharYPos,y
	beq @lbl_C27831
	ldx.b #$04
	bcs @lbl_C27831
	eor.b #$FF
	inc a
	ldx.b #$08
@lbl_C27831:
	cmp.b wTemp00
	bne @lbl_C27839
	ldy.b #$01
	sty.b wTemp02
@lbl_C27839:
	bcc @lbl_C2783F
	sta.b wTemp00
	sta.b wTemp03
@lbl_C2783F:
	txa
	ora.b wTemp01
	tax
	lda.l UNREACH_C27852,x
	sta.b wTemp01
	lsr a
	bcs @lbl_C27850
	ldy.b #$01
	sty.b wTemp02
@lbl_C27850:
	plp
	rtl

UNREACH_C27852:
	.db $06                               ;C27852  
	.db $00,$04                           ;C27853
	.db $06                               ;C27855  
	.db $06,$07,$05                       ;C27856
	.db $06                               ;C27859  
	.db $02,$01,$03                       ;C2785A
	.db $06                               ;C2785D  

func_C2785E:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.b #$00
	pha
	pha
	pha
	lda.w wCharDir,y
	tax
	lsr a
	bcc @lbl_C278B3
	lda.l DATA8_C27917,x
	clc
	adc.w wCharYPos,y
	sta.b wTemp01
	lda.w wCharXPos,y
	sta.b wTemp00
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	sta.b wTemp03,s
	bpl @lbl_C27893
	asl a
	bpl @lbl_C27893
	sta.b wTemp01,s
@lbl_C27893:
	lda.w wCharYPos,y
	sta.b wTemp01
	lda.l DATA8_C27915,x
	clc
	adc.w wCharXPos,y
	sta.b wTemp00
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	sta.b wTemp02,s
	bpl @lbl_C278B3
	asl a
	bpl @lbl_C278B3
	sta.b wTemp01,s
@lbl_C278B3:
	lda.l DATA8_C27917,x
	clc
	adc.w wCharYPos,y
	xba
	lda.l DATA8_C27915,x
	clc
	adc.w wCharXPos,y
	rep #$20 ;A->16
	sta.b wTemp00
	pha
	jsl.l func_C359AF
	pla
	sta.b wTemp04
	ldx.b wTemp00
	stx.b wTemp03
	plx
	bne @lbl_C27904
	sep #$20 ;A->8
	lda.b wTemp02
	asl a
	and.b wTemp02
	rep #$20 ;A->16
	bmi @lbl_C27904
	cpy.b #$13
	beq @lbl_C27910
	ldx.b wTemp01
	bmi @lbl_C27910
	lda.b wTemp00
	pha
	lda.b wTemp02
	pha
	lda.b wTemp04
	pha
	jsl.l func_C307C9
	pla
	sta.b wTemp04
	pla
	sta.b wTemp02
	pla
	sta.b wTemp00
	ldx.b wTemp06
	bne @lbl_C27910
@lbl_C27904:
	ldx.b wTemp02
	bmi @lbl_C2790C
	ldx.b #$E0
	stx.b wTemp02
@lbl_C2790C:
	ldx.b #$80
	stx.b wTemp00
@lbl_C27910:
	pla
	sta.b wTemp06
	plp
	rtl

DATA8_C27915:
	.db $01,$01                           ;C27915

DATA8_C27917:
	.db $00,$FF,$FF,$FF,$00,$01,$01,$01   ;C27917

func_C2791F:
	php
	sep #$30 ;AXY->8
	lda.b wTemp02
	bmi @lbl_C2794F
	ldx.b wTemp00
	lda.l wCharTrapsActivated,x
	bne @lbl_C2793D
	lda.l wCharRemainingTigerTrapTurns,x
	beq @lbl_C27949
	bmi @lbl_C2793D
	dec a
	sta.l wCharRemainingTigerTrapTurns,x
	beq @lbl_C27949
@lbl_C2793D:
	lda.l wCharXPos,x
	sta.b wTemp02
	lda.l wCharYPos,x
	sta.b wTemp03
@lbl_C27949:
	stx.b wTemp00
	jsl.l func_C27951
@lbl_C2794F:
	plp
	rtl

func_C27951:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	rep #$20 ;A->16
	lda.b wTemp02
	ldx.w wCharXPos,y
	stx.b wTemp00
	ldx.w wCharYPos,y
	stx.b wTemp01
	ldx.b #$80
	stx.b wTemp02
	pha
	jsl.l func_C35B7A
	pla
	sta.b wTemp00
	sty.b wTemp02
	pha
	jsl.l func_C35B7A
	pla
	sta.b wTemp00
	pha
	jsl.l func_C359AF
	sep #$20 ;A->8
	lda.b wTemp02
	sta.w wCharUnderfootTerrainType,y
	lda.w $894A
	beq @lbl_C279B7
	lda.w wCharRemainingTigerTrapTurns,y
	bne @lbl_C279B7
	lda.w wCharType,y
	cmp.b #$21
	beq @lbl_C279B7
	cmp.b #$02
	beq @lbl_C279B7
	cmp.b #$0E
	beq @lbl_C279B7
	cmp.b #$13
	beq @lbl_C279B7
	cmp.b #$20
	beq @lbl_C279B7
	lda.b wTemp01
	cmp.b #$C0
	bcc @lbl_C279B7
	sta.w wCharTrapsActivated,y
	stz.w $8977
@lbl_C279B7:
	rep #$20 ;A->16
	pla
	sta.b wTemp04
	sty.b wTemp00
	sep #$20 ;A->8
	sta.w wCharXPos,y
	xba
	sta.w wCharYPos,y
	lda.w wCharDir,y
	sta.b wTemp03
	lda.w wCharAppearance,y
	sta.b wTemp01
	jsl.l func_C626B5
	plp
	rtl

func_C279D7:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	ldy.b #$00
	lda.w wCharTargetXPos,x
	sec
	sbc.w wCharXPos,x
	beq @lbl_C279F0
	ldy.b #$01
	bcs @lbl_C279F0
	ldy.b #$02
	eor.b #$FF
	inc a
@lbl_C279F0:
	sta.b wTemp01
	sty.b wTemp00
	ldy.b #$00
	lda.w wCharTargetYPos,x
	sec
	sbc.w wCharYPos,x
	beq @lbl_C27A08
	ldy.b #$04
	bcs @lbl_C27A08
	ldy.b #$08
	eor.b #$FF
	inc a
@lbl_C27A08:
	sec
	sbc.b wTemp01
	sta.b wTemp01
	tya
	ora.b wTemp00
	tax
	lda.l UNREACH_C27852,x
	sta.b wTemp00
	plp
	rtl

func_C27A19:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.b #$02
	sta.w wCharDir,y
	lda.w wCharUnderfootTerrainType,y
	sta.b wTemp00
	stz.b wTemp01
	phy
	jsl.l func_C36549
	ply
	lda.w wCharTargetXPos,y
	cmp.b wTemp00
	bne @lbl_C27A40
	lda.b #$04
	sta.w wCharDir,y
@lbl_C27A40:
	lda.w wCharDir,y
	pha
	ldx.b #$05
	lda.b wTemp01,s
	clc
	adc.l UNREACH_C27A7F,x
	and.b #$07
	sta.w wCharDir,y
	sty.b wTemp00
	phx
	phy
	call_savebank func_C2785E
	ply
	plx
	lda.b wTemp00
	bpl @lbl_C27A66
	lda.b wTemp02
	bpl @lbl_C27A76
@lbl_C27A66:
	.db $CA,$10,$DD,$68,$99,$DD,$85,$C2,$20,$A9,$FF,$FF,$85,$00,$28,$6B
@lbl_C27A76:
	pla
	rep #$20 ;A->16
	lda.b wTemp04
	sta.b wTemp00
	plp
	rtl

UNREACH_C27A7F:
	.db $03,$05,$FF,$01,$04               ;C27A7F  
	.db $00                               ;C27A84

func_C27A85:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wCharDir,y
	pha
	ldx.b #$04
@lbl_C27A94:
	lda.b wTemp01,s
	clc
	adc.l DATA8_C27ACD,x
	and.b #$07
	sta.w wCharDir,y
	sty.b wTemp00
	phx
	phy
	call_savebank func_C2785E
	ply
	plx
	lda.b wTemp00
	bpl @lbl_C27AB4
	lda.b wTemp02
	bpl @lbl_C27AC4
@lbl_C27AB4:
	dex
	bpl @lbl_C27A94
	pla
	sta.w wCharDir,y
	rep #$20 ;A->16
	lda.w #$FFFF
	sta.b wTemp00
	plp
	rtl
@lbl_C27AC4:
	pla
	rep #$20 ;A->16
	lda.b wTemp04
	sta.b wTemp00
	plp
	rtl

DATA8_C27ACD:
	.db $FE,$02,$FF,$01,$00               ;C27ACD

func_C27AD2:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wCharDir,y
	pha
	phy
	jsl.l func_C279D7
	ply
	lda.b wTemp00
	pha
	ldx.b wTemp01
	bmi @lbl_C27AEE
	ora.b #$08
@lbl_C27AEE:
	tax
	lda.l DATA8_C27B3F,x
	tax
@lbl_C27AF4:
	lda.b wTemp01,s
	clc
	adc.l DATA8_C27B38,x
	and.b #$07
	sta.w wCharDir,y
	sty.b wTemp00
	phx
	phy
	call_savebank func_C2785E
	ply
	plx
	lda.b wTemp02
	bmi @lbl_C27B19
	lda.b wTemp00
	bmi @lbl_C27B2E
	lda.w wCharDir,y
	sta.b wTemp02,s
@lbl_C27B19:
	dex
	lda.l DATA8_C27B38,x
	bne @lbl_C27AF4
	pla
	pla
	sta.w wCharDir,y
	rep #$20 ;A->16
	lda.w #$FFFF
	sta.b wTemp00
	plp
	rtl
@lbl_C27B2E:
	pla
	pla
	rep #$20 ;A->16
	lda.b wTemp04
	sta.b wTemp00
	plp
	rtl

DATA8_C27B38:
	.db $00,$FF,$01,$00,$01,$FF,$00       ;C27B38

DATA8_C27B3F:
	.db $03,$06                           ;C27B3F
	.db $03                               ;C27B41  
	.db $03,$03,$06                       ;C27B42
	.db $03                               ;C27B45  
	.db $03                               ;C27B46
	.db $03                               ;C27B47  
	.db $03,$03,$06                       ;C27B48
	.db $03                               ;C27B4B  
	.db $03,$03,$06                       ;C27B4C

func_C27B4F:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7E85C8
	sta.l wCharTargetXPos,x
	lda.l $7E85DC
	sta.l wCharTargetYPos,x
	jsl.l func_C27AD2
	plp
	rtl

func_C27B6A:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharUnderfootTerrainType,x
	and.b #$0F
	sta.b wTemp00
	phx
	jsl.l func_C3653C
	plx
	lda.b wTemp00
	beq @lbl_C27B8C
	dec a
	bne @lbl_C27BB0
	lda.l wCharUnderfootTerrainType,x
	bit.b #$40
	beq @lbl_C27B98
@lbl_C27B8C:
	lda.b #$FF
	sta.l wCharTargetXPos,x
	sta.l wCharTargetYPos,x
	plp
	rtl
@lbl_C27B98:
	stz.b wTemp01
	sta.b wTemp00
	phx
	jsl.l func_C36549
	plx
	lda.b wTemp00
	sta.l wCharTargetXPos,x
	lda.b wTemp01
	sta.l wCharTargetYPos,x
	plp
	rtl
@lbl_C27BB0:
	pha
@lbl_C27BB1:
	stz.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	phx
	jsl.l func_C3F69F
	plx
	lda.b wTemp00
	sta.b wTemp01
	lda.l wCharUnderfootTerrainType,x
	and.b #$0F
	sta.b wTemp00
	phx
	jsl.l func_C36549
	plx
	lda.b wTemp00
	cmp.l wCharXPos,x
	bne @lbl_C27BDF
	lda.b wTemp01
	cmp.l wCharYPos,x
	beq @lbl_C27BB1
@lbl_C27BDF:
	pla
	lda.b wTemp00
	sta.l wCharTargetXPos,x
	lda.b wTemp01
	sta.l wCharTargetYPos,x
	plp
	rtl

func_C27BEE:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharTargetXPos,x
	bmi @lbl_C27C23
	cmp.l wCharXPos,x
	bne @lbl_C27C1B
	lda.l wCharTargetYPos,x
	cmp.l wCharYPos,x
	bne @lbl_C27C1B
	lda.b #$FF
	sta.l wCharTargetXPos,x
	sta.l wCharTargetYPos,x
	stx.b wTemp00
	jsl.l func_C27A85
	plp
	rtl
@lbl_C27C1B:
	stx.b wTemp00
	jsl.l func_C27AD2
	plp
	rtl
@lbl_C27C23:
	lda.l wCharUnderfootTerrainType,x
	bit.b #$10
	bne @lbl_C27C41
	stx.b wTemp00
	phx
	jsl.l func_C27B6A
	plx
	lda.l wCharTargetXPos,x
	bmi @lbl_C27C65
	stx.b wTemp00
	jsl.l func_C27AD2
	plp
	rtl
@lbl_C27C41:
	bit.b #$40
	beq @lbl_C27C65
	stx.b wTemp00
	phx
	jsl.l func_C27B6A
	plx
	lda.l wCharTargetXPos,x
	bpl @lbl_C27C5D
	lda.l wCharDir,x
	eor.b #$04
	sta.l wCharDir,x
@lbl_C27C5D:
	stx.b wTemp00
	jsl.l func_C27A85
	plp
	rtl
@lbl_C27C65:
	stx.b wTemp00
	jsl.l func_C27A85
	plp
	rtl

func_C27C6D:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharUnderfootTerrainType,x
	bit.b #$40
	beq @lbl_C27C7C
	and.b #$0F
@lbl_C27C7C:
	bit.b #$10
	bne @lbl_C27C92
	sta.b wTemp01
	lda.l $7E87D0
	bmi @lbl_C27C92
	bit.b #$40
	beq @lbl_C27C8E
	and.b #$0F
@lbl_C27C8E:
	cmp.b wTemp01
	beq @lbl_C27C9E
@lbl_C27C92:
	stx.b wTemp00
	jsl.l func_C277F8
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C27CA4
@lbl_C27C9E:
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C27CA4:
	stz.b wTemp00
	plp
	rtl

func_C27CA8:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharNPCFlags,x
	ora.l wCharIgnoreShiren,x
	lsr a
	bcs @lbl_C27CD0
	phx
	jsl.l func_C27C6D
	plx
	lda.b wTemp00
	beq @lbl_C27CD0
	lda.b #$00
	sta.l wCharDeadEndWaitingTurn,x
	stx.b wTemp00
	jsl.l func_C27B4F
	plp
	rtl
@lbl_C27CD0:
	lda.l wCharDeadEndWaitingTurn,x
	cmp.b #$06
	bcs @lbl_C27CFB
	stx.b wTemp00
	phx
	jsl.l func_C27BEE
	plx
	lda.b wTemp00
	bmi @lbl_C27CEC
	lda.b #$00
	sta.l wCharDeadEndWaitingTurn,x
	plp
	rtl
@lbl_C27CEC:
	lda.l wCharDeadEndWaitingTurn,x
	cmp.b #$05
	bcs @lbl_C27CFB
	inc a
	sta.l wCharDeadEndWaitingTurn,x
	plp
	rtl
@lbl_C27CFB:
	inc a
	and.b #$07
	sta.l wCharDeadEndWaitingTurn,x
	lda.b #$FF
	sta.l wCharTargetXPos,x
	sta.l wCharTargetYPos,x
	jsl.l Random
	lda.b wTemp00
	and.b #$07
	sta.l wCharDir,x
	stx.b wTemp00
	phx
	jsl.l func_C27A85
	plx
	lda.l wCharUnderfootTerrainType,x
	bit.b #$10
	beq @lbl_C27D3A
	lda.b wTemp00
	bpl @lbl_C27D34
	lda.b #$06
	sta.l wCharDeadEndWaitingTurn,x
	plp
	rtl
@lbl_C27D34:
	lda.b #$05
	sta.l wCharDeadEndWaitingTurn,x
@lbl_C27D3A:
	plp
	rtl
	php                                     ;C27D3C
	sep #$30                                ;C27D3D
	ldx $00                                 ;C27D3F
	jmp $7CD0                               ;C27D41
	php                                     ;C27D44
	sep #$30                                ;C27D45
	lda #$FF                                ;C27D47
	pha                                     ;C27D49
	ldx #$00                                ;C27D4A
@lbl_C27D4C:
	lda $7E85F1,x                           ;C27D4C
	beq @lbl_C27D65                         ;C27D50
	lda $7E8781,x                           ;C27D52
	bmi @lbl_C27D65                         ;C27D56
	txa                                     ;C27D58
	stx $00                                 ;C27D59
	phx                                     ;C27D5B
	jsl $C27C6D                             ;C27D5C
	plx                                     ;C27D60
	lda $00                                 ;C27D61
	bne @lbl_C27D77                         ;C27D63
@lbl_C27D65:
	inx                                     ;C27D65
	cpx #$13                                ;C27D66
	bcc @lbl_C27D4C                         ;C27D68
	plx                                     ;C27D6A
	bpl @lbl_C27DB0                         ;C27D6B
	lda #$13                                ;C27D6D
	sta $00                                 ;C27D6F
	jsl $C27D3C                             ;C27D71
	bra @lbl_C27DCE                         ;C27D75
@lbl_C27D77:
	txa                                     ;C27D77
	sta $01,s                               ;C27D78
	stx $00                                 ;C27D7A
	phx                                     ;C27D7C
	jsl $C277F8                             ;C27D7D
	plx                                     ;C27D81
	lda $00                                 ;C27D82
	cmp #$01                                ;C27D84
	bne @lbl_C27D65                         ;C27D86
	lda $01                                 ;C27D88
	eor #$04                                ;C27D8A
	sta $7E85F0                             ;C27D8C
	lda #$13                                ;C27D90
	sta $00                                 ;C27D92
	phx                                     ;C27D94
	jsl $C2785E                             ;C27D95
	plx                                     ;C27D99
	lda $00                                 ;C27D9A
	bmi @lbl_C27D65                         ;C27D9C
	pla                                     ;C27D9E
	txa                                     ;C27D9F
	sta $7E8730                             ;C27DA0
	lda #$13                                ;C27DA4
	sta $00                                 ;C27DA6
	jsl $C2121A                             ;C27DA8
	stz $00                                 ;C27DAC
	plp                                     ;C27DAE
	rts                                     ;C27DAF
@lbl_C27DB0:
	lda #$00                                ;C27DB0
	sta $7E8820                             ;C27DB2
	lda $7E85B5,x                           ;C27DB6
	sta $7E87E4                             ;C27DBA
	lda $7E85C9,x                           ;C27DBE
	sta $7E87F8                             ;C27DC2
	lda #$13                                ;C27DC6
	sta $00                                 ;C27DC8
	jsl $C27AD2                             ;C27DCA
@lbl_C27DCE:
	rep #$20                                ;C27DCE
	lda $00                                 ;C27DD0
	sta $02                                 ;C27DD2
	sep #$20                                ;C27DD4
	ldx #$13                                ;C27DD6
	stx $00                                 ;C27DD8
	jsl $C2791F                             ;C27DDA
	lda #$01                                ;C27DDE
	sta $00                                 ;C27DE0
	plp                                     ;C27DE2
	rts                                     ;C27DE3

func_C27DE4:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	bne @lbl_C27DEF
	plp
	rtl
@lbl_C27DEF:
	lda.l $7E871C
	ora.l $7E885C
	bne @lbl_C27E76
	lda.l $7E87BC
	cmp.b #$1B
	beq @lbl_C27E26
	lda.l $7E8948
	beq @lbl_C27E26
	dec a
	bne @lbl_C27E12
	jsl.l Random
	lda.b wTemp00
	bpl @lbl_C27E1C
@lbl_C27E12:
	lda.l wCharIsAwake,x
	and.b #$FE
	sta.l wCharIsAwake,x
@lbl_C27E1C:
	lda.l wCharIsAwake,x
	and.b #$FB
	sta.l wCharIsAwake,x
@lbl_C27E26:
	lda.l wCharAttackTarget,x
	bpl @lbl_C27E76
	lda.l wCharNPCFlags,x
	and.b #$01
	ora.l wCharIsAwake,x
	ora.l wCharRemainingSleepTurns,x
	ora.l wCharRemainingConfusedTurns,x
	ora.l wCharRemainingPuzzledTurns,x
	ora.l wCharRemainingBlindlessTurns,x
	ora.l wCharIsKigny,x
	ora.l wCharIgnoreShiren,x
	bne @lbl_C27E76
	lda.l $7E899A
	cmp.b #$13
	bne @lbl_C27E76
	stx.b wTemp00
	phx
	jsl.l func_C277F8
	plx
	lda.b wTemp01
	sta.l wCharDir,x
	lda.l $7E85C8
	sta.l wCharTargetXPos,x
	lda.l $7E85DC
	sta.l wCharTargetYPos,x
@lbl_C27E76:
	plp
	rtl

func_C27E78:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b #$04
	sta.l wCharIsAwake,x
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$A9,$08,$9F   ;C27E85
	.db $31,$87,$7E,$28,$6B               ;C27E8D  

func_C27E92:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b #$02
	sta.l wCharIsAwake,x
	cpx.b #$13
	bne @lbl_C27EA7
	lda.b #$32
	sta.l $7E89B2
@lbl_C27EA7:
	plp
	rtl

func_C27EA9:
	jmp.w func_C27E92

func_C27EAC:
	php
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E8758
	plp
	rtl

func_C27EB7:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharRemainingTigerTrapTurns,x
	bne @lbl_C27EC8
	lda.b #$0A
	sta.l wCharRemainingTigerTrapTurns,x
@lbl_C27EC8:
	plp
	rtl

func_C27ECA:
	php
	sep #$20 ;A->8
	lda.l $7E899B
	bne @lbl_C27EDF
	lda.l $7E8971
	bmi @lbl_C27EDF
	sta.b wTemp00
	jsl.l func_C32CFE
@lbl_C27EDF:
	plp
	rtl
	php                                     ;C27EE1
	sep #$20                                ;C27EE2
	jsl $C62787                             ;C27EE4
	lda $00                                 ;C27EE8
	bne @lbl_C27F0E                         ;C27EEA
	lda #$13                                ;C27EEC
	sta $00                                 ;C27EEE
	lda #$16                                ;C27EF0
	sta $02                                 ;C27EF2
	jsl $C62550                             ;C27EF4
	lda #$13                                ;C27EF8
	sta $00                                 ;C27EFA
	sta $01                                 ;C27EFC
	lda #$08                                ;C27EFE
	sta $02                                 ;C27F00
	jsl $C228EF                             ;C27F02
	lda #$01                                ;C27F06
	sta $7E8979                             ;C27F08
	plp                                     ;C27F0C
	rtl                                     ;C27F0D
@lbl_C27F0E:
	dec a                                   ;C27F0E
	bne @lbl_C27F33                         ;C27F0F
	lda #$13                                ;C27F11
	sta $00                                 ;C27F13
	lda #$16                                ;C27F15
	sta $02                                 ;C27F17
	jsl $C62550                             ;C27F19
	lda #$13                                ;C27F1D
	sta $00                                 ;C27F1F
	sta $01                                 ;C27F21
	lda #$08                                ;C27F23
	sta $02                                 ;C27F25
	jsl $C228EF                             ;C27F27
	lda #$04                                ;C27F2B
	sta $7E8979                             ;C27F2D
	plp                                     ;C27F31
	rtl                                     ;C27F32
@lbl_C27F33:
	lda #$13                                ;C27F33
	sta $00                                 ;C27F35
	lda #$17                                ;C27F37
	sta $02                                 ;C27F39
	jsl $C62550                             ;C27F3B
	lda #$13                                ;C27F3F
	sta $00                                 ;C27F41
	sta $01                                 ;C27F43
	lda #$08                                ;C27F45
	sta $02                                 ;C27F47
	jsl $C228EF                             ;C27F49
	plp                                     ;C27F4D
	rtl                                     ;C27F4E
	php                                     ;C27F4F
	sep #$20                                ;C27F50
	lda #$03                                ;C27F52
	sta $7E8979                             ;C27F54
	plp                                     ;C27F58
	rtl                                     ;C27F59

func_C27F5A:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.b #$FF
	pha
	pha
	ldx.b #$07
@lbl_C27F67:
	lda.l DATA8_C27915,x
	clc
	adc.w $85C8
	sta.b wTemp00
	lda.l DATA8_C27917,x
	clc
	adc.w $85DC
	sta.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	ldy.b wTemp00
	bmi @lbl_C27F8D
	lda.w wCharIsAwake,y
	bit.b #$02
	bne @lbl_C27F8D
	phy
@lbl_C27F8D:
	dex
	bpl @lbl_C27F67
	lda.b wTemp02,s
	bmi @lbl_C27FA2
	ply
@lbl_C27F95:
	lda.b #$02
	sta.w wCharIsAwake,y
	ply
	bpl @lbl_C27F95
	pla
	sta.b wTemp00
	plp
	rtl
@lbl_C27FA2:
	pla
	bpl @lbl_C27FA2
	pla
	stz.b wTemp00
	plp
	rtl

func_C27FAA:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharIsSealed,x
	bmi @lbl_C27FBB
	lda.b #$00
	sta.l wCharIsAwake,x
@lbl_C27FBB:
	plp
	rtl

func_C27FBD:
	php 
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b #$12
@lbl_C27FC6:
	lda.w $8781,y
	bmi @lbl_C27FD0
	lda.b #$00
	sta.w $8731,y
@lbl_C27FD0:
	dey 
	bpl @lbl_C27FC6
	plp 
	rtl

func_C27FD5:
	php 
	sep #$30 ;AXY->8
	ldx.b #$12
@lbl_C27FDA:
	lda.l $7E85F1,x
	beq @lbl_C28016
	stx.b wTemp00
	phx
	jsl.l func_C20F35
	plx
	lda.l $7E85B5,x
	sta.b wTemp00
	pha
	lda.l $7E85C9,x
	sta.b wTemp01
	pha
	lda.l $7E85DD,x
	sta.b wTemp02
	lda.b #$01
	sta.b wTemp03
	phx
	jsl.l func_C2007D
	plx
	ldy.b wTemp00
	pla
	sta.b wTemp01
	pla
	sta.b wTemp00
	sty.b wTemp02
	phx
	jsl.l func_C35B7A
	plx
@lbl_C28016:
	dex 
	bpl @lbl_C27FDA
	plp 
	rtl

func_C2801B:
	php 
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7E85A1,x
	cmp.b #$28
	bne @lbl_C28038
	stx.b wTemp00
	lda.b #$25
	sta.b wTemp01
	lda.b #$02
	sta.b wTemp02
	jsl.l func_C280D4
	plp 
	rtl
@lbl_C28038:
	lda.b wTemp00
	cmp.b #$13
	bne @lbl_C28050
	jsl.l GetCurrentFloor
	jsl.l func_C20B4B
	jsl.l func_C24167
	lda.b #$13
	sta.b wTemp00
	plp 
	rtl
@lbl_C28050:
	tax 
	lda.l $7E8759,x
	bmi @lbl_C28065
	sta.b wTemp00
	lda.b #$FF
	sta.l $7E8759,x
	phx
	jsl.l func_C306F4
	plx
@lbl_C28065:
	lda.l $7E85A1,x
	pha
	lda.b #$00
	sta.l $7E8781,x
	txa 
	sta.b wTemp00
	pha
	jsl.l GetCharacterMapInfo
	pla
	rep #$10 ;XY->16
	ldx.b wTemp00
	sta.b wTemp00
	phx
	jsl.l func_C20F35
	plx
	jsl.l func_C62AAF
	lda.b wTemp00
	cmp.b #$1B
	bcc @lbl_C28091
	lda.b #$1B
@lbl_C28091:
	sta.b wTemp01
	lda.b #$01
	sta.b wTemp00
	phx
	jsl.l func_C3F69F
	plx
	lda.b wTemp00
	sta.b wTemp02
	pla
	sta.b wTemp03
	ldy.b wTemp02
	lda.b #$01
	sta.l $7E89B9
@lbl_C280AC:
	stx.b wTemp00
	sty.b wTemp02
	phx
	phy
	jsl.l func_C20BC7
	ply
	plx
	lda.l $7E89B9
	bne @lbl_C280AC
	lda.b wTemp00
	bmi @lbl_C280D2
	stx.b wTemp00
	sta.b wTemp02
	pha
	jsl.l func_C35B7A
	pla
	sta.b wTemp00
	jsl.l func_C27FAA
@lbl_C280D2:
	plp 
	rtl

func_C280D4:
	php 
	sep #$30 ;AXY->8
	lda.b wTemp01
	pha
	lda.b wTemp02
	pha
	ldx.b wTemp00
	lda.l $7E8759,x
	bmi @lbl_C380F3
	sta.b wTemp00
	lda.b #$FF
	sta.l $7E8759,x
	phx
	jsl.l func_C306F4
	plx
@lbl_C380F3:
	lda.b #$00
	sta.l $7E8781,x
	lda.l $7E899A
	pha
	lda.b #$13
	sta.l $7E899A
	stx.b wTemp00
	phx
	jsl.l func_C20F35
	plx
	pla
	sta.l $7E899A
	stx.b wTemp00
	phx
	jsl.l GetCharacterMapInfo
	plx
	stx.b wTemp05
	pla
	sta.b wTemp04
	pla
	sta.b wTemp03
	lda.l $7E87D1,x
	pha
	lda.l $7E87E5,x
	pha
	lda.l $7E86B9,x
	pha
	rep #$10 ;XY->16
	ldx.b wTemp00
	phx
	jsl.l func_C20072
	plx
	lda.b wTemp00
	stx.b wTemp00
	sta.b wTemp02
	pha
	jsl.l func_C35B7A
	pla
	sep #$10 ;XY->8
	tax 
	cmp.l $7E899A
	bne @lbl_C28155
	lda.b #$00
	sta.l $7E87A9,x
@lbl_C28155:
	pla
	sta.l $7E86B9,x
	pla
	sta.l $7E87E5,x
	pla
	sta.l $7E87D1,x
	stx.b wTemp00
	jsl.l func_C27FAA
	plp 
	rtl


func_C2816C:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharXPos,x
	sta.b wTemp00
	lda.l wCharYPos,x
	sta.b wTemp01
	phx
	jsl.l func_C3631A
	plx
	lda.b wTemp00
	bpl @lbl_C2818B
;C28187  
	.db $64,$00,$28,$6B
@lbl_C2818B:
	lda.l wCharDir,x
	sta.b wTemp02
	lda.l wCharType,x
	cpx.b #$13
	bne @lbl_C2819D
;C28199  
	.db $BF,$A9,$87,$7E
@lbl_C2819D:
	sta.b wTemp03
	lda.l wCharLevel,x
	sta.b wTemp04
	txy
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	phy
	jsl.l func_C20086
	ply
	pla
	ldx.b wTemp00
	bmi @lbl_C28211
	sta.b wTemp00
	stx.b wTemp02
	phx
	jsl.l func_C35B7A
	plx
	stx.b wTemp00
	phx
	phy
	jsl.l func_C27FAA
	ply
	plx
	sep #$20 ;A->8
	lda.l $7E85C8
	sta.l wCharTargetXPos,x
	lda.l $7E85DC
	sta.l wCharTargetYPos,x
	stx.b wTemp00
	lda.l wCharAppearance,x
	sta.b wTemp01
	lda.b #$06
	sta.b wTemp02
	lda.l wCharDir,x
	sta.b wTemp03
	lda.l wCharXPos,x
	sta.b wTemp06
	lda.l wCharYPos,x
	sta.b wTemp07
	tyx
	lda.l wCharXPos,x
	sta.b wTemp04
	lda.l wCharYPos,x
	sta.b wTemp05
	jsl.l func_C626A0
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C28211:
	stz $00                                 ;C3820F
	plp                                     ;C38211
	rtl                                     ;C38212
	php                                     ;C38213
	sep #$30                                ;C38214
	ldx $00                                 ;C38216
	lda #$C1                                ;C38218
	sta $7E897D                             ;C3821A
	ldy #$80                                ;C3821E
	lda $01                                 ;C38220
	beq @lbl_C38226                         ;C38222
	ldy #$80                                ;C38224
@lbl_C38226:
	sty $02                                 ;C38226
	phx                                     ;C38228
	jsl $C626F6                             ;C38229
	plx                                     ;C3822D
	stx $00                                 ;C3822E
	phx                                     ;C38230
	jsl $C282EB                             ;C38231
	plx                                     ;C38235
	stx $00                                 ;C38236
	phx                                     ;C38238
	jsl $C20F35                             ;C38239
	plx                                     ;C3823D
	lda $7E85C9,x                           ;C3823E
	xba                                     ;C38242
	lda $7E85B5,x                           ;C38243
	rep #$20                                ;C38247
	pha                                     ;C38249
	ldx #$30                                ;C3824A
	phx                                     ;C3824C
	lda $02,s                               ;C3824D
	clc                                     ;C3824F
	adc $C282B9,x                           ;C38250
	sta $00                                 ;C38254
	pha                                     ;C38256
	jsl $C359AF                             ;C38257
	pla                                     ;C3825B
	ldx $00                                 ;C3825C
	phx                                     ;C3825E
	ldx $01                                 ;C3825F
	bmi @lbl_C38275                         ;C38261
	sta $00                                 ;C38263
	ldy #$80                                ;C38265
	sty $02                                 ;C38267
	phx                                     ;C38269
	jsl $C35BA2                             ;C3826A
	plx                                     ;C3826E
	stx $00                                 ;C3826F
	jsl $C306F4                             ;C38271
@lbl_C38275:
	plx                                     ;C38275
	bmi @lbl_C382AC                         ;C38276
	sep #$20                                ;C38278
	cpx #$13                                ;C3827A
	bne @lbl_C38292                         ;C3827C
	phx                                     ;C3827E
	jsl $C28588                             ;C3827F
	plx                                     ;C38283
	lda $00                                 ;C38284
	beq @lbl_C382AA                         ;C38286
	lda $7E85F1,x                           ;C38288
	cmp #$01                                ;C3828C
	bne @lbl_C382A4                         ;C3828E
	bra @lbl_C3829A                         ;C38290
@lbl_C38292:
	stx $00                                 ;C38292
	phx                                     ;C38294
	jsl $C282EB                             ;C38295
	plx                                     ;C38299
@lbl_C3829A:
	stx $00                                 ;C3829A
	phx                                     ;C3829C
	jsl $C20F35                             ;C3829D
	plx                                     ;C382A1
	bra @lbl_C382AA                         ;C382A2
@lbl_C382A4:
	lda #$01                                ;C382A4
	sta $7E85F1,x                           ;C382A6
@lbl_C382AA:
	rep #$20                                ;C382AA
@lbl_C382AC:
	plx                                     ;C382AC
	dex                                     ;C382AD
	dex                                     ;C382AE
	bpl @lbl_C382B4                         ;C382AF
	pla                                     ;C382B1
	plp                                     ;C382B2
	rtl                                     ;C382B3
@lbl_C382B4:
	jmp $824E                               ;C382B4
	inc $FFFD,x                             ;C382B7
	sbc $FE00,x                             ;C382BA
	ora ($FE,x)                             ;C382BD
	.db $02   ;C382BF
	inc $FEFE,x                             ;C382C0
	sbc $FF00FE,x                           ;C382C3
	ora ($FF,x)                             ;C382C7
	.db $02   ;C382C9
	sbc $FFFFFE,x                           ;C382CA
	sbc $010000,x                           ;C382CE
	.db $00   ;C382D2
	.db $02   ;C382D3
	.db $00   ;C382D4
	inc $FF00,x                             ;C382D5
	.db $00   ;C382D8
	.db $00   ;C382D9
	ora ($01,x)                             ;C382DA
	ora ($02,x)                             ;C382DC
	ora ($FE,x)                             ;C382DE
	ora ($FF,x)                             ;C382E0
	ora ($00,x)                             ;C382E2
	.db $02   ;C382E4
	ora ($02,x)                             ;C382E5
	.db $02   ;C382E7
	.db $02   ;C382E8
.ACCU 8

func_C282EB:
	php
	sep #$20 ;A->8
	lda.b #$05
	sta.b wTemp02
	jsl.l func_C62565
	plp
	rtl
	php                                     ;C382F6
	sep #$30                                ;C382F7
	ldx $00                                 ;C382F9
	lda $01                                 ;C382FB
	sta $7E8709,x                           ;C382FD
	plp                                     ;C38301
	rtl                                     ;C38302
	php                                     ;C38303
	sep #$30                                ;C38304
	ldx $00                                 ;C38306
	lda #$00                                ;C38308
	sta $7E8781,x                           ;C3830A
	sta $7E8709,x                           ;C3830E
	sta $7E88AD,x                           ;C38312
	sta $7E88C1,x                           ;C38316
	sta $7E86B9,x                           ;C3831A
	txa                                     ;C3831E
	cmp $7E899A                             ;C3831F
	bne @lbl_C3832B                         ;C38323
	lda #$13                                ;C38325
	sta $7E899A                             ;C38327
@lbl_C3832B:
	lda #$01                                ;C3832B
	sta $7E876D,x                           ;C3832D
	lda $7E85A1,x                           ;C38331
	sta $7E87A9,x                           ;C38335
	cpx #$13                                ;C38339
	bne @lbl_C3834C                         ;C3833B
	lda $7E899B                             ;C3833D
	beq @lbl_C3834C                         ;C38341
	lda #$01                                ;C38343
	sta $7E899B                             ;C38345
	jsr $30F6                               ;C38349
@lbl_C3834C:
	plp                                     ;C3834C
	rtl                                     ;C3834D
	php                                     ;C3834E
	sep #$30                                ;C3834F
	ldx $00                                 ;C38351
	phx                                     ;C38353
	jsl $C282EB                             ;C38354
	plx                                     ;C38358
	stx $00                                 ;C38359
	phx                                     ;C3835B
	jsl $C20F35                             ;C3835C
	plx                                     ;C38360
	lda $7E8641,x                           ;C38361
	sta $02                                 ;C38365
	lda $7E8655,x                           ;C38367
	sta $03                                 ;C3836B
	lda $7E8669,x                           ;C3836D
	sta $04                                 ;C38371
	lda #$13                                ;C38373
	sta $00                                 ;C38375
	jsl $C234DF                             ;C38377
	plp                                     ;C3837B
	rtl                                     ;C3837C

func_C2837F:
	php
	sep #$30 ;AXY->8
	lda.l $7E8975
	ora.l $7E8983
	bne @lbl_C2839C
	ldx.b wTemp00
	lda.l wCharIsAwake,x
	and.b #$08
	ora.l wCharInvisible,x
	sta.b wTemp06
	plp
	rtl
@lbl_C2839C:
	stz.b wTemp06
	plp
	rtl

func_C283A0:
	php
	sep #$20 ;A->8
	lda.l $7E8975
	ora.b #$01
	sta.l $7E8975
	jsl.l func_C35E1B
	plp
	rtl
	.db $08,$E2,$20,$A5,$00,$F0,$08,$AF,$75,$89,$7E,$09,$02,$80,$06,$AF   ;C283B3
	.db $75,$89,$7E,$29,$FD,$8F,$75,$89   ;C283C3  
	.db $7E,$22,$1B,$5E,$C3,$28,$6B       ;C283CB  

func_C283D2:
	php
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E8983
	jsl.l func_C35E1B
	plp
	rtl
	.db $08,$E2,$20,$A5,$00,$8F,$84,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00   ;C283E1
	.db $8F,$85,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00,$8F,$86,$89,$7E,$28   ;C283F1  
	.db $6B,$08,$E2,$20,$A5,$00,$8F,$87,$89,$7E,$28,$6B,$08,$E2,$20,$A5   ;C28401
	.db $00,$8F,$89,$89,$7E,$28,$6B       ;C28411

func_C28418:
	php
	sep #$20 ;A->8
	lda.l $7E8997
	inc a
	beq @lbl_C28426
	sta.l $7E8997
@lbl_C28426:
	plp
	rtl

func_C28428:
	php 
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E89A6
	plp 
	rtl

func_C28433:
	php 
	sep #$20 ;A->8
	ldx.b wTemp00
	lda.b wTemp01
	sta.l $7E88AD,x
	plp 
	rtl

func_C28440:
	php 
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E89A7
	lda.b #$06
	sta.l $7E85F0
	plp 
	rtl

func_C28451:
	php
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E89A8
	plp
	rtl
	.db $08,$E2,$20,$A5,$00,$8F,$8A,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00   ;C2845C
	.db $8F,$8B,$89,$7E,$28,$6B,$08,$E2,$20,$A9,$01,$8F,$B6,$89,$7E,$28   ;C2846C  
	.db $6B,$08,$E2,$20,$A5,$00,$8F,$8C,$89,$7E,$28,$6B,$08,$E2,$20,$AF   ;C2847C
	.db $8D,$89,$7E,$09,$01,$8F,$8D,$89,$7E,$28,$6B,$08,$E2,$20,$A5,$00   ;C2848C  
	.db $F0,$08,$AF,$8D,$89,$7E,$09,$02,$80,$06,$AF,$8D,$89,$7E,$29,$FD   ;C2849C  
	.db $8F,$8D,$89,$7E,$28,$6B           ;C284AC  

func_C284B2:
	php
	rep #$20 ;A->16
	lda.b wTemp00
	sta.l $7E89A2
	plp
	rtl

func_C284BD:
	php
	rep #$20 ;A->16
	lda.b wTemp00
	sta.l $7E89A4
	plp
	rtl

UNREACH_C284C8:
	.db $00   ;C384C6
	.db $00   ;C384C7
	.db $02   ;C384C8
	.db $00   ;C384C9
	.db $00   ;C384CA
	.db $00   ;C384CB
	.db $00   ;C384CC
	.db $00   ;C384CD
	.db $00   ;C384CE
	.db $00   ;C384CF
	.db $00   ;C384D0
	.db $00   ;C384D1
	.db $00   ;C384D2
	php                                     ;C384D3
	.db $02   ;C384D4
	.db $00   ;C384D5
	tsb $02                                 ;C384D6
	tsb $0102                               ;C384D8
	.db $00   ;C384DB
	.db $00   ;C384DC
	.db $00   ;C384DD
	.db $00   ;C384DE
	.db $00   ;C384DF
	.db $00   ;C384E0
	.db $00   ;C384E1
	.db $00   ;C384E2
	tsb $00                                 ;C384E3
	.db $00   ;C384E5
	ora ($02,x)                             ;C384E6
	.db $00   ;C384E8
	.db $00   ;C384E9
	.db $00   ;C384EA
	.db $00   ;C384EB
	tsb $08                                 ;C384EC
	.db $00   ;C384EE
	.db $00   ;C384EF
	.db $00   ;C384F0
	.db $00   ;C384F1
	.db $00   ;C384F2
	.db $00   ;C384F3
	.db $00   ;C384F4
	.db $00   ;C384F5
	.db $00   ;C384F6
	.db $00   ;C384F7
	.db $00   ;C384F8
	.db $00   ;C384F9
	.db $00   ;C384FA
	.db $00   ;C384FB
	.db $00   ;C384FC
	.db $00   ;C384FD
	.db $00   ;C384FE
	.db $00   ;C384FF
	.db $00   ;C38500
	.db $00   ;C38501
	.db $00   ;C38502
	.db $00   ;C38503
	.db $00   ;C38504
	.db $00   ;C38505
	.db $00   ;C38506
	.db $00   ;C38507
	.db $00   ;C38508
	.db $00   ;C38509
	.db $00   ;C3850A
	.db $00   ;C3850B
	.db $00   ;C3850C
	.db $00   ;C3850D
	.db $00   ;C3850E
	.db $00   ;C3850F
	.db $00   ;C38510
	.db $00   ;C38511
	.db $00   ;C38512
	.db $00   ;C38513
	.db $00   ;C38514
	.db $00   ;C38515
	.db $00   ;C38516
	.db $00   ;C38517
	.db $00   ;C38518
	.db $00   ;C38519
	.db $00   ;C3851A
	.db $00   ;C3851B
	.db $00   ;C3851C
	.db $00   ;C3851D
	.db $00   ;C3851E
	.db $00   ;C3851F
	.db $00   ;C38520
	.db $00   ;C38521
	.db $00   ;C38522
	.db $00   ;C38523
	.db $00   ;C38524
	.db $00   ;C38525
	.db $00   ;C38526
	.db $00   ;C38527
	.db $00   ;C38528
	.db $00   ;C38529
	.db $00   ;C3852A
	.db $00   ;C3852B
	.db $00   ;C3852C
	.db $00   ;C3852D
	.db $00   ;C3852E
	.db $00   ;C3852F
	.db $00   ;C38530
	.db $00   ;C38531
	.db $00   ;C38532
	.db $00   ;C38533
	.db $00   ;C38534
	.db $00   ;C38535
	.db $00   ;C38536
	.db $00   ;C38537
	.db $00   ;C38538
	.db $00   ;C38539
	.db $00   ;C3853A
	.db $00   ;C3853B
	.db $00   ;C3853C
	.db $00   ;C3853D
	.db $00   ;C3853E
	.db $00   ;C3853F
	.db $00   ;C38540
	.db $00   ;C38541
	.db $00   ;C38542
	.db $00   ;C38543
	.db $00   ;C38544
	.db $00   ;C38545
	.db $00   ;C38546
	.db $00   ;C38547
	.db $00   ;C38548
	.db $00   ;C38549
	.db $00   ;C3854A
	.db $00   ;C3854B
	.db $00   ;C3854C
	.db $00   ;C3854D
	.db $00   ;C3854E
	.db $00   ;C3854F
	.db $00   ;C38550
	.db $00   ;C38551
	.db $00   ;C38552
	.db $00   ;C38553
	.db $00   ;C38554
	.db $00   ;C38555
	.db $00   ;C38556
	.db $00   ;C38557
	.db $00   ;C38558
	.db $00   ;C38559
	.db $00   ;C3855A
	.db $00   ;C3855B
	.db $00   ;C3855C
	.db $00   ;C3855D
	.db $00   ;C3855E
	.db $00   ;C3855F
	.db $00   ;C38560
	.db $00   ;C38561
	.db $00   ;C38562
	.db $00   ;C38563
	.db $00   ;C38564
	.db $00   ;C38565
	.db $00   ;C38566
	.db $00   ;C38567
	.db $00   ;C38568
	.db $00   ;C38569
	.db $00   ;C3856A
	.db $00   ;C3856B
	.db $00   ;C3856C
	.db $00   ;C3856D
	.db $00   ;C3856E
	.db $00   ;C3856F
	.db $00   ;C38570
	.db $00   ;C38571
	.db $00   ;C38572
	.db $00   ;C38573
	.db $00   ;C38574
	.db $00   ;C38575
	.db $00   ;C38576
	.db $00   ;C38577
	.db $00   ;C38578
	.db $00   ;C38579
	.db $00   ;C3857A
	.db $00   ;C3857B
	.db $00   ;C3857C
	.db $00   ;C3857D
	.db $00   ;C3857E
	.db $00   ;C3857F
	.db $00   ;C38580
	.db $00   ;C38581
	.db $00   ;C38582
	.db $00   ;C38583
	.db $00   ;C38584
	.db $00   ;C38585

func_C28588:
	php
	sep #$30 ;AXY->8
	lda.l $7E89A5
	and.b #$02
	eor.b #$02
	sta.b wTemp00
	plp
	rtl

func_C28597:
	php
	sep #$20 ;A->8
	lda.l $7E86B8
	sta.b wTemp00
	plp
	rtl

func_C285A2:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharRemainingPuzzledTurns,x
	sta.b wTemp01
	lda.l wCharIsAwake,x
	and.b #$BF
	ora.l wCharRemainingSleepTurns,x
	sta.b wTemp02
	lda.l wCharRemainingConfusedTurns,x
	sta.b wTemp03
	lda.l wCharSpeed,x
	sta.b wTemp04
	cpx.b #$13
	beq @lbl_C285E7
	.db $64,$00,$AF,$75,$89,$7E,$0F,$83,$89,$7E,$0F,$60,$BE,$7E,$D0,$0C   ;C285C9  
	.db $BF,$31,$87,$7E,$29,$08,$1F,$09   ;C285D9  
	.db $87,$7E,$85,$00,$28,$6B           ;C285E1  
@lbl_C285E7:
	lda.l wCharRemainingBlindlessTurns,x
	sta.b wTemp00
	lda.l $7E871C
	sta.b wTemp05
	lda.l $7E8998
	and.b #$01
	ora.l $7E885C
	ora.b wTemp02
	sta.b wTemp02
	plp
	rtl

func_C28603:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharRemainingPuzzledTurns,x
	sta.b wTemp01
	lda.l wCharRemainingSleepTurns,x
	sta.b wTemp02
	lda.l wCharRemainingConfusedTurns,x
	sta.b wTemp03
	lda.l wCharSpeed,x
	sta.b wTemp04
	cpx.b #$13
	beq @lbl_C2864A
	lda.l wCharIsAwake,x
	and.b #$BF
	sta.b wTemp05
	stz.b wTemp00
	lda.l $7E8975
	ora.l $7E8983
	ora.l $7EBE60
	bne @lbl_C28664
	lda.l wCharIsAwake,x
	and.b #$08
	ora.l wCharInvisible,x
	sta.b wTemp00
	bra @lbl_C28664
@lbl_C2864A:
	lda.l $7E8998
	beq @lbl_C28652
	stz.b wTemp04
@lbl_C28652:
	lda.l $7E871C
	sta.b wTemp00
	lda.l wCharIsAwake,x
	and.b #$BF
	ora.l $7E885C
	sta.b wTemp05
@lbl_C28664:
	lda.l $7E86B8
	sta.b wTemp06
	lda.l $7E86E0
	sta.b wTemp07
	plp
	rtl

func_C28672:
	php 
	sep #$30 ;AXY->8
	ldy.b #$06
	lda.l $7E87D0
	bit.b #$10
	beq @lbl_C28681
	ldy.b #$05
@lbl_C28681:
	sty.b wTemp02
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C626F6
	ldx.b #$12
@lbl_C2868D:
	lda.l $7E85F1,x
	beq @lbl_C286C3
	lda.l $7E8781,x
	bmi @lbl_C286C3
	stx.b wTemp00
	phx
	jsl.l func_C2778A
	plx
	lda.b wTemp00
	beq @lbl_C286C3
	lda.b #$19
	sta.b wTemp00
	lda.b #$32
	sta.b wTemp01
	phx
	jsl.l func_C3F69F
	plx
	lda.b wTemp00
	sta.b wTemp02
	stx.b wTemp00
	lda.b #$13
	sta.b wTemp01
	phx
	jsl.l func_C228DF
	plx
@lbl_C286C3:
	dex 
	bpl @lbl_C2868D
	plp 
	rtl

func_C286C8:
	php 
	sep #$30 ;AXY->8
	lda.b #$57
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage
	ldx.b #$12
@lbl_C286D9:
	lda.l $7E85F1,x
	bne @lbl_C286E2
	jmp.w @lbl_C28766
@lbl_C286E2:
	lda.l $7E8781,x
	bmi @lbl_C28766
	stx.b wTemp00
	phx
	jsl.l func_C2778A
	plx
	lda.b wTemp00
	beq @lbl_C28766
	jsl.l Random
	lda.b wTemp00
	cmp.b #$55
	bcs @lbl_C2872E
	lda.b #$58
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	stx.b wTemp02
	phx
	jsl.l DisplayMessage
	plx
	lda.b #$05
	sta.b wTemp00
	lda.b #$23
	sta.b wTemp01
	phx
	jsl.l func_C3F69F
	plx
	lda.b wTemp00
	sta.b wTemp02
	stx.b wTemp00
	lda.b #$13
	sta.b wTemp01
	phx
	jsl.l func_C228DF
	plx
	bra @lbl_C28766
@lbl_C2872E:
	cmp.b #$AA
	bcs @lbl_C2874C
	lda.b #$59
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	stx.b wTemp02
	stx.b wTemp02
	phx
	jsl.l DisplayMessage
	plx
	lda.b #$02
	sta.l $7E8731,x
	bra @lbl_C28766
@lbl_C2874C:
	lda.b #$5A
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	stx.b wTemp02
	phx
	jsl.l DisplayMessage
	plx
	lda.b #$00
	sta.l $7E8731,x
	sta.l $7E8835,x
@lbl_C28766:
	dex 
	bmi @lbl_C2876C
	jmp.w @lbl_C286D9
@lbl_C2876C:
	plp 
	rtl

func_C2876E:
	php 
	sep #$30 ;AXY->8
	ldx.b #$12
@lbl_C28773:
	lda.l $7E85F1,x
	beq @lbl_C2878B
	lda.l $7E8781,x
	bmi @lbl_C2878B
	lda.l $7E8835,x
	bne @lbl_C2878B
	lda.b #$02
	sta.l $7E876D,x
@lbl_C2878B:
	dex 
	bpl @lbl_C28773
	plp 
	rtl

func_C28790:
	php
	sep #$30 ;AXY->8
	ldy.b #$09
	lda.l $7E87D0
	bit.b #$10
	beq @lbl_C2879F
;C2879D
	.db $A0,$08
@lbl_C2879F:
	sty.b wTemp02
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C626F6
	ldx.b #$12
@lbl_C287AB:
	lda.l wCharHP,x
	beq @lbl_C287D5
	lda.l wCharIsSealed,x
	bmi @lbl_C287D5
	stx.b wTemp00
	phx
	jsl.l func_C2778A
	plx
	lda.b wTemp00
	beq @lbl_C287D5
	lda.b #$15
	sta.l wCharRemainingSleepTurns,x
	lda.b #$00
	sta.l wCharIsAwake,x
	lda.b #$02
	sta.l wCharSpeed,x
@lbl_C287D5:
	dex
	bpl @lbl_C287AB
	plp
	rtl
	php                                     ;C387D8
	sep #$30                                ;C387D9
	ldy #$0B                                ;C387DB
	lda $7E87D0                             ;C387DD
	bit #$10                                ;C387E1
	beq @lbl_C387E7                         ;C387E3
	ldy #$0A                                ;C387E5
@lbl_C387E7:
	sty $02                                 ;C387E7
	lda #$13                                ;C387E9
	sta $00                                 ;C387EB
	jsl $C626F6                             ;C387ED
@lbl_C387F1:
	ldx #$12                                ;C387F1
@lbl_C387F3:
	lda $7E85F1,x                           ;C387F3
	beq @lbl_C38817                         ;C387F7
	lda $7E8781,x                           ;C387F9
	bmi @lbl_C38817                         ;C387FD
	stx $00                                 ;C387FF
	phx                                     ;C38801
	jsl $C2778A                             ;C38802
	plx                                     ;C38806
	lda $00                                 ;C38807
	beq @lbl_C38817                         ;C38809
	lda #$15                                ;C3880B
	sta $7E86B9,x                           ;C3880D
	lda #$00                                ;C38811
	sta $7E8731,x                           ;C38813
@lbl_C38817:
	dex                                     ;C38817
	bpl @lbl_C387F3                         ;C38818
	plp                                     ;C3881A
	rtl                                     ;C3881B
	php                                     ;C3881C
	sep #$30                                ;C3881D
	bra @lbl_C387F1                         ;C3881F
	php                                     ;C38821
	sep #$30                                ;C38822
	ldx #$12                                ;C38824
@lbl_C38826:
	lda $7E85F1,x                           ;C38826
	beq @lbl_C3884A                         ;C3882A
	lda $7E8781,x                           ;C3882C
	bmi @lbl_C3884A                         ;C38830
	stx $00                                 ;C38832
	phx                                     ;C38834
	jsl $C2778A                             ;C38835
	plx                                     ;C38839
	lda $00                                 ;C3883A
	beq @lbl_C3884A                         ;C3883C
	lda #$15                                ;C3883E
	sta $7E86CD,x                           ;C38840
	lda #$00                                ;C38844
	sta $7E8731,x                           ;C38846
@lbl_C3884A:
	dex                                     ;C3884A
	bpl @lbl_C38826                         ;C3884B
	plp                                     ;C3884D
	rtl                                     ;C3884E
	php                                     ;C3884F
	sep #$30                                ;C38850
	lda #$13                                ;C38852
	sta $00                                 ;C38854
	lda #$07                                ;C38856
	sta $02                                 ;C38858
	jsl $C626F6                             ;C3885A
	lda #$13                                ;C3885E
	sta $00                                 ;C38860
	lda #$D2                                ;C38862
	sta $02                                 ;C38864
	jsl $C62565                             ;C38866
	ldx #$12                                ;C3886A
@lbl_C3886C:
	lda $7E85F1,x                           ;C3886C
	beq @lbl_C3888C                         ;C38870
	lda $7E8781,x                           ;C38872
	bmi @lbl_C3888C                         ;C38876
	stx $00                                 ;C38878
	phx                                     ;C3887A
	jsl $C2778A                             ;C3887B
	plx                                     ;C3887F
	lda $00                                 ;C38880
	beq @lbl_C3888C                         ;C38882
	stx $00                                 ;C38884
	phx                                     ;C38886
	jsl $C28350                             ;C38887
	plx                                     ;C3888B
@lbl_C3888C:
	dex                                     ;C3888C
	bpl @lbl_C3886C                         ;C3888D
	jsl $C625CE                             ;C3888F
	lda #$13                                ;C38893
	sta $00                                 ;C38895
	lda #$D3                                ;C38897
	sta $02                                 ;C38899
	jsl $C62565                             ;C3889B
	plp                                     ;C3889F
	rtl                                     ;C388A0
	php                                     ;C388A1
	sep #$30                                ;C388A2
	lda #$13                                ;C388A4
	sta $00                                 ;C388A6
	lda #$04                                ;C388A8
	sta $02                                 ;C388AA
	jsl $C626F6                             ;C388AC
	ldx #$12                                ;C388B0
@lbl_C388B2:
	lda $7E85F1,x                           ;C388B2
	beq @lbl_C388D4                         ;C388B6
	lda $7E8781,x                           ;C388B8
	bmi @lbl_C388D4                         ;C388BC
	stx $00                                 ;C388BE
	phx                                     ;C388C0
	jsl $C277F8                             ;C388C1
	plx                                     ;C388C5
	lda $00                                 ;C388C6
	cmp #$03                                ;C388C8
	bcs @lbl_C388D4                         ;C388CA
	stx $00                                 ;C388CC
	phx                                     ;C388CE
	jsl $C28350                             ;C388CF
	plx                                     ;C388D3
@lbl_C388D4:
	dex                                     ;C388D4
	bpl @lbl_C388B2                         ;C388D5
	lda #$01                                ;C388D7
	sta $7E8604                             ;C388D9
	jsl $C625CE                             ;C388DD
	plp                                     ;C388E1
	rtl                                     ;C388E2
	php                                     ;C388E3
	sep #$30                                ;C388E4
	ldy $00                                 ;C388E6
	lda #$00                                ;C388E8
	pha                                     ;C388EA
	ldx #$12                                ;C388EB
@lbl_C388ED:
	lda $7E85F1,x                           ;C388ED
	beq @lbl_C3891F                         ;C388F1
	lda $7E8781,x                           ;C388F3
	bmi @lbl_C3891F                         ;C388F7
	stx $00                                 ;C388F9
	cpy $00                                 ;C388FB
	beq @lbl_C38913                         ;C388FD
	sty $01                                 ;C388FF
	phx                                     ;C38901
	phy                                     ;C38902
	jsl $C277B3                             ;C38903
	ply                                     ;C38907
	plx                                     ;C38908
	lda $00                                 ;C38909
	cmp #$02                                ;C3890B
	bcs @lbl_C3891F                         ;C3890D
	lda #$01                                ;C3890F
	sta $01,s                               ;C38911
@lbl_C38913:
	lda #$0A                                ;C38913
	sta $7E86E1,x                           ;C38915
	lda #$00                                ;C38919
	sta $7E8731,x                           ;C3891B
@lbl_C3891F:
	dex                                     ;C3891F
	bpl @lbl_C388ED                         ;C38920
	pla                                     ;C38922
	sta $00                                 ;C38923
	plp                                     ;C38925
	rtl                                     ;C38926
	php                                     ;C38927
	sep #$30                                ;C38928
	ldy $00                                 ;C3892A
	lda #$00                                ;C3892C
	pha                                     ;C3892E
	ldx #$12                                ;C3892F
@lbl_C38931:
	lda $7E85F1,x                           ;C38931
	beq @lbl_C38963                         ;C38935
	lda $7E8781,x                           ;C38937
	bmi @lbl_C38963                         ;C3893B
	stx $00                                 ;C3893D
	cpy $00                                 ;C3893F
	beq @lbl_C38957                         ;C38941
	sty $01                                 ;C38943
	phx                                     ;C38945
	phy                                     ;C38946
	jsl $C277B3                             ;C38947
	ply                                     ;C3894B
	plx                                     ;C3894C
	lda $00                                 ;C3894D
	cmp #$02                                ;C3894F
	bcs @lbl_C38963                         ;C38951
	lda #$01                                ;C38953
	sta $01,s                               ;C38955
@lbl_C38957:
	lda #$15                                ;C38957
	sta $7E86B9,x                           ;C38959
	lda #$00                                ;C3895D
	sta $7E8731,x                           ;C3895F
@lbl_C38963:
	dex                                     ;C38963
	bpl @lbl_C38931                         ;C38964
	pla                                     ;C38966
	sta $00                                 ;C38967
	plp                                     ;C38969
	rtl                                     ;C3896A
	php                                     ;C3896B
	sep #$30                                ;C3896C
	ldy $00                                 ;C3896E
	lda #$00                                ;C38970
	pha                                     ;C38972
	ldx #$12                                ;C38973
@lbl_C38975:
	lda $7E85F1,x                           ;C38975
	beq @lbl_C389A7                         ;C38979
	lda $7E8781,x                           ;C3897B
	bmi @lbl_C389A7                         ;C3897F
	stx $00                                 ;C38981
	cpy $00                                 ;C38983
	beq @lbl_C3899B                         ;C38985
	sty $01                                 ;C38987
	phx                                     ;C38989
	phy                                     ;C3898A
	jsl $C277B3                             ;C3898B
	ply                                     ;C3898F
	plx                                     ;C38990
	lda $00                                 ;C38991
	cmp #$02                                ;C38993
	bcs @lbl_C389A7                         ;C38995
	lda #$01                                ;C38997
	sta $01,s                               ;C38999
@lbl_C3899B:
	lda #$0A                                ;C3899B
	sta $7E86CD,x                           ;C3899D
	lda #$00                                ;C389A1
	sta $7E8731,x                           ;C389A3
@lbl_C389A7:
	dex                                     ;C389A7
	bpl @lbl_C38975                         ;C389A8
	pla                                     ;C389AA
	sta $00                                 ;C389AB
	plp                                     ;C389AD
	rtl                                     ;C389AE
	php                                     ;C389AF
	sep #$30                                ;C389B0
	ldy $00                                 ;C389B2
	lda #$00                                ;C389B4
	pha                                     ;C389B6
	ldx #$12                                ;C389B7
@lbl_C389B9:
	lda $7E85F1,x                           ;C389B9
	beq @lbl_C389EB                         ;C389BD
	lda $7E8781,x                           ;C389BF
	bmi @lbl_C389EB                         ;C389C3
	stx $00                                 ;C389C5
	cpy $00                                 ;C389C7
	beq @lbl_C389DF                         ;C389C9
	sty $01                                 ;C389CB
	phx                                     ;C389CD
	phy                                     ;C389CE
	jsl $C277B3                             ;C389CF
	ply                                     ;C389D3
	plx                                     ;C389D4
	lda $00                                 ;C389D5
	cmp #$02                                ;C389D7
	bcs @lbl_C389EB                         ;C389D9
	lda #$01                                ;C389DB
	sta $01,s                               ;C389DD
@lbl_C389DF:
	lda #$0A                                ;C389DF
	sta $7E86A5,x                           ;C389E1
	lda #$00                                ;C389E5
	sta $7E8731,x                           ;C389E7
@lbl_C389EB:
	dex                                     ;C389EB
	bpl @lbl_C389B9                         ;C389EC
	pla                                     ;C389EE
	sta $00                                 ;C389EF
	plp                                     ;C389F1
	rtl                                     ;C389F2

func_C289F5:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	ldx.b wTemp00
	ldy.b wTemp01
	phx
	jsl.l GetCharacterMapInfo
	lda.b wTemp00
	pha
	sty.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp00
	pha
	sta.b wTemp02
	lda.b wTemp05,s
	sta.b wTemp00
	phy
	jsl.l func_C27951
	ply
	lda.b wTemp03,s
	sta.b wTemp02
	sty.b wTemp00
	phy
	jsl.l func_C27951
	ply
	pla
	sta.b wTemp00
	pla
	plx
	stx.b wTemp02
	phx
	jsl.l func_C35B7A
	plx
	sep #$20 ;A->8
	cpy.b #$13
	bne @lbl_C28A3B
	tyx
@lbl_C28A3B:
	jsr.w func_C2452B
	plp
	rtl
	.db $08,$E2,$30,$A6,$00,$A9,$13,$85,$00,$A9,$02,$85,$02,$DA,$22,$F6   ;C28A40
	.db $26,$C6,$FA,$BF,$A1,$85,$7E,$8F,$96,$89,$7E,$A2,$12,$BF,$F1,$85   ;C28A50  
	.db $7E,$F0,$26,$BF,$81,$87,$7E,$30,$20,$BF,$A1,$85,$7E,$CF,$96,$89   ;C28A60  
	.db $7E,$D0,$16,$A9,$00,$9F,$81,$87,$7E,$86,$00,$DA,$22,$EB,$82,$C2   ;C28A70  
	.db $FA,$86,$00,$DA,$22,$35,$0F,$C2,$FA,$CA,$10,$D1,$22,$CE,$25,$C6   ;C28A80
	.db $28,$6B                           ;C28A90

func_C28A92:
	php
	sep #$30 ;AXY->8
	ldx.b #$00
	bra @lbl_C28AA2
@lbl_C28A99:
	sta.b wTemp00
	phx
	jsl.l func_C306F4
	plx
	inx
@lbl_C28AA2:
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C28A99
	lda.b #$00
	sta.l $7E8604
	lda.l $7E85C8
	sta.b wTemp00
	lda.l $7E85DC
	sta.b wTemp01
	lda.b #$06
	sta.b wTemp02
	lda.b #$00
	sta.b wTemp03
	jsl.l func_C2007D
	lda.b #$00
	sta.l $7E8979
	plp
	rtl
	.db $08,$E2,$30,$A2,$00,$BF,$4F,$89,$7E,$48,$E8,$E0,$14,$90,$F6,$A9   ;C28ACE
	.db $00,$8F,$04,$86,$7E,$AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85,$7E,$85   ;C28ADE
	.db $01,$A9,$06,$85,$02,$A9,$00,$85,$03,$22,$7D,$00,$C2,$A9,$00,$8F   ;C28AEE  
	.db $79,$89,$7E,$A2,$13,$68,$9F,$4F,$89,$7E,$CA,$10,$F8,$28,$6B,$08   ;C28AFE  
	.db $E2,$20,$A9,$01,$8F,$B7,$89,$7E   ;C28B0E
	.db $28,$6B                           ;C28B16

func_C28B18:
	php
	sep #$20 ;A->8
	lda.b #$02
	sta.l $7E89B7
	plp
	rtl

func_C28B23:
	php
	sep #$20 ;A->8
	lda.l $7E8998
	and.b #$01
	ora.l $7E86F4
	sta.b wTemp01
	ora.l $7E8977
	ora.l $7E885C
	ora.l $7E89A7
	ora.l $7E88C0
	ora.l $7E8744
	ora.l $7E89B3
	ora.l $7E89B7
	sta.b wTemp00
	plp
	rtl

func_C28B52:
	php
	sep #$30 ;AXY->8
	lda.l $7E898E
	ora.l $7E899B
	bne @lbl_C28B7D
	lda.l $7E87D0
	and.b #$F0
	cmp.b #$B0
	bne @lbl_C28B7D
	.db $A9,$00,$8F,$7B,$89,$7E,$A9,$13,$85,$00,$22,$90,$43,$C2,$A9,$01   ;C28B69
	.db $85,$00,$28,$6B                   ;C28B79  
@lbl_C28B7D:
	lda.l $7E897B
	bne @lbl_C28B90
	lda.l $7E899C
	bpl @lbl_C28B8C
;C28B89  
	.db $4C,$A7,$8C
@lbl_C28B8C:
	stz.b wTemp00
	plp
	rtl
@lbl_C28B90:
	bpl @lbl_C28B95
	jmp.w func_C28C19
@lbl_C28B95:
	lda $7E87D0                             ;C38B91
	sta $00                                 ;C38B95
	lda #$00                                ;C38B97
	sta $01                                 ;C38B99
	jsl $C36549                             ;C38B9B
	lda $00                                 ;C38B9F
	sta $02                                 ;C38BA1
	lda $01                                 ;C38BA3
	sta $03                                 ;C38BA5
	lda #$13                                ;C38BA7
	sta $00                                 ;C38BA9
	jsl $C24380                             ;C38BAB
	lda $7E897B                             ;C38BAF
	tax                                     ;C38BB3
	lda $7E87D1,x                           ;C38BB4
	sta $00                                 ;C38BB8
	lda $7E87E5,x                           ;C38BBA
	sta $01                                 ;C38BBE
	jsl $C359AF                             ;C38BC0
	lda $00                                 ;C38BC4
	bmi @lbl_C38BCE                         ;C38BC6
	sta $00                                 ;C38BC8
	jsl $C24390                             ;C38BCA
@lbl_C38BCE:
	lda $7E897B                             ;C38BCE
	tax                                     ;C38BD2
	lda $7E87D1,x                           ;C38BD3
	sta $02                                 ;C38BD7
	lda $7E87E5,x                           ;C38BD9
	sta $03                                 ;C38BDD
	stx $00                                 ;C38BDF
	jsl $C27951                             ;C38BE1
	lda #$00                                ;C38BE5
	sta $7E897B                             ;C38BE7
	lda #$13                                ;C38BEB
	sta $02                                 ;C38BED
	lda $7E85C8                             ;C38BEF
	sta $00                                 ;C38BF3
	lda $7E85DC                             ;C38BF5
	sta $01                                 ;C38BF9
	jsl $C35B7A                             ;C38BFB
	jsl $C62405                             ;C38BFF
	lda #$85                                ;C38C03
	sta $00                                 ;C38C05
	lda #$06                                ;C38C07
	sta $01                                 ;C38C09
	jsl.l DisplayMessage
	.db $A9,$01   ;C28C05  
	.db $85,$00,$28,$6B                   ;C28C15  

func_C28C19:
	cmp.b #$86
	bne @lbl_C28C53
	.db $A9,$00,$8F,$7B,$89,$7E,$AF,$C8,$85,$7E,$85,$00,$AF,$DC,$85,$7E   ;C28C1D
	.db $85,$01,$22,$AF,$59,$C3,$A5,$01,$C9,$86,$D0,$0C,$A9,$13,$85,$00   ;C28C2D  
	.db $A9,$10,$85,$02,$22,$F6,$26,$C6,$A9,$13,$85,$00,$22,$90,$43,$C2   ;C28C3D
	.db $A9,$01,$85,$00,$28,$6B           ;C28C4D
@lbl_C28C53:
	cmp.b #$84
	bne @lbl_C28C65
	lda.b #$00
	sta.l $7E897B
	jsl.l func_C6080E
	stz.b wTemp00
	plp
	rtl
@lbl_C28C65:
	bit.b #$20
	bne @lbl_C28C93
	pha
	ora.b #$20
	sta.b wTemp02
	lda.l $7E85C8
	sta.b wTemp00
	lda.l $7E85DC
	sta.b wTemp01
	jsl.l func_C35BA2
	pla
	and.b #$1F
	sta.b wTemp00
	lda.b #$00
	sta.l $7E897B
	jsl.l func_C3D41F
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C28C93:
	and.b #$1F
	sta.b wTemp00
	lda.b #$00
	sta.l $7E897B
	jsl.l func_C3D43B
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
	.db $A9,$00,$8F,$9C,$89,$7E,$AF,$9D,$89,$7E,$85,$00,$AF,$9E,$89,$7E   ;C28CA7
	.db $85,$01,$22,$F7,$D9,$C3,$A9,$01   ;C28CB7  
	.db $85,$00,$28,$6B                   ;C28CBF  

func_C28CC3:
	php
	sep #$30 ;AXY->8
	ldx.b #$12
@lbl_C28CC8:
	lda.l wCharHP,x
	beq @lbl_C28CEA
	lda.l wCharTrapsActivated,x
	beq @lbl_C28CEA
	and.b #$1F
	sta.b wTemp00
	lda.b #$00
	sta.l wCharTrapsActivated,x
	phx
	stx.b wTemp01
	jsl.l func_C3D528
	jsl.l func_C62405
	plx
@lbl_C28CEA:
	dex
	bpl @lbl_C28CC8
	plp
	rtl
	.db $08,$E2,$20,$AF,$C8,$85,$7E,$8F,$9D,$89,$7E,$AF,$DC,$85,$7E,$8F   ;C28CEF
	.db $9E,$89,$7E,$22,$5F,$F6,$C3,$A5,$00,$C9,$CD,$B0,$10,$A9,$03,$85   ;C28CFF  
	.db $00,$A9,$06,$85,$01,$22,$9F,$F6,$C3,$A5,$00,$80,$02,$A9,$40,$8F   ;C28D0F
	.db $9C,$89,$7E,$28,$6B               ;C28D1F  

SortShirenInventory:
	php
	sep #$30 ;AXY->8
	restorebank
	; Reorder Shiren's inventory entries in wShirenStatus.itemAmounts using
	; item metadata from func_C30710 and the priority table at DATA8_C28E40.
	lda.b #$00
	pha
	pha
	pha
	pha
	ldx.b #$01
	jmp.w func_C28DDC

func_C28D34:
	phx
	sta.b wTemp02,s
	sta.b wTemp00
	phx
	call_savebank func_C30710
	plx
	lda.b wTemp01
	sta.b wTemp03,s
	lda.b wTemp02
	sta.b wTemp04,s
	jmp.w func_C28DD4

func_C28D4C:
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	phx
	call_savebank func_C30710
	plx
	lda.b wTemp01
	cmp.b wTemp03,s
	bne func_C28DD4
	cmp.b #$E0
	bne @lbl_C28D6A
;C28D64  
	.db $A5,$02,$C3,$04,$D0,$6A
@lbl_C28D6A:
	lda.b wTemp00
	cmp.b #$04
	bne @lbl_C28DB3
	.db $BF,$4F,$89,$7E,$85,$00,$DA,$22,$D5,$3A,$C3,$FA,$A5,$00,$C9,$00   ;C28D70  
	.db $D0,$31,$A3,$02,$85,$00,$DA,$22,$D5,$3A,$C3,$FA,$A5,$00,$C9,$00   ;C28D80  
	.db $D0,$21,$A9,$01,$83,$05,$BF,$4F,$89,$7E,$85,$00,$A3,$02,$85,$01   ;C28D90  
	.db $8B,$22,$61,$3B,$C3,$AB,$A3,$01,$85,$00,$8B,$22,$4D,$3C,$C2,$AB   ;C28DA0
	.db $FA,$80,$29                       ;C28DB0
@lbl_C28DB3:
	lda.b wTemp01,s
	phx
	tax
	bra @lbl_C28DC5
@lbl_C28DB9:
	lda.b #$01
	sta.b wTemp06,s
	lda.l wShirenStatus.itemAmounts,x
	sta.l $7E8950,x
@lbl_C28DC5:
	dex
	txa
	cmp.b wTemp01,s
	bne @lbl_C28DB9
	plx
	lda.b wTemp02,s
	sta.l $7E8950,x
	bra func_C28DDA
func_C28DD4:
	dex
	bmi func_C28DDA
	jmp.w func_C28D4C
func_C28DDA:
	plx
	inx

func_C28DDC:
	lda.l wShirenStatus.itemAmounts,x
	bmi @lbl_C28DE5
	jmp.w func_C28D34
@lbl_C28DE5:
	pla
	pla
	pla
@lbl_C28DE8:
	lda.b #$00
	pha
	ldx.b #$00
@lbl_C28DED:
	lda.l $7E8950,x
	bmi @lbl_C28E34
	sta.b wTemp00
	phx
	call_savebank func_C30710
	plx
	ldy.b wTemp00
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	phx
	phy
	call_savebank func_C30710
	ply
	plx
	lda.w DATA8_C28E40,y
	ldy.b wTemp00
	cmp.w DATA8_C28E40,y
	bcs @lbl_C28E31
	lda.l $7E8950,x
	tay
	lda.l wShirenStatus.itemAmounts,x
	sta.l $7E8950,x
	tya
	sta.l wShirenStatus.itemAmounts,x
	lda.b #$01
	sta.b wTemp01,s
	sta.b wTemp02,s
@lbl_C28E31:
	inx
	bra @lbl_C28DED
@lbl_C28E34:
	pla
	bne @lbl_C28DE8
	pla
	bne @lbl_C28E3E
	jsl.l func_C28FBC
@lbl_C28E3E:
	plp
	rtl

DATA8_C28E40:
	.db $05,$06,$04,$00,$03,$01,$02,$07   ;C28E40
	.db $FF                               ;C28E48  
	.db $09                               ;C28E49
	.db $0A                               ;C28E4A
	.db $08                               ;C28E4B

func_C28E4C:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	bne @lbl_C28E61
	lda.l $7E89A4
	bit.b #$40
	bne @lbl_C28E69
@lbl_C28E5D:
	stz.b wTemp00
	plp
	rtl
@lbl_C28E61:
	lda.l wCharType,x
	cmp.b #$0E
	bne @lbl_C28E5D
@lbl_C28E69:
	.db $A9,$01,$85,$00,$28,$6B           ;C28E69

func_C28E6F:
	php
	sep #$20 ;A->8
	lda.l $7E8979
	sta.b wTemp01
	lda.b #$00
	sta.l $7E8979
	lda.l $7E897A
	sta.b wTemp00
	lda.l $7E8998
	and.b #$01
	bne @lbl_C28E92
	lda.b #$FF
	sta.l $7E897A
@lbl_C28E92:
	plp
	rtl

func_C28E94:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharAppearance,x
	sta.b wTemp00
	cpx.b #$13
	beq @lbl_C28EC1
	lda.l $7E86B8
	bne @lbl_C28EBD
	lda.l wCharInvisible,x
	beq @lbl_C28EC1
	.db $AF,$75,$89,$7E,$0F,$83,$89,$7E   ;C28EAF  
	.db $0F,$60,$BE,$7E,$D0,$04           ;C28EB7  
@lbl_C28EBD:
	lda.b #$C0
	sta.b wTemp00
@lbl_C28EC1:
	lda.l wCharLevel,x
	sta.b wTemp01
	plp
	rtl
	.db $08   ;C38EBB
	sep #$30                                ;C38EBC
	ldy $00                                 ;C38EBE
	ldx #$FF                                ;C38EC0
	bra @lbl_C38F11                         ;C38EC2
@lbl_C38EC4:
	sta $00                                 ;C38EC4
	phx                                     ;C38EC6
	phy                                     ;C38EC7
	jsl $C30710                             ;C38EC8
	ply                                     ;C38ECC
	plx                                     ;C38ECD
	lda $00                                 ;C38ECE
	cmp #$0B                                ;C38ED0
	bne @lbl_C38F04                         ;C38ED2
	lda #$00                                ;C38ED4
@lbl_C38ED6:
	pha                                     ;C38ED6
	sta $01                                 ;C38ED7
	lda $7E894F,x                           ;C38ED9
	sta $00                                 ;C38EDD
	phx                                     ;C38EDF
	phy                                     ;C38EE0
	jsl $C33AEF                             ;C38EE1
	ply                                     ;C38EE5
	plx                                     ;C38EE6
	lda $00                                 ;C38EE7
	bmi @lbl_C38F01                         ;C38EE9
	cpy $00                                 ;C38EEB
	bne @lbl_C38EFD                         ;C38EED
	phx                                     ;C38EEF
	phy                                     ;C38EF0
	jsl $C30710                             ;C38EF1
	ply                                     ;C38EF5
	plx                                     ;C38EF6
	lda $01                                 ;C38EF7
	cmp #$5C                                ;C38EF9
	beq @lbl_C38F1E                         ;C38EFB
@lbl_C38EFD:
	pla                                     ;C38EFD
	inc a                                   ;C38EFE
	bra @lbl_C38ED6                         ;C38EFF
@lbl_C38F01:
	pla                                     ;C38F01
	bra @lbl_C38F11                         ;C38F02
@lbl_C38F04:
	tya                                     ;C38F04
	cmp $7E894F,x                           ;C38F05
	bne @lbl_C38F11                         ;C38F09
	lda $01                                 ;C38F0B
	cmp #$5C                                ;C38F0D
	beq @lbl_C38F2F                         ;C38F0F
@lbl_C38F11:
	inx                                     ;C38F11
	lda $7E894F,x                           ;C38F12
	bpl @lbl_C38EC4                         ;C38F16
	lda #$01                                ;C38F18
	sta $00                                 ;C38F1A
	plp                                     ;C38F1C
	rtl                                     ;C38F1D
@lbl_C38F1E:
	lda $7E894F,x                           ;C38F1E
	sta $00                                 ;C38F22
	pla                                     ;C38F24
	sta $01                                 ;C38F25
	phy                                     ;C38F27
	jsl $C33B01                             ;C38F28
	ply                                     ;C38F2C
	bra @lbl_C38F37                         ;C38F2D
@lbl_C38F2F:
	stx $00                                 ;C38F2F
	phy                                     ;C38F31
	jsl $C23C4D                             ;C38F32
	ply                                     ;C38F36
@lbl_C38F37:
	sty $00                                 ;C38F37
	jsl $C306F4                             ;C38F39
	stz $00                                 ;C38F3D
	plp                                     ;C38F3F
	rtl                                     ;C38F40

func_C28F4F:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	rep #$10 ;XY->16
	ldx.w #$036F
	ldy.w #$002B
@lbl_C28F5E:
	sep #$20 ;A->8
	lda.w wCharType,x
	sta.w $8911,y
	rep #$20 ;A->16
	txa
	sec
	sbc.w #$0014
	tax
	dey
	bpl @lbl_C28F5E
	ldx.w #$00A8
	stx.b wTemp00
	ldx.w #$8911
	stx.b wTemp02
	lda.w #$007E
	sta.b wTemp04
	jsl.l func_C3E2AB
	plp
	rtl

func_C28F86:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldx.w #$00A8
	stx.b wTemp00
	ldx.w #$8911
	stx.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	jsl.l func_C3E2DB
	bankswitch 0x7E
	ldx.w #$036F
	ldy.w #$002B
@lbl_C28FA7:
	sep #$20 ;A->8
	lda.w $8911,y
	sta.w wCharType,x
	rep #$20 ;A->16
	txa
	sec
	sbc.w #$0014
	tax
	dey
	bpl @lbl_C28FA7
	plp
	rtl

func_C28FBC:
	php
	sep #$20 ;A->8
	jsl.l func_C627F1
	lda.b wTemp00
	bne @lbl_C28FC9
	plp
	rtl
@lbl_C28FC9:
	lda.l $7E894E
	bne @lbl_C28FD7
	lda.b #$02
	sta.l $7E894E
	plp
	rtl
@lbl_C28FD7:
	jsl.l func_C3E34B
	jsl.l func_C3E34B
	lda.l $7E85F0
	ora.b #$10
	sta.b wTemp00
	stz.b wTemp01
	jsl.l func_C3E1D5
	lda.b #$02
	sta.l $7E894E
	plp
	rtl

func_C28FF5:
	php
	sep #$20 ;A->8
	lda.l $7E894E
	beq @lbl_C29003
	dec a
	sta.l $7E894E
@lbl_C29003:
	plp
	rtl

func_C29005:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wCharRemainingSleepTurns,x
	beq @lbl_C29020
;C29010
	.db $A9,$33,$85,$00,$A9,$01,$85,$01,$86,$02
	jsl.l DisplayMessage
	.db $28,$6B
@lbl_C29020:
	lda.l wCharIsAwake,x
	and.b #$FD
	sta.l wCharIsAwake,x
	lda.l wCharNPCFlags,x
	bit.b #$02
	bne @lbl_C29048
	lda.l $7E85F0
	eor.b #$04
	sta.l wCharDir,x
	stx.b wTemp00
	lda.b #$01
	sta.b wTemp02
	phx
	jsl.l func_C62550
	plx
@lbl_C29048:
	lda.l wCharType,x
	cmp.b #$4D
	bne @lbl_C29053
	jmp.w func_C29082
@lbl_C29053:
	cmp.b #$4C
	bne @lbl_C2905A
;C29057  
	.db $4C,$C3,$92
@lbl_C2905A:
	stx.b wTemp00
	sta.b wTemp01
	phx
	jsl.l func_C10000
	plx
	lda.l wCharNPCFlags,x
	bit.b #$04
	beq @lbl_C29080
	lda.l wCharAutoDir,x
	sta.l wCharDir,x
	stx.b wTemp00
	lda.b #$01
	sta.b wTemp02
	phx
	jsl.l func_C62550
	plx
@lbl_C29080:
	plp
	rtl

func_C29082:
	sep #$30 ;AXY->8
	lda.l wCharIsSealed,x
	cmp.b #$02
	bne @lbl_C2909A
	.db $A9,$81,$85,$00,$A9,$06,$85,$01   ;C2908C
	jsl.l DisplayMessage
	.db $28,$6B           ;C29094  
@lbl_C2909A:
	lda.l $7E87D0
	cmp.b #$0A
	bcc @lbl_C290A5
;C290A2  
	.db $4C,$D9,$91
@lbl_C290A5:
	sta.b wTemp00
	jsl.l func_C36698
	rep #$20 ;A->16
	lda.w #$0000
	pha
	pha
	lda.b wTemp02
	pha
	lda.b wTemp00
	clc
	adc.w #$0101
	pha

func_C290BC:
	rep #$20 ;A->16
	pha
	sta.b wTemp00
	jsl.l func_C359AF
	ldx.b wTemp01
	bpl @lbl_C290CC
	jmp.w @lbl_C2914F
@lbl_C290CC:
	sep #$20 ;A->8
	stx.b wTemp00
	phx
	jsl.l func_C33AD5
	plx
	lda.b wTemp00
	cmp.b #$02
	bne @lbl_C2910E
	.db $86,$00,$A9,$01,$85,$01,$DA,$22,$92,$3A,$C3,$FA,$86,$00,$64,$01   ;C290DC  
	.db $DA,$22,$A0,$3C,$C3,$FA,$C2,$20,$AF,$91,$89,$7E,$38,$E5,$00,$8F   ;C290EC
	.db $91,$89,$7E,$AF,$93,$89,$7E,$E9,$00,$00,$8F,$93,$89,$7E,$E2,$20   ;C290FC  
	.db $80,$32                           ;C2910C  
@lbl_C2910E:
	cmp.b #$00
	bne @lbl_C29140
	stx.b wTemp00
	lda.b #$01
	sta.b wTemp01
	phx
	jsl.l func_C33CA0
	plx
	rep #$20 ;A->16
	lda.b wTemp00
	beq @lbl_C2913E
	clc
	adc.b wTemp07,s
	sta.b wTemp07,s
	lda.b w0009,s
	adc.w #$0000
	sta.b w0009,s
	sep #$20 ;A->8
	stx.b wTemp00
	lda.b #$FF
	sta.b wTemp01
	phx
	jsl.l func_C33A92
	plx
@lbl_C2913E:
	sep #$20 ;A->8
@lbl_C29140:
	stx.b wTemp00
	jsl.l func_C33AE2
	ldx.b wTemp00
	cpx.b #$FF
	beq @lbl_C2914F
;C2914C  
	.db $4C,$CC,$90
@lbl_C2914F:
	rep #$20 ;A->16
	pla
	sep #$20 ;A->8
	inc a
	cmp.b wTemp03,s
	bcc @lbl_C29162
	lda.b wTemp01,s
	xba
	inc a
	cmp.b wTemp04,s
	xba
	bcs @lbl_C29165
@lbl_C29162:
	jmp.w func_C290BC
@lbl_C29165:
	rep #$20 ;A->16
	pla
	pla
	lda.b wTemp01,s
	sta.b wTemp02
	lda.b wTemp03,s
	sta.b wTemp04
	ora.b wTemp02
	beq @lbl_C291D7
	lda.w #$067D
	sta.b wTemp00
	jsl.l DisplayMessage1
	ldx.b wTemp00
	bne @lbl_C291A9
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b wTemp03,s
	sta.b wTemp02
	jsl.l func_C25BE0
	jsl.l func_C62405
	lda.l $7E8991
	ora.l $7E8993
	beq @lbl_C291A5
	lda.w #$067F
	sta.b wTemp00
	jsl.l DisplayMessage
@lbl_C291A5:
	ldy.b #$01
	bra @lbl_C291B4
@lbl_C291A9:
	.db $A9,$7E,$06,$85,$00
	jsl.l DisplayMessage
	.db $A0,$00                       ;C291B1  
@lbl_C291B4:
	sep #$20 ;A->8
	ldx.b #$7E
@lbl_C291B8:
	stx.b wTemp00
	phx
	phy
	jsl.l func_C33AD5
	ply
	plx
	lda.b wTemp00
	bpl @lbl_C291D2
	stx.b wTemp00
	sty.b wTemp01
	phx
	phy
	jsl.l func_C33A92
	ply
	plx
@lbl_C291D2:
	dex
	bpl @lbl_C291B8
	rep #$20 ;A->16
@lbl_C291D7:
	pla
	pla
	rep #$20 ;A->16
	lda.w #$067B
	sta.b wTemp00
	lda.l $7E8993
	bpl @lbl_C291E9
@lbl_C291E6:
	jmp.w func_C29284
@lbl_C291E9:
	sta.b wTemp04
	lda.l $7E8991
	sta.b wTemp02
	ora.b wTemp04
	beq @lbl_C291E6
	jsl.l DisplayMessage1
	ldx.b wTemp00
	bne @lbl_C29234
	lda.l $7E8991
	sta.b wTemp00
	lda.l $7E8993
	sta.b wTemp02
	lda.w #$0000
	sec
	sbc.b wTemp00
	sta.b wTemp00
	lda.w #$0000
	sbc.b wTemp02
	sta.b wTemp02
	bpl @lbl_C29280
	lda.l wShirenStatus.gitan
	clc
	adc.b wTemp00
	lda.l $7E8941
	adc.b wTemp02
	bpl @lbl_C29280
	.db $A9,$80,$06,$85,$00
	jsl.l DisplayMessage
	.db $28,$6B                       ;C29231  
@lbl_C29234:
	.db $E2,$20,$AF,$72,$89,$7E,$C2,$20,$30,$3D,$85,$00,$22,$10,$07,$C3   ;C29234
	.db $A6,$01,$E0,$94,$D0,$31,$A9,$7C,$06,$85,$00,$AF,$93,$89,$7E,$4A   ;C29244  
	.db $85,$04,$AF,$91,$89,$7E,$6A,$69,$00,$00,$85,$02,$48,$A5,$04,$69   ;C29254  
	.db $00,$00,$85,$04,$48,$22,$7E,$2B,$C6,$A6,$00,$D0,$08,$68,$85,$02   ;C29264
	.db $68,$85,$00,$80,$90,$68,$68,$A9   ;C29274
	.db $7E,$06,$80,$AC                   ;C2927C  
@lbl_C29280:
	jsl.l func_C25BE0

func_C29284:
	lda.w #$067F
	sta.b wTemp00
	jsl.l DisplayMessage
	lda.w #$0000
	sta.l $7E8991
	sta.l $7E8993
	sep #$20 ;A->8
	lda.b #$00
	sta.l $7E8990
	sep #$30 ;AXY->8
	ldx.b #$7E
@lbl_C292A4:
	stx.b wTemp00
	phx
	jsl.l func_C33AD5
	plx
	lda.b wTemp00
	cmp.b #$02
	bne @lbl_C292BE
	stx.b wTemp00
	lda.b #$00
	sta.b wTemp01
	phx
	jsl.l func_C33A92
	plx
@lbl_C292BE:
	dex
	bpl @lbl_C292A4
	plp
	rtl
	.db $E2,$30,$BF,$81,$87,$7E,$C9,$02,$D0,$0E,$A9,$86,$85,$00,$A9,$06   ;C292C3
	.db $85,$01
	jsl.l DisplayMessage
	.db $28,$6B   ;C392C2
	lda $7E87BD,x                           ;C392C4
	bit #$90                                ;C392C8
	.db $D0,$F6   ;C392CA
	rep #$20                                ;C392CC
	lda #$0682                              ;C392CE
	sta $00                                 ;C392D1
	lda #$03E8                              ;C392D3
	sta $02                                 ;C392D6
	pha                                     ;C392D8
	stz $04                                 ;C392D9
	sep #$30                                ;C392DB
	lda #$0A                                ;C392DD
	sta $05                                 ;C392DF
	phx                                     ;C392E1
	jsl $C62B7E                             ;C392E2
	plx                                     ;C392E6
	lda $00                                 ;C392E7
	.db $F0,$44   ;C392E9
	sep #$20                                ;C392EB
	lda $7E8972                             ;C392ED
	bmi @lbl_C39321                         ;C392F1
	sta $00                                 ;C392F3
	phx                                     ;C392F5
	jsl $C30710                             ;C392F6
	plx                                     ;C392FA
	lda $01                                 ;C392FB
	cmp #$94                                ;C392FD
	bne @lbl_C39321                         ;C392FF
	rep #$20                                ;C39301
	lda #$0683                              ;C39303
	sta $00                                 ;C39306
	lda #$01F4                              ;C39308
	sta $02                                 ;C3930B
	sta $01,s                               ;C3930D
	stz $04                                 ;C3930F
	sep #$30                                ;C39311
	lda #$0A                                ;C39313
	sta $05                                 ;C39315
	phx                                     ;C39317
	jsl $C62B7E                             ;C39318
	plx                                     ;C3931C
	lda $00                                 ;C3931D
	.db $F0,$0E   ;C3931F
@lbl_C39321:
	rep #$20                                ;C39321
	pla                                     ;C39323
	lda #$067E                              ;C39324
	sta $00                                 ;C39327
.ACCU 8
	jsl.l DisplayMessage
	.db $28,$6B,$C2,$20,$68,$85,$00,$64,$02,$22,$B7,$5B,$C2,$A5,$00   ;C29343  
	.db $F0,$0B,$A9,$80,$06,$85,$00
	jsl.l DisplayMessage
	.db $28,$6B,$E2,$20,$A9   ;C29353  
	.db $0B,$9F,$71,$88,$7E,$86,$00,$A9,$13,$85,$01,$22,$F5,$89,$C2,$A9   ;C29363
	.db $84,$85,$00,$A9,$06,$85,$01
	jsl.l DisplayMessage
	.db $A9,$E7,$85,$00,$A9   ;C29373  
	.db $01,$85,$01,$22,$EE,$2A,$C6,$28   ;C29383  
	.db $6B                               ;C2938B

func_C2938C:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp04
	pha
	plb
	rep #$10 ;XY->16
	ldy.b wTemp02
	jmp.w func_C29420

func_C2939C:
	iny
	phy
	phb
	cmp.b #$20
	bcs @lbl_C293E1
	bit.b #$10
	bne @lbl_C293CD
	and.b #$07
	sta.l wCharDir,x
	stx.b wTemp00
	phx
	jsl.l func_C2785E
	plx
	rep #$20 ;A->16
	lda.b wTemp04
	sta.b wTemp02
	sep #$20 ;A->8
	stx.b wTemp00
	phx
	jsl.l func_C27951
	plx
	phx
	jsl.l func_C62428
	plx
	bra @lbl_C2941E
@lbl_C293CD:
	and.b #$07
	sta.l wCharDir,x
	stx.b wTemp00
	lda.b #$01
	sta.b wTemp02
	phx
	jsl.l func_C62550
	plx
	bra @lbl_C2941E
@lbl_C293E1:
	sec
	sbc.b #$20
	bne @lbl_C29402
	plb
	ply
	lda.w wTemp00,y
	sta.b wTemp00
	iny
	lda.w wTemp00,y
	sta.b wTemp01
	iny
	phy
	phb
	stz.b wTemp02
	phx
	jsl.l func_C30351
	plx
	lda.b wTemp00
	bra @lbl_C29404
@lbl_C29402:
	lda.b #$80
@lbl_C29404:
	sta.b wTemp02
	lda.l wCharXPos,x
	sta.b wTemp00
	lda.l wCharYPos,x
	sta.b wTemp01
	phx
	jsl.l func_C35BA2
	plx
	phx
	jsl.l func_C62405
	plx
@lbl_C2941E:
	plb
	ply

func_C29420:
	lda.w func_C10000,y
	bmi @lbl_C29428
	jmp.w func_C2939C
@lbl_C29428:
	plp
	rtl

func_C2942A:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b wTemp01
	sta.b wTemp00
	lda.b wTemp02
	sta.b wTemp01
	stz.b wTemp02
	phx
	jsl.l func_C30351
	plx
	lda.l wCharDir,x
	sta.b wTemp01
	lda.l wCharXPos,x
	sta.b wTemp02
	lda.l wCharYPos,x
	sta.b wTemp03
	stx.b wTemp04
	stz.b wTemp05
	jsl.l ExecutePreparedThrowEffect
	plp
	rtl

.include "data/player/strength_stat_table.asm"
.include "data/enemies/stats.asm"
.include "data/dungeon_enemy_spawn_tables.asm"
.include "data/player/level_exp_table.asm"

UNREACH_C2CAD9:
	.db $0A,$05,$03,$30,$02,$01,$01,$01
	.db $08
	.db $0A,$05,$03,$30,$02,$01,$01,$01
	.db $0A,$0A,$05,$03,$30,$02,$01,$01
	.db $02,$10

func_C2CAF4:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	jsl.l func_C2CB1D
	jsl.l func_C2CB6D
	jsl.l func_C2CBC5
	jsl.l func_C2CDB7
	jsl.l func_C2CF66
	jsl.l func_C2D0AB
	jsl.l func_C2D36F
	jsl.l func_C2CB54
	plp
	rtl

func_C2CB1D:
	php
	sep #$30 ;AXY->8
	jsl.l Get7ED5EC
	lda.b wTemp00
	cmp.b #$04
	bcs @lbl_C2CB30
	lda.b #$03
	ldx.b #$00
	bra @lbl_C2CB40
@lbl_C2CB30:
	cmp.b #$07
	bcs @lbl_C2CB3A
	lda.b #$04
	ldx.b #$09
	bra @lbl_C2CB40
@lbl_C2CB3A:
	lda.b #$05
	ldx.b #$12
	bra @lbl_C2CB40
@lbl_C2CB40:
	sta.w $89BC
	ldy.b #$00
@lbl_C2CB45:
	lda.l UNREACH_C2CAD9,x
	sta.w $8B83,y
	inx
	iny
	cpy.b #$09
	bcc @lbl_C2CB45
	plp
	rtl

func_C2CB54:
	php
	sep #$30 ;AXY->8
	ldx.w $BE8E
@lbl_C2CB5A:
	dex
	bmi @lbl_C2CB6B
	dec.w $BE66,x
	dec.w $BE70,x
	inc.w $BE7A,x
	inc.w $BE84,x
	bra @lbl_C2CB5A
@lbl_C2CB6B:
	plp
	rtl

func_C2CB6D:
	php
	sep #$30 ;AXY->8
	ldx.b #$6F
@lbl_C2CB72:
	stz.w $89C3,x
	stz.w $8A33,x
	stz.w $8AA3,x
	stz.w $8B13,x
	dex
	bpl @lbl_C2CB72
	ldy.b #$00
@lbl_C2CB83:
	tya
	clc
	adc.b #$10
	and.b #$F0
	tay
	lda.b #$10
	sta.w $89C3,y
@lbl_C2CB8F:
	iny
	lda.b #$00
	sta.w $89C3,y
	dec a
	sta.w $8A33,y
	tya
	and.b #$0F
	cmp.w $8B84
	bcc @lbl_C2CB8F
	iny
	lda.b #$10
	sta.w $89C3,y
	cpy.w $8B86
	bcc @lbl_C2CB83
	ldy.w $8B84
	iny
@lbl_C2CBB0:
	tya
	ora.w $8B86
	clc
	adc.b #$10
	tax
	lda.b #$10
	sta.w $89C3,y
	sta.w $89C3,x
	dey
	bpl @lbl_C2CBB0
	plp
	rtl

func_C2CBC5:
	php
	sep #$30 ;AXY->8
	lda.w $89BC
	asl a
	tax
	pea.w $CBD7
	rep #$20 ;A->16
	lda.l UNREACH_C2CBDA,x
	pha
	rts
	plp
	rtl

UNREACH_C2CBDA:
	sbc #$1ECB                              ;C39540
	cpy $CC43                               ;C39543
	eor $CC,s                               ;C39546
	eor $CC,s                               ;C39548
	eor $CC,s                               ;C3954A
	lda $CC,s                               ;C3954C
	inc $CC,x                               ;C3954E
	sep #$30                                ;C39550
	ldx #$11                                ;C39552
	jsl $C3F65F                             ;C39554
	lda $00                                 ;C39558
	and #$01                                ;C3955A
	beq @lbl_C39560                         ;C3955C
	ldx #$14                                ;C3955E
@lbl_C39560:
	ldy #$02                                ;C39560
@lbl_C39562:
	lda #$10                                ;C39562
	sta $89C3,x                             ;C39564
	sta $89C4,x                             ;C39567
	lda #$FE                                ;C3956A
	sta $8A33,x                             ;C3956C
	sta $8A34,x                             ;C3956F
	txa                                     ;C39572
	clc                                     ;C39573
	adc #$10                                ;C39574
	tax                                     ;C39576
	dey                                     ;C39577
	bpl @lbl_C39562                         ;C39578
	lda #$10                                ;C3957A
	sta $89E6                               ;C3957C
	lda #$FE                                ;C3957F
	sta $8A56                               ;C39581
	rts                                     ;C39584
	sep #$20                                ;C39585
	lda #$10                                ;C39587
	sta $89D4                               ;C39589
	sta $89F4                               ;C3958C
	sta $89D8                               ;C3958F
	sta $89F8                               ;C39592
	sta $89E6                               ;C39595
	lda #$FE                                ;C39598
	sta $8A44                               ;C3959A
	sta $8A64                               ;C3959D
	sta $8A48                               ;C395A0
	sta $8A68                               ;C395A3
	sta $8A56                               ;C395A6
	rts                                     ;C395A9
.ACCU 16
	sep #$30 ;AXY->8
	lda.b #$10
	sta.w $89E6
	lda.b #$FE
	sta.w $8A56
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$0A
	bcs @lbl_C2CC5E
	ldx.b #$00
	bra @lbl_C2CC78
@lbl_C2CC5E:
	cmp.b #$0F
	bcs @lbl_C2CC66
	ldx.b #$19
	bra @lbl_C2CC78
@lbl_C2CC66:
	cmp.b #$14
	bcs @lbl_C2CC6E
;C2CC6A
	.db $A2,$55,$80,$0A
@lbl_C2CC6E:
	cmp.b #$19
	bcs @lbl_C2CC76
	ldx.b #$19
	bra @lbl_C2CC78
@lbl_C2CC76:
	.db $A2,$00
@lbl_C2CC78:
	jsl.l Random
	cpx.b wTemp00
	bcc @lbl_C2CCA3
	jsl.l Random
	lda.b wTemp00
	and.b #$03
	asl a
	asl a
	tax
	lda.b #$03
	sta.b wTemp00
@lbl_C2CC8F:
	lda.l UNREACH_C2CD5F,x
	tay
	lda.b #$10
	sta.w $89C3,y
	lda.b #$FE
	sta.w $8A33,y
	inx
	dec.b wTemp00
	bpl @lbl_C2CC8F
@lbl_C2CCA3:
	rts
	sep #$30                                ;C39607
	ldx #$33                                ;C39609
	jsl $C3F65F                             ;C3960B
	lda $00                                 ;C3960F
	and #$01                                ;C39611
	beq @lbl_C39616                         ;C39613
	inx                                     ;C39615
@lbl_C39616:
	lda #$10                                ;C39616
	sta $89C3,x                             ;C39618
	lda #$FE                                ;C3961B
	sta $8A33,x                             ;C3961D
	jsl $C3F65F                             ;C39620
	lda $00                                 ;C39624
	and #$0F                                ;C39626
	cmp #$05                                ;C39628
	bcs @lbl_C39659                         ;C3962A
	jsl $C3F65F                             ;C3962C
	lda $00                                 ;C39630
	and #$03                                ;C39632
	sta $00                                 ;C39634
	lda #$06                                ;C39636
	sta $01                                 ;C39638
	jsl $C3E3CB                             ;C3963A
	lda $00                                 ;C3963E
	tax                                     ;C39640
	lda #$05                                ;C39641
	sta $00                                 ;C39643
@lbl_C39645:
	lda $C2CD6F,x                           ;C39645
	tay                                     ;C39649
	lda #$10                                ;C3964A
	sta $89C3,y                             ;C3964C
	lda #$FE                                ;C3964F
	sta $8A33,y                             ;C39651
	inx                                     ;C39654
	dec $00                                 ;C39655
	bpl @lbl_C39645                         ;C39657
@lbl_C39659:
	rts                                     ;C39659
	sep #$30                                ;C3965A
	ldx #$34                                ;C3965C
	ldy #$44                                ;C3965E
	jsl $C3F65F                             ;C39660
	lda $00                                 ;C39664
	and #$01                                ;C39666
	beq @lbl_C3966C                         ;C39668
	inx                                     ;C3966A
	iny                                     ;C3966B
@lbl_C3966C:
	lda #$10                                ;C3966C
	sta $89C3,x                             ;C3966E
	sta $89C4,x                             ;C39671
	sta $89C3,y                             ;C39674
	sta $89C4,y                             ;C39677
	lda #$FE                                ;C3967A
	sta $8A33,x                             ;C3967C
	sta $8A34,x                             ;C3967F
	sta $8A33,y                             ;C39682
	sta $8A34,y                             ;C39685
	jsl $C3F65F                             ;C39688
	lda $00                                 ;C3968C
	and #$0F                                ;C3968E
	cmp #$05                                ;C39690
	bcs @lbl_C396C1                         ;C39692
	jsl $C3F65F                             ;C39694
	lda $00                                 ;C39698
	and #$03                                ;C3969A
	sta $00                                 ;C3969C
	lda #$0C                                ;C3969E
	sta $01                                 ;C396A0
	jsl $C3E3CB                             ;C396A2
	lda $00                                 ;C396A6
	tax                                     ;C396A8
	lda #$0B                                ;C396A9
	sta $00                                 ;C396AB
@lbl_C396AD:
	lda $C2CD87,x                           ;C396AD
	tay                                     ;C396B1
	lda #$10                                ;C396B2
	sta $89C3,y                             ;C396B4
	lda #$FE                                ;C396B7
	sta $8A33,y                             ;C396B9
	inx                                     ;C396BC
	dec $00                                 ;C396BD
	bpl @lbl_C396AD                         ;C396BF
@lbl_C396C1:
	rts                                     ;C396C1

UNREACH_C2CD5F:
	ora ($12),y                             ;C396C2
	.db $21,$22,$21,$22,$31,$32,$14,$15,$24,$25,$24,$25,$34,$35,$11,$12,$13,$21,$22,$23,$31,$32,$33,$41,$42,$43,$14,$15,$16,$24,$25,$26,$34,$35,$36,$44,$45,$46,$11,$12,$13,$14,$21,$22,$23,$24,$31,$32,$33,$34,$31,$32,$33,$34,$41,$42,$43,$44,$51,$52,$53,$54,$16,$17,$18,$19,$26,$27,$28,$29,$36,$37,$38,$39,$36,$37,$38,$39,$46,$47,$48,$49,$56,$57,$58,$59   ;C396C4

func_C2CDB7:
	php
	sep #$30 ;AXY->8
@lbl_C2CDBA:
	lda.w $8B85
	sta.b wTemp01
	lda.b #$01
	sta.b wTemp00
	jsl.l func_C3F69F
	lda.b wTemp00
	asl a
	asl a
	asl a
	asl a
	pha
	lda.w $8B84
	sta.b wTemp01
	lda.b #$01
	sta.b wTemp00
	jsl.l func_C3F69F
	pla
	ora.b wTemp00
	tay
	lda.w $89C3,y
	bne @lbl_C2CDBA
	jsl.l func_C2CEB0
@lbl_C2CDE8:
	stz.b wTemp06
	ldy.b #$00
@lbl_C2CDEC:
	tya
	clc
	adc.b #$10
	and.b #$F0
	tay
@lbl_C2CDF3:
	iny
	lda.w $89C3,y
	bne @lbl_C2CDFE
	inc a
	sta.b wTemp06
	bra @lbl_C2CE0E
@lbl_C2CDFE:
	cmp.b #$10
	beq @lbl_C2CE0E
	lda.b wTemp06
	pha
	phy
	jsl.l func_C2CEB0
	ply
	pla
	sta.b wTemp06
@lbl_C2CE0E:
	tya
	and.b #$0F
	cmp.w $8B84
	bcc @lbl_C2CDF3
	cpy.w $8B86
	bcc @lbl_C2CDEC
	lda.b wTemp06
	bne @lbl_C2CDE8
	ldx.b #$02
@lbl_C2CE21:
	phx
	jsl.l func_C2CE2C
	plx
	dex
	bpl @lbl_C2CE21
	plp
	rtl

func_C2CE2C:
	php
	sep #$30 ;AXY->8
	lda.b #$0A
	sta.b wTemp06
@lbl_C2CE33:
	dec.b wTemp06
	bpl @lbl_C2CE39
	plp
	rtl
@lbl_C2CE39:
	lda.b #$01
	sta.b wTemp00
	lda.w $8B85
	sta.b wTemp01
	lda.b wTemp06
	pha
	jsl.l func_C3F69F
	pla
	sta.b wTemp06
	lda.b wTemp00
	asl a
	asl a
	asl a
	asl a
	pha
	lda.b #$01
	sta.b wTemp00
	lda.w $8B84
	sta.b wTemp01
	lda.b wTemp06
	pha
	jsl.l func_C3F69F
	pla
	sta.b wTemp06
	pla
	ora.b wTemp00
	tay
	lda.w $89C3,y
	cmp.b #$0F
	bcs @lbl_C2CE39
	sta.b wTemp02
	jsl.l Random
	lda.b wTemp00
	and.b #$03
	tax
@lbl_C2CE7C:
	lda.l DATA8_C2CEE5,x
	bit.b wTemp02
	beq @lbl_C2CE87
	inx
	bra @lbl_C2CE7C
@lbl_C2CE87:
	phy
	jsl.l func_C2CF55
	ply
	lda.b wTemp00
	cmp.b #$10
	beq @lbl_C2CE33
	lda.l DATA8_C2CEE5,x
	ora.w $89C3,y
	sta.w $89C3,y
	tya
	clc
	adc.l DATA8_C2CEED,x
	tay
	lda.l DATA8_C2CEE7,x
	ora.w $89C3,y
	sta.w $89C3,y
	plp
	rtl

func_C2CEB0:
	php
	sep #$30 ;AXY->8
	jsl.l Random
	lda.b wTemp00
	and.b #$03
	tax
@lbl_C2CEBC:
	phy
	jsl.l func_C2CEF5
	ply
	cpx.b #$FF
	beq @lbl_C2CEE3
	lda.l DATA8_C2CEE5,x
	ora.w $89C3,y
	sta.w $89C3,y
	tya
	clc
	adc.l DATA8_C2CEED,x
	tay
	lda.l DATA8_C2CEE7,x
	ora.w $89C3,y
	sta.w $89C3,y
	bra @lbl_C2CEBC
@lbl_C2CEE3:
	plp
	rtl

DATA8_C2CEE5:
	.db $01,$02                           ;C2CEE5

DATA8_C2CEE7:
	.db $04,$08,$01,$02                   ;C2CEE7
	.db $04                               ;C2CEEB  
	.db $08                               ;C2CEEC

DATA8_C2CEED:
	.db $F0,$01,$10,$FF,$F0,$01           ;C2CEED
	.db $10                               ;C2CEF3  
	.db $FF                               ;C2CEF4

func_C2CEF5:
	php
	sep #$30 ;AXY->8
	stx.w $89BD
	jsl.l Random
	lda.b wTemp00
	and.b #$01
	beq @lbl_C2CF0F
	phy
	jsl.l func_C2CF55
	ply
	lda.b wTemp00
	beq @lbl_C2CF53
@lbl_C2CF0F:
	jsl.l Random
	lda.b wTemp00
	and.b #$02
	eor.b #$03
	sta.b wTemp00
	txa
	clc
	adc.b wTemp00
	and.b #$03
	tax
	phy
	jsl.l func_C2CF55
	ply
	lda.b wTemp00
	beq @lbl_C2CF53
	inx
	inx
	phy
	jsl.l func_C2CF55
	ply
	lda.b wTemp00
	beq @lbl_C2CF53
	ldx.w $89BD
	phy
	jsl.l func_C2CF55
	ply
	lda.b wTemp00
	beq @lbl_C2CF53
	inx
	inx
	phy
	jsl.l func_C2CF55
	ply
	lda.b wTemp00
	beq @lbl_C2CF53
	ldx.b #$FF
@lbl_C2CF53:
	plp
	rtl

func_C2CF55:
	php
	sep #$30 ;AXY->8
	tya
	clc
	adc.l DATA8_C2CEED,x
	tay
	lda.w $89C3,y
	sta.b wTemp00
	plp
	rtl

func_C2CF66:
	php
	sep #$30 ;AXY->8
	stz.w $BE8E
	lda.b #$0A
	dec a
	sta.b wTemp04

func_C2CF71:
	lda.b #$04
	sta.b wTemp05

func_C2CF75:
	lda.w $8B89
	sta.b wTemp00
	lda.w $8B8A
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	jsl.l func_C3F69F
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.b wTemp06
	lda.w $8B89
	sta.b wTemp00
	lda.w $8B8A
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	jsl.l func_C3F69F
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.b wTemp07
	lda.b #$01
	sta.b wTemp00
	lda.w $8B85
	sec
	sbc.b wTemp07
	inc a
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	jsl.l func_C3F69F
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	asl a
	asl a
	asl a
	tay
	lda.b #$01
	sta.b wTemp00
	lda.w $8B84
	sec
	sbc.b wTemp06
	inc a
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	phy
	jsl.l func_C3F69F
	ply
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	tya
	ora.b wTemp00
	tay
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	phy
	jsl.l func_C2D03A
	ply
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	lda.b wTemp00
	beq @lbl_C2D023
	dec.b wTemp05
	bmi @lbl_C2D031
	brl func_C2CF75
@lbl_C2D023:
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	jsl.l func_C2D067
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
@lbl_C2D031:
	dec.b wTemp04
	bmi @lbl_C2D038
	brl func_C2CF71
@lbl_C2D038:
	plp
	rtl

func_C2D03A:
	php
	sep #$30 ;AXY->8
	dec.b wTemp06
	dec.b wTemp07
@lbl_C2D041:
	tyx
	lda.b wTemp06
	sta.b wTemp04
@lbl_C2D046:
	lda.w $8A33,x
	cmp.b #$FF
	bne @lbl_C2D061
	inx
	dec.b wTemp04
	bpl @lbl_C2D046
	tya
	clc
	adc.b #$10
	tay
	dec.b wTemp07
	bpl @lbl_C2D041
	lda.b #$00
	sta.b wTemp00
	bra @lbl_C2D065
@lbl_C2D061:
	lda.b #$01
	sta.b wTemp00
@lbl_C2D065:
	plp
	rtl

func_C2D067:
	php
	sep #$30 ;AXY->8
	ldx.w $BE8E
	tya
	and.b #$0F
	sta.w $BE66,x
	clc
	adc.b wTemp06
	dec a
	sta.w $BE7A,x
	tya
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w $BE70,x
	clc
	adc.b wTemp07
	dec a
	sta.w $BE84,x
	dec.b wTemp06
	dec.b wTemp07
@lbl_C2D08D:
	tyx
	lda.b wTemp06
	sta.b wTemp04
	lda.w $BE8E
@lbl_C2D095:
	sta.w $8A33,x
	inx
	dec.b wTemp04
	bpl @lbl_C2D095
	tya
	clc
	adc.b #$10
	tay
	dec.b wTemp07
	bpl @lbl_C2D08D
	inc.w $BE8E
	plp
	rtl

func_C2D0AB:
	php
	sep #$30 ;AXY->8
	ldx.w $BE8E

func_C2D0B1:
	dex
	bpl @lbl_C2D0B6
	plp
	rtl
@lbl_C2D0B6:
	lda.w $BE66,x
	cmp.b #$01
	beq @lbl_C2D0D1
	dec a
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp00
	clc
	adc.w $8B87
	inc a
	inc a
@lbl_C2D0D1:
	sta.b wTemp04
	lda.w $BE66,x
	cmp.w $8B84
	beq @lbl_C2D0F7
	lda.w $BE7A,x
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	rep #$30 ;AXY->16
	jsl.l func_C3E3CB
	sep #$30 ;AXY->8
	lda.b wTemp00
	clc
	adc.w $8B87
	dec a
	dec a
	bra @lbl_C2D0F9
@lbl_C2D0F7:
	lda.b #$36
@lbl_C2D0F9:
	sta.b wTemp07
	lda.w $BE66,x
	cmp.w $BE7A,x
	bne @lbl_C2D169
	lda.b #$04
	sta.b wTemp00
	lda.b wTemp07
	sec
	sbc.b wTemp04
	inc a
	sta.b wTemp01
	lda.w $8B8B
	cmp.b wTemp01
	bcs @lbl_C2D118
	sta.b wTemp01
@lbl_C2D118:
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	phx
	jsl.l func_C3F69F
	plx
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.b wTemp02
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp07
	sec
	sbc.b wTemp02
	inc a
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp02
	pha
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	phx
	jsl.l func_C3F69F
	plx
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	pla
	sta.b wTemp02
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.w $BE66,x
	clc
	adc.b wTemp02
	dec a
	sta.w $BE7A,x
	brl func_C2D211
@lbl_C2D169:
	lda.w $BE66,x
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	rep #$30 ;AXY->16
	jsl.l func_C3E3CB
	sep #$30 ;AXY->8
	lda.b wTemp00
	clc
	adc.w $8B87
	dec a
	dec a
	sta.b wTemp05
	lda.w $BE7A,x
	dec a
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	rep #$30 ;AXY->16
	jsl.l func_C3E3CB
	sep #$30 ;AXY->8
	lda.b wTemp00
	clc
	adc.w $8B87
	inc a
	inc a
	sta.b wTemp06
	lda.b wTemp07
	sec
	sbc.b wTemp04
	cmp.w $8B8B
	bcc @lbl_C2D1E1
	lda.b wTemp00
	sec
	sbc.w $8B8B
	lsr a
	sta.b wTemp02
	lda.b wTemp05
	sec
	sbc.b wTemp04
	cmp.b wTemp02
	bcs @lbl_C2D1C4
	lda.b wTemp05
	sta.b wTemp04
	bra @lbl_C2D1CB
@lbl_C2D1C4:
	.db $A5,$04,$18,$65,$02,$85,$04
@lbl_C2D1CB:
	lda.b wTemp07
	sec
	sbc.b wTemp06
	cmp.b wTemp02
	bcs @lbl_C2D1DA
	lda.b wTemp06
	sta.b wTemp07
	bra @lbl_C2D1E1
@lbl_C2D1DA:
	.db $A5,$07,$38,$E5,$02,$85,$07
@lbl_C2D1E1:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	phx
	jsl.l func_C3F69F
	plx
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.w $BE66,x
	lda.b wTemp06
	sta.b wTemp00
	lda.b wTemp07
	sta.b wTemp01
	phx
	jsl.l func_C3F69F
	plx
	lda.b wTemp00
	sta.w $BE7A,x

func_C2D211:
	lda.w $BE70,x
	cmp.b #$01
	beq @lbl_C2D22C
	dec a
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp00
	clc
	adc.w $8B88
	inc a
	inc a
@lbl_C2D22C:
	sta.b wTemp04
	lda.w $BE70,x
	cmp.w $8B85
	beq @lbl_C2D252
	lda.w $BE84,x
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	rep #$30 ;AXY->16
	jsl.l func_C3E3CB
	sep #$30 ;AXY->8
	lda.b wTemp00
	clc
	adc.w $8B88
	dec a
	dec a
	bra @lbl_C2D254
@lbl_C2D252:
	lda.b #$20
@lbl_C2D254:
	sta.b wTemp07
	lda.w $BE70,x
	cmp.w $BE84,x
	bne @lbl_C2D2C4
	lda.b #$04
	sta.b wTemp00
	lda.b wTemp07
	sec
	sbc.b wTemp04
	inc a
	sta.b wTemp01
	lda.w $8B8B
	cmp.b wTemp01
	bcs @lbl_C2D273
	sta.b wTemp01
@lbl_C2D273:
	rep #$30 ;AXY->16
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	phx
	jsl.l func_C3F69F
	plx
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.b wTemp02
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp07
	sec
	sbc.b wTemp02
	inc a
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp02
	pha
	lda.b wTemp04
	pha
	lda.b wTemp06
	pha
	phx
	jsl.l func_C3F69F
	plx
	pla
	sta.b wTemp06
	pla
	sta.b wTemp04
	pla
	sta.b wTemp02
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.w $BE70,x
	clc
	adc.b wTemp02
	dec a
	sta.w $BE84,x
	brl func_C2D36C
@lbl_C2D2C4:
	lda.w $BE70,x
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	rep #$30 ;AXY->16
	jsl.l func_C3E3CB
	sep #$30 ;AXY->8
	lda.b wTemp00
	clc
	adc.w $8B88
	dec a
	dec a
	sta.b wTemp05
	lda.w $BE84,x
	dec a
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	rep #$30 ;AXY->16
	jsl.l func_C3E3CB
	sep #$30 ;AXY->8
	lda.b wTemp00
	clc
	adc.w $8B88
	inc a
	inc a
	sta.b wTemp06
	lda.b wTemp07
	sec
	sbc.b wTemp04
	cmp.w $8B8B
	bcc @lbl_C2D33C
	lda.b wTemp00
	sec
	sbc.w $8B8B
	lsr a
	sta.b wTemp02
	lda.b wTemp05
	sec
	sbc.b wTemp04
	cmp.b wTemp02
	bcs @lbl_C2D31F
	lda.b wTemp05
	sta.b wTemp04
	bra @lbl_C2D326
@lbl_C2D31F:
	lda.b wTemp04
	clc
	adc.b wTemp02
	sta.b wTemp04
@lbl_C2D326:
	lda.b wTemp07
	sec
	sbc.b wTemp06
	cmp.b wTemp02
	bcs @lbl_C2D335
	lda.b wTemp06
	sta.b wTemp07
	bra @lbl_C2D33C
@lbl_C2D335:
	lda.b wTemp07
	sec
	sbc.b wTemp02
	sta.b wTemp07
@lbl_C2D33C:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	phx
	jsl.l func_C3F69F
	plx
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.w $BE70,x
	lda.b wTemp06
	sta.b wTemp00
	lda.b wTemp07
	sta.b wTemp01
	phx
	jsl.l func_C3F69F
	plx
	lda.b wTemp00
	sta.w $BE84,x

func_C2D36C:
	jmp.w func_C2D0B1

func_C2D36F:
	php
	sep #$30 ;AXY->8
	ldx.w $BE8E
	dex
@lbl_C2D376:
	lda.w $BE66,x
	sta.b wTemp00
	lda.w $BE70,x
	sta.b wTemp01
	lda.w $BE7A,x
	sta.b wTemp02
	lda.w $BE84,x
	sta.b wTemp03
	txa
	ora.b #$00
	sta.b wTemp04
	phx
	jsl.l func_C36053
	plx
	dex
	bpl @lbl_C2D376
	ldy.b #$11
@lbl_C2D39A:
	lda.w $8A33,y
	cmp.b #$FF
	bne @lbl_C2D405
	tya
	and.b #$0F
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp00
	clc
	adc.w $8B87
	sta.b wTemp00
	sec
	sbc.b #$03
	sta.b wTemp01
	lda.b wTemp00
	clc
	adc.b #$03
	sec
	sbc.w $8B83
	sta.b wTemp00
	phy
	jsl.l func_C3F69F
	ply
	lda.b wTemp00
	sta.w $8AA3,y
	tya
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp00
	clc
	adc.w $8B88
	sta.b wTemp00
	sec
	sbc.b #$03
	sta.b wTemp01
	lda.b wTemp00
	clc
	adc.b #$03
	sec
	sbc.w $8B83
	sta.b wTemp00
	phy
	jsl.l func_C3F69F
	ply
	lda.b wTemp00
	sta.w $8B13,y
@lbl_C2D405:
	iny
	tya
	and.b #$0F
	dec a
	cmp.w $8B84
	bcc @lbl_C2D39A
	tya
	and.b #$F0
	clc
	adc.b #$11
	tay
	lsr a
	lsr a
	lsr a
	lsr a
	dec a
	cmp.w $8B85
	bcs @lbl_C2D423
	brl @lbl_C2D39A
@lbl_C2D423:
	ldy.b #$11
@lbl_C2D425:
	phy
	jsl.l func_C2D469
	ply
	iny
	tya
	and.b #$0F
	dec a
	cmp.w $8B84
	bcc @lbl_C2D425
	tya
	and.b #$F0
	clc
	adc.b #$11
	tay
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w $8B85
	bcc @lbl_C2D425
	ldy.b #$11
@lbl_C2D447:
	phy
	jsl.l func_C2D68E
	ply
	iny
	tya
	and.b #$0F
	cmp.w $8B84
	bcc @lbl_C2D447
	tya
	and.b #$F0
	clc
	adc.b #$11
	tay
	lsr a
	lsr a
	lsr a
	lsr a
	dec a
	cmp.w $8B85
	bcc @lbl_C2D447
	plp
	rtl

func_C2D469:
	php
	sep #$30 ;AXY->8
	lda.w $89C3,y
	and.b #$04
	bne @lbl_C2D475
@lbl_C2D473:
	plp
	rtl
@lbl_C2D475:
	lda.w $8A33,y
	cmp.b #$FE
	beq @lbl_C2D473
	sta.w $89C1
	lda.w $8A43,y
	cmp.b #$FE
	beq @lbl_C2D473
	sta.w $89C2
	lda.w $89C1
	bmi @lbl_C2D493
	cmp.w $89C2
	beq @lbl_C2D473
@lbl_C2D493:
	tya
	and.b #$0F
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp00
	clc
	adc.w $8B87
	sta.b wTemp02
	ldx.w $89C1
	cpx.b #$FF
	bne @lbl_C2D4BF
	lda.w $8B13,y
	sta.w $89BE
	lda.w $8AA3,y
	sta.b wTemp04
	sta.b wTemp05
	bra @lbl_C2D4F4
@lbl_C2D4BF:
	lda.w $BE84,x
	inc a
	sta.w $89BE
	lda.w $BE66,x
	sta.b wTemp04
	tya
	and.b #$0F
	cmp.b #$01
	beq @lbl_C2D4DF
	lda.b wTemp02
	sec
	sbc.w $8B83
	cmp.b wTemp04
	bcc @lbl_C2D4DF
	inc a
	sta.b wTemp04
@lbl_C2D4DF:
	lda.w $BE7A,x
	sta.b wTemp05
	tya
	and.b #$0F
	cmp.w $8B84
	beq @lbl_C2D4F4
	lda.b wTemp02
	cmp.b wTemp05
	bcs @lbl_C2D4F4
;C2D4F2  
	.db $85,$05
@lbl_C2D4F4:
	ldx.w $89C2
	cpx.b #$FF
	bne @lbl_C2D50A
	lda.w $8B23,y
	sta.w $89C0
	lda.w $8AB3,y
	sta.b wTemp06
	sta.b wTemp07
	bra @lbl_C2D53F
@lbl_C2D50A:
	lda.w $BE70,x
	dec a
	sta.w $89C0
	lda.w $BE66,x
	sta.b wTemp06
	tya
	and.b #$0F
	cmp.b #$01
	beq @lbl_C2D52A
	lda.b wTemp02
	sec
	sbc.w $8B83
	cmp.b wTemp06
	bcc @lbl_C2D52A
	inc a
	sta.b wTemp06
@lbl_C2D52A:
	lda.w $BE7A,x
	sta.b wTemp07
	tya
	and.b #$0F
	cmp.w $8B84
	beq @lbl_C2D53F
	lda.b wTemp02
	cmp.b wTemp07
	bcs @lbl_C2D53F
	sta.b wTemp07
@lbl_C2D53F:
	lda.w $89C0
	sec
	sbc.w $89BE
	dec a
	dec a
	bpl @lbl_C2D54D
;C2D54A  
	.db $82,$99,$00
@lbl_C2D54D:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	jsl.l func_C2D8F0
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.w $89BD
	lda.b wTemp06
	sta.b wTemp00
	lda.b wTemp07
	sta.b wTemp01
	jsl.l func_C2D8F0
	lda.b wTemp00
	sta.w $89BF
	lda.w $89BE
	inc a
	sta.b wTemp00
	lda.w $89C0
	dec a
	sta.b wTemp01
	jsl.l func_C2D8F0
	lda.b wTemp00
	sta.b wTemp06
	lda.w $89BD
	sta.b wTemp00
	lda.w $89BE
	sta.b wTemp01
	lda.b wTemp06
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	jsl.l func_C3601D
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.w $89BD
	sta.b wTemp00
	lda.b wTemp06
	sta.b wTemp01
	lda.w $89BF
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	jsl.l func_C35FE7
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.w $89BF
	sta.b wTemp00
	lda.b wTemp06
	sta.b wTemp01
	lda.w $89C0
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C3601D
	brl func_C2D688
	lda $07                                 ;C39EFD
	cmp $04                                 ;C39EFF
	bcs @lbl_C39F31                         ;C39F01
	sta $89BF                               ;C39F03
	lda $04                                 ;C39F06
	sta $89BD                               ;C39F08
	ldx $89C1                               ;C39F0B
	cmp $BE66,x                             ;C39F0E
	bne @lbl_C39F18                         ;C39F11
	lda $89BE                               ;C39F13
	bra @lbl_C39F1B                         ;C39F16
@lbl_C39F18:
	lda $89C0                               ;C39F18
@lbl_C39F1B:
	sta $01                                 ;C39F1B
	lda $89BD                               ;C39F1D
	sta $00                                 ;C39F20
	lda $89BF                               ;C39F22
	sta $02                                 ;C39F25
	lda #$30                                ;C39F27
	sta $03                                 ;C39F29
	jsl $C35FE7                             ;C39F2B
	.db $80,$6E   ;C39F2F
@lbl_C39F31:
	lda $05                                 ;C39F31
	cmp $06                                 ;C39F33
	bcs @lbl_C39F67                         ;C39F35
	sta $89BD                               ;C39F37
	lda $06                                 ;C39F3A
	sta $89BF                               ;C39F3C
	lda $05                                 ;C39F3F
	ldx $89C1                               ;C39F41
	cmp $BE7A,x                             ;C39F44
	bne @lbl_C39F4E                         ;C39F47
	lda $89BE                               ;C39F49
	bra @lbl_C39F51                         ;C39F4C
@lbl_C39F4E:
	lda $89C0                               ;C39F4E
@lbl_C39F51:
	sta $01                                 ;C39F51
	lda $89BD                               ;C39F53
	sta $00                                 ;C39F56
	lda $89BF                               ;C39F58
	sta $02                                 ;C39F5B
	lda #$30                                ;C39F5D
	sta $03                                 ;C39F5F
	jsl $C35FE7                             ;C39F61
	.db $80,$38   ;C39F65
@lbl_C39F67:
	lda $04                                 ;C39F67
	cmp $06                                 ;C39F69
	bcs @lbl_C39F71                         ;C39F6B
	lda $06                                 ;C39F6D
	sta $04                                 ;C39F6F
@lbl_C39F71:
	lda $07                                 ;C39F71
	cmp $05                                 ;C39F73
	bcs @lbl_C39F79                         ;C39F75
	sta $05                                 ;C39F77
@lbl_C39F79:
	lda $04                                 ;C39F79
	sta $00                                 ;C39F7B
	lda $05                                 ;C39F7D
	sta $01                                 ;C39F7F
	jsl $C3F69F                             ;C39F81
	lda $00                                 ;C39F85
	sta $89BD                               ;C39F87
	sta $89BF                               ;C39F8A
	lda $89BE                               ;C39F8D
	sta $01                                 ;C39F90
	lda $89C0                               ;C39F92
	sta $02                                 ;C39F95
	lda #$30                                ;C39F97
	sta $03                                 ;C39F99
	jsl $C3601D                             ;C39F9B

func_C2D688:
	jsl.l func_C2D8B7
	plp
	rtl

func_C2D68E:
	php
	sep #$30 ;AXY->8
	lda.w $89C3,y
	and.b #$02
	bne @lbl_C2D69A
@lbl_C2D698:
	plp
	rtl
@lbl_C2D69A:
	lda.w $8A33,y
	cmp.b #$FE
	beq @lbl_C2D698
	sta.w $89C1
	lda.w $8A34,y
	cmp.b #$FE
	beq @lbl_C2D698
	sta.w $89C2
	lda.w $89C1
	bmi @lbl_C2D6B8
	cmp.w $89C2
	beq @lbl_C2D698
@lbl_C2D6B8:
	tya
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b wTemp00
	lda.w $8B83
	sta.b wTemp01
	jsl.l func_C3E3CB
	lda.b wTemp00
	clc
	adc.w $8B88
	sta.b wTemp02
	ldx.w $89C1
	cpx.b #$FF
	bne @lbl_C2D6E6
	lda.w $8AA3,y
	sta.w $89BD
	lda.w $8B13,y
	sta.b wTemp04
	sta.b wTemp05
	bra @lbl_C2D71B
@lbl_C2D6E6:
	lda.w $BE7A,x
	inc a
	sta.w $89BD
	lda.w $BE70,x
	sta.b wTemp04
	tya
	and.b #$F0
	cmp.b #$10
	beq @lbl_C2D706
	lda.b wTemp02
	sec
	sbc.w $8B83
	cmp.b wTemp04
	bcc @lbl_C2D706
	inc a
	sta.b wTemp04
@lbl_C2D706:
	lda.w $BE84,x
	sta.b wTemp05
	tya
	and.b #$F0
	cmp.w $8B86
	beq @lbl_C2D71B
	lda.b wTemp02
	cmp.b wTemp05
	bcs @lbl_C2D71B
	sta.b wTemp05
@lbl_C2D71B:
	ldx.w $89C2
	cpx.b #$FF
	bne @lbl_C2D731
	lda.w $8AA4,y
	sta.w $89BF
	lda.w $8B14,y
	sta.b wTemp06
	sta.b wTemp07
	bra @lbl_C2D766
@lbl_C2D731:
	lda.w $BE66,x
	dec a
	sta.w $89BF
	lda.w $BE70,x
	sta.b wTemp06
	tya
	and.b #$F0
	cmp.b #$10
	beq @lbl_C2D751
	lda.b wTemp02
	sec
	sbc.w $8B83
	cmp.b wTemp06
	bcc @lbl_C2D751
	inc a
	sta.b wTemp06
@lbl_C2D751:
	lda.w $BE84,x
	sta.b wTemp07
	tya
	and.b #$F0
	cmp.w $8B86
	beq @lbl_C2D766
	lda.b wTemp02
	cmp.b wTemp07
	bcs @lbl_C2D766
	sta.b wTemp07
@lbl_C2D766:
	lda.w $89BF
	sec
	sbc.w $89BD
	dec a
	dec a
	bpl @lbl_C2D774
;C2D771  
	.db $82,$99,$00
@lbl_C2D774:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	jsl.l func_C2D8F0
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.w $89BE
	lda.b wTemp06
	sta.b wTemp00
	lda.b wTemp07
	sta.b wTemp01
	jsl.l func_C2D8F0
	lda.b wTemp00
	sta.w $89C0
	lda.w $89BD
	inc a
	sta.b wTemp00
	lda.w $89BF
	dec a
	sta.b wTemp01
	jsl.l func_C2D8F0
	lda.b wTemp00
	sta.b wTemp06
	lda.w $89BD
	sta.b wTemp00
	lda.w $89BE
	sta.b wTemp01
	lda.b wTemp06
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	jsl.l func_C35FE7
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.b wTemp06
	sta.b wTemp00
	lda.w $89BE
	sta.b wTemp01
	lda.w $89C0
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	rep #$30 ;AXY->16
	lda.b wTemp06
	pha
	jsl.l func_C3601D
	pla
	sta.b wTemp06
	sep #$30 ;AXY->8
	lda.b wTemp06
	sta.b wTemp00
	lda.w $89C0
	sta.b wTemp01
	lda.w $89BF
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C35FE7
	brl func_C2D8B1
	lda $07                                 ;C3A11D
	cmp $04                                 ;C3A11F
	bcs @lbl_C3A151                         ;C3A121
	sta $89C0                               ;C3A123
	lda $04                                 ;C3A126
	sta $89BE                               ;C3A128
	ldx $89C1                               ;C3A12B
	cmp $BE70,x                             ;C3A12E
	bne @lbl_C3A138                         ;C3A131
	lda $89BD                               ;C3A133
	bra @lbl_C3A13B                         ;C3A136
@lbl_C3A138:
	lda $89BF                               ;C3A138
@lbl_C3A13B:
	sta $00                                 ;C3A13B
	lda $89BE                               ;C3A13D
	sta $01                                 ;C3A140
	lda $89C0                               ;C3A142
	sta $02                                 ;C3A145
	lda #$30                                ;C3A147
	sta $03                                 ;C3A149
	jsl $C3601D                             ;C3A14B
	.db $80,$70   ;C3A14F
@lbl_C3A151:
	lda $05                                 ;C3A151
	cmp $06                                 ;C3A153
	bcs @lbl_C3A187                         ;C3A155
	sta $89BE                               ;C3A157
	lda $06                                 ;C3A15A
	sta $89C0                               ;C3A15C
	lda $05                                 ;C3A15F
	ldx $89C1                               ;C3A161
	cmp $BE84,x                             ;C3A164
	bne @lbl_C3A16E                         ;C3A167
	lda $89BD                               ;C3A169
	bra @lbl_C3A171                         ;C3A16C
@lbl_C3A16E:
	lda $89BF                               ;C3A16E
@lbl_C3A171:
	sta $00                                 ;C3A171
	lda $89BE                               ;C3A173
	sta $01                                 ;C3A176
	lda $89C0                               ;C3A178
	sta $02                                 ;C3A17B
	lda #$30                                ;C3A17D
	sta $03                                 ;C3A17F
	jsl $C3601D                             ;C3A181
	.db $80,$3A   ;C3A185
@lbl_C3A187:
	lda $04                                 ;C3A187
	cmp $06                                 ;C3A189
	bcs @lbl_C3A191                         ;C3A18B
	lda $06                                 ;C3A18D
	sta $04                                 ;C3A18F
@lbl_C3A191:
	lda $07                                 ;C3A191
	cmp $05                                 ;C3A193
	bcs @lbl_C3A199                         ;C3A195
	sta $05                                 ;C3A197
@lbl_C3A199:
	lda $04                                 ;C3A199
	sta $00                                 ;C3A19B
	lda $05                                 ;C3A19D
	sta $01                                 ;C3A19F
	jsl $C3F69F                             ;C3A1A1
	lda $00                                 ;C3A1A5
	sta $89BE                               ;C3A1A7
	sta $89C0                               ;C3A1AA
	sta $01                                 ;C3A1AD
	lda $89BD                               ;C3A1AF
	sta $00                                 ;C3A1B2
	lda $89BF                               ;C3A1B4
	sta $02                                 ;C3A1B7
	lda #$30                                ;C3A1B9
	sta $03                                 ;C3A1BB
	jsl $C35FE7                             ;C3A1BD

func_C2D8B1:
	jsl.l func_C2D8B7
	plp
	rtl

func_C2D8B7:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.w $89C1
	bmi @lbl_C2D8D5
	ora.b #$70
	pha
	lda.w $89BD
	sta.b wTemp00
	lda.w $89BE
	sta.b wTemp01
	pla
	sta.b wTemp02
	jsl.l func_C35C72
@lbl_C2D8D5:
	lda.w $89C2
	bmi @lbl_C2D8EE
	ora.b #$70
	pha
	lda.w $89BF
	sta.b wTemp00
	lda.w $89C0
	sta.b wTemp01
	pla
	sta.b wTemp02
	jsl.l func_C35C72
@lbl_C2D8EE:
	plp
	rtl

func_C2D8F0:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b wTemp01
	beq @lbl_C2D92A
	bcc @lbl_C2D903
;C2D8FB
	.db $48,$A5,$01,$85,$00,$68,$85,$01
@lbl_C2D903:
	lda.b wTemp01
	sec
	sbc.b wTemp00
	cmp.b #$02
	bcc @lbl_C2D916
	inc.b wTemp00
	dec.b wTemp01
	jsl.l func_C3F69F
	bra @lbl_C2D92A
@lbl_C2D916:
	ldx.b wTemp00
	ldy.b wTemp01
	jsl.l Random
	lda.b wTemp00
	and.b #$01
	beq @lbl_C2D928
	stx.b wTemp00
	bra @lbl_C2D92A
@lbl_C2D928:
	sty.b wTemp00
@lbl_C2D92A:
	plp
	rtl
	.db $11,$12,$13,$14,$15,$21,$22,$23,$24,$25,$31,$32,$33,$34,$35,$11   ;C2D92C  
	.db $12,$13,$14,$15,$16,$21,$22,$23,$24,$25,$26,$31,$32,$33,$34,$35   ;C2D93C  
	.db $36,$41,$42,$43,$44,$45,$46,$08,$E2,$30,$A2,$08,$BF,$64,$D9,$C2   ;C2D94C  
	.db $9D,$83,$8B,$CA,$10,$F6,$28,$60,$0A,$05,$03,$30,$02,$01,$01,$01   ;C2D95C  
	.db $0A,$08,$E2,$30,$A2,$08,$BF,$7E,$D9,$C2,$9D,$83,$8B,$CA,$10,$F6   ;C2D96C
	.db $28,$60,$08,$06,$04,$40,$03,$00,$01,$01,$08,$08,$E2,$20,$A9,$7E   ;C2D97C
	.db $48,$AB,$20,$53,$D9,$22,$6D,$CB,$C2,$20,$A6,$D9,$22,$AB,$D0,$C2   ;C2D98C
	.db $22,$6F,$D3,$C2,$22,$54,$CB,$C2,$28,$6B,$08,$E2,$30,$A2,$0E,$BF   ;C2D99C  
	.db $2C,$D9,$C2,$A8,$BF,$40,$DA,$C2,$99,$C3,$89,$BF,$4F,$DA,$C2,$99   ;C2D9AC  
	.db $33,$8A,$CA,$10,$EA,$A9,$0E,$48,$AA,$BF,$2C,$D9,$C2,$A8,$64,$00   ;C2D9BC  
	.db $A3,$01,$85,$01,$5A,$8B,$22,$9F,$F6,$C3,$AB,$7A,$A6,$00,$BF,$2C   ;C2D9CC  
	.db $D9,$C2,$AA,$B9,$33,$8A,$30,$0F,$85,$00,$BD,$33,$8A,$30,$08,$99   ;C2D9DC  
	.db $33,$8A,$A5,$00,$9D,$33,$8A,$68,$3A,$D0,$CC,$A0,$0E,$BB,$BF,$2C   ;C2D9EC  
	.db $D9,$C2,$AA,$BD,$33,$8A,$30,$09,$C9,$0A,$90,$05,$A9,$FF,$9D,$33   ;C2D9FC  
	.db $8A,$88,$10,$E9,$A9,$0E,$48,$AA,$BF,$2C,$D9,$C2,$AA,$A8,$BD,$33   ;C2DA0C
	.db $8A,$30,$15,$AA,$98,$29,$0F,$9D,$66,$BE,$9D,$7A,$BE,$98,$4A,$4A   ;C2DA1C
	.db $4A,$4A,$9D,$70,$BE,$9D,$84,$BE,$68,$3A,$10,$DA,$A9,$0A,$8F,$8E   ;C2DA2C
	.db $BE,$7E,$28,$60,$06,$0C,$10,$06,$0C,$07,$0D,$10,$07,$0D,$03,$09   ;C2DA3C  
	.db $10,$03,$09,$00,$01,$FF,$02,$03,$04,$05,$FF,$06,$07,$08,$09,$FF   ;C2DA4C  
	.db $0A,$0B,$08,$E2,$20,$A9,$7E,$48,$AB,$20,$6D,$D9,$22,$6D,$CB,$C2   ;C2DA5C
	.db $20,$7D,$DA,$22,$AB,$D0,$C2,$22,$6F,$D3,$C2,$22,$54,$CB,$C2,$28   ;C2DA6C  
	.db $6B,$08,$E2,$30,$A2,$17,$BF,$3B,$D9,$C2,$A8,$BF,$B3,$DB,$C2,$99   ;C2DA7C
	.db $C3,$89,$BF,$CB,$DB,$C2,$99,$33,$8A,$CA,$10,$EA,$A9,$17,$48,$AA   ;C2DA8C  
	.db $BF,$3B,$D9,$C2,$A8,$64,$00,$A3,$01,$85,$01,$5A,$8B,$22,$9F,$F6   ;C2DA9C  
	.db $C3,$AB,$7A,$A6,$00,$BF,$3B,$D9,$C2,$AA,$B9,$33,$8A,$30,$0F,$85   ;C2DAAC  
	.db $00,$BD,$33,$8A,$30,$08,$99,$33,$8A,$A5,$00,$9D,$33,$8A,$68,$3A   ;C2DABC
	.db $D0,$CC,$A0,$17,$BB,$BF,$3B,$D9,$C2,$AA,$BD,$33,$8A,$30,$09,$C9   ;C2DACC  
	.db $0A,$90,$05,$A9,$FF,$9D,$33,$8A,$88,$10,$E9,$A9,$17,$48,$AA,$BF   ;C2DADC
	.db $3B,$D9,$C2,$AA,$A8,$BD,$33,$8A,$30,$15,$AA,$98,$29,$0F,$9D,$66   ;C2DAEC
	.db $BE,$9D,$7A,$BE,$98,$4A,$4A,$4A,$4A,$9D,$70,$BE,$9D,$84,$BE,$68   ;C2DAFC  
	.db $3A,$10,$DA,$A9,$0A,$8F,$8E,$BE,$7E,$A0,$12,$A9,$04,$85,$02,$A9   ;C2DB0C
	.db $02,$85,$04,$20,$E3,$DB,$A0,$15,$A9,$04,$85,$02,$A9,$08,$85,$04   ;C2DB1C
	.db $20,$E3,$DB,$A0,$42,$A9,$01,$85,$02,$A9,$02,$85,$04,$20,$E3,$DB   ;C2DB2C  
	.db $A0,$45,$A9,$01,$85,$02,$A9,$08,$85,$04,$20,$E3,$DB,$22,$5F,$F6   ;C2DB3C
	.db $C3,$A5,$00,$89,$03,$D0,$10,$AD,$D6,$89,$09,$02,$8D,$D6,$89,$AD   ;C2DB4C  
	.db $D7,$89,$09,$08,$8D,$D7,$89,$22,$5F,$F6,$C3,$A5,$00,$89,$03,$D0   ;C2DB5C  
	.db $10,$AD,$E5,$89,$09,$04,$8D,$E5,$89,$AD,$F5,$89,$09,$01,$8D,$F5   ;C2DB6C  
	.db $89,$22,$5F,$F6,$C3,$A5,$00,$89,$03,$D0,$10,$AD,$E8,$89,$09,$04   ;C2DB7C
	.db $8D,$E8,$89,$AD,$F8,$89,$09,$01,$8D,$F8,$89,$22,$5F,$F6,$C3,$A5   ;C2DB8C  
	.db $00,$89,$03,$D0,$10,$AD,$06,$8A,$09,$02,$8D,$06,$8A,$AD,$07,$8A   ;C2DB9C
	.db $09,$08,$8D,$07,$8A,$28,$60,$00,$00,$04,$04,$00,$00,$00,$02,$0F   ;C2DBAC
	.db $0F,$08,$00,$00,$02,$0F,$0F,$08,$00,$00,$00,$01,$01,$00,$00,$FF   ;C2DBBC  
	.db $00,$01,$02,$03,$FF,$FF,$04,$FF,$FF,$05,$FF,$FF,$06,$FF,$FF,$07   ;C2DBCC
	.db $FF,$FF,$08,$09,$0A,$0B,$FF,$08,$E2,$30,$22,$5F,$F6,$C3,$A5,$00   ;C2DBDC  
	.db $89,$01,$F0,$0A,$A5,$02,$48,$A5,$04,$85,$02,$68,$85,$04,$A2,$00   ;C2DBEC
	.db $BF,$E5,$CE,$C2,$C5,$02,$F0,$03,$E8,$80,$F5,$B9,$C3,$89,$1F,$E5   ;C2DBFC  
	.db $CE,$C2,$99,$C3,$89,$98,$18,$7F,$ED,$CE,$C2,$A8,$B9,$C3,$89,$1F   ;C2DC0C  
	.db $E7,$CE,$C2,$99,$C3,$89,$28,$60,$08,$E2,$20,$A9,$7E,$48,$AB,$20   ;C2DC1C  
	.db $6D,$D9,$22,$6D,$CB,$C2,$20,$43,$DC,$22,$AB,$D0,$C2,$22,$6F,$D3   ;C2DC2C  
	.db $C2,$22,$54,$CB,$C2,$28,$6B,$08,$E2,$30,$A2,$17,$BF,$3B,$D9,$C2   ;C2DC3C
	.db $A8,$BF,$60,$DD,$C2,$99,$C3,$89,$BF,$78,$DD,$C2,$99,$33,$8A,$CA   ;C2DC4C
	.db $10,$EA,$A9,$17,$48,$AA,$BF,$3B,$D9,$C2,$A8,$64,$00,$A3,$01,$85   ;C2DC5C  
	.db $01,$5A,$8B,$22,$9F,$F6,$C3,$AB,$7A,$A6,$00,$BF,$3B,$D9,$C2,$AA   ;C2DC6C  
	.db $B9,$33,$8A,$30,$0F,$85,$00,$BD,$33,$8A,$30,$08,$99,$33,$8A,$A5   ;C2DC7C  
	.db $00,$9D,$33,$8A,$68,$3A,$D0,$CC,$A9,$17,$48,$AA,$BF,$3B,$D9,$C2   ;C2DC8C
	.db $AA,$A8,$BD,$33,$8A,$30,$15,$AA,$98,$29,$0F,$9D,$66,$BE,$9D,$7A   ;C2DC9C
	.db $BE,$98,$4A,$4A,$4A,$4A,$9D,$70,$BE,$9D,$84,$BE,$68,$3A,$10,$DA   ;C2DCAC  
	.db $A9,$08,$8F,$8E,$BE,$7E,$A0,$22,$A9,$01,$85,$02,$A9,$08,$85,$04   ;C2DCBC
	.db $20,$E3,$DB,$A0,$23,$A9,$01,$85,$02,$A9,$08,$85,$04,$20,$E3,$DB   ;C2DCCC  
	.db $A0,$24,$A9,$01,$85,$02,$A9,$02,$85,$04,$20,$E3,$DB,$A0,$25,$A9   ;C2DCDC
	.db $01,$85,$02,$A9,$02,$85,$04,$20,$E3,$DB,$A0,$32,$A9,$04,$85,$02   ;C2DCEC  
	.db $A9,$08,$85,$04,$20,$E3,$DB,$A0,$33,$A9,$04,$85,$02,$A9,$08,$85   ;C2DCFC
	.db $04,$20,$E3,$DB,$A0,$34,$A9,$04,$85,$02,$A9,$02,$85,$04,$20,$E3   ;C2DD0C  
	.db $DB,$A0,$35,$A9,$04,$85,$02,$A9,$02,$85,$04,$20,$E3,$DB,$A0,$23   ;C2DD1C
	.db $A9,$04,$85,$02,$A9,$02,$85,$04,$20,$E3,$DB,$A0,$24,$A9,$04,$85   ;C2DD2C
	.db $02,$A9,$08,$85,$04,$20,$E3,$DB,$A0,$33,$A9,$01,$85,$02,$A9,$02   ;C2DD3C
	.db $85,$04,$20,$E3,$DB,$A0,$34,$A9,$01,$85,$02,$A9,$08,$85,$04,$20   ;C2DD4C  
	.db $E3,$DB,$28,$60,$06,$0A,$0A,$0A,$0A,$0C,$05,$00,$00,$00,$00,$05   ;C2DD5C  
	.db $05,$00,$00,$00,$00,$05,$03,$0A,$0A,$0A,$0A,$09,$FF,$FF,$FF,$FF   ;C2DD6C  
	.db $FF,$FF,$FF,$00,$01,$02,$03,$FF,$FF,$04,$05,$06,$07,$FF,$FF,$FF   ;C2DD7C  
	.db $FF,$FF,$FF,$FF,$08,$E2,$20,$A9,$7E,$48,$AB,$20,$53,$D9,$22,$6D   ;C2DD8C  
	.db $CB,$C2,$20,$AF,$DD,$22,$AB,$D0,$C2,$22,$6F,$D3,$C2,$22,$54,$CB   ;C2DD9C
	.db $C2,$28,$6B,$08,$E2,$30,$A2,$0E,$BF,$2C,$D9,$C2,$A8,$BF,$49,$DE   ;C2DDAC
	.db $C2,$99,$C3,$89,$BF,$58,$DE,$C2,$99,$33,$8A,$CA,$10,$EA,$A9,$0E   ;C2DDBC
	.db $48,$AA,$BF,$2C,$D9,$C2,$A8,$64,$00,$A3,$01,$85,$01,$5A,$8B,$22   ;C2DDCC
	.db $9F,$F6,$C3,$AB,$7A,$A6,$00,$BF,$2C,$D9,$C2,$AA,$B9,$33,$8A,$30   ;C2DDDC  
	.db $0F,$85,$00,$BD,$33,$8A,$30,$08,$99,$33,$8A,$A5,$00,$9D,$33,$8A   ;C2DDEC  
	.db $68,$3A,$D0,$CC,$A0,$0E,$BB,$BF,$2C,$D9,$C2,$AA,$BD,$33,$8A,$30   ;C2DDFC
	.db $09,$C9,$0A,$90,$05,$A9,$FF,$9D,$33,$8A,$88,$10,$E9,$A9,$0E,$48   ;C2DE0C
	.db $AA,$BF,$2C,$D9,$C2,$AA,$A8,$BD,$33,$8A,$30,$15,$AA,$98,$29,$0F   ;C2DE1C
	.db $9D,$66,$BE,$9D,$7A,$BE,$98,$4A,$4A,$4A,$4A,$9D,$70,$BE,$9D,$84   ;C2DE2C  
	.db $BE,$68,$3A,$10,$DA,$A9,$0A,$8F,$8E,$BE,$7E,$28,$60,$00,$00,$00   ;C2DE3C  
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$03   ;C2DE4C
	.db $04,$05,$06,$FF,$07,$08,$09,$0A,$0B,$0C,$0D,$08,$E2,$20,$A9,$7E   ;C2DE5C  
	.db $48,$AB,$20,$53,$D9,$22,$6D,$CB,$C2,$20,$86,$DE,$22,$AB,$D0,$C2   ;C2DE6C
	.db $22,$6F,$D3,$C2,$22,$54,$CB,$C2,$28,$6B,$08,$E2,$30,$22,$5F,$F6   ;C2DE7C  
	.db $C3,$A5,$00,$29,$07,$AA,$A9,$00,$CA,$30,$05,$18,$69,$0F,$80,$F8   ;C2DE8C  
	.db $85,$06,$AA,$BF,$6F,$DF,$C2,$A8,$A9,$01,$48,$18,$65,$06,$AA,$BF   ;C2DE9C  
	.db $6F,$DF,$C2,$85,$04,$A2,$00,$BF,$E5,$CE,$C2,$C5,$04,$F0,$03,$E8   ;C2DEAC  
	.db $80,$F5,$B9,$C3,$89,$1F,$E5,$CE,$C2,$99,$C3,$89,$98,$18,$7F,$ED   ;C2DEBC  
	.db $CE,$C2,$A8,$B9,$C3,$89,$1F,$E7,$CE,$C2,$99,$C3,$89,$68,$1A,$C9   ;C2DECC  
	.db $0F,$90,$C7,$A2,$0E,$BF,$2C,$D9,$C2,$A8,$BF,$E7,$DF,$C2,$99,$33   ;C2DEDC  
	.db $8A,$CA,$10,$F1,$A9,$0E,$48,$AA,$BF,$2C,$D9,$C2,$A8,$64,$00,$A3   ;C2DEEC
	.db $01,$85,$01,$5A,$8B,$22,$9F,$F6,$C3,$AB,$7A,$A6,$00,$BF,$2C,$D9   ;C2DEFC  
	.db $C2,$AA,$B9,$33,$8A,$30,$0F,$85,$00,$BD,$33,$8A,$30,$08,$99,$33   ;C2DF0C
	.db $8A,$A5,$00,$9D,$33,$8A,$68,$3A,$D0,$CC,$A0,$0E,$BB,$BF,$2C,$D9   ;C2DF1C
	.db $C2,$AA,$BD,$33,$8A,$30,$09,$C9,$0A,$90,$05,$A9,$FF,$9D,$33,$8A   ;C2DF2C
	.db $88,$10,$E9,$A9,$0E,$48,$AA,$BF,$2C,$D9,$C2,$AA,$A8,$BD,$33,$8A   ;C2DF3C
	.db $30,$15,$AA,$98,$29,$0F,$9D,$66,$BE,$9D,$7A,$BE,$98,$4A,$4A,$4A   ;C2DF4C  
	.db $4A,$9D,$70,$BE,$9D,$84,$BE,$68,$3A,$10,$DA,$A9,$0A,$8F,$8E,$BE   ;C2DF5C
	.db $7E,$28,$60,$11,$04,$04,$02,$01,$01,$02,$04,$04,$02,$01,$01,$02   ;C2DF6C  
	.db $04,$04,$31,$01,$01,$02,$04,$04,$02,$01,$01,$02,$04,$04,$02,$01   ;C2DF7C  
	.db $01,$11,$02,$02,$02,$02,$04,$08,$08,$08,$08,$04,$02,$02,$02,$02   ;C2DF8C  
	.db $15,$08,$08,$08,$08,$04,$02,$02,$02,$02,$04,$08,$08,$08,$08,$11   ;C2DF9C  
	.db $04,$04,$02,$02,$02,$02,$01,$01,$08,$08,$08,$04,$02,$02,$15,$04   ;C2DFAC  
	.db $04,$08,$08,$08,$08,$01,$01,$02,$02,$02,$04,$08,$08,$31,$01,$01   ;C2DFBC  
	.db $02,$02,$02,$02,$04,$04,$08,$08,$08,$01,$02,$02,$35,$01,$01,$08   ;C2DFCC
	.db $08,$08,$08,$04,$04,$02,$02,$02,$01,$08,$08,$00,$01,$02,$03,$04   ;C2DFDC
	.db $05,$06,$FF,$07,$08,$09,$0A,$0B,$0C,$0D,$FF,$FF,$FF,$FF,$FF,$FF   ;C2DFEC  
	
