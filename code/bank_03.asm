.bank $03
.org $0000 ;$C30000

ClearItemTable:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$FF
	ldx.w #$007E
@lbl_C3000A:
	sta.l wItemType,x
	dex
	bpl @lbl_C3000A
	ldx.w #$009F
	lda.b #$FF
@lbl_C30016:
	sta.l wItemCustomNamesBuffer,x
	dex
	bpl @lbl_C30016
	plp
	rtl

RandomizeItemAppearances:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldx.w #$009F
	lda.b #$FF
@lbl_C30029:
	sta.l wItemCustomNamesBuffer,x
	dex
	bpl @lbl_C30029
	sep #$30 ;AXY->8
	ldx.b #$E5
@lbl_C30034:
	txa
	sta.l wItemHasCustomName,x
	lda.b #$01
	sta.l wItemIdentified,x
	dex
	cpx.b #$FF
	bne @lbl_C30034
	ldx.b #$14
@lbl_C30046:
	txa
	clc
	adc.b #$00
	sta.l $7E911A,x
	dex
	bpl @lbl_C30046
	ldx.b #$19
@lbl_C30053:
	txa
	clc
	adc.b #$2E
	sta.l $7E9148,x
	dex
	bpl @lbl_C30053
	ldx.b #$0A
@lbl_C30060:
	txa
	clc
	adc.b #$54
	sta.l $7E916E,x
	dex
	bpl @lbl_C30060
	ldx.b #$0E
@lbl_C3006D:
	txa
	clc
	adc.b #$6B
	sta.l $7E9185,x
	dex
	bpl @lbl_C3006D
	ldx.b #$11
@lbl_C3007A:
	txa
	clc
	adc.b #$86
	sta.l $7E91A6,x
	dex
	bpl @lbl_C3007A
	lda.b #$28
	sta.b wTemp00
	lda.b #$3C
	sta.b wTemp01
	jsl.l ShuffleItemAppearanceRange
	lda.b #$56
	sta.b wTemp00
	lda.b #$6F
	sta.b wTemp01
	jsl.l ShuffleItemAppearanceRange
	lda.b #$7C
	sta.b wTemp00
	lda.b #$86
	sta.b wTemp01
	jsl.l ShuffleItemAppearanceRange
	lda.b #$93
	sta.b wTemp00
	lda.b #$A1
	sta.b wTemp01
	jsl.l ShuffleItemAppearanceRange
	lda.b #$B4
	sta.b wTemp00
	lda.b #$C5
	sta.b wTemp01
	jsl.l ShuffleItemAppearanceRange
	ldx.b #$E5
@lbl_C300C3:
	lda.l wItemHasCustomName,x
	sta.l wItemUnidentifiedName,x
	dex
	cpx.b #$FF
	bne @lbl_C300C3
	plp
	rtl

PreIdentifyDungeonItems:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$00
	beq @lbl_C300ED
	cmp.b #$01
	beq @lbl_C300FA
	cmp.b #$02
	beq @lbl_C300FA
	cmp.b #$03
	beq @lbl_C300FA
	bra @lbl_C30126
@lbl_C300ED:
	.db $A2,$C5,$A9,$01,$9F,$0C,$90,$7E   ;C300ED
	.db $CA,$E0,$B4,$10,$F7               ;C300F5
@lbl_C300FA:
	ldx.b #$3C
	lda.b #$01
@lbl_C300FE:
	sta.l wItemIdentified,x
	dex
	cpx.b #$28
	bpl @lbl_C300FE
	ldx.b #$6F
	lda.b #$01
@lbl_C3010B:
	sta.l wItemIdentified,x
	dex
	cpx.b #$56
	bpl @lbl_C3010B
	lda.b #$01
	sta.l $7E90CE
	sta.l $7E90CF
	sta.l $7E90D0
	sta.l $7E90D1
@lbl_C30126:
	lda.b #$01
	sta.l $7E908F
	sta.l $7E9074
	sta.l $7E9049
	sta.l $7E904A
	sta.l $7E904B
	sta.l $7E904C
	plp
	rtl

ShuffleItemAppearanceRange:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b wTemp00
	phx
	ldy.b wTemp01
@lbl_C3014E:
	lda.b wTemp01,s
	sta.b wTemp00
	sty.b wTemp01
	phy
	jsl.l GetRandomInRange
	ply
	ldx.b wTemp00
	lda.w wItemHasCustomName,y
	sta.b wTemp00
	lda.w wItemHasCustomName,x
	sta.w wItemHasCustomName,y
	lda.b wTemp00
	sta.w wItemHasCustomName,x
	lda.b #$00
	sta.w wItemIdentified,y
	dey
	tya
	cmp.b wTemp01,s
	bne @lbl_C3014E
	lda.b #$00
	sta.w wItemIdentified,y
	plx
	plp
	rtl
	php                                     ;C3017F
	sep #$30                                ;C30180
	lda $00                                 ;C30182
	ldx #$7F                                ;C30184
	sta $7E8B8C,x                           ;C30186
	stx $00                                 ;C3018A
	jsl $C30192                             ;C3018C
	plp                                     ;C30190
	rtl                                     ;C30191

IdentifyItem:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	txy
	tax
	lda.l wItemIdentified,x
	pha
	lda.b #$01
	sta.l wItemIdentified,x
	lda.l DATA8_C341BB,x
	cmp.b #$06
	beq @lbl_C301BC
	cmp.b #$03
	beq @lbl_C301BC
	cmp.b #$05
	beq @lbl_C301BC
	cmp.b #$07
	bne @lbl_C301C3
@lbl_C301BC:
	tyx
	lda.b #$01
	sta.l wItemTimesIdentified,x
@lbl_C301C3:
	pla
	bne @lbl_C301CC
	sty.b wTemp00
	jsl.l ValidateCustomNameSlot
@lbl_C301CC:
	plp
	rtl

FindFreeCustomNameSlot:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldx.w #$0098
	lda.b #$FF
@lbl_C301D8:
	cmp.l wItemCustomNamesBuffer,x
	beq @lbl_C301EC
	.rept 8
		dex
	.endr
	bpl @lbl_C301D8
	sta.b wTemp00
	plp
	rtl
@lbl_C301EC:
	stz.b wTemp00
	plp
	rtl

; Sets up scratch buffer for item renaming. Returns buffer pointer in wTemp00/wTemp02.
; For blank scrolls: uses fixed buffer at $7E9360
; For other items: allocates slot in wItemCustomNamesBuffer
SetupItemRenameBuffer:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	cmp.b #$68
	beq @lbl_C30245
	phx
	jsl.l ValidateCustomNameSlot
	plx
	lda.l wItemType,x
	pha
	rep #$10 ;XY->16
	ldx.w #$0098
	lda.b #$FF
@lbl_C3020F:
	cmp.l wItemCustomNamesBuffer,x
	beq @lbl_C30222
	.rept 8
		dex
	.endr
	bpl @lbl_C3020F
	ldx.w #0
@lbl_C30222:
	lda.b #$7E
	sta.b wTemp02
	rep #$20 ;A->16
	txa
	clc
	adc.w #$92BE
	sta.b wTemp00
	txa
	lsr a
	lsr a
	lsr a
	sep #$30 ;AXY->8
	sec 
	sbc.b #$14
	plx
	sta.l wItemHasCustomName,X
	lda.b #$FF
	sta.l $7E935F
	plp 
	rtl
@lbl_C30245:
	sep #$30 ;AXY->8
	txa 
	sta.l $7E935F
	lda.b #$7E
	sta.b wTemp02
	rep #$20 ;A->16
	lda.w #$9360
	sta wTemp00
	plp 
	rtl
; Applies item buffer changes from scratch RAM to actual item slot.
; Reads slot from $7E935F and writes $9360-$9365 back to item fields.
ApplyItemBufferChanges:
	php
	sep #$30 ;AXY->8
	lda.l $7E935F
	bmi @lbl_C30293
	tax 
	lda.l $7E9360
	sta.l wItemModification1,x
	lda.l $7E9361
	sta.l wItemModification2,x
	lda.l $7E9362
	sta.l wItemFuseAbility1,x
	lda.l $7E9363
	sta.l wItemFuseAbility2,x
	lda.l $7E9364
	sta.l wItemIsCursed,x
	lda.l $7E9365
	sta.l wItemTimesIdentified,x
@lbl_C30293:
	plp 
	rtl


SpawnFloorItem:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b #$7E
@lbl_C3029E:
	lda.w wItemType,y
	cmp.b #$FF
	beq InitFloorItemSlot
	dey
	bpl @lbl_C3029E
;C302A8
	.db $80,$53
InitFloorItemSlot:
	lda.b #$00
	sta.w wItemTimesIdentified,y
	lda.b wTemp00
	sta.w wItemType,y
	lda.b #$00
	sta.w wItemIsCursed,y
	lda.b wTemp01
	sta.w wItemModification1,y
	bpl @lbl_C302C5
	lda.b #$01
	sta.w wItemIsCursed,y
@lbl_C302C5:
	ldx.b wTemp00
	cpx.b #$68
	bne @lbl_C302D0
	lda.b #$FF
	sta.w wItemModification1,y
@lbl_C302D0:
	lda.l DATA8_C341BB,x
	cmp.b #$06
	bne @lbl_C302DD
	lda.b #$00
	sta.w wItemModification1,y
@lbl_C302DD:
	lda.b wTemp02
	sta.w wItemModification2,y
	lda.b #$FF
	sta.w wItemPotNextItem,y
	lda.b #$00
	sta.w wItemGoods,y
	txa
	asl a
	tax
	lda.l ItemDefaultFuseAbility1ByType,x
	sta.w wItemFuseAbility1,y
	lda.l ItemDefaultFuseAbility2ByType,x
	sta.w wItemFuseAbility2,y
	sty.b wTemp00
	plp
	rtl

; Default fuse-ability bytes per item type, stored as interleaved
; (ability1, ability2) pairs so callers can read either byte separately
; or the full 16-bit pair at once.
ItemDefaultFuseAbility1ByType:
	.db $00                               ;C30301

ItemDefaultFuseAbility2ByType:
	.db $00,$00,$00,$10,$00,$00,$00,$01   ;C30302
	.db $00,$00,$00,$00,$00               ;C3030A
	.db $02,$00,$20,$02,$40,$00,$80,$00   ;C3030F
	.db $00,$01                           ;C30317
	.db $04,$00,$08,$00,$00,$00,$00,$00   ;C30319  
	.db $00,$00                           ;C30321
	.db $00,$00,$00,$00,$00,$00,$00,$00   ;C30323
	.db $00,$00                           ;C3032B
	.db $05,$00                           ;C3032D
	.db $00,$00,$08,$00,$04,$00           ;C3032F
	.db $00,$00                           ;C30335
	.db $10,$00,$00,$00,$20,$00           ;C30337  
	.db $02,$00                           ;C3033D
	.db $40,$00,$80,$00,$00,$00,$00,$01   ;C3033F
	.db $00,$02                           ;C30347
	.db $00,$04                           ;C30349
	.db $00,$00,$00,$00,$00,$00           ;C3034B

SpawnItemAtTempSlot:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b #$7F
	jmp.w InitFloorItemSlot

SpawnFloorItemWithRandomMod:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l DATA8_C3438B,x
	sta.b wTemp00
	lda.l DATA8_C34473,x
	phx
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	bpl @lbl_C3037E
	and.b #$7F
	tax
	lda.l UNREACH_C303A0,x
@lbl_C3037E:
	tay
	bpl @lbl_C3038B
	jsl $C627E6                             ;C30381
	lda $00                                 ;C30385
	cmp.b #$00
	bne @lbl_C3038B
@lbl_C3038B:
	sty.b wTemp01
	lda.b #$00
	sta.b wTemp02
	plx
	cpx.b #$9B
	bne @lbl_C30398
	stz.b wTemp01
@lbl_C30398:
	stx.b wTemp00
	jsl.l SpawnFloorItem
	plp
	rtl

UNREACH_C303A0:
	.db $00,$00,$00,$00                   ;C303A0
	.db $00,$00                           ;C303A4
	.db $00,$00,$00,$00                   ;C303A6
	.db $00                               ;C303AA
	.db $01,$01,$02                       ;C303AB  
	.db $03,$FF,$00,$00,$00               ;C303AE
	.db $00                               ;C303B3
	.db $00,$00,$00                       ;C303B4
	.db $00,$00,$00                       ;C303B7
	.db $00                               ;C303BA
	.db $01                               ;C303BB  
	.db $01,$02,$03                       ;C303BC
	.db $FF,$03                           ;C303BF  
	.db $03,$03                           ;C303C1
	.db $03,$03,$03,$03,$03,$03,$03,$03   ;C303C3  
	.db $03,$FD,$FD,$FD                   ;C303CB
	.db $FD                               ;C303CF  

SpawnRandomFloorItemOrGitan:
	php
	sep #$30 ;AXY->8
	jsl.l Random
	lda.b wTemp00
	cmp.b #$40
	bcc @lbl_C303E3
	jsl.l SpawnRandomDungeonFloorItem
	plp
	rtl
@lbl_C303E3:
	jsl.l SpawnFloorGitan
	plp
	rtl

SpawnFloorItemFromTable:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
@lbl_C303EF:
	lda.b wTemp01,s
	sta.b wTemp00
	jsr.w GetDungeonItemRange
	ldx.b wTemp00
	cpx.b #$E0
	beq @lbl_C3040E
	phx
	jsr.w CheckItemSpawnGated
	plx
	lda.b wTemp00
	beq @lbl_C303EF
	stx.b wTemp00
	jsl.l SpawnFloorItemWithRandomMod
	pla
	plp
	rtl
@lbl_C3040E:
	pla
	sta.b wTemp00
	jsr.w PickRandomCategoryItem
	jsl.l SpawnFloorItem
	plp
	rtl

SpawnRandomDungeonFloorItem:
	php
	sep #$30 ;AXY->8
@lbl_C3041D:
	jsr.w RollDungeonItemType
	ldx.b wTemp00
	phx
	jsr.w CheckItemSpawnGated
	plx
	lda.b wTemp00
	beq @lbl_C3041D
	stx.b wTemp00
	jsl.l SpawnFloorItemWithRandomMod
	plp
	rtl

GetDungeonItemRange:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b wTemp00
	bne @lbl_C30463
	jsl $C627E6                             ;C3043C
	lda $00                                 ;C30440
	ldx #$001B                              ;C30442
	cmp #$08                                ;C30445
	beq @lbl_C30461                         ;C30447
	ldx #$001B                              ;C30449
	cmp #$01                                ;C3044C
	beq @lbl_C30461                         ;C3044E
	ldx #$0037                              ;C30450
	cmp #$02                                ;C30453
	beq @lbl_C30461                         ;C30455
	ldx #$0053                              ;C30457
	cmp #$03                                ;C3045A
	beq @lbl_C30461                         ;C3045C
	ldx #$0078                              ;C3045E
@lbl_C30461:
	.db $80,$7B   ;C30461
@lbl_C30463:
	dec a
	bne @lbl_C3048D
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	ldx.w #$0024
	cmp.b #$08
	beq @lbl_C3048B
	ldx.w #$0024
	cmp.b #$01
	beq @lbl_C3048B
	.db $A2,$3E,$00,$C9,$02,$F0,$0A,$A2,$5C,$00,$C9,$03,$F0,$03,$A2,$82   ;C3047A
	.db $00                               ;C3048A
@lbl_C3048B:
	bra RollRandomItemFromTable
@lbl_C3048D:
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	ldx.w #$002B
	cmp.b #$08
	beq @lbl_C304B2
	ldx.w #$002B
	cmp.b #$01
	beq @lbl_C304B2
	.db $A2,$45,$00,$C9,$02,$F0,$0A,$A2,$65,$00,$C9,$03,$F0,$03,$A2,$8C   ;C304A1
	.db $00                               ;C304B1
@lbl_C304B2:
	bra RollRandomItemFromTable

RollDungeonItemType:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	ldx.w #$0012
	cmp.b #$08
	beq RollRandomItemFromTable
	ldx.w #$0012
	cmp.b #$01
	beq RollRandomItemFromTable
	.db $A2,$30,$00,$C9,$02,$F0,$0A,$A2,$4C,$00,$C9,$03,$F0,$03,$A2,$6E   ;C304CD
	.db $00                               ;C304DD
RollRandomItemFromTable:
	jsl.l Random
	lda.b wTemp00
@lbl_C304E4:
	dex
	cmp.l DungeonSpawnTablesGroupRates,x
	bcc @lbl_C304E4
	rep #$20 ;A->16
	txa
	asl a
	tax
	lda.l DungeonSpawnTablesItemRatesTable,x
	tax
	sep #$20 ;A->8
	jsl.l Random
	lda.b wTemp00
@lbl_C304FD:
	dex
	cmp.l DungeonItemSpawnTablesItemRates,x
	bcc @lbl_C304FD
	lda.l DungeonItemSpawnTablesTypes,x
	sta.b wTemp00
	plp
	rts

; Picks a random item from a dungeon-specific sub-table for the given category.
; Called when GetDungeonItemRange returns $E0 (sentinel for category-based spawns).
; Returns item type in wTemp01 and Item_MonsterMeat ($E0) in wTemp00.
PickRandomCategoryItem:
	php
	sep #$30 ;AXY->8
	ldy.b wTemp00
	jsl.l GetCurrentDungeon
	sty.b wTemp01
	rep #$20 ;A->16
	ldx.b #$00
	bra @lbl_C30526
@lbl_C3051D:
	cmp.b wTemp00
	beq @lbl_C3052C
	inx
	inx
	inx
	inx
	inx
@lbl_C30526:
	lda.l DATA8_C30559,x
	bpl @lbl_C3051D
@lbl_C3052C:
	lda.l UNREACH_C3055B,x
	pha
	sep #$20 ;A->8
	lda.l UNREACH_C3055D,x
	pha
@lbl_C30538:
	jsl.l Random
	lda.b wTemp00
	cmp.b wTemp01,s
	bcs @lbl_C30538
	rep #$30 ;AXY->16
	and.w #$00FF
	asl a
	tay
	restorebank
	lda.b ($02,s),y
	sta.b wTemp01
	sep #$20 ;A->8
	lda.b #$E0
	sta.b wTemp00
	pla
	plx
	plp
	rts

DATA8_C30559:
	.db $01,$00                           ;C30559

UNREACH_C3055B:
	.db $61,$51                           ;C3055B  

UNREACH_C3055D:
	.db $14                               ;C3055D  
	.db $01,$01,$89,$51,$14,$01,$02,$B1   ;C3055E
	.db $51,$05                           ;C30566
	.db $02,$00,$BB,$51,$1C,$02,$01,$F3,$51,$27,$02,$02,$41,$52,$31,$03   ;C30568
	.db $00,$A3,$52,$00,$03,$01,$A3,$52,$01,$03,$02,$A5,$52,$01,$04,$00   ;C30578
	.db $A7,$52,$27,$04,$01,$F5,$52,$32,$04,$02,$59,$53,$2D,$FF,$FF,$61   ;C30588  
	.db $51,$14                           ;C30598  

CheckItemSpawnGated:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b #$C0
	bne @lbl_C305B3
;C305A3
	.db $A9,$04,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$05,$B0,$16,$80,$1A
@lbl_C305B3:
	cmp.b #$82
	bne @lbl_C305D1
	GetEvent Event_Naoki
	cmp.b #$07
	bcs @lbl_C305C7
	bra @lbl_C305CD
@lbl_C305C7:
	lda.b #$01
	sta.b wTemp00
	plp
	rts
@lbl_C305CD:
	stz.b wTemp00
	plp
	rts
@lbl_C305D1:
	cmp.b #$08
	beq @lbl_C305DD
	cmp.b #$64
	beq @lbl_C305DD
	cmp.b #$65
	bne @lbl_C305C7
@lbl_C305DD:
	jsl $C627E6                             ;C305DD
	lda $00                                 ;C305E1
	cmp #$01                                ;C305E3
	.db $D0,$E0   ;C305E5
	jsl $C62771                             ;C305E7
	lda $00                                 ;C305EB
	cmp #$08                                ;C305ED
	.db $B0,$D6   ;C305EF
	.db $80,$DA   ;C305F1

SpawnFloorGitan:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.w #$03E8
	pha
	jsl.l func_C3F683
	ldx.b wTemp00
	sep #$20 ;A->8
	lda.b wTemp01,s
	sta.b wTemp01
	jsl.l MultiplyPackedBytesToWord
	lda.b wTemp01
	sta.b wTemp01,s
	stx.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	jsl.l MultiplyPackedBytesToWord
	lda.b #$00
	sta.b wTemp02,s
	rep #$20 ;A->16
	pla
	clc
	adc.b wTemp00
	sta.b wTemp01
	ldx.b #$E5
	stx.b wTemp00
	jsl.l SpawnFloorItem
	plp
	rtl

; Spawns a large Gitan pile with doubled value (mod1/mod2 hold value, shifted left with overflow cap at $FFFF).
SpawnLargeGitan:
	php
	sep #$30 ;AXY->8
	jsl.l SpawnFloorGitan
	ldx.b wTemp00
	lda.l wItemModification2,x
	xba
	lda.l wItemModification1,x
	rep #$20 ;A->16
	asl a
	bcc @lbl_C3064A
;C30647
	.db $A9,$FF,$FF
@lbl_C3064A:
	sep #$20 ;A->8
	sta.l wItemModification1,x
	xba
	sta.l wItemModification2,x
	stx.b wTemp00
	plp
	rtl

UpgradeItemModification:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemModification1,x
	cmp.b #$63
	beq @lbl_C3066B
	inc a
	sta.l wItemModification1,x
@lbl_C3066B:
	jsl.l IdentifyItem
	plp
	rtl

CreateFloorItem:
	php
	sep #$30 ;AXY->8
	ldx.b #$7E
@lbl_C30676:
	lda.l wItemType,x
	cmp.b #$FF
	beq @lbl_C30683
	dex
	bpl @lbl_C30676
;C30681  
	.db $80,$42
@lbl_C30683:
	lda.b wTemp00
	sta.l wItemType,x
	lda.b wTemp01
	sta.l wItemIsCursed,x
	lda.b wTemp02
	sta.l wItemModification1,x
	lda.b wTemp03
	sta.l wItemModification2,x
	lda.b wTemp04
	sta.l wItemFuseAbility1,x
	lda.b wTemp05
	sta.l wItemFuseAbility2,x
	lda.b #$00
	sta.l wItemGoods,x
	sta.l wItemTimesIdentified,x
	lda.b #$FF
	sta.l wItemPotNextItem,x
	lda.l wItemType,x
	cmp.b #$68
	bne @lbl_C306C5
;C306BF
	.db $A9,$FF,$9F,$8C,$8C,$7E
@lbl_C306C5:
	stx.b wTemp00
	plp
	rtl

GetItemStatsToTemp:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	sta.b wTemp00
	lda.l wItemIsCursed,x
	sta.b wTemp01
	lda.l wItemModification1,x
	sta.b wTemp02
	lda.l wItemModification2,x
	sta.b wTemp03
	lda.l wItemFuseAbility1,x
	sta.b wTemp04
	lda.l wItemFuseAbility2,x
	sta.b wTemp05
	plp
	rtl

FreeFloorItemSlot:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$80
	bcs @lbl_C3070E
	bra @lbl_C30700
@lbl_C306FF:
	.db $AA
@lbl_C30700:
	lda.b #$FF
	sta.l wItemType,x
	lda.l wItemPotNextItem,x
	cmp.b #$FF
	bne @lbl_C306FF
@lbl_C3070E:
	plp
	rtl

GetItemDisplayInfo:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wItemModification1,y
	sta.b wTemp02
	lda.w wItemModification2,y
	sta.b wTemp03
	lda.w wItemIsCursed,y
	sta.b wTemp07
	ldx.w wItemType,y
	stx.b wTemp01
	stx.b wTemp05
	cpx.b #$E7
	beq @lbl_C30773
	lda.l DATA8_C341BB,x
	sta.b wTemp00
	lda.l DATA8_C342A3,x
	clc
	adc.b wTemp02
	sta.b wTemp04
	lda.w wItemIdentified,x
	bne @lbl_C3074C
	lda.w wItemHasCustomName,x
	sta.b wTemp05
@lbl_C3074C:
	cmp.b #$EC
	lda.b #$00
	rol a
	asl a
	ora.w wItemIdentified,x
	asl a
	ora.w wItemTimesIdentified,y
	ldx.b wTemp00
	cpx.b #$0B
	beq @lbl_C30763
	cpx.b #$04
	bne @lbl_C30765
@lbl_C30763:
	ora.b #$01
@lbl_C30765:
	sta.b wTemp06
	lda.b wTemp01
	cmp.b #Item_InvisibleItem
	beq @lbl_C3077D
	cmp.b #$68
	beq @lbl_C30789
	plp
	rtl
@lbl_C30773:
	lda $02                                 ;C30773
	sta $00                                 ;C30775
	lda #$03                                ;C30777
	sta $06                                 ;C30779
	plp                                     ;C3077B
	rtl                                     ;C3077C
@lbl_C3077D:
	lda $7E8975                             ;C3077D
	bne @lbl_C30787                         ;C30781
	lda #$E6                                ;C30783
	sta $05                                 ;C30785
@lbl_C30787:
	plp                                     ;C30787
	rtl                                     ;C30788
@lbl_C30789:
	lda.b #$02
	sta.b wTemp06
	lda.w wItemModification1,y
	cmp.b #$FF
	beq @lbl_C30798
;C30794
	.db $A9,$EC,$85,$05
@lbl_C30798:
	plp
	rtl

; Sets special flags on wTemp01 slot index based on item type.
; Item_InvisibleItem: if canSeeInvisibleObjects==0, sets bit 7 on wTemp01 (hides item from Shiren).
; Nduba meat ($E7): if wItemIsCursed==$0C, sets wTemp01=$83 (special Nduba state).
AdjustItemSlotFlags:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp01
	cpx.b #$7F
	bcs @lbl_C307C7
	lda.l wItemType,x
	cmp.b #Item_InvisibleItem
	bne @lbl_C307B7
	lda $7E8975                             ;C307AB
	bne @lbl_C307B5                         ;C307AF
	lda #$80                                ;C307B1
	sta $01                                 ;C307B3
@lbl_C307B5:
	plp                                     ;C307B5
	rtl                                     ;C307B6
@lbl_C307B7:
	cmp.b #$E7
	bne @lbl_C307C7
	.db $BF,$8C,$8C,$7E,$C9,$0C,$D0,$04   ;C307BB  
	.db $A9,$83,$85,$01                   ;C307C3
@lbl_C307C7:
	plp
	rtl

; Checks if the item at wTemp01 is a blank scroll ($68) named "Sanctuary" (text $04CC).
; Returns wTemp06=0 if it matches, wTemp06=1 otherwise (including non-blank-scroll items).
CheckIsNamedSanctuaryScroll:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp01
	lda.l wItemType,x
	cmp.b #$68
	beq @lbl_C307DC
@lbl_C307D6:
	lda.b #$01
	sta.b wTemp06
	plp
	rtl
@lbl_C307DC:
	bankswitch 0x7E
	lda.w wItemModification1,x
	sta.w $9360
	lda.w wItemModification2,x
	sta.w $9361
	lda.w wItemFuseAbility1,x
	sta.w $9362
	lda.w wItemFuseAbility2,x
	sta.w $9363
	lda.w wItemIsCursed,x
	sta.w $9364
	lda.w wItemTimesIdentified,x
	sta.w $9365
	lda.b #$FF
	sta.w $9366
	rep #$10 ;XY->16
	ldx.w #$04CC
	stx.b wTemp00
	ldy.w #$9360
	sty.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	jsl.l CheckIfItemNameEqualToTextEntry
	bcs @lbl_C307D6
;C3081F
	stz $06                                 ;C3081F
	plp                                     ;C30821
	rtl                                     ;C30822

; No-op handler for items that don't need special processing.
NullItemHandler:
rtl

; Variant of CheckIsNamedSanctuaryScroll using wTemp00 as both item slot and result register.
; Returns wTemp00=0 if blank scroll ($68) named "Sanctuary", wTemp00=1 otherwise.
CheckIsNamedSanctuaryScrollAlt:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	cmp.b #$68
	beq @lbl_C30837
@lbl_C30831:
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C30837:
	bankswitch 0x7E
	lda.w wItemModification1,x
	sta.w $9360
	lda.w wItemModification2,x
	sta.w $9361
	lda.w wItemFuseAbility1,x
	sta.w $9362
	lda.w wItemFuseAbility2,x
	sta.w $9363
	lda.w wItemIsCursed,x
	sta.w $9364
	lda.w wItemTimesIdentified,x
	sta.w $9365
	lda.b #$FF
	sta.w $9366
	rep #$10 ;XY->16
	ldx.w #$04CC
	stx.b wTemp00
	ldy.w #$9360
	sty.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	jsl.l CheckIfItemNameEqualToTextEntry
	bcs @lbl_C30831
	;C3087A
	stz $00                                 ;C3087A
	plp                                     ;C3087C
	rtl                                     ;C3087D
	


.include "code/item_effects.asm"

RestoreItemFromThrowTemp:
	php
	sep #$30 ;AXY->8
	jsl.l SpawnFloorItem
	ldy.b wTemp00
	bmi @lbl_C33A4E
	bankswitch 0x7E
	lda.w $8C0B
	sta.w wItemType,y
	lda.w $8C8B
	sta.w wItemIsCursed,y
	lda.w $8D0B
	sta.w wItemModification1,y
	lda.w $8D8B
	sta.w wItemModification2,y
	lda.w $8F0B
	sta.w wItemGoods,y
@lbl_C33A4E:
	plp
	rtl

PrepareSelectedThrowableItem:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	ldx.w wItemType,y
	lda.l DATA8_C341BB,x
	cmp.b #$04
	bne @lbl_C33A8E
	lda.w wItemModification1,y
	dec a
	beq @lbl_C33A8E
	sta.w wItemModification1,y
	; Split an arrow stack into a temporary single-arrow item for the common
	; throw-effect pipeline.
	stx.w $8C0B
	lda.w wItemIsCursed,y
	sta.w $8C8B
	lda.b #$01
	sta.w $8D0B
	lda.w wItemModification2,y
	sta.w $8D8B
	lda.b #$FF
	sta.w $8E8B
	lda.w wItemGoods,y
	sta.w $8F0B
	ldy.b #$7F
@lbl_C33A8E:
	sty.b wTemp00
	plp
	rtl

SetItemGoods:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	cmp.b #$E7
	beq @lbl_C33AB0
	tax
	lda.l DATA8_C341BB,x
	cmp.b #$08
	beq @lbl_C33AB0
	ldx.b wTemp00
	lda.b wTemp01
	sta.l wItemGoods,x
@lbl_C33AB0:
	plp
	rtl

SetContainedItemsGoods:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
@lbl_C33AB7:
	tax
	txy
	lda.l wItemType,x
	tax
	lda.l DATA8_C341BB,x
	tyx
	cmp.b #$08
	beq @lbl_C33ACD
;C33AC7  
	.db $A5,$01,$9F,$8C,$8E,$7E
@lbl_C33ACD:
	lda.l wItemPotNextItem,x
	bpl @lbl_C33AB7
	plp
	rtl

GetItemGoods:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemGoods,x
	sta.b wTemp00
	plp
	rtl

GetPotNextItem:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemPotNextItem,x
	sta.b wTemp00
	plp
	rtl

GetContainedItemByIndex:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
@lbl_C33AF4:
	lda.l wItemPotNextItem,x
	tax
	dec.b wTemp01
	bpl @lbl_C33AF4
	stx.b wTemp00
	plp
	rtl

RemoveContainedItemByIndex:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemModification1,x
	inc a
	sta.l wItemModification1,x
	bra @lbl_C33B16
@lbl_C33B11:
	lda.l wItemPotNextItem,x
	tax
@lbl_C33B16:
	dec.b wTemp01
	bpl @lbl_C33B11
	phx
	lda.l wItemPotNextItem,x
	tax
	tay
	lda.l wItemPotNextItem,x
	plx
	sta.l wItemPotNextItem,x
	tyx
	lda.b #$FF
	sta.l wItemPotNextItem,x
	sty.b wTemp00
	plp
	rtl

InsertContainedItemByIndex:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemModification1,x
	dec a
	sta.l wItemModification1,x
	bra @lbl_C33B4A
@lbl_C33B45:
	lda.l wItemPotNextItem,x
	tax
@lbl_C33B4A:
	dec.b wTemp01
	bpl @lbl_C33B45
	lda.l wItemPotNextItem,x
	tay
	lda.b wTemp02
	sta.l wItemPotNextItem,x
	tax
	tya
	sta.l wItemPotNextItem,x
	plp
	rtl

MergeItemModifications:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp01
	lda.l wItemModification1,x
	ldx.b wTemp00
	clc
	adc.l wItemModification1,x
	cmp.b #$63
	bcc @lbl_C33B77
;C33B75
	.db $A9,$63
@lbl_C33B77:
	sta.l wItemModification1,x
	lda.b wTemp01
	sta.b wTemp00
	jsl.l FreeFloorItemSlot
	plp
	rtl
	php                                     ;C33B85
	sep #$30                                ;C33B86
	ldx $00                                 ;C33B88
	jsl $C627E6                             ;C33B8A
	lda $00                                 ;C33B8E
	cmp #$00                                ;C33B90
	bne @lbl_C33BA5                         ;C33B92
	lda $7E8B8C,x                           ;C33B94
	ldx #$24                                ;C33B96
@lbl_C33B9A:
	cmp $C33BC7,x                           ;C33B98
	beq @lbl_C33BA7                         ;C33B9A
	dex                                     ;C33B9C
	dex                                     ;C33B9D
	dex                                     ;C33B9E
	bpl @lbl_C33B9A                         ;C33B9F
@lbl_C33BA5:
	plp                                     ;C33BA1
	rtl                                     ;C33BA2
@lbl_C33BA7:
	lda $C33BC8,x                           ;C33BA3
	sta $00                                 ;C33BA5
	stz $01                                 ;C33BA7
	phx                                     ;C33BA9
	jsl.l DisplayMessage
	.db $FA   ;C33BB4
	.db $BF,$C9,$3B,$C3,$C9,$FF,$F0,$08,$85,$00,$64,$01
	jsl.l DisplayMessage
	plp                                     ;C33BC5
	rtl                                     ;C33BC6
	plp                                     ;C33BC7
	eor $2942,y                             ;C33BC8
	eor $2C41,y                             ;C33BCB
	eor $5683,y                             ;C33BCE
	tcd                                     ;C33BD1
	.db $90,$58   ;C33BD2
	tcd                                     ;C33BD4
	adc ($5A,x)                             ;C33BD5
	tcd                                     ;C33BD7
	sta ($5B,s),y                           ;C33BD8
	tcd                                     ;C33BDA
	sta $AE                                 ;C33BDB
	cpy #$FF                                ;C33BDD
	lda $B0FFC0                             ;C33BDF
	cpy #$FF                                ;C33BE3
	.db $10,$BA   ;C33BE5
	sbc $FFBA11,x                           ;C33BE7
	ora ($BA)                               ;C33BEB
	.db $FF   ;C33BED

; Validates custom name slot for item. On overflow, writes $FF to wItemCustomNamesBuffer.
ValidateCustomNameSlot:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	tax
	lda.l wItemHasCustomName,x
	clc
	adc.b #$14
	bcc @lbl_C33C0B
	.db $0A,$0A,$0A,$AA,$A9,$FF,$9F,$BE   ;C33C01
	.db $92,$7E                           ;C33C09  
@lbl_C33C0B:
	plp
	rtl

; Returns item data to temp registers. For blank scrolls ($68): returns mod/fuse/curse stats.
; For other items: reads wItemHasCustomName and returns custom name buffer data.
GetItemOrBlankScrollData:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	cmp.b #$68
	beq @lbl_C33C42
	tax
	lda.l wItemHasCustomName,x
	clc
	adc.b #$14
	asl a
	asl a
	asl a
	tax
	rep #$20 ;A->16
	lda.l wItemCustomNamesBuffer,x
	sta.b wTemp00
	lda.l $7E92C0,x
	sta.b wTemp02
	lda.l $7E92C2,x
	sta.b wTemp04
	lda.l $7E92C4,x
	sta.b wTemp06
	plp
	rtl
@lbl_C33C42:
	sep #$30 ;AXY->8
	lda.l wItemModification1,x
	sta.b wTemp00
	lda.l wItemModification2,x
	sta.b wTemp01
	lda.l wItemFuseAbility1,x
	sta.b wTemp02
	lda.l wItemFuseAbility2,x
	sta.b wTemp03
	lda.l wItemIsCursed,x
	sta.b wTemp04
	lda.l wItemTimesIdentified,x
	sta.b wTemp05
	lda.b #$FF
	sta.b wTemp06
	plp
	rtl

SerializeItemData:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldx.w #$07D2
	stx.b wTemp00
	ldx.w #$8B8C
	stx.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	jsl.l func_C3E2AB
	plp
	rtl

DeserializeItemData:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldx.w #$07D2
	stx.b wTemp00
	ldx.w #$8B8C
	stx.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	jsl.l func_C3E2DB
	plp
	rtl

GetItemBuySellPrice:
	php
	rep #$20 ;A->16
	lda.b wTemp00
	and.w #$00FF
	pha
	lda.b wTemp00
	xba
	and.w #$00FF
	asl a
	pha
	sep #$20 ;A->8
	jsl.l GetItemDisplayInfo
	lda.b wTemp01
	cmp.b #$E7
	bne @lbl_C33CC5
;C33CBD
	rep #$20                                ;C33CBD
	stz $00                                 ;C33CBF
	pla                                     ;C33CC1
	pla                                     ;C33CC2
	plp                                     ;C33CC3
	rtl                                     ;C33CC4
.ACCU 8
@lbl_C33CC5:
	rep #$30 ;AXY->16
	lda.b wTemp00
	and.w #$00FF
	asl a
	tax
	jmp.w (ItemBuySellPriceHandlers,x)

ItemBuySellPriceHandlers:
	.dw ItemBuySellPriceHandler_Herb
	.dw ItemBuySellPriceHandler_Scroll
	.dw ItemBuySellPriceHandler_RiceBall
	.dw ItemBuySellPriceHandler_Weapon
	.dw ItemBuySellPriceHandler_Arrow
	.dw ItemBuySellPriceHandler_Shield
	.dw ItemBuySellPriceHandler_Armband
	.dw ItemBuySellPriceHandler_Staff
	.dw ItemBuySellPriceHandler_Gitan
	.dw ItemBuySellPriceHandler_MonsterMeat
	.dw ItemBuySellPriceHandler_Misc ; GoldenFeather/HappinessBox/StrangeBox/Item_E4
	.dw ItemBuySellPriceHandler_Jar

ItemBuySellPriceHandler_Herb:
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_MedicinalHerb
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l HerbBuySellPrices,x
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Scroll:
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_BlessingScroll
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l ScrollBuySellPrices,x
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_RiceBall:
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_Onigiri
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l RiceBallBuySellPrices,x
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Weapon:
	lda.b wTemp02
	and.w #$00FF
	sta.b wTemp04
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_Cudgel
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l WeaponBuySellPrices,x
	sta.b wTemp06
	lda.b wTemp03,s
	sta.b wTemp00
	phx
	jsl.l LoadItemFuseAbilitiesAndDefaults
	plx
	lda.b wTemp01,s
	phx
	tax
	ldy.w #$0009
	lda.b wTemp06
@lbl_C33D67:
	lsr.b wTemp00
	bcc @lbl_C33D70
	clc
	adc.l WeaponFuseAbilityPriceBonus,x
@lbl_C33D70:
	inx
	inx
	inx
	inx
	dey
	bpl @lbl_C33D67
	sta.b wTemp06
	plx
	lda.b wTemp00
	bit.w #$0002
	beq @lbl_C33D83
;C33D81  
	inc.b wTemp04                            ;C33D81
@lbl_C33D83:
	lda.b wTemp04
	bne @lbl_C33D8B
	lda.b wTemp06
	bra @lbl_C33DE0
@lbl_C33D8B:
	ldy.w #$0000
	bit.w #$0080
	beq @lbl_C33D9A
;C33D93
	eor #$00FF                              ;C33D93
	inc a                                   ;C33D96
	ldy #$8000                              ;C33D97
@lbl_C33D9A:
	sta.b wTemp02
	tya
	bmi @lbl_C33DCE
	lda.b wTemp01,s
	bne @lbl_C33DB7
	lda.b wTemp06
@lbl_C33DA5:
	clc
	adc.l WeaponUpgradePriceBonus,x
	bcc @lbl_C33DB1
;C33DAC
	lda #$FDE8                              ;C33DAC
	bra @lbl_C33DE0                         ;C33DAF
@lbl_C33DB1:
	dec.b wTemp02
	bne @lbl_C33DA5
	bra @lbl_C33DE0
@lbl_C33DB7:
	lda.b wTemp06
@lbl_C33DB9:
	clc
	adc.l WeaponUpgradePriceBonus,x
	cmp.w #$7D00
	bcc @lbl_C33DC8
;C33DC3
	lda #$7D00                              ;C33DC3
	bra @lbl_C33DE0                         ;C33DC6
@lbl_C33DC8:
	dec.b wTemp02
	bne @lbl_C33DB9
	bra @lbl_C33DE0
@lbl_C33DCE:
	lda.b wTemp06                            ;C33DCE
@lbl_C33DD0:
	sec                                     ;C33DD0
	sbc.l WeaponUpgradePriceBonus,x         ;C33DD1
	bcs @lbl_C33DDC                         ;C33DD5
	lda #$0000                              ;C33DD7
	bra @lbl_C33DE0                         ;C33DDA
@lbl_C33DDC:
	dec.b wTemp02                           ;C33DDC
	bne @lbl_C33DD0                         ;C33DDE
@lbl_C33DE0:
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Arrow:
	lda.b wTemp02
	and.w #$00FF
	xba
	sta.b wTemp04
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_WoodArrow
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l ArrowBuySellPrices,x
	ora.b wTemp04
	sta.b wTemp00
	jsl.l MultiplyPackedBytesToWord
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Shield:
	lda.b wTemp02
	and.w #$00FF
	sta.b wTemp04
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_HideShield
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l ShieldBuySellPrices,x
	sta.b wTemp06
	lda.b wTemp03,s
	sta.b wTemp00
	phx
	jsl.l LoadItemFuseAbilitiesAndDefaults
	plx
	lda.b wTemp01,s
	phx
	tax
	ldy.w #$000A
	lda.b wTemp06
@lbl_C33E3E:
	lsr.b wTemp00
	bcc @lbl_C33E47
	clc
	adc.l ShieldFuseAbilityPriceBonus,x
@lbl_C33E47:
	inx
	inx
	inx
	inx
	dey
	bpl @lbl_C33E3E
	sta.b wTemp06
	plx
	lda.b wTemp00
	bit.w #$0001
	beq @lbl_C33E5A
;C33E58  
	inc $04                                 ;C33E58
@lbl_C33E5A:
	lda.b wTemp04
	bne @lbl_C33E62
	lda.b wTemp06
	bra @lbl_C33EB7
@lbl_C33E62:
	ldy.w #$0000
	bit.w #$0080
	beq @lbl_C33E71
;C33E6A
	eor #$00FF                              ;C33E6A
	inc a                                   ;C33E6D
	ldy #$8000                              ;C33E6E
@lbl_C33E71:
	sta.b wTemp02
	tya
	bmi @lbl_C33EA5
	lda.b wTemp01,s
	bne @lbl_C33E8E
	lda.b wTemp06                            ;C33E7A
@lbl_C33E7C:
	clc                                     ;C33E7C
	adc.l ShieldUpgradePriceBonus,x         ;C33E7D
	bcc @lbl_C33E88                         ;C33E81
	lda #$FDE8                              ;C33E83
	bra @lbl_C33EB7                         ;C33E86
@lbl_C33E88:
	dec.b wTemp02                           ;C33E88
	bne @lbl_C33E7C                         ;C33E8A
	bra @lbl_C33EB7                         ;C33E8C
@lbl_C33E8E:
	lda.b wTemp06
@lbl_C33E90:
	clc
	adc.l ShieldUpgradePriceBonus,x
	cmp.w #$7D00
	bcc @lbl_C33E9F
;C33E9A
	lda #$7D00                              ;C33E9A
	bra @lbl_C33EB7                         ;C33E9D
@lbl_C33E9F:
	dec.b wTemp02
	bne @lbl_C33E90
	bra @lbl_C33EB7
@lbl_C33EA5:
	lda.b wTemp06                            ;C33EA5
@lbl_C33EA7:
	sec                                     ;C33EA7
	sbc.l ShieldUpgradePriceBonus,x         ;C33EA8
	bcs @lbl_C33EB3                         ;C33EAC
	lda #$0000                              ;C33EAE
	bra @lbl_C33EB7                         ;C33EB1
@lbl_C33EB3:
	dec.b wTemp02                           ;C33EB3
	bne @lbl_C33EA7                         ;C33EB5
@lbl_C33EB7:
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Armband:
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_PassageArmband
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.l ArmbandBuySellPrices,x
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Staff:
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_SlothStaff
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.b wTemp02
	and.w #$00FF
	tay
	lda.b wTemp01,s
	bne @lbl_C33F04
	lda.l StaffBuySellPrices,x
@lbl_C33EF5:
	dey
	bmi @lbl_C33F18
	clc
	adc.l StaffUsesPriceBonus,x
	bcc @lbl_C33EF5
;C33EFF
	.db $A9,$E8,$FD,$80,$14
@lbl_C33F04:
	lda.l StaffBuySellPrices,x
@lbl_C33F08:
	dey
	bmi @lbl_C33F18
	clc
	adc.l StaffUsesPriceBonus,x
	cmp.w #$7D00
	bcc @lbl_C33F08
;C33F15
	.db $A9,$00,$7D
@lbl_C33F18:
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Gitan:
	stz $00                                 ;C33F1E
	pla                                     ;C33F20
	pla                                     ;C33F21
	plp                                     ;C33F22
	rtl                                     ;C33F23
ItemBuySellPriceHandler_MonsterMeat:
	lda.b wTemp02
	xba
	and.w #$00FF
	ldy.w #$0000
	cmp.w #$0004
	bcc @lbl_C33F3A
;C33F32
	.db $38,$E9,$03,$00,$A8,$A9,$03,$00
@lbl_C33F3A:
	dec a
	asl a
	asl a
	clc
	adc.b wTemp01,s
	sta.b wTemp06
	lda.b wTemp02
	and.w #$00FF
	dec a
	asl a
	asl a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	clc
	adc.b wTemp06
	tax
	lda.l MonsterMeatBuySellPrices,x
	dey
	bmi @lbl_C33F61
;C33F5B
	.db $18,$69,$F4,$01,$80,$F7
@lbl_C33F61:
	sta.b wTemp00
	pla
	pla
	plp
	rtl
ItemBuySellPriceHandler_Misc:
	lda $D9A890                             ;C33F67
	sta $00                                 ;C33F6B
	pla                                     ;C33F6D
	pla                                     ;C33F6E
	plp                                     ;C33F6F
	rtl                                     ;C33F70
ItemBuySellPriceHandler_Jar:
	lda.b wTemp00
	xba
	and.w #$00FF
	sec
	sbc.w #Item_HoldingJar
	asl a
	asl a
	clc
	adc.b wTemp01,s
	tax
	lda.b wTemp02
	and.w #$00FF
	tay
	lda.b wTemp01,s
	bne @lbl_C33F9E
	lda.l JarBuySellPrices,x
@lbl_C33F8F:
	dey
	bmi @lbl_C33FB2
	clc
	adc.l JarSizeUpgradePriceBonus,x
	bcc @lbl_C33F8F
;C33F99
	.db $A9,$E8,$FD,$80,$14
@lbl_C33F9E:
	lda.l JarBuySellPrices,x
@lbl_C33FA2:
	dey
	bmi @lbl_C33FB2
	clc
	adc.l JarSizeUpgradePriceBonus,x
	cmp.w #$7D00
	bcc @lbl_C33FA2
;C33FAF
	.db $A9,$00,$7D
@lbl_C33FB2:
	sta.b wTemp00
	pla
	pla
	plp
	rtl
; TODO: purpose unclear - scans unlabeled 262-byte table at $C34E00 backwards for a matching
; item type and accumulates range-tier flags into $00. No external callers found.
	php                                     ;C33FB8
	sep #$20                                ;C33FB9
	rep #$10                                ;C33FBB
	lda $00                                 ;C33FBD
	stz $00                                 ;C33FBF
	ldx #$0105                              ;C33FC1
@lbl_C33FC4:
	cmp $C34E00,x                           ;C33FC4
	beq @lbl_C33FCF                         ;C33FC8
@lbl_C33FCA:
	dex                                     ;C33FCA
	bpl @lbl_C33FC4                         ;C33FCB
	plp                                     ;C33FCD
	rtl                                     ;C33FCE
@lbl_C33FCF:
	cpx #$00FE                              ;C33FCF
	bcc @lbl_C33FDE                         ;C33FD2
	pha                                     ;C33FD4
	lda $00                                 ;C33FD5
	ora #$04                                ;C33FD7
	sta $00                                 ;C33FD9
	pla                                     ;C33FDB
	bra @lbl_C33FCA                         ;C33FDC
@lbl_C33FDE:
	cpx #$0048                              ;C33FDE
	bcc @lbl_C33FED                         ;C33FE1
	pha                                     ;C33FE3
	lda $00                                 ;C33FE4
	ora #$02                                ;C33FE6
	sta $00                                 ;C33FE8
	pla                                     ;C33FEA
	bra @lbl_C33FCA                         ;C33FEB
@lbl_C33FED:
	pha                                     ;C33FED
	lda $00                                 ;C33FEE
	ora #$01                                ;C33FF0
	sta $00                                 ;C33FF2
	pla                                     ;C33FF4
	bra @lbl_C33FCA                         ;C33FF5
ApplyBlessingScrollEffect:
	php                                     ;C33FF7
	sep #$20                                ;C33FF8
	lda #$7E                                ;C33FFA
	pha                                     ;C33FFC
	plb                                     ;C33FFD
	jsr $1C70                               ;C33FFE
	plp                                     ;C34001
	rtl                                     ;C34002
SaveAndClearItemCurseState:
	php                                     ;C34003
	sep #$30                                ;C34004
	ldx $00                                 ;C34006
	lda $7E8C0C,x                           ;C34008
	sta $00                                 ;C3400C
	lda #$00                                ;C3400E
	sta $7E8C0C,x                           ;C34010
	plp                                     ;C34014
	rtl                                     ;C34015
TryCurseEquippableItem:
	php                                     ;C34016
	ldx $00                                 ;C34017
	lda $7E8B8C,x                           ;C34019
	tax                                     ;C3401D
	lda $C341BB,x                           ;C3401E
	cmp #$03                                ;C34022
	beq @lbl_C3402E                         ;C34024
	cmp #$05                                ;C34026
	beq @lbl_C3402E                         ;C34028
	cmp #$06                                ;C3402A
	bne @lbl_C3403E                         ;C3402C
@lbl_C3402E:
	ldx $00                                 ;C3402E
	lda $7E8C0C,x                           ;C34030
	sta $00                                 ;C34034
	lda #$01                                ;C34036
	sta $7E8C0C,x                           ;C34038
	plp                                     ;C3403C
	rtl                                     ;C3403D
@lbl_C3403E:
	lda #$01                                ;C3403E
	sta $00                                 ;C34040
	plp                                     ;C34042
	rtl                                     ;C34043
.ACCU 16
.INDEX 16

ConsumeBlastShieldDurability:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemFuseAbility2,x
	bit.b #$02
	bne @lbl_C34057
;C34051
	lda #$01                                ;C34051
	sta $00                                 ;C34053
	plp                                     ;C34055
	rtl                                     ;C34056
@lbl_C34057:
	lda.l wItemModification2,x
	bne @lbl_C3406D
	lda.b #$14
	sta.b wTemp00
	lda.b #$28
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
@lbl_C3406D:
	dec a
	sta.l wItemModification2,x
	bne @lbl_C34078
;C34074  
	.db $9F,$0C,$8C,$7E
@lbl_C34078:
	sta.b wTemp00
	plp
	rtl

RepairOrphanedPotItems:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b #$00
	lda.b #$00
@lbl_C34087:
	sta.w $935F,y
	iny
	bne @lbl_C34087
	ldx.b #$1D
@lbl_C3408F:
	lda.l wShirenStatus.itemAmounts,x
	tay
	lda.w $935F,y
	inc a
	sta.w $935F,y
	dex
	bpl @lbl_C3408F
	ldx.b #$7E
@lbl_C340A0:
	lda.w wItemType,x
	cmp.b #$FF
	beq @lbl_C340B2
	lda.w wItemPotNextItem,x
	tay
	lda.w $935F,y
	inc a
	sta.w $935F,y
@lbl_C340B2:
	dex
	bpl @lbl_C340A0
	ldy.b #$7E
@lbl_C340B7:
	lda.w $935F,y
	cmp.b #$02
	bcc @lbl_C340C3
;C340BE  
	jsr $40FA                               ;C340BE
	.db $80,$19   ;C340C1
@lbl_C340C3:
	dec a
	beq @lbl_C340D2
	lda.w wItemType,y
	cmp.b #$FF
	beq @lbl_C340D0
;C340CD  
	jsr $4101                               ;C340CD
@lbl_C340D0:
	bra @lbl_C340DC
@lbl_C340D2:
	lda.w wItemType,y
	cmp.b #$FF
	bne @lbl_C340DC
;C340D9  
	jsr $410D                               ;C340D9
@lbl_C340DC:
	dey
	bpl @lbl_C340B7
	ldy.b #$80
@lbl_C340E1:
	lda.w $935F,y
	beq @lbl_C340E9
;C340E6  
	jsr $40FA                               ;C340E6
@lbl_C340E9:
	iny
	cpy.b #$FF
	bne @lbl_C340E1
	stz.b wTemp00
	plp
	rtl
;C340F2
@lbl_C340F2:
	pla                                     ;C340F2
	pla                                     ;C340F3
	lda #$01                                ;C340F4
	sta $00                                 ;C340F6
	plp                                     ;C340F8
	rtl                                     ;C340F9
	lda $808000                             ;C340FA
	beq @lbl_C340F2                         ;C340FE
	rts                                     ;C34100
	lda $808000                             ;C34101
	beq @lbl_C340F2                         ;C34105
	lda #$FF                                ;C34107
	sta $8B8C,y                             ;C34109
	rts                                     ;C3410C
	lda $808000                             ;C3410D
	beq @lbl_C340F2                         ;C34111
	lda #$40                                ;C34113
	sta $8B8C,y                             ;C34115
	lda #$00                                ;C34118
	sta $8D8C,y                             ;C3411A
	lda #$FF                                ;C3411D
	sta $8E0C,y                             ;C3411F
	rts                                     ;C34122
	php                                     ;C34123
	sep #$30                                ;C34124
	ldy #$00                                ;C34126
@lbl_C34128:
	sty $00                                 ;C34128
	phy                                     ;C3412A
	jsl $C23B7C                             ;C3412B
	ply                                     ;C3412F
	ldx $00                                 ;C34130
	bmi @lbl_C34151                         ;C34132
	phx                                     ;C34134
	phy                                     ;C34135
	jsl $C30710                             ;C34136
	ply                                     ;C3413A
	plx                                     ;C3413B
	lda $00                                 ;C3413C
	cmp #$02                                ;C3413E
	bne @lbl_C3414E                         ;C34140
	lda $01                                 ;C34142
	cmp #$B0                                ;C34144
	beq @lbl_C3414E                         ;C34146
	lda #$B0                                ;C34148
	sta $7E8B8C,x                           ;C3414A
@lbl_C3414E:
	iny                                     ;C3414E
	bra @lbl_C34128                         ;C3414F
@lbl_C34151:
	plp                                     ;C34151
	rtl                                     ;C34152
	php                                     ;C34153
	sep #$30                                ;C34154
	lda #$7E                                ;C34156
	pha                                     ;C34158
	plb                                     ;C34159
	jsl $C23B89                             ;C3415A
	lda $03                                 ;C3415E
	pha                                     ;C34160
	lda $02                                 ;C34161
	pha                                     ;C34163
	lda $01                                 ;C34164
	pha                                     ;C34166
	ldx $00                                 ;C34167
	bmi @lbl_C3417E                         ;C34169
	lda $8C0C,x                             ;C3416B
	pha                                     ;C3416E
	stz $8C0C,x                             ;C3416F
	phx                                     ;C34172
	phb                                     ;C34173
	jsl $C23C02                             ;C34174
	plb                                     ;C34178
	plx                                     ;C34179
	pla                                     ;C3417A
	sta $8C0C,x                             ;C3417B
@lbl_C3417E:
	pla                                     ;C3417E
	bmi @lbl_C34197                         ;C3417F
	tax                                     ;C34181
	lda $8C0C,x                             ;C34182
	pha                                     ;C34185
	stz $8C0C,x                             ;C34186
	stx $00                                 ;C34189
	phx                                     ;C3418B
	phb                                     ;C3418C
	jsl $C23C10                             ;C3418D
	plb                                     ;C34191
	plx                                     ;C34192
	pla                                     ;C34193
	sta $8C0C,x                             ;C34194
@lbl_C34197:
	pla                                     ;C34197
	bmi @lbl_C341B0                         ;C34198
	tax                                     ;C3419A
	lda $8C0C,x                             ;C3419B
	pha                                     ;C3419E
	stz $8C0C,x                             ;C3419F
	stx $00                                 ;C341A2
	phx                                     ;C341A4
	phb                                     ;C341A5
	jsl $C23C09                             ;C341A6
	plb                                     ;C341AA
	plx                                     ;C341AB
	pla                                     ;C341AC
	sta $8C0C,x                             ;C341AD
@lbl_C341B0:
	pla                                     ;C341B0
	bmi @lbl_C341B9                         ;C341B1
	sta $00                                 ;C341B3
	jsl $C23BE1                             ;C341B5
@lbl_C341B9:
	plp                                     ;C341B9
	rtl                                     ;C341BA


DATA8_C341BB:
	.db $03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03
	.db $04,$04,$04,$04,$04,$04
	.db $05,$05,$05,$05,$05
	.db $05,$05,$05
	.db $05
	.db $05,$05,$05,$05
	.db $05,$05
	.db $05,$05,$05
	.db $00,$00
	.db $00
	.db $00,$00
	.db $00,$00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00
	.db $00,$00
	.db $00,$00,$00
	.db $00
	.db $00,$00,$00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00
	.db $01,$01,$01
	.db $01,$01,$01,$01,$01
	.db $01
	.db $01
	.db $01
	.db $01,$01,$01,$01,$01
	.db $01
	.db $01
	.db $01
	.db $01
	.db $01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01
	.db $07
	.db $07
	.db $07
	.db $07,$07,$07,$07,$07,$07
	.db $07
	.db $07
	.db $07,$07,$07,$07,$07,$07,$07,$07
	.db $07,$07,$07,$07,$06,$06,$06,$06
	.db $06
	.db $06
	.db $06,$06,$06,$06,$06,$06
	.db $06,$06
	.db $06,$06,$06,$06,$06,$06,$06,$06
	.db $06,$06,$06,$06,$06
	.db $02,$02
	.db $02,$02,$02,$02
	.db $0B,$0B
	.db $0B,$0B
	.db $0B,$0B,$0B
	.db $0B,$0B,$0B,$0B
	.db $0B
	.db $0B
	.db $0B,$0B
	.db $0B,$0B,$0B,$0D,$0D,$0D,$0D,$0D
	.db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
	.db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
	.db $0D,$0D,$0D,$0D,$0D
	.db $09
	.db $0A,$0A,$0A,$0A
	.db $08
	.db $00,$00

DATA8_C342A3:
	.db $02,$04
	.db $05
	.db $06
	.db $07
	.db $08
	.db $0C,$04
	.db $01
	.db $02,$04
	.db $03
	.db $05,$05,$1E,$32
	.db $00
	.db $00,$00,$00,$00,$00
	.db $02,$04
	.db $00,$03
	.db $07
	.db $07,$0C,$05
	.db $0A
	.db $05,$05,$03,$1E
	.db $03,$03
	.db $1E,$00,$00
	.db $00,$00
	.db $00
	.db $00,$00
	.db $00,$00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00
	.db $00,$00,$00
	.db $00
	.db $00,$00,$00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00
	.db $00,$00,$00
	.db $00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00
	.db $00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00
	.db $00,$00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00,$00,$00,$00,$00,$00
	.db $00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00
	.db $00,$00
	.db $00,$00,$00,$00
	.db $00,$00
	.db $00,$00
	.db $00,$00
	.db $00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00
	.db $00
	.db $00,$00,$00,$00
	.db $00
	.db $00,$00

DATA8_C3438B:
	.db $80,$90
	.db $90
	.db $90
	.db $90
	.db $90
	.db $90,$90,$80,$90,$90
	.db $90
	.db $00,$00,$00,$00
	.db $0A
	.db $05,$05,$00,$00,$00
	.db $90,$90
	.db $90,$90
	.db $90
	.db $90,$90,$90
	.db $90
	.db $90,$90,$90,$90,$90
	.db $90
	.db $90,$90,$90
	.db $00,$00
	.db $00
	.db $00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00
	.db $00,$00
	.db $00,$00,$00
	.db $00
	.db $00,$00,$00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00
	.db $00,$00
	.db $00,$00,$00,$00,$00
	.db $00
	.db $00,$00,$00,$00,$00,$00,$00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $05
	.db $05
	.db $05
	.db $05
	.db $05
	.db $05
	.db $05,$05
	.db $05
	.db $05
	.db $05
	.db $05,$05,$05,$05,$05,$05,$05,$05
	.db $05,$05,$05,$05,$A0,$A0,$A0,$A0
	.db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.db $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.db $A0,$A0,$A0,$A0,$A0,$A0,$A0
	.db $00,$00
	.db $00,$00,$00,$00
	.db $03
	.db $03,$03,$03
	.db $03
	.db $03
	.db $03
	.db $03,$03,$03,$03,$03,$03
	.db $03
	.db $03,$03,$03,$03,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$01,$00,$00

DATA8_C34473:
	.db $8F,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$8F,$9F,$9F,$9F,$00,$00,$00,$00
	.db $14,$0F,$0A,$00,$00,$00,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
	.db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$08,$07,$07,$07
	.db $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
	.db $07,$07,$07,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF
	.db $AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$AF,$00,$00
	.db $00,$00,$00,$00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
	.db $06,$06,$06,$06,$06,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$FF,$00,$00

;c3455b
ItemUseEffectFunctionTable:
	.dw WeaponUseEffect-1 ;Cudgel
	.dw WeaponUseEffect-1 ;Nagamaki
	.dw WeaponUseEffect-1 ;BufusCleaver
	.dw WeaponUseEffect-1 ;Katana
	.dw WeaponUseEffect-1 ;Dragonkiller
	.dw WeaponUseEffect-1 ;Mastersword
	.dw WeaponUseEffect-1 ;KabrasBlade
	.dw WeaponUseEffect-1 ;SickleSlayer
	.dw WeaponUseEffect-1 ;Pickaxe
	.dw WeaponUseEffect-1 ;HomingBlade
	.dw WeaponUseEffect-1 ;MinotaursAxe
	.dw WeaponUseEffect-1 ;RazorWind
	.dw WeaponUseEffect-1 ;CyclopsKiller
	.dw WeaponUseEffect-1 ;DrainBuster
	.dw WeaponUseEffect-1 ;Firebrand
	.dw WeaponUseEffect-1 ;KabraReborn
	.dw ItemUseNoEffect-1 ;WoodArrow
	.dw ItemUseNoEffect-1 ;IronArrow
	.dw ItemUseNoEffect-1 ;SilverArrow
	.dw UnusedItemUseEffect-1 ;13
	.dw UnusedItemUseEffect-1 ;14
	.dw UnusedItemUseEffect-1 ;15
	.dw ShieldUseEffect-1 ;HideShield
	.dw ShieldUseEffect-1 ;Bronzeward
	.dw ShieldUseEffect-1 ;AntiPoisonShield
	.dw ShieldUseEffect-1 ;WoodShield
	.dw ShieldUseEffect-1 ;IronShield
	.dw ShieldUseEffect-1 ;Dragonward
	.dw ShieldUseEffect-1 ;Windshield
	.dw ShieldUseEffect-1 ;SpikedWard
	.dw ShieldUseEffect-1 ;ArmorWard
	.dw ShieldUseEffect-1 ;EchoShield
	.dw ShieldUseEffect-1 ;EvasiveShield
	.dw ShieldUseEffect-1 ;FancyShield
	.dw ShieldUseEffect-1 ;FragileShield
	.dw ShieldUseEffect-1 ;BlastShield
	.dw ShieldUseEffect-1 ;WalrusShield
	.dw ShieldUseEffect-1 ;Stormward
	.dw ShieldUseEffect-1 ;26
	.dw ShieldUseEffect-1 ;27
	.dw MedicinalHerbUseEffect-1 ;MedicinalHerb
	.dw RestorativeHerbUseEffect-1 ;RestorativeHerb
	.dw HappinessHerbUseEffect-1 ;HappinessHerb
	.dw SightHerbUseEffect-1 ;SightHerb
	.dw DragonHerbUseEffect-1 ;DragonHerb
	.dw VictoryHerbUseEffect-1 ;VictoryHerb
	.dw AngelSeedUseEffect-1 ;AngelSeed
	.dw $09F0 ;RevivalHerb
	.dw InvisibilityHerbUseEffect-1 ;InvisibilityHerb
	.dw BitterHerbUseEffect-1 ;BitterHerb
	.dw MisfortuneHerbUseEffect-1 ;MisfortuneHerb
	.dw IllLuckHerbUseEffect-1 ;IllLuckHerb
	.dw KignyHerbUseEffect ;KignyHerb
	.dw AmnesiaHerbUseEffect-1 ;AmnesiaHerb
	.dw $0A94 ;36
	.dw LifeHerbUseEffect-1 ;LifeHerb
	.dw BigBellySeedUseEffect-1 ;BigBellySeed
	.dw LittleBellySeedUseEffect-1 ;LittleBellySeed
	.dw TalkSeedUseEffect-1 ;TalkSeed
	.dw StrengthHerbUseEffect-1 ;StrengthHerb
	.dw AntidoteHerbUseEffect-1 ;AntidoteHerb
	.dw PoisonHerbUseEffect-1 ;PoisonHerb
	.dw ConfusionHerbUseEffect-1 ;ConfusionHerb
	.dw SleepHerbUseEffect-1 ;SleepHerb
	.dw $09F0 ;Weeds
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw BlessingScrollUseEffect-1 ;BlessingScroll
	.dw IdentityScrollUseEffect-1 ;IdentityScroll
	.dw LightScrollUseEffect-1 ;LightScroll
	.dw BigpotScrollUseEffect-1 ;BigpotScroll
	.dw BlastwaveScrollUseEffect-1 ;BlastwaveScroll
	.dw SilenceScrollUseEffect-1 ;SilenceScroll
	.dw $1A7A ;5C
	.dw TrapScrollUseEffect-1 ;TrapScroll
	.dw NeedScrollUseEffect-1 ;NeedScroll
	.dw HasteScrollUseEffect-1 ;HasteScroll
	.dw SleepScrollUseEffect-1 ;SleepScroll
	.dw PowerupScrollUseEffect-1 ;PowerupScroll
	.dw $18B8 ;62
	.dw ExplosionScrollUseEffect-1 ;ExplosionScroll
	.dw GreatHallScrollUseEffect-1 ;GreatHallScroll
	.dw MonsterHouseScrollUseEffect-1 ;MonsterHouseScroll
	.dw ConfusionScrollUseEffect-1 ;ConfusionScroll
	.dw RemovalScrollUseEffect-1 ;RemovalScroll
	.dw BlankScrollUseEffect-1 ;BlankScroll
	.dw WanderingScrollUseEffect-1 ;WanderingScroll
	.dw AirBlessScrollUseEffect-1 ;AirBlessScroll
	.dw EarthBlessScrollUseEffect-1 ;EarthBlessScroll
	.dw PlatingScrollUseEffect-1 ;PlatingScroll
	.dw ExtractionScrollUseEffect-1 ;ExtractionScroll
	.dw HandsFullScrollUseEffect-1 ;HandsFullScroll
	.dw UnusedItemUseEffect-1 ;6F
	.dw $1862 ;70
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw SlothStaffUseEffect-1 ;SlothStaff
	.dw KnockbackStaffUseEffect-1 ;KnockbackStaff
	.dw HappinessStaffUseEffect-1 ;HappinessStaff
	.dw MisfortuneStaffUseEffect-1 ;MisfortuneStaff
	.dw DoppelgangerStaffUseEffect-1 ;DoppelgangerStaff
	.dw SwitchingStaffUseEffect-1 ;SwitchingStaff
	.dw BufusStaffUseEffect-1 ;BufusStaff
	.dw SkullStaffUseEffect-1 ;SkullStaff
	.dw ParalysisStaffUseEffect-1 ;ParalysisStaff
	.dw PostponeStaffUseEffect-1 ;PostponeStaff
	.dw PainSplitStaffUseEffect-1 ;PainSplitStaff
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw $1D3E ;PassageArmband
	.dw $1DC8 ;DiscountArmband
	.dw $1D1C ;TrapArmband
	.dw $1D2D ;Levelholder
	.dw $1D90 ;RecoveryArmband
	.dw $1DC8 ;RustlessArmband
	.dw $1D97 ;CriticalArmband
	.dw $1D9E ;RegretArmband
	.dw $1DC8 ;BlessingArmband
	.dw $1DAC ;PitchersArmband
	.dw $1D89 ;HappyArmband
	.dw $1DB3 ;LossArmband
	.dw $1D82 ;SightArmband
	.dw $1DBA ;CalmArmband
	.dw $1DC1 ;IdentityArmband
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw OnigiriUseEffect-1 ;Onigiri
	.dw $15AD ;BigOnigiri
	.dw SpoiledOnigiriUseEffect-1 ;SpoiledOnigiri
	.dw $1579 ;HugeOnigiri
	.dw SpecialOnigiriUseEffect-1 ;SpecialOnigiri
	.dw UnusedItemUseEffect-1 ;B3
	.dw JarUseEffect-1 ;HoldingJar
	.dw HidingJarUseEffect-1 ;HidingJar
	.dw JarUseEffect-1 ;DivisionJar
	.dw JarUseEffect-1 ;StrengtheningJar
	.dw JarUseEffect-1 ;IdentityJar
	.dw $28C3 ;ChiropracticJar
	.dw JarUseEffect-1 ;StorehouseJar
	.dw JarUseEffect-1 ;WeakeningJar
	.dw JarUseEffect-1 ;BC
	.dw JarUseEffect-1 ;BottomlessJar
	.dw MonsterJarUseEffect-1 ;MonsterJar
	.dw JarUseEffect-1 ;ChangeJar
	.dw JarUseEffect-1 ;MeldingJar
	.dw WalrusJarUseEffect-1 ;WalrusJar
	.dw JarUseEffect-1 ;GaibarasJar
	.dw JarUseEffect-1 ;PointlessJar
	.dw JarUseEffect-1 ;UnbreakableJar
	.dw JarUseEffect-1 ;VentingJar
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw UnusedItemUseEffect-1
	.dw MonsterMeatUseEffect-1 ;MonsterMeat
	.dw ItemUseNoEffect-1 ;GoldenFeather
	.dw ItemUseNoEffect-1 ;HappinessBox
	.dw ItemUseNoEffect-1 ;StrangeBox
	.dw ItemUseNoEffect-1 ;E4
	.dw ItemUseNoEffect-1 ;Gitan
	.dw UnusedItemUseEffect-1 ;Null
	.dw UnusedItemUseEffect-1 ;Nduba

;c3472b
ItemThrowEffectFunctionTable:
	.dw $364E ;Cudgel
	.dw $364E ;Nagamaki
	.dw $364E ;BufusCleaver
	.dw $364E ;Katana
	.dw $364E ;Dragonkiller
	.dw $364E ;Mastersword
	.dw $364E ;KabrasBlade
	.dw $364E ;SickleSlayer
	.dw $364E ;Pickaxe
	.dw $364E ;HomingBlade
	.dw $364E ;MinotaursAxe
	.dw $364E ;RazorWind
	.dw $364E ;CyclopsKiller
	.dw $364E ;DrainBuster
	.dw $364E ;Firebrand
	.dw $364E ;KabraReborn
	.dw $3697 ;WoodArrow
	.dw $36C1 ;IronArrow
	.dw $36C7 ;SilverArrow
	.dw $3877 ;13
	.dw $3877 ;14
	.dw $3877 ;15
	.dw $3667 ;HideShield
	.dw $3667 ;Bronzeward
	.dw $3667 ;AntiPoisonShield
	.dw $3667 ;WoodShield
	.dw $3667 ;IronShield
	.dw $3667 ;Dragonward
	.dw $3667 ;Windshield
	.dw $3667 ;SpikedWard
	.dw $3667 ;ArmorWard
	.dw $3667 ;EchoShield
	.dw $3667 ;EvasiveShield
	.dw $3667 ;FancyShield
	.dw $3667 ;FragileShield
	.dw $3667 ;BlastShield
	.dw $3667 ;WalrusShield
	.dw $3667 ;Stormward
	.dw $3667 ;26
	.dw $3667 ;27
	.dw MedicinalHerbThrowEffect-1 ;MedicinalHerb
	.dw RestorativeHerbThrowEffect-1 ;RestorativeHerb
	.dw HappinessHerbThrowEffect-1 ;HappinessHerb
	.dw $399B ;SightHerb
	.dw DragonHerbThrowEffect-1 ;DragonHerb
	.dw $3877 ;VictoryHerb
	.dw $10CF ;AngelSeed
	.dw $3877 ;RevivalHerb
	.dw InvisibilityHerbThrowEffect-1 ;InvisibilityHerb
	.dw BitterHerbThrowEffect-1 ;BitterHerb
	.dw MisfortuneHerbThrowEffect-1 ;MisfortuneHerb
	.dw IllLuckHerbThrowEffect-1 ;IllLuckHerb
	.dw $0A19 ;KignyHerb
	.dw $3877 ;AmnesiaHerb
	.dw $3877 ;36
	.dw $11B6 ;LifeHerb
	.dw $3877 ;BigBellySeed
	.dw $3877 ;LittleBellySeed
	.dw $3877 ;TalkSeed
	.dw $3877 ;StrengthHerb
	.dw AntidoteHerbThrowEffect-1 ;AntidoteHerb
	.dw $1309 ;PoisonHerb
	.dw $1366 ;ConfusionHerb
	.dw $13C3 ;SleepHerb
	.dw $37F0 ;Weeds
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3725 ;BlessingScroll
	.dw $37A1 ;IdentityScroll
	.dw $3877 ;LightScroll
	.dw $3877 ;BigpotScroll
	.dw $3877 ;BlastwaveScroll
	.dw $3877 ;SilenceScroll
	.dw $3877 ;5C
	.dw $3877 ;TrapScroll
	.dw $3877 ;NeedScroll
	.dw $3877 ;HasteScroll
	.dw $3877 ;SleepScroll
	.dw $3877 ;PowerupScroll
	.dw $3877 ;62
	.dw $3877 ;ExplosionScroll
	.dw $3877 ;GreatHallScroll
	.dw $3877 ;MonsterHouseScroll
	.dw $3877 ;ConfusionScroll
	.dw $395A ;RemovalScroll
	.dw BlankScrollThrowEffect-1 ;BlankScroll
	.dw $3877 ;WanderingScroll
	.dw $3877 ;AirBlessScroll
	.dw $3877 ;EarthBlessScroll
	.dw $3877 ;PlatingScroll
	.dw $3877 ;ExtractionScroll
	.dw $3877 ;HandsFullScroll
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $203D ;SlothStaff
	.dw $1E0B ;KnockbackStaff
	.dw $1F58 ;HappinessStaff
	.dw $1F98 ;MisfortuneStaff
	.dw $1E10 ;DoppelgangerStaff
	.dw $1E1B ;SwitchingStaff
	.dw $1E5D ;BufusStaff
	.dw $1EC2 ;SkullStaff
	.dw $2047 ;ParalysisStaff
	.dw $206E ;PostponeStaff
	.dw $20AF ;PainSplitStaff
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3940 ;PassageArmband
	.dw $3940 ;DiscountArmband
	.dw $3940 ;TrapArmband
	.dw $3940 ;Levelholder
	.dw $3940 ;RecoveryArmband
	.dw $3940 ;RustlessArmband
	.dw $3940 ;CriticalArmband
	.dw $3940 ;RegretArmband
	.dw $3940 ;BlessingArmband
	.dw $3940 ;PitchersArmband
	.dw $3940 ;HappyArmband
	.dw $3940 ;LossArmband
	.dw $3940 ;SightArmband
	.dw $3940 ;CalmArmband
	.dw $3940 ;IdentityArmband
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3891 ;Onigiri
	.dw $3891 ;BigOnigiri
	.dw $3891 ;SpoiledOnigiri
	.dw $3891 ;HugeOnigiri
	.dw $3891 ;SpecialOnigiri
	.dw $3877 ;B3
	.dw $36F2 ;HoldingJar
	.dw $36CD ;HidingJar
	.dw $36F2 ;DivisionJar
	.dw $36F2 ;StrengtheningJar
	.dw $377B ;IdentityJar
	.dw $36F2 ;ChiropracticJar
	.dw $36F2 ;StorehouseJar
	.dw $36F2 ;WeakeningJar
	.dw $36F2 ;BC
	.dw $36F2 ;BottomlessJar
	.dw $36F2 ;MonsterJar
	.dw $36F2 ;ChangeJar
	.dw $36F2 ;MeldingJar
	.dw $36F2 ;WalrusJar
	.dw $36F2 ;GaibarasJar
	.dw $36F2 ;PointlessJar
	.dw $3716 ;UnbreakableJar
	.dw $36F2 ;VentingJar
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3877
	.dw $3913 ;MonsterMeat
	.dw $3940 ;GoldenFeather
	.dw $3940 ;HappinessBox
	.dw $3940 ;StrangeBox
	.dw $3940
	.dw $38DB ;Gitan
	.dw $3877 ;Null
	.dw $3877 ;Nduba

.include "data/dungeon_item_spawn_tables.asm"

InitFloorTileArrays:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	rep #$30 ;AXY->16
	lda.w #$8080
	ldx.w #$0A7E
@lbl_C353C2:
	sta.w $945F,x
	sta.w $9EDF,x
	sta.w $A95F,x
	sta.w $B3DF,x
	dex
	dex
	bpl @lbl_C353C2
	plp
	rtl

ResetFloorData:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	ldy.w #$0A7F
@lbl_C353E0:
	lda.b #$80
	sta.w $945F,y
	sta.w $B3DF,y
	lda.w $9EDF,y
	bmi @lbl_C353F5
	sta.b wTemp00
	phy
	jsl.l FreeFloorItemSlot
	ply
@lbl_C353F5:
	lda.b #$80
	sta.w $9EDF,y
	lda.b #$E0
	sta.w $A95F,y
	dey
	bpl @lbl_C353E0
	stz.w $BE5F
	stz.w $BE60
	stz.w $BE61
	lda.b #$00
	ldy.w #$0009
@lbl_C35410:
	sta.w $C13E,y
	sta.w $C148,y
	sta.w $C152,y
	sta.w $C15C,y
	sta.w $C134,y
	dey
	bpl @lbl_C35410
	lda.b #$FF
	ldy.w #$004F
@lbl_C35427:
	sta.w $C094,y
	sta.w $C0E4,y
	dey
	bpl @lbl_C35427
	lda.b #$00
	ldy.w #$0009
@lbl_C35435:
	sta.w $C166,y
	dey
	bpl @lbl_C35435
	stz.w $C176
	stz.w $C178
	lda.b #$FF
	sta.w $C172
	sta.w $C173
	sta.w $C175
	plp
	rtl

func_C3544E:
	php
	sep #$30 ;AXY->8
	jsl.l DetermineNextFloor
	jsr.w func_C35561
	asl a
	tax
	jumptablecall Jumptable_C3546C
	lda.b #$FF
	sta.l $7EBE64
	jsl.l func_C150D7
	plp
	rtl

Jumptable_C3546C:
	.dw $579B
	.dw $5808
	.dw $584A
	.dw $584B
	.dw $5896
	.dw $58AA
	.dw $58EA
	.dw $58BE
	.dw $590E
	.dw $592E
	.dw $5944
	.dw $595A
	.dw $596D
	.dw $5980

DetermineNextFloor:
	php
	sep #$30 ;AXY->8
	jsl.l Get7ED5EC
	lda.b wTemp00
	bpl @lbl_C3549C
	sec                                     ;C35493
	sbc #$7F                                ;C35494
	sta $7EC195                             ;C35496
	plp                                     ;C3549A
	rtl                                     ;C3549B
@lbl_C3549C:
	pha
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bne @lbl_C354DC
	lda.b wTemp01,s
	ldx.b #$00
	cmp.b #$02
	beq @lbl_C354E3
	inx
	cmp.b #$03
	beq @lbl_C354E3
	inx
	cmp.b #$04
	beq @lbl_C354E3
	inx
	cmp.b #$05
	beq @lbl_C354E3
	inx
	cmp.b #$07
	beq @lbl_C354E3
	inx
	cmp.b #$08
	beq @lbl_C354E3
	inx
	cmp.b #$0D
	beq @lbl_C354E3
	inx
	cmp.b #$0E
	beq @lbl_C354E3
	inx
	cmp.b #$23
	beq @lbl_C354E3
	inx
	cmp.b #$10
	beq @lbl_C354E3
@lbl_C354DC:
	pla
	sta.l wMapNum
	plp
	rtl
@lbl_C354E3:
	lda.l DATA8_C35556,x
	sta.b wTemp00
	lda.l DATA8_C35557,x
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	ldx.b wTemp00
	lda.l DATA8_C35501,x
	sta.l wMapNum
	pla
	plp
	rtl

DATA8_C35501:
	.db $02                               ;C35501
	.db $16,$17,$18,$19,$52,$53           ;C35502  
	.db $54                               ;C35508
	.db $55,$56,$03,$57,$58,$59,$5A       ;C35509  
	.db $5B                               ;C35510
	.db $5C,$5D,$5E,$5F                   ;C35511  
	.db $04                               ;C35515
	.db $1A,$1B,$1C,$1D,$1E,$45,$46,$47   ;C35516
	.db $48,$05,$49                       ;C3551E
	.db $4A                               ;C35521
	.db $4B,$4C,$4D,$4E,$4F,$50,$51,$07   ;C35522
	.db $1F,$20,$21                       ;C3552A  
	.db $22                               ;C3552D
	.db $33,$34,$35,$36,$37,$08,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$40,$0D   ;C3552E  
	.db $60,$61,$62,$63,$64,$65,$66,$67,$68,$0E,$24,$25,$26,$27,$23,$41   ;C3553E
	.db $42,$43,$44,$10,$28,$29,$2A,$2B   ;C3554E

DATA8_C35556:
	.db $00                               ;C35556

DATA8_C35557:
	.db $0A,$14,$1E,$28,$32               ;C35557
	.db $3C,$46,$4B,$50,$55               ;C3555C  

func_C35561:
	jsr.w func_C3575D
	tya
	asl a
	tax
	lda.l UNREACH_C355BD,x
	sta.b w00a9
	lda.l UNREACH_C355BD+1,x
	sta.b w00aa
	restorebank
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bcc @lbl_C35583
	ldy.b #$80
	bra @lbl_C35594
@lbl_C35583:
	cmp.b #$08
	bne @lbl_C3558B
	ldy.b #$81
	bra @lbl_C35594
@lbl_C3558B:
	jsl.l Random
	lda.b wTemp00
	and.b #$7F
	tay
@lbl_C35594:
	lda.b ($A9),y
	ldx.b wTemp06
	cpx.b #$01
	beq @lbl_C355A6
	cmp.b #$09
	beq @lbl_C3558B
	cmp.b #$0A
	beq @lbl_C3558B
	bra @lbl_C355B8
@lbl_C355A6:
	ldx.b wTemp04
	cpx.b #$01
	beq @lbl_C355B8
	.db $C9,$04,$F0,$DB,$C9,$05,$F0,$D7   ;C355AC
	.db $C9,$07,$F0,$D3                   ;C355B4
@lbl_C355B8:
	sta.l $7EC179
	rts

UNREACH_C355BD:
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c35659
	.dw Data_c356db
	.dw Data_c35659
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c355d7
	.dw Data_c355d7
	
Data_c355d7:
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $07,$07,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $09,$09,$03,$03,$03,$03,$03,$03,$0A,$0A,$03,$03,$03,$03,$03,$03
	.db $0B,$0B,$03,$03,$03,$03,$03,$03,$0C,$0C,$03,$03,$03,$03,$03,$03
	.db $0D,$0D,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $00,$01

Data_c35659:
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$04,$04,$03,$03,$03,$03,$03,$03
	.db $05,$05,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $07,$07,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $09,$09,$03,$03,$03,$03,$03,$03,$0A,$0A,$03,$03,$03,$03,$03,$03
	.db $0B,$0B,$0B,$03,$03,$03,$03,$03,$0C,$0C,$0C,$03,$03,$03,$03,$03
	.db $0C,$0D,$0D,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $00,$01

Data_c356db:
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$04,$04,$03,$03,$03,$03,$03,$03
	.db $05,$05,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $07,$07,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $0B,$0B,$0B,$03,$03,$03,$03,$03,$0C,$0C,$0C,$03,$03,$03,$03,$03
	.db $0D,$0D,$0D,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.db $00,$01

func_C3575D:
	ldx.b #$01
	jsl.l GetCurrentDungeon
	ldy.b wTemp00
	cpy.b #$01
	bne @lbl_C3577B
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$15
	bcs @lbl_C35776
	dex
	bra @lbl_C3577B
@lbl_C35776:
	cmp.b #$1A
	bcc @lbl_C3577B
;C3577A
	.db $CA
@lbl_C3577B:
	stx.b wTemp06
	ldx.b #$01
	cpy.b #$02
	beq @lbl_C3578E
	cpy.b #$03
	beq @lbl_C3578E
	cpy.b #$04
	beq @lbl_C3578E
	stx.b wTemp04
	rts
@lbl_C3578E:
	jsl $C62771                             ;C3578E
	lda $00                                 ;C35792
	cmp #$04                                ;C35794
	.db $B0,$F3   ;C35796
	dex                                     ;C35798
	.db $80,$F0   ;C35799
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bne @lbl_C357AF
	jsl.l func_C38D18
	jsl.l func_C38D72
	bra @lbl_C357D3
@lbl_C357AF:
	.db $A9,$01,$8F,$8E,$BE,$7E,$A9,$03,$8F,$66,$BE,$7E,$A9,$03,$8F,$70   ;C357AF
	.db $BE,$7E,$A9,$3C,$8F,$7A,$BE,$7E,$A9,$26,$8F,$84,$BE,$7E,$A9,$00   ;C357BF  
	.db $8F,$66,$C1,$7E                   ;C357CF  
@lbl_C357D3:
	jsl.l func_C38AD6
	jsl.l func_C38B2F
	jsl.l func_C38C9F
	jsr.w func_C38BAE
	jsr.w func_C38C70
	jsl.l func_C3893E
	jsl.l func_C62B37
	lda.b wTemp00
	beq @lbl_C35807
	jsl.l func_C38981
	jsl.l func_C389AA
	jsl.l Get7ED5EC
	lda.b wTemp00
	cmp.b #$10
	beq @lbl_C35807
	jsl.l func_C38A3C
@lbl_C35807:
	rts
	jsl.l func_C38AD6
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$00
	xba
	lda.l wMapNum
	dec a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	phx
	jsl.l func_C38FB7
	plx
	phx
	jsl.l func_C38DD4
	plx
	phx
	jsl.l func_C38E07
	plx
	phx
	jsl.l func_C38ECC
	plx
	phx
	jsl.l func_C38F01
	plx
	jsl.l func_C38F34
	jsl.l func_C371AB
	jsl.l func_C3893E
	rts

	;C3584A
	rts
	jsl.l func_C2CAF4
	jsl.l func_C39021
	jsl.l func_C38AD6
	jsr.w func_C36FF0
	jsl.l func_C371AB
	jsr.w func_C3737C
	jsr.w func_C39382
	jsr.w func_C39AAA
	jsr.w func_C38011
	jsr.w func_C39C97
	jsr.w func_C39D8C
	jsr.w func_C39FB2
	jsl.l func_C38981
	jsl.l func_C389AA
	jsl.l func_C389DB
	jsl.l func_C3D219
	jsl.l func_C38A3C
	jsl.l func_C391FA
	jsl.l func_C3893E
	jsr.w func_C399F2
	jsr.w func_C39E1D
	rts

	jsr $858F                               ;C35896
	jsl $C38AD6                             ;C35899
	jsl $C371AB                             ;C3589D
	jsr $9C97                               ;C358A1
	jsr $9D8C                               ;C358A4
	jmp $58CE                               ;C358A7
	jsr $8757                               ;C358AA
	jsl $C38AD6                             ;C358AD
	jsl $C371AB                             ;C358B1
	jsr $9C97                               ;C358B5
	jsr $9D8C                               ;C358B8
	jmp $58CE                               ;C358BB
	stz $00                                 ;C358BE
	jsr $8895                               ;C358C0
	jsl $C38AD6                             ;C358C3
	jsl $C371AB                             ;C358C7
	jsr $9C97                               ;C358CB
	jsl $C3893E                             ;C358CE
	jsl $C38981                             ;C358D2
	jsl $C389AA                             ;C358D6
	jsl $C389DB                             ;C358DA
	jsl $C3D219                             ;C358DE
	jsl $C38A3C                             ;C358E2
	jsr $99F2                               ;C358E6
	rts                                     ;C358E9
	jsr $8865                               ;C358EA
	jsl $C38AD6                             ;C358ED
	jsl $C371AB                             ;C358F1
	jsl $C3893E                             ;C358F5
	jsl $C38981                             ;C358F9
	jsl $C389AA                             ;C358FD
	jsl $C389DB                             ;C35901
	jsl $C3D219                             ;C35905
	jsl $C38A3C                             ;C35909
	rts                                     ;C3590D
	jsr $8916                               ;C3590E
	jsl $C38AD6                             ;C35911
	jsl $C371AB                             ;C35915
	jsl $C3893E                             ;C35919
	jsl $C38981                             ;C3591D
	jsl $C389AA                             ;C35921
	jsl $C389DB                             ;C35925
	jsl $C3D219                             ;C35929
	rts                                     ;C3592D
	jsl $C2DD90                             ;C3592E
	jsl $C39021                             ;C35932
	jsl $C38AD6                             ;C35936
	jsr $9A64                               ;C3593A
	jsl $C371AB                             ;C3593D
	jmp $5990                               ;C35941
	jsl $C2D987                             ;C35944
	jsl $C39021                             ;C35948
	jsl $C38AD6                             ;C3594C
	jsr $9A3B                               ;C35950
	jsl $C371AB                             ;C35953
	jmp $5990                               ;C35957
	jsl $C2DA5E                             ;C3595A
	jsl $C39021                             ;C3595E
	jsl $C38AD6                             ;C35962
	jsl $C371AB                             ;C35966
	jmp $5990                               ;C3596A
	jsl $C2DC24                             ;C3596D
	jsl $C39021                             ;C35971
	jsl $C38AD6                             ;C35975
	jsl $C371AB                             ;C35979
	jmp $5990                               ;C3597D
	jsl $C2DE67                             ;C35980
	jsl $C39021                             ;C35984
	jsl $C38AD6                             ;C35988
	jsl $C371AB                             ;C3598C
	jsr $9382                               ;C35990
	jsl $C3893E                             ;C35993
	jsl $C38981                             ;C35997
	jsl $C389AA                             ;C3599B
	jsl $C389DB                             ;C3599F
	jsl $C3D219                             ;C359A3
	jsl $C38A3C                             ;C359A7
	jsr $99F2                               ;C359AB
	rts                                     ;C359AE

func_C359AF:
	php
	rep #$30 ;AXY->16
	lda.b wTemp00
	lsr a
	lsr a
	sep #$20 ;A->8
	and.b #$C0
	ora.b wTemp00
	tax
	lda.l $7E945F,x
	sta.b wTemp00
	lda.l $7E9EDF,x
	sta.b wTemp01
	lda.l $7EA95F,x
	sta.b wTemp02
	plp
	rtl

func_C359D1:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.b wTemp02
	ldx.b #$80
	stx.b wTemp02
	asl a
	tax
	lda.b wTemp01
	xba
	lda.b wTemp00
	asl a
	asl a
	rep #$30 ;AXY->16
	lsr a
	lsr a
	pha
@lbl_C359EC:
	rep #$20 ;A->16
	lda.b wTemp01,s
	clc
	adc.l DATA8_C35A26,x
	tay
	sep #$20 ;A->8
	lda.w $945F,y
	asl a
	ror.b wTemp00
	lda.w $9EDF,y
	sec
	bpl @lbl_C35A11
	cmp.b #$E0
	bcs @lbl_C35A11
	cmp.b #$83
	beq @lbl_C35A11
	cmp.b #$86
	beq @lbl_C35A11
	clc
@lbl_C35A11:
	ror.b wTemp01
	lda.w $A95F,y
	asl a
	ror.b wTemp02
	inx
	inx
	bcc @lbl_C359EC
	lda.b wTemp00
	eor.b #$FF
	sta.b wTemp00
	ply
	plp
	rtl

DATA8_C35A26:
	.db $01,$00,$C1,$FF,$C0,$FF,$BF,$FF,$FF,$FF,$3F,$00,$40,$00,$41,$00
	.db $01,$00,$C1,$FF,$C0,$FF,$BF,$FF
	.db $FF,$FF,$3F,$00,$40,$00

func_C35A44:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	jsl.l func_C28597
	lda.b wTemp00
	sta.w $BE65
	rep #$30 ;AXY->16
	ldy.w #$0980
func_C35A59:
	tya
func_C35A5A:
	sec
	sbc.w #$0040
	tay
	lda.w $B41A,y
	bpl func_C35A59
	cpy.w #$0100
	bcs @lbl_C35A70
	ldy.w $BE62
	sty.b wTemp00
	plp
	rtl
@lbl_C35A70:
	iny
	iny
	iny

func_C35A73:
	dey
	tyx
	rep #$20 ;A->16
	lda.w #$8080
@lbl_C35A7A:
	inx
	inx
	bit.w $B3DF,x
	beq @lbl_C35A7A
	txy
	sep #$20 ;A->8
	lda.w $B3DF,y
	bmi @lbl_C35A8D
	iny
	lda.w $B3DF,y
@lbl_C35A8D:
	and.b #$7F
	sta.w $B3DF,y
	tya
	and.b #$3F
	cmp.b #$3C
	bcc @lbl_C35AA1
	rep #$20 ;A->16
	tya
	and.w #$FFC0
	bra func_C35A5A
@lbl_C35AA1:
	sep #$20 ;A->8
	lda.w $9EDF,y
	sta.b wTemp01
	phy
	jsl.l AdjustItemSlotFlags
	ply
	lda.w $945F,y
	sta.b wTemp00
	bmi @lbl_C35ABB
	phy
	jsl.l func_C20E47
	ply
@lbl_C35ABB:
	lda.w $A95F,y
	sta.b wTemp02
	lda.w $B3DF,y
	and.b #$01
	bne @lbl_C35AE5
	lda.w $BE5F
	bne @lbl_C35AD4
	lda.b #$E0
	sta.b wTemp02
	lda.b wTemp01
	bmi @lbl_C35AE1
@lbl_C35AD4:
	lda.b wTemp01
	bmi @lbl_C35AE5
	lda.w $BE61
	ora.l $7E8983
	bne @lbl_C35AE5
@lbl_C35AE1:
	lda.b #$80
	sta.b wTemp01
@lbl_C35AE5:
	lda.w $BE65
	beq @lbl_C35AED
	jmp.w func_C35B68
@lbl_C35AED:
	lda.w $BE60
	ora.l $7E8983
	bne func_C35B4D
	lda.b wTemp00
	bmi func_C35B4D
	lda.w $BE64
	bit.b #$90
	bne @lbl_C35B1D
	lda.w $A95F,y
	bmi @lbl_C35B1D
	bit.b #$40
	beq @lbl_C35B0C
	and.b #$0F
@lbl_C35B0C:
	cmp.w $BE64
	bne @lbl_C35B1D
	xba
	lda.b #$00
	xba
	tax
	lda.w $C166,x
	bit.b #$01
	beq @lbl_C35B33
@lbl_C35B1D:
	rep #$20 ;A->16
	tya
	sec
	sbc.w $BE62
	ldx.w #$0010
@lbl_C35B27:
	cmp.l DATA8_C35DFB,x
	beq @lbl_C35B33
	dex
	dex
	bpl @lbl_C35B27
	bra @lbl_C35B41
@lbl_C35B33:
	rep #$20 ;A->16
	phy
	jsl.l func_C2837F
	ply
	sep #$20 ;A->8
	lda.b wTemp06
	beq func_C35B4D
@lbl_C35B41:
	sep #$20 ;A->8
	lda.b wTemp00
	cmp.b #$13
	beq func_C35B4D
	lda.b #$80
	sta.b wTemp00
func_C35B4D:
	sty.b wTemp04
	jsl.l func_80E704
	lda.w $9EDF,y
	sta.b wTemp00
	lda.w $A95F,y
	sta.b wTemp02
	phy
	call_savebank func_80B830
	ply
	jmp.w func_C35A73

func_C35B68:
	sep #$20 ;A->8
	lda.b wTemp00
	cmp.b #$13
	beq @lbl_C35B74
	lda.b #$80
	sta.b wTemp00
@lbl_C35B74:
	lda.b #$80
	sta.b wTemp01
	bra func_C35B4D

func_C35B7A:
	php
	rep #$30 ;AXY->16
	lda.b wTemp00
	lsr a
	lsr a
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.l $7EB41B,x
	txa
	ora.b wTemp00
	tax
	lda.b wTemp02
	sta.l $7E945F,x
	lda.l $7EB3DF,x
	ora.b #$80
	sta.l $7EB3DF,x
	plp
	rtl

func_C35BA2:
	php
	rep #$30 ;AXY->16
	lda.b wTemp00
	lsr a
	lsr a
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.l $7EB41B,x
	txa
	ora.b wTemp00
	tax
	lda.l $7EB3DF,x
	ora.b #$80
	sta.l $7EB3DF,x
	lda.b wTemp02
	sta.l $7E9EDF,x
	bmi @lbl_C35BE2
	lda.b #$00
	xba
	lda.l $7EA95F,x
	cmp.b #$0A
	bcs @lbl_C35BE2
	tax
	lda.b wTemp00
	sta.l $7EC152,x
	lda.b wTemp01
	sta.l $7EC15C,x
@lbl_C35BE2:
	plp
	rtl

func_C35BE4:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EC15C,x
	bpl @lbl_C35BF7
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	plp
	rtl
@lbl_C35BF7:
	txy
	sta.b wTemp01
	xba
	lda.l $7EC152,x
	sta.b wTemp00
	asl a
	asl a
	rep #$30 ;AXY->16
	lsr a
	lsr a
	tax
	sep #$20 ;A->8
	lda.l $7E9EDF,x
	bmi @lbl_C35C12
	plp
	rtl
@lbl_C35C12:
	sep #$30 ;AXY->8
	tyx
	bankswitch 0x7E
	rep #$10 ;XY->16
	lda.w UNREACH_00BE70,x
	inc a
	xba
	lda.b #$00
	rep #$20 ;A->16
	lsr a
	lsr a
	sep #$20 ;A->8
	ora.w $BE66,x
	inc a
	tay
@lbl_C35C2D:
	lda.w $9EDF,y
	bpl @lbl_C35C5C
	iny
	lda.w $A95F,y
	bpl @lbl_C35C2D
	rep #$20 ;A->16
	tya
	and.w #$FFC0
	clc
	adc.w #$0040
	sep #$20 ;A->8
	ora.w $BE66,x
	inc a
	tay
	lda.w $A95F,y
	bpl @lbl_C35C2D
	lda.b #$FF
	sta.w $C152,x
	sta.w $C15C,x
	sta.b wTemp00
	sta.b wTemp01
	plp
	rtl
@lbl_C35C5C:
	rep #$20                                ;C35C5C
	tya                                     ;C35C5E
	asl a                                   ;C35C5F
	asl a                                   ;C35C60
	sep #$20                                ;C35C61
	lsr a                                   ;C35C63
	lsr a                                   ;C35C64
	sta $00                                 ;C35C65
	sta $C152,x                             ;C35C67
	xba                                     ;C35C6A
	sta $01                                 ;C35C6B
	sta $C15C,x                             ;C35C6D
	plp                                     ;C35C70
	rtl                                     ;C35C71

func_C35C72:
	php
	rep #$30 ;AXY->16
	lda.b wTemp00
	lsr a
	lsr a
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.l $7EB41B,x
	txa
	ora.b wTemp00
	tax
	lda.b wTemp02
	sta.l $7EA95F,x
	lda.l $7EB3DF,x
	ora.b #$80
	sta.l $7EB3DF,x
	plp
	rtl

func_C35C9A:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	jsl.l func_C28597
	lda.b wTemp00
	sta.w $BE65
	lda.b #$13
	sta.b wTemp00
	call_savebank GetCharacterMapInfo
	rep #$30 ;AXY->16
	lda.b wTemp00
	lsr a
	lsr a
	sep #$20 ;A->8
	and.b #$C0
	tay
	ora.b wTemp00
	tax
	stx.w $BE62
	lda.w $BE65
	beq @lbl_C35CCD
	jmp.w func_C35DE5
@lbl_C35CCD:
	lda.b #$80
	sta.w $B3DB,y
	sta.w $B41B,y
	sta.w $B45B,y
	jsl.l func_C2334F
	lda.b wTemp00
	bne @lbl_C35D16
	ldx.w #$0010
@lbl_C35CE3:
	rep #$20 ;A->16
	lda.w $BE62
	clc
	adc.l DATA8_C35DFB,x
	tay
	sep #$20 ;A->8
	lda.w $A95F,y
	and.b #$F0
	cmp.b #$C0
	beq @lbl_C35D01
	lda.w $B3DF,y
	ora.b #$81
	sta.w $B3DF,y
@lbl_C35D01:
	lda.w $945F,y
	bmi @lbl_C35D10
	sta.b wTemp00
	phx
	call_savebank func_C27DE4
	plx
@lbl_C35D10:
	dex
	dex
	bpl @lbl_C35CE3
	bra @lbl_C35D62
@lbl_C35D16:
	ldx #$0010                              ;C35D16
@lbl_C35D19:
	rep #$20                                ;C35D19
	lda $BE62                               ;C35D1B
	clc                                     ;C35D1E
	adc $C35DFB,x                           ;C35D1F
	tay                                     ;C35D23
	sep #$20                                ;C35D24
	lda $A95F,y                             ;C35D26
	and #$F0                                ;C35D29
	cmp #$C0                                ;C35D2B
	bne @lbl_C35D47                         ;C35D2D
	jsl $C36BCE                             ;C35D2F
	lda #$00                                ;C35D33
	sta $02                                 ;C35D35
	stz $03                                 ;C35D37
	lda #$01                                ;C35D39
	sta $04                                 ;C35D3B
	phx                                     ;C35D3D
	phy                                     ;C35D3E
	phb                                     ;C35D3F
	jsl $C36829                             ;C35D40
	plb                                     ;C35D44
	ply                                     ;C35D45
	plx                                     ;C35D46
@lbl_C35D47:
	lda $B3DF,y                             ;C35D47
	ora #$81                                ;C35D4A
	sta $B3DF,y                             ;C35D4C
	lda $945F,y                             ;C35D4F
	bmi @lbl_C35D5E                         ;C35D52
	sta $00                                 ;C35D54
	phx                                     ;C35D56
	phb                                     ;C35D57
	jsl $C27DE4                             ;C35D58
	plb                                     ;C35D5C
	plx                                     ;C35D5D
@lbl_C35D5E:
	dex                                     ;C35D5E
	dex                                     ;C35D5F
	bpl @lbl_C35D19                         ;C35D60
@lbl_C35D62:
	lda.w $BE64
	pha
	ldy.w $BE62
	lda.w $A95F,y
	sta.w $BE64
	cmp.b wTemp01,s
	beq @lbl_C35DE2
	bit.b #$90
	beq @lbl_C35D7F
	lda.b wTemp01,s
	bit.b #$90
	beq @lbl_C35DDC
	bra @lbl_C35DE2
@lbl_C35D7F:
	pha
	sta.b wTemp00
	jsl.l func_C366B7
	lda.b wTemp00
	bit.b #$01
	bne @lbl_C35D94
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C36BDF
@lbl_C35D94:
	lda.l $7EC175
	cmp.b wTemp01,s
	bne @lbl_C35DD9
	lda.l $7EC177
	bne @lbl_C35DD9
	lda.b #$01
	sta.l $7EC177
	lda.b #$22
	sta.b wTemp00
	lda.l $7EC176
	beq @lbl_C35DB6
;C35DB2
	.db $A9,$23,$85,$00
@lbl_C35DB6:
	stz.b wTemp01
	jsl.l func_C62AEE
	jsl.l func_C35EF8
	lda.b #$00
	xba
	lda.l $7EC176
	asl a
	tax
	lda.l DATA8_C35E0D,x
	sta.b wTemp00
	lda.l DATA8_C35E0E,x
	sta.b wTemp01
	jsl.l DisplayMessage
@lbl_C35DD9:
	pla
	bra @lbl_C35DE2
@lbl_C35DDC:
	sta.b wTemp00
	jsl.l func_C3701A
@lbl_C35DE2:
	pla
	plp
	rtl

func_C35DE5:
	sep #$20 ;A->8
	lda.b #$80
	sta.w $B41B,y
	lda.w $B3DF,x
	ora.b #$81
	sta.w $B3DF,x
	lda.b #$FF
	sta.w $BE64
	plp
	rtl

DATA8_C35DFB:
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$01,$00,$3F,$00,$40,$00
	.db $41,$00

DATA8_C35E0D:
	.db $3A

DATA8_C35E0E:
	.db $01
	.db $3B,$01,$3C,$01,$3D,$01,$3E,$01
	.db $3F,$01,$40,$01

func_C35E1B:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	ldy.w #$0A7F
@lbl_C35E27:
	lda.w $A95F,y
	bpl @lbl_C35E41
	cmp.b #$B0
	beq @lbl_C35E41
	lda.b #$80
	cmp.w $9EDF,y
	bne @lbl_C35E41
	cmp.w $945F,y
	bne @lbl_C35E41
@lbl_C35E3C:
	dey
	bpl @lbl_C35E27
	plp
	rtl
@lbl_C35E41:
	lda.w $B3DF,y
	ora.b #$80
	sta.w $B3DF,y
	rep #$20 ;A->16
	tya
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.w $B41B,x
	lda.b #$80
	bra @lbl_C35E3C

func_C35E5A:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.w $BE5F
	beq @lbl_C35E69
;C35E66  
	.db $4C,$C9,$5E
@lbl_C35E69:
	ldx.w $BE8E
@lbl_C35E6C:
	dex
	bmi @lbl_C35E79
	stx.b wTemp00
	phx
	jsl.l func_C366D5
	plx
	bra @lbl_C35E6C
@lbl_C35E79:
	rep #$10 ;XY->16
	ldy.w #$0A7F
@lbl_C35E7E:
	lda.w $A95F,y
	bit.b #$80
	beq @lbl_C35EA8
	and.b #$F0
	cmp.b #$C0
	bne @lbl_C35EC1
	jsl $C36BCE                             ;C35E8B
	lda #$00                                ;C35E8F
	sta $02                                 ;C35E91
	stz $03                                 ;C35E93
	lda #$01                                ;C35E95
	sta $04                                 ;C35E97
	phy                                     ;C35E99
	phb                                     ;C35E9A
	jsl $C36829                             ;C35E9B
	plb                                     ;C35E9F
	ply                                     ;C35EA0
	.db $80,$05   ;C35EA1
	lda #$10                                ;C35EA3
	sta $A95F,y                             ;C35EA5
@lbl_C35EA8:
	lda.w $B3DF,y
	bit.b #$01
	bne @lbl_C35EC1
	ora.b #$80
	sta.w $B3DF,y
	rep #$20 ;A->16
	tya
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.w $B41B,x
@lbl_C35EC1:
	dey
	bpl @lbl_C35E7E
	inc.w $BE5F
	plp
	rtl
	sep #$20                                ;C35EC9
	rep #$10                                ;C35ECB
	ldy #$097F                              ;C35ECD
@lbl_C35ED0:
	lda $A95F,y                             ;C35ED0
	and #$F0                                ;C35ED3
	cmp #$C0                                ;C35ED5
	bne @lbl_C35EF3                         ;C35ED7
	lda #$10                                ;C35ED9
	sta $A95F,y                             ;C35EDB
	lda $B3DF,y                             ;C35EDE
	ora #$80                                ;C35EE1
	sta $B3DF,y                             ;C35EE3
	rep #$20                                ;C35EE6
	tya                                     ;C35EE8
	sep #$20                                ;C35EE9
	and #$C0                                ;C35EEB
	tax                                     ;C35EED
	lda #$80                                ;C35EEE
	sta $B41B,x                             ;C35EF0
@lbl_C35EF3:
	dey                                     ;C35EF3
	bpl @lbl_C35ED0                         ;C35EF4
	plp                                     ;C35EF6
	rtl                                     ;C35EF7

func_C35EF8:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	lda.w $BE60
	bne @lbl_C35F29
	inc.w $BE60
	ldy.w #$0A7F
@lbl_C35F0C:
	lda.w $945F,y
	bpl @lbl_C35F56
	lda.w $9EDF,y
	bmi @lbl_C35F26
	sta.b wTemp00
	phy
	call_savebank GetItemDisplayInfo
	ply
	lda.b wTemp01
	cmp.b #$E7
	beq @lbl_C35F2B
@lbl_C35F26:
	dey
	bpl @lbl_C35F0C
@lbl_C35F29:
	plp
	rtl
@lbl_C35F2B:
	lda $9EDF,y                             ;C35F2B
	sta $00                                 ;C35F2E
	phy                                     ;C35F30
	jsl $C306F4                             ;C35F31
	ply                                     ;C35F35
	lda #$80                                ;C35F36
	sta $9EDF,y                             ;C35F38
	jsl $C36BCE                             ;C35F3B
	lda #$06                                ;C35F3F
	sta $02                                 ;C35F41
	lda #$0F                                ;C35F43
	sta $03                                 ;C35F45
	phy                                     ;C35F47
	phb                                     ;C35F48
	jsl $C2007D                             ;C35F49
	plb                                     ;C35F4D
	ply                                     ;C35F4E
	lda $00                                 ;C35F4F
	.db $30,$03   ;C35F51
	sta $945F,y                             ;C35F53
@lbl_C35F56:
	lda.w $B3DF,y
	ora.b #$80
	sta.w $B3DF,y
	rep #$20 ;A->16
	tya
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.w $B41B,x
	bra @lbl_C35F26

func_C35F6D:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	lda.w $BE61
	bne @lbl_C35F89
	inc.w $BE61
	ldy.w #$0A7F
@lbl_C35F81:
	lda.w $9EDF,y
	bpl @lbl_C35F8B
@lbl_C35F86:
	dey
	bpl @lbl_C35F81
@lbl_C35F89:
	plp
	rtl
@lbl_C35F8B:
	lda.w $B3DF,y
	ora.b #$80
	sta.w $B3DF,y
	rep #$20 ;A->16
	tya
	sep #$20 ;A->8
	and.b #$C0
	tax
	lda.b #$80
	sta.w $B41B,x
	bra @lbl_C35F86

func_C35FA2:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	ldy.w #$0A7F
@lbl_C35FAE:
	lda.w $9EDF,y
	cmp.b #$80
	beq @lbl_C35FC3
	and.b #$C0
	cmp.b #$C0
	bne @lbl_C35FC3
	lda.w $9EDF,y
	ora.b #$20
	sta.w $9EDF,y
@lbl_C35FC3:
	dey
	bpl @lbl_C35FAE
	plp
	rtl

func_C35FC8:
	php
	sep #$20 ;A->8
	lda.l $7EBE5F
	sta.b wTemp00
	lda.l $7EBE60
	ora.l $7E8983
	sta.b wTemp01
	lda.l $7EBE61
	ora.l $7E8983
	sta.b wTemp02
	plp
	rtl

func_C35FE7:
	php
	sep #$30 ;AXY->8
	lda.b wTemp02
	cmp.b wTemp00
	bcs @lbl_C35FF8
	pha
	lda.b wTemp00
	sta.b wTemp02
	pla
	sta.b wTemp00
@lbl_C35FF8:
	lda.b wTemp02
	inc a
	pha
	lda.b wTemp03
	pha
	ldx.b wTemp00
	ldy.b wTemp01
@lbl_C36003:
	txa
	cmp.b wTemp02,s
	bcs @lbl_C36019
	stx.b wTemp00
	sty.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	inx
	bra @lbl_C36003
@lbl_C36019:
	pla
	pla
	plp
	rtl

func_C3601D:
	php
	sep #$30 ;AXY->8
	lda.b wTemp02
	cmp.b wTemp01
	bcs @lbl_C3602E
	pha
	lda.b wTemp01
	sta.b wTemp02
	pla
	sta.b wTemp01
@lbl_C3602E:
	lda.b wTemp02
	inc a
	pha
	lda.b wTemp03
	pha
	ldx.b wTemp00
	ldy.b wTemp01
@lbl_C36039:
	tya
	cmp.b wTemp02,s
	bcs @lbl_C3604F
	stx.b wTemp00
	sty.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	iny
	bra @lbl_C36039
@lbl_C3604F:
	pla
	pla
	plp
	rtl

func_C36053:
	php
	sep #$30 ;AXY->8
	lda.b wTemp01
	pha
	lda.b wTemp02
	inc a
	pha
	lda.b wTemp03
	inc a
	pha
	lda.b wTemp04
	pha
	ldx.b wTemp00
@lbl_C36066:
	lda.b wTemp04,s
	tay
	txa
	cmp.b wTemp03,s
	bcs @lbl_C36087
@lbl_C3606E:
	tya
	cmp.b wTemp02,s
	bcs @lbl_C36084
	stx.b wTemp00
	sty.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	iny
	bra @lbl_C3606E
@lbl_C36084:
	inx
	bra @lbl_C36066
@lbl_C36087:
	pla
	pla
	pla
	pla
	plp
	rtl

func_C3608D:
	php
	rep #$10 ;XY->16
@lbl_C36090:
	rep #$20 ;A->16
@lbl_C36092:
	jsl.l Random
	lda.b wTemp00
	xba
	pha
	jsl.l Random
	pla
	ora.b wTemp00
	and.w #$0FFF
	cmp.w #$0980
	bcs @lbl_C36092
	tax
	sep #$20 ;A->8
	lda.l $7EA95F,x
	bit.b #$A0
	bne @lbl_C36090
	bit.b #$10
	bne @lbl_C360C8
	and.b #$0F
	sta.b wTemp00
	phx
	jsl.l func_C366B7
	plx
	lda.b wTemp00
	bit.b #$20
	bne @lbl_C36090
@lbl_C360C8:
	lda.l $7E945F,x
	cmp.b #$80
	bne @lbl_C36090
	txy
	jsl.l func_C36BCE
	plp
	rtl

func_C360D7:
	php
	rep #$10 ;XY->16
	ldy.w #$0064
@lbl_C360DD:
	rep #$20 ;A->16
	dey
	bpl @lbl_C360E7
;C360E2  
	jsr $612E                               ;C360E2
	plp                                     ;C360E5
	rtl                                     ;C360E6
@lbl_C360E7:
	jsl.l Random
	lda.b wTemp00
	xba
	pha
	jsl.l Random
	pla
	ora.b wTemp00
	and.w #$0FFF
	cmp.w #$0980
	bcs @lbl_C360E7
	tax
	sep #$20 ;A->8
	lda.l $7EA95F,x
	bit.b #$A0
	bne @lbl_C360DD
	bit.b #$10
	bne @lbl_C3611F
	and.b #$0F
	sta.b wTemp00
	phx
	phy
	jsl.l func_C366B7
	ply
	plx
	lda.b wTemp00
	bit.b #$20
	bne @lbl_C360DD
@lbl_C3611F:
	lda.l $7E945F,x
	cmp.b #$80
	bne @lbl_C360DD
	txy
	jsl.l func_C36BCE
	plp
	rtl
@lbl_C3612E:
	rep #$20                                ;C3612E
@lbl_C36130:
	jsl $C3F65F                             ;C36130
	lda $00                                 ;C36134
	xba                                     ;C36136
	pha                                     ;C36137
	jsl $C3F65F                             ;C36138
	pla                                     ;C3613C
	ora $00                                 ;C3613D
	and #$0FFF                              ;C3613F
	cmp #$0980                              ;C36142
	bcs @lbl_C36130                         ;C36145
	tax                                     ;C36147
	sep #$20                                ;C36148
	lda $7EA95F,x                           ;C3614A
	bit #$80                                ;C3614E
	bne @lbl_C3616C                         ;C36150
	bit #$20                                ;C36152
	bne @lbl_C36172                         ;C36154
	bit #$10                                ;C36156
	bne @lbl_C36172                         ;C36158
	and #$0F                                ;C3615A
	sta $00                                 ;C3615C
	phx                                     ;C3615E
	jsl $C366B7                             ;C3615F
	plx                                     ;C36163
	lda $00                                 ;C36164
	bit #$20                                ;C36166
	bne @lbl_C3612E                         ;C36168
	bra @lbl_C36172                         ;C3616A
@lbl_C3616C:
	and #$F0                                ;C3616C
	cmp #$C0                                ;C3616E
	bne @lbl_C3612E                         ;C36170
@lbl_C36172:
	lda $7E945F,x                           ;C36172
	cmp #$80                                ;C36176
	bne @lbl_C3612E                         ;C36178
	txy                                     ;C3617A
	jsl $C36BCE                             ;C3617B
	rts                                     ;C3617F
	php                                     ;C36180
	sep #$30                                ;C36181
	lda #$7E                                ;C36183
	pha                                     ;C36185
	plb                                     ;C36186
	lda $BE8E                               ;C36187
	dec a                                   ;C3618A
	sta $01                                 ;C3618B
	stz $00                                 ;C3618D
	jsl $C3F69F                             ;C3618F
	ldx $00                                 ;C36193
	lda $C134,x                             ;C36195
	bne @lbl_C361A2                         ;C36198
	lda #$FF                                ;C3619A
	sta $00                                 ;C3619C
	sta $01                                 ;C3619E
	plp                                     ;C361A0
	rtl                                     ;C361A1
@lbl_C361A2:
	dec a                                   ;C361A2
	sta $01                                 ;C361A3
	stz $00                                 ;C361A5
	phx                                     ;C361A7
	jsl $C3F69F                             ;C361A8
	plx                                     ;C361AC
	lda $00                                 ;C361AD
	sta $01                                 ;C361AF
	stx $00                                 ;C361B1
	jsl $C36549                             ;C361B3
	lda $01                                 ;C361B7
	xba                                     ;C361B9
	lda $00                                 ;C361BA
	asl a                                   ;C361BC
	asl a                                   ;C361BD
	rep #$30                                ;C361BE
	lsr a                                   ;C361C0
	lsr a                                   ;C361C1
	sta $06                                 ;C361C2
	ldx #$0006                              ;C361C4
@lbl_C361C7:
	rep #$20                                ;C361C7
	lda $06                                 ;C361C9
	clc                                     ;C361CB
	adc $C361FB,x                           ;C361CC
	tay                                     ;C361D0
	sep #$20                                ;C361D1
	lda $A95F,y                             ;C361D3
	bit #$90                                ;C361D6
	bne @lbl_C361DF                         ;C361D8
	lda $945F,y                             ;C361DA
	bmi @lbl_C361EB                         ;C361DD
@lbl_C361DF:
	dex                                     ;C361DF
	dex                                     ;C361E0
	bpl @lbl_C361C7                         ;C361E1
	lda #$FF                                ;C361E3
	sta $00                                 ;C361E5
	sta $01                                 ;C361E7
	plp                                     ;C361E9
	rtl                                     ;C361EA
@lbl_C361EB:
	rep #$20                                ;C361EB
	tya                                     ;C361ED
	asl a                                   ;C361EE
	asl a                                   ;C361EF
	sep #$20                                ;C361F0
	lsr a                                   ;C361F2
	lsr a                                   ;C361F3
	sta $00                                 ;C361F4
	xba                                     ;C361F6
	sta $01                                 ;C361F7
	plp                                     ;C361F9
	rtl                                     ;C361FA
	.db $01,$00,$FF,$FF,$40,$00,$C0,$FF   ;C361FB

func_C36203:
	php
	rep #$10 ;XY->16
@lbl_C36206:
	rep #$20 ;A->16
@lbl_C36208:
	jsl.l Random
	lda.b wTemp00
	xba
	pha
	jsl.l Random
	pla
	ora.b wTemp00
	and.w #$0FFF
	cmp.w #$0980
	bcs @lbl_C36208
	tax
	sep #$20 ;A->8
	lda.l $7EA95F,x
	bit.b #$A0
	bne @lbl_C36206
	bit.b #$10
	bne @lbl_C3623E
	and.b #$0F
	sta.b wTemp00
	phx
	jsl.l func_C366B7
	plx
	lda.b wTemp00
	bit.b #$20
	bne @lbl_C36206
@lbl_C3623E:
	lda.l $7E9EDF,x
	cmp.b #$80
	bne @lbl_C36206
	txy
	jsl.l func_C36BCE
	plp
	rtl
	php                                     ;C3624D
	rep #$10                                ;C3624E
@lbl_C36250:
	rep #$20                                ;C36250
@lbl_C36252:
	jsl $C3F65F                             ;C36252
	lda $00                                 ;C36256
	xba                                     ;C36258
	pha                                     ;C36259
	jsl $C3F65F                             ;C3625A
	pla                                     ;C3625E
	ora $00                                 ;C3625F
	and #$0FFF                              ;C36261
	cmp #$0980                              ;C36264
	bcs @lbl_C36252                         ;C36267
	tax                                     ;C36269
	sep #$20                                ;C3626A
	lda $7EA95F,x                           ;C3626C
	bit #$90                                ;C36270
	bne @lbl_C36250                         ;C36272
	lda $7E9EDF,x                           ;C36274
	cmp #$C0                                ;C36278
	bcs @lbl_C36280                         ;C3627A
	cmp #$80                                ;C3627C
	bne @lbl_C36250                         ;C3627E
@lbl_C36280:
	txy                                     ;C36280
	jsl $C36BCE                             ;C36281
	plp                                     ;C36285
	rtl                                     ;C36286

func_C36287:
	php
	rep #$10 ;XY->16
	ldy.w #$0064
@lbl_C3628D:
	rep #$20 ;A->16
	dey
	bpl @lbl_C36297
;C36292  
	jsr $62D4                               ;C36292
	plp                                     ;C36295
	rtl                                     ;C36296
@lbl_C36297:
	jsl.l Random
	lda.b wTemp00
	xba
	pha
	jsl.l Random
	pla
	ora.b wTemp00
	and.w #$0FFF
	cmp.w #$0980
	bcs @lbl_C36297
	tax
	sep #$20 ;A->8
	lda.l $7EA95F,x
	bit.b #$80
	bne @lbl_C3628D
	bit.b #$10
	beq @lbl_C362C1
	cmp.b #$10
	bne @lbl_C3628D
@lbl_C362C1:
	lda.l $7E9EDF,x
	cmp.b #$C0
	bcs @lbl_C362CD
	cmp.b #$80
	bne @lbl_C3628D
@lbl_C362CD:
	txy
	jsl.l func_C36BCE
	plp
	rtl
@lbl_C362D4:
	rep #$20                                ;C362D4
@lbl_C362D6:
	jsl $C3F65F                             ;C362D6
	lda $00                                 ;C362DA
	xba                                     ;C362DC
	pha                                     ;C362DD
	jsl $C3F65F                             ;C362DE
	pla                                     ;C362E2
	ora $00                                 ;C362E3
	and #$0FFF                              ;C362E5
	cmp #$0980                              ;C362E8
	bcs @lbl_C362D6                         ;C362EB
	tax                                     ;C362ED
	sep #$20                                ;C362EE
	lda $7EA95F,x                           ;C362F0
	bit #$80                                ;C362F4
	bne @lbl_C36302                         ;C362F6
	bit #$10                                ;C362F8
	beq @lbl_C36308                         ;C362FA
	cmp #$10                                ;C362FC
	bne @lbl_C362D4                         ;C362FE
	bra @lbl_C36308                         ;C36300
@lbl_C36302:
	and #$F0                                ;C36302
	cmp #$C0                                ;C36304
	bne @lbl_C362D4                         ;C36306
@lbl_C36308:
	lda $7E9EDF,x                           ;C36308
	cmp #$C0                                ;C3630C
	bcs @lbl_C36314                         ;C3630E
	cmp #$80                                ;C36310
	bne @lbl_C362D4                         ;C36312
@lbl_C36314:
	txy                                     ;C36314
	jsl $C36BCE                             ;C36315
	rts                                     ;C36319

func_C3631A:
	php
	sep #$30 ;AXY->8
	lda.b wTemp01
	pha
	lda.b wTemp00
	pha
	jsr.w func_C3635A
	lda.b wTemp00
	bpl @lbl_C36356
@lbl_C3632A:
	jsl.l Random
	lda.b wTemp00
	and.b #$0F
	cmp.b #$09
	bcs @lbl_C3632A
	tax
	ldy.b #$08
@lbl_C36339:
	lda.b wTemp01,s
	clc
	adc.l DATA8_C363EC,x
	sta.b wTemp00
	lda.b wTemp02,s
	clc
	adc.l DATA8_C363FE,x
	sta.b wTemp01
	jsr.w func_C3635A
	lda.b wTemp00
	bpl @lbl_C36356
	inx
	dey
	bpl @lbl_C36339
@lbl_C36356:
	pla
	pla
	plp
	rtl

func_C3635A:
	lda.b wTemp00
	sta.b wTemp04
	lda.b wTemp01
	sta.b wTemp06
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C36372
	lda.b wTemp00
	bmi @lbl_C36379
@lbl_C36372:
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	rts
@lbl_C36379:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp06
	sta.b wTemp01
	rts

func_C36382:
	php
	sep #$30 ;AXY->8
	lda.b wTemp01
	pha
	lda.b wTemp00
	pha
	jsr.w func_C363C2
	lda.b wTemp00
	bpl @lbl_C363BE
@lbl_C36392:
	jsl.l Random
	lda.b wTemp00
	and.b #$0F
	cmp.b #$09
	bcs @lbl_C36392
	tax
	ldy.b #$08
@lbl_C363A1:
	lda.b wTemp01,s
	clc
	adc.l DATA8_C363EC,x
	sta.b wTemp00
	lda.b wTemp02,s
	clc
	adc.l DATA8_C363FE,x
	sta.b wTemp01
	jsr.w func_C363C2
	lda.b wTemp00
	bpl @lbl_C363BE
	inx
	dey
	bpl @lbl_C363A1
@lbl_C363BE:
	pla
	pla
	plp
	rtl

func_C363C2:
	lda.b wTemp00
	sta.b wTemp04
	lda.b wTemp01
	sta.b wTemp06
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C363E5
	lda.b wTemp01
	cmp.b #$80
	bne @lbl_C363E5
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp06
	sta.b wTemp01
	rts
@lbl_C363E5:
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	rts

DATA8_C363EC:
	.db $FF,$00,$01,$FF,$00,$01,$FF,$00   ;C363EC
	.db $01,$FF,$00                       ;C363F4
	.db $01,$FF,$00,$01,$FF,$00,$01       ;C363F7  

DATA8_C363FE:
	.db $FF,$FF,$FF,$00,$00,$00,$01,$01   ;C363FE
	.db $01,$FF,$FF                       ;C36406
	.db $FF,$00,$00,$00,$01,$01,$01       ;C36409  

func_C36410:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l func_C36BBD
	phy
	tyx
	lda.l $7EA95F,x
	pha
	rep #$20 ;A->16
	lda.b wTemp02
	and.w #$00FF
	ora.w #$1400
	sta.b wTemp00
	jsl.l MultiplyPackedBytesToWord
	lda.b wTemp00
	pha
	ldy.w #$0012
@lbl_C36436:
	rep #$20 ;A->16
	tya
	clc
	adc.b wTemp01,s
	tax
	lda.l UNREACH_C36488,x
	clc
	adc.b wTemp04,s
	tax
	and.w #$003F
	cmp.w #$003C
	bcs @lbl_C3646A
	txa
	and.w #$0FC0
	cmp.w #$0980
	bcs @lbl_C3646A
	sep #$20 ;A->8
	lda.l $7EA95F,x
	bmi @lbl_C3646A
	cmp.b wTemp03,s
	bne @lbl_C3646A
	lda.l $7E9EDF,x
	cmp.b #$80
	beq @lbl_C36478
@lbl_C3646A:
	dey
	dey
	bpl @lbl_C36436
	sep #$20 ;A->8
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	bra @lbl_C3647D
@lbl_C36478:
	txy
	jsl.l func_C36BCE
@lbl_C3647D:
	rep #$20 ;A->16
	pla
	sep #$20 ;A->8
	pla
	rep #$20 ;A->16
	pla
	plp
	rtl

UNREACH_C36488:
	.db $04,$00,$83,$00,$83,$FF,$43,$00   ;C36488  
	.db $C3,$FF,$03,$00                   ;C36490  
	.db $42,$00,$C2,$FF,$02,$00,$01,$00,$C4,$FF,$01,$FF,$83,$FF,$42,$FF   ;C36494
	.db $C3,$FF,$41,$FF,$82,$FF,$C2,$FF,$81,$FF,$C1,$FF,$00,$FF,$42,$FF   ;C364A4  
	.db $3E,$FF,$41,$FF,$3F,$FF,$40,$FF,$81,$FF,$7F,$FF,$80,$FF,$C0,$FF   ;C364B4  
	.db $FF,$FE,$BC,$FF,$3E,$FF,$7D,$FF,$3F,$FF,$BD,$FF,$7E,$FF,$7F,$FF   ;C364C4  
	.db $BE,$FF,$BF,$FF                   ;C364D4  
	.db $FC,$FF,$7D,$00,$7D,$FF,$3D,$00,$BD,$FF,$FD,$FF,$3E,$00,$BE,$FF   ;C364D8
	.db $FE,$FF,$FF,$FF                   ;C364E8
	.db $FF,$00,$3C,$00,$BE,$00,$7D,$00,$BF,$00,$3D,$00,$7E,$00,$7F,$00   ;C364EC  
	.db $3E,$00,$3F,$00,$00,$01,$C2,$00,$BE,$00,$C1,$00,$BF,$00,$C0,$00   ;C364FC  
	.db $81,$00,$7F,$00,$80,$00,$40,$00,$44,$00,$01,$01,$83,$00,$C2,$00   ;C3650C  
	.db $43,$00,$C1,$00,$82,$00,$42,$00   ;C3651C
	.db $81,$00,$41,$00                   ;C36524
	.db $08,$E2,$30,$A0,$00,$A6,$00,$BF,$66,$C1,$7E,$89,$08,$F0,$01,$C8   ;C36528
	.db $84,$00,$28,$6B                   ;C36538  

func_C3653C:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EC134,x
	sta.b wTemp00
	plp
	rtl

func_C36549:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	asl a
	asl a
	ora.b wTemp01
	tax
	lda.l $7EC094,x
	sta.b wTemp00
	lda.l $7EC0E4,x
	sta.b wTemp01
	plp
	rtl
	php                                     ;C36562
	sep #$20                                ;C36563
	rep #$10                                ;C36565
	lda #$7E                                ;C36567
	pha                                     ;C36569
	plb                                     ;C3656A
	ldy #$097F                              ;C3656B
@lbl_C3656E:
	lda $945F,y                             ;C3656E
	bmi @lbl_C3659D                         ;C36571
	cmp #$13                                ;C36573
	beq @lbl_C3659D                         ;C36575
	sta $00                                 ;C36577
	phy                                     ;C36579
	phb                                     ;C3657A
	jsl HandleCharacterDeath                             ;C3657B
	plb                                     ;C3657F
	ply                                     ;C36580
	jsl $C36BCE                             ;C36581
	ldx $00                                 ;C36585
	phx                                     ;C36587
	phy                                     ;C36588
	phb                                     ;C36589
	jsl $C303D0                             ;C3658A
	plb                                     ;C3658E
	ply                                     ;C3658F
	plx                                     ;C36590
	lda $00                                 ;C36591
	bmi @lbl_C3659D                         ;C36593
	stx $00                                 ;C36595
	sta $02                                 ;C36597
	jsl $C35BA2                             ;C36599
@lbl_C3659D:
	dey                                     ;C3659D
	bpl @lbl_C3656E                         ;C3659E
	plp                                     ;C365A0
	rtl                                     ;C365A1
	php                                     ;C365A2
	sep #$20                                ;C365A3
	rep #$10                                ;C365A5
	lda #$7E                                ;C365A7
	pha                                     ;C365A9
	plb                                     ;C365AA
	ldy #$097F                              ;C365AB
@lbl_C365AE:
	lda $9EDF,y                             ;C365AE
	bmi @lbl_C365EB                         ;C365B1
	sta $00                                 ;C365B3
	phy                                     ;C365B5
	jsl $C306F4                             ;C365B6
	ply                                     ;C365BA
	jsl $C36BCE                             ;C365BB
	ldx $00                                 ;C365BF
	lda #$80                                ;C365C1
	sta $02                                 ;C365C3
	phx                                     ;C365C5
	jsl $C35BA2                             ;C365C6
	plx                                     ;C365CA
	jsl $C62771                             ;C365CB
	lda $00                                 ;C365CF
	sta $02                                 ;C365D1
	stx $00                                 ;C365D3
	phx                                     ;C365D5
	phy                                     ;C365D6
	phb                                     ;C365D7
	jsl $C20BE7                             ;C365D8
	plb                                     ;C365DC
	ply                                     ;C365DD
	plx                                     ;C365DE
	lda $00                                 ;C365DF
	bmi @lbl_C365EB                         ;C365E1
	stx $00                                 ;C365E3
	sta $02                                 ;C365E5
	jsl $C35B7A                             ;C365E7
@lbl_C365EB:
	dey                                     ;C365EB
	bpl @lbl_C365AE                         ;C365EC
	plp                                     ;C365EE
	rtl                                     ;C365EF
.INDEX 8

func_C365F0:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b wTemp00
	rep #$10 ;XY->16
	lda.w $C13E,x
	bmi @lbl_C36662
	sta.b wTemp00
	lda.w $C148,x
	sta.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp01
	bmi @lbl_C3662F
	sta $00                                 ;C36611
	phx                                     ;C36613
	phy                                     ;C36614
	phb                                     ;C36615
	jsl $C30710                             ;C36616
	plb                                     ;C3661A
	ply                                     ;C3661B
	plx                                     ;C3661C
	lda $00                                 ;C3661D
	cmp #$08                                ;C3661F
	.db $D0,$0C   ;C36621
	lda $C13E,x                             ;C36623
	sta $00                                 ;C36626
	lda $C148,x                             ;C36628
	sta $01                                 ;C3662B
	plp                                     ;C3662D
	rtl                                     ;C3662E
@lbl_C3662F:
	lda.w $BE70,x
	inc a
	xba
	lda.b #$00
	rep #$20 ;A->16
	lsr a
	lsr a
	sep #$20 ;A->8
	ora.w $BE66,x
	inc a
	tay
@lbl_C36641:
	lda.w $9EDF,y
	bpl @lbl_C36670
	iny
	lda.w $A95F,y
	bpl @lbl_C36641
	rep #$20 ;A->16
	tya
	and.w #$FFC0
	clc
	adc.w #$0040
	sep #$20 ;A->8
	ora.w $BE66,x
	inc a
	tay
	lda.w $A95F,y
	bpl @lbl_C36641
@lbl_C36662:
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	sta.w $C13E,x
	sta.w $C148,x
	plp
	rtl
@lbl_C36670:
	sta $00                                 ;C36670
	phx                                     ;C36672
	phy                                     ;C36673
	phb                                     ;C36674
	jsl $C30710                             ;C36675
	plb                                     ;C36679
	ply                                     ;C3667A
	plx                                     ;C3667B
	lda $00                                 ;C3667C
	cmp #$08                                ;C3667E
	.db $D0,$C4   ;C36680
	rep #$20                                ;C36682
	tya                                     ;C36684
	asl a                                   ;C36685
	asl a                                   ;C36686
	sep #$20                                ;C36687
	lsr a                                   ;C36689
	lsr a                                   ;C3668A
	sta $00                                 ;C3668B
	sta $C13E,x                             ;C3668D
	xba                                     ;C36690
	sta $01                                 ;C36691
	sta $C148,x                             ;C36693
	plp                                     ;C36696
	rtl                                     ;C36697

func_C36698:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EBE66,x
	sta.b wTemp00
	lda.l $7EBE70,x
	sta.b wTemp01
	lda.l $7EBE7A,x
	sta.b wTemp02
	lda.l $7EBE84,x
	sta.b wTemp03
	plp
	rtl

func_C366B7:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EC166,x
	sta.b wTemp00
	plp
	rtl

func_C366C4:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EC166,x
	ora.b #$01
	sta.l $7EC166,x
	plp
	rtl

func_C366D5:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EC166,x
	bit.b #$01
	beq @lbl_C366F4
	and.b #$FE
	sta.l $7EC166,x
	lda.l $7EBE64
	cmp.b wTemp00
	bne @lbl_C366F4
	jsl.l func_C36BDF
@lbl_C366F4:
	plp
	rtl

func_C366F6:
	php 
	sep #$30 ;AXY->8
	lda.b #$01
	sta.b wTemp00
	jsr.w func_C38895
	lda.b #$7E
	pha
	plb
	lda.b #$00
	ldy.b #$09
@lbl_C36708:
	sta.w $C13E,y
	sta.w $C148,y
	dey 
	bpl @lbl_C36708
	stz.w $C134
	lda.b #$00
	sta.w $C166
	phb
	jsl.l func_C27FBD
	plb
	phb
	jsl.l func_C27717
	plb
	lda.b #$FF
	sta.w $BE64
	jsl.l func_C35C9A
	jsl.l func_C35E1B
	plp 
	rtl

func_C36734:
	php 
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$7E
	pha
	plb
	stz.w $BE5F
	stz.w $BE60
	stz.w $BE61
	ldx.w #$0A7F
@lbl_C36749:
	lda.w $9EDF,x
	and.b #$C0
	cmp.b #$C0
	bne @lbl_C3675A
	lda.w $9EDF,x
	and.b #$DF
	sta.w $9EDF,x
@lbl_C3675A:
	lda.b #$80
	sta.w $B3DF,x
	dex 
	bpl @lbl_C36749
	lda.b #$FF
	sta.w $BE64
	jsl.l func_C35C9A
	plp 
	rtl

func_C3676D:
	php 
	rep #$20 ;A->16
	lda.b wTemp00
	sta.l $7EC172
	plp 
	rtl


func_C36778:
	php
	rep #$20 ;A->16
	lda.l $7EC172
	sta.b wTemp00
	plp
	rtl

func_C36783:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	ldy.b wTemp01
	phx
	phy
	jsl.l func_C36382
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C36798
	plp
	rtl
@lbl_C36798:
	stx $00                                 ;C36798
	sty $01                                 ;C3679A
	phx                                     ;C3679C
	jsl $C36CA5                             ;C3679D
	plx                                     ;C367A1
	lda $00                                 ;C367A2
	pha                                     ;C367A4
	phy                                     ;C367A5
	phx                                     ;C367A6
@lbl_C367A7:
	jsl $C3F65F                             ;C367A7
	lda $00                                 ;C367AB
	and #$0F                                ;C367AD
	cmp #$09                                ;C367AF
	bcs @lbl_C367A7                         ;C367B1
	tax                                     ;C367B3
	ldy #$08                                ;C367B4
@lbl_C367B6:
	lda $01,s                               ;C367B6
	clc                                     ;C367B8
	adc $C363EC,x                           ;C367B9
	sta $00                                 ;C367BD
	sta $04                                 ;C367BF
	lda $02,s                               ;C367C1
	clc                                     ;C367C3
	adc $C363FE,x                           ;C367C4
	sta $01                                 ;C367C8
	sta $06                                 ;C367CA
	phx                                     ;C367CC
	jsl $C36CA5                             ;C367CD
	plx                                     ;C367D1
	lda $00                                 ;C367D2
	bit #$80                                ;C367D4
	bne @lbl_C36810                         ;C367D6
	lda $04                                 ;C367D8
	sta $00                                 ;C367DA
	lda $06                                 ;C367DC
	sta $01                                 ;C367DE
	lda $04                                 ;C367E0
	pha                                     ;C367E2
	lda $06                                 ;C367E3
	pha                                     ;C367E5
	phx                                     ;C367E6
	phy                                     ;C367E7
	jsl $C36382                             ;C367E8
	ply                                     ;C367EC
	plx                                     ;C367ED
	pla                                     ;C367EE
	sta $06                                 ;C367EF
	pla                                     ;C367F1
	sta $04                                 ;C367F2
	lda $00                                 ;C367F4
	bmi @lbl_C36810                         ;C367F6
	sta $04                                 ;C367F8
	lda $01                                 ;C367FA
	sta $06                                 ;C367FC
	lda $03,s                               ;C367FE
	bit #$90                                ;C36800
	bne @lbl_C3681C                         ;C36802
	phx                                     ;C36804
	jsl $C36CA5                             ;C36805
	plx                                     ;C36809
	lda $00                                 ;C3680A
	cmp $03,s                               ;C3680C
	beq @lbl_C3681C                         ;C3680E
@lbl_C36810:
	inx                                     ;C36810
	dey                                     ;C36811
	bpl @lbl_C367B6                         ;C36812
	lda #$FF                                ;C36814
	sta $00                                 ;C36816
	sta $01                                 ;C36818
	bra @lbl_C36824                         ;C3681A
@lbl_C3681C:
	lda $04                                 ;C3681C
	sta $00                                 ;C3681E
	lda $06                                 ;C36820
	sta $01                                 ;C36822
@lbl_C36824:
	pla                                     ;C36824
	pla                                     ;C36825
	pla                                     ;C36826
	plp                                     ;C36827
	rtl                                     ;C36828

func_C36829:
	php
	rep #$30 ;AXY->16
	lda.b wTemp02
	lsr a
	bcs @lbl_C3687A
	ldx.b wTemp00
	phx
	jsl.l func_C39067
	plx
	txa
	sep #$20 ;A->8
	asl a
	asl a
	rep #$20 ;A->16
	lsr a
	lsr a
	tay
	sep #$20 ;A->8
	lda.b wTemp00
	bmi @lbl_C36860
	pha                                     ;C36849
	lda #$02                                ;C3684A
	sta $01                                 ;C3684C
	jsr $6ABE                               ;C3684E
	jsl $C390D7                             ;C36851
	pla                                     ;C36855
	sta $00                                 ;C36856
	jsl $C37063                             ;C36858
	lda #$01                                ;C3685C
	.db $80,$10   ;C3685E
@lbl_C36860:
	bankswitch 0x7E
	lda.b wTemp03
	bne @lbl_C3686D
	jsr.w func_C3687E
	bra @lbl_C36870
@lbl_C3686D:
	jsr.w func_C3689A
@lbl_C36870:
	pha
	jsl.l func_C371AB
	pla
	sta.b wTemp00
	plp
	rtl
@lbl_C3687A:
	stz.b wTemp00
	plp
	rtl

func_C3687E:
	lda.w $A95F,y
	and.b #$F0
	cmp.b #$C0
	bne func_C36897
	lda.b wTemp04
	bne func_C36891
func_C3688B:
	jsr.w func_C368BE
	lda.b #$01
	rts
func_C36891:
	jsr $68ED                               ;C36891
	lda #$01                                ;C36894
	rts                                     ;C36896
func_C36897:
	lda.b #$00
	rts

func_C3689A:
	lda.w $A95F,y
	and.b #$F0
	cmp.b #$C0
	beq func_C3688B
	bit.b #$40
	beq @lbl_C368BB
	lda.w $A95F,y
	bit.b #$10
	bne @lbl_C368BB
	stx.b wTemp00
	lda.b #$30
	sta.b wTemp02
	jsl.l func_C35C72
	lda.b #$02
	rts
@lbl_C368BB:
	lda.b #$03
	rts

func_C368BE:
	lda.b #$00
	xba
	lda.b wTemp02
	tax
@lbl_C368C4:
	phx
	jsr.w func_C368ED
	plx
	rep #$20 ;A->16
	tya
	clc
	adc.l UNREACH_C368E5,x
	tay
	sep #$20 ;A->8
	lda.w $A95F,y
	and.b #$F0
	cmp.b #$C0
	bne @lbl_C368E4
	lda.w $A95F,y
	bit.b #$02
	beq @lbl_C368C4
@lbl_C368E4:
	rts

UNREACH_C368E5:
	.db $01,$00,$C0,$FF,$FF,$FF,$40,$00   ;C368E5  

func_C368ED:
	lda.w $A95F,y
	bit.b #$01
	beq @lbl_C368FF
	jsr.w func_C36928
	lda.b wTemp00
	bmi @lbl_C368FF
	ora.b #$70
	bra @lbl_C36901
@lbl_C368FF:
	lda.b #$30
@lbl_C36901:
	sta.w $A95F,y
	lda.w $945F,y
	bmi @lbl_C36911
;C36909  
	sta $00                                 ;C36909
	phy                                     ;C3690B
	jsl $C27FAA                             ;C3690C
	ply                                     ;C36910
@lbl_C36911:
	rep #$20 ;A->16
	tya
	and.w #$0FC0
	tax
	sep #$20 ;A->8
	lda.b #$80
	sta.w $B41B,x
	lda.w $B3DF,y
	ora.b #$81
	sta.w $B3DF,y
	rts

func_C36928:
	phy
	ldx.w #$0006
@lbl_C3692C:
	rep #$20 ;A->16
	lda.b wTemp01,s
	clc
	adc.l UNREACH_C368E5,x
	tay
	sep #$20 ;A->8
	lda.w $A95F,y
	bit.b #$90
	bne @lbl_C36943
	and.b #$0F
	bra @lbl_C36949
@lbl_C36943:
	dex
	dex
	bpl @lbl_C3692C
;C36947
	.db $A9,$FF
@lbl_C36949:
	sta.b wTemp00
	ply
	rts
	php                                     ;C3694D
	sep #$30                                ;C3694E
	ldy $00                                 ;C36950
	stz $00                                 ;C36952
	stz $01                                 ;C36954
	phy                                     ;C36956
	jsl $C20BE7                             ;C36957
	ply                                     ;C3695B
	ldx $00                                 ;C3695C
	bpl @lbl_C36962                         ;C3695E
	plp                                     ;C36960
	rtl                                     ;C36961
@lbl_C36962:
	phx                                     ;C36962
	jsl $C210AC                             ;C36963
	plx                                     ;C36967
	lda $03                                 ;C36968
	pha                                     ;C3696A
	stx $00                                 ;C3696B
	phx                                     ;C3696D
	jsl.l GetCharacterStats                             ;C3696E
	plx                                     ;C36972
	lda $05                                 ;C36973
	pha                                     ;C36975
	stx $00                                 ;C36976
	phy                                     ;C36978
	jsl HandleCharacterDeath                             ;C36979
	ply                                     ;C3697D
	sty $00                                 ;C3697E
	jsl $C210AC                             ;C36980
	lda $01                                 ;C36984
	pha                                     ;C36986
	lda $00                                 ;C36987
	pha                                     ;C36989
	lda #$03                                ;C3698A
@lbl_C3698C:
	pha                                     ;C3698C
	lda $02,s                               ;C3698D
	sta $00                                 ;C3698F
	lda $03,s                               ;C36991
	sta $01                                 ;C36993
	jsl $C3631A                             ;C36995
	ldx $00                                 ;C36999
	ldy $01                                 ;C3699B
	bmi @lbl_C369D5                         ;C3699D
	jsl $C3F65F                             ;C3699F
	lda $00                                 ;C369A3
	and #$07                                ;C369A5
	sta $02                                 ;C369A7
	stx $00                                 ;C369A9
	sty $01                                 ;C369AB
	lda $05,s                               ;C369AD
	sta $03                                 ;C369AF
	lda $04,s                               ;C369B1
	sta $04                                 ;C369B3
	phx                                     ;C369B5
	phy                                     ;C369B6
	jsl $C20086                             ;C369B7
	ply                                     ;C369BB
	plx                                     ;C369BC
	lda $00                                 ;C369BD
	bmi @lbl_C369D5                         ;C369BF
	pha                                     ;C369C1
	phx                                     ;C369C2
	phy                                     ;C369C3
	jsl $C27FAA                             ;C369C4
	ply                                     ;C369C8
	plx                                     ;C369C9
	pla                                     ;C369CA
	stx $00                                 ;C369CB
	sty $01                                 ;C369CD
	sta $02                                 ;C369CF
	jsl $C35B7A                             ;C369D1
@lbl_C369D5:
	pla                                     ;C369D5
	dec a                                   ;C369D6
	bpl @lbl_C3698C                         ;C369D7
	pla                                     ;C369D9
	pla                                     ;C369DA
	pla                                     ;C369DB
	pla                                     ;C369DC
	plp                                     ;C369DD
	rtl                                     ;C369DE
	php                                     ;C369DF
	sep #$20                                ;C369E0
	lda $7EC178                             ;C369E2
	sta $00                                 ;C369E4
	plp                                     ;C369E6
	rtl                                     ;C369E7
	php                                     ;C369E8
	sep #$30                                ;C369E9
	lda $7EBE8E                             ;C369EB
	.db $D0,$0C   ;C369F1
	lda #$5C                                ;C369F3
	sta $00                                 ;C369F5
	stz $01                                 ;C369F7
.INDEX 16
	jsl.l DisplayMessage
	plp                                     ;C369FD
	rtl                                     ;C369FE
@lbl_C369FF:
	lda #$13                                ;C369FF
	sta $00                                 ;C36A01
	jsl $C210AC                             ;C36A03
	jsl $C36CA5                             ;C36A07
	lda $00                                 ;C36A0B
	bit #$10                                ;C36A0D
	bne @lbl_C36A2A                         ;C36A0F
	and #$0F                                ;C36A11
	tax                                     ;C36A13
	lda $7EC166,x                           ;C36A14
	bit #$08                                ;C36A18
	bne @lbl_C36A76                         ;C36A1A
	bit #$20                                ;C36A1C
	beq @lbl_C36A31                         ;C36A1E
@lbl_C36A20:
	lda #$13                                ;C36A20
	sta $00                                 ;C36A22
	jsl $C24390                             ;C36A24
	bra @lbl_C369FF                         ;C36A28
@lbl_C36A2A:
	cmp #$10                                ;C36A2A
	bne @lbl_C36A20                         ;C36A2C
	jsr $6A78                               ;C36A2E
@lbl_C36A31:
	ldy #$8412                              ;C36A31
	.db $00   ;C36A34
	phx                                     ;C36A35
	phy                                     ;C36A36
	jsl $C24373                             ;C36A37
	ply                                     ;C36A3B
	plx                                     ;C36A3C
	lda $00                                 ;C36A3D
	bne @lbl_C36A4B                         ;C36A3F
	sty $00                                 ;C36A41
	phx                                     ;C36A43
	phy                                     ;C36A44
	jsl HandleCharacterDeath                             ;C36A45
	ply                                     ;C36A49
	plx                                     ;C36A4A
@lbl_C36A4B:
	dey                                     ;C36A4B
	.db $10,$E5   ;C36A4C
	txy                                     ;C36A4E
	ldx #$BF09                              ;C36A4F
	ror $C1                                 ;C36A52
	ror $F729,x                             ;C36A54
	sta $7EC166,x                           ;C36A57
	dex                                     ;C36A5B
	.db $10,$F3   ;C36A5C
	lda #$00                                ;C36A5E
	sta $7EC176                             ;C36A60
	tya                                     ;C36A64
	sta $7EC175                             ;C36A65
	jsr $99F2                               ;C36A69
	lda #$FF                                ;C36A6C
	sta $7EBE64                             ;C36A6E
	jsl $C35C9A                             ;C36A72
@lbl_C36A76:
	plp                                     ;C36A76
	rtl                                     ;C36A77
	lda #$13                                ;C36A78
	sta $00                                 ;C36A7A
	jsl $C210AC                             ;C36A7C
	lda $7EBE8E                             ;C36A80
	tax                                     ;C36A84
@lbl_C36A85:
	dex                                     ;C36A85
	lda $7EBE66,x                           ;C36A86
	cmp $00                                 ;C36A8A
	bcs @lbl_C36A85                         ;C36A8C
	lda $00                                 ;C36A8E
	cmp $7EBE7A,x                           ;C36A90
	bcs @lbl_C36A85                         ;C36A94
	lda $7EBE70,x                           ;C36A96
	cmp $01                                 ;C36A9A
	bcs @lbl_C36A85                         ;C36A9C
	lda $01                                 ;C36A9E
	cmp $7EBE84,x                           ;C36AA0
	bcs @lbl_C36A85                         ;C36AA4
	stx $00                                 ;C36AA6
	phx                                     ;C36AA8
	jsl $C390D7                             ;C36AA9
	plx                                     ;C36AAD
	phx                                     ;C36AAE
	jsl $C371AB                             ;C36AAF
	plx                                     ;C36AB3
	stx $00                                 ;C36AB4
	lda #$04                                ;C36AB6
	sta $01                                 ;C36AB8
	jsr $6ABE                               ;C36ABA
	rts                                     ;C36ABD
	php                                     ;C36ABE
	sep #$30                                ;C36ABF
	ldx $00                                 ;C36AC1
	lda $01                                 ;C36AC3
	eor #$FF                                ;C36AC5
	and $7EC166,x                           ;C36AC7
	sta $7EC166,x                           ;C36ACB
	plp                                     ;C36ACF
	rts                                     ;C36AD0
	php                                     ;C36AD1
	sep #$30                                ;C36AD2
	ldy #$00                                ;C36AD4
	lda $7EBE8E                             ;C36AD6
	tax                                     ;C36ADA
@lbl_C36ADB:
	dex                                     ;C36ADB
	bmi @lbl_C36AE8                         ;C36ADC
	lda $7EC166,x                           ;C36ADE
	bit #$40                                ;C36AE2
	beq @lbl_C36ADB                         ;C36AE4
	bra @lbl_C36B15                         ;C36AE6
@lbl_C36AE8:
	lda $7EBE8E                             ;C36AE8
	tax                                     ;C36AEC
@lbl_C36AED:
	dex                                     ;C36AED
	bmi @lbl_C36AFB                         ;C36AEE
	lda $7EC166,x                           ;C36AF0
	bit #$10                                ;C36AF4
	beq @lbl_C36AED                         ;C36AF6
	iny                                     ;C36AF8
	bra @lbl_C36B15                         ;C36AF9
@lbl_C36AFB:
	lda $7EBE8E                             ;C36AFB
	tax                                     ;C36AFF
@lbl_C36B00:
	dex                                     ;C36B00
	bmi @lbl_C36B0D                         ;C36B01
	lda $7EC166,x                           ;C36B03
	bit #$20                                ;C36B07
	beq @lbl_C36B00                         ;C36B09
	bra @lbl_C36B15                         ;C36B0B
@lbl_C36B0D:
	lda #$FF                                ;C36B0D
	sta $00                                 ;C36B0F
	sta $01                                 ;C36B11
	bra @lbl_C36B47                         ;C36B13
@lbl_C36B15:
	lda $7EBE66,x                           ;C36B15
	inc a                                   ;C36B19
	sta $00                                 ;C36B1A
	lda $7EBE70,x                           ;C36B1C
	inc a                                   ;C36B20
	sta $01                                 ;C36B21
	lda $7EBE7A,x                           ;C36B23
	dec a                                   ;C36B27
	sta $02                                 ;C36B28
	lda $7EBE84,x                           ;C36B2A
	dec a                                   ;C36B2E
	sta $03                                 ;C36B2F
	tya                                     ;C36B31
	beq @lbl_C36B44                         ;C36B32
	inc $00                                 ;C36B34
	inc $00                                 ;C36B36
	inc $01                                 ;C36B38
	inc $01                                 ;C36B3A
	dec $02                                 ;C36B3C
	dec $02                                 ;C36B3E
	dec $03                                 ;C36B40
	dec $03                                 ;C36B42
@lbl_C36B44:
	jsr $6B49                               ;C36B44
@lbl_C36B47:
	plp                                     ;C36B47
	rtl                                     ;C36B48
	lda $00                                 ;C36B49
	pha                                     ;C36B4B
	lda $01                                 ;C36B4C
	pha                                     ;C36B4E
	lda $02                                 ;C36B4F
	pha                                     ;C36B51
	lda $03                                 ;C36B52
	pha                                     ;C36B54
	lda #$09                                ;C36B55
	sta $06                                 ;C36B57
@lbl_C36B59:
	lda $04,s                               ;C36B59
	sta $00                                 ;C36B5B
	lda $02,s                               ;C36B5D
	sta $01                                 ;C36B5F
	lda $06                                 ;C36B61
	pha                                     ;C36B63
	jsl $C3F69F                             ;C36B64
	pla                                     ;C36B68
	sta $06                                 ;C36B69
	ldx $00                                 ;C36B6B
	lda $03,s                               ;C36B6D
	sta $00                                 ;C36B6F
	lda $01,s                               ;C36B71
	sta $01                                 ;C36B73
	lda $06                                 ;C36B75
	pha                                     ;C36B77
	phx                                     ;C36B78
	jsl $C3F69F                             ;C36B79
	plx                                     ;C36B7D
	pla                                     ;C36B7E
	sta $06                                 ;C36B7F
	ldy $00                                 ;C36B81
	stx $00                                 ;C36B83
	sty $01                                 ;C36B85
	phx                                     ;C36B87
	jsl $C359AF                             ;C36B88
	plx                                     ;C36B8C
	lda $02                                 ;C36B8D
	bit #$80                                ;C36B8F
	bne @lbl_C36B9F                         ;C36B91
	lda $00                                 ;C36B93
	cmp #$80                                ;C36B95
	bne @lbl_C36B9F                         ;C36B97
	lda $01                                 ;C36B99
	cmp #$80                                ;C36B9B
	beq @lbl_C36BA7                         ;C36B9D
@lbl_C36B9F:
	dec $06                                 ;C36B9F
	bpl @lbl_C36B59                         ;C36BA1
	ldx #$FF                                ;C36BA3
	ldy #$FF                                ;C36BA5
@lbl_C36BA7:
	stx $00                                 ;C36BA7
	sty $01                                 ;C36BA9
	pla                                     ;C36BAB
	pla                                     ;C36BAC
	pla                                     ;C36BAD
	pla                                     ;C36BAE
	rts                                     ;C36BAF
.INDEX 16

func_C36BB0:
	php
	sep #$20 ;A->8
	lda.l wMapNum
	sta.b wTemp00
	stz.b wTemp01
	plp
	rtl

func_C36BBD:
	php
	sep #$20 ;A->8
	lda.b wTemp01
	xba
	lda.b wTemp00
	asl a
	asl a
	rep #$30 ;AXY->16
	lsr a
	lsr a
	tay
	plp
	rtl

func_C36BCE:
	php
	rep #$30 ;AXY->16
	tya
	asl a
	asl a
	sep #$20 ;A->8
	lsr a
	lsr a
	sta.b wTemp00
	xba
	sta.b wTemp01
	plp
	rtl

func_C36BDF:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	rep #$10 ;XY->16
	lda.w $BE70,y
@lbl_C36BED:
	xba
	lda.b #$00
	rep #$20 ;A->16
	lsr a
	lsr a
	sep #$20 ;A->8
	tax
	lda.b #$80
	sta.w $B41B,x
	txa
	ora.w $BE66,y
	tax
@lbl_C36C01:
	lda.w $B3DF,x
	bit.b #$01
	bne @lbl_C36C0D
	ora.b #$81
	sta.w $B3DF,x
@lbl_C36C0D:
	lda.w $945F,x
	bmi @lbl_C36C1E
	sta.b wTemp00
	phx
	phy
	call_savebank func_C27DE4
	ply
	plx
@lbl_C36C1E:
	inx
	txa
	and.b #$3F
	cmp.w $BE7A,y
	bcc @lbl_C36C01
	beq @lbl_C36C01
	rep #$20 ;A->16
	txa
	asl a
	asl a
	sep #$20 ;A->8
	xba
	inc a
	cmp.w $BE84,y
	bcc @lbl_C36BED
	beq @lbl_C36BED
	plp
	rtl
	phx                                     ;C36C3B
	phy                                     ;C36C3C
	php                                     ;C36C3D
	sep #$30                                ;C36C3E
	lda $02                                 ;C36C40
	inc a                                   ;C36C42
	pha                                     ;C36C43
	lda $01                                 ;C36C44
	bpl @lbl_C36C4C                         ;C36C46
	lda $03                                 ;C36C48
	sta $01                                 ;C36C4A
@lbl_C36C4C:
	ldx $00                                 ;C36C4C
	ldy $01                                 ;C36C4E
@lbl_C36C50:
	txa                                     ;C36C50
	cmp $01,s                               ;C36C51
	bcs @lbl_C36C63                         ;C36C53
	stx $00                                 ;C36C55
	sty $01                                 ;C36C57
	jsr $A114                               ;C36C59
	lda $00                                 ;C36C5C
	bne @lbl_C36C67                         ;C36C5E
	inx                                     ;C36C60
	bra @lbl_C36C50                         ;C36C61
@lbl_C36C63:
	ldx #$FF                                ;C36C63
	ldy #$FF                                ;C36C65
@lbl_C36C67:
	stx $00                                 ;C36C67
	sty $01                                 ;C36C69
	pla                                     ;C36C6B
	plp                                     ;C36C6C
	ply                                     ;C36C6D
	plx                                     ;C36C6E
	rts                                     ;C36C6F
	phx                                     ;C36C70
	phy                                     ;C36C71
	php                                     ;C36C72
	sep #$30                                ;C36C73
	lda $03                                 ;C36C75
	inc a                                   ;C36C77
	pha                                     ;C36C78
	lda $00                                 ;C36C79
	bpl @lbl_C36C81                         ;C36C7B
	lda $02                                 ;C36C7D
	sta $00                                 ;C36C7F
@lbl_C36C81:
	ldx $00                                 ;C36C81
	ldy $01                                 ;C36C83
@lbl_C36C85:
	tya                                     ;C36C85
	cmp $01,s                               ;C36C86
	bcs @lbl_C36C98                         ;C36C88
	stx $00                                 ;C36C8A
	sty $01                                 ;C36C8C
	jsr $A114                               ;C36C8E
	lda $00                                 ;C36C91
	bne @lbl_C36C9C                         ;C36C93
	iny                                     ;C36C95
	bra @lbl_C36C85                         ;C36C96
@lbl_C36C98:
	ldx #$FF                                ;C36C98
	ldy #$FF                                ;C36C9A
@lbl_C36C9C:
	stx $00                                 ;C36C9C
	sty $01                                 ;C36C9E
	pla                                     ;C36CA0
	plp                                     ;C36CA1
	ply                                     ;C36CA2
	plx                                     ;C36CA3
	rts                                     ;C36CA4
.INDEX 16

func_C36CA5:
	php
	sep #$20 ;A->8
	lda.b wTemp01
	xba
	lda.b wTemp00
	asl a
	asl a
	rep #$30 ;AXY->16
	lsr a
	lsr a
	tax
	sep #$20 ;A->8
	lda.l $7EA95F,x
	sta.b wTemp00
	plp
	rtl

func_C36CBE:
	php
	sep #$20 ;A->8
	lda.b wTemp01
	xba
	lda.b wTemp00
	asl a
	asl a
	rep #$30 ;AXY->16
	lsr a
	lsr a
	tax
	sep #$20 ;A->8
	lda.b wTemp02
	sta.l $7EA95F,x
	plp
	rtl

func_C36CD7:
	ldx.w $BE8F
	lda.b wTemp00
	sta.w $BE90,x
	lda.b wTemp01
	sta.w $BF90,x
	inc.w $BE8F
	rts

func_C36CE8:
	lda.w $BE8F
	bne @lbl_C36CEF
	clc
	rts
@lbl_C36CEF:
	dec.w $BE8F
	stz.b $00
	lda.w $BE8F
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	ldx.b wTemp00
	ldy.w $BE8F
	lda.w $BE90,x
	sta.w $C090
	lda.w $BE90,y
	sta.w $BE90,x
	lda.w $BF90,x
	sta.w $C091
	lda.w $BF90,y
	sta.w $BF90,x
	sec 
	rts

func_C36D1D:
	php 
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b wTemp00
	lda.w $C166,x
	ora.b #$04
	sta.w $C166,x
	lda.w $BE66,x
	inc a
	pha
	lda.w $BE70,x
	inc a
	pha
	lda.w $BE7A,x
	dec a
	pha
	lda.w $BE84,x
	dec a
	pha
	stz.w $BE8F
	lda.b $04,s
	sta.b wTemp00
	lda.b $03,s
	sta.b wTemp01
	lda.b $02,s
	sta.b wTemp02
	lda.b $01,s
	sta.b wTemp03
	lda.b #$10
	sta.b wTemp04
	jsl.l func_C36053
	lda.b $04,s
	inc a
	tax
@lbl_C36D61:
	txa 
	cmp.b $02,s
	bcs @lbl_C36D82
	stx.b wTemp00
	lda.b $03,s
	dec a
	sta.b wTemp01
	phx
	jsr.w func_C36CD7
	plx
	stx.b wTemp00
	lda.b $01,s
	inc a
	sta.b wTemp01
	phx
	jsr.w func_C36CD7
	plx
	inx 
	inx 
	bra @lbl_C36D61
@lbl_C36D82:
	lda.b $03,s
	inc a
	tay
@lbl_C36D86:
	tya 
	cmp.b $01,s
	bcs @lbl_C36DA3
	lda.b $04,s
	dec a
	sta.b wTemp00
	sty.b wTemp01
	jsr.w func_C36CD7
	lda.b $02,s
	inc a
	sta.b wTemp00
	sty.b wTemp01
	jsr.w func_C36CD7
	iny 
	iny 
	bra @lbl_C36D86
@lbl_C36DA3:
	pla
	pla
	pla
	pla
@lbl_C36DA7:
	jsr.w func_C36CE8
	bcs @lbl_C36DAE
	plp 
	rts
@lbl_C36DAE:
	stz.b wTemp00
	lda.b #$17
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	asl a
	asl a
	tay 
	lda.b #$03
@lbl_C36DBF:
	pha
	tya 
	clc 
	adc.b $01,s
	tax 
	lda.l Data_c36e38+8,x
	tax 
	lda.w $C090
	clc 
	adc.l Data_c36e38,x
	sta.w $C092
	sta.b wTemp00
	lda.w $C091
	clc 
	adc.l Data_c36e38+4,x
	sta.w $C093
	sta.b wTemp01
	jsl.l func_C36CA5
	lda.b wTemp00
	cmp.b #$10
	bne @lbl_C36DF1
	pla
	bra @lbl_C36DF8
@lbl_C36DF1:
	pla
	dec a
	bpl @lbl_C36DBF
	brl @lbl_C36DA7
@lbl_C36DF8:
	lda.w $C090
	clc 
	adc.w $C092
	lsr a
	sta.b wTemp00
	lda.w $C091
	clc 
	adc.w $C093
	lsr a
	sta.b wTemp01
	lda.b #$E0
	sta.b wTemp02
	jsl.l func_C36CBE
	ldx.w $C092
	stx.w $C090
	stx.b wTemp00
	ldy.w $C093
	sty.w $C091
	sty.b wTemp01
	lda.b #$E0
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C36CD7
	brl @lbl_C36DAE

	
Data_c36e38:
	.db $02,$00,$FE,$00
	.db $00,$02,$00,$FE
	.db $00,$01,$02,$03,$00,$01,$03
	.db $02,$00,$02,$01,$03,$00,$02,$03,$01,$00,$03,$01,$02,$00,$03,$02
	.db $01,$01,$00,$02,$03,$01,$00,$03,$02,$01,$02,$00,$03,$01,$02,$03
	.db $00,$01,$03,$00,$02,$01,$03,$02,$00,$02,$00,$01,$03,$02,$00,$03
	.db $01,$02,$01,$00,$03,$02,$01,$03,$00,$02,$03,$00,$01,$02,$03,$01
	.db $00,$03,$00,$01,$02,$03,$00,$02,$01,$03,$01,$00,$02,$03,$01,$02
	.db $00,$03,$02,$00,$01,$03,$02,$01,$00

func_C36EA0:
	php
	sep #$30 ;AXY->8
	lda.l $7EBE8E
	cmp.b #$01
	bne @lbl_C36EAF
;C36EAB
	.db $A2,$FF,$80,$26
@lbl_C36EAF:
	tax
@lbl_C36EB0:
	dex
	bmi @lbl_C36ED5
	lda.l $7EBE7A,x
	sec
	sbc.l $7EBE66,x
	dec a
	cmp.b #$07
	bcc @lbl_C36EB0
	lsr a
	bcc @lbl_C36EB0
	.db $BF,$84,$BE,$7E,$38,$FF,$70,$BE,$7E,$3A,$C9,$07,$90,$DE,$4A,$90   ;C36EC4  
	.db $DB                               ;C36ED4
@lbl_C36ED5:
	stx.b wTemp00
	plp
	rts

func_C36ED9:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EBE66,x
	inc a
	pha
	lda.l $7EBE70,x
	inc a
	pha
	lda.l $7EBE7A,x
	dec a
	pha
	lda.l $7EBE84,x
	dec a
	pha
	lda.b $04,s
	tax
	lda.b $03,s
	dec a
	tay
	lda.b $02,s
	inc a
	sta.b wTemp06
@lbl_C36F02:
	txa
	cmp.b wTemp06
	bcs @lbl_C36F33
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C36F30
	stx.b wTemp00
	sty.b wTemp01
	lda.b #$30
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	stx.b wTemp00
	sty.b wTemp01
	inc.b wTemp01
	lda.b #$10
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
@lbl_C36F30:
	inx
	bra @lbl_C36F02
@lbl_C36F33:
	lda.b $04,s
	tax
	lda.b $01,s
	inc a
	tay
	lda.b $02,s
	inc a
	sta.b wTemp06
@lbl_C36F3F:
	txa
	cmp.b wTemp06
	bcs @lbl_C36F70
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C36F6D
	stx.b wTemp00
	sty.b wTemp01
	lda.b #$30
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	stx.b wTemp00
	sty.b wTemp01
	dec.b wTemp01
	lda.b #$10
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
@lbl_C36F6D:
	inx
	bra @lbl_C36F3F
@lbl_C36F70:
	lda.b $04,s
	dec a
	tax
	lda.b $03,s
	tay
	lda.b $01,s
	inc a
	sta.b wTemp06
@lbl_C36F7C:
	tya
	cmp.b wTemp06
	bcs @lbl_C36FAD
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C36FAA
	stx.b wTemp00
	sty.b wTemp01
	lda.b #$30
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	stx.b wTemp00
	inc.b $00
	sty.b wTemp01
	lda.b #$10
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
@lbl_C36FAA:
	iny
	bra @lbl_C36F7C
@lbl_C36FAD:
	lda.b $02,s
	inc a
	tax
	lda.b $03,s
	tay
	lda.b $01,s
	inc a
	sta.b wTemp06
@lbl_C36FB9:
	tya
	cmp.b wTemp06
	bcs @lbl_C36FEA
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C36FE7
	stx.b wTemp00
	sty.b wTemp01
	lda.b #$30
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	stx.b wTemp00
	dec.b $00
	sty.b wTemp01
	lda.b #$10
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
@lbl_C36FE7:
	iny
	bra @lbl_C36FB9
@lbl_C36FEA:
	pla
	pla
	pla
	pla
	plp
	rts

func_C36FF0:
	php
	sep #$20 ;A->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C37007
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$11
	bcc @lbl_C37018
@lbl_C37007:
	jsr.w func_C36EA0
	lda.b wTemp00
	bmi @lbl_C37018
	pha                                     ;C3700E
	jsr $6D1D                               ;C3700F
	pla                                     ;C37012
	sta $00                                 ;C37013
	jsr $6ED9                               ;C37015
@lbl_C37018:
	plp
	rts

func_C3701A:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EBE84,x
	pha
	lda.l $7EBE7A,x
	pha
	lda.l $7EBE70,x
	inc a
	pha
	lda.l $7EBE66,x
	inc a
	tax
@lbl_C37035:
	lda.b wTemp01,s
	tay
	txa
	cmp.b wTemp02,s
	bcs @lbl_C3705E
@lbl_C3703D:
	tya
	cmp.b wTemp03,s
	bcs @lbl_C3705B
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp00
	bmi @lbl_C37058
	phx
	phy
	jsl.l func_C27DE4
	ply
	plx
@lbl_C37058:
	iny
	bra @lbl_C3703D
@lbl_C3705B:
	inx
	bra @lbl_C37035
@lbl_C3705E:
	pla
	pla
	pla
	plp
	rtl
	php                                     ;C37063
	sep #$30                                ;C37064
	ldx $00                                 ;C37066
	lda $7EBE84,x                           ;C37068
	pha                                     ;C3706C
	lda $7EBE7A,x                           ;C3706D
	pha                                     ;C37071
	lda $7EBE70,x                           ;C37072
	inc a                                   ;C37076
	pha                                     ;C37077
	lda $7EBE66,x                           ;C37078
	inc a                                   ;C3707C
	tax                                     ;C3707D
@lbl_C3707E:
	lda $01,s                               ;C3707E
	tay                                     ;C37080
	txa                                     ;C37081
	cmp $02,s                               ;C37082
	bcs @lbl_C370A7                         ;C37084
@lbl_C37086:
	tya                                     ;C37086
	cmp $03,s                               ;C37087
	bcs @lbl_C370A4                         ;C37089
	stx $00                                 ;C3708B
	sty $01                                 ;C3708D
	phx                                     ;C3708F
	jsl $C359AF                             ;C37090
	plx                                     ;C37094
	lda $00                                 ;C37095
	bmi @lbl_C370A1                         ;C37097
	phx                                     ;C37099
	phy                                     ;C3709A
	jsl $C27FAA                             ;C3709B
	ply                                     ;C3709F
	plx                                     ;C370A0
@lbl_C370A1:
	iny                                     ;C370A1
	bra @lbl_C37086                         ;C370A2
@lbl_C370A4:
	inx                                     ;C370A4
	bra @lbl_C3707E                         ;C370A5
@lbl_C370A7:
	pla                                     ;C370A7
	pla                                     ;C370A8
	pla                                     ;C370A9
	plp                                     ;C370AA
	rtl                                     ;C370AB

func_C370AC:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	asl a
	asl a
	pha
	ldx.b wTemp00
	lda.l $7EBE66,x
	pha
	lda.l $7EBE70,x
	pha
	lda.l $7EBE7A,x
	pha
	lda.l $7EBE84,x
	pha
	lda.b #$FF
	sta.b wTemp06
	lda.b wTemp04,s
	inc a
	tax
	lda.b wTemp03,s
	tay
	lda.b wTemp02,s
	sta.b wTemp04
@lbl_C370DA:
	txa
	cmp.b wTemp04
	bcs @lbl_C37101
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C370FE
	inc.b wTemp06
	lda.b wTemp05,s
	ora.b wTemp06
	phx
	tax
	lda.b wTemp01,s
	sta.l $7EC094,x
	tya
	sta.l $7EC0E4,x
	plx
@lbl_C370FE:
	inx
	bra @lbl_C370DA
@lbl_C37101:
	lda.b wTemp04,s
	inc a
	tax
	lda.b wTemp01,s
	tay
	lda.b wTemp02,s
	sta.b wTemp04
@lbl_C3710C:
	txa
	cmp.b wTemp04
	bcs @lbl_C37133
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C37130
	inc.b wTemp06
	lda.b wTemp05,s
	ora.b wTemp06
	phx
	tax
	lda.b wTemp01,s
	sta.l $7EC094,x
	tya
	sta.l $7EC0E4,x
	plx
@lbl_C37130:
	inx
	bra @lbl_C3710C
@lbl_C37133:
	lda.b wTemp04,s
	tax
	lda.b wTemp03,s
	inc a
	tay
	lda.b wTemp01,s
	sta.b wTemp04
@lbl_C3713E:
	tya
	cmp.b wTemp04
	bcs @lbl_C37165
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C37162
	inc.b wTemp06
	lda.b wTemp05,s
	ora.b wTemp06
	phx
	tax
	lda.b wTemp01,s
	sta.l $7EC094,x
	tya
	sta.l $7EC0E4,x
	plx
@lbl_C37162:
	iny
	bra @lbl_C3713E
@lbl_C37165:
	lda.b wTemp02,s
	tax
	lda.b wTemp03,s
	inc a
	tay
	lda.b wTemp01,s
	sta.b wTemp04
@lbl_C37170:
	tya
	cmp.b wTemp04
	bcs @lbl_C37197
	stx.b wTemp00
	sty.b wTemp01
	jsr.w func_C3A114
	lda.b wTemp00
	beq @lbl_C37194
	inc.b wTemp06
	lda.b wTemp05,s
	ora.b wTemp06
	phx
	tax
	lda.b wTemp01,s
	sta.l $7EC094,x
	tya
	sta.l $7EC0E4,x
	plx
@lbl_C37194:
	iny
	bra @lbl_C37170
@lbl_C37197:
	lda.b wTemp05,s
	lsr a
	lsr a
	lsr a
	tax
	lda.b wTemp06
	inc a
	sta.l $7EC134,x
	pla
	pla
	pla
	pla
	pla
	plp
	rtl

func_C371AB:
	php
	sep #$30 ;AXY->8
	lda.l $7EBE8E
	dec a
	tax
@lbl_C371B4:
	stx.b wTemp00
	phx
	jsl.l func_C370AC
	plx
	dex
	bpl @lbl_C371B4
	plp
	rtl

func_C371C1:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EBE66,x
	inc a
	pha
	lda.l $7EBE70,x
	inc a
	pha
	lda.l $7EBE7A,x
	dec a
	pha
	lda.l $7EBE84,x
	dec a
	pha
	lda.b #$09
	sta.b wTemp06
@lbl_C371E2:
	lda.b wTemp04,s
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	lda.b wTemp06
	pha
	jsl.l GetRandomInRange
	pla
	sta.b wTemp06
	ldx.b wTemp00
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	lda.b wTemp06
	pha
	phx
	jsl.l GetRandomInRange
	plx
	pla
	sta.b wTemp06
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C37222
	lda.b wTemp01
	cmp.b #$80
	beq @lbl_C3722A
@lbl_C37222:
	dec.b wTemp06
	bpl @lbl_C371E2
;C37226
	.db $A2,$FF,$A0,$FF
@lbl_C3722A:
	stx.b wTemp00
	sty.b wTemp01
	pla
	pla
	pla
	pla
	plp
	rtl

func_C37234:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l $7EBE66,x
	inc a
	pha
	lda.l $7EBE70,x
	inc a
	pha
	lda.l $7EBE7A,x
	dec a
	pha
	lda.l $7EBE84,x
	dec a
	pha
	lda.b #$09
	sta.b wTemp06
@lbl_C37255:
	lda.b wTemp04,s
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	lda.b wTemp06
	pha
	jsl.l GetRandomInRange
	pla
	sta.b wTemp06
	ldx.b wTemp00
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	lda.b wTemp06
	pha
	phx
	jsl.l GetRandomInRange
	plx
	pla
	sta.b wTemp06
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C37295
	lda.b wTemp00
	cmp.b #$80
	beq @lbl_C3729D
@lbl_C37295:
	dec.b wTemp06
	bpl @lbl_C37255
;C37299
	.db $A2,$FF,$A0,$FF
@lbl_C3729D:
	stx.b wTemp00
	sty.b wTemp01
	pla
	pla
	pla
	pla
	plp
	rtl
	php                                     ;C372A7
	sep #$30                                ;C372A8
	jsl $C3F65F                             ;C372AA
	lda $00                                 ;C372AE
	and #$07                                ;C372B0
	tay                                     ;C372B2
	lda #$00                                ;C372B3
	sta $7EC170                             ;C372B5
@lbl_C372B9:
	tyx                                     ;C372B9
	lda $C372FB,x                           ;C372BA
	bmi @lbl_C372F2                         ;C372BE
	tax                                     ;C372C0
	lda $7E89C3,x                           ;C372C1
	bit #$02                                ;C372C5
	beq @lbl_C372F8                         ;C372C7
	bit #$04                                ;C372C9
	beq @lbl_C372F8                         ;C372CB
	lda $7E89C4,x                           ;C372CD
	bit #$04                                ;C372D1
	beq @lbl_C372F8                         ;C372D3
	bit #$08                                ;C372D5
	beq @lbl_C372F8                         ;C372D7
	lda $7E89D3,x                           ;C372D9
	bit #$02                                ;C372DD
	beq @lbl_C372F8                         ;C372DF
	bit #$01                                ;C372E1
	beq @lbl_C372F8                         ;C372E3
	lda $7E89D4,x                           ;C372E5
	bit #$08                                ;C372E9
	beq @lbl_C372F8                         ;C372EB
	bit #$01                                ;C372ED
	beq @lbl_C372F8                         ;C372EF
	txa                                     ;C372F1
@lbl_C372F2:
	sta $7EC171                             ;C372F2
	plp                                     ;C372F6
	rts                                     ;C372F7
@lbl_C372F8:
	iny                                     ;C372F8
	bra @lbl_C372B9                         ;C372F9
	ora ($12),y                             ;C372FB
	ora ($14,s),y                           ;C372FD
	and ($22,x)                             ;C372FF
	and $24,s                               ;C37301
	ora ($12),y                             ;C37303
	ora ($14,s),y                           ;C37305
	and ($22,x)                             ;C37307
	and $24,s                               ;C37309
	sbc $30E208,x                           ;C3730B
	lda $7EC171                             ;C3730F
	bpl @lbl_C37319                         ;C37313
	lda #$00                                ;C37315
	bra @lbl_C37376                         ;C37317
@lbl_C37319:
	tax                                     ;C37319
	lda $7E8A33,x                           ;C3731A
	bmi @lbl_C3732C                         ;C3731E
	cmp $7E8A34,x                           ;C37320
	beq @lbl_C3735E                         ;C37324
	cmp $7E8A43,x                           ;C37326
	beq @lbl_C3736C                         ;C3732A
@lbl_C3732C:
	lda $7E8A44,x                           ;C3732C
	bmi @lbl_C3733E                         ;C37330
	cmp $7E8A43,x                           ;C37332
	beq @lbl_C37368                         ;C37336
	cmp $7E8A34,x                           ;C37338
	beq @lbl_C37370                         ;C3733C
@lbl_C3733E:
	lda $7E8A33,x                           ;C3733E
	bpl @lbl_C3735A                         ;C37342
	lda $7E8A34,x                           ;C37344
	bpl @lbl_C3735A                         ;C37348
	lda $7E8A43,x                           ;C3734A
	bpl @lbl_C3735A                         ;C3734E
	lda $7E8A44,x                           ;C37350
	bpl @lbl_C3735A                         ;C37354
	lda #$00                                ;C37356
	bra @lbl_C37376                         ;C37358
@lbl_C3735A:
	lda #$01                                ;C3735A
	bra @lbl_C37376                         ;C3735C
@lbl_C3735E:
	cmp $7E8A43,x                           ;C3735E
	beq @lbl_C37374                         ;C37362
	lda #$02                                ;C37364
	bra @lbl_C37376                         ;C37366
@lbl_C37368:
	lda #$03                                ;C37368
	bra @lbl_C37376                         ;C3736A
@lbl_C3736C:
	lda #$04                                ;C3736C
	bra @lbl_C37376                         ;C3736E
@lbl_C37370:
	lda #$05                                ;C37370
	bra @lbl_C37376                         ;C37372
@lbl_C37374:
	lda #$00                                ;C37374
@lbl_C37376:
	sta $00                                 ;C37376
	stz $01                                 ;C37378
	plp                                     ;C3737A
	rts                                     ;C3737B

func_C3737C:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C37399
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$11
	bcc @lbl_C373B9
	cmp.b #$15
	bcs @lbl_C373B9
@lbl_C37399:
	rep #$20                                ;C37399
	ldy #$0005                              ;C3739B
@lbl_C3739E:
	dey                                     ;C3739E
	.db $30,$18   ;C3739F
	phy                                     ;C373A1
	jsr $72A7                               ;C373A2
	jsr $730C                               ;C373A5
	ply                                     ;C373A8
	lda $00                                 ;C373A9
	beq @lbl_C3739E                         ;C373AB
	dec a                                   ;C373AD
	asl a                                   ;C373AE
	tax                                     ;C373AF
	lda $C373BB,x                           ;C373B0
	pea $73B8                               ;C373B4
	pha                                     ;C373B7
	rts                                     ;C373B8
.ACCU 8
@lbl_C373B9:
	plp
	rts
	cpy $73                                 ;C373BB
	ldx $7A                                 ;C373BD
	eor $177B,x                             ;C373BF
	jmp ($7CCF,x)                           ;C373C2
	php                                     ;C373C5
	sep #$30                                ;C373C6
	jsl $C3F65F                             ;C373C8
	lda $00                                 ;C373CC
	and #$03                                ;C373CE
	tay                                     ;C373D0
@lbl_C373D1:
	tyx                                     ;C373D1
	lda $7EC171                             ;C373D2
	clc                                     ;C373D6
	adc $C37409,x                           ;C373D7
	tax                                     ;C373DB
	lda $7E8A33,x                           ;C373DC
	bpl @lbl_C373E5                         ;C373E0
	iny                                     ;C373E2
	bra @lbl_C373D1                         ;C373E3
@lbl_C373E5:
	rep #$30                                ;C373E5
	jsl $C3F65F                             ;C373E7
	lda $00                                 ;C373EB
	and #$0001                              ;C373ED
	tax                                     ;C373F0
	tya                                     ;C373F1
	and #$0003                              ;C373F2
	asl a                                   ;C373F5
	dex                                     ;C373F6
	bmi @lbl_C373FD                         ;C373F7
	clc                                     ;C373F9
	adc #$0008                              ;C373FA
@lbl_C373FD:
	tax                                     ;C373FD
	lda $C37411,x                           ;C373FE
	pea $7406                               ;C37402
	pha                                     ;C37405
	rts                                     ;C37406
	plp                                     ;C37407
	rts                                     ;C37408
	.db $00   ;C37409
	ora ($10,x)                             ;C3740A
	ora ($00),y                             ;C3740C
	ora ($10,x)                             ;C3740E
	ora ($20),y                             ;C37410
	stz $EE,x                               ;C37412
	stz $BD,x                               ;C37414
	adc $8E,x                               ;C37416
	ror $5F,x                               ;C37418
	adc [$2F],y                             ;C3741A
	sei                                     ;C3741C
	.db $00   ;C3741D
	adc $79D3,y                             ;C3741E
	php                                     ;C37421
	sep #$30                                ;C37422
	lda $7EC171                             ;C37424
	pha                                     ;C37428
	tax                                     ;C37429
	lda $7E8A33,x                           ;C3742A
	tax                                     ;C3742E
	lda $7EC166,x                           ;C3742F
	cmp #$00                                ;C37433
	beq @lbl_C3743A                         ;C37435
	pla                                     ;C37437
	plp                                     ;C37438
	rts                                     ;C37439
@lbl_C3743A:
	lda $7EBE7A,x                           ;C3743A
	pha                                     ;C3743E
	lda $7EBE84,x                           ;C3743F
	pha                                     ;C37443
	lda $7EBE70,x                           ;C37444
	pha                                     ;C37448
	ldy #$04                                ;C37449
@lbl_C3744B:
	lda $04,s                               ;C3744B
	sta $00                                 ;C3744D
	jsr $7D89                               ;C3744F
	lda #$FF                                ;C37452
	sta $01                                 ;C37454
	lda $02,s                               ;C37456
	sta $03                                 ;C37458
	jsr $6C3B                               ;C3745A
	lda $00                                 ;C3745D
	inc a                                   ;C3745F
	tax                                     ;C37460
	lda $04,s                               ;C37461
	sta $00                                 ;C37463
	jsr $7D89                               ;C37465
	lda #$FF                                ;C37468
	sta $00                                 ;C3746A
	lda $03,s                               ;C3746C
	sta $02                                 ;C3746E
	jsr $6C70                               ;C37470
	lda $00                                 ;C37473
	dec a                                   ;C37475
	dec a                                   ;C37476
	stx $00                                 ;C37477
	cmp $00                                 ;C37479
	bcc @lbl_C374E3                         ;C3747B
	sta $01                                 ;C3747D
	phy                                     ;C3747F
	jsl $C3F69F                             ;C37480
	ply                                     ;C37484
	ldx $00                                 ;C37485
	lda $01,s                               ;C37487
	sta $01                                 ;C37489
	jsr $A114                               ;C3748B
	lda $00                                 ;C3748E
	bne @lbl_C374E9                         ;C37490
	stx $00                                 ;C37492
	lda $02,s                               ;C37494
	sta $01                                 ;C37496
	jsr $A114                               ;C37498
	lda $00                                 ;C3749B
	bne @lbl_C374E9                         ;C3749D
	stx $00                                 ;C3749F
	lda $01,s                               ;C374A1
	inc a                                   ;C374A3
	sta $01                                 ;C374A4
	lda $02,s                               ;C374A6
	dec a                                   ;C374A8
	sta $02                                 ;C374A9
	lda #$B0                                ;C374AB
	sta $03                                 ;C374AD
	phx                                     ;C374AF
	jsl $C3601D                             ;C374B0
	plx                                     ;C374B4
	stx $00                                 ;C374B5
	lda $01,s                               ;C374B7
	inc a                                   ;C374B9
	sta $01                                 ;C374BA
	lda #$00                                ;C374BC
	sta $02                                 ;C374BE
	jsr $7EA4                               ;C374C0
	stx $00                                 ;C374C3
	lda $02,s                               ;C374C5
	dec a                                   ;C374C7
	sta $01                                 ;C374C8
	lda #$03                                ;C374CA
	sta $02                                 ;C374CC
	jsr $7EA4                               ;C374CE
	lda $04,s                               ;C374D1
	tax                                     ;C374D3
	lda $7E8A33,x                           ;C374D4
	tax                                     ;C374D8
	lda $7EC166,x                           ;C374D9
	ora #$80                                ;C374DD
	sta $7EC166,x                           ;C374DF
@lbl_C374E3:
	pla                                     ;C374E3
	pla                                     ;C374E4
	pla                                     ;C374E5
	pla                                     ;C374E6
	plp                                     ;C374E7
	rts                                     ;C374E8
@lbl_C374E9:
	dey                                     ;C374E9
	bmi @lbl_C374E3                         ;C374EA
	brl @lbl_C3744B                         ;C374EC
	php                                     ;C374EF
	sep #$30                                ;C374F0
	lda $7EC171                             ;C374F2
	inc a                                   ;C374F6
	pha                                     ;C374F7
	tax                                     ;C374F8
	lda $7E8A33,x                           ;C374F9
	tax                                     ;C374FD
	lda $7EC166,x                           ;C374FE
	cmp #$00                                ;C37502
	beq @lbl_C37509                         ;C37504
	pla                                     ;C37506
	plp                                     ;C37507
	rts                                     ;C37508
@lbl_C37509:
	lda $7EBE66,x                           ;C37509
	pha                                     ;C3750D
	lda $7EBE84,x                           ;C3750E
	pha                                     ;C37512
	lda $7EBE70,x                           ;C37513
	pha                                     ;C37517
	ldy #$04                                ;C37518
@lbl_C3751A:
	lda $04,s                               ;C3751A
	sta $00                                 ;C3751C
	jsr $7D89                               ;C3751E
	lda $03,s                               ;C37521
	sta $00                                 ;C37523
	lda #$FF                                ;C37525
	sta $02                                 ;C37527
	jsr $6C70                               ;C37529
	lda $00                                 ;C3752C
	inc a                                   ;C3752E
	inc a                                   ;C3752F
	tax                                     ;C37530
	lda $04,s                               ;C37531
	sta $00                                 ;C37533
	jsr $7D89                               ;C37535
	lda #$FF                                ;C37538
	sta $01                                 ;C3753A
	lda $02,s                               ;C3753C
	sta $03                                 ;C3753E
	jsr $6C3B                               ;C37540
	lda $00                                 ;C37543
	dec a                                   ;C37545
	stx $00                                 ;C37546
	cmp $00                                 ;C37548
	bcc @lbl_C375B2                         ;C3754A
	sta $01                                 ;C3754C
	phy                                     ;C3754E
	jsl $C3F69F                             ;C3754F
	ply                                     ;C37553
	ldx $00                                 ;C37554
	lda $01,s                               ;C37556
	sta $01                                 ;C37558
	jsr $A114                               ;C3755A
	lda $00                                 ;C3755D
	bne @lbl_C375B8                         ;C3755F
	stx $00                                 ;C37561
	lda $02,s                               ;C37563
	sta $01                                 ;C37565
	jsr $A114                               ;C37567
	lda $00                                 ;C3756A
	bne @lbl_C375B8                         ;C3756C
	stx $00                                 ;C3756E
	lda $01,s                               ;C37570
	inc a                                   ;C37572
	sta $01                                 ;C37573
	lda $02,s                               ;C37575
	dec a                                   ;C37577
	sta $02                                 ;C37578
	lda #$B0                                ;C3757A
	sta $03                                 ;C3757C
	phx                                     ;C3757E
	jsl $C3601D                             ;C3757F
	plx                                     ;C37583
	stx $00                                 ;C37584
	lda $01,s                               ;C37586
	inc a                                   ;C37588
	sta $01                                 ;C37589
	lda #$00                                ;C3758B
	sta $02                                 ;C3758D
	jsr $7EA4                               ;C3758F
	stx $00                                 ;C37592
	lda $02,s                               ;C37594
	dec a                                   ;C37596
	sta $01                                 ;C37597
	lda #$03                                ;C37599
	sta $02                                 ;C3759B
	jsr $7EA4                               ;C3759D
	lda $04,s                               ;C375A0
	tax                                     ;C375A2
	lda $7E8A33,x                           ;C375A3
	tax                                     ;C375A7
	lda $7EC166,x                           ;C375A8
	ora #$80                                ;C375AC
	sta $7EC166,x                           ;C375AE
@lbl_C375B2:
	pla                                     ;C375B2
	pla                                     ;C375B3
	pla                                     ;C375B4
	pla                                     ;C375B5
	plp                                     ;C375B6
	rts                                     ;C375B7
@lbl_C375B8:
	dey                                     ;C375B8
	bmi @lbl_C375B2                         ;C375B9
	brl @lbl_C3751A                         ;C375BB
	php                                     ;C375BE
	sep #$30                                ;C375BF
	lda $7EC171                             ;C375C1
	clc                                     ;C375C5
	adc #$10                                ;C375C6
	pha                                     ;C375C8
	tax                                     ;C375C9
	lda $7E8A33,x                           ;C375CA
	tax                                     ;C375CE
	lda $7EC166,x                           ;C375CF
	cmp #$00                                ;C375D3
	beq @lbl_C375DA                         ;C375D5
	pla                                     ;C375D7
	plp                                     ;C375D8
	rts                                     ;C375D9
@lbl_C375DA:
	lda $7EBE7A,x                           ;C375DA
	pha                                     ;C375DE
	lda $7EBE84,x                           ;C375DF
	pha                                     ;C375E3
	lda $7EBE70,x                           ;C375E4
	pha                                     ;C375E8
	ldy #$04                                ;C375E9
@lbl_C375EB:
	lda $04,s                               ;C375EB
	sta $00                                 ;C375ED
	jsr $7D89                               ;C375EF
	lda $01,s                               ;C375F2
	sta $01                                 ;C375F4
	lda #$FF                                ;C375F6
	sta $03                                 ;C375F8
	jsr $6C3B                               ;C375FA
	lda $00                                 ;C375FD
	inc a                                   ;C375FF
	tax                                     ;C37600
	lda $04,s                               ;C37601
	sta $00                                 ;C37603
	jsr $7D89                               ;C37605
	lda #$FF                                ;C37608
	sta $00                                 ;C3760A
	lda $03,s                               ;C3760C
	sta $02                                 ;C3760E
	jsr $6C70                               ;C37610
	lda $00                                 ;C37613
	dec a                                   ;C37615
	dec a                                   ;C37616
	stx $00                                 ;C37617
	cmp $00                                 ;C37619
	bcc @lbl_C37683                         ;C3761B
	sta $01                                 ;C3761D
	phy                                     ;C3761F
	jsl $C3F69F                             ;C37620
	ply                                     ;C37624
	ldx $00                                 ;C37625
	lda $01,s                               ;C37627
	sta $01                                 ;C37629
	jsr $A114                               ;C3762B
	lda $00                                 ;C3762E
	bne @lbl_C37689                         ;C37630
	stx $00                                 ;C37632
	lda $02,s                               ;C37634
	sta $01                                 ;C37636
	jsr $A114                               ;C37638
	lda $00                                 ;C3763B
	bne @lbl_C37689                         ;C3763D
	stx $00                                 ;C3763F
	lda $01,s                               ;C37641
	inc a                                   ;C37643
	sta $01                                 ;C37644
	lda $02,s                               ;C37646
	dec a                                   ;C37648
	sta $02                                 ;C37649
	lda #$B0                                ;C3764B
	sta $03                                 ;C3764D
	phx                                     ;C3764F
	jsl $C3601D                             ;C37650
	plx                                     ;C37654
	stx $00                                 ;C37655
	lda $01,s                               ;C37657
	inc a                                   ;C37659
	sta $01                                 ;C3765A
	lda #$00                                ;C3765C
	sta $02                                 ;C3765E
	jsr $7EA4                               ;C37660
	stx $00                                 ;C37663
	lda $02,s                               ;C37665
	dec a                                   ;C37667
	sta $01                                 ;C37668
	lda #$03                                ;C3766A
	sta $02                                 ;C3766C
	jsr $7EA4                               ;C3766E
	lda $04,s                               ;C37671
	tax                                     ;C37673
	lda $7E8A33,x                           ;C37674
	tax                                     ;C37678
	lda $7EC166,x                           ;C37679
	ora #$80                                ;C3767D
	sta $7EC166,x                           ;C3767F
@lbl_C37683:
	pla                                     ;C37683
	pla                                     ;C37684
	pla                                     ;C37685
	pla                                     ;C37686
	plp                                     ;C37687
	rts                                     ;C37688
@lbl_C37689:
	dey                                     ;C37689
	bmi @lbl_C37683                         ;C3768A
	brl @lbl_C375EB                         ;C3768C
	php                                     ;C3768F
	sep #$30                                ;C37690
	lda $7EC171                             ;C37692
	clc                                     ;C37696
	adc #$11                                ;C37697
	pha                                     ;C37699
	tax                                     ;C3769A
	lda $7E8A33,x                           ;C3769B
	tax                                     ;C3769F
	lda $7EC166,x                           ;C376A0
	cmp #$00                                ;C376A4
	beq @lbl_C376AB                         ;C376A6
	pla                                     ;C376A8
	plp                                     ;C376A9
	rts                                     ;C376AA
@lbl_C376AB:
	lda $7EBE66,x                           ;C376AB
	pha                                     ;C376AF
	lda $7EBE84,x                           ;C376B0
	pha                                     ;C376B4
	lda $7EBE70,x                           ;C376B5
	pha                                     ;C376B9
	ldy #$04                                ;C376BA
@lbl_C376BC:
	lda $04,s                               ;C376BC
	sta $00                                 ;C376BE
	jsr $7D89                               ;C376C0
	lda $03,s                               ;C376C3
	sta $00                                 ;C376C5
	lda #$FF                                ;C376C7
	sta $02                                 ;C376C9
	jsr $6C70                               ;C376CB
	lda $00                                 ;C376CE
	inc a                                   ;C376D0
	inc a                                   ;C376D1
	tax                                     ;C376D2
	lda $04,s                               ;C376D3
	sta $00                                 ;C376D5
	jsr $7D89                               ;C376D7
	lda $01,s                               ;C376DA
	sta $01                                 ;C376DC
	lda #$FF                                ;C376DE
	sta $03                                 ;C376E0
	jsr $6C3B                               ;C376E2
	lda $00                                 ;C376E5
	dec a                                   ;C376E7
	stx $00                                 ;C376E8
	cmp $00                                 ;C376EA
	bcc @lbl_C37754                         ;C376EC
	sta $01                                 ;C376EE
	phy                                     ;C376F0
	jsl $C3F69F                             ;C376F1
	ply                                     ;C376F5
	ldx $00                                 ;C376F6
	lda $01,s                               ;C376F8
	sta $01                                 ;C376FA
	jsr $A114                               ;C376FC
	lda $00                                 ;C376FF
	bne @lbl_C3775A                         ;C37701
	stx $00                                 ;C37703
	lda $02,s                               ;C37705
	sta $01                                 ;C37707
	jsr $A114                               ;C37709
	lda $00                                 ;C3770C
	bne @lbl_C3775A                         ;C3770E
	stx $00                                 ;C37710
	lda $01,s                               ;C37712
	inc a                                   ;C37714
	sta $01                                 ;C37715
	lda $02,s                               ;C37717
	dec a                                   ;C37719
	sta $02                                 ;C3771A
	lda #$B0                                ;C3771C
	sta $03                                 ;C3771E
	phx                                     ;C37720
	jsl $C3601D                             ;C37721
	plx                                     ;C37725
	stx $00                                 ;C37726
	lda $01,s                               ;C37728
	inc a                                   ;C3772A
	sta $01                                 ;C3772B
	lda #$00                                ;C3772D
	sta $02                                 ;C3772F
	jsr $7EA4                               ;C37731
	stx $00                                 ;C37734
	lda $02,s                               ;C37736
	dec a                                   ;C37738
	sta $01                                 ;C37739
	lda #$03                                ;C3773B
	sta $02                                 ;C3773D
	jsr $7EA4                               ;C3773F
	lda $04,s                               ;C37742
	tax                                     ;C37744
	lda $7E8A33,x                           ;C37745
	tax                                     ;C37749
	lda $7EC166,x                           ;C3774A
	ora #$80                                ;C3774E
	sta $7EC166,x                           ;C37750
@lbl_C37754:
	pla                                     ;C37754
	pla                                     ;C37755
	pla                                     ;C37756
	pla                                     ;C37757
	plp                                     ;C37758
	rts                                     ;C37759
@lbl_C3775A:
	dey                                     ;C3775A
	bmi @lbl_C37754                         ;C3775B
	brl @lbl_C376BC                         ;C3775D
	php                                     ;C37760
	sep #$30                                ;C37761
	lda $7EC171                             ;C37763
	pha                                     ;C37767
	tax                                     ;C37768
	lda $7E8A33,x                           ;C37769
	tax                                     ;C3776D
	lda $7EC166,x                           ;C3776E
	cmp #$00                                ;C37772
	beq @lbl_C37779                         ;C37774
	pla                                     ;C37776
	plp                                     ;C37777
	rts                                     ;C37778
@lbl_C37779:
	lda $7EBE84,x                           ;C37779
	pha                                     ;C3777D
	lda $7EBE7A,x                           ;C3777E
	pha                                     ;C37782
	lda $7EBE66,x                           ;C37783
	pha                                     ;C37787
	ldx #$04                                ;C37788
@lbl_C3778A:
	lda $04,s                               ;C3778A
	sta $00                                 ;C3778C
	jsr $7D89                               ;C3778E
	lda #$FF                                ;C37791
	sta $00                                 ;C37793
	lda $02,s                               ;C37795
	sta $02                                 ;C37797
	jsr $6C70                               ;C37799
	lda $01                                 ;C3779C
	inc a                                   ;C3779E
	tay                                     ;C3779F
	lda $04,s                               ;C377A0
	sta $00                                 ;C377A2
	jsr $7D89                               ;C377A4
	lda #$FF                                ;C377A7
	sta $01                                 ;C377A9
	lda $03,s                               ;C377AB
	sta $03                                 ;C377AD
	jsr $6C3B                               ;C377AF
	lda $01                                 ;C377B2
	dec a                                   ;C377B4
	dec a                                   ;C377B5
	sty $00                                 ;C377B6
	cmp $00                                 ;C377B8
	bcc @lbl_C37824                         ;C377BA
	sta $01                                 ;C377BC
	phx                                     ;C377BE
	jsl $C3F69F                             ;C377BF
	plx                                     ;C377C3
	ldy $00                                 ;C377C4
	sty $01                                 ;C377C6
	lda $01,s                               ;C377C8
	sta $00                                 ;C377CA
	jsr $A114                               ;C377CC
	lda $00                                 ;C377CF
	bne @lbl_C3782A                         ;C377D1
	sty $01                                 ;C377D3
	lda $02,s                               ;C377D5
	sta $00                                 ;C377D7
	jsr $A114                               ;C377D9
	lda $00                                 ;C377DC
	bne @lbl_C3782A                         ;C377DE
	lda $01,s                               ;C377E0
	inc a                                   ;C377E2
	sta $00                                 ;C377E3
	sty $01                                 ;C377E5
	lda $02,s                               ;C377E7
	dec a                                   ;C377E9
	sta $02                                 ;C377EA
	lda #$B0                                ;C377EC
	sta $03                                 ;C377EE
	phy                                     ;C377F0
	jsl $C35FE7                             ;C377F1
	ply                                     ;C377F5
	lda $01,s                               ;C377F6
	inc a                                   ;C377F8
	sta $00                                 ;C377F9
	sty $01                                 ;C377FB
	lda #$06                                ;C377FD
	sta $02                                 ;C377FF
	jsr $7EA4                               ;C37801
	lda $02,s                               ;C37804
	dec a                                   ;C37806
	sta $00                                 ;C37807
	sty $01                                 ;C37809
	lda #$09                                ;C3780B
	sta $02                                 ;C3780D
	jsr $7EA4                               ;C3780F
	lda $04,s                               ;C37812
	tax                                     ;C37814
	lda $7E8A33,x                           ;C37815
	tax                                     ;C37819
	lda $7EC166,x                           ;C3781A
	ora #$80                                ;C3781E
	sta $7EC166,x                           ;C37820
@lbl_C37824:
	pla                                     ;C37824
	pla                                     ;C37825
	pla                                     ;C37826
	pla                                     ;C37827
	plp                                     ;C37828
	rts                                     ;C37829
@lbl_C3782A:
	dex                                     ;C3782A
	bmi @lbl_C37824                         ;C3782B
	brl @lbl_C3778A                         ;C3782D
	php                                     ;C37830
	sep #$30                                ;C37831
	lda $7EC171                             ;C37833
	inc a                                   ;C37837
	pha                                     ;C37838
	tax                                     ;C37839
	lda $7E8A33,x                           ;C3783A
	tax                                     ;C3783E
	lda $7EC166,x                           ;C3783F
	cmp #$00                                ;C37843
	beq @lbl_C3784A                         ;C37845
	pla                                     ;C37847
	plp                                     ;C37848
	rts                                     ;C37849
@lbl_C3784A:
	lda $7EBE84,x                           ;C3784A
	pha                                     ;C3784E
	lda $7EBE7A,x                           ;C3784F
	pha                                     ;C37853
	lda $7EBE66,x                           ;C37854
	pha                                     ;C37858
	ldx #$04                                ;C37859
@lbl_C3785B:
	lda $04,s                               ;C3785B
	sta $00                                 ;C3785D
	jsr $7D89                               ;C3785F
	lda $01,s                               ;C37862
	sta $00                                 ;C37864
	lda #$FF                                ;C37866
	sta $02                                 ;C37868
	jsr $6C70                               ;C3786A
	lda $01                                 ;C3786D
	inc a                                   ;C3786F
	tay                                     ;C37870
	lda $04,s                               ;C37871
	sta $00                                 ;C37873
	jsr $7D89                               ;C37875
	lda #$FF                                ;C37878
	sta $01                                 ;C3787A
	lda $03,s                               ;C3787C
	sta $03                                 ;C3787E
	jsr $6C3B                               ;C37880
	lda $01                                 ;C37883
	dec a                                   ;C37885
	dec a                                   ;C37886
	sty $00                                 ;C37887
	cmp $00                                 ;C37889
	bcc @lbl_C378F5                         ;C3788B
	sta $01                                 ;C3788D
	phx                                     ;C3788F
	jsl $C3F69F                             ;C37890
	plx                                     ;C37894
	ldy $00                                 ;C37895
	sty $01                                 ;C37897
	lda $01,s                               ;C37899
	sta $00                                 ;C3789B
	jsr $A114                               ;C3789D
	lda $00                                 ;C378A0
	bne @lbl_C378FB                         ;C378A2
	sty $01                                 ;C378A4
	lda $02,s                               ;C378A6
	sta $00                                 ;C378A8
	jsr $A114                               ;C378AA
	lda $00                                 ;C378AD
	bne @lbl_C378FB                         ;C378AF
	lda $01,s                               ;C378B1
	inc a                                   ;C378B3
	sta $00                                 ;C378B4
	sty $01                                 ;C378B6
	lda $02,s                               ;C378B8
	dec a                                   ;C378BA
	sta $02                                 ;C378BB
	lda #$B0                                ;C378BD
	sta $03                                 ;C378BF
	phy                                     ;C378C1
	jsl $C35FE7                             ;C378C2
	ply                                     ;C378C6
	lda $01,s                               ;C378C7
	inc a                                   ;C378C9
	sta $00                                 ;C378CA
	sty $01                                 ;C378CC
	lda #$06                                ;C378CE
	sta $02                                 ;C378D0
	jsr $7EA4                               ;C378D2
	lda $02,s                               ;C378D5
	dec a                                   ;C378D7
	sta $00                                 ;C378D8
	sty $01                                 ;C378DA
	lda #$09                                ;C378DC
	sta $02                                 ;C378DE
	jsr $7EA4                               ;C378E0
	lda $04,s                               ;C378E3
	tax                                     ;C378E5
	lda $7E8A33,x                           ;C378E6
	tax                                     ;C378EA
	lda $7EC166,x                           ;C378EB
	ora #$80                                ;C378EF
	sta $7EC166,x                           ;C378F1
@lbl_C378F5:
	pla                                     ;C378F5
	pla                                     ;C378F6
	pla                                     ;C378F7
	pla                                     ;C378F8
	plp                                     ;C378F9
	rts                                     ;C378FA
@lbl_C378FB:
	dex                                     ;C378FB
	bmi @lbl_C378F5                         ;C378FC
	brl @lbl_C3785B                         ;C378FE
	php                                     ;C37901
	sep #$30                                ;C37902
	lda $7EC171                             ;C37904
	clc                                     ;C37908
	adc #$10                                ;C37909
	pha                                     ;C3790B
	tax                                     ;C3790C
	lda $7E8A33,x                           ;C3790D
	tax                                     ;C37911
	lda $7EC166,x                           ;C37912
	cmp #$00                                ;C37916
	beq @lbl_C3791D                         ;C37918
	pla                                     ;C3791A
	plp                                     ;C3791B
	rts                                     ;C3791C
@lbl_C3791D:
	lda $7EBE70,x                           ;C3791D
	pha                                     ;C37921
	lda $7EBE7A,x                           ;C37922
	pha                                     ;C37926
	lda $7EBE66,x                           ;C37927
	pha                                     ;C3792B
	ldx #$04                                ;C3792C
@lbl_C3792E:
	lda $04,s                               ;C3792E
	sta $00                                 ;C37930
	jsr $7D89                               ;C37932
	lda $03,s                               ;C37935
	sta $01                                 ;C37937
	lda #$FF                                ;C37939
	sta $03                                 ;C3793B
	jsr $6C3B                               ;C3793D
	lda $01                                 ;C37940
	inc a                                   ;C37942
	inc a                                   ;C37943
	tay                                     ;C37944
	lda $04,s                               ;C37945
	sta $00                                 ;C37947
	jsr $7D89                               ;C37949
	lda #$FF                                ;C3794C
	sta $00                                 ;C3794E
	lda $02,s                               ;C37950
	sta $02                                 ;C37952
	jsr $6C70                               ;C37954
	lda $01                                 ;C37957
	dec a                                   ;C37959
	sty $00                                 ;C3795A
	cmp $00                                 ;C3795C
	bcc @lbl_C379C8                         ;C3795E
	sta $01                                 ;C37960
	phx                                     ;C37962
	jsl $C3F69F                             ;C37963
	plx                                     ;C37967
	ldy $00                                 ;C37968
	sty $01                                 ;C3796A
	lda $01,s                               ;C3796C
	sta $00                                 ;C3796E
	jsr $A114                               ;C37970
	lda $00                                 ;C37973
	bne @lbl_C379CE                         ;C37975
	sty $01                                 ;C37977
	lda $02,s                               ;C37979
	sta $00                                 ;C3797B
	jsr $A114                               ;C3797D
	lda $00                                 ;C37980
	bne @lbl_C379CE                         ;C37982
	lda $01,s                               ;C37984
	inc a                                   ;C37986
	sta $00                                 ;C37987
	sty $01                                 ;C37989
	lda $02,s                               ;C3798B
	dec a                                   ;C3798D
	sta $02                                 ;C3798E
	lda #$B0                                ;C37990
	sta $03                                 ;C37992
	phy                                     ;C37994
	jsl $C35FE7                             ;C37995
	ply                                     ;C37999
	lda $01,s                               ;C3799A
	inc a                                   ;C3799C
	sta $00                                 ;C3799D
	sty $01                                 ;C3799F
	lda #$06                                ;C379A1
	sta $02                                 ;C379A3
	jsr $7EA4                               ;C379A5
	lda $02,s                               ;C379A8
	dec a                                   ;C379AA
	sta $00                                 ;C379AB
	sty $01                                 ;C379AD
	lda #$09                                ;C379AF
	sta $02                                 ;C379B1
	jsr $7EA4                               ;C379B3
	lda $04,s                               ;C379B6
	tax                                     ;C379B8
	lda $7E8A33,x                           ;C379B9
	tax                                     ;C379BD
	lda $7EC166,x                           ;C379BE
	ora #$80                                ;C379C2
	sta $7EC166,x                           ;C379C4
@lbl_C379C8:
	pla                                     ;C379C8
	pla                                     ;C379C9
	pla                                     ;C379CA
	pla                                     ;C379CB
	plp                                     ;C379CC
	rts                                     ;C379CD
@lbl_C379CE:
	dex                                     ;C379CE
	bmi @lbl_C379C8                         ;C379CF
	brl @lbl_C3792E                         ;C379D1
	php                                     ;C379D4
	sep #$30                                ;C379D5
	lda $7EC171                             ;C379D7
	clc                                     ;C379DB
	adc #$11                                ;C379DC
	pha                                     ;C379DE
	tax                                     ;C379DF
	lda $7E8A33,x                           ;C379E0
	tax                                     ;C379E4
	lda $7EC166,x                           ;C379E5
	cmp #$00                                ;C379E9
	beq @lbl_C379F0                         ;C379EB
	pla                                     ;C379ED
	plp                                     ;C379EE
	rts                                     ;C379EF
@lbl_C379F0:
	lda $7EBE70,x                           ;C379F0
	pha                                     ;C379F4
	lda $7EBE7A,x                           ;C379F5
	pha                                     ;C379F9
	lda $7EBE66,x                           ;C379FA
	pha                                     ;C379FE
	ldx #$04                                ;C379FF
@lbl_C37A01:
	lda $04,s                               ;C37A01
	sta $00                                 ;C37A03
	jsr $7D89                               ;C37A05
	lda $03,s                               ;C37A08
	sta $01                                 ;C37A0A
	lda #$FF                                ;C37A0C
	sta $03                                 ;C37A0E
	jsr $6C3B                               ;C37A10
	lda $01                                 ;C37A13
	inc a                                   ;C37A15
	inc a                                   ;C37A16
	tay                                     ;C37A17
	lda $04,s                               ;C37A18
	sta $00                                 ;C37A1A
	jsr $7D89                               ;C37A1C
	lda $01,s                               ;C37A1F
	sta $00                                 ;C37A21
	lda #$FF                                ;C37A23
	sta $02                                 ;C37A25
	jsr $6C70                               ;C37A27
	lda $01                                 ;C37A2A
	dec a                                   ;C37A2C
	sty $00                                 ;C37A2D
	cmp $00                                 ;C37A2F
	bcc @lbl_C37A9B                         ;C37A31
	sta $01                                 ;C37A33
	phx                                     ;C37A35
	jsl $C3F69F                             ;C37A36
	plx                                     ;C37A3A
	ldy $00                                 ;C37A3B
	sty $01                                 ;C37A3D
	lda $01,s                               ;C37A3F
	sta $00                                 ;C37A41
	jsr $A114                               ;C37A43
	lda $00                                 ;C37A46
	bne @lbl_C37AA1                         ;C37A48
	sty $01                                 ;C37A4A
	lda $02,s                               ;C37A4C
	sta $00                                 ;C37A4E
	jsr $A114                               ;C37A50
	lda $00                                 ;C37A53
	bne @lbl_C37AA1                         ;C37A55
	lda $01,s                               ;C37A57
	inc a                                   ;C37A59
	sta $00                                 ;C37A5A
	sty $01                                 ;C37A5C
	lda $02,s                               ;C37A5E
	dec a                                   ;C37A60
	sta $02                                 ;C37A61
	lda #$B0                                ;C37A63
	sta $03                                 ;C37A65
	phy                                     ;C37A67
	jsl $C35FE7                             ;C37A68
	ply                                     ;C37A6C
	lda $01,s                               ;C37A6D
	inc a                                   ;C37A6F
	sta $00                                 ;C37A70
	sty $01                                 ;C37A72
	lda #$06                                ;C37A74
	sta $02                                 ;C37A76
	jsr $7EA4                               ;C37A78
	lda $02,s                               ;C37A7B
	dec a                                   ;C37A7D
	sta $00                                 ;C37A7E
	sty $01                                 ;C37A80
	lda #$09                                ;C37A82
	sta $02                                 ;C37A84
	jsr $7EA4                               ;C37A86
	lda $04,s                               ;C37A89
	tax                                     ;C37A8B
	lda $7E8A33,x                           ;C37A8C
	tax                                     ;C37A90
	lda $7EC166,x                           ;C37A91
	ora #$80                                ;C37A95
	sta $7EC166,x                           ;C37A97
@lbl_C37A9B:
	pla                                     ;C37A9B
	pla                                     ;C37A9C
	pla                                     ;C37A9D
	pla                                     ;C37A9E
	plp                                     ;C37A9F
	rts                                     ;C37AA0
@lbl_C37AA1:
	dex                                     ;C37AA1
	bmi @lbl_C37A9B                         ;C37AA2
	brl @lbl_C37A01                         ;C37AA4
	php                                     ;C37AA7
	sep #$30                                ;C37AA8
	lda $7EC171                             ;C37AAA
	pha                                     ;C37AAE
	tax                                     ;C37AAF
	lda $7E8A33,x                           ;C37AB0
	tax                                     ;C37AB4
	lda $7EC166,x                           ;C37AB5
	cmp #$00                                ;C37AB9
	beq @lbl_C37AC0                         ;C37ABB
	pla                                     ;C37ABD
	plp                                     ;C37ABE
	rts                                     ;C37ABF
@lbl_C37AC0:
	lda $7EBE84,x                           ;C37AC0
	pha                                     ;C37AC4
	lda $7EBE70,x                           ;C37AC5
	pha                                     ;C37AC9
	ldy #$04                                ;C37ACA
@lbl_C37ACC:
	lda $03,s                               ;C37ACC
	sta $00                                 ;C37ACE
	jsr $7D89                               ;C37AD0
	lda #$FF                                ;C37AD3
	sta $01                                 ;C37AD5
	lda $02,s                               ;C37AD7
	sta $03                                 ;C37AD9
	jsr $6C3B                               ;C37ADB
	lda $00                                 ;C37ADE
	inc a                                   ;C37AE0
	tax                                     ;C37AE1
	lda $03,s                               ;C37AE2
	inc a                                   ;C37AE4
	sta $00                                 ;C37AE5
	jsr $7D89                               ;C37AE7
	lda #$FF                                ;C37AEA
	sta $01                                 ;C37AEC
	lda $02,s                               ;C37AEE
	sta $03                                 ;C37AF0
	jsr $6C3B                               ;C37AF2
	lda $00                                 ;C37AF5
	dec a                                   ;C37AF7
	sta $01                                 ;C37AF8
	stx $00                                 ;C37AFA
	phy                                     ;C37AFC
	jsl $C3F69F                             ;C37AFD
	ply                                     ;C37B01
	ldx $00                                 ;C37B02
	lda $01,s                               ;C37B04
	sta $01                                 ;C37B06
	jsr $A114                               ;C37B08
	lda $00                                 ;C37B0B
	beq @lbl_C37B15                         ;C37B0D
	dey                                     ;C37B0F
	bmi @lbl_C37B59                         ;C37B10
	brl @lbl_C37ACC                         ;C37B12
@lbl_C37B15:
	stx $00                                 ;C37B15
	lda $01,s                               ;C37B17
	inc a                                   ;C37B19
	sta $01                                 ;C37B1A
	lda $02,s                               ;C37B1C
	dec a                                   ;C37B1E
	sta $02                                 ;C37B1F
	lda #$B0                                ;C37B21
	sta $03                                 ;C37B23
	phx                                     ;C37B25
	jsl $C3601D                             ;C37B26
	plx                                     ;C37B2A
	stx $00                                 ;C37B2B
	lda $01,s                               ;C37B2D
	inc a                                   ;C37B2F
	sta $01                                 ;C37B30
	lda #$00                                ;C37B32
	sta $02                                 ;C37B34
	jsr $7EA4                               ;C37B36
	stx $00                                 ;C37B39
	lda $02,s                               ;C37B3B
	dec a                                   ;C37B3D
	sta $01                                 ;C37B3E
	lda #$03                                ;C37B40
	sta $02                                 ;C37B42
	jsr $7EA4                               ;C37B44
	lda $03,s                               ;C37B47
	tax                                     ;C37B49
	lda $7E8A33,x                           ;C37B4A
	tax                                     ;C37B4E
	lda $7EC166,x                           ;C37B4F
	ora #$80                                ;C37B53
	sta $7EC166,x                           ;C37B55
@lbl_C37B59:
	pla                                     ;C37B59
	pla                                     ;C37B5A
	pla                                     ;C37B5B
	plp                                     ;C37B5C
	rts                                     ;C37B5D
	php                                     ;C37B5E
	sep #$30                                ;C37B5F
	lda $7EC171                             ;C37B61
	clc                                     ;C37B65
	adc #$10                                ;C37B66
	pha                                     ;C37B68
	tax                                     ;C37B69
	lda $7E8A33,x                           ;C37B6A
	tax                                     ;C37B6E
	lda $7EC166,x                           ;C37B6F
	cmp #$00                                ;C37B73
	beq @lbl_C37B7A                         ;C37B75
	pla                                     ;C37B77
	plp                                     ;C37B78
	rts                                     ;C37B79
@lbl_C37B7A:
	lda $7EBE84,x                           ;C37B7A
	pha                                     ;C37B7E
	lda $7EBE70,x                           ;C37B7F
	pha                                     ;C37B83
	ldy #$04                                ;C37B84
@lbl_C37B86:
	lda $03,s                               ;C37B86
	sta $00                                 ;C37B88
	jsr $7D89                               ;C37B8A
	lda $01,s                               ;C37B8D
	sta $01                                 ;C37B8F
	lda #$FF                                ;C37B91
	sta $03                                 ;C37B93
	jsr $6C3B                               ;C37B95
	lda $00                                 ;C37B98
	inc a                                   ;C37B9A
	tax                                     ;C37B9B
	lda $03,s                               ;C37B9C
	inc a                                   ;C37B9E
	sta $00                                 ;C37B9F
	jsr $7D89                               ;C37BA1
	lda $01,s                               ;C37BA4
	sta $01                                 ;C37BA6
	lda #$FF                                ;C37BA8
	sta $03                                 ;C37BAA
	jsr $6C3B                               ;C37BAC
	lda $00                                 ;C37BAF
	dec a                                   ;C37BB1
	sta $01                                 ;C37BB2
	stx $00                                 ;C37BB4
	phy                                     ;C37BB6
	jsl $C3F69F                             ;C37BB7
	ply                                     ;C37BBB
	ldx $00                                 ;C37BBC
	lda $02,s                               ;C37BBE
	sta $01                                 ;C37BC0
	jsr $A114                               ;C37BC2
	lda $00                                 ;C37BC5
	beq @lbl_C37BCF                         ;C37BC7
	dey                                     ;C37BC9
	bmi @lbl_C37C13                         ;C37BCA
	brl @lbl_C37B86                         ;C37BCC
@lbl_C37BCF:
	stx $00                                 ;C37BCF
	lda $01,s                               ;C37BD1
	inc a                                   ;C37BD3
	sta $01                                 ;C37BD4
	lda $02,s                               ;C37BD6
	dec a                                   ;C37BD8
	sta $02                                 ;C37BD9
	lda #$B0                                ;C37BDB
	sta $03                                 ;C37BDD
	phx                                     ;C37BDF
	jsl $C3601D                             ;C37BE0
	plx                                     ;C37BE4
	stx $00                                 ;C37BE5
	lda $01,s                               ;C37BE7
	inc a                                   ;C37BE9
	sta $01                                 ;C37BEA
	lda #$00                                ;C37BEC
	sta $02                                 ;C37BEE
	jsr $7EA4                               ;C37BF0
	stx $00                                 ;C37BF3
	lda $02,s                               ;C37BF5
	dec a                                   ;C37BF7
	sta $01                                 ;C37BF8
	lda #$03                                ;C37BFA
	sta $02                                 ;C37BFC
	jsr $7EA4                               ;C37BFE
	lda $03,s                               ;C37C01
	tax                                     ;C37C03
	lda $7E8A33,x                           ;C37C04
	tax                                     ;C37C08
	lda $7EC166,x                           ;C37C09
	ora #$80                                ;C37C0D
	sta $7EC166,x                           ;C37C0F
@lbl_C37C13:
	pla                                     ;C37C13
	pla                                     ;C37C14
	pla                                     ;C37C15
	plp                                     ;C37C16
	rts                                     ;C37C17
	php                                     ;C37C18
	sep #$30                                ;C37C19
	lda $7EC171                             ;C37C1B
	pha                                     ;C37C1F
	tax                                     ;C37C20
	lda $7E8A33,x                           ;C37C21
	tax                                     ;C37C25
	lda $7EC166,x                           ;C37C26
	cmp #$00                                ;C37C2A
	beq @lbl_C37C31                         ;C37C2C
	pla                                     ;C37C2E
	plp                                     ;C37C2F
	rts                                     ;C37C30
@lbl_C37C31:
	lda $7EBE7A,x                           ;C37C31
	pha                                     ;C37C35
	lda $7EBE66,x                           ;C37C36
	pha                                     ;C37C3A
	ldx #$04                                ;C37C3B
@lbl_C37C3D:
	lda $03,s                               ;C37C3D
	sta $00                                 ;C37C3F
	jsr $7D89                               ;C37C41
	lda #$FF                                ;C37C44
	sta $00                                 ;C37C46
	lda $02,s                               ;C37C48
	sta $02                                 ;C37C4A
	jsr $6C70                               ;C37C4C
	lda $01                                 ;C37C4F
	inc a                                   ;C37C51
	tay                                     ;C37C52
	lda $03,s                               ;C37C53
	clc                                     ;C37C55
	adc #$10                                ;C37C56
	sta $00                                 ;C37C58
	jsr $7D89                               ;C37C5A
	lda #$FF                                ;C37C5D
	sta $00                                 ;C37C5F
	lda $02,s                               ;C37C61
	sta $02                                 ;C37C63
	jsr $6C70                               ;C37C65
	sty $00                                 ;C37C68
	dec $01                                 ;C37C6A
	phx                                     ;C37C6C
	jsl $C3F69F                             ;C37C6D
	plx                                     ;C37C71
	ldy $00                                 ;C37C72
	sty $01                                 ;C37C74
	lda $01,s                               ;C37C76
	sta $00                                 ;C37C78
	jsr $A114                               ;C37C7A
	lda $00                                 ;C37C7D
	beq @lbl_C37C87                         ;C37C7F
	dex                                     ;C37C81
	bmi @lbl_C37CCB                         ;C37C82
	brl @lbl_C37C3D                         ;C37C84
@lbl_C37C87:
	lda $01,s                               ;C37C87
	inc a                                   ;C37C89
	sta $00                                 ;C37C8A
	sty $01                                 ;C37C8C
	lda $02,s                               ;C37C8E
	dec a                                   ;C37C90
	sta $02                                 ;C37C91
	lda #$B0                                ;C37C93
	sta $03                                 ;C37C95
	phy                                     ;C37C97
	jsl $C35FE7                             ;C37C98
	ply                                     ;C37C9C
	lda $01,s                               ;C37C9D
	inc a                                   ;C37C9F
	sta $00                                 ;C37CA0
	sty $01                                 ;C37CA2
	lda #$06                                ;C37CA4
	sta $02                                 ;C37CA6
	jsr $7EA4                               ;C37CA8
	lda $02,s                               ;C37CAB
	dec a                                   ;C37CAD
	sta $00                                 ;C37CAE
	sty $01                                 ;C37CB0
	lda #$09                                ;C37CB2
	sta $02                                 ;C37CB4
	jsr $7EA4                               ;C37CB6
	lda $03,s                               ;C37CB9
	tax                                     ;C37CBB
	lda $7E8A33,x                           ;C37CBC
	tax                                     ;C37CC0
	lda $7EC166,x                           ;C37CC1
	ora #$80                                ;C37CC5
	sta $7EC166,x                           ;C37CC7
@lbl_C37CCB:
	pla                                     ;C37CCB
	pla                                     ;C37CCC
	pla                                     ;C37CCD
	plp                                     ;C37CCE
	rts                                     ;C37CCF
	php                                     ;C37CD0
	sep #$30                                ;C37CD1
	lda $7EC171                             ;C37CD3
	inc a                                   ;C37CD7
	pha                                     ;C37CD8
	tax                                     ;C37CD9
	lda $7E8A33,x                           ;C37CDA
	tax                                     ;C37CDE
	lda $7EC166,x                           ;C37CDF
	cmp #$00                                ;C37CE3
	beq @lbl_C37CEA                         ;C37CE5
	pla                                     ;C37CE7
	plp                                     ;C37CE8
	rts                                     ;C37CE9
@lbl_C37CEA:
	lda $7EBE7A,x                           ;C37CEA
	pha                                     ;C37CEE
	lda $7EBE66,x                           ;C37CEF
	pha                                     ;C37CF3
	ldx #$04                                ;C37CF4
@lbl_C37CF6:
	lda $03,s                               ;C37CF6
	sta $00                                 ;C37CF8
	jsr $7D89                               ;C37CFA
	lda $01,s                               ;C37CFD
	sta $00                                 ;C37CFF
	lda #$FF                                ;C37D01
	sta $02                                 ;C37D03
	jsr $6C70                               ;C37D05
	lda $01                                 ;C37D08
	inc a                                   ;C37D0A
	tay                                     ;C37D0B
	lda $03,s                               ;C37D0C
	clc                                     ;C37D0E
	adc #$10                                ;C37D0F
	sta $00                                 ;C37D11
	jsr $7D89                               ;C37D13
	lda $01,s                               ;C37D16
	sta $00                                 ;C37D18
	lda #$FF                                ;C37D1A
	sta $02                                 ;C37D1C
	jsr $6C70                               ;C37D1E
	sty $00                                 ;C37D21
	dec $01                                 ;C37D23
	phx                                     ;C37D25
	jsl $C3F69F                             ;C37D26
	plx                                     ;C37D2A
	ldy $00                                 ;C37D2B
	sty $01                                 ;C37D2D
	lda $02,s                               ;C37D2F
	sta $00                                 ;C37D31
	jsr $A114                               ;C37D33
	lda $00                                 ;C37D36
	beq @lbl_C37D40                         ;C37D38
	dex                                     ;C37D3A
	bmi @lbl_C37D84                         ;C37D3B
	brl @lbl_C37CF6                         ;C37D3D
@lbl_C37D40:
	lda $01,s                               ;C37D40
	inc a                                   ;C37D42
	sta $00                                 ;C37D43
	sty $01                                 ;C37D45
	lda $02,s                               ;C37D47
	dec a                                   ;C37D49
	sta $02                                 ;C37D4A
	lda #$B0                                ;C37D4C
	sta $03                                 ;C37D4E
	phy                                     ;C37D50
	jsl $C35FE7                             ;C37D51
	ply                                     ;C37D55
	lda $01,s                               ;C37D56
	inc a                                   ;C37D58
	sta $00                                 ;C37D59
	sty $01                                 ;C37D5B
	lda #$06                                ;C37D5D
	sta $02                                 ;C37D5F
	jsr $7EA4                               ;C37D61
	lda $02,s                               ;C37D64
	dec a                                   ;C37D66
	sta $00                                 ;C37D67
	sty $01                                 ;C37D69
	lda #$09                                ;C37D6B
	sta $02                                 ;C37D6D
	jsr $7EA4                               ;C37D6F
	lda $03,s                               ;C37D72
	tax                                     ;C37D74
	lda $7E8A33,x                           ;C37D75
	tax                                     ;C37D79
	lda $7EC166,x                           ;C37D7A
	ora #$80                                ;C37D7E
	sta $7EC166,x                           ;C37D80
@lbl_C37D84:
	pla                                     ;C37D84
	pla                                     ;C37D85
	pla                                     ;C37D86
	plp                                     ;C37D87
	rts                                     ;C37D88
	phx                                     ;C37D89
	phy                                     ;C37D8A
	lda $00                                 ;C37D8B
	and #$0F                                ;C37D8D
	dec a                                   ;C37D8F
	sta $02                                 ;C37D90
	lda $00                                 ;C37D92
	lsr a                                   ;C37D94
	lsr a                                   ;C37D95
	lsr a                                   ;C37D96
	lsr a                                   ;C37D97
	dec a                                   ;C37D98
	sta $03                                 ;C37D99
	lda $7EC170                             ;C37D9B
	tax                                     ;C37D9F
	lda $C37DD0,x                           ;C37DA0
	clc                                     ;C37DA4
	adc $02                                 ;C37DA5
	tax                                     ;C37DA7
	lda $C37DD3,x                           ;C37DA8
	sta $00                                 ;C37DAC
	lda $C37DE7,x                           ;C37DAE
	sta $02                                 ;C37DB2
	lda $7EC170                             ;C37DB4
	tax                                     ;C37DB8
	lda $C37DFB,x                           ;C37DB9
	clc                                     ;C37DBD
	adc $03                                 ;C37DBE
	tax                                     ;C37DC0
	lda $C37DFE,x                           ;C37DC1
	sta $01                                 ;C37DC5
	lda $C37E0A,x                           ;C37DC7
	sta $03                                 ;C37DCB
	ply                                     ;C37DCD
	plx                                     ;C37DCE
	rts                                     ;C37DCF
	.db $00   ;C37DD0
	ora $0B                                 ;C37DD1
	tsb $11                                 ;C37DD3
	tcs                                     ;C37DD5
	and $2F                                 ;C37DD6
	tsb $10                                 ;C37DD8
	clc                                     ;C37DDA
	jsr $3028                               ;C37DDB
	tsb $0B                                 ;C37DDE
	ora ($17),y                             ;C37DE0
	ora $2923,x                             ;C37DE2
	and $1A1035                             ;C37DE5
	bit $2E                                 ;C37DE9
	tsc                                     ;C37DEB
	ora $271F17                             ;C37DEC
	and $100A3B                             ;C37DF0
	asl $1C,x                               ;C37DF4
	jsl $342E28                             ;C37DF6
	tsc                                     ;C37DFA
	.db $00   ;C37DFB
	ora $07,s                               ;C37DFC
	tsb $10                                 ;C37DFE
	inc a                                   ;C37E00
	tsb $0D                                 ;C37E01
	ora $1D,x                               ;C37E03
	tsb $0C                                 ;C37E05
	ora ($18)                               ;C37E07
	asl $190F,x                             ;C37E09
	and $0C                                 ;C37E0C
	trb $1C                                 ;C37E0E
	and $0B                                 ;C37E10
	ora ($17),y                             ;C37E12
	ora $0825,x                             ;C37E14
	sep #$30                                ;C37E17
	lda $00                                 ;C37E19
	pha                                     ;C37E1B
	lda $01                                 ;C37E1C
	pha                                     ;C37E1E
	ldx #$00                                ;C37E1F
	lda $01                                 ;C37E21
	cmp $03                                 ;C37E23
	beq @lbl_C37E31                         ;C37E25
	inx                                     ;C37E27
	inx                                     ;C37E28
	lda $00                                 ;C37E29
	cmp $02                                 ;C37E2B
	beq @lbl_C37E31                         ;C37E2D
	inx                                     ;C37E2F
	inx                                     ;C37E30
@lbl_C37E31:
	jmp ($7E34,x)                           ;C37E31
	dec a                                   ;C37E34
	ror $7E6D,x                             ;C37E35
	ldy #$7E                                ;C37E38
	ldx #$04                                ;C37E3A
	lda $01,s                               ;C37E3C
	tay                                     ;C37E3E
@lbl_C37E3F:
	txa                                     ;C37E3F
	cmp #$3C                                ;C37E40
	bcs @lbl_C37E69                         ;C37E42
	stx $00                                 ;C37E44
	sty $01                                 ;C37E46
	phx                                     ;C37E48
	jsl $C359AF                             ;C37E49
	plx                                     ;C37E4D
	lda $02                                 ;C37E4E
	bit #$80                                ;C37E50
	beq @lbl_C37E66                         ;C37E52
	cmp #$B0                                ;C37E54
	beq @lbl_C37E66                         ;C37E56
	stx $00                                 ;C37E58
	sty $01                                 ;C37E5A
	lda #$B0                                ;C37E5C
	sta $02                                 ;C37E5E
	phx                                     ;C37E60
	jsl $C36CBE                             ;C37E61
	plx                                     ;C37E65
@lbl_C37E66:
	inx                                     ;C37E66
	bra @lbl_C37E3F                         ;C37E67
@lbl_C37E69:
	pla                                     ;C37E69
	pla                                     ;C37E6A
	plp                                     ;C37E6B
	rts                                     ;C37E6C
	lda $02,s                               ;C37E6D
	tax                                     ;C37E6F
	ldy #$04                                ;C37E70
@lbl_C37E72:
	tya                                     ;C37E72
	cmp #$26                                ;C37E73
	bcs @lbl_C37E9C                         ;C37E75
	stx $00                                 ;C37E77
	sty $01                                 ;C37E79
	phx                                     ;C37E7B
	jsl $C359AF                             ;C37E7C
	plx                                     ;C37E80
	lda $02                                 ;C37E81
	bit #$80                                ;C37E83
	beq @lbl_C37E99                         ;C37E85
	cmp #$B0                                ;C37E87
	beq @lbl_C37E99                         ;C37E89
	stx $00                                 ;C37E8B
	sty $01                                 ;C37E8D
	lda #$B0                                ;C37E8F
	sta $02                                 ;C37E91
	phx                                     ;C37E93
	jsl $C36CBE                             ;C37E94
	plx                                     ;C37E98
@lbl_C37E99:
	iny                                     ;C37E99
	bra @lbl_C37E72                         ;C37E9A
@lbl_C37E9C:
	pla                                     ;C37E9C
	pla                                     ;C37E9D
	plp                                     ;C37E9E
	rts                                     ;C37E9F
	pla                                     ;C37EA0
	pla                                     ;C37EA1
	plp                                     ;C37EA2
	rts                                     ;C37EA3
	phx                                     ;C37EA4
	phy                                     ;C37EA5
	php                                     ;C37EA6
	sep #$30                                ;C37EA7
	ldx $02                                 ;C37EA9
	lda $C37F19,x                           ;C37EAB
	sta $A9                                 ;C37EAF
	lda $C37F1A,x                           ;C37EB1
	sta $AA                                 ;C37EB5
	lda $C37F1B,x                           ;C37EB7
	sta $AB                                 ;C37EBB
	rep #$30                                ;C37EBD
	jsl $C36BBD                             ;C37EBF
	tyx                                     ;C37EC3
	ldy #$0000                              ;C37EC4
	bra @lbl_C37EEB                         ;C37EC7
@lbl_C37EC9:
	rep #$20                                ;C37EC9
	tya                                     ;C37ECB
	clc                                     ;C37ECC
	adc #$0004                              ;C37ECD
	and #$0007                              ;C37ED0
	sta $06                                 ;C37ED3
@lbl_C37ED5:
	jsl $C3F65F                             ;C37ED5
	lda $00                                 ;C37ED9
	and #$0003                              ;C37EDB
	asl a                                   ;C37EDE
	beq @lbl_C37EEA                         ;C37EDF
	cmp #$0004                              ;C37EE1
	beq @lbl_C37EEA                         ;C37EE4
	cmp $06                                 ;C37EE6
	beq @lbl_C37ED5                         ;C37EE8
@lbl_C37EEA:
	tay                                     ;C37EEA
@lbl_C37EEB:
	txa                                     ;C37EEB
	clc                                     ;C37EEC
	adc [$A9],y                             ;C37EED
	tax                                     ;C37EEF
	sep #$20                                ;C37EF0
	lda $7EA95F,x                           ;C37EF2
	bit #$80                                ;C37EF6
	beq @lbl_C37EC9                         ;C37EF8
	cmp #$B0                                ;C37EFA
	beq @lbl_C37EC9                         ;C37EFC
	cmp #$F0                                ;C37EFE
	beq @lbl_C37F15                         ;C37F00
	lda #$B0                                ;C37F02
	sta $7EA95F,x                           ;C37F04
	jsl $C3F65F                             ;C37F08
	lda $00                                 ;C37F0C
	bit #$1F                                ;C37F0E
	bne @lbl_C37EC9                         ;C37F10
	jsr $7F45                               ;C37F12
@lbl_C37F15:
	plp                                     ;C37F15
	ply                                     ;C37F16
	plx                                     ;C37F17
	rts                                     ;C37F18
	and $7F                                 ;C37F19
	cmp $2D,s                               ;C37F1B
	adc $7F35C3,x                           ;C37F1D
	cmp $3D,s                               ;C37F21
	adc $FFC0C3,x                           ;C37F23
	ora ($00,x)                             ;C37F27
	cpy #$FFFF                              ;C37F29
	sbc $010040,x                           ;C37F2C
	.db $00   ;C37F30
	rti                                     ;C37F31
	.db $00   ;C37F32
	sbc $FFFFFF,x                           ;C37F33
	cpy #$FFFF                              ;C37F37
	sbc $010040,x                           ;C37F3A
	.db $00   ;C37F3E
	cpy #$01FF                              ;C37F3F
	.db $00   ;C37F42
	rti                                     ;C37F43
	.db $00   ;C37F44
	txy                                     ;C37F45
	jsl $C36BCE                             ;C37F46
	lda $01                                 ;C37F4A
	pha                                     ;C37F4C
	lda $00                                 ;C37F4D
	pha                                     ;C37F4F
	ldx #$0024                              ;C37F50
@lbl_C37F53:
	lda $01,s                               ;C37F53
	clc                                     ;C37F55
	adc $C37FC7,x                           ;C37F56
	sta $00                                 ;C37F5A
	lda $02,s                               ;C37F5C
	clc                                     ;C37F5E
	adc $C37FEC,x                           ;C37F5F
	sta $01                                 ;C37F63
	jsr $A114                               ;C37F65
	lda $00                                 ;C37F68
	bne @lbl_C37FC4                         ;C37F6A
	dex                                     ;C37F6C
	bpl @lbl_C37F53                         ;C37F6D
	ldx #$0024                              ;C37F6F
@lbl_C37F72:
	lda $01,s                               ;C37F72
	clc                                     ;C37F74
	adc $C37FC7,x                           ;C37F75
	cmp #$04                                ;C37F79
	bcc @lbl_C37FC1                         ;C37F7B
	cmp #$3C                                ;C37F7D
	bcs @lbl_C37FC1                         ;C37F7F
	sta $00                                 ;C37F81
	lda $02,s                               ;C37F83
	clc                                     ;C37F85
	adc $C37FEC,x                           ;C37F86
	cmp #$04                                ;C37F8A
	bcc @lbl_C37FC1                         ;C37F8C
	cmp #$26                                ;C37F8E
	bcs @lbl_C37FC1                         ;C37F90
	sta $01                                 ;C37F92
	ldy $00                                 ;C37F94
	phx                                     ;C37F96
	jsl $C36CA5                             ;C37F97
	plx                                     ;C37F9B
	lda $00                                 ;C37F9C
	bit #$80                                ;C37F9E
	beq @lbl_C37FB4                         ;C37FA0
	cmp #$E0                                ;C37FA2
	bne @lbl_C37FC1                         ;C37FA4
@lbl_C37FA6:
	sty $00                                 ;C37FA6
	lda #$B0                                ;C37FA8
	sta $02                                 ;C37FAA
	phx                                     ;C37FAC
	jsl $C36CBE                             ;C37FAD
	plx                                     ;C37FB1
	bra @lbl_C37FC1                         ;C37FB2
@lbl_C37FB4:
	bit #$10                                ;C37FB4
	bne @lbl_C37FC1                         ;C37FB6
	sty $00                                 ;C37FB8
	jsr $A130                               ;C37FBA
	lda $00                                 ;C37FBD
	beq @lbl_C37FA6                         ;C37FBF
@lbl_C37FC1:
	dex                                     ;C37FC1
	bpl @lbl_C37F72                         ;C37FC2
@lbl_C37FC4:
	pla                                     ;C37FC4
	pla                                     ;C37FC5
	rts                                     ;C37FC6
	.db $FF,$00,$01,$FE,$FF,$00,$01,$02,$FD,$FE,$FF,$00,$01,$02,$03,$FD,$FE,$FF,$00,$01,$02,$03,$FD,$FE,$FF,$00,$01,$02,$03,$FE,$FF,$00,$01,$02,$FF,$00,$01,$FD,$FD,$FD,$FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$03,$03,$03   ;C37FC7

func_C38011:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C38034
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$08
	bcc @lbl_C3803C
	cmp.b #$1E
	bcs @lbl_C3803C
	cmp.b #$0F
	bcc @lbl_C38034
	cmp.b #$16
	bcc @lbl_C3803C
@lbl_C38034:
	lda.l $7EBE8E
	tax
@lbl_C38039:
	dex
	bpl @lbl_C3803E
@lbl_C3803C:
	plp
	rts
@lbl_C3803E:
	lda.l $7EC166,x
	cmp.b #$00
	bne @lbl_C38039
	lda.l $7EBE7A,x
	sec
	sbc.l $7EBE66,x
	cmp.b #$06
	bcc @lbl_C38039
	sta.b wTemp02
	lda.l $7EBE84,x
	sec
	sbc.l $7EBE70,x
	cmp.b #$06
	bcc @lbl_C38039
	sta.b wTemp04
	lda.l $7EC166,x
	ora.b #$80
	sta.l $7EC166,x
	lda.b wTemp02
	lsr a
	bcc @lbl_C3807E
	pha                                     ;C38073
	jsl $C3F65F                             ;C38074
	pla                                     ;C38078
	ldy $00                                 ;C38079
	.db $10,$01   ;C3807B
	clc                                     ;C3807D
@lbl_C3807E:
	adc.l $7EBE66,x
	pha
	lda.b wTemp04
	lsr a
	bcc @lbl_C38093
	pha
	jsl.l Random
	pla
	ldy.b wTemp00
	bpl @lbl_C38093
	clc
@lbl_C38093:
	adc.l $7EBE70,x
	sta.b wTemp01
	pla
	sta.b wTemp00
	rep #$10 ;XY->16
	jsl.l func_C36BBD
	phy
	ldx.w #$0901
	stx.b wTemp00
	jsl.l GetRandomInRange
	stz.b wTemp01
	ldx.b wTemp00
	stz.b wTemp00
	lda.l UNREACH_C380F1,x
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	stx.b wTemp01
	jsl.l MultiplyPackedBytesToWord
	asl.b wTemp00
	stz.b wTemp01
	rep #$20 ;A->16
	txa
	dec a
	asl a
	tax
	lda.l UNREACH_C380FB,x
	clc
	adc.b wTemp00
	sta.b w00a9
	restorebank
	txy
@lbl_C380DA:
	rep #$20 ;A->16
	lda.b wTemp01,s
	clc
	adc.b ($A9),y
	tax
	sep #$20 ;A->8
	lda.b #$B0
	sta.l $7EA95F,x
	dey
	dey
	bpl @lbl_C380DA
	ply
	plp
	rts

UNREACH_C380F1:
	.db $00,$08,$0B,$15,$23,$13,$07,$07,$03,$00

UNREACH_C380FB:
	.dw Data_c3810d
	.dw Data_c3811f
	.dw Data_c3814f
	.dw Data_c381d3
	.dw Data_c382f3
	.dw Data_c383bb
	.dw Data_c3841b
	.dw Data_c3848b
	.dw Data_c384cb
	
Data_c3810d:
	.dw $FFBF,$FFC0,$FFC1,$FFFF,$0000,$0001,$003F,$0040,$0041
	
Data_c3811f:
	.dw $FFBF,$FFFF
	.dw $FFC0,$0000
	.dw $FFC1,$0001
	.dw $FFFF,$003F
	.dw $0000,$0040
	.dw $0001,$0041
	.dw $FFBF,$FFC0,$FFFF,$0000
	.db $3F,$00,$40,$00,$C0,$FF,$C1,$FF,$00,$00,$01,$00,$40,$00,$41,$00
	
Data_c3814f:
	.db $BF,$FF,$FF,$FF,$3F,$00,$C0,$FF,$00,$00,$40,$00,$C1,$FF,$01,$00
	.db $41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF
	.db $FF,$FF,$00,$00,$01,$00,$3F,$00,$40,$00,$41,$00,$BF,$FF,$FF,$FF
	.db $00,$00,$C0,$FF,$00,$00,$01,$00,$00,$00,$40,$00,$41,$00,$FF,$FF
	.db $3F,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$C0,$FF
	.db $C1,$FF,$00,$00,$00,$00,$01,$00
	.db $40,$00,$FF,$FF,$00,$00,$3F,$00
	.db $BF,$FF,$C0,$FF,$00,$00,$C0,$FF
	.db $C1,$FF,$01,$00,$00,$00,$01,$00
	.db $41,$00,$FF,$FF,$00,$00,$40,$00
	.db $C0,$FF,$FF,$FF,$00,$00,$C1,$FF,$00,$00,$01,$00
	.db $01,$00,$40,$00,$41,$00,$00,$00,$3F,$00,$40,$00
	
Data_c381d3:
	.db $BF,$FF,$FF,$FF,$3F,$00,$40,$00
	.db $C0,$FF,$00,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$3F,$00
	.db $C0,$FF,$C1,$FF,$00,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$00,$00,$40,$00
	.db $C0,$FF,$C1,$FF,$01,$00,$41,$00
	.db $C0,$FF,$00,$00,$3F,$00,$40,$00
	.db $C1,$FF,$01,$00,$40,$00,$41,$00
	.db $BF,$FF,$FF,$FF,$00,$00,$01,$00
	.db $FF,$FF,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF
	.db $FF,$FF,$00,$00,$01,$00,$3F,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$01,$00
	.db $FF,$FF,$00,$00,$01,$00,$41,$00
	.db $C1,$FF,$FF,$FF,$00,$00,$01,$00
	.db $01,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$FF,$FF,$00,$00,$3F,$00
	.db $C0,$FF,$00,$00,$01,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$00,$00
	.db $FF,$FF,$00,$00,$01,$00,$40,$00
	.db $C0,$FF,$FF,$FF
	.db $00,$00,$40,$00,$C1,$FF,$00,$00,$01,$00,$41,$00,$C0,$FF,$FF,$FF
	.db $00,$00,$01,$00,$00,$00,$3F,$00,$40,$00,$41,$00,$BF,$FF,$FF,$FF
	.db $00,$00,$40,$00,$C0,$FF,$00,$00,$01,$00,$41,$00,$C0,$FF,$C1,$FF
	.db $FF,$FF,$00,$00,$00,$00,$01,$00,$3F,$00,$40,$00,$C0,$FF,$FF,$FF
	.db $00,$00,$3F,$00,$C1,$FF,$00,$00,$01,$00,$40,$00,$BF,$FF,$C0,$FF
	.db $00,$00,$01,$00,$FF,$FF,$00,$00,$40,$00,$41,$00,$BF,$FF,$C0,$FF
	.db $FF,$FF,$00,$00,$C0,$FF,$C1,$FF,$00,$00,$01,$00,$00,$00,$01,$00
	.db $40,$00,$41,$00,$FF,$FF,$00,$00,$3F,$00,$40,$00
	
Data_c382f3:
	.db $BF,$FF,$FF,$FF,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$3F,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$01,$00,$41,$00
	.db $C1,$FF,$01,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$FF,$FF,$00,$00,$3F,$00,$40,$00
	.db $C0,$FF,$00,$00,$01,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$00,$00,$3F,$00
	.db $C0,$FF,$C1,$FF,$00,$00,$01,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$00,$00,$40,$00
	.db $C0,$FF,$C1,$FF,$00,$00,$01,$00,$41,$00
	.db $C0,$FF,$FF,$FF,$00,$00,$3F,$00,$40,$00
	.db $C1,$FF,$00,$00,$01,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$00,$00,$01,$00
	.db $FF,$FF,$00,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$00,$00
	.db $FF,$FF,$00,$00,$01,$00,$3F,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$00,$00,$01,$00
	.db $FF,$FF,$00,$00,$01,$00,$40,$00,$41,$00
	.db $C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$01,$00
	.db $00,$00,$01,$00,$3F,$00,$40,$00,$41,$00
	
Data_c383bb:
	.db $BF,$FF,$FF,$FF,$00,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$3F,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$00,$00,$01,$00,$41,$00
	.db $C1,$FF,$00,$00,$01,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$00,$00,$3F,$00,$40,$00
	.db $C0,$FF,$C1,$FF,$00,$00,$01,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$01,$00
	.db $FF,$FF,$00,$00,$01,$00,$3F,$00,$40,$00,$41,$00

Data_c3841b:
	.db $BF,$FF,$C0,$FF,$FF,$FF,$00,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$3F,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$00,$00,$01,$00,$40,$00,$41,$00
	.db $C0,$FF,$C1,$FF,$00,$00,$01,$00,$3F,$00,$40,$00,$41,$00
	.db $C0,$FF,$FF,$FF,$00,$00,$01,$00,$3F,$00,$40,$00,$41,$00
	.db $BF,$FF,$C0,$FF,$FF,$FF,$00,$00,$01,$00,$3F,$00,$40,$00
	.db $BF,$FF,$C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$01,$00,$40,$00
	.db $C0,$FF,$C1,$FF,$FF,$FF,$00,$00,$01,$00,$40,$00,$41,$00

Data_c3848b:
	.dw $FFBF,$FFC0,$FFFF,$0000,$0001,$003F,$0040,$0041
	.dw $FFBF,$FFC0,$FFC1,$FFFF,$0000,$0001,$003F,$0040
	.dw $FFBF,$FFC0,$FFC1,$FFFF,$0000,$0001,$0040,$0041
	.dw $FFC0,$FFC1,$FFFF,$0000,$0001,$003F,$0040,$0041

Data_c384cb:
	.dw $FFBF,$FFC0,$FFC1,$FFFF,$0000,$0001,$003F,$0040,$0041


func_C384DD:
	phx
	phy
	php 
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b wTemp01
	pha
	lda.b wTemp02
	pha
	lda.b wTemp03
	pha
	lda.b wTemp04
	pha
	lda.b $05,s
	sta.b wTemp00
	lda.b $02,s
	sta.b wTemp01
	lda.b $04,s
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C35FE7
	lda.b $04,s
	sta.b wTemp00
	lda.b $02,s
	sta.b wTemp01
	lda.b $01,s
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C3601D
	lda.b $04,s
	sta.b wTemp00
	lda.b $01,s
	sta.b wTemp01
	lda.b $03,s
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C35FE7
	pla
	pla
	pla
	pla
	pla
	plp 
	ply
	plx
	rts

func_C38536:
	phx
	phy
	php 
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b wTemp01
	pha
	lda.b wTemp02
	pha
	lda.b wTemp03
	pha
	lda.b wTemp04
	pha
	lda.b $05,s
	sta.b wTemp00
	lda.b $03,s
	sta.b wTemp01
	lda.b $02,s
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C3601D
	lda.b $05,s
	sta.b wTemp00
	lda.b $02,s
	sta.b wTemp01
	lda.b $04,s
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C35FE7
	lda.b $04,s
	sta.b wTemp00
	lda.b $02,s
	sta.b wTemp01
	lda.b $01,s
	sta.b wTemp02
	lda.b #$30
	sta.b wTemp03
	jsl.l func_C3601D
	pla
	pla
	pla
	pla
	pla
	plp 
	ply
	plx
	rts

func_C3858F:
	php 
	sep #$30 ;AXY->8
	lda.b #$04
	sta.l $7EBE8E
	ldx.b #$03
@lbl_C3859A:
	lda.l Data_c38737,x
	sta.b wTemp00
	lda.l Data_c3873b,x
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	dec a
	sta.l $7EBE66,x
	lda.l Data_c3873f,x
	sta.b wTemp00
	lda.l Data_c38743,x
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	dec a
	sta.l $7EBE70,x
	lda.l Data_c38747,x
	sta.b wTemp00
	lda.l Data_c3874b,x
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	inc a
	sta.l $7EBE7A,x
	lda.l Data_c3874f,x
	sta.b wTemp00
	lda.l Data_c38753,x
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	inc a
	sta.l $7EBE84,x
	txa 
	ora.b #$00
	sta.b wTemp04
	pla
	sta.b wTemp03
	pla
	sta.b wTemp02
	pla
	sta.b wTemp01
	pla
	sta.b wTemp00
	phx
	jsl.l func_C36053
	plx
	dex 
	bmi @lbl_C3861F
	brl @lbl_C3859A
@lbl_C3861F:
	ldx.b #$02
@lbl_C38621:
	lda.l $7EBE70,x
	inc a
	sta.b wTemp00
	lda.l $7EBE84,x
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	sta.b wTemp01
	pha
	lda.l $7EBE7A,x
	inc a
	pha
	dec a
	sta.b wTemp00
	txa 
	ora.b #$70
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	lda.l $7EBE7A,x
	inc a
	sta.b wTemp00
	lda.l $7EBE67,x
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	lda.l $7EBE71,x
	inc a
	sta.b wTemp00
	lda.l $7EBE85,x
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	sta.b wTemp01
	pha
	lda.l $7EBE67,x
	dec a
	pha
	inc a
	sta.b wTemp00
	txa 
	inc a
	ora.b #$70
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	pla
	sta.b wTemp02
	pla
	sta.b wTemp04
	pla
	sta.b wTemp01
	pla
	sta.b wTemp00
	pla
	sta.b wTemp03
	jsr.w func_C384DD
	dex 
	dex 
	bmi @lbl_C386AC
	brl @lbl_C38621
@lbl_C386AC:
	ldx.b #$01
@lbl_C386AE:
	lda.l $7EBE66,x
	inc a
	sta.b wTemp00
	lda.l $7EBE7A,x
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	lda.l $7EBE84,x
	inc a
	pha
	dec a
	sta.b wTemp01
	txa 
	ora.b #$70
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	lda.l $7EBE84,x
	inc a
	sta.b wTemp00
	lda.l $7EBE72,x
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	lda.l $7EBE68,x
	inc a
	sta.b wTemp00
	lda.l $7EBE7C,x
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	pha
	lda.l $7EBE72,x
	dec a
	pha
	inc a
	sta.b wTemp01
	txa 
	inc a
	inc a
	ora.b #$70
	sta.b wTemp02
	phx
	jsl.l func_C36CBE
	plx
	pla
	sta.b wTemp04
	pla
	sta.b wTemp01
	pla
	sta.b wTemp03
	pla
	sta.b wTemp02
	pla
	sta.b wTemp00
	jsr.w func_C38536
	dex 
	bmi @lbl_C38735
	brl @lbl_C386AE
@lbl_C38735:
	plp 
	rts

Data_c38737:
	.db $07,$23
	.db $07,$23

Data_c3873b:
	.db $0B,$27
	.db $0B,$27

Data_c3873f:
	.db $07,$07
	.db $18,$18

Data_c38743:
	.db $09,$09
	.db $1A,$1A

Data_c38747:
	.db $18,$34
	.db $18,$34

Data_c3874b:
	.db $1C,$38
	.db $1C,$38

Data_c3874f:
	ora $20200F                             ;C3874F

Data_c38753:
	.db $11,$11
	.db $22   ;C38755
	.db $22   ;C38756
	
func_C38757:
	php
	sep #$30 ;AXY->8
	lda.b #$02
	sta.l $7EBE8E
	ldx.b #$01
@lbl_C38762:
	lda.l Data_c38855,x
	sta.b wTemp00
	lda.l Data_c38855+2,x
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	pha
	dec a
	sta.l $7EBE66,x
	lda.l Data_c38855+4,x
	sta.b wTemp00
	lda.l Data_c38855+6,x
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	pha
	dec a
	sta.l $7EBE70,x
	lda.l Data_c38855+8,x
	sta.b wTemp00
	lda.l Data_c38855+10,x
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	pha
	inc a
	sta.l $7EBE7A,x
	lda.l Data_c38855+12,x
	sta.b wTemp00
	lda.l Data_c38855+14,x
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	pha
	inc a
	sta.l $7EBE84,x
	txa 
	ora.b #$00
	sta.b wTemp04
	pla
	sta.b wTemp03
	pla
	sta.b wTemp02
	pla
	sta.b wTemp01
	pla
	sta.b wTemp00
	phx
	jsl.l func_C36053
	plx
	dex 
	bpl @lbl_C38762
	lda.l $7EBE70
	inc a
	sta.b wTemp00
	lda.l $7EBE84
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	sta.b wTemp01
	pha
	lda.l $7EBE7A
	inc a
	pha
	dec a
	sta.b wTemp00
	lda.b #$70
	sta.b wTemp02
	jsl.l func_C36CBE
	lda.l $7EBE7A
	inc a
	sta.b wTemp00
	lda.l $7EBE67
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	pha
	lda.l $7EBE71
	inc a
	sta.b wTemp00
	lda.l $7EBE85
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	sta.b wTemp01
	pha
	lda.l $7EBE67
	dec a
	pha
	inc a
	sta.b wTemp00
	lda.b #$71
	sta.b wTemp02
	jsl.l func_C36CBE
	pla
	sta.b wTemp02
	pla
	sta.b wTemp04
	pla
	sta.b wTemp01
	pla
	sta.b wTemp00
	pla
	sta.b wTemp03
	jsr.w func_C384DD
	plp 
	rts

Data_c38855:
	ora [$23]                               ;C38855
	phd                                     ;C38857
	and [$07]                               ;C38858
	ora [$0B]                               ;C3885A
	phd                                     ;C3885C
	clc                                     ;C3885D
	bit $1C,x                               ;C3885E
	sec                                     ;C38860
	asl $221E,x                             ;C38861
	.db $22   ;C38864

func_C38865:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$7E
	pha
	plb
@lbl_C3886E:
	rep #$20 ;A->16
	lda.w #$E0E0
	ldx.w #$097E
@lbl_C38876:
	sta.w $A95F,x
	dex 
	dex 
	bpl @lbl_C38876
	jsr.w func_C38757
	sep #$20 ;A->8
	jsr.w func_C36EA0
	lda.b wTemp00
	bmi @lbl_C3886E
	pha
	jsr.w func_C36D1D
	pla
	sta.b wTemp00
	jsr.w func_C36ED9
	plp 
	rts

func_C38895:
	php 
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b #$01
	sta.l $7EBE8E
	sta.l $7EC178
	lda.b #$07
	sta.l $7EC179
	lda.b #$04
	sta.b wTemp00
	dec a
	sta.l $7EBE66
	lda.b #$04
	sta.b wTemp01
	dec a
	sta.l $7EBE70
	lda.b #$3B
	sta.b wTemp02
	inc a
	sta.l $7EBE7A
	lda.b #$25
	sta.b wTemp03
	inc a
	sta.l $7EBE84
	lda.b #$00
	sta.b wTemp04
	jsl.l func_C36053
	pla
	bne @lbl_C38914
	lda.b #$04
	sta.b wTemp00
	lda.b #$25
	sta.b wTemp01
	lda.b #$3B
	sta.b wTemp02
	lda.b #$E0
	sta.b wTemp03
	jsl.l func_C35FE7
	lda.l $7EBE84
	dec a
	sta.l $7EBE84
	lda.b #$3B
	sta.b wTemp00
	lda.b #$04
	sta.b wTemp01
	lda.b #$25
	sta.b wTemp02
	lda.b #$E0
	sta.b wTemp03
	jsl.l func_C3601D
	lda.l $7EBE7A
	dec a
	sta.l $7EBE7A
@lbl_C38914:
	plp
	rts


func_C38916:
	php 
	sep #$20 ;A->8
	lda.b #$01
	sta.l $7EBE8E
	lda.b #$11
	sta.l $7EBE66
	lda.b #$06
	sta.l $7EBE70
	lda.b #$2F
	sta.l $7EBE7A
	lda.b #$24
	sta.l $7EBE84
	stz.b wTemp00
	jsr.w func_C36D1D
	plp 
	rts


func_C3893E:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l $7EC179
	cmp.b #$02
	bcs @lbl_C38963
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$08
	beq @lbl_C3895D
	jsl.l func_C62B37
	lda.b wTemp00
	bne @lbl_C38963
@lbl_C3895D:
	jsl.l GetTransitionDestX
	bra @lbl_C38967
@lbl_C38963:
	jsl.l func_C3608D
@lbl_C38967:
	ldx.b wTemp00
	lda.b #$13
	sta.b wTemp00
	stx.b wTemp02
	phx
	jsl.l func_C20DD1
	plx
	stx.b wTemp00
	lda.b #$13
	sta.b wTemp02
	jsl.l func_C35B7A
	plp
	rtl

func_C38981:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$0007
@lbl_C38989:
	phy
	jsl.l func_C3608D
	ply
	ldx.b wTemp00
	phx
	phy
	jsl.l func_C20BE7
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C389A5
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C35B7A
@lbl_C389A5:
	dey
	bne @lbl_C38989
	plp
	rtl

func_C389AA:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l func_C627C8
	lda.b wTemp00
	bpl @lbl_C389D9
	ldy.w #$0003
@lbl_C389BA:
	phy
	jsl.l func_C36203
	ply
	ldx.b wTemp00
	phx
	phy
	jsl.l SpawnRandomFloorItemOrGitan
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C389D6
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C35BA2
@lbl_C389D6:
	dey
	bpl @lbl_C389BA
@lbl_C389D9:
	plp
	rtl

func_C389DB:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l $7EC179
	cmp.b #$07
	beq @lbl_C38A36
	cmp.b #$08
	beq @lbl_C38A36
@lbl_C389EC:
	jsl.l func_C36203
	ldy.b wTemp00
	jsl.l func_C359AF
	lda.b #$00
	xba
	lda.b wTemp02
	bit.b #$10
	bne @lbl_C38A0A
	and.b #$0F
	tax
	lda.l $7EC166,x
	bit.b #$10
	bne @lbl_C389EC
@lbl_C38A0A:
	sty.b wTemp00
	lda.b wTemp00
	sta.l $7EC172
	lda.b wTemp01
	sta.l $7EC173
	lda.b #$83
	sta.b wTemp02
	jsl.l func_C35BA2
	plp
	rtl
	lda $00                                 ;C38A22
	cmp #$18                                ;C38A24
	.db $90,$E4   ;C38A26
	cmp #$20                                ;C38A28
	.db $B0,$E0   ;C38A2A
	lda $01                                 ;C38A2C
	cmp #$10                                ;C38A2E
	.db $90,$DA   ;C38A30
	cmp #$18                                ;C38A32
	.db $B0,$D6   ;C38A34
@lbl_C38A36:
	jsl $C36203                             ;C38A36
	.db $80,$E6   ;C38A3A

func_C38A3C:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l GetCurrentFloor
	lda.b wTemp00
	pha
	jsl.l GetCurrentDungeon
	lda.b #$00
	xba
	lda.b wTemp00
	asl a
	tax
	lda.l UNREACH_C38AA7,x
	sta.b w00a9
	lda.l UNREACH_C38AA8,x
	sta.b w00aa
	restorebank
	ldy.w #$0000
@lbl_C38A64:
	lda.b ($A9),y
	cmp.b wTemp01,s
	bcs @lbl_C38A6F
	iny
	iny
	iny
	bra @lbl_C38A64
@lbl_C38A6F:
	iny
	lda.b ($A9),y
	sta.b wTemp00
	iny
	lda.b ($A9),y
	sta.b wTemp01
	jsl.l GetRandomInRange
	stz.b wTemp01
	ldy.b wTemp00
@lbl_C38A81:
	phy
	jsl.l func_C36287
	ply
	ldx.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp00
	phx
	phy
	jsl.l func_C3D3AB
	ply
	plx
	lda.b wTemp00
	ora.b #$C0
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C35BA2
	dey
	bne @lbl_C38A81
	pla
	plp
	rtl

UNREACH_C38AA7:
	.db $C1                               ;C38AA7  

UNREACH_C38AA8:
	.db $8A                               ;C38AA8
	.db $C7,$8A                           ;C38AA9
	.db $C7,$8A,$D3,$8A,$C7,$8A,$C7,$8A,$C7,$8A,$C7,$8A,$C7,$8A,$C7,$8A   ;C38AAB  
	.db $C7,$8A,$C7,$8A,$C7,$8A,$0A,$01   ;C38ABB  
	.db $03,$63,$01,$03                   ;C38AC3  
	.db $0A,$01,$03,$14,$03,$05,$1E,$05   ;C38AC7
	.db $07                               ;C38ACF
	.db $63,$07,$09,$63,$07,$09           ;C38AD0  

func_C38AD6:
	php
	sep #$20 ;A->8
	stz.b wTemp00
	stz.b wTemp01
	lda.b #$3F
	sta.b wTemp02
	lda.b #$03
	sta.b wTemp03
	lda.b #$F0
	sta.b wTemp04
	jsl.l func_C36053
	stz.b wTemp00
	lda.b #$26
	sta.b wTemp01
	lda.b #$3F
	sta.b wTemp02
	lda.b #$29
	sta.b wTemp03
	lda.b #$F0
	sta.b wTemp04
	jsl.l func_C36053
	stz.b wTemp00
	stz.b wTemp01
	lda.b #$03
	sta.b wTemp02
	lda.b #$29
	sta.b wTemp03
	lda.b #$F0
	sta.b wTemp04
	jsl.l func_C36053
	lda.b #$3C
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$3F
	sta.b wTemp02
	lda.b #$29
	sta.b wTemp03
	lda.b #$F0
	sta.b wTemp04
	jsl.l func_C36053
	plp
	rtl

func_C38B2F:
	php
	rep #$30 ;AXY->16
	jsl.l Get7ED5EE
	lda.b wTemp00
	and.w #$00FF
	sec
	sbc.w #$000A
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	jsl.l func_C36BB0
	lda.b wTemp00
	dec a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tay
	sep #$20 ;A->8
	lda.l DATA8_C3A15F,x
	sta.b wTemp00
	lda.l DATA8_C3A15F+1,x
	sta.b wTemp01
	lda.l DATA8_C3A15F+2,x
	sta.b wTemp02
	lda.b [wTemp00],y
	sta.b w00a9
	iny
	lda.b [wTemp00],y
	sta.b w00aa
	iny
	lda.b [wTemp00],y
	sta.b w00ab
	bankswitch 0x7E
	ldy.w #$0000
	ldx.w #$0104
@lbl_C38B80:
	lda.b [$A9],y
	cmp.b #$FF
	beq @lbl_C38BAC
	pha
	iny
	lda.b [$A9],y
@lbl_C38B8A:
	pha
	lda.b wTemp02,s
	sta.w $A95F,x
	inx
	pla
	dec a
	bne @lbl_C38B8A
	pla
	iny
	rep #$20 ;A->16
	txa
	and.w #$003F
	cmp.w #$003C
	bcc @lbl_C38BA8
	txa
	clc
	adc.w #$0008
	tax
@lbl_C38BA8:
	sep #$20 ;A->8
	bra @lbl_C38B80
@lbl_C38BAC:
	plp
	rtl

func_C38BAE:
	php
	sep #$30 ;AXY->8
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bne @lbl_C38BC5
	jsl.l Get7ED5EC
	lda.b wTemp00
	cmp.b #$0A
	beq @lbl_C38BC7
@lbl_C38BC5:
	plp
	rts
@lbl_C38BC7:
	GetEvent Event_Naoki
	beq @lbl_C38BF9
	GetEvent Event_Gaibara
	beq @lbl_C38BF9
	.db $A9,$09,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$01,$D0,$0F,$A9,$88   ;C38BDF
	.db $85,$00
	jsl.l _GetEvent
	.db $A5,$00   ;C38BEF  
	.db $F0,$03                           ;C38BF7  
@lbl_C38BF9:
	jsr.w func_C38BFE
	plp
	rts

func_C38BFE:
	lda.b #$36
	ldy.b #$08
@lbl_C38C02:
	cpy.b #$04
	bcc @lbl_C38C28
	ldx.b #$3B
@lbl_C38C08:
	cpx.b #$31
	bcc @lbl_C38C25
	pha
	phx
	tax
	lda.l DATA8_C38C39,x
	sta.b wTemp02
	sty.b wTemp01
	plx
	stx.b wTemp00
	phx
	jsl.l func_C36CBE
	plx
	pla
	dec a
	dex
	bra @lbl_C38C08
@lbl_C38C25:
	dey
	bra @lbl_C38C02
@lbl_C38C28:
	lda.b #$38
	sta.b wTemp00
	lda.b #$05
	sta.b wTemp01
	lda.b #$80
	sta.b wTemp02
	jsl.l func_C35BA2
	rts

DATA8_C38C39:
	.db $B0,$B0,$B0,$00,$00,$00,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$00,$00   ;C38C39
	.db $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$00,$00,$00,$00,$B0,$B0,$B0   ;C38C49
	.db $B0,$B0,$B0,$00,$00,$00,$00,$00,$00,$B0,$B0,$B0,$B0,$B0,$00,$00   ;C38C59
	.db $00,$00,$B0,$B0,$B0,$B0,$B0       ;C38C69

func_C38C70:
	php
	sep #$30 ;AXY->8
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bne @lbl_C38C9D
	lda.l wMapNum
	ldx.b #$04
	cmp.b #$06
	beq @lbl_C38C93
	ldx.b #$03
	cmp.b #$0A
	beq @lbl_C38C93
	ldx.b #$01
	cmp.b #$0F
	bne @lbl_C38C9D
@lbl_C38C93:
	lda.l $7EC166,x
	ora.b #$20
	sta.l $7EC166,x
@lbl_C38C9D:
	plp
	rts

func_C38C9F:
	php
	rep #$30 ;AXY->16
	jsl.l Get7ED5EE
	lda.b wTemp00
	and.w #$00FF
	sec
	sbc.w #$000A
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	jsl.l func_C36BB0
	lda.b wTemp00
	dec a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tay
	sep #$20 ;A->8
	lda.l DATA8_C3A454,x
	sta.b wTemp00
	lda.l DATA8_C3A454+1,x
	sta.b wTemp01
	lda.l DATA8_C3A454+2,x
	sta.b wTemp02
	lda.b [wTemp00],y
	sta.b w00a9
	iny
	lda.b [wTemp00],y
	sta.b w00aa
	iny
	lda.b [wTemp00],y
	sta.b w00ab
	ldy.w #$0000
@lbl_C38CE9:
	lda.b [$A9],y
	bmi @lbl_C38D16
	sta.b wTemp00
	iny
	lda.b [$A9],y
	sta.b wTemp01
	iny
	lda.b [$A9],y
	sta.b wTemp02
	cmp.b #$83
	bne @lbl_C38D0F
	lda.l $7EC172
	bpl @lbl_C38D0F
	lda.b wTemp00
	sta.l $7EC172
	lda.b wTemp01
	sta.l $7EC173
@lbl_C38D0F:
	jsl.l func_C35BA2
	iny
	bra @lbl_C38CE9
@lbl_C38D16:
	plp
	rtl

func_C38D18:
	php
	rep #$30 ;AXY->16
	jsl.l func_C36BB0
	lda.b wTemp00
	dec a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	sep #$20 ;A->8
	lda.l DATA8_DAEC36,x
	sta.b w00a9
	lda.l DATA8_DAEC36+1,x
	sta.b w00aa
	lda.l DATA8_DAEC36+2,x
	sta.b w00ab
	ldy.w #$0000
@lbl_C38D40:
	lda.b #$00
	xba
	lda.b [$A9],y
	bmi @lbl_C38D69
	ora.b #$00
	tax
	iny
	lda.b [$A9],y
	sta.l $7EBE66,x
	iny
	lda.b [$A9],y
	sta.l $7EBE70,x
	iny
	lda.b [$A9],y
	sta.l $7EBE7A,x
	iny
	lda.b [$A9],y
	sta.l $7EBE84,x
	iny
	bra @lbl_C38D40
@lbl_C38D69:
	iny
	lda.b [$A9],y
	sta.l $7EBE8E
	plp
	rtl

func_C38D72:
	php
	rep #$30 ;AXY->16
	jsl.l func_C36BB0
	lda.b wTemp00
	dec a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	sep #$20 ;A->8
	lda.l DATA8_DAF9C1,x
	sta.b w00a9
	lda.l DATA8_DAF9C1+1,x
	sta.b w00aa
	lda.l DATA8_DAF9C1+2,x
	sta.b w00ab
	ldy.w #$FFFF
	stz.b wTemp01
@lbl_C38D9C:
	stz.b wTemp02
	lda.b #$00
	xba
	iny
	lda.b [$A9],y
	cmp.b #$FF
	beq @lbl_C38DD2
	and.b #$0F
	sta.b wTemp00
	asl a
	asl a
	asl a
	ora.b wTemp02
	tax
@lbl_C38DB2:
	iny
	lda.b [$A9],y
	cmp.b #$FE
	beq @lbl_C38DC7
	sta.l $7EC094,x
	iny
	lda.b [$A9],y
	sta.l $7EC0E4,x
	inx
	bra @lbl_C38DB2
@lbl_C38DC7:
	iny
	lda.b [$A9],y
	ldx.b wTemp00
	sta.l $7EC134,x
	bra @lbl_C38D9C
@lbl_C38DD2:
	plp
	rtl

func_C38DD4:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l FeisProblemsMapTerrainDataTable,x
	sta.b w00a9
	lda.l FeisProblemsMapTerrainDataTable+1,x
	sta.b w00aa
	lda.l FeisProblemsMapTerrainDataTable+2,x
	sta.b w00ab
	ldy.w #$0000
@lbl_C38DEE:
	lda.b [$A9],y
	bmi @lbl_C38E05
	sta.b wTemp00
	iny
	lda.b [$A9],y
	sta.b wTemp01
	iny
	lda.b [$A9],y
	sta.b wTemp02
	jsl.l func_C35C72
	iny
	bra @lbl_C38DEE
@lbl_C38E05:
	plp
	rtl

func_C38E07:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l FeisProblemsMapItemDataTable,x
	sta.b w00a9
	lda.l FeisProblemsMapItemDataTable+1,x
	sta.b w00aa
	lda.l FeisProblemsMapItemDataTable+2,x
	sta.b w00ab
	ldy.w #$0000
	lda.b [$A9],y
	bpl @lbl_C38E27
	plp
	rtl
@lbl_C38E27:
	sta $00                                 ;C38E27
	iny                                     ;C38E29
	lda [$A9],y                             ;C38E2A
	sta $01                                 ;C38E2C
	ldx $00                                 ;C38E2E
	iny                                     ;C38E30
	lda [$A9],y                             ;C38E31
	sta $00                                 ;C38E33
	iny                                     ;C38E35
	lda [$A9],y                             ;C38E36
	sta $01                                 ;C38E38
	iny                                     ;C38E3A
	lda [$A9],y                             ;C38E3B
	sta $04                                 ;C38E3D
	iny                                     ;C38E3F
	lda [$A9],y                             ;C38E40
	sta $06                                 ;C38E42
	lda $00                                 ;C38E44
	cmp #$E5                                ;C38E46
	beq @lbl_C38E7E                         ;C38E48
	lda $01                                 ;C38E4A
	cmp #$80                                ;C38E4C
	beq @lbl_C38E68                         ;C38E4E
	stz $02                                 ;C38E50
	lda $04                                 ;C38E52
	pha                                     ;C38E54
	lda $06                                 ;C38E55
	pha                                     ;C38E57
	phx                                     ;C38E58
	phy                                     ;C38E59
	jsl $C30295                             ;C38E5A
	ply                                     ;C38E5E
	plx                                     ;C38E5F
	pla                                     ;C38E60
	sta $06                                 ;C38E61
	pla                                     ;C38E63
	sta $04                                 ;C38E64
	bra @lbl_C38E92                         ;C38E66
@lbl_C38E68:
	lda $04                                 ;C38E68
	pha                                     ;C38E6A
	lda $06                                 ;C38E6B
	pha                                     ;C38E6D
	phx                                     ;C38E6E
	phy                                     ;C38E6F
	jsl $C3035D                             ;C38E70
	ply                                     ;C38E74
	plx                                     ;C38E75
	pla                                     ;C38E76
	sta $06                                 ;C38E77
	pla                                     ;C38E79
	sta $04                                 ;C38E7A
	bra @lbl_C38E92                         ;C38E7C
@lbl_C38E7E:
	lda $04                                 ;C38E7E
	pha                                     ;C38E80
	lda $06                                 ;C38E81
	pha                                     ;C38E83
	phx                                     ;C38E84
	phy                                     ;C38E85
	jsl $C305F3                             ;C38E86
	ply                                     ;C38E8A
	plx                                     ;C38E8B
	pla                                     ;C38E8C
	sta $06                                 ;C38E8D
	pla                                     ;C38E8F
	sta $04                                 ;C38E90
@lbl_C38E92:
	lda $00                                 ;C38E92
	bmi @lbl_C38EC8                         ;C38E94
	lda $04                                 ;C38E96
	beq @lbl_C38EAE                         ;C38E98
	lda $00                                 ;C38E9A
	pha                                     ;C38E9C
	lda $06                                 ;C38E9D
	pha                                     ;C38E9F
	phx                                     ;C38EA0
	phy                                     ;C38EA1
	jsl $C30192                             ;C38EA2
	ply                                     ;C38EA6
	plx                                     ;C38EA7
	pla                                     ;C38EA8
	sta $06                                 ;C38EA9
	pla                                     ;C38EAB
	sta $00                                 ;C38EAC
@lbl_C38EAE:
	lda $06                                 ;C38EAE
	beq @lbl_C38EBE                         ;C38EB0
	lda #$01                                ;C38EB2
	sta $01                                 ;C38EB4
	phx                                     ;C38EB6
	phy                                     ;C38EB7
	jsl $C33A92                             ;C38EB8
	ply                                     ;C38EBC
	plx                                     ;C38EBD
@lbl_C38EBE:
	lda $00                                 ;C38EBE
	sta $02                                 ;C38EC0
	stx $00                                 ;C38EC2
	jsl $C35BA2                             ;C38EC4
@lbl_C38EC8:
	iny                                     ;C38EC8
	.db $82,$55,$FF   ;C38EC9

func_C38ECC:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l FeisProblemsMapStairsDataTable,x
	sta.b w00a9
	lda.l FeisProblemsMapStairsDataTable+1,x
	sta.b w00aa
	lda.l FeisProblemsMapStairsDataTable+2,x
	sta.b w00ab
	ldy.w #$0000
	lda.b [$A9],y
	sta.b wTemp00
	sta.l $7EC172
	iny
	lda.b [$A9],y
	sta.b wTemp01
	sta.l $7EC173
	lda.b #$83
	sta.b wTemp02
	jsl.l func_C35BA2
	plp
	rtl

func_C38F01:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l FeisProblemsMapTrapDataTable,x
	sta.b w00a9
	lda.l FeisProblemsMapTrapDataTable+1,x
	sta.b w00aa
	lda.l FeisProblemsMapTrapDataTable+2,x
	sta.b w00ab
	ldy.w #$0000
	lda.b [$A9],y
	bmi @lbl_C38F32
	sta $00                                 ;C38F1F
	iny                                     ;C38F21
	lda [$A9],y                             ;C38F22
	sta $01                                 ;C38F24
	iny                                     ;C38F26
	lda [$A9],y                             ;C38F27
	sta $02                                 ;C38F29
	jsl $C35BA2                             ;C38F2B
	iny                                     ;C38F2F
	.db $80,$E9   ;C38F30
@lbl_C38F32:
	plp
	rtl

func_C38F34:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l FeisProblemsMapCharacterDataTable,x
	sta.b w00a9
	lda.l FeisProblemsMapCharacterDataTable+1,x
	sta.b w00aa
	lda.l FeisProblemsMapCharacterDataTable+2,x
	sta.b w00ab
	ldy.w #$0000
	lda.b [$A9],y
	bpl @lbl_C38F54
	plp
	rtl
@lbl_C38F54:
	sta $00                                 ;C38F54
	iny                                     ;C38F56
	lda [$A9],y                             ;C38F57
	sta $01                                 ;C38F59
	ldx $00                                 ;C38F5B
	jsl $C3F65F                             ;C38F5D
	lda $00                                 ;C38F61
	and #$07                                ;C38F63
	sta $02                                 ;C38F65
	iny                                     ;C38F67
	lda [$A9],y                             ;C38F68
	sta $03                                 ;C38F6A
	iny                                     ;C38F6C
	lda [$A9],y                             ;C38F6D
	sta $04                                 ;C38F6F
	stx $00                                 ;C38F71
	phx                                     ;C38F73
	phy                                     ;C38F74
	jsl $C20086                             ;C38F75
	ply                                     ;C38F79
	plx                                     ;C38F7A
	lda $00                                 ;C38F7B
	bpl @lbl_C38F82                         ;C38F7D
	iny                                     ;C38F7F
	bra @lbl_C38FB3                         ;C38F80
@lbl_C38F82:
	iny                                     ;C38F82
	lda [$A9],y                             ;C38F83
	cmp #$02                                ;C38F85
	bne @lbl_C38F93                         ;C38F87
	phx                                     ;C38F89
	phy                                     ;C38F8A
	jsl $C27E85                             ;C38F8B
	ply                                     ;C38F8F
	plx                                     ;C38F90
	bra @lbl_C38FA9                         ;C38F91
@lbl_C38F93:
	cmp #$01                                ;C38F93
	bne @lbl_C38FA1                         ;C38F95
	phx                                     ;C38F97
	phy                                     ;C38F98
	jsl $C27E78                             ;C38F99
	ply                                     ;C38F9D
	plx                                     ;C38F9E
	bra @lbl_C38FA9                         ;C38F9F
@lbl_C38FA1:
	phx                                     ;C38FA1
	phy                                     ;C38FA2
	jsl $C27FAA                             ;C38FA3
	ply                                     ;C38FA7
	plx                                     ;C38FA8
@lbl_C38FA9:
	lda $00                                 ;C38FA9
	sta $02                                 ;C38FAB
	stx $00                                 ;C38FAD
	jsl $C35B7A                             ;C38FAF
@lbl_C38FB3:
	iny                                     ;C38FB3
	.db $82,$97,$FF   ;C38FB4

func_C38FB7:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l FeisProblemsMapRoomDataTable,x
	sta.b w00a9
	lda.l FeisProblemsMapRoomDataTable+1,x
	sta.b w00aa
	lda.l FeisProblemsMapRoomDataTable+2,x
	sta.b w00ab
	ldy.w #$0000
@lbl_C38FD1:
	lda.b #$00
	xba
	lda.b [$A9],y
	bmi @lbl_C39018
	tax
	iny
	lda.b [$A9],y
	sta.l $7EBE66,x
	inc a
	sta.b wTemp00
	iny
	lda.b [$A9],y
	sta.l $7EBE70,x
	inc a
	sta.b wTemp01
	iny
	lda.b [$A9],y
	sta.l $7EBE7A,x
	dec a
	sta.b wTemp02
	iny
	lda.b [$A9],y
	sta.l $7EBE84,x
	dec a
	sta.b wTemp03
	txa
	ora.b #$00
	sta.b wTemp04
	phx
	phy
	jsl.l func_C36053
	ply
	plx
	iny
	lda.b [$A9],y
	sta.l $7EC166,x
	iny
	bra @lbl_C38FD1
@lbl_C39018:
	iny
	lda.b [$A9],y
	sta.l $7EBE8E
	plp
	rtl

func_C39021:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	bankswitch 0x7E
	ldx.w #$0877
@lbl_C3902D:
	lda.w $A95F,x
	sta.w $AA63,x
	dex
	bpl @lbl_C3902D
	lda.b #$00
	xba
	lda.w $BE8E
	dec a
	tax
@lbl_C3903E:
	lda.w $BE66,x
	clc
	adc.b #$04
	sta.w $BE66,x
	lda.w $BE70,x
	clc
	adc.b #$04
	sta.w $BE70,x
	lda.w $BE7A,x
	clc
	adc.b #$04
	sta.w $BE7A,x
	lda.w $BE84,x
	clc
	adc.b #$04
	sta.w $BE84,x
	dex
	bpl @lbl_C3903E
	plp
	rtl

func_C39067:
	php
	sep #$30 ;AXY->8
	lda.l $7EBE8E
	tax
@lbl_C3906F:
	dex
	bmi @lbl_C3909A
	lda.l $7EC166,x
	bit.b #$02
	beq @lbl_C3906F
	.db $BF,$66,$BE,$7E,$C5,$00,$B0,$ED,$A5,$00,$DF,$7A,$BE,$7E,$B0,$E5   ;C3907A  
	.db $BF,$70,$BE,$7E,$C5,$01,$B0,$DD,$A5,$01,$DF,$84,$BE,$7E,$B0,$D5   ;C3908A  
@lbl_C3909A:
	stx.b wTemp00
	plp
	rtl

func_C3909E:
	php
	sep #$30 ;AXY->8
	lda.l $7EBE8E
	tax
	rep #$10 ;XY->16
@lbl_C390A8:
	dex
	bmi @lbl_C390D3
	lda.l $7EC166,x
	bit.b #$07
	bne @lbl_C390A8
	lda.l $7EBE66,x
	cmp.b wTemp00
	bcs @lbl_C390A8
	lda.b wTemp00
	cmp.l $7EBE7A,x
	bcs @lbl_C390A8
	lda.l $7EBE70,x
	cmp.b wTemp01
	bcs @lbl_C390A8
	lda.b wTemp01
	cmp.l $7EBE84,x
	bcs @lbl_C390A8
@lbl_C390D3:
	stx.b wTemp00
	plp
	rtl
	php                                     ;C390D7
	sep #$30                                ;C390D8
	ldx $00                                 ;C390DA
	lda $7EBE66,x                           ;C390DC
	pha                                     ;C390E0
	inc a                                   ;C390E1
	sta $00                                 ;C390E2
	lda $7EBE70,x                           ;C390E4
	pha                                     ;C390E8
	inc a                                   ;C390E9
	sta $01                                 ;C390EA
	lda $7EBE7A,x                           ;C390EC
	pha                                     ;C390F0
	dec a                                   ;C390F1
	sta $02                                 ;C390F2
	lda $7EBE84,x                           ;C390F4
	pha                                     ;C390F8
	dec a                                   ;C390F9
	sta $03                                 ;C390FA
	txa                                     ;C390FC
	ora #$00                                ;C390FD
	sta $04                                 ;C390FF
	txa                                     ;C39101
	ora #$70                                ;C39102
	pha                                     ;C39104
	jsl $C391C0                             ;C39105
	lda $05,s                               ;C39109
	tax                                     ;C3910B
	lda $04,s                               ;C3910C
	tay                                     ;C3910E
@lbl_C3910F:
	txa                                     ;C3910F
	cmp $03,s                               ;C39110
	bcs @lbl_C39135                         ;C39112
	stx $00                                 ;C39114
	sty $01                                 ;C39116
	phx                                     ;C39118
	jsl $C36CA5                             ;C39119
	plx                                     ;C3911D
	lda $00                                 ;C3911E
	bit #$80                                ;C39120
	bne @lbl_C39132                         ;C39122
	stx $00                                 ;C39124
	sty $01                                 ;C39126
	lda $01,s                               ;C39128
	sta $02                                 ;C3912A
	phx                                     ;C3912C
	jsl $C36CBE                             ;C3912D
	plx                                     ;C39131
@lbl_C39132:
	inx                                     ;C39132
	bra @lbl_C3910F                         ;C39133
@lbl_C39135:
	lda $05,s                               ;C39135
	tax                                     ;C39137
	lda $02,s                               ;C39138
	tay                                     ;C3913A
@lbl_C3913B:
	txa                                     ;C3913B
	cmp $03,s                               ;C3913C
	bcs @lbl_C39161                         ;C3913E
	stx $00                                 ;C39140
	sty $01                                 ;C39142
	phx                                     ;C39144
	jsl $C36CA5                             ;C39145
	plx                                     ;C39149
	lda $00                                 ;C3914A
	bit #$80                                ;C3914C
	bne @lbl_C3915E                         ;C3914E
	stx $00                                 ;C39150
	sty $01                                 ;C39152
	lda $01,s                               ;C39154
	sta $02                                 ;C39156
	phx                                     ;C39158
	jsl $C36CBE                             ;C39159
	plx                                     ;C3915D
@lbl_C3915E:
	inx                                     ;C3915E
	bra @lbl_C3913B                         ;C3915F
@lbl_C39161:
	lda $05,s                               ;C39161
	tax                                     ;C39163
	lda $04,s                               ;C39164
	tay                                     ;C39166
@lbl_C39167:
	tya                                     ;C39167
	cmp $02,s                               ;C39168
	bcs @lbl_C3918D                         ;C3916A
	stx $00                                 ;C3916C
	sty $01                                 ;C3916E
	phx                                     ;C39170
	jsl $C36CA5                             ;C39171
	plx                                     ;C39175
	lda $00                                 ;C39176
	bit #$80                                ;C39178
	bne @lbl_C3918A                         ;C3917A
	stx $00                                 ;C3917C
	sty $01                                 ;C3917E
	lda $01,s                               ;C39180
	sta $02                                 ;C39182
	phx                                     ;C39184
	jsl $C36CBE                             ;C39185
	plx                                     ;C39189
@lbl_C3918A:
	iny                                     ;C3918A
	bra @lbl_C39167                         ;C3918B
@lbl_C3918D:
	lda $03,s                               ;C3918D
	tax                                     ;C3918F
	lda $04,s                               ;C39190
	tay                                     ;C39192
@lbl_C39193:
	tya                                     ;C39193
	cmp $02,s                               ;C39194
	bcs @lbl_C391B9                         ;C39196
	stx $00                                 ;C39198
	sty $01                                 ;C3919A
	phx                                     ;C3919C
	jsl $C36CA5                             ;C3919D
	plx                                     ;C391A1
	lda $00                                 ;C391A2
	bit #$80                                ;C391A4
	bne @lbl_C391B6                         ;C391A6
	stx $00                                 ;C391A8
	sty $01                                 ;C391AA
	lda $01,s                               ;C391AC
	sta $02                                 ;C391AE
	phx                                     ;C391B0
	jsl $C36CBE                             ;C391B1
	plx                                     ;C391B5
@lbl_C391B6:
	iny                                     ;C391B6
	bra @lbl_C39193                         ;C391B7
@lbl_C391B9:
	pla                                     ;C391B9
	pla                                     ;C391BA
	pla                                     ;C391BB
	pla                                     ;C391BC
	pla                                     ;C391BD
	plp                                     ;C391BE
	rtl                                     ;C391BF
	php                                     ;C391C0
	sep #$30                                ;C391C1
	lda $01                                 ;C391C3
	pha                                     ;C391C5
	lda $02                                 ;C391C6
	inc a                                   ;C391C8
	pha                                     ;C391C9
	lda $03                                 ;C391CA
	inc a                                   ;C391CC
	pha                                     ;C391CD
	lda $04                                 ;C391CE
	pha                                     ;C391D0
	ldx $00                                 ;C391D1
@lbl_C391D3:
	lda $04,s                               ;C391D3
	tay                                     ;C391D5
	txa                                     ;C391D6
	cmp $03,s                               ;C391D7
	bcs @lbl_C391F4                         ;C391D9
@lbl_C391DB:
	tya                                     ;C391DB
	cmp $02,s                               ;C391DC
	bcs @lbl_C391F1                         ;C391DE
	stx $00                                 ;C391E0
	sty $01                                 ;C391E2
	lda $01,s                               ;C391E4
	sta $02                                 ;C391E6
	phx                                     ;C391E8
	jsl $C35C72                             ;C391E9
	plx                                     ;C391ED
	iny                                     ;C391EE
	bra @lbl_C391DB                         ;C391EF
@lbl_C391F1:
	inx                                     ;C391F1
	bra @lbl_C391D3                         ;C391F2
@lbl_C391F4:
	pla                                     ;C391F4
	pla                                     ;C391F5
	pla                                     ;C391F6
	pla                                     ;C391F7
	plp                                     ;C391F8
	rtl                                     ;C391F9
.INDEX 16

func_C391FA:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C39215
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$15
	bcc @lbl_C3922F
	cmp.b #$1E
	bcs @lbl_C3922F
@lbl_C39215:
	lda.l $7EBE8E
	cmp.b #$01
	beq @lbl_C3922F
	jsl.l Random
	lda.b wTemp00
	bit.b #$01
	bne @lbl_C3922F
;C39227  
	jsl $C39231                             ;C39227
	jsl $C392FD                             ;C3922B
@lbl_C3922F:
	plp
	rtl
	php                                     ;C39231
	sep #$30                                ;C39232
	jsl $C3F65F                             ;C39234
	lda $00                                 ;C39238
	bit #$01                                ;C3923A
	beq @lbl_C39240                         ;C3923C
	plp                                     ;C3923E
	rtl                                     ;C3923F
@lbl_C39240:
	stz $00                                 ;C39240
	lda $7EBE8E                             ;C39242
	dec a                                   ;C39246
	sta $01                                 ;C39247
	jsl $C3F69F                             ;C39249
	ldx $00                                 ;C3924D
	lda $7EC166,x                           ;C3924F
	bit #$04                                ;C39253
	bne @lbl_C39240                         ;C39255
	stz $00                                 ;C39257
	lda $7EC134,x                           ;C39259
	dec a                                   ;C3925D
	sta $01                                 ;C3925E
	phx                                     ;C39260
	jsl $C3F69F                             ;C39261
	plx                                     ;C39265
	ldy $00                                 ;C39266
	sty $01                                 ;C39268
	stx $00                                 ;C3926A
	jsl $C36549                             ;C3926C
	ldy $01                                 ;C39270
	phy                                     ;C39272
	ldx $00                                 ;C39273
	phx                                     ;C39275
	lda #$C1                                ;C39276
	sta $02                                 ;C39278
	jsl $C36CBE                             ;C3927A
@lbl_C3927E:
	jsl $C3F65F                             ;C3927E
	lda $00                                 ;C39282
	and #$03                                ;C39284
	tax                                     ;C39286
	ldy #$03                                ;C39287
@lbl_C39289:
	lda $01,s                               ;C39289
	clc                                     ;C3928B
	adc $C392ED,x                           ;C3928C
	sta $00                                 ;C39290
	sta $04                                 ;C39292
	lda $02,s                               ;C39294
	clc                                     ;C39296
	adc $C392F5,x                           ;C39297
	sta $01                                 ;C3929B
	sta $06                                 ;C3929D
	phx                                     ;C3929F
	jsl $C36CA5                             ;C392A0
	plx                                     ;C392A4
	lda $00                                 ;C392A5
	bit #$80                                ;C392A7
	bne @lbl_C392E1                         ;C392A9
	cmp #$30                                ;C392AB
	beq @lbl_C392C5                         ;C392AD
	bit #$40                                ;C392AF
	beq @lbl_C392E1                         ;C392B1
	lda $04                                 ;C392B3
	sta $00                                 ;C392B5
	lda $06                                 ;C392B7
	sta $01                                 ;C392B9
	lda #$C1                                ;C392BB
	sta $02                                 ;C392BD
	jsl $C36CBE                             ;C392BF
	bra @lbl_C392E5                         ;C392C3
@lbl_C392C5:
	lda $04                                 ;C392C5
	sta $00                                 ;C392C7
	lda $06                                 ;C392C9
	sta $01                                 ;C392CB
	lda #$C0                                ;C392CD
	sta $02                                 ;C392CF
	phx                                     ;C392D1
	jsl $C36CBE                             ;C392D2
	plx                                     ;C392D6
	lda $00                                 ;C392D7
	sta $01,s                               ;C392D9
	lda $01                                 ;C392DB
	sta $02,s                               ;C392DD
	bra @lbl_C3927E                         ;C392DF
@lbl_C392E1:
	inx                                     ;C392E1
	dey                                     ;C392E2
	bpl @lbl_C39289                         ;C392E3
@lbl_C392E5:
	pla                                     ;C392E5
	pla                                     ;C392E6
	jsl $C371AB                             ;C392E7
	plp                                     ;C392EB
	rtl                                     ;C392EC
	.db $00,$00,$FF,$01,$00,$00,$FF,$01,$FF,$01,$00,$00,$FF,$01,$00,$00   ;C392ED
	php                                     ;C392FD
	sep #$30                                ;C392FE
	jsl $C3F65F                             ;C39300
	lda $00                                 ;C39304
	bit #$01                                ;C39306
	bne @lbl_C39328                         ;C39308
	ldy #$09                                ;C3930A
@lbl_C3930C:
	stz $00                                 ;C3930C
	lda $7EBE8E                             ;C3930E
	dec a                                   ;C39312
	sta $01                                 ;C39313
	phy                                     ;C39315
	jsl $C3F69F                             ;C39316
	ply                                     ;C3931A
	ldx $00                                 ;C3931B
	lda $7EC166,x                           ;C3931D
	cmp #$00                                ;C39321
	beq @lbl_C3932A                         ;C39323
	dey                                     ;C39325
	bpl @lbl_C3930C                         ;C39326
@lbl_C39328:
	plp                                     ;C39328
	rtl                                     ;C39329
@lbl_C3932A:
	ora #$02                                ;C3932A
	sta $7EC166,x                           ;C3932C
	lda $7EBE84,x                           ;C39330
	pha                                     ;C39334
	lda $7EBE7A,x                           ;C39335
	pha                                     ;C39339
	lda $7EBE70,x                           ;C3933A
	inc a                                   ;C3933E
	pha                                     ;C3933F
	lda $7EBE66,x                           ;C39340
	inc a                                   ;C39344
	tax                                     ;C39345
@lbl_C39346:
	lda $01,s                               ;C39346
	tay                                     ;C39348
	txa                                     ;C39349
	cmp $02,s                               ;C3934A
	bcs @lbl_C3937D                         ;C3934C
@lbl_C3934E:
	tya                                     ;C3934E
	cmp $03,s                               ;C3934F
	bcs @lbl_C3937A                         ;C39351
	stx $00                                 ;C39353
	sty $01                                 ;C39355
	lda #$C2                                ;C39357
	sta $02                                 ;C39359
	phx                                     ;C3935B
	jsl $C36CBE                             ;C3935C
	plx                                     ;C39360
	stx $00                                 ;C39361
	sty $01                                 ;C39363
	phx                                     ;C39365
	jsl $C359AF                             ;C39366
	plx                                     ;C3936A
	lda $00                                 ;C3936B
	bmi @lbl_C39377                         ;C3936D
	phx                                     ;C3936F
	phy                                     ;C39370
	jsl $C27E85                             ;C39371
	ply                                     ;C39375
	plx                                     ;C39376
@lbl_C39377:
	iny                                     ;C39377
	bra @lbl_C3934E                         ;C39378
@lbl_C3937A:
	inx                                     ;C3937A
	bra @lbl_C39346                         ;C3937B
@lbl_C3937D:
	pla                                     ;C3937D
	pla                                     ;C3937E
	pla                                     ;C3937F
	plp                                     ;C39380
	rtl                                     ;C39381

func_C39382:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C3939D
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$08
	bcc @lbl_C393E2
	cmp.b #$0F
	bcs @lbl_C393E2
@lbl_C3939D:
	lda.l $7EC179
	cmp.b #$03
	bne @lbl_C393AF
	jsl.l Random
	lda.b wTemp00
	bit.b #$03
	bne @lbl_C393E2
@lbl_C393AF:
	lda $7EBE8E                             ;C393AF
	tax                                     ;C393B3
@lbl_C393B4:
	dex                                     ;C393B4
	.db $30,$2B   ;C393B5
	lda $7EC134,x                           ;C393B7
	cmp #$01                                ;C393BB
	bne @lbl_C393B4                         ;C393BD
	jsr $93E4                               ;C393BF
	lda $00                                 ;C393C2
	.db $D0,$1C   ;C393C4
	txa                                     ;C393C6
	sta $7EC174                             ;C393C7
	lda $7EC166,x                           ;C393CB
	ora #$20                                ;C393CF
	sta $7EC166,x                           ;C393D1
	jsl $C3F65F                             ;C393D5
	lda $00                                 ;C393D9
	and #$03                                ;C393DB
	asl a                                   ;C393DD
	tax                                     ;C393DE
	jmp ($9425,x)                           ;C393DF
@lbl_C393E2:
	plp
	rts
	phx                                     ;C393E4
	stx $00                                 ;C393E5
	stz $01                                 ;C393E7
	jsl $C36549                             ;C393E9
	lda $01                                 ;C393ED
	pha                                     ;C393EF
	lda $00                                 ;C393F0
	pha                                     ;C393F2
	ldy #$00                                ;C393F3
	ldx #$03                                ;C393F5
@lbl_C393F7:
	lda $01,s                               ;C393F7
	clc                                     ;C393F9
	adc $C392ED,x                           ;C393FA
	sta $00                                 ;C393FE
	lda $02,s                               ;C39400
	clc                                     ;C39402
	adc $C392F5,x                           ;C39403
	sta $01                                 ;C39407
	phx                                     ;C39409
	jsl $C36CA5                             ;C3940A
	plx                                     ;C3940E
	lda $00                                 ;C3940F
	bit #$80                                ;C39411
	beq @lbl_C3941C                         ;C39413
	bit #$40                                ;C39415
	bne @lbl_C3941C                         ;C39417
	iny                                     ;C39419
	bra @lbl_C3941F                         ;C3941A
@lbl_C3941C:
	dex                                     ;C3941C
	bpl @lbl_C393F7                         ;C3941D
@lbl_C3941F:
	sty $00                                 ;C3941F
	pla                                     ;C39421
	pla                                     ;C39422
	plx                                     ;C39423
	rts                                     ;C39424
	and $2D94                               ;C39425
	sty $2D,x                               ;C39428
	sty $3B,x                               ;C3942A
	sty $20,x                               ;C3942C
	eor #$94                                ;C3942E
	jsr $94A6                               ;C39430
	jsr $95DB                               ;C39433
	jsr $96CF                               ;C39436
	plp                                     ;C39439
	rts                                     ;C3943A
	jsr $9449                               ;C3943B
	jsr $94A6                               ;C3943E
	jsr $9635                               ;C39441
	jsr $96CF                               ;C39444
	plp                                     ;C39447
	rts                                     ;C39448
	php                                     ;C39449
	sep #$20                                ;C3944A
	rep #$10                                ;C3944C
	lda $7EC174                             ;C3944E
	sta $00                                 ;C39452
	stz $01                                 ;C39454
	jsl $C36549                             ;C39456
	lda $00                                 ;C3945A
	pha                                     ;C3945C
	lda $01                                 ;C3945D
	pha                                     ;C3945F
	ldx #$0003                              ;C39460
@lbl_C39463:
	lda $02,s                               ;C39463
	clc                                     ;C39465
	adc $C392ED,x                           ;C39466
	sta $00                                 ;C3946A
	lda $01,s                               ;C3946C
	clc                                     ;C3946E
	adc $C392F5,x                           ;C3946F
	sta $01                                 ;C39473
	ldy $00                                 ;C39475
	phx                                     ;C39477
	jsl $C359AF                             ;C39478
	plx                                     ;C3947C
	lda $02                                 ;C3947D
	bit #$90                                ;C3947F
	beq @lbl_C39486                         ;C39481
	dex                                     ;C39483
	bpl @lbl_C39463                         ;C39484
@lbl_C39486:
	pla                                     ;C39486
	pla                                     ;C39487
	sty $00                                 ;C39488
	lda #$06                                ;C3948A
	sta $02                                 ;C3948C
	lda #$4D                                ;C3948E
	sta $03                                 ;C39490
	phy                                     ;C39492
	jsl $C2007D                             ;C39493
	ply                                     ;C39497
	lda $00                                 ;C39498
	bmi @lbl_C394A4                         ;C3949A
	sty $00                                 ;C3949C
	sta $02                                 ;C3949E
	jsl $C35B7A                             ;C394A0
@lbl_C394A4:
	plp                                     ;C394A4
	rts                                     ;C394A5
	php                                     ;C394A6
	sep #$20                                ;C394A7
	rep #$10                                ;C394A9
	lda $7EC174                             ;C394AB
	sta $00                                 ;C394AF
	stz $01                                 ;C394B1
	jsl $C36549                             ;C394B3
	lda $00                                 ;C394B7
	pha                                     ;C394B9
	lda $01                                 ;C394BA
	pha                                     ;C394BC
	ldx #$0008                              ;C394BD
@lbl_C394C0:
	lda $02,s                               ;C394C0
	clc                                     ;C394C2
	adc $C394F3,x                           ;C394C3
	sta $00                                 ;C394C7
	lda $01,s                               ;C394C9
	clc                                     ;C394CB
	adc $C394FC,x                           ;C394CC
	sta $01                                 ;C394D0
	ldy $00                                 ;C394D2
	phx                                     ;C394D4
	jsl $C359AF                             ;C394D5
	plx                                     ;C394D9
	lda $02                                 ;C394DA
	bit #$90                                ;C394DC
	bne @lbl_C394EC                         ;C394DE
	sty $00                                 ;C394E0
	lda #$85                                ;C394E2
	sta $02                                 ;C394E4
	phx                                     ;C394E6
	jsl $C35BA2                             ;C394E7
	plx                                     ;C394EB
@lbl_C394EC:
	dex                                     ;C394EC
	bpl @lbl_C394C0                         ;C394ED
	pla                                     ;C394EF
	pla                                     ;C394F0
	plp                                     ;C394F1
	rts                                     ;C394F2
	.db $FF,$00,$01,$FF,$00,$01,$FF,$00,$01,$FF,$FF,$FF,$00,$00,$00   ;C394F3
	ora ($01,x)                             ;C39502
	ora ($08,x)                             ;C39504
	sep #$30                                ;C39506
	lda #$00                                ;C39508
	ldx #$1A                                ;C3950A
@lbl_C3950C:
	sta $7EC17A,x                           ;C3950C
	dex                                     ;C39510
	bpl @lbl_C3950C                         ;C39511
	lda $7EC174                             ;C39513
	tax                                     ;C39517
	lda $7EBE7A,x                           ;C39518
	sec                                     ;C3951C
	sbc $7EBE66,x                           ;C3951D
	lsr a                                   ;C39521
	bcc @lbl_C3952F                         ;C39522
	pha                                     ;C39524
	jsl $C3F65F                             ;C39525
	pla                                     ;C39529
	ldy $00                                 ;C3952A
	bpl @lbl_C3952F                         ;C3952C
	clc                                     ;C3952E
@lbl_C3952F:
	adc $7EBE66,x                           ;C3952F
	pha                                     ;C39533
	lda $7EBE84,x                           ;C39534
	sec                                     ;C39538
	sbc $7EBE70,x                           ;C39539
	lsr a                                   ;C3953D
	bcc @lbl_C3954B                         ;C3953E
	pha                                     ;C39540
	jsl $C3F65F                             ;C39541
	pla                                     ;C39545
	ldy $00                                 ;C39546
	bpl @lbl_C3954B                         ;C39548
	clc                                     ;C3954A
@lbl_C3954B:
	adc $7EBE70,x                           ;C3954B
	pha                                     ;C3954F
	rep #$10                                ;C39550
	ldx #$0008                              ;C39552
@lbl_C39555:
	lda $02,s                               ;C39555
	clc                                     ;C39557
	adc $C394F3,x                           ;C39558
	sta $00                                 ;C3955C
	lda $01,s                               ;C3955E
	clc                                     ;C39560
	adc $C394FC,x                           ;C39561
	sta $01                                 ;C39565
	ldy $00                                 ;C39567
	phx                                     ;C39569
	jsl $C359AF                             ;C3956A
	plx                                     ;C3956E
	lda $00                                 ;C3956F
	cmp #$80                                ;C39571
	bne @lbl_C39591                         ;C39573
	lda $01                                 ;C39575
	cmp #$80                                ;C39577
	bne @lbl_C39591                         ;C39579
	lda $02                                 ;C3957B
	bit #$90                                ;C3957D
	bne @lbl_C39591                         ;C3957F
	sty $00                                 ;C39581
	lda $00                                 ;C39583
	sta $7EC183,x                           ;C39585
	lda $01                                 ;C39589
	sta $7EC18C,x                           ;C3958B
	bra @lbl_C39597                         ;C3958F
@lbl_C39591:
	lda #$01                                ;C39591
	sta $7EC17A,x                           ;C39593
@lbl_C39597:
	dex                                     ;C39597
	bpl @lbl_C39555                         ;C39598
	pla                                     ;C3959A
	pla                                     ;C3959B
	plp                                     ;C3959C
	rts                                     ;C3959D
	phy                                     ;C3959E
	php                                     ;C3959F
	sep #$30                                ;C395A0
	ldx #$08                                ;C395A2
@lbl_C395A4:
	lda $7EC17A,x                           ;C395A4
	beq @lbl_C395B3                         ;C395A8
	dex                                     ;C395AA
	bpl @lbl_C395A4                         ;C395AB
	stz $00                                 ;C395AD
	stz $01                                 ;C395AF
	bra @lbl_C395D8                         ;C395B1
@lbl_C395B3:
	jsl $C3F65F                             ;C395B3
	lda $00                                 ;C395B7
	and #$0F                                ;C395B9
	cmp #$09                                ;C395BB
	bcs @lbl_C395B3                         ;C395BD
	tax                                     ;C395BF
	lda $7EC17A,x                           ;C395C0
	bne @lbl_C395B3                         ;C395C4
	lda #$01                                ;C395C6
	sta $7EC17A,x                           ;C395C8
	lda $7EC183,x                           ;C395CC
	sta $00                                 ;C395D0
	lda $7EC18C,x                           ;C395D2
	sta $01                                 ;C395D6
@lbl_C395D8:
	plp                                     ;C395D8
	ply                                     ;C395D9
	rts                                     ;C395DA
	php                                     ;C395DB
	sep #$20                                ;C395DC
	rep #$10                                ;C395DE
	jsr $9505                               ;C395E0
	lda #$05                                ;C395E3
	sta $00                                 ;C395E5
	lda #$09                                ;C395E7
	sta $01                                 ;C395E9
	jsl $C3F69F                             ;C395EB
	stz $01                                 ;C395EF
	ldy $00                                 ;C395F1
@lbl_C395F3:
	jsr $959E                               ;C395F3
	ldx $00                                 ;C395F6
	beq @lbl_C39633                         ;C395F8
	jsl $C62771                             ;C395FA
	lda $00                                 ;C395FE
	stz $00                                 ;C39600
	cmp #$10                                ;C39602
	bcc @lbl_C3960E                         ;C39604
	inc $00                                 ;C39606
	cmp #$33                                ;C39608
	bcc @lbl_C3960E                         ;C3960A
	inc $00                                 ;C3960C
@lbl_C3960E:
	phx                                     ;C3960E
	phy                                     ;C3960F
	jsl $C303E9                             ;C39610
	ply                                     ;C39614
	plx                                     ;C39615
	lda $00                                 ;C39616
	bmi @lbl_C39630                         ;C39618
	pha                                     ;C3961A
	lda #$01                                ;C3961B
	sta $01                                 ;C3961D
	phx                                     ;C3961F
	phy                                     ;C39620
	jsl $C33A92                             ;C39621
	ply                                     ;C39625
	plx                                     ;C39626
	pla                                     ;C39627
	stx $00                                 ;C39628
	sta $02                                 ;C3962A
	jsl $C35BA2                             ;C3962C
@lbl_C39630:
	dey                                     ;C39630
	bne @lbl_C395F3                         ;C39631
@lbl_C39633:
	plp                                     ;C39633
	rts                                     ;C39634
	php                                     ;C39635
	sep #$30                                ;C39636
	jsr $9505                               ;C39638
	jsl $C62771                             ;C3963B
	ldx #$00                                ;C3963F
	lda $00                                 ;C39641
	cmp #$10                                ;C39643
	bcc @lbl_C3964D                         ;C39645
	inx                                     ;C39647
	cmp #$33                                ;C39648
	bcc @lbl_C3964D                         ;C3964A
	inx                                     ;C3964C
@lbl_C3964D:
	phx                                     ;C3964D
	stx $00                                 ;C3964E
	jsl $C303E9                             ;C39650
	ldx $00                                 ;C39654
	bpl @lbl_C3965B                         ;C39656
	plx                                     ;C39658
	plp                                     ;C39659
	rts                                     ;C3965A
@lbl_C3965B:
	phx                                     ;C3965B
	jsl $C30710                             ;C3965C
	plx                                     ;C39660
	lda $00                                 ;C39661
	pha                                     ;C39663
	stx $00                                 ;C39664
	jsl $C306F4                             ;C39666
	rep #$10                                ;C3966A
	lda #$05                                ;C3966C
	sta $00                                 ;C3966E
	lda #$09                                ;C39670
	sta $01                                 ;C39672
	jsl $C3F69F                             ;C39674
	stz $01                                 ;C39678
	ldy $00                                 ;C3967A
@lbl_C3967C:
	jsr $959E                               ;C3967C
	ldx $00                                 ;C3967F
	beq @lbl_C396CB                         ;C39681
@lbl_C39683:
	lda $02,s                               ;C39683
	sta $00                                 ;C39685
	phx                                     ;C39687
	phy                                     ;C39688
	jsl $C303E9                             ;C39689
	ply                                     ;C3968D
	plx                                     ;C3968E
	lda $00                                 ;C3968F
	bmi @lbl_C396C8                         ;C39691
	pha                                     ;C39693
	phx                                     ;C39694
	phy                                     ;C39695
	jsl $C30710                             ;C39696
	ply                                     ;C3969A
	plx                                     ;C3969B
	lda $00                                 ;C3969C
	cmp $02,s                               ;C3969E
	beq @lbl_C396AF                         ;C396A0
	pla                                     ;C396A2
	sta $00                                 ;C396A3
	phx                                     ;C396A5
	phy                                     ;C396A6
	jsl $C306F4                             ;C396A7
	ply                                     ;C396AB
	plx                                     ;C396AC
	bra @lbl_C39683                         ;C396AD
@lbl_C396AF:
	lda $01,s                               ;C396AF
	sta $00                                 ;C396B1
	lda #$01                                ;C396B3
	sta $01                                 ;C396B5
	phx                                     ;C396B7
	phy                                     ;C396B8
	jsl $C33A92                             ;C396B9
	ply                                     ;C396BD
	plx                                     ;C396BE
	pla                                     ;C396BF
	stx $00                                 ;C396C0
	sta $02                                 ;C396C2
	jsl $C35BA2                             ;C396C4
@lbl_C396C8:
	dey                                     ;C396C8
	bne @lbl_C3967C                         ;C396C9
@lbl_C396CB:
	pla                                     ;C396CB
	pla                                     ;C396CC
	plp                                     ;C396CD
	rts                                     ;C396CE
	php                                     ;C396CF
	sep #$20                                ;C396D0
	rep #$10                                ;C396D2
	jsr $959E                               ;C396D4
	ldx $00                                 ;C396D7
	beq @lbl_C396EF                         ;C396D9
	lda #$06                                ;C396DB
	sta $02                                 ;C396DD
	lda #$0F                                ;C396DF
	sta $03                                 ;C396E1
	jsl $C2007D                             ;C396E3
	lda $00                                 ;C396E7
	bmi @lbl_C396EF                         ;C396E9
	jsl $C20C16                             ;C396EB
@lbl_C396EF:
	plp                                     ;C396EF
	rts                                     ;C396F0
.INDEX 8

func_C396F1:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$0A
	sta.b wTemp00
	lda.b #$0F
	sta.b wTemp01
	jsl.l GetRandomInRange
	stz.b wTemp01
	ldy.b wTemp00
@lbl_C39706:
	lda.l $7EC175
	sta.b wTemp00
	phy
	jsl.l func_C37234
	ply
	ldx.b wTemp00
	bmi @lbl_C39734
	phx
	phy
	jsl.l func_C20BE7
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C39734
	stx.b wTemp00
	sta.b wTemp02
	pha
	jsl.l func_C35B7A
	pla
	sta.b wTemp00
	phy
	jsl.l func_C27E78
	ply
@lbl_C39734:
	dey
	bne @lbl_C39706
	plp
	rts
	phx                                     ;C39739
	phy                                     ;C3973A
	php                                     ;C3973B
	rep #$30                                ;C3973C
	lda $00                                 ;C3973E
	asl a                                   ;C39740
	tax                                     ;C39741
	lda $C39764,x                           ;C39742
	sta $A9                                 ;C39746
@lbl_C39748:
	jsl $C3F65F                             ;C39748
	lda $00                                 ;C3974C
	and #$0007                              ;C3974E
	cmp $C39792,x                           ;C39751
	bcs @lbl_C39748                         ;C39755
	tay                                     ;C39757
	sep #$20                                ;C39758
	phk                                     ;C3975A
	plb                                     ;C3975B
	lda ($A9),y                             ;C3975C
	sta $00                                 ;C3975E
	plp                                     ;C39760
	ply                                     ;C39761
	plx                                     ;C39762
	rts                                     ;C39763
	
;special monster house data

;c39764
	.dw $976E
	.dw $9776
	.dw $977C
	.dw $9784
	.dw $978C

;c3976e
	.db $05,$05,$05,$05,$0A,$0A,$0A,$0A
	
	.db $12,$12,$0D,$0D,$27,$27
	
	.db $12,$12,$1D,$1D,$26,$26,$10,$10
	
	.db $02,$02,$0E,$0E,$21,$21,$13,$13

;c3978c
	.db $1C,$10,$15,$06,$08,$0C

;entry sizes

;c39792
	.db $08
	.db $06
	.db $08
	.db $08
	.db $06

;c39797
	php                                     ;C39797
	sep #$20                                ;C39798
	rep #$10                                ;C3979A
@lbl_C3979C:
	jsl $C3F65F                             ;C3979C
	lda $00                                 ;C397A0
	and #$07                                ;C397A2
	cmp #$05                                ;C397A4
	bcs @lbl_C3979C                         ;C397A6
	inc a                                   ;C397A8
	sta $7EC176                             ;C397A9
	ldx #$0F0A                              ;C397AD
	stx $00                                 ;C397B0
	jsl $C3F69F                             ;C397B2
	stz $01                                 ;C397B6
	ldy $00                                 ;C397B8
@lbl_C397BA:
	lda $7EC175                             ;C397BA
	sta $00                                 ;C397BE
	phy                                     ;C397C0
	jsl $C37234                             ;C397C1
	ply                                     ;C397C5
	ldx $00                                 ;C397C6
	bmi @lbl_C39828                         ;C397C8
	jsl $C3F65F                             ;C397CA
	lda $00                                 ;C397CE
	and #$07                                ;C397D0
	pha                                     ;C397D2
	lda $7EC176                             ;C397D3
	dec a                                   ;C397D7
	sta $00                                 ;C397D8
	stz $01                                 ;C397DA
	jsr $9739                               ;C397DC
	lda $00                                 ;C397DF
	pha                                     ;C397E1
	cmp #$0E                                ;C397E2
	beq @lbl_C397FE                         ;C397E4
	cmp #$0D                                ;C397E6
	beq @lbl_C397FE                         ;C397E8
	lda #$01                                ;C397EA
	sta $00                                 ;C397EC
	lda #$03                                ;C397EE
	sta $01                                 ;C397F0
	phx                                     ;C397F2
	phy                                     ;C397F3
	jsl $C3F69F                             ;C397F4
	ply                                     ;C397F8
	plx                                     ;C397F9
	lda $00                                 ;C397FA
	bra @lbl_C39800                         ;C397FC
@lbl_C397FE:
	lda #$01                                ;C397FE
@lbl_C39800:
	sta $04                                 ;C39800
	pla                                     ;C39802
	sta $03                                 ;C39803
	pla                                     ;C39805
	sta $02                                 ;C39806
	stx $00                                 ;C39808
	phx                                     ;C3980A
	phy                                     ;C3980B
	jsl $C20086                             ;C3980C
	ply                                     ;C39810
	plx                                     ;C39811
	lda $00                                 ;C39812
	bmi @lbl_C39828                         ;C39814
	sta $02                                 ;C39816
	stx $00                                 ;C39818
	pha                                     ;C3981A
	jsl $C35B7A                             ;C3981B
	pla                                     ;C3981F
	sta $00                                 ;C39820
	phy                                     ;C39822
	jsl $C27E78                             ;C39823
	ply                                     ;C39827
@lbl_C39828:
	dey                                     ;C39828
	bne @lbl_C397BA                         ;C39829
	plp                                     ;C3982B
	rts                                     ;C3982C
	php                                     ;C3982D
	sep #$20                                ;C3982E
	rep #$10                                ;C39830
	ldx #$0F0A                              ;C39832
	stx $00                                 ;C39835
	jsl $C3F69F                             ;C39837
	stz $01                                 ;C3983B
	ldy $00                                 ;C3983D
@lbl_C3983F:
	lda $7EC175                             ;C3983F
	sta $00                                 ;C39843
	phy                                     ;C39845
	jsl $C37234                             ;C39846
	ply                                     ;C3984A
	ldx $00                                 ;C3984B
	bmi @lbl_C39886                         ;C3984D
	jsl $C3F65F                             ;C3984F
	lda $00                                 ;C39853
	and #$07                                ;C39855
	sta $02                                 ;C39857
	jsl $C3F65F                             ;C39859
	lda $00                                 ;C3985D
	and #$01                                ;C3985F
	clc                                     ;C39861
	adc #$4A                                ;C39862
	sta $03                                 ;C39864
	stx $00                                 ;C39866
	phx                                     ;C39868
	phy                                     ;C39869
	jsl $C2007D                             ;C3986A
	ply                                     ;C3986E
	plx                                     ;C3986F
	lda $00                                 ;C39870
	bmi @lbl_C39886                         ;C39872
	stx $00                                 ;C39874
	sta $02                                 ;C39876
	pha                                     ;C39878
	jsl $C35B7A                             ;C39879
	pla                                     ;C3987D
	sta $00                                 ;C3987E
	phy                                     ;C39880
	jsl $C27E78                             ;C39881
	ply                                     ;C39885
@lbl_C39886:
	dey                                     ;C39886
	bne @lbl_C3983F                         ;C39887
	plp                                     ;C39889
	rts                                     ;C3988A

func_C3988B:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l func_C627C8
	lda.b wTemp00
	bpl @lbl_C398C2
	ldy.w #$0006
@lbl_C3989B:
	lda.l $7EC175
	sta.b wTemp00
	phy
	jsl.l func_C371C1
	ply
	ldx.b wTemp00
	bmi @lbl_C398BF
	phx
	phy
	jsl.l SpawnRandomFloorItemOrGitan
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C398BF
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C35BA2
@lbl_C398BF:
	dey
	bpl @lbl_C3989B
@lbl_C398C2:
	plp
	rts

func_C398C4:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	jsl.l GetCurrentFloor
	lda.b wTemp00
	pha
	lda.b #$00
	pha
	lda.l $7E8975
	bit.b #$01
	beq @lbl_C398DF
;C398DB
	lda #$20                                ;C398DB
	sta $01,s                               ;C398DD
@lbl_C398DF:
	ldx.w #$0503
	stx.b wTemp00
	jsl.l GetRandomInRange
	stz.b wTemp01
	ldy.b wTemp00
@lbl_C398EC:
	lda.l $7EC175
	sta.b wTemp00
	phy
	jsl.l func_C371C1
	ply
	ldx.b wTemp00
	bmi @lbl_C39916
	lda.b wTemp02,s
	sta.b wTemp00
	phx
	phy
	jsl.l func_C3D3AB
	ply
	plx
	lda.b wTemp00
	ora.b #$C0
	ora.b wTemp01,s
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C35BA2
@lbl_C39916:
	dey
	bne @lbl_C398EC
	pla
	pla
	plp
	rts

func_C3991D:
	php
	sep #$30 ;AXY->8
	jsl.l func_C62B58
	lda.b wTemp00
	beq @lbl_C39955
	jsl $C24368                             ;C39928
	lda $00                                 ;C3992C
	beq @lbl_C3993A                         ;C3992E
	ldx #$03                                ;C39930
	lda #$06                                ;C39932
	sta $7EC176                             ;C39934
	bra @lbl_C39951                         ;C39938
@lbl_C3993A:
	ldx #$01                                ;C3993A
	jsl $C627E6                             ;C3993C
	lda $00                                 ;C39940
	cmp #$01                                ;C39942
	beq @lbl_C39951                         ;C39944
	jsl $C3F65F                             ;C39946
	lda $00                                 ;C3994A
	bit #$01                                ;C3994C
	beq @lbl_C39951                         ;C3994E
	inx                                     ;C39950
@lbl_C39951:
	stx $00                                 ;C39951
	plp                                     ;C39953
	rts                                     ;C39954
@lbl_C39955:
	ldx.b #$00
	lda.l $7EC179
	cmp.b #$04
	beq @lbl_C39983
	cmp.b #$05
	beq @lbl_C39983
	cmp.b #$07
	beq @lbl_C39983
	jsl.l func_C627C8
	lda.b wTemp00
	bpl @lbl_C39999
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$04
	bcc @lbl_C39999
	jsl.l Random
	lda.b wTemp00
	bit.b #$0F
	bne @lbl_C39999
@lbl_C39983:
	inx
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	beq @lbl_C39999
	jsl $C3F65F                             ;C3998E
	lda $00                                 ;C39992
	cmp #$AA                                ;C39994
	.db $90,$01   ;C39996
	inx                                     ;C39998
@lbl_C39999:
	stx.b wTemp00
	plp
	rts

func_C3999D:
	php
	sep #$30 ;AXY->8
	lda.l $7EC175
	bmi @lbl_C399B3
@lbl_C399A6:
	tax
	lda.l $7EC166,x
	ora.b #$08
	sta.l $7EC166,x
@lbl_C399B1:
	plp
	rts
@lbl_C399B3:
	lda.l $7EC179
	cmp.b #$04
	beq @lbl_C399D6
	cmp.b #$05
	beq @lbl_C399E0
	cmp.b #$07
	beq @lbl_C399EA
	lda.l $7EBE8E
	tax
@lbl_C399C8:
	dex
	bmi @lbl_C399B1
	lda.l $7EC166,x
	cmp.b #$00
	bne @lbl_C399C8
	txa
	bra @lbl_C399EC
@lbl_C399D6:
	jsl $C3F65F                             ;C399D6
	lda $00                                 ;C399DA
	and #$03                                ;C399DC
	.db $80,$0C   ;C399DE
@lbl_C399E0:
	jsl $C3F65F                             ;C399E0
	lda $00                                 ;C399E4
	and #$01                                ;C399E6
	.db $80,$02   ;C399E8
@lbl_C399EA:
	.db $A9,$00
@lbl_C399EC:
	sta.l $7EC175
	bra @lbl_C399A6

func_C399F2:
	php
	sep #$30 ;AXY->8
	jsr.w func_C3991D
	ldy.b wTemp00
	beq @lbl_C39A0F
	jsr.w func_C3999D
	lda.l $7EC175
	bmi @lbl_C39A0F
	tya
	dec a
	asl a
	tax
	;return from the jumptable function afterwards
	;might be a macro
	pea.w @lbl_C39A0F - 1
	jmp.w (Jumptable_C39A17,x)
@lbl_C39A0F:
	lda.b #$00
	sta.l $7EC177
	plp
	rts

Jumptable_C39A17:
	.dw func_C39A1D
	.dw func_C39A27
	.dw func_C39A31

func_C39A1D:
	jsr.w func_C396F1
	jsr.w func_C3988B
	jsr.w func_C398C4
	rts

func_C39A27:
	jsr $9797                               ;C39A27
	jsr $988B                               ;C39A2A
	jsr $98C4                               ;C39A2D
	rts                                     ;C39A30
	
func_C39A31:
	jsr $982D                               ;C39A31
	jsr $988B                               ;C39A34
	jsr $98C4                               ;C39A37
	rts                                     ;C39A3A
	php                                     ;C39A3B
	sep #$20                                ;C39A3C
@lbl_C39A3E:
	jsl $C36203                             ;C39A3E
	lda $00                                 ;C39A42
	cmp #$20                                ;C39A44
	bcs @lbl_C39A3E                         ;C39A46
	lda #$86                                ;C39A48
	sta $02                                 ;C39A4A
	jsl $C35BA2                             ;C39A4C
@lbl_C39A50:
	jsl $C36203                             ;C39A50
	lda $00                                 ;C39A54
	cmp #$20                                ;C39A56
	bcc @lbl_C39A50                         ;C39A58
	lda #$86                                ;C39A5A
	sta $02                                 ;C39A5C
	jsl $C35BA2                             ;C39A5E
	plp                                     ;C39A62
	rts                                     ;C39A63
	php                                     ;C39A64
	sep #$30                                ;C39A65
	lda $7EBE8E                             ;C39A67
	dec a                                   ;C39A6B
	tax                                     ;C39A6C
@lbl_C39A6D:
	lda $7EBE70,x                           ;C39A6D
	inc a                                   ;C39A71
	sta $00                                 ;C39A72
	lda $7EBE84,x                           ;C39A74
	dec a                                   ;C39A78
	sta $01                                 ;C39A79
	phx                                     ;C39A7B
	jsl $C3F69F                             ;C39A7C
	plx                                     ;C39A80
	ldy $00                                 ;C39A81
	lda $7EBE66,x                           ;C39A83
	inc a                                   ;C39A87
	sta $00                                 ;C39A88
	lda $7EBE7A,x                           ;C39A8A
	dec a                                   ;C39A8E
	sta $01                                 ;C39A8F
	phx                                     ;C39A91
	phy                                     ;C39A92
	jsl $C3F69F                             ;C39A93
	ply                                     ;C39A97
	plx                                     ;C39A98
	sty $01                                 ;C39A99
	lda #$86                                ;C39A9B
	sta $02                                 ;C39A9D
	phx                                     ;C39A9F
	jsl $C35BA2                             ;C39AA0
	plx                                     ;C39AA4
	dex                                     ;C39AA5
	bpl @lbl_C39A6D                         ;C39AA6
	plp                                     ;C39AA8
	rts                                     ;C39AA9

func_C39AAA:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C39AC5
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$0D
	bcc @lbl_C39AD7
	cmp.b #$17
	bcs @lbl_C39AD7
@lbl_C39AC5:
	jsl.l Random
	lda.b wTemp00
	bit.b #$0F
	bne @lbl_C39AD7
	lda.l $7EBE8E
	tax
@lbl_C39AD4:
	dex
	bpl @lbl_C39AD9
@lbl_C39AD7:
	plp
	rts
@lbl_C39AD9:
	lda.l $7EC166,x
	cmp.b #$00
	bne @lbl_C39AD4
	lda.l $7EBE7A,x
	sec
	sbc.l $7EBE66,x
	dec a
	cmp.b #$06
	bcc @lbl_C39AD4
	sta.b wTemp02
	lda.l $7EBE84,x
	sec
	sbc.l $7EBE70,x
	dec a
	cmp.b #$06
	bcc @lbl_C39AD4
	sta.b wTemp04
	lda.l $7EC166,x
	ora.b #$10
	sta.l $7EC166,x
	lda.b wTemp02
	sec
	sbc.b #$04
	sta.b wTemp01
	cmp.b #$05
	bcc @lbl_C39B1A
;C39B16
	.db $A9,$05,$85,$01
@lbl_C39B1A:
	lda.b #$02
	sta.b wTemp00
	lda.b wTemp02
	pha
	lda.b wTemp04
	pha
	phx
	jsl.l GetRandomInRange
	plx
	pla
	sta.b wTemp04
	pla
	sta.b wTemp02
	lda.b wTemp00
	sta.b wTemp06
	lda.b wTemp02
	sec
	sbc.b wTemp06
	lsr a
	tay
	sty.b wTemp00
	sty.b wTemp01
	bcc @lbl_C39B55
	jsl $C3F65F                             ;C39B41
	lda $00                                 ;C39B45
	bmi @lbl_C39B50                         ;C39B47
	sty $00                                 ;C39B49
	iny                                     ;C39B4B
	sty $01                                 ;C39B4C
	.db $80,$05   ;C39B4E
@lbl_C39B50:
	sty $01                                 ;C39B50
	iny                                     ;C39B52
	sty $00                                 ;C39B53
@lbl_C39B55:
	lda.l $7EBE66,x
	clc
	adc.b wTemp00
	pha
	lda.l $7EBE7A,x
	sec
	sbc.b wTemp01
	pha
	lda.b wTemp04
	sec
	sbc.b #$04
	sta.b wTemp01
	cmp.b #$05
	bcc @lbl_C39B74
;C39B70
	.db $A9,$05,$85,$01
@lbl_C39B74:
	lda.b #$02
	sta.b wTemp00
	lda.b wTemp04
	pha
	phx
	jsl.l GetRandomInRange
	plx
	pla
	sta.b wTemp04
	lda.b wTemp00
	sta.b wTemp06
	lda.b wTemp04
	sec
	sbc.b wTemp06
	lsr a
	tay
	sty.b wTemp00
	sty.b wTemp01
	bcc @lbl_C39BA9
	jsl $C3F65F                             ;C39B95
	lda $00                                 ;C39B99
	bmi @lbl_C39BA4                         ;C39B9B
	sty $00                                 ;C39B9D
	iny                                     ;C39B9F
	sty $01                                 ;C39BA0
	.db $80,$05   ;C39BA2
@lbl_C39BA4:
	sty $01                                 ;C39BA4
	iny                                     ;C39BA6
	sty $00                                 ;C39BA7
@lbl_C39BA9:
	lda.l $7EBE70,x
	clc
	adc.b wTemp00
	pha
	lda.l $7EBE84,x
	sec
	sbc.b wTemp01
	pha
	lda.b wTemp04,s
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	lda.b wTemp03,s
	sta.b wTemp02
	lda.b #$B0
	sta.b wTemp03
	jsl.l func_C35FE7
	lda.b wTemp04,s
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	lda.b wTemp03,s
	sta.b wTemp02
	lda.b #$B0
	sta.b wTemp03
	jsl.l func_C35FE7
	lda.b wTemp04,s
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp02
	lda.b #$B0
	sta.b wTemp03
	jsl.l func_C3601D
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp02
	lda.b #$B0
	sta.b wTemp03
	jsl.l func_C3601D
	lda.b wTemp04,s
	inc a
	sta.b wTemp00
	lda.b wTemp03,s
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	ldx.b wTemp00
	lda.b wTemp02,s
	inc a
	sta.b wTemp00
	lda.b wTemp01,s
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	lda.b #$86
	sta.b wTemp02
	jsl.l func_C35BA2
	lda.b wTemp02,s
	inc a
	tay
@lbl_C39C3B:
	lda.b wTemp04,s
	inc a
	tax
	tya
	cmp.b wTemp01,s
	bcs @lbl_C39C91
@lbl_C39C44:
	txa
	cmp.b wTemp03,s
	bcs @lbl_C39C8E
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp01
	cmp.b #$80
	bne @lbl_C39C8B
	jsl.l Random
	lda.b wTemp00
	bmi @lbl_C39C8B
	jsl.l Random
	lda.b wTemp00
	bmi @lbl_C39C73
	phx
	phy
	jsl.l SpawnFloorGitan
	ply
	plx
	bra @lbl_C39C7B
@lbl_C39C73:
	phx
	phy
	jsl.l SpawnRandomDungeonFloorItem
	ply
	plx
@lbl_C39C7B:
	lda.b wTemp00
	bmi @lbl_C39C8B
	sta.b wTemp02
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C35BA2
	plx
@lbl_C39C8B:
	inx
	bra @lbl_C39C44
@lbl_C39C8E:
	iny
	bra @lbl_C39C3B
@lbl_C39C91:
	pla
	pla
	pla
	pla
	plp
	rts

func_C39C97:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C39CBA
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$08
	bcc @lbl_C39CCC
	cmp.b #$1E
	bcs @lbl_C39CCC
	cmp.b #$0F
	bcc @lbl_C39CBA
	cmp.b #$16
	bcc @lbl_C39CCC
@lbl_C39CBA:
	jsl.l Random
	lda.b wTemp00
	bit.b #$03
	bne @lbl_C39CCC
;C39CC4  
	.db $AF,$8E,$BE,$7E,$AA,$CA,$10,$02
@lbl_C39CCC:
	plp
	rts
	lda $7EC166,x                           ;C39CCE
	cmp #$00                                ;C39CD0
	.db $D0,$F3   ;C39CD4
	lda $7EBE7A,x                           ;C39CD6
	sec                                     ;C39CDA
	sbc $7EBE66,x                           ;C39CDB
	dec a                                   ;C39CDF
	lsr a                                   ;C39CE0
	.db $90,$E6   ;C39CE1
	lda $7EBE84,x                           ;C39CE3
	sec                                     ;C39CE7
	sbc $7EBE70,x                           ;C39CE8
	dec a                                   ;C39CEC
	lsr a                                   ;C39CED
	.db $90,$D9   ;C39CEE
	lda $7EC166,x                           ;C39CF0
	ora #$80                                ;C39CF4
	sta $7EC166,x                           ;C39CF6
	lda $7EBE66,x                           ;C39CFA
	inc a                                   ;C39CFE
	inc a                                   ;C39CFF
	sta $00                                 ;C39D00
	lda $7EBE70,x                           ;C39D02
	inc a                                   ;C39D06
	inc a                                   ;C39D07
	sta $01                                 ;C39D08
	lda $7EBE7A,x                           ;C39D0A
	dec a                                   ;C39D0E
	dec a                                   ;C39D0F
	sta $02                                 ;C39D10
	lda $7EBE84,x                           ;C39D12
	dec a                                   ;C39D16
	dec a                                   ;C39D17
	sta $03                                 ;C39D18
	jsr $9D3E                               ;C39D1A
	lda $7EBE66,x                           ;C39D1D
	inc a                                   ;C39D21
	sta $00                                 ;C39D22
	lda $7EBE70,x                           ;C39D24
	inc a                                   ;C39D28
	sta $01                                 ;C39D29
	lda $7EBE7A,x                           ;C39D2B
	dec a                                   ;C39D2F
	sta $02                                 ;C39D30
	lda $7EBE84,x                           ;C39D32
	dec a                                   ;C39D36
	sta $03                                 ;C39D37
	jsr $9D3E                               ;C39D39
	plp                                     ;C39D3C
	rts                                     ;C39D3D
	phx                                     ;C39D3E
	lda $00                                 ;C39D3F
	pha                                     ;C39D41
	lda $01                                 ;C39D42
	pha                                     ;C39D44
	lda $02                                 ;C39D45
	inc a                                   ;C39D47
	pha                                     ;C39D48
	lda $03                                 ;C39D49
	inc a                                   ;C39D4B
	pha                                     ;C39D4C
	lda $03,s                               ;C39D4D
	tay                                     ;C39D4F
@lbl_C39D50:
	tya                                     ;C39D50
	cmp $01,s                               ;C39D51
	bcs @lbl_C39D86                         ;C39D53
	lda $04,s                               ;C39D55
	tax                                     ;C39D57
@lbl_C39D58:
	txa                                     ;C39D58
	cmp $02,s                               ;C39D59
	bcs @lbl_C39D82                         ;C39D5B
	jsl $C3F65F                             ;C39D5D
	lda $00                                 ;C39D61
	bmi @lbl_C39D7E                         ;C39D63
	stx $00                                 ;C39D65
	sty $01                                 ;C39D67
	jsr $A130                               ;C39D69
	lda $00                                 ;C39D6C
	bne @lbl_C39D7E                         ;C39D6E
	stx $00                                 ;C39D70
	sty $01                                 ;C39D72
	lda #$B0                                ;C39D74
	sta $02                                 ;C39D76
	phx                                     ;C39D78
	jsl $C36CBE                             ;C39D79
	plx                                     ;C39D7D
@lbl_C39D7E:
	inx                                     ;C39D7E
	inx                                     ;C39D7F
	bra @lbl_C39D58                         ;C39D80
@lbl_C39D82:
	iny                                     ;C39D82
	iny                                     ;C39D83
	bra @lbl_C39D50                         ;C39D84
@lbl_C39D86:
	pla                                     ;C39D86
	pla                                     ;C39D87
	pla                                     ;C39D88
	pla                                     ;C39D89
	plx                                     ;C39D8A
	rts                                     ;C39D8B

func_C39D8C:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C39DA3
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$08
	bcc @lbl_C39DB5
@lbl_C39DA3:
	jsl.l Random
	lda.b wTemp00
	bit.b #$03
	bne @lbl_C39DB5
;C39DAD  
	.db $AF,$8E,$BE,$7E,$AA,$CA,$10,$02
@lbl_C39DB5:
	plp
	rts
	lda $7EC166,x                           ;C39DB7
	cmp #$00                                ;C39DB9
	.db $D0,$F3   ;C39DBD
	lda $7EBE7A,x                           ;C39DBF
	sec                                     ;C39DC3
	sbc $7EBE66,x                           ;C39DC4
	dec a                                   ;C39DC8
	lsr a                                   ;C39DC9
	.db $90,$E6   ;C39DCA
	lda $7EBE84,x                           ;C39DCC
	sec                                     ;C39DD0
	sbc $7EBE70,x                           ;C39DD1
	dec a                                   ;C39DD5
	lsr a                                   ;C39DD6
	.db $90,$D9   ;C39DD7
	lda $7EBE66,x                           ;C39DD9
	inc a                                   ;C39DDD
	inc a                                   ;C39DDE
	pha                                     ;C39DDF
	lda $7EBE70,x                           ;C39DE0
	inc a                                   ;C39DE4
	inc a                                   ;C39DE5
	pha                                     ;C39DE6
	lda $7EBE7A,x                           ;C39DE7
	pha                                     ;C39DEB
	lda $7EBE84,x                           ;C39DEC
	pha                                     ;C39DF0
	lda $03,s                               ;C39DF1
	tay                                     ;C39DF3
@lbl_C39DF4:
	tya                                     ;C39DF4
	cmp $01,s                               ;C39DF5
	bcs @lbl_C39E17                         ;C39DF7
	lda $04,s                               ;C39DF9
	tax                                     ;C39DFB
@lbl_C39DFC:
	txa                                     ;C39DFC
	cmp $02,s                               ;C39DFD
	bcs @lbl_C39E13                         ;C39DFF
	stx $00                                 ;C39E01
	sty $01                                 ;C39E03
	lda #$E0                                ;C39E05
	sta $02                                 ;C39E07
	phx                                     ;C39E09
	jsl $C36CBE                             ;C39E0A
	plx                                     ;C39E0E
	inx                                     ;C39E0F
	inx                                     ;C39E10
	bra @lbl_C39DFC                         ;C39E11
@lbl_C39E13:
	iny                                     ;C39E13
	iny                                     ;C39E14
	bra @lbl_C39DF4                         ;C39E15
@lbl_C39E17:
	pla                                     ;C39E17
	pla                                     ;C39E18
	pla                                     ;C39E19
	pla                                     ;C39E1A
	plp                                     ;C39E1B
	rts                                     ;C39E1C

func_C39E1D:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C39E38
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$08
	bcc @lbl_C39E5F
	cmp.b #$1A
	bcs @lbl_C39E5F
@lbl_C39E38:
	lda.l $7EBE8E
	cmp.b #$0A
	beq @lbl_C39E5F
	ldy.b #$0E
@lbl_C39E42:
	tyx
	lda.l DATA8_C39F85,x
	tax
	lda.l $7E89C3,x
	cmp.b #$10
	bne @lbl_C39E5C
	lda.l $7E8A33,x
	cmp.b #$FE
	bne @lbl_C39E5C
	cpx.b #$23
	bne @lbl_C39E61
@lbl_C39E5C:
	dey
	bpl @lbl_C39E42
@lbl_C39E5F:
	plp
	rts
@lbl_C39E61:
	tyx
	lda.l UNREACH_C39F94,x
	sta.b wTemp00
	clc
	adc.b #$06
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	dec a
	pha
	clc
	adc.b #$05
	pha
	lda.l UNREACH_C39FA3,x
	sta.b wTemp00
	clc
	adc.b #$06
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	dec a
	pha
	clc
	adc.b #$05
	pha
	lda.l $7EBE8E
	tax
	lda.l $7EC166,x
	ora.b #$C0
	sta.l $7EC166,x
	lda.b wTemp04,s
	sta.l $7EBE66,x
	inc a
	sta.b wTemp00
	lda.b wTemp02,s
	sta.l $7EBE70,x
	inc a
	sta.b wTemp01
	lda.b wTemp03,s
	sta.l $7EBE7A,x
	dec a
	sta.b wTemp02
	lda.b wTemp01,s
	sta.l $7EBE84,x
	dec a
	sta.b wTemp03
	stx.b wTemp04
	phx
	jsl.l func_C36053
	plx
	txa
	inc a
	sta.l $7EBE8E
	lda.b wTemp04,s
	inc a
	sta.b wTemp00
	lda.b wTemp03,s
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	ldx.b wTemp00
	lda.b wTemp02,s
	inc a
	sta.b wTemp00
	lda.b wTemp01,s
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	lda.b #$86
	sta.b wTemp02
	jsl.l func_C35BA2
	lda.b wTemp02,s
	inc a
	tay
@lbl_C39F07:
	lda.b wTemp04,s
	inc a
	tax
	tya
	cmp.b wTemp01,s
	bcs @lbl_C39F43
@lbl_C39F10:
	txa
	cmp.b wTemp03,s
	bcs @lbl_C39F40
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C359AF
	plx
	lda.b wTemp01
	cmp.b #$80
	bne @lbl_C39F3D
	phx
	phy
	jsl.l SpawnFloorGitan
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C39F3D
	sta.b wTemp02
	stx.b wTemp00
	sty.b wTemp01
	phx
	jsl.l func_C35BA2
	plx
@lbl_C39F3D:
	inx
	bra @lbl_C39F10
@lbl_C39F40:
	iny
	bra @lbl_C39F07
@lbl_C39F43:
	lda.b wTemp04,s
	inc a
	sta.b wTemp00
	lda.b wTemp03,s
	dec a
	sta.b wTemp01
	jsl.l GetRandomInRange
	ldx.b wTemp00
	lda.b wTemp02,s
	inc a
	sta.b wTemp00
	lda.b wTemp01,s
	dec a
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	phx
	phy
	jsl.l func_C20BE7
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C39F7F
	stx.b wTemp00
	sty.b wTemp01
	sta.b wTemp02
	jsl.l func_C35B7A
@lbl_C39F7F:
	pla
	pla
	pla
	pla
	plp
	rts

DATA8_C39F85:
	.db $11,$12,$13,$14,$15,$21,$22,$23   ;C39F85
	.db $24,$25,$31,$32,$33,$34,$35       ;C39F8D

UNREACH_C39F94:
	.db $05,$10,$1B,$26,$31,$05,$10,$1B   ;C39F94  
	.db $26                               ;C39F9C  
	.db $31                               ;C39F9D
	.db $05,$10,$1B,$26,$31               ;C39F9E  

UNREACH_C39FA3:
	.db $05,$05,$05,$05,$05,$10,$10,$10   ;C39FA3  
	.db $10                               ;C39FAB  
	.db $10                               ;C39FAC
	.db $1B,$1B,$1B,$1B,$1B               ;C39FAD

func_C39FB2:
	php
	sep #$30 ;AXY->8
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C39FC9
	jsl.l GetCurrentFloor
	lda.b wTemp00
	cmp.b #$0C
	bcc @lbl_C39FDB
@lbl_C39FC9:
	jsl.l Random
	lda.b wTemp00
	bit.b #$0F
	bne @lbl_C39FDB
;C39FD3  
	.db $AF,$8E,$BE,$7E,$AA,$CA,$10,$02
@lbl_C39FDB:
	plp
	rts
	lda $7EC166,x                           ;C39FDD
	cmp #$00                                ;C39FDF
	.db $D0,$F3   ;C39FE3
	lda $7EBE7A,x                           ;C39FE5
	sec                                     ;C39FE9
	sbc $7EBE66,x                           ;C39FEA
	dec a                                   ;C39FEE
	lsr a                                   ;C39FEF
	.db $90,$E6   ;C39FF0
	lda $7EBE84,x                           ;C39FF2
	sec                                     ;C39FF6
	sbc $7EBE70,x                           ;C39FF7
	dec a                                   ;C39FFB
	lsr a                                   ;C39FFC
	.db $90,$D9   ;C39FFD
	lda $7EC166,x                           ;C39FFF
	ora #$04                                ;C3A003
	sta $7EC166,x                           ;C3A005
	lda $7EBE66,x                           ;C3A009
	inc a                                   ;C3A00D
	sta $00                                 ;C3A00E
	inc a                                   ;C3A010
	pha                                     ;C3A011
	lda $7EBE70,x                           ;C3A012
	inc a                                   ;C3A016
	sta $01                                 ;C3A017
	inc a                                   ;C3A019
	pha                                     ;C3A01A
	lda $7EBE7A,x                           ;C3A01B
	dec a                                   ;C3A01F
	sta $02                                 ;C3A020
	pha                                     ;C3A022
	lda $7EBE84,x                           ;C3A023
	dec a                                   ;C3A027
	sta $03                                 ;C3A028
	pha                                     ;C3A02A
	lda #$10                                ;C3A02B
	sta $04                                 ;C3A02D
	jsl $C36053                             ;C3A02F
	lda $03,s                               ;C3A033
	tay                                     ;C3A035
@lbl_C3A036:
	tya                                     ;C3A036
	cmp $01,s                               ;C3A037
	bcs @lbl_C3A06B                         ;C3A039
	lda $04,s                               ;C3A03B
	tax                                     ;C3A03D
@lbl_C3A03E:
	txa                                     ;C3A03E
	cmp $02,s                               ;C3A03F
	bcs @lbl_C3A067                         ;C3A041
	phx                                     ;C3A043
	jsl $C3F65F                             ;C3A044
	lda $00                                 ;C3A048
	and #$03                                ;C3A04A
	asl a                                   ;C3A04C
	tax                                     ;C3A04D
	pea $A053                               ;C3A04E
	jmp ($A071,x)                           ;C3A051
	plx                                     ;C3A054
	stx $00                                 ;C3A055
	sty $01                                 ;C3A057
	lda #$C0                                ;C3A059
	sta $02                                 ;C3A05B
	phx                                     ;C3A05D
	jsl $C36CBE                             ;C3A05E
	plx                                     ;C3A062
	inx                                     ;C3A063
	inx                                     ;C3A064
	bra @lbl_C3A03E                         ;C3A065
@lbl_C3A067:
	iny                                     ;C3A067
	iny                                     ;C3A068
	bra @lbl_C3A036                         ;C3A069
@lbl_C3A06B:
	pla                                     ;C3A06B
	pla                                     ;C3A06C
	pla                                     ;C3A06D
	pla                                     ;C3A06E
	plp                                     ;C3A06F
	rts                                     ;C3A070
	adc $7AA0,y                             ;C3A071
	ldy #$B4                                ;C3A074
	ldy #$E0                                ;C3A076
	ldy #$60                                ;C3A078
	lda $03,s                               ;C3A07A
	tax                                     ;C3A07C
	stx $00                                 ;C3A07D
	sty $01                                 ;C3A07F
	phx                                     ;C3A081
	jsl $C359AF                             ;C3A082
	plx                                     ;C3A086
	lda $00                                 ;C3A087
	cmp #$80                                ;C3A089
	bne @lbl_C3A0B3                         ;C3A08B
	stx $00                                 ;C3A08D
	sty $01                                 ;C3A08F
	phx                                     ;C3A091
	phy                                     ;C3A092
	jsl $C20BE7                             ;C3A093
	ply                                     ;C3A097
	plx                                     ;C3A098
	lda $00                                 ;C3A099
	bmi @lbl_C3A0B3                         ;C3A09B
	pha                                     ;C3A09D
	phx                                     ;C3A09E
	phy                                     ;C3A09F
	jsl $C27E85                             ;C3A0A0
	ply                                     ;C3A0A4
	plx                                     ;C3A0A5
	pla                                     ;C3A0A6
	sta $02                                 ;C3A0A7
	stx $00                                 ;C3A0A9
	sty $01                                 ;C3A0AB
	phx                                     ;C3A0AD
	jsl $C35B7A                             ;C3A0AE
	plx                                     ;C3A0B2
@lbl_C3A0B3:
	rts                                     ;C3A0B3
	lda $03,s                               ;C3A0B4
	tax                                     ;C3A0B6
	stx $00                                 ;C3A0B7
	sty $01                                 ;C3A0B9
	phx                                     ;C3A0BB
	jsl $C359AF                             ;C3A0BC
	plx                                     ;C3A0C0
	lda $01                                 ;C3A0C1
	cmp #$80                                ;C3A0C3
	bne @lbl_C3A0DF                         ;C3A0C5
	phx                                     ;C3A0C7
	phy                                     ;C3A0C8
	jsl $C303D0                             ;C3A0C9
	ply                                     ;C3A0CD
	plx                                     ;C3A0CE
	lda $00                                 ;C3A0CF
	bmi @lbl_C3A0DF                         ;C3A0D1
	sta $02                                 ;C3A0D3
	stx $00                                 ;C3A0D5
	sty $01                                 ;C3A0D7
	phx                                     ;C3A0D9
	jsl $C35BA2                             ;C3A0DA
	plx                                     ;C3A0DE
@lbl_C3A0DF:
	rts                                     ;C3A0DF
	lda $03,s                               ;C3A0E0
	tax                                     ;C3A0E2
	stx $00                                 ;C3A0E3
	sty $01                                 ;C3A0E5
	phx                                     ;C3A0E7
	jsl $C359AF                             ;C3A0E8
	plx                                     ;C3A0EC
	lda $00                                 ;C3A0ED
	cmp #$80                                ;C3A0EF
	bne @lbl_C3A113                         ;C3A0F1
	stx $00                                 ;C3A0F3
	sty $01                                 ;C3A0F5
	lda #$06                                ;C3A0F7
	sta $02                                 ;C3A0F9
	lda #$0F                                ;C3A0FB
	sta $03                                 ;C3A0FD
	phx                                     ;C3A0FF
	phy                                     ;C3A100
	jsl $C2007D                             ;C3A101
	ply                                     ;C3A105
	plx                                     ;C3A106
	lda $00                                 ;C3A107
	bmi @lbl_C3A113                         ;C3A109
	phx                                     ;C3A10B
	phy                                     ;C3A10C
	jsl $C20C16                             ;C3A10D
	ply                                     ;C3A111
	plx                                     ;C3A112
@lbl_C3A113:
	rts                                     ;C3A113

func_C3A114:
	phx
	phy
	php
	sep #$30 ;AXY->8
	ldy.b #$01
	jsl.l func_C36CA5
	lda.b wTemp00
	bit.b #$80
	bne @lbl_C3A129
	bit.b #$40
	bne @lbl_C3A12A
@lbl_C3A129:
	dey
@lbl_C3A12A:
	sty.b wTemp00
	plp
	ply
	plx
	rts
	phx                                     ;C3A130
	phy                                     ;C3A131
	php                                     ;C3A132
	sep #$30                                ;C3A133
	lda $01                                 ;C3A135
	pha                                     ;C3A137
	lda $00                                 ;C3A138
	pha                                     ;C3A13A
	ldx #$03                                ;C3A13B
@lbl_C3A13D:
	lda $01,s                               ;C3A13D
	clc                                     ;C3A13F
	adc $C392ED,x                           ;C3A140
	sta $00                                 ;C3A144
	lda $02,s                               ;C3A146
	clc                                     ;C3A148
	adc $C392F5,x                           ;C3A149
	sta $01                                 ;C3A14D
	jsr $A114                               ;C3A14F
	lda $00                                 ;C3A152
	bne @lbl_C3A159                         ;C3A154
	dex                                     ;C3A156
	bpl @lbl_C3A13D                         ;C3A157
@lbl_C3A159:
	pla                                     ;C3A159
	pla                                     ;C3A15A
	plp                                     ;C3A15B
	ply                                     ;C3A15C
	plx                                     ;C3A15D
	rts                                     ;C3A15E

.include "data/unknown_data_bank3_c3a15f.asm"
.include "data/maps/feis_problems.asm"

func_C3D219:
	rtl
	php                                     ;C3D21A
	sep #$30                                ;C3D21B
	jsl $C3D282                             ;C3D21D
	lda $00                                 ;C3D221
	cmp #$FF                                ;C3D223
	beq @lbl_C3D23B                         ;C3D225
	sta $00                                 ;C3D227
	jsl $C3035D                             ;C3D229
	lda $00                                 ;C3D22D
	pha                                     ;C3D22F
	jsl $C36203                             ;C3D230
	pla                                     ;C3D234
	sta $02                                 ;C3D235
	jsl $C35BA2                             ;C3D237
@lbl_C3D23B:
	jsl $C627E6                             ;C3D23B
	lda $00                                 ;C3D23F
	pha                                     ;C3D241
	jsl $C62771                             ;C3D242
	lda $00                                 ;C3D246
	pha                                     ;C3D248
	ldx #$00                                ;C3D249
@lbl_C3D24B:
	lda $C3D281,x                           ;C3D24B
	bmi @lbl_C3D27D                         ;C3D24F
	tay                                     ;C3D251
	lda $C3D282,x                           ;C3D252
	cmp $02,s                               ;C3D256
	bne @lbl_C3D278                         ;C3D258
	lda $C3D283,x                           ;C3D25A
	cmp $01,s                               ;C3D25E
	bne @lbl_C3D278                         ;C3D260
	phx                                     ;C3D262
	sty $00                                 ;C3D263
	jsl $C3035D                             ;C3D265
	lda $00                                 ;C3D269
	pha                                     ;C3D26B
	jsl $C36203                             ;C3D26C
	pla                                     ;C3D270
	sta $02                                 ;C3D271
	jsl $C35BA2                             ;C3D273
	plx                                     ;C3D277
@lbl_C3D278:
	inx                                     ;C3D278
	inx                                     ;C3D279
	inx                                     ;C3D27A
	bra @lbl_C3D24B                         ;C3D27B
@lbl_C3D27D:
	pla                                     ;C3D27D
	pla                                     ;C3D27E
	plp                                     ;C3D27F
	rtl                                     ;C3D280
	sbc $30E208,x                           ;C3D281
	lda #$FF                                ;C3D285
	sta $00                                 ;C3D287
	plp                                     ;C3D289
	rtl                                     ;C3D28A
	jsl $C62771                             ;C3D28B
	lda $00                                 ;C3D28F
	pha                                     ;C3D291
	jsl $C627E6                             ;C3D292
	ldx $00                                 ;C3D296
	cpx #$00                                ;C3D298
	beq @lbl_C3D2A6                         ;C3D29A
	cpx #$01                                ;C3D29C
	beq @lbl_C3D2AC                         ;C3D29E
	cpx #$02                                ;C3D2A0
	beq @lbl_C3D2B2                         ;C3D2A2
	bra @lbl_C3D2C4                         ;C3D2A4
@lbl_C3D2A6:
	ldy #$E1                                ;C3D2A6
	lda #$09                                ;C3D2A8
	bra @lbl_C3D2B6                         ;C3D2AA
@lbl_C3D2AC:
	ldy #$E2                                ;C3D2AC
	lda #$20                                ;C3D2AE
	bra @lbl_C3D2B6                         ;C3D2B0
@lbl_C3D2B2:
	ldy #$E3                                ;C3D2B2
	lda #$20                                ;C3D2B4
@lbl_C3D2B6:
	cmp $01,s                               ;C3D2B6
	bcs @lbl_C3D2C4                         ;C3D2B8
	phy                                     ;C3D2BA
	jsl $C2487E                             ;C3D2BB
	ply                                     ;C3D2BF
	lda $00                                 ;C3D2C0
	beq @lbl_C3D2C6                         ;C3D2C2
@lbl_C3D2C4:
	ldy #$FF                                ;C3D2C4
@lbl_C3D2C6:
	pla                                     ;C3D2C6
	sty $00                                 ;C3D2C7
	plp                                     ;C3D2C9
	rtl                                     ;C3D2CA

func_C3D2CB:
	rtl

;something related to spawning traps
func_C3D2CC:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$08
	bne @lbl_C3D309
	jsl.l Get7ED5EC
	lda.b wTemp00
	dec a
	sta.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	lda.l FeisProblemsMapTrapListDataTable,x
	sta.b wTemp04
	lda.l FeisProblemsMapTrapListDataTable+1,x
	sta.b wTemp05
	lda.l FeisProblemsMapTrapListDataTable+2,x
	sta.b wTemp06
	ldy.b #$0A
@lbl_C3D2FF:
	lda.b [wTemp04],y
	sta.w wTrapSpawnList,y
	dey
	bpl @lbl_C3D2FF
	plp
	rtl
@lbl_C3D309:
	ldy.b #$0A
	lda.b #$FF
@lbl_C3D30D:
	sta.w wTrapSpawnList,y
	dey
	bpl @lbl_C3D30D
	stz.b wTemp06
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$03
	bne @lbl_C3D321
	inc.b wTemp06
@lbl_C3D321:
	lda.b #$00
	sta.w $C19A
	lda.b wTemp06
	beq @lbl_C3D338
	stz.b wTemp04
	jsl Random
	lda.b wTemp00
	bit #$07
	beq @lbl_C3D338
	inc.b wTemp04
@lbl_C3D338:
	ldy.b #$03
@lbl_C3D33A:
	phy
@lbl_C3D33B:
	jsl.l Random
	lda.b wTemp00
	and.b #$07
	cmp.b #$06
	bcs @lbl_C3D33B
	tax
	lda.l DATA8_C3D398,x
	ldx.b wTemp06
	beq @lbl_C3D358
	ldx.b wTemp04
	beq @lbl_C3D358
	cmp #$10
	beq @lbl_C3D33B
@lbl_C3D358:
	ldy.b #$04
@lbl_C3D35A:
	cmp.w wTrapSpawnList,y
	beq @lbl_C3D33B
	dey
	bpl @lbl_C3D35A
	ply
	sta.w wTrapSpawnList,y
	dey
	bpl @lbl_C3D33A
	ldy.b #$05
@lbl_C3D36B:
	phy
@lbl_C3D36C:
	jsl.l Random
	lda.b wTemp00
	and.b #$0F
	cmp.b #$0D
	bcs @lbl_C3D36C
	tax
	lda.l DATA8_C3D39E,x
	ldx.b wTemp06
	beq @lbl_C3D385
	cmp #Trap_HungerTrap
	beq @lbl_C3D36C
@lbl_C3D385:
	ldy.b #$05
@lbl_C3D387:
	cmp.w $C19B,y
	beq @lbl_C3D36C
	dey
	bpl @lbl_C3D387
	ply
	sta.w $C19B,y
	dey
	bpl @lbl_C3D36B
	plp
	rtl

DATA8_C3D398:
	.db $01,$02,$11,$07,$14,$10           ;C3D398

DATA8_C3D39E:
	.db $04,$06,$08,$05,$09,$0A,$16,$0E   ;C3D39E
	.db $12,$0D,$0F,$13,$17               ;C3D3A6

func_C3D3AB:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$00
	beq @lbl_C3D3FD
	ldy.b #$02
	cmp.b #$0C
	beq @lbl_C3D3C7
	dey
	cmp.b #$0A
	beq @lbl_C3D3C7
	dey
@lbl_C3D3C7:
	jsl.l Random
	lda.b wTemp00
	and.b #$0F
	cmp.b #$0B
	bcs @lbl_C3D3C7
	cpy.b #$01
	bne @lbl_C3D3DB
	cmp.b #$04
	beq @lbl_C3D3C7
@lbl_C3D3DB:
	tax
	lda.l $7EC196,x
	cmp.b #$00
	bne @lbl_C3D3F0
	pha
	jsl.l Random
	pla
	ldx.b wTemp00
	cpx.b #$AB
	bcs @lbl_C3D3C7
@lbl_C3D3F0:
	cpy.b #$02
	bne @lbl_C3D3F8
;C3D3F4
	.db $C9,$17,$F0,$CF
@lbl_C3D3F8:
	sta.b wTemp00
	pla
	plp
	rtl
@lbl_C3D3FD:
	jsl.l $C3F65F                           ;C3D3FD
	lda $00                                 ;C3D401
	and #$0F                                ;C3D403
	cmp #$0B                                ;C3D405
	bcs @lbl_C3D3FD                         ;C3D407
	tax                                     ;C3D409
	lda.l $7EC196,x                         ;C3D40A
	sta $00                                 ;C3D40E
	lda $01,s                               ;C3D410
	cmp #$0A                                ;C3D412
	bne @lbl_C3D41C                         ;C3D414
	lda $00                                 ;C3D416
	cmp #$00                                ;C3D418
	beq @lbl_C3D3FD                         ;C3D41A
@lbl_C3D41C:
	pla                                     ;C3D41C
	plp                                     ;C3D41D
	rtl                                     ;C3D41E

func_C3D41F:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	tay
	asl a
	pha
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C210FF
	sty.b wTemp00
	jsl.l func_C62735
	plx
	rep #$30 ;AXY->16
	jmp.w func_C3D479

func_C3D43B:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C210FF
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C62735
	jsl.l Random
	pla
	asl a
	tax
	rep #$30 ;AXY->16
	lda.b wTemp00
	and.w #$0001
	beq func_C3D479
	lda.l UNREACH_C3D4C4,x
	sta.b wTemp00
	phx
	jsl.l DisplayMessage
	plx
	lda.l UNREACH_C3D4F6,x
	sta.b wTemp00
	jsl.l DisplayMessage
	plp
	rtl
func_C3D479:
	lda.l UNREACH_C3D4C4,x
	sta.b wTemp00
	phx
	jsl.l DisplayMessage
	plx
	lda.w #$0013
	sta.b wTemp00
	jumptablecall Jumptable_C3D492
	plp
	rtl

Jumptable_C3D492:
	.dw $D5CD
	.dw $D587
	.dw $D7A3
	.dw $D59E
	.dw $D5DC
	.dw $D623
	.dw $D647
	.dw $DB53
	.dw $D688
	.dw $D7CF
	.dw $D7B6
	.dw $D7EE
	.dw $D81E
	.dw $D847
	.dw $D87C
	.dw $D89F
	.dw $D8C4
	.dw $D920
	.dw $D967
	.dw $D9C1
	.dw $DC29
	.dw $D9E6
	.dw $DA2E
	.dw $DA76
	.dw $E0AE

UNREACH_C3D4C4:
	.dw $0141
	.dw $0142
	.dw $0143
	.dw $0144
	.dw $0144
	.dw $0145
	.dw $0145
	.dw $0146
	.dw $0147
	.dw $0148
	.dw $0149
	.dw $014A
	.dw $014D
	.dw $014B
	.dw $014C
	.dw $014D
	.dw $0145
	.dw $014D
	.dw $014C
	.dw $014D
	.dw $014E
	.dw $0145
	.dw $014C
	.dw $014D
	.dw $014D

UNREACH_C3D4F6:
	.dw $014F
	.dw $0150
	.dw $0151
	.dw $0151
	.dw $0151
	.dw $0151
	.dw $0151
	.dw $0153
	.dw $0154
	.dw $0151
	.dw $0151
	.dw $0151
	.dw $0151
	.dw $0151
	.dw $0155
	.dw $0154
	.dw $0151
	.dw $0151
	.dw $0152
	.dw $0151
	.dw $0156
	.dw $0151
	.dw $005C
	.dw $0151
	.dw $0151

func_C3D528:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	ldx.b wTemp01
	phx
	stx.b wTemp00
	asl a
	pha
	jsl.l func_C210FF
	lda.b wTemp01,s
	lsr a
	sta.b wTemp00
	rep #$20 ;A->16
	lda.b wTemp04
	pha
	jsl.l func_C62735
	pla
	sep #$20 ;A->8
	plx
	pla
	sta.b wTemp00
	jumptablecall Jumptable_C3D555
	plp
	rtl

Jumptable_C3D555:
	.dw $DDC9
	.dw $DF3A
	.dw $DFF6
	.dw $DF4F
	.dw $DF4F
	.dw $DDDE
	.dw $DF9A
	.dw $DB5D
	.dw $DF1D
	.dw $D7CF
	.dw $DE88
	.dw $D7EE
	.dw $DF0E
	.dw $E00B
	.dw $DE52
	.dw $E032
	.dw $D8C4
	.dw $DFC1
	.dw $DECF
	.dw $E059
	.dw $DC33
	.dw $DB5D
	.dw $DEA9
	.dw $DA84
	.dw $E0CC

;c3d587
	sep #$20 ;A->8
	lda.b #$05
	sta.b wTemp00
	jsl.l func_C27EAC
	lda.b #$13
	sta.b wTemp00
	lda.b #$18
	sta.b wTemp02
	jsl.l PlayVisualEffect
	rts
	sep #$20                                ;C3D59E
	lda #$C3                                ;C3D5A0
	sta $00                                 ;C3D5A2
	jsl $C23BA6                             ;C3D5A4
	lda #$9C                                ;C3D5A8
	sta $00                                 ;C3D5AA
	stz $01                                 ;C3D5AC
	jsl.l DisplayMessage
	lda #$13                                ;C3D5B2
	sta $00                                 ;C3D5B4
	lda #$13                                ;C3D5B6
	sta $02                                 ;C3D5B8
	jsl PlayVisualEffect                             ;C3D5BA
	lda #$13                                ;C3D5BE
	sta $00                                 ;C3D5C0
	sta $01                                 ;C3D5C2
	lda #$08                                ;C3D5C4
	sta $02                                 ;C3D5C6
	jsl $C228EF                             ;C3D5C8
	rts                                     ;C3D5CC
	sep #$20                                ;C3D5CD
	lda #$C2                                ;C3D5CF
	sta $00                                 ;C3D5D1
	jsl $C23BA6                             ;C3D5D3
	jsl $C27EE1                             ;C3D5D7
	rts                                     ;C3D5DB
	sep #$20 ;A->8
	lda.b #$C4
	sta.b wTemp00
	jsl.l func_C23BA6
	lda.b #$94
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	lda.b #$14
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$13
	sta.b wTemp00
	sta.b wTemp01
	lda.b #$08
	sta.b wTemp02
	jsl.l func_C228EF
	lda.b #$FF
	sta.b wTemp00
	jsl.l ModifyShirenStrength
	lda.b wTemp00
	beq @lbl_C3D622
	sta.b wTemp02
	lda.b #$A0
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
@lbl_C3D622:
	rts
	sep #$20 ;A->8
	lda.b #$19
	sta.b wTemp02
	jsl.l PlayVisualEffect
	jsl.l GetCategoryShortcutItemIds
	lda.b wTemp01
	bmi @lbl_C3D63A
	jsl.l func_C27ECA
	rts
@lbl_C3D63A:
	lda.b #$39
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage
	rts
	sep #$20                                ;C3D647
	lda #$EE                                ;C3D649
	sta $00                                 ;C3D64B
	stz $01                                 ;C3D64D
	jsl.l DisplayMessage
	lda #$13                                ;C3D653
	sta $00                                 ;C3D655
	lda #$1A                                ;C3D657
	sta $02                                 ;C3D659
	jsl PlayVisualEffect                             ;C3D65B
	lda #$13                                ;C3D65F
	sta $00                                 ;C3D661
	lda #$05                                ;C3D663
	sta $01                                 ;C3D665
	jsl $C24080                             ;C3D667
	lda $00                                 ;C3D66B
	.db $F0,$0E   ;C3D66D
	lda #$13                                ;C3D66F
	sta $02                                 ;C3D671
	lda #$ED                                ;C3D673
	sta $00                                 ;C3D675
	stz $01                                 ;C3D677
	jsl.l DisplayMessage
	rts                                     ;C3D67D
	php                                     ;C3D67E
	rep #$20                                ;C3D67F
	sep #$10                                ;C3D681
	jsr $D695                               ;C3D683
	plp                                     ;C3D686
	rtl                                     ;C3D687
.ACCU 8
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.w #$005F
	sta.b wTemp00
	jsl.l DisplayMessage
	ldy.b #$13
	sty.b wTemp00
	ldy.b #$15
	sty.b wTemp02
	jsl.l PlayVisualEffect
	ldx.b #$13
	stx.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp00
	ldy.b wTemp02
	pha
	pha
	phy
	pha
	lda.w #$000A
@lbl_C3D6B4:
	pha
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b wTemp05,s
	sta.b wTemp02
	jsl.l func_C36410
	lda.b wTemp00
	pha
	bpl @lbl_C3D6D3
@lbl_C3D6C6:
	pla
	pla
@lbl_C3D6C8:
	pha
	jsl.l func_C625CE
	pla
	dec a
	bne @lbl_C3D6C8
	bra @lbl_C3D6FC
@lbl_C3D6D3:
	jsl.l func_C23B1C
	ldx.b wTemp00
	bmi @lbl_C3D6C6
	jsr.w func_C3D772
	stx.b wTemp00
	phx
	jsl.l GetItemDisplayInfo
	plx
	ldy.b wTemp00
	cpy.b #$0B
	bne @lbl_C3D6F7
	jsl.l Random
	lda.b wTemp00
	and.w #$000F
	beq @lbl_C3D701
@lbl_C3D6F7:
	pla
	pla
	dec a
	bne @lbl_C3D6B4
@lbl_C3D6FC:
	pla
	ply
	pla
	pla
	rts
@lbl_C3D701:
	pla                                     ;C3D701
	sta $06,s                               ;C3D702
	txa                                     ;C3D704
	sta $08,s                               ;C3D705
	lda #$0041                              ;C3D707
	sta $02                                 ;C3D709
	jsl $C62642                             ;C3D70B
	bra @lbl_C3D73D                         ;C3D70F
@lbl_C3D712:
	pha                                     ;C3D711
	lda $03,s                               ;C3D712
	sta $00                                 ;C3D714
	lda $05,s                               ;C3D716
	sta $02                                 ;C3D718
	jsl $C36410                             ;C3D71A
	lda $00                                 ;C3D71E
	pha                                     ;C3D720
	bpl @lbl_C3D731                         ;C3D721
@lbl_C3D724:
	pla                                     ;C3D723
	pla                                     ;C3D724
@lbl_C3D726:
	pha                                     ;C3D725
	jsl $C625CE                             ;C3D726
	pla                                     ;C3D72A
	dec a                                   ;C3D72B
	bne @lbl_C3D726                         ;C3D72C
	bra @lbl_C3D741                         ;C3D72E
@lbl_C3D731:
	jsl $C23B1C                             ;C3D730
	ldx $00                                 ;C3D734
	bmi @lbl_C3D724                         ;C3D736
	jsr $D772                               ;C3D738
	pla                                     ;C3D73B
@lbl_C3D73D:
	pla                                     ;C3D73C
	dec a                                   ;C3D73D
	bne @lbl_C3D712                         ;C3D73E
@lbl_C3D741:
	pla                                     ;C3D740
	ply                                     ;C3D741
	lda $01,s                               ;C3D742
	sta $00                                 ;C3D744
	lda #$0080                              ;C3D746
	sta $02                                 ;C3D748
	jsl $C35BA2                             ;C3D74A
	lda $03,s                               ;C3D74E
	sta $00                                 ;C3D750
	ldy #$0B                                ;C3D752
	sty $01                                 ;C3D754
	lda #$064A                              ;C3D756
	sta $02                                 ;C3D758
	lda $01,s                               ;C3D75A
	sta $04                                 ;C3D75C
	sta $06                                 ;C3D75E
	jsl $C626CA                             ;C3D760
	pla                                     ;C3D764
	sta $02                                 ;C3D765
	pla                                     ;C3D767
	sta $00                                 ;C3D768
	jsl $C33170                             ;C3D76A
	rts                                     ;C3D76E

func_C3D772:
	stx.b wTemp00
	phx
	jsl.l GetItemDisplayInfo
	plx
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	ldy.b #$40
	sty.b wTemp02
	ldy.b #$02
	sty.b wTemp03
	lda.b wTemp07,s
	sta.b wTemp04
	lda.b wTemp03,s
	sta.b wTemp06
	phx
	jsl.l func_C626CA
	plx
	lda.b wTemp03,s
	sta.b wTemp02
	stx.b wTemp00
	phx
	jsl.l func_C330D1
	plx
	rts
	sep #$20 ;A->8
	lda.b #$10
	sta.b wTemp02
	jsl.l func_C626F6
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C24390
	rts
	sep #$20                                ;C3D7B6
	lda #$13                                ;C3D7B8
	sta $00                                 ;C3D7BA
	jsl $C3694D                             ;C3D7BC
	lda #$E9                                ;C3D7C0
	sta $00                                 ;C3D7C2
	stz $01                                 ;C3D7C4
	lda #$13                                ;C3D7C6
	sta $02                                 ;C3D7C8
	jsl.l DisplayMessage
	rts                                     ;C3D7CE
	sep #$20                                ;C3D7CF
	lda $00                                 ;C3D7D1
	pha                                     ;C3D7D3
	jsl $C27FBD                             ;C3D7D4
	pla                                     ;C3D7D8
	sta $00                                 ;C3D7D9
	lda #$20                                ;C3D7DB
	sta $02                                 ;C3D7DD
	jsl PlayVisualEffect                             ;C3D7DF
	lda #$F1                                ;C3D7E3
	sta $00                                 ;C3D7E5
	stz $01                                 ;C3D7E7
	jsl.l DisplayMessage
	rts                                     ;C3D7ED
	sep #$20                                ;C3D7EE
	jsl $C369DF                             ;C3D7F0
	lda $00                                 ;C3D7F4
	.db $D0,$1B   ;C3D7F6
	lda #$13                                ;C3D7F8
	sta $00                                 ;C3D7FA
	lda #$03                                ;C3D7FC
	sta $02                                 ;C3D7FE
	jsl $C626F6                             ;C3D800
	jsl $C366F6                             ;C3D804
	lda #$E8                                ;C3D808
	sta $00                                 ;C3D80A
	stz $01                                 ;C3D80C
	jsl.l DisplayMessage
	rts                                     ;C3D812
	lda #$F0                                ;C3D813
	sta $00                                 ;C3D815
	stz $01                                 ;C3D817
	jsl.l DisplayMessage
	rts                                     ;C3D81D
	sep #$20                                ;C3D81E
	lda #$1E                                ;C3D820
	sta $02                                 ;C3D822
	jsl PlayVisualEffect                             ;C3D824
	jsl $C2433A                             ;C3D828
	lda #$EA                                ;C3D82C
	sta $00                                 ;C3D82E
	stz $01                                 ;C3D830
	lda #$13                                ;C3D832
	sta $02                                 ;C3D834
	jsl.l DisplayMessage
	lda #$13                                ;C3D83A
	sta $00                                 ;C3D83C
	lda #$01                                ;C3D83E
	sta $02                                 ;C3D840
	jsl PlayVisualEffect                             ;C3D842
	rts                                     ;C3D846
	sep #$30 ;AXY->8
	lda.b #$EB
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$13
	sta.b wTemp02
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	lda.b #$1B
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$13
	sta.b wTemp00
	lda.b #$0A
	sta.b wTemp01
	jsl.l func_C23FFF
	lda.b wTemp00
	bne @lbl_C3D87B
;C3D873
	lda #$2C                                ;C3D873
	sta $02                                 ;C3D875
	jsl $C625E5                             ;C3D877
@lbl_C3D87B:
	rts
	rep #$20                                ;C3D87C
	lda #$FF9C                              ;C3D87E
	sta $00                                 ;C3D880
	jsl ModifyShirenHunger                             ;C3D882
	lda #$0051                              ;C3D886
	sta $00                                 ;C3D888
.ACCU 8
	jsl.l DisplayMessage
	sep #$20                                ;C3D88E
	lda #$13                                ;C3D890
	sta $00                                 ;C3D892
	lda #$1D                                ;C3D894
	sta $02                                 ;C3D896
	jsl PlayVisualEffect                             ;C3D898
	rts                                     ;C3D89C
	sep #$20 ;A->8
	lda.b #$0A
	sta.b wTemp01
	jsl.l func_C24073
	lda.b #$13
	sta.b wTemp00
	lda.b #$1C
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$EC
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$13
	sta.b wTemp02
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	ldy.b wTemp00
	lda.b #$1E
@lbl_C3D8D4:
	pha
@lbl_C3D8D5:
	phy
	jsl.l func_C36287
	ply
	cpy.b wTemp00
	beq @lbl_C3D8D5
	ldx.b wTemp00
	bmi @lbl_C3D905
@lbl_C3D8E3:
	jsl.l GetCurrentFloor
	phx
	phy
	jsl.l func_C3D3AB
	ply
	plx
	lda.b wTemp00
	bmi @lbl_C3D905
	cmp.b #$10
	beq @lbl_C3D8E3
	cmp.b #$0A
	beq @lbl_C3D8E3
	stx.b wTemp00
	ora.b #$C0
	sta.b wTemp02
	jsl.l func_C35BA2
@lbl_C3D905:
	pla
	dec a
	bne @lbl_C3D8D4
	lda.l $7E8975
	bit.b #$01
	beq @lbl_C3D915
;C3D911  
	jsl $C35FA2                             ;C3D90F
@lbl_C3D915:
	lda.b #$F2
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	lda.b #$E4
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	lda.b #$0F
	sta.b wTemp02
	jsl.l func_C626F6
	lda.b #$13
	sta.b wTemp00
	lda.b #$23
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$C9
	sta.b wTemp00
	jsl.l func_C23BA6
	lda.b #$05
	sta.b wTemp00
	lda.b #$09
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	sta.b wTemp02
	lda.b #$13
	sta.b wTemp00
	sta.b wTemp01
	jsl.l func_C228DF
	rts
	.db $E2,$30,$A9,$DC,$85,$00,$64,$01
	jsl.l DisplayMessage
	lda #$13                                ;C3D973
	sta $00                                 ;C3D975
	lda #$1F                                ;C3D977
	sta $02                                 ;C3D979
	jsl PlayVisualEffect                             ;C3D97B
	ldy #$8400                              ;C3D97F
	.db $00   ;C3D982
	phy                                     ;C3D983
	jsl $C23B7C                             ;C3D984
	ply                                     ;C3D988
	ldx $00                                 ;C3D989
	bmi @lbl_C3D9A4                         ;C3D98B
	phx                                     ;C3D98D
	phy                                     ;C3D98E
	jsl $C30710                             ;C3D98F
	ply                                     ;C3D993
	plx                                     ;C3D994
	lda $00                                 ;C3D995
	cmp #$02                                ;C3D997
	bne @lbl_C3D9A1                         ;C3D999
	lda $01                                 ;C3D99B
	cmp #$B0                                ;C3D99D
	.db $D0,$0F   ;C3D99F
@lbl_C3D9A1:
	iny                                     ;C3D9A1
	.db $80,$DD   ;C3D9A2
@lbl_C3D9A4:
	rep #$20                                ;C3D9A4
	lda #$0154                              ;C3D9A6
	sta $00                                 ;C3D9A9
.ACCU 8
	jsl.l DisplayMessage
	rts                                     ;C3D9AF
	jsl $C34123                             ;C3D9B0
	sep #$20                                ;C3D9B4
	lda #$DD                                ;C3D9B6
	sta $00                                 ;C3D9B8
	stz $01                                 ;C3D9BA
	jsl.l DisplayMessage
	rts                                     ;C3D9C0
	sep #$20 ;A->8
	lda.b #$E5
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$13
	sta.b wTemp02
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	lda.b #$21
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C240D6
	rts
	sep #$20                                ;C3D9E6
	lda #$E0                                ;C3D9E8
	sta $00                                 ;C3D9EA
	stz $01                                 ;C3D9EC
	jsl.l DisplayMessage
	jsl $C28CEF                             ;C3D9F2
	rts                                     ;C3D9F6
	php                                     ;C3D9F7
	sep #$20                                ;C3D9F8
	rep #$10                                ;C3D9FA
	ldy $00                                 ;C3D9FC
	sty $04                                 ;C3D9FE
	sty $06                                 ;C3DA00
	lda #$0E                                ;C3DA02
	sta $02                                 ;C3DA04
	phy                                     ;C3DA06
	jsl $C626DF                             ;C3DA07
	ply                                     ;C3DA0B
	lda #$CA                                ;C3DA0C
	sta $00                                 ;C3DA0E
	jsl $C23BA6                             ;C3DA10
	pea $DA19                               ;C3DA14
	jmp $DB7D                               ;C3DA17
	plp                                     ;C3DA1A
	rtl                                     ;C3DA1B

DATA8_C3DA1C:
	.db $01,$00,$01,$FF,$00,$FF,$FF,$FE,$FF,$FF,$FF,$00,$00,$01,$01,$01   ;C3DA1C
	.db $00,$00                           ;C3DA2C
	sep #$20 ;A->8
	jsl.l GetCategoryShortcutItemIds
	lda.b wTemp00
	bpl @lbl_C3DA5B
	lda.b wTemp01
	bpl @lbl_C3DA5B
	lda.b wTemp02
	bpl @lbl_C3DA5B
	lda.b wTemp03
	bpl @lbl_C3DA5B
	lda.b #$13
	sta.b wTemp00
	lda.b #$33
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$EF
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	rts
@lbl_C3DA5B:
	lda #$13                                ;C3DA5B
	sta $00                                 ;C3DA5D
	lda #$22                                ;C3DA5F
	sta $02                                 ;C3DA61
	jsl PlayVisualEffect                             ;C3DA63
	jsl $C34153                             ;C3DA67
	lda #$DE                                ;C3DA6B
	sta $00                                 ;C3DA6D
	stz $01                                 ;C3DA6F
	jsl.l DisplayMessage
	rts                                     ;C3DA75
	sep #$30                                ;C3DA76
	lda #$CB                                ;C3DA78
	sta $00                                 ;C3DA7A
	jsl $C23BA6                             ;C3DA7C
	ldx #$13                                ;C3DA80
	stx $00                                 ;C3DA82
	sep #$30                                ;C3DA84
	ldx $00                                 ;C3DA86
	phx                                     ;C3DA88
	jsl $C210AC                             ;C3DA89
	plx                                     ;C3DA8D
	lda $00                                 ;C3DA8E
	pha                                     ;C3DA90
	lda $01                                 ;C3DA91
	pha                                     ;C3DA93
	lda $02                                 ;C3DA94
	pha                                     ;C3DA96
	lda $04                                 ;C3DA97
	pha                                     ;C3DA99
	lda #$80                                ;C3DA9A
	sta $02                                 ;C3DA9C
	phx                                     ;C3DA9E
	jsl $C35B7A                             ;C3DA9F
	plx                                     ;C3DAA3
	lda $02,s                               ;C3DAA4
	clc                                     ;C3DAA6
	adc #$04                                ;C3DAA7
	and #$07                                ;C3DAA9
	sta $00                                 ;C3DAAB
	lda #$0A                                ;C3DAAD
	sta $01                                 ;C3DAAF
	lda $04,s                               ;C3DAB1
	sta $02                                 ;C3DAB3
	lda $03,s                               ;C3DAB5
	sta $03                                 ;C3DAB7
	phx                                     ;C3DAB9
	jsl $C32FEE                             ;C3DABA
	plx                                     ;C3DABE
	lda $03                                 ;C3DABF
	sta $07                                 ;C3DAC1
	pha                                     ;C3DAC3
	lda $02                                 ;C3DAC4
	sta $06                                 ;C3DAC6
	pha                                     ;C3DAC8
	lda $00                                 ;C3DAC9
	pha                                     ;C3DACB
	lda #$11                                ;C3DACC
	sta $02                                 ;C3DACE
	lda $05,s                               ;C3DAD0
	sta $03                                 ;C3DAD2
	lda $07,s                               ;C3DAD4
	sta $04                                 ;C3DAD6
	lda $06,s                               ;C3DAD8
	sta $05                                 ;C3DADA
	phx                                     ;C3DADC
	jsl $C626DF                             ;C3DADD
	plx                                     ;C3DAE1
	stx $00                                 ;C3DAE2
	lda $04,s                               ;C3DAE4
	sta $01                                 ;C3DAE6
	lda #$24                                ;C3DAE8
	sta $02                                 ;C3DAEA
	phx                                     ;C3DAEC
	jsl $C626A0                             ;C3DAED
	plx                                     ;C3DAF1
	pla                                     ;C3DAF2
	bmi @lbl_C3DB05                         ;C3DAF3
	sta $00                                 ;C3DAF5
	lda #$13                                ;C3DAF7
	sta $01                                 ;C3DAF9
	lda #$05                                ;C3DAFB
	sta $02                                 ;C3DAFD
	phx                                     ;C3DAFF
	jsl $C228DF                             ;C3DB00
	plx                                     ;C3DB04
@lbl_C3DB05:
	rep #$20                                ;C3DB05
	lda $01,s                               ;C3DB07
	sta $00                                 ;C3DB09
	phx                                     ;C3DB0B
	jsl $C3631A                             ;C3DB0C
	plx                                     ;C3DB10
	lda $00                                 ;C3DB11
	bmi @lbl_C3DB17                         ;C3DB13
	sta $01,s                               ;C3DB15
@lbl_C3DB17:
	lda $01,s                               ;C3DB17
	sta $00                                 ;C3DB19
	stx $02                                 ;C3DB1B
	phx                                     ;C3DB1D
	jsl $C35B7A                             ;C3DB1E
	plx                                     ;C3DB22
	stx $00                                 ;C3DB23
	pla                                     ;C3DB25
	sta $02                                 ;C3DB26
	phx                                     ;C3DB28
	jsl $C20DD1                             ;C3DB29
	plx                                     ;C3DB2D
	sep #$20                                ;C3DB2E
	lda #$05                                ;C3DB30
	sta $02                                 ;C3DB32
	stx $00                                 ;C3DB34
	lda #$13                                ;C3DB36
	sta $01                                 ;C3DB38
	phx                                     ;C3DB3A
	jsl $C228DF                             ;C3DB3B
	plx                                     ;C3DB3F
	stx $00                                 ;C3DB40
	phx                                     ;C3DB42
	jsl $C2457A                             ;C3DB43
	plx                                     ;C3DB47
	stx $00                                 ;C3DB48
	jsl $C24584                             ;C3DB4A
	pla                                     ;C3DB4E
	pla                                     ;C3DB4F
	pla                                     ;C3DB50
	pla                                     ;C3DB51
	rts                                     ;C3DB52
	sep #$20                                ;C3DB53
	rep #$10                                ;C3DB55
	lda #$13                                ;C3DB57
	sta $00                                 ;C3DB59
	bra @lbl_C3DB63                         ;C3DB5B
	sep #$20                                ;C3DB5D
	rep #$10                                ;C3DB5F
	lda $00                                 ;C3DB61
@lbl_C3DB63:
	pha                                     ;C3DB63
	lda #$0C                                ;C3DB64
	sta $02                                 ;C3DB66
	jsl $C626F6                             ;C3DB68
	pla                                     ;C3DB6C
	sta $00                                 ;C3DB6D
	jsl $C210AC                             ;C3DB6F
	ldy $00                                 ;C3DB73
	lda #$C5                                ;C3DB75
	sta $00                                 ;C3DB77
	jsl $C23BA6                             ;C3DB79
	lda #$FF                                ;C3DB7D
	pha                                     ;C3DB7F
	ldx #$0010                              ;C3DB80
@lbl_C3DB83:
	rep #$20                                ;C3DB82
	tya                                     ;C3DB84
	clc                                     ;C3DB85
	adc $C3DA1C,x                           ;C3DB86
	sta $00                                 ;C3DB88
	sta $06                                 ;C3DB8A
	phx                                     ;C3DB8C
	jsl $C359AF                             ;C3DB8D
	plx                                     ;C3DB91
	sep #$20                                ;C3DB92
	lda $00                                 ;C3DB94
	bmi @lbl_C3DB9C                         ;C3DB96
	pha                                     ;C3DB98
@lbl_C3DB9C:
	lda $01                                 ;C3DB99
	bmi @lbl_C3DBBC                         ;C3DB9B
	sta $00                                 ;C3DB9D
	rep #$20                                ;C3DB9F
	phx                                     ;C3DBA1
	phy                                     ;C3DBA2
	jsl $C306F4                             ;C3DBA3
	ply                                     ;C3DBA7
	plx                                     ;C3DBA8
	lda $06                                 ;C3DBA9
	sta $00                                 ;C3DBAB
	sep #$20                                ;C3DBAD
	lda #$80                                ;C3DBAF
	sta $02                                 ;C3DBB1
	phx                                     ;C3DBB3
	jsl $C35BA2                             ;C3DBB4
	plx                                     ;C3DBB8
@lbl_C3DBBC:
	dex                                     ;C3DBB9
	dex                                     ;C3DBBA
	bpl @lbl_C3DB83                         ;C3DBBB
	bra @lbl_C3DC23                         ;C3DBBD
@lbl_C3DBC2:
	sta $00                                 ;C3DBBF
	jsl $C24373                             ;C3DBC1
	lda $00                                 ;C3DBC5
	beq @lbl_C3DBD5                         ;C3DBC7
	lda $01,s                               ;C3DBC9
	sta $00                                 ;C3DBCB
	jsr $DCFF                               ;C3DBCD
	bra @lbl_C3DC22                         ;C3DBD0
@lbl_C3DBD5:
	lda $01,s                               ;C3DBD2
	sta $00                                 ;C3DBD4
	jsl $C210AC                             ;C3DBD6
	ldx $00                                 ;C3DBDA
	lda $03                                 ;C3DBDC
	cmp #$00                                ;C3DBDE
	bne @lbl_C3DBEA                         ;C3DBE0
	jsr $DD27                               ;C3DBE2
	bra @lbl_C3DC22                         ;C3DBE5
@lbl_C3DBEA:
	cmp #$08                                ;C3DBE7
	bne @lbl_C3DBF7                         ;C3DBE9
	lda $01,s                               ;C3DBEB
	sta $00                                 ;C3DBED
	jsr $DD85                               ;C3DBEF
	bra @lbl_C3DC22                         ;C3DBF2
@lbl_C3DBF7:
	cmp #$1A                                ;C3DBF4
	bne @lbl_C3DC04                         ;C3DBF6
	lda $01,s                               ;C3DBF8
	sta $00                                 ;C3DBFA
	jsr $DD8A                               ;C3DBFC
	bra @lbl_C3DC22                         ;C3DBFF
@lbl_C3DC04:
	lda $01,s                               ;C3DC01
	sta $00                                 ;C3DC03
	phx                                     ;C3DC05
	jsl ShowDamageEffect                             ;C3DC06
	plx                                     ;C3DC0A
	lda $01,s                               ;C3DC0B
	sta $00                                 ;C3DC0D
	phx                                     ;C3DC0F
	jsl HandleCharacterDeath                             ;C3DC10
	plx                                     ;C3DC14
	stx $00                                 ;C3DC15
	lda #$80                                ;C3DC17
	sta $02                                 ;C3DC19
	jsl $C35B7A                             ;C3DC1B
@lbl_C3DC22:
	pla                                     ;C3DC1F
@lbl_C3DC23:
	lda $01,s                               ;C3DC20
	bpl @lbl_C3DBC2                         ;C3DC22
	pla                                     ;C3DC24
	rts                                     ;C3DC25
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	bra @lbl_C3DC39
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b wTemp00
@lbl_C3DC39:
	pha
	lda.b #$0D
	sta.b wTemp02
	jsl.l func_C626F6
	pla
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	ldy.b wTemp00
	lda.b #$C5
	sta.b wTemp00
	jsl.l func_C23BA6
	lda.b #$FF
	pha
	ldx.w #$0010
@lbl_C3DC59:
	rep #$20 ;A->16
	tya
	clc
	adc.l DATA8_C3DA1C,x
	sta.b wTemp00
	sta.b wTemp06
	phx
	jsl.l func_C359AF
	plx
	sep #$20 ;A->8
	lda.b wTemp00
	bmi @lbl_C3DC72
	pha
@lbl_C3DC72:
	lda.b wTemp01
	bmi @lbl_C3DC92
	sta.b wTemp00
	rep #$20 ;A->16
	phx
	phy
	jsl.l FreeFloorItemSlot
	ply
	plx
	lda.b wTemp06
	sta.b wTemp00
	sep #$20 ;A->8
	lda.b #$80
	sta.b wTemp02
	phx
	jsl.l func_C35BA2
	plx
@lbl_C3DC92:
	dex
	dex
	bpl @lbl_C3DC59
	bra @lbl_C3DCF9
@lbl_C3DC98:
	sta.b wTemp00
	jsl.l func_C24373
	lda.b wTemp00
	beq @lbl_C3DCAB
	lda $01,s                               ;C3DC9F
	sta $00                                 ;C3DCA1
	jsr $DCFF                               ;C3DCA3
	.db $80,$4D   ;C3DCA9
@lbl_C3DCAB:
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	ldx.b wTemp00
	lda.b wTemp03
	cmp.b #$00
	bne @lbl_C3DCC0
	jsr.w func_C3DD57
	bra @lbl_C3DCF8
@lbl_C3DCC0:
	cmp.b #$08
	bne @lbl_C3DCCD
	lda.b wTemp01,s
	sta.b wTemp00
	jsr.w func_C3DD85
	bra @lbl_C3DCF8
@lbl_C3DCCD:
	cmp.b #$1A
	bne @lbl_C3DCDA
	lda $01,s                               ;C3DCD1
	sta $00                                 ;C3DCD3
	jsr $DD8A                               ;C3DCD5
	.db $80,$1E   ;C3DCD8
@lbl_C3DCDA:
	lda.b wTemp01,s
	sta.b wTemp00
	phx
	jsl.l ShowDamageEffect
	plx
	lda.b wTemp01,s
	sta.b wTemp00
	phx
	jsl.l HandleCharacterDeath
	plx
	stx.b wTemp00
	lda.b #$80
	sta.b wTemp02
	jsl.l func_C35B7A
@lbl_C3DCF8:
	pla
@lbl_C3DCF9:
	lda.b wTemp01,s
	bpl @lbl_C3DC98
	pla
	rts
	lda $00                                 ;C3DCFF
	pha                                     ;C3DD01
	jsl.l GetCharacterStats                             ;C3DD02
	lda $00                                 ;C3DD06
	dec a                                   ;C3DD08
	beq @lbl_C3DD17                         ;C3DD09
	sta $02                                 ;C3DD0B
	pla                                     ;C3DD0D
	sta $00                                 ;C3DD0E
	sta $01                                 ;C3DD10
	jsl $C228DF                             ;C3DD12
	rts                                     ;C3DD16
@lbl_C3DD17:
	pla                                     ;C3DD17
	sta $00                                 ;C3DD18
	pha                                     ;C3DD1A
	jsl ShowDamageEffect                             ;C3DD1B
	pla                                     ;C3DD1F
	sta $00                                 ;C3DD20
	jsl HandleCharacterDeath                             ;C3DD22
	rts                                     ;C3DD26
	ldy #$0001                              ;C3DD27
	phy                                     ;C3DD2A
	jsl $C28588                             ;C3DD2B
	ply                                     ;C3DD2F
	lda $00                                 ;C3DD30
	beq @lbl_C3DD35                         ;C3DD32
	dey                                     ;C3DD34
@lbl_C3DD35:
	lda #$13                                ;C3DD35
	sta $00                                 ;C3DD37
	jsl.l GetCharacterStats                             ;C3DD39
	lda $00                                 ;C3DD3D
	lsr a                                   ;C3DD3F
	adc #$00                                ;C3DD40
	cpy #$0001                              ;C3DD42
	bne @lbl_C3DD4A                         ;C3DD45
	lsr a                                   ;C3DD47
	adc #$00                                ;C3DD48
@lbl_C3DD4A:
	sta $02                                 ;C3DD4A
	lda #$13                                ;C3DD4C
	sta $00                                 ;C3DD4E
	sta $01                                 ;C3DD50
	jsl $C228DF                             ;C3DD52
	rts                                     ;C3DD56

func_C3DD57:
	ldy.w #$0001
	phy
	jsl.l func_C28588
	ply
	lda.b wTemp00
	beq @lbl_C3DD65
	dey
@lbl_C3DD65:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStats
	lda.b wTemp00
	dec a
	cpy.w #$0001
	bne @lbl_C3DD78
	lsr a
	adc.b #$00
@lbl_C3DD78:
	sta.b wTemp02
	lda.b #$13
	sta.b wTemp00
	sta.b wTemp01
	jsl.l func_C228DF
	rts

func_C3DD85:
	jsl.l func_C2816C
	rts
	lda $00                                 ;C3DD8A
	pha                                     ;C3DD8C
	phx                                     ;C3DD8D
	jsl.l GetCharacterStats                             ;C3DD8E
	plx                                     ;C3DD92
	lda $05                                 ;C3DD93
	pha                                     ;C3DD95
	lda $02,s                               ;C3DD96
	sta $00                                 ;C3DD98
	phx                                     ;C3DD9A
	jsl ShowDamageEffect                             ;C3DD9B
	plx                                     ;C3DD9F
	lda $02,s                               ;C3DDA0
	sta $00                                 ;C3DDA2
	phx                                     ;C3DDA4
	jsl HandleCharacterDeath                             ;C3DDA5
	plx                                     ;C3DDA9
	lda #$E0                                ;C3DDAA
	sta $00                                 ;C3DDAC
	lda #$1A                                ;C3DDAE
	sta $01                                 ;C3DDB0
	pla                                     ;C3DDB2
	sta $02                                 ;C3DDB3
	phx                                     ;C3DDB5
	jsl $C30295                             ;C3DDB6
	plx                                     ;C3DDBA
	lda $00                                 ;C3DDBB
	bmi @lbl_C3DDC7                         ;C3DDBD
	stx $00                                 ;C3DDBF
	sta $02                                 ;C3DDC1
	jsl $C35BA2                             ;C3DDC3
@lbl_C3DDC7:
	pla                                     ;C3DDC7
	rts                                     ;C3DDC8
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b #$16
	sta.b wTemp02
	jsl.l PlayVisualEffect
	pla
	sta.b wTemp00
	jsl.l HandleCharacterDeath
	rts
	sep #$30                                ;C3DDDE
	ldx $00                                 ;C3DDE0
	ldy #$01                                ;C3DDE2
	lda #$19                                ;C3DDE4
	sta $02                                 ;C3DDE6
	phx                                     ;C3DDE8
	phy                                     ;C3DDE9
	jsl PlayVisualEffect                             ;C3DDEA
	ply                                     ;C3DDEE
	plx                                     ;C3DDEF
	stx $00                                 ;C3DDF0
	phx                                     ;C3DDF2
	jsl $C210AC                             ;C3DDF3
	plx                                     ;C3DDF7
	lda $03                                 ;C3DDF8
	cmp #$2E                                ;C3DDFA
	beq @lbl_C3DE13                         ;C3DDFC
	cmp #$22                                ;C3DDFE
	beq @lbl_C3DE13                         ;C3DE00
	cmp #$1E                                ;C3DE02
	beq @lbl_C3DE13                         ;C3DE04
	cmp #$2A                                ;C3DE06
	beq @lbl_C3DE13                         ;C3DE08
	cmp #$08                                ;C3DE0A
	beq @lbl_C3DE38                         ;C3DE0C
	cmp #$09                                ;C3DE0E
	beq @lbl_C3DE47                         ;C3DE10
	dey                                     ;C3DE12
@lbl_C3DE13:
	stx $00                                 ;C3DE13
	phx                                     ;C3DE15
	jsl.l GetCharacterStats                             ;C3DE16
	plx                                     ;C3DE1A
	stx $00                                 ;C3DE1B
	lda $06                                 ;C3DE1D
	lsr a                                   ;C3DE1F
	eor #$FF                                ;C3DE20
	inc a                                   ;C3DE22
	sta $01                                 ;C3DE23
	phx                                     ;C3DE25
	phy                                     ;C3DE26
	jsl $C234BF                             ;C3DE27
	ply                                     ;C3DE2B
	plx                                     ;C3DE2C
	cpy #$01                                ;C3DE2D
	bne @lbl_C3DE37                         ;C3DE2F
	stx $00                                 ;C3DE31
	jsl $C240D6                             ;C3DE33
@lbl_C3DE37:
	rts                                     ;C3DE37
@lbl_C3DE38:
	stx $00                                 ;C3DE38
	phx                                     ;C3DE3A
	jsl ShowDamageEffect                             ;C3DE3B
	plx                                     ;C3DE3F
	stx $00                                 ;C3DE40
	jsl HandleCharacterDeath                             ;C3DE42
	rts                                     ;C3DE46
@lbl_C3DE47:
	stx $00                                 ;C3DE47
	lda #$01                                ;C3DE49
	sta $01                                 ;C3DE4B
	jsl ApplyCharacterLevelGains                             ;C3DE4D
	rts                                     ;C3DE51
	sep #$30                                ;C3DE52
	ldx $00                                 ;C3DE54
	lda #$1D                                ;C3DE56
	sta $02                                 ;C3DE58
	phx                                     ;C3DE5A
	jsl PlayVisualEffect                             ;C3DE5B
	plx                                     ;C3DE5F
	stx $00                                 ;C3DE60
	phx                                     ;C3DE62
	jsl $C210AC                             ;C3DE63
	plx                                     ;C3DE67
	lda $03                                 ;C3DE68
	cmp #$27                                ;C3DE6A
	beq @lbl_C3DE7D                         ;C3DE6C
	stx $00                                 ;C3DE6E
	phx                                     ;C3DE70
	jsl ShowDamageEffect                             ;C3DE71
	plx                                     ;C3DE75
	stx $00                                 ;C3DE76
	jsl HandleCharacterDeath                             ;C3DE78
	rts                                     ;C3DE7C
@lbl_C3DE7D:
	stx $00                                 ;C3DE7D
	lda #$01                                ;C3DE7F
	sta $01                                 ;C3DE81
	jsl ApplyCharacterLevelGains                             ;C3DE83
	rts                                     ;C3DE87
	sep #$20                                ;C3DE88
	rep #$10                                ;C3DE8A
	lda $00                                 ;C3DE8C
	pha                                     ;C3DE8E
	jsl $C210AC                             ;C3DE8F
	ldx $00                                 ;C3DE93
	pla                                     ;C3DE95
	sta $00                                 ;C3DE96
	phx                                     ;C3DE98
	jsl $C3694D                             ;C3DE99
	plx                                     ;C3DE9D
	stx $00                                 ;C3DE9E
	lda #$80                                ;C3DEA0
	sta $02                                 ;C3DEA2
	jsl $C35BA2                             ;C3DEA4
	rts                                     ;C3DEA8
	sep #$20                                ;C3DEA9
	rep #$10                                ;C3DEAB
	lda $00                                 ;C3DEAD
	pha                                     ;C3DEAF
	lda #$22                                ;C3DEB0
	sta $02                                 ;C3DEB2
	lda $00                                 ;C3DEB4
	pha                                     ;C3DEB6
	jsl PlayVisualEffect                             ;C3DEB7
	pla                                     ;C3DEBB
	sta $00                                 ;C3DEBC
	jsl $C28305                             ;C3DEBE
	ldx #$0138                              ;C3DEC2
	stx $00                                 ;C3DEC5
	pla                                     ;C3DEC7
	sta $02                                 ;C3DEC8
	jsl.l DisplayMessage
	rts                                     ;C3DECE
	sep #$20                                ;C3DECF
	rep #$10                                ;C3DED1
	lda $00                                 ;C3DED3
	pha                                     ;C3DED5
	lda #$1F                                ;C3DED6
	sta $02                                 ;C3DED8
	jsl PlayVisualEffect                             ;C3DEDA
	lda $01,s                               ;C3DEDE
	sta $00                                 ;C3DEE0
	jsl $C210AC                             ;C3DEE2
	ldx $00                                 ;C3DEE6
	lda $01,s                               ;C3DEE8
	sta $00                                 ;C3DEEA
	phx                                     ;C3DEEC
	jsl ShowDamageEffect                             ;C3DEED
	plx                                     ;C3DEF1
	lda #$B0                                ;C3DEF2
	sta $00                                 ;C3DEF4
	phx                                     ;C3DEF6
	jsl $C3035D                             ;C3DEF7
	plx                                     ;C3DEFB
	lda $00                                 ;C3DEFC
	bmi @lbl_C3DF06                         ;C3DEFE
	stx $02                                 ;C3DF00
	jsl $C330D1                             ;C3DF02
@lbl_C3DF06:
	pla                                     ;C3DF06
	sta $00                                 ;C3DF07
	jsl HandleCharacterDeath                             ;C3DF09
	rts                                     ;C3DF0D
	sep #$20                                ;C3DF0E
	lda #$13                                ;C3DF10
	sta $01                                 ;C3DF12
	lda #$1E                                ;C3DF14
	sta $02                                 ;C3DF16
	jsl $C228EF                             ;C3DF18
	rts                                     ;C3DF1C
	sep #$20                                ;C3DF1D
	lda $00                                 ;C3DF1F
	pha                                     ;C3DF21
	lda #$15                                ;C3DF22
	sta $02                                 ;C3DF24
	jsl PlayVisualEffect                             ;C3DF26
	pla                                     ;C3DF2A
	sta $00                                 ;C3DF2B
	lda #$13                                ;C3DF2D
	sta $01                                 ;C3DF2F
	lda #$01                                ;C3DF31
	sta $02                                 ;C3DF33
	jsl $C228DF                             ;C3DF35
	rts                                     ;C3DF39
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b #$18
	sta.b wTemp02
	jsl.l PlayVisualEffect
	pla
	sta.b wTemp00
	jsl.l func_C27EB7
	rts
	sep #$20                                ;C3DF4F
	lda $00                                 ;C3DF51
	pha                                     ;C3DF53
	lda #$13                                ;C3DF54
	sta $02                                 ;C3DF56
	jsl PlayVisualEffect                             ;C3DF58
	lda $01,s                               ;C3DF5C
	sta $00                                 ;C3DF5E
	jsl $C210AC                             ;C3DF60
	lda $04                                 ;C3DF64
	cmp #$08                                ;C3DF66
	beq @lbl_C3DF7A                         ;C3DF68
	pla                                     ;C3DF6A
	sta $00                                 ;C3DF6B
	lda #$13                                ;C3DF6D
	sta $01                                 ;C3DF6F
	lda #$1E                                ;C3DF71
	sta $02                                 ;C3DF73
	jsl $C228EF                             ;C3DF75
	rts                                     ;C3DF79
@lbl_C3DF7A:
	pla                                     ;C3DF7A
	sta $00                                 ;C3DF7B
	jsl $C210D4                             ;C3DF7D
	lda #$7F                                ;C3DF81
	sta $00                                 ;C3DF83
	lda #$04                                ;C3DF85
	sta $01                                 ;C3DF87
	lda #$46                                ;C3DF89
	sta $02                                 ;C3DF8B
	lda $04                                 ;C3DF8D
	sta $06                                 ;C3DF8F
	lda $05                                 ;C3DF91
	sta $07                                 ;C3DF93
	jsl $C626CA                             ;C3DF95
	rts                                     ;C3DF99
	sep #$20                                ;C3DF9A
	lda $00                                 ;C3DF9C
	pha                                     ;C3DF9E
	lda #$05                                ;C3DF9F
	sta $01                                 ;C3DFA1
	jsl $C24080                             ;C3DFA3
	lda $01,s                               ;C3DFA7
	sta $00                                 ;C3DFA9
	lda #$1A                                ;C3DFAB
	sta $02                                 ;C3DFAD
	jsl PlayVisualEffect                             ;C3DFAF
	pla                                     ;C3DFB3
	sta $02                                 ;C3DFB4
	lda #$ED                                ;C3DFB6
	sta $00                                 ;C3DFB8
	stz $01                                 ;C3DFBA
	jsl.l DisplayMessage
	rts                                     ;C3DFC0
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b #$0F
	sta.b wTemp02
	jsl.l func_C626F6
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b #$23
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$05
	sta.b wTemp00
	lda.b #$09
	sta.b wTemp01
	jsl.l GetRandomInRange
	lda.b wTemp00
	sta.b wTemp02
	pla
	sta.b wTemp00
	lda.b #$13
	sta.b wTemp01
	jsl.l func_C228DF
	rts
	sep #$20                                ;C3DFF6
	lda $00                                 ;C3DFF8
	pha                                     ;C3DFFA
	lda #$10                                ;C3DFFB
	sta $02                                 ;C3DFFD
	jsl $C626F6                             ;C3DFFF
	pla                                     ;C3E003
	sta $00                                 ;C3E004
	jsl $C24390                             ;C3E006
	rts                                     ;C3E00A
	sep #$20                                ;C3E00B
	lda $00                                 ;C3E00D
	pha                                     ;C3E00F
	lda #$0A                                ;C3E010
	sta $01                                 ;C3E012
	jsl $C23FFF                             ;C3E014
	lda #$EB                                ;C3E018
	sta $00                                 ;C3E01A
	stz $01                                 ;C3E01C
	lda $01,s                               ;C3E01E
	sta $02                                 ;C3E020
	jsl.l DisplayMessage
	pla                                     ;C3E026
	sta $00                                 ;C3E027
	lda #$1B                                ;C3E029
	sta $02                                 ;C3E02B
	jsl PlayVisualEffect                             ;C3E02D
	rts                                     ;C3E031
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	lda.b #$0A
	sta.b wTemp01
	jsl.l func_C24073
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b #$1C
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.b #$35
	sta.b wTemp00
	stz.b wTemp01
	pla
	sta.b wTemp02
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	lda.b wTemp00
	pha
	sta.b wTemp02
	lda.b #$E5
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b #$21
	sta.b wTemp02
	jsl.l PlayVisualEffect
	pla
	sta.b wTemp00
	jsl.l func_C240D6
	rts

func_C3E07E:
	php
	rep #$20 ;A->16
	lda.l $7EC196
	sta.b wTemp00
	lda.l $7EC198
	sta.b wTemp02
	sep #$20 ;A->8
	lda.l $7EC19A
	sta.b wTemp04
	plp
	rtl

func_C3E097:
	php
	rep #$20 ;A->16
	lda.l $7EC19B
	sta.b wTemp00
	lda.l $7EC19D
	sta.b wTemp02
	lda.l $7EC19F
	sta.b wTemp04
	plp
	rtl
	rep #$20                                ;C3E0AE
	lda #$0013                              ;C3E0B0
	sta $00                                 ;C3E0B3
	lda #$00CF                              ;C3E0B5
	sta $02                                 ;C3E0B8
	jsl PlayVisualEffect                             ;C3E0BA
	lda #$0105                              ;C3E0BE
	sta $00                                 ;C3E0C1
	jsl.l DisplayMessage
	jsl $C28472                             ;C3E0C7
	rts                                     ;C3E0CB
	rts                                     ;C3E0CC

func_C3E0CD:
	sep #$30 ;AXY->8
	jsl.l func_C3E178
	lda.b wTemp00
	beq @lbl_C3E0DC
	bmi @lbl_C3E0DC
	brl func_C3E104
@lbl_C3E0DC:
	jsl.l func_C3E768
	lda.b wTemp00
	cmp.b #$FF
	bne @lbl_C3E100
	lda.b #$FF
	sta.b wTemp00
	stz.b wTemp01
	jsl.l func_809650
	jsl.l func_C4854E
	jsl.l func_C495B2
	jsl.l func_C48584
	jsl.l func_C4014D
@lbl_C3E100:
	jsl.l func_C3E11A

func_C3E104:
	lda.b #$01
	sta.b wTemp00
	jsl.l func_C60003
	jsl.l func_C62D0F
	rep #$30 ;AXY->16
	sep #$20 ;A->8
	stz.b wTemp00
	jsl.l func_81CFE0

func_C3E11A:
	php
	rep #$20 ;A->16
	jsl.l func_C3E7DA
	inc.b wTemp00
	bne @lbl_C3E12A
;C3E125
	.db $A9,$FF,$FF,$85,$00
@lbl_C3E12A:
	jsl.l func_C3E7E6
	plp
	rtl

func_C3E130:
	rtl

func_C3E131:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	lda.l DATA8_C3E14F,x
	sta.b w00ae
	lda.l DATA8_C3E150,x
	sta.b w00af
	lda.l DemoTable,x
	sta.b w00b0
	plp
	rtl

DATA8_C3E14F:
	.db $00

DATA8_C3E150:
	.db $60

;c3e151
DemoTable:
	bcs @lbl_C3E153                         ;C3E151
@lbl_C3E153:
	rts                                     ;C3E153
	lda ($00),y                             ;C3E154
	rts                                     ;C3E156
	.db $B2   ;C3E157
	.dl Demo1
	.dl Demo2
	.dl Demo3
	.dl Demo4
	.dl Demo5
	.dl Demo6

func_C3E16A:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$0001
	lda.b wTemp00
	sta.b [$AE],y
	plp
	rtl

func_C3E178:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$0001
	lda.b [$AE],y
	cmp.b #$01
	beq @lbl_C3E197
	cmp.b #$00
	beq @lbl_C3E197
@lbl_C3E18A:
	sep #$20 ;A->8
	ldy.w #$0001
	lda.b #$FF
	sta.b [$AE],y
	sta.b wTemp00
	plp
	rtl
@lbl_C3E197:
	rep #$20 ;A->16
	ldy.w #$0002
	lda.b [$AE],y
	cmp.w #$1374
	bcs @lbl_C3E18A
	sta.b wTemp00
	tay
	sep #$20 ;A->8
	lda.b [$AE],y
	cmp.b #$FF
	bne @lbl_C3E18A
	ldy.w #$0004
	lda.b [$AE]
@lbl_C3E1B3:
	eor.b [$AE],y
	iny
	cpy.b wTemp00
	bcc @lbl_C3E1B3
	cmp.b #$00
	bne @lbl_C3E18A
	ldy.w #$0001
	lda.b [$AE],y
	sta.b wTemp00
	plp
	rtl

func_C3E1C7:
	php
	rep #$20 ;A->16
	lda.w #$0004
	sta.b w00ac
	sep #$20 ;A->8
	stz.b w00b1
	plp
	rtl

func_C3E1D5:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b w00ac
	cpy.w #$12D4
	bcc @lbl_C3E203
	cpy #$1374                              ;C3E1E1
	bcc @lbl_C3E1F0                         ;C3E1E4
	lda #$03                                ;C3E1E6
	sta $00                                 ;C3E1E8
	jsl $C6287D                             ;C3E1EA
	plp                                     ;C3E1EE
	rtl                                     ;C3E1EF
@lbl_C3E1F0:
	lda #$01                                ;C3E1F0
	cpy #$1324                              ;C3E1F2
	bcc @lbl_C3E1F9                         ;C3E1F5
	lda #$02                                ;C3E1F7
@lbl_C3E1F9:
	ldx $00                                 ;C3E1F9
	sta $00                                 ;C3E1FB
	jsl $C6287D                             ;C3E1FD
	stx $00                                 ;C3E201
@lbl_C3E203:
	lda.b wTemp00
	cmp.b #$1C
	beq @lbl_C3E232
	stz.b w00b1
	cmp.b #$A0
	bcc @lbl_C3E229
	ldx.w #$0001
	cmp.b #$C0
	bcc @lbl_C3E220
	.db $97,$AE,$47,$AE,$87,$AE,$C8,$A5   ;C3E216  
	.db $01,$E8                           ;C3E21E  
@lbl_C3E220:
	sta.b [$AE],y
	eor.b [$AE]
	sta.b [$AE]
	iny
	lda.b wTemp00,x
@lbl_C3E229:
	sta.b [$AE],y
	eor.b [$AE]
	sta.b [$AE]
	iny
	bra @lbl_C3E258
@lbl_C3E232:
	lda $B1                                 ;C3E232
	beq @lbl_C3E244                         ;C3E234
	inc a                                   ;C3E236
	dey                                     ;C3E237
	sta [$AE],y                             ;C3E238
	eor $B1                                 ;C3E23A
	eor [$AE]                               ;C3E23C
	sta [$AE]                               ;C3E23E
	inc $B1                                 ;C3E240
	.db $80,$22   ;C3E242
@lbl_C3E244:
	lda #$1C                                ;C3E244
	sta [$AE],y                             ;C3E246
	eor [$AE]                               ;C3E248
	sta [$AE]                               ;C3E24A
	iny                                     ;C3E24C
	lda #$01                                ;C3E24D
	sta $B1                                 ;C3E24F
	sta [$AE],y                             ;C3E251
	eor [$AE]                               ;C3E253
	sta [$AE]                               ;C3E255
	iny                                     ;C3E257
@lbl_C3E258:
	lda.b #$FF
	sta.b [$AE],y
	sty.b w00ac
	rep #$20 ;A->16
	tya
	ldy.w #$0002
	sta.b [$AE],y
	jsl.l func_C28FF5
	plp
	rtl

func_C3E26C:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b w00b1
	bne @lbl_C3E2A3
	ldy.b w00ac
	lda.b [$AE],y
	sta.b wTemp00
	cmp.b #$FF
	beq @lbl_C3E29A
	iny
	cmp.b #$1C
	beq @lbl_C3E29C
	cmp.b #$A0
	bcc @lbl_C3E298
	lda.b [$AE],y
	sta.b wTemp01
	iny
	lda.b wTemp00
	cmp.b #$C0
	bcc @lbl_C3E298
;C3E293  
	.db $B7,$AE,$85,$02,$C8
@lbl_C3E298:
	sty.b w00ac
@lbl_C3E29A:
	plp
	rtl
@lbl_C3E29C:
	lda.b [$AE],y
	iny
	sty.b w00ac
	sta.b w00b1
@lbl_C3E2A3:
	dec.b w00b1
	lda.b #$1C
	sta.b wTemp00
	plp
	rtl

func_C3E2AB:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b w00ac
	cpy.w #$1374
	bcs @lbl_C3E2D9
	ldx.w #$0000
@lbl_C3E2BA:
	phy
	txy
	lda.b [wTemp02],y
	ply
	sta.b [$AE],y
	eor.b [$AE]
	sta.b [$AE]
	inx
	iny
	cpx.b wTemp00
	bcc @lbl_C3E2BA
	lda.b #$FF
	sta.b [$AE],y
	sty.b w00ac
	rep #$20 ;A->16
	tya
	ldy.w #$0002
	sta.b [$AE],y
@lbl_C3E2D9:
	plp
	rtl

func_C3E2DB:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b w00ac
	ldx.w #$0000
@lbl_C3E2E5:
	lda.b [$AE],y
	phy
	txy
	sta.b [wTemp02],y
	tyx
	ply
	inx
	iny
	cpx.b wTemp00
	bne @lbl_C3E2E5
	sty.b w00ac
	plp
	rtl

func_C3E2F7:
	php
	sep #$30 ;AXY->8
	lda.b wTemp01
	asl a
	clc
	adc.b wTemp01
	tax
	lda.l DATA8_C3E14F,x
	sta.b wTemp04
	lda.l DATA8_C3E150,x
	sta.b wTemp05
	lda.l DemoTable,x
	sta.b wTemp06
	lda.b wTemp00
	asl a
	clc
	adc.b wTemp00
	tax
	lda.l DATA8_C3E14F,x
	sta.b wTemp00
	lda.l DATA8_C3E150,x
	sta.b wTemp01
	lda.l DemoTable,x
	sta.b wTemp02
	rep #$10 ;XY->16
	ldy.w #$1387
@lbl_C3E331:
	lda.b [wTemp00],y
	sta.b [wTemp04],y
	dey
	bpl @lbl_C3E331
	ldy.w #$0001
	lda.b [wTemp00],y
	bmi @lbl_C3E349
	lda.l debugMode
	beq @lbl_C3E349
	lda.b #$00
	sta.b [wTemp04],y
@lbl_C3E349:
	plp
	rtl

func_C3E34B:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b w00ac
	dey
	lda.b [$AE],y
	eor.b [$AE]
	sta.b [$AE]
	lda.b #$FF
	sta.b [$AE],y
	sty.b w00ac
	rep #$20 ;A->16
	tya
	ldy.w #$0002
	sta.b [$AE],y
	plp
	rtl

func_C3E369:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$00
	sta.b [$AE]
	ldy.w #$0002
	rep #$20 ;A->16
	lda.w #$0004
	sta.b [$AE],y
	tay
	sep #$20 ;A->8
	lda.b #$00
	sta.b [$AE],y
	plp
	rtl

func_C3E385:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b w00ac
	cpy.w #$1374
	bcs @lbl_C3E3A6
	sta.b [$AE],y
	eor.b [$AE]
	sta.b [$AE]
	iny
	lda.b #$FF
	sta.b [$AE],y
	sty.b w00ac
	rep #$20 ;A->16
	tya
	ldy.w #$0002
	sta.b [$AE],y
@lbl_C3E3A6:
	plp
	rtl

func_C3E3A8:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.b w00ac
	lda.b [$AE],y
	sta.b wTemp00
	cmp.b #$FF
	beq @lbl_C3E3BA
	iny
	sty.b w00ac
@lbl_C3E3BA:
	plp
	rtl

func_C3E3BC:
	php
	rep #$30 ;AXY->16
	ldy.w #$0002
	lda.b [$AE],y
	sec
	sbc.b w00ac
	sta.b wTemp00
	plp
	rtl

MultiplyPackedBytesToWord:
	php
	sep #$20 ;A->8
	lda.b wTemp01
	eor.b #$FF
	xba
	lda.b #$00
	sta.b wTemp01
	rep #$20 ;A->16
	asl a
	bcs @lbl_C3E3DE
	adc.b wTemp00
@lbl_C3E3DE:
	asl a
	bcs @lbl_C3E3E3
	adc.b wTemp00
@lbl_C3E3E3:
	asl a
	bcs @lbl_C3E3E8
	adc.b wTemp00
@lbl_C3E3E8:
	asl a
	bcs @lbl_C3E3ED
	adc.b wTemp00
@lbl_C3E3ED:
	asl a
	bcs @lbl_C3E3F2
	adc.b wTemp00
@lbl_C3E3F2:
	asl a
	bcs @lbl_C3E3F7
	adc.b wTemp00
@lbl_C3E3F7:
	asl a
	bcs @lbl_C3E3FC
	adc.b wTemp00
@lbl_C3E3FC:
	asl a
	bcs @lbl_C3E401
	adc.b wTemp00
@lbl_C3E401:
	sta.b wTemp00
	plp
	rtl

func_C3E405:
	php
	rep #$20 ;A->16
	lda.b wTemp02
	eor.w #$FFFF
	sta.b wTemp02
	lda.w #$0000
	asl.b wTemp02
	bcs @lbl_C3E418
	lda.b wTemp00
@lbl_C3E418:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E423
	adc.b wTemp00
	bcc @lbl_C3E423
	inc.b wTemp02
@lbl_C3E423:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E42E
	adc.b wTemp00
	bcc @lbl_C3E42E
	inc.b wTemp02
@lbl_C3E42E:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E439
	adc.b wTemp00
	bcc @lbl_C3E439
	inc.b wTemp02
@lbl_C3E439:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E444
	adc.b wTemp00
	bcc @lbl_C3E444
	inc.b wTemp02
@lbl_C3E444:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E44F
	adc.b wTemp00
	bcc @lbl_C3E44F
	inc.b wTemp02
@lbl_C3E44F:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E45A
	adc.b wTemp00
	bcc @lbl_C3E45A
	inc.b wTemp02
@lbl_C3E45A:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E465
	adc.b wTemp00
	bcc @lbl_C3E465
	inc.b wTemp02
@lbl_C3E465:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E470
	adc.b wTemp00
	bcc @lbl_C3E470
	inc.b wTemp02
@lbl_C3E470:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E47B
	adc.b wTemp00
	bcc @lbl_C3E47B
	inc.b wTemp02
@lbl_C3E47B:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E486
	adc.b wTemp00
	bcc @lbl_C3E486
	inc.b wTemp02
@lbl_C3E486:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E491
	adc.b wTemp00
	bcc @lbl_C3E491
	inc.b wTemp02
@lbl_C3E491:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E49C
	adc.b wTemp00
	bcc @lbl_C3E49C
	inc.b wTemp02
@lbl_C3E49C:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E4A7
	adc.b wTemp00
	bcc @lbl_C3E4A7
	inc.b wTemp02
@lbl_C3E4A7:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E4B2
	adc.b wTemp00
	bcc @lbl_C3E4B2
	inc.b wTemp02
@lbl_C3E4B2:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E4BD
	adc.b wTemp00
	bcc @lbl_C3E4BD
	inc.b wTemp02
@lbl_C3E4BD:
	sta.b wTemp00
	plp
	rtl

func_C3E4C1:
	php
	sep #$20 ;A->8
	lda.b wTemp02
	eor.b #$FF
	sta.b wTemp03
	rep #$20 ;A->16
	lda.w #$0000
	asl.b wTemp02
	bcs @lbl_C3E4D5
	lda.b wTemp00
@lbl_C3E4D5:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E4E0
	adc.b wTemp00
	bcc @lbl_C3E4E0
	inc.b wTemp02
@lbl_C3E4E0:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E4EB
	adc.b wTemp00
	bcc @lbl_C3E4EB
	inc.b wTemp02
@lbl_C3E4EB:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E4F6
	adc.b wTemp00
	bcc @lbl_C3E4F6
	inc.b wTemp02
@lbl_C3E4F6:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E501
	adc.b wTemp00
	bcc @lbl_C3E501
	inc.b wTemp02
@lbl_C3E501:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E50C
	adc.b wTemp00
	bcc @lbl_C3E50C
	inc.b wTemp02
@lbl_C3E50C:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E517
	adc.b wTemp00
	bcc @lbl_C3E517
	inc.b wTemp02
@lbl_C3E517:
	asl a
	rol.b wTemp02
	bcs @lbl_C3E522
	adc.b wTemp00
	bcc @lbl_C3E522
	inc.b wTemp02
@lbl_C3E522:
	sta.b wTemp00
	plp
	rtl

; 16-bit unsigned division using shift-and-subtract algorithm.
; Input: wTemp00 = dividend, wTemp02 = divisor
; Output: wTemp00 = quotient, wTemp01 = remainder
Divide16Bit:
	php
	sep #$20 ;A->8
	lda.b wTemp02
	xba
	lda.b #$00
	rep #$20 ;A->16
	lsr a
	sta.b wTemp02
	lda.b wTemp00
	cmp.b wTemp02
	bcc @lbl_C3E53B
	sbc.b wTemp02
@lbl_C3E53B:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E542
	sbc.b wTemp02
@lbl_C3E542:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E549
	sbc.b wTemp02
@lbl_C3E549:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E550
	sbc.b wTemp02
@lbl_C3E550:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E557
	sbc.b wTemp02
@lbl_C3E557:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E55E
	sbc.b wTemp02
@lbl_C3E55E:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E565
	sbc.b wTemp02
@lbl_C3E565:
	rol a
	cmp.b wTemp02
	bcc @lbl_C3E56C
	sbc.b wTemp02
@lbl_C3E56C:
	rol a
	sta.b wTemp00
	plp
	rtl

func_C3E571:
	php
	sep #$20 ;A->8
	lda.b wTemp00
	cmp.b #$03
	bcs @lbl_C3E5A4
	pha
	rep #$20 ;A->16
	lda.w #$0000
	sta.b wTemp00
	jsl.l GetJoypadState
	lda.b wTemp00
	bit.w #$0020
	sep #$20 ;A->8
	beq @lbl_C3E596
;C3E58F
	.db $68,$18,$69,$03,$48,$80,$0B
@lbl_C3E596:
	lda.b wTemp00
	bit.b #$10
	beq @lbl_C3E5A1
;C3E59C
	.db $68,$18,$69,$06,$48
@lbl_C3E5A1:
	pla
	bra @lbl_C3E5A4
@lbl_C3E5A4:
	cmp.b #$03
	tay
	bcc @lbl_C3E5AB
	lda.b #$00
@lbl_C3E5AB:
	sta.b wTemp00
	phy
	jsl.l func_C3E66B
	ply
	sty.b wTemp00
	jsl.l func_C3E131
	jsl.l func_C60037
	lda.b wTemp00
	cmp.b #$FF
	beq @lbl_C3E5C7
	stz.b wTemp00
	plp
	rtl
@lbl_C3E5C7:
	lda.b #$01
	sta.b wTemp00
	plp
	rtl

func_C3E5CD:
	php
	sep #$20 ;A->8
	lda.b w00b4
	pha
	plb
	rep #$30 ;AXY->16
	ldy.b w00b2
	ldx.w #$0000
	sep #$20 ;A->8
@lbl_C3E5DD:
	lda.l DATA8_C3E5EC,x
	beq @lbl_C3E5EA
	sta.w wTemp01,y
	inx
	iny
	bra @lbl_C3E5DD
@lbl_C3E5EA:
	plp
	rtl

DATA8_C3E5EC:
	.db $56,$41,$4C,$49,$44,$00

func_C3E5F2:
	php
	jsl.l func_C3E66B
	sep #$20 ;A->8
	lda.b w00b4
	pha
	plb
	rep #$30 ;AXY->16
	ldy.b w00b2
	ldx.w #$0000
	sep #$20 ;A->8
@lbl_C3E606:
	lda.l DATA8_C3E5EC,x
	beq @lbl_C3E615
	cmp.w wTemp01,y
	bne @lbl_C3E625
	inx
	iny
	bra @lbl_C3E606
@lbl_C3E615:
	jsl.l func_C3E768
	lda.b wTemp00
	cmp.b #$FF
	beq @lbl_C3E625
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
@lbl_C3E625:
	stz.b wTemp00
	plp
	rtl

func_C3E629:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	jsl.l func_C3E5F2
	pla
	ldy.b wTemp00
	bne @lbl_C3E642
	sta.b wTemp00
	jsl.l func_C3E706
	stz.b wTemp00
	plp
	rtl
@lbl_C3E642:
	sta.b wTemp00
	jsl.l func_C3E66B
	rep #$10 ;XY->16
	ldy.w #$0367
	lda.b #$00
@lbl_C3E64F:
	eor.b [$B2],y
	dey
	bpl @lbl_C3E64F
	sta.b wTemp00
	plp
	rtl

func_C3E658:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$0367
	lda.b #$00
@lbl_C3E662:
	eor.b [$B2],y
	dey
	bne @lbl_C3E662
	sta.b [$B2]
	plp
	rtl

func_C3E66B:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	sta.b w00b5
	jsl.l func_C3E131
	lda.b w00b5
	asl a
	clc
	adc.b w00b5
	tax
	rep #$20 ;A->16
	lda.l DATA8_C3E68F,x
	sta.b w00b2
	sep #$20 ;A->8
	lda.l DATA8_C3E691,x
	sta.b w00b4
	plp
	rtl

DATA8_C3E68F:
	.db $58,$7B                           ;C3E68F

DATA8_C3E691:
	.db $B0,$58,$7B,$B1,$58,$7B,$B2       ;C3E691

func_C3E698:
	php
	lda.b w00b5
	sta.b wTemp00
	plp
	rtl

func_C3E69F:
	sep #$30 ;AXY->8
	lda.b wTemp00
	jsl.l func_C3E66B
	jsl.l func_C3E0CD

func_C3E6AB:
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	jsl.l func_C3E66B
	pla
	sta.b wTemp00
	jsl.l func_C3E1C7
	lda.b #$FF
	sta.b wTemp00
	jsl.l func_C3E16A
	jsl.l func_C3E6D3
	jsl.l func_C3E5CD
	jsl.l func_C3E658
	jsl.l func_C3E0CD

func_C3E6D3:
	php
	sep #$20 ;A->8
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	sta.b wTemp02
	sta.b wTemp03
	jsl.l func_C3E77A
	stz.b wTemp00
	stz.b wTemp01
	jsl.l func_C3E7E6
	lda.b #$17
	sta.b wTemp00
	stz.b wTemp02
	jsl.l func_C3E826
	stz.b wTemp00
	jsl.l func_C3E7D1
	lda.b #$01
	sta.b wTemp00
	jsl.l func_C3E80B
	plp
	rtl

func_C3E706:
	php
	jsl.l func_C3E66B
	sep #$20 ;A->8
	lda.b w00b4
	pha
	plb
	rep #$30 ;AXY->16
	ldy.b w00b2
	ldx.w #$0000
	sep #$20 ;A->8
@lbl_C3E71A:
	lda.l DATA8_C3E5EC,x
	beq @lbl_C3E729
	lda.b #$00
	sta.w wTemp01,y
	inx
	iny
	bra @lbl_C3E71A
@lbl_C3E729:
	plp
	rtl

func_C3E72B:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	jsl.l func_C3E2F7
	pla
	sta.b wTemp00
	ldx.b wTemp01
	ldy.b wTemp00
	stx.b wTemp00
	phy
	jsl.l func_C3E66B
	ply
	lda.b w00b2
	ldx.b w00b4
	sty.b wTemp00
	pha
	phx
	jsl.l func_C3E66B
	plx
	pla
	sta.b wTemp04
	stx.b wTemp06
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$0367
@lbl_C3E75F:
	lda.b [$B2],y
	sta.b [wTemp04],y
	dey
	bpl @lbl_C3E75F
	plp
	rtl

func_C3E768:
	php
	rep #$30 ;AXY->16
	ldy.w #$0006
	lda.b [$B2],y
	sta.b wTemp00
	iny
	iny
	lda.b [$B2],y
	sta.b wTemp02
	plp
	rtl

func_C3E77A:
	php
	rep #$30 ;AXY->16
	ldy.w #$0006
	lda.b wTemp00
	eor.b [$B2],y
	sta.b wTemp04
	lda.b wTemp00
	sta.b [$B2],y
	iny
	iny
	lda.b wTemp02
	eor.b [$B2],y
	eor.b wTemp04
	sta.b wTemp04
	lda.b wTemp02
	sta.b [$B2],y
	sep #$20 ;A->8
	lda.b wTemp04
	eor.b wTemp05
	eor.b [$B2]
	sta.b [$B2]
	plp
	rtl

func_C3E7A4:
	php
	rep #$10 ;XY->16
	ldy.w #$000D

func_C3E7AA:
	sep #$20 ;A->8
	lda.b [$B2],y
	sta.b wTemp00
	plp
	rtl
	.db $08,$C2,$10,$A0,$0D,$00           ;C3E7B2

func_C3E7B8:
	sep #$20 ;A->8
	lda.b wTemp00
	eor.b [$B2],y
	eor.b [$B2]
	sta.b [$B2]
	lda.b wTemp00
	sta.b [$B2],y
	plp
	rtl

func_C3E7C8:
	php
	rep #$10 ;XY->16
	ldy.w #$000C
	jmp.w func_C3E7AA

func_C3E7D1:
	php
	rep #$10 ;XY->16
	ldy.w #$000C
	jmp.w func_C3E7B8

func_C3E7DA:
	php
	rep #$30 ;AXY->16
	ldy.w #$000A
	lda.b [$B2],y
	sta.b wTemp00
	plp
	rtl

func_C3E7E6:
	php
	rep #$30 ;AXY->16
	ldy.w #$000A
	lda.b [$B2],y
	eor.b wTemp00
	sta.b wTemp02
	lda.b wTemp00
	sta.b [$B2],y
	sep #$20 ;A->8
	lda.b wTemp02
	eor.b wTemp03
	eor.b [$B2]
	sta.b [$B2]
	plp
	rtl

func_C3E802:
	php
	rep #$10 ;XY->16
	ldy.w #$000F
	jmp.w func_C3E7AA

func_C3E80B:
	php
	rep #$10 ;XY->16
	ldy.w #$000F
	jmp.w func_C3E7B8

func_C3E814:
	php
	rep #$10 ;XY->16
	ldy.w #$000E
	jmp.w func_C3E7AA

func_C3E81D:
	php
	rep #$10 ;XY->16
	ldy.w #$000E
	jmp.w func_C3E7B8

func_C3E826:
	php
	sep #$20 ;A->8
	lda.b #$00
	xba
	lda.b wTemp00
	rep #$30 ;AXY->16
	clc
	adc.w #$0010
	tay
	sep #$20 ;A->8
	lda.b wTemp02
	eor.b [$B2],y
	eor.b [$B2]
	sta.b [$B2]
	lda.b wTemp02
	sta.b [$B2],y
	plp
	rtl

func_C3E845:
	php
	sep #$20 ;A->8
	lda.b #$00
	xba
	lda.b wTemp00
	rep #$30 ;AXY->16
	clc
	adc.w #$0010
	tay
	sep #$20 ;A->8
	lda.b [$B2],y
	sta.b wTemp00
	plp
	rtl

func_C3E85C:
	php
	sep #$20 ;A->8
	stz.b wTemp07
	rep #$30 ;AXY->16
	lda.b wTemp06
	asl a
	clc
	adc.b wTemp06
	asl a
	clc
	adc.w #$0110
	tay
	lda.b [$B2],y
	sta.b wTemp00
	iny
	iny
	lda.b [$B2],y
	sta.b wTemp02
	iny
	iny
	lda.b [$B2],y
	sta.b wTemp04
	plp
	rtl

func_C3E881:
	php
	sep #$20 ;A->8
	stz.b wTemp07
	rep #$30 ;AXY->16
	lda.b wTemp06
	asl a
	clc
	adc.b wTemp06
	asl a
	clc
	adc.w #$0110
	tay
	lda.b [$B2],y
	eor.b wTemp00
	sta.b wTemp06
	lda.b wTemp00
	sta.b [$B2],y
	iny
	iny
	lda.b [$B2],y
	eor.b wTemp02
	eor.b wTemp06
	sta.b wTemp06
	lda.b wTemp02
	sta.b [$B2],y
	iny
	iny
	lda.b [$B2],y
	eor.b wTemp04
	eor.b wTemp06
	sta.b wTemp06
	lda.b wTemp04
	sta.b [$B2],y
	sep #$20 ;A->8
	lda.b wTemp06
	eor.b wTemp07
	eor.b [$B2]
	sta.b [$B2]
	plp
	rtl

func_C3E8C6:
	rtl

func_C3E8C7:
	php
	rep #$30 ;AXY->16
	lda.w #$0002
	sta.b wTemp00
	jsl.l func_80DD40
	tdc
	sta.l $7F9CE4
	sta.l $7F9CE5
	jsl.l func_C627F1
	stz.b wTemp01
	lda.b wTemp00
	cmp.w #$0000
	bne @lbl_C3E8F5
	lda.w #$0001
	sta.l $7F9CE2
	ldx.w #$0004
	bra @lbl_C3E90B
@lbl_C3E8F5:
	jsl.l func_C3E802
	stz.b wTemp01
	lda.b wTemp00
	sta.l $7F9CE2
	bne @lbl_C3E908
;C3E903
	.db $A2,$06,$00,$80,$03
@lbl_C3E908:
	ldx.w #$0004
@lbl_C3E90B:
	stx.b wTemp00
	jsl.l func_80E5F5
	plp
	rtl

GetLivePlayerActionCommand:
	php
	rep #$30 ;AXY->16
	tdc
	sta.l $7F9CDA
	lda.b wTemp00
	pha
	and.w #$00FF
	sta.l $7F9CD8
	cmp.w #$00FF
	beq @lbl_C3E94A
	cmp.w #$0083
	bne @lbl_C3E93A
	jsl.l func_C3ED51
	lda.b wTemp00
	bmi @lbl_C3E968
	pla
	plp
	rtl
@lbl_C3E93A:
	lda.w #$0000
	sta.l $7F9CD8
	jsl.l func_C3EB97
	bcs @lbl_C3E951
	pla
	plp
	rtl
@lbl_C3E94A:
	lda.w #$0000
	sta.l $7F9CD8
@lbl_C3E951:
	lda.w #$0013
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	jsl.l func_C359AF
	lda.b wTemp01
	and.w #$00FF
	cmp.w #$0083
	bne @lbl_C3E96F
@lbl_C3E968:
	lda.w #$0001
	sta.l $7F9CD8
@lbl_C3E96F:
	sep #$30 ;AXY->8
	ply
	ply
	cpy.b #$FF
	beq @lbl_C3E9B4
	phy                                     ;C3E977
	lda #$13                                ;C3E978
	sta $00                                 ;C3E97A
	jsl $C210AC                             ;C3E97C
	jsl $C359AF                             ;C3E980
	ldx #$1F                                ;C3E984
	ply                                     ;C3E986
	cpy $01                                 ;C3E987
	beq @lbl_C3E9AA                         ;C3E989
	ldx #$FF                                ;C3E98B
@lbl_C3E98D:
	inx                                     ;C3E98D
	stx $00                                 ;C3E98E
	phx                                     ;C3E990
	phy                                     ;C3E991
	jsl $C23B7C                             ;C3E992
	ply                                     ;C3E996
	plx                                     ;C3E997
	lda $00                                 ;C3E998
	.db $30,$18   ;C3E99A
	cpy $00                                 ;C3E99C
	bne @lbl_C3E98D                         ;C3E99E
	stx $00                                 ;C3E9A0
	jsl $C3F0EC                             ;C3E9A2
	.db $B0,$0C   ;C3E9A6
	plp                                     ;C3E9A8
	rtl                                     ;C3E9A9
@lbl_C3E9AA:
	stx $00                                 ;C3E9AA
	jsl $C3F0EC                             ;C3E9AC
	.db $B0,$02   ;C3E9B0
	plp                                     ;C3E9B2
	rtl                                     ;C3E9B3
@lbl_C3E9B4:
	rep #$30 ;AXY->16
	bra @lbl_C3E9BC
@lbl_C3E9B8:
	jsl.l func_C07CC7
@lbl_C3E9BC:
	; Poll controller state and derive the next live player action command.
	jsl.l func_C3F3E7
	ldx.w #$0000
	stx.b wTemp00
	phx
	jsl.l GetJoypadState
	plx
	ldy.b wTemp00
	phy
	stx.b wTemp00
	bit.w #$4040
	beq @lbl_C3E9DB
	jsl.l GetJoypadPressed
	bra @lbl_C3E9DF
@lbl_C3E9DB:
	jsl.l GetJoypadHeld
@lbl_C3E9DF:
	ply
	lda.b wTemp00
	pha
	sty.b wTemp00
	lda.w #$100F
	and.b wTemp00
	sta.l $7F9CDE
	lda.l $7F9CDA
	beq @lbl_C3E9FF
	lda.l $7F9CDC
	eor.b wTemp00
	bit.w #$0040
	beq @lbl_C3EA19
@lbl_C3E9FF:
	lda.w #$0001
	sta.l $7F9CDA
	lda.b wTemp00
	sta.l $7F9CDC
	ldx.w #$000A
	bit.w #$0040
	beq @lbl_C3EA17
	ldx.w #$0000
@lbl_C3EA17:
	stx.b wTemp00
@lbl_C3EA19:
	pla
	bit.w #$A0BF
	beq @lbl_C3E9B8
	lda.w #$0000
	sta.b wTemp00
	jsl.l GetJoypadState
	lda.l debugMode
	and.w #$0010
	eor.w #$FFFF
	and.b wTemp00
	bit.w #$0080
	beq @lbl_C3EA7A
	; A-button command path:
	; A+B yields fixed command $1C.
	; A alone yields fixed command $18 when there is no new facing direction.
	; A+dpad with a different direction yields packed direction|$10, which the
	; action handler treats as a face-only command.
	ldy.w #$001C
	bit.w #$0040
	bne @lbl_C3EA8D
	lda.l $7F9CDE
	sta.b wTemp00
	jsl.l MapDPadBitsToDirection
	ldy.w #$0018
	bcs @lbl_C3EA8D
	lda.b wTemp00
	pha
	lda.w #$0013
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	stz.b wTemp03
	pla
	cmp.b wTemp02
	beq @lbl_C3EA8D
	ora.w #$0010
	pha
	lda.w #$0000
	sta.b wTemp00
	lda.w #$0080
	sta.b wTemp02
	jsl.l func_80DD6E
	pla
	sta.b wTemp00
	plp
	rtl
@lbl_C3EA7A:
	; L yields fixed command $1D. Start yields fixed command $E1.
	ldy.w #$001D
	bit.w #$2000
	bne @lbl_C3EA8D
	ldy.w #$00E1
	bit.w #$0010
	beq @lbl_C3EA91
;C3EA8A  
	.db $4C,$EE,$EA
@lbl_C3EA8D:
	sty.b wTemp00
	plp
	rtl
@lbl_C3EA91:
	bit.w #$0020
	beq @lbl_C3EA9D
	jsl.l func_C3F3B6
@lbl_C3EA9A:
	jmp.w @lbl_C3E9B8
@lbl_C3EA9D:
	; X-button actions go through a context-sensitive resolver that can emit
	; fixed commands such as $5F based on what Shiren is facing/standing on.
	bit.w #$8000
	beq @lbl_C3EACF
	lda.w #$0013
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp04
	and.w #$00FF
	cmp.w #$0037
	beq @lbl_C3EA9A
	cmp.w #$0000
	beq @lbl_C3EAC2
;C3EABA  
	jsl $C3ECC5                             ;C3EABA
	.db $B0,$DA   ;C3EABE
	plp                                     ;C3EAC0
	rtl                                     ;C3EAC1
@lbl_C3EAC2:
	tdc
	sta.l $7F9CDA
	jsl.l func_C3EBA3
	bcs @lbl_C3EA9A
	plp
	rtl
@lbl_C3EACF:
	sta.b wTemp00
	pha
	; Convert d-pad bit combinations into the 0-7 direction enum from constants/npc.asm.
	jsl.l MapDPadBitsToDirection
	pla
	bcs @lbl_C3EA9A
	; Directional commands keep the 0-7 direction in the low bits. B adds $08
	; and Y adds $10 to select alternate movement/action families.
	ldy.w #$0008
	bit.w #$0040
	bne @lbl_C3EAE9
	ldy.w #$0010
	bit.w #$4000
	beq @lbl_C3EAEC
@lbl_C3EAE9:
	tya
	tsb.b wTemp00
@lbl_C3EAEC:
	plp
	rtl
	rep #$30                                ;C3EAEE
	stz $00                                 ;C3EAF0
	clc                                     ;C3EAF2
	bit #$1000                              ;C3EAF3
	beq @lbl_C3EAF9                         ;C3EAF6
	sec                                     ;C3EAF8
@lbl_C3EAF9:
	rol $00                                 ;C3EAF9
	clc                                     ;C3EAFB
	bit #$4000                              ;C3EAFC
	beq @lbl_C3EB02                         ;C3EAFF
	sec                                     ;C3EB01
@lbl_C3EB02:
	rol $00                                 ;C3EB02
	clc                                     ;C3EB04
	bit #$0040                              ;C3EB05
	beq @lbl_C3EB0B                         ;C3EB08
	sec                                     ;C3EB0A
@lbl_C3EB0B:
	rol $00                                 ;C3EB0B
	lda $00                                 ;C3EB0D
	cmp #$0006                              ;C3EB0F
	beq @lbl_C3EB2C                         ;C3EB12
	cmp #$0007                              ;C3EB14
	bne @lbl_C3EB42                         ;C3EB17
	jsl.l $C07D19                           ;C3EB19
	jsl.l $C4854E                           ;C3EB1D
	jsl.l $C4A997                           ;C3EB21
	jsl.l $C48584                           ;C3EB25
	jmp $E9B8                               ;C3EB29
@lbl_C3EB2C:
	sep #$20                                ;C3EB2C
	lda #$01                                ;C3EB2E
	sta.l $00103F                           ;C3EB30
	rep #$20                                ;C3EB34
	lda #$8000                              ;C3EB36
	sta $00                                 ;C3EB39
	jsl.l $818049                           ;C3EB3B
	jmp $E9B8                               ;C3EB3F
@lbl_C3EB42:
	xba                                     ;C3EB42
	ora #$00E1                              ;C3EB43
	sta $00                                 ;C3EB46
	plp                                     ;C3EB48
	rtl                                     ;C3EB49

MapDPadBitsToDirection:
	php
	rep #$30 ;AXY->16
	restorebank
	; wTemp00 holds controller direction bits; successful matches return a direction enum in wTemp00.
	lda.b wTemp00
	and.w #$1000
	bne @lbl_C3EB5B
	ldx.w #$000E
	bra @lbl_C3EB5E
@lbl_C3EB5B:
	ldx.w #$0006
@lbl_C3EB5E:
	lda.b wTemp00
	and.w #$000F
@lbl_C3EB63:
	cmp.w DATA8_C3EB77,x
	bne @lbl_C3EB70
	lda.w DATA8_C3EB87,x
	sta.b wTemp00
	plp
	clc
	rtl
@lbl_C3EB70:
	dex
	dex
	bpl @lbl_C3EB63
	plp
	sec
	rtl

DATA8_C3EB77:
	.db $09,$00,$05,$00,$0A,$00,$06,$00,$08,$00,$01,$00,$04,$00,$02,$00   ;C3EB77

DATA8_C3EB87:
	.db $01,$00,$07,$00,$03,$00,$05,$00,$02,$00,$00,$00,$06,$00,$04,$00   ;C3EB87

func_C3EB97:
	php
	rep #$30 ;AXY->16
	lda.w #$0001
	sta.l $7F9CE0
	bra func_C3EBAD

func_C3EBA3:
	php
	rep #$30 ;AXY->16
	lda.w #$0000
	sta.l $7F9CE0
func_C3EBAD:
	jsl.l func_C07D19
	jsl.l func_C4854E
	lda.l $7F9CE0
	beq func_C3EBBE
	jmp.w BuildGroundItemActionCommand
func_C3EBBE:
	lda.l $7F9CE0
	bne func_C3EBF9
	jsl.l func_C49602
	bcs func_C3EBF9
	lda.b wTemp00
	asl a
	tax
	lda.l DATA8_C3EBD4,x
	pha
	rts

DATA8_C3EBD4:
	.db $FF,$EB,$07,$EC,$AD,$EC,$B4,$EC   ;C3EBD4
	.db $BC,$EC                           ;C3EBDC  
	.db $28,$EC                           ;C3EBDE
	.db $3F,$EC,$49,$EC,$07,$EC           ;C3EBE0  
func_C3EBE6:
	lda.b wTemp00
	pha
	lda.b wTemp02
	pha
	jsl.l func_C48584
	pla
	sta.b wTemp02
	pla
	sta.b wTemp00
	plp
	clc
	rtl
func_C3EBF9:
	jsl.l func_C48584
	plp
	sec
	rtl
	jsl.l func_C3F123
	bcs func_C3EBBE
	bra func_C3EBE6
	lda.l $7F9CD8
	bne @lbl_C3EC15
	lda.w #$005F
	sta.b wTemp00
	bra func_C3EBE6
@lbl_C3EC15:
	jsl $C4A29D                             ;C3EC15
	lda $00                                 ;C3EC19
	and #$00FF                              ;C3EC1B
	beq @lbl_C3EC22                         ;C3EC1E
	.db $80,$9C   ;C3EC20
@lbl_C3EC22:
	ldx #$001A                              ;C3EC22
	stx $00                                 ;C3EC25
	.db $80,$BD   ;C3EC27

BuildGroundItemActionCommand:
	jsl.l OpenGroundItemActionMenu
	bcs func_C3EBBE
	lda.b wTemp02
	bne @lbl_C3EC40
	; Ground-container special case: choose an item to put inside the container.
	lda #$001F                              ;C3EC33
	sta $00                                 ;C3EC36
	jsl $C3F17D                             ;C3EC38
	.db $90,$A8   ;C3EC3C
	.db $80,$E9   ;C3EC3E
@lbl_C3EC40:
	dec a
	bne @lbl_C3EC4A
	; Direct throw action for the underfoot item.
	.db $A9,$9F,$00,$85,$00,$80,$9C
@lbl_C3EC4A:
	dec a
	bne @lbl_C3EC77
	; Exchange the selected inventory item with the underfoot item.
	sep #$20                                ;C3EC4D
	stz $00                                 ;C3EC4F
	jsl $C23B7C                             ;C3EC51
	lda $00                                 ;C3EC55
	rep #$20                                ;C3EC57
	.db $30,$CE   ;C3EC59
	lda #$001F                              ;C3EC5B
	sta $00                                 ;C3EC5E
	jsl $C4A0B1                             ;C3EC60
	.db $B0,$C3   ;C3EC64
	sep #$20                                ;C3EC66
	lda $00                                 ;C3EC68
	ora #$40                                ;C3EC6A
	sta $01                                 ;C3EC6C
	lda #$BF                                ;C3EC6E
	sta $00                                 ;C3EC70
	rep #$20                                ;C3EC72
	jmp $EBE6                               ;C3EC74
@lbl_C3EC77:
	dec a
	bne @lbl_C3EC91
	; Name/read the underfoot item (blank-scroll-specific path included here).
	lda #$0013                              ;C3EC7A
	sta $00                                 ;C3EC7D
	jsl $C210AC                             ;C3EC7F
	jsl $C359AF                             ;C3EC83
	lda $01                                 ;C3EC87
	sta $00                                 ;C3EC89
	jsl $C3F336                             ;C3EC8B
	.db $80,$98   ;C3EC8F
@lbl_C3EC91:
	dec a
	bne @lbl_C3EC96
;C3EC94  
	.db $80,$93
@lbl_C3EC96:
	dec a
	bne @lbl_C3ECA6
	; Ground-container special case: choose an item inside the container.
	lda #$001F                              ;C3EC99
	sta $00                                 ;C3EC9C
	jsr $F1F7                               ;C3EC9E
	.db $B0,$86   ;C3ECA1
	jmp $EBE6                               ;C3ECA3
@lbl_C3ECA6:
	; Fall back to the context-sensitive underfoot pickup action ($5F).
	lda.w #$005F
	sta.b wTemp00
	jmp.w func_C3EBE6
	; Toggle the ground-item details display.
	jsl.l ToggleGroundItemDetailsView
	jmp.w func_C3EBF9
	lda.w #$00F0
	sta.b wTemp00
	jmp.w func_C3EBE6
	lda #$00F1                              ;C3ECBD
	sta $00                                 ;C3ECC0
	jmp $EBE6                               ;C3ECC2
	php                                     ;C3ECC5
	rep #$30                                ;C3ECC6
	jsl $C07D19                             ;C3ECC8
	jsl $C4854E                             ;C3ECCC
	jsl $C62B42                             ;C3ECD0
	lda $00                                 ;C3ECD4
	and #$00FF                              ;C3ECD6
	beq @lbl_C3ECEB                         ;C3ECD9
	lda #$ED3B                              ;C3ECDB
	sta $00                                 ;C3ECDE
	lda #$00C3                              ;C3ECE0
	sta $02                                 ;C3ECE3
	jsl $C48E3D                             ;C3ECE5
	bra @lbl_C3ED06                         ;C3ECE9
@lbl_C3ECEB:
	lda #$ED46                              ;C3ECEB
	sta $00                                 ;C3ECEE
	lda #$00C3                              ;C3ECF0
	sta $02                                 ;C3ECF3
	jsl $C48E3D                             ;C3ECF5
	lda $00                                 ;C3ECF9
	and #$00FF                              ;C3ECFB
	cmp #$0002                              ;C3ECFE
	bne @lbl_C3ED06                         ;C3ED01
	inc a                                   ;C3ED03
	sta $00                                 ;C3ED04
@lbl_C3ED06:
	lda $00                                 ;C3ED06
	and #$00FF                              ;C3ED08
	bit #$0080                              ;C3ED0B
	bne @lbl_C3ED34                         ;C3ED0E
	pha                                     ;C3ED10
	jsl $C48584                             ;C3ED11
	pla                                     ;C3ED15
	ldx #$001D                              ;C3ED16
	dec a                                   ;C3ED19
	bmi @lbl_C3ED28                         ;C3ED1A
	ldx #$0019                              ;C3ED1C
	dec a                                   ;C3ED1F
	bmi @lbl_C3ED28                         ;C3ED20
	dec a                                   ;C3ED22
	bmi @lbl_C3ED2D                         ;C3ED23
	ldx #$00F0                              ;C3ED25
@lbl_C3ED28:
	stx $00                                 ;C3ED28
	plp                                     ;C3ED2A
	clc                                     ;C3ED2B
	rtl                                     ;C3ED2C
@lbl_C3ED2D:
	jsl $C3F387                             ;C3ED2D
	plp                                     ;C3ED31
	sec                                     ;C3ED32
	rtl                                     ;C3ED33
@lbl_C3ED34:
	jsl $C48584                             ;C3ED34
	plp                                     ;C3ED38
	sec                                     ;C3ED39
	rtl                                     ;C3ED3A
	.db $BF,$01,$03,$00,$09,$04,$02,$02,$21,$10,$00,$C0,$01,$03,$00,$04,$06,$01,$03,$21,$10,$00   ;C3ED3B

func_C3ED51:
	php
	rep #$30 ;AXY->16
	jsl.l func_C07D19
	jsl.l func_C4854E
	jsl.l func_C4A29D
	ldx.w #$001A
	lda.b wTemp00
	beq @lbl_C3ED6A
	ldx.w #$FFFF
@lbl_C3ED6A:
	phx
	jsl.l func_C48584
	plx
	stx.b wTemp00
	plp
	rtl

func_C3ED74:
	php
	rep #$30 ;AXY->16
	lda.b wTemp00
	pha
	jsl.l func_C07D19
	jsl.l func_C4854E
	pla
	sta.b wTemp00
	cmp.w #$07D4
	beq @lbl_C3ED8F
	cmp.w #$06BF
	bne @lbl_C3ED92
@lbl_C3ED8F:
	jmp.w func_C3EE0C
@lbl_C3ED92:
	cmp.w #$0949
	beq @lbl_C3EDBD
	cmp.w #$094A
	beq @lbl_C3EDA7
	cmp.w #$094B
	bne @lbl_C3EDD5
;C3EDA1  
	.db $AF,$E7,$9C,$7F,$80,$24
@lbl_C3EDA7:
	sep #$20                                ;C3EDA7
	jsl $C4B3B8                             ;C3EDA9
	lda $01                                 ;C3EDAD
	sta $7F9CE7                             ;C3EDAF
	lda $00                                 ;C3EDB1
	bit #$80                                ;C3EDB3
	.db $F0,$12   ;C3EDB7
	lda #$01                                ;C3EDB9
	.db $80,$0E   ;C3EDBB
.ACCU 16
@lbl_C3EDBD:
	sep #$20                                ;C3EDBD
	jsl $C4B256                             ;C3EDBF
	lda $00                                 ;C3EDC3
	cmp #$FF                                ;C3EDC5
	bne @lbl_C3EDCB                         ;C3EDC7
	lda #$64                                ;C3EDC9
@lbl_C3EDCB:
	pha                                     ;C3EDCB
	jsl $C48584                             ;C3EDCC
	pla                                     ;C3EDD0
	sta $00                                 ;C3EDD1
	plp                                     ;C3EDD3
	rtl                                     ;C3EDD4
.ACCU 16
@lbl_C3EDD5:
	rep #$20 ;A->16
	ldx.w #$0000
	bra @lbl_C3EDE2
@lbl_C3EDDC:
	txa
	clc
	adc.w #$000D
	tax
@lbl_C3EDE2:
	lda.l DATA8_C3EE2E,x
	bmi @lbl_C3EDEC
	cmp.b wTemp00
	bne @lbl_C3EDDC
@lbl_C3EDEC:
	txa
	clc
	adc.w #$EE30
	sta.b wTemp00
	lda.w #$00C3
	sta.b wTemp02
	lda.b [wTemp00]
	bmi @lbl_C3EE00
	jsl.l func_C48E3D
@lbl_C3EE00:
	lda.b wTemp00
	pha
	jsl.l func_C48584
	pla
	sta.b wTemp00
	plp
	rtl

func_C3EE0C:
	sep #$30 ;AXY->8
	lda.b #$1F
	sta.b wTemp00
	jsl.l func_C4A0B1
	bcs @lbl_C3EE24
	lda.b wTemp00
	pha
	jsl.l func_C48584
	pla
	sta.b wTemp00
	plp
	rtl
@lbl_C3EE24:
	jsl.l func_C48584
	lda.b #$80
	sta.b wTemp00
	plp
	rtl

DATA8_C3EE2E:
	.db $8D,$06,$A9,$01,$16,$00,$08,$04   ;C3EE2E
	.db $01,$02,$25,$10,$00,$3E,$09       ;C3EE36
	.db $AC,$01,$03,$00,$08,$0A,$02,$05   ;C3EE3D  
	.db $21,$10,$00                       ;C3EE45  
	.db $3F,$09                           ;C3EE48
	.db $AD,$01,$03,$00,$10,$0E,$04,$07   ;C3EE4A  
	.db $21,$10,$00                       ;C3EE52  
	.db $40,$09                           ;C3EE55
	.db $AE,$01,$03,$00,$10,$0E,$04,$07   ;C3EE57  
	.db $21,$10,$00                       ;C3EE5F  
	.db $41,$09                           ;C3EE62
	.db $AF,$01,$03,$00,$08,$0C,$02,$06   ;C3EE64  
	.db $21,$10,$00                       ;C3EE6C  
	.db $42,$09                           ;C3EE6F
	.db $B0,$01,$03,$00,$10,$0A,$04,$05   ;C3EE71  
	.db $21,$10,$00                       ;C3EE79  
	.db $43,$09                           ;C3EE7C
	.db $B1,$01,$03,$00,$06,$0A,$01,$05   ;C3EE7E  
	.db $21,$10,$00                       ;C3EE86  
	.db $44,$09                           ;C3EE89
	.db $B2,$01,$03,$00,$16,$0C,$03,$06   ;C3EE8B  
	.db $3A,$10,$00                       ;C3EE93
	.db $45,$09                           ;C3EE96
	.db $B3,$01,$03,$00,$16,$0C,$03,$06   ;C3EE98  
	.db $3A,$10,$00                       ;C3EEA0
	.db $46,$09                           ;C3EEA3
	.db $B4,$01,$03,$00,$0C,$0C,$03,$06   ;C3EEA5  
	.db $21,$10,$00                       ;C3EEAD  
	.db $47,$09                           ;C3EEB0
	.db $B5,$01,$03,$00,$04,$06,$01,$03   ;C3EEB2  
	.db $21,$10,$00                       ;C3EEBA  
	.db $48,$09                           ;C3EEBD
	.db $B6,$01,$03,$00,$06,$08,$01,$04   ;C3EEBF  
	.db $21,$10,$00                       ;C3EEC7  
	.db $EB,$07                           ;C3EECA
	.db $ED,$07,$15,$00,$09,$04,$01,$02   ;C3EECC  
	.db $25,$10,$00                       ;C3EED4  
	.db $D2,$06                           ;C3EED7
	.db $07,$09,$17,$00,$07,$04,$01,$02   ;C3EED9  
	.db $25,$10,$00                       ;C3EEE1  
	.db $03,$07                           ;C3EEE4
	.db $0A,$09,$13,$00,$0B,$04,$01,$02   ;C3EEE6
	.db $25,$10,$00                       ;C3EEEE  
	.db $04,$07                           ;C3EEF1
	.db $0A,$09,$13,$00,$0B,$04,$01,$02   ;C3EEF3
	.db $25,$10,$00                       ;C3EEFB  
	.db $0B,$07                           ;C3EEFE
	.db $0A,$09,$13,$00,$0B,$04,$01,$02   ;C3EF00
	.db $25,$10,$00                       ;C3EF08  
	.db $2B,$07                           ;C3EF0B
	.db $13,$09,$0B,$00,$13,$04,$01,$02   ;C3EF0D  
	.db $25,$10,$00                       ;C3EF15  
	.db $39,$07                           ;C3EF18
	.db $14,$09,$0F,$00,$0F,$04,$01,$02   ;C3EF1A  
	.db $25,$10,$00                       ;C3EF22  
	.db $3B,$07                           ;C3EF25
	.db $14,$09,$0F,$00,$0F,$04,$01,$02   ;C3EF27  
	.db $25,$10,$00                       ;C3EF2F  
	.db $15,$09                           ;C3EF32
	.db $15,$09,$0D,$00,$11,$04,$01,$02   ;C3EF34  
	.db $25,$10,$00                       ;C3EF3C  
	.db $1A,$09                           ;C3EF3F
	.db $1A,$09,$06,$00,$18,$06,$01,$03   ;C3EF41
	.db $25,$10,$00                       ;C3EF49  
	.db $1B,$09                           ;C3EF4C
	.db $1B,$09,$06,$00,$18,$04,$01,$02   ;C3EF4E
	.db $25,$10,$00                       ;C3EF56  
	.db $1C,$09                           ;C3EF59
	.db $1C,$09,$06,$00,$18,$04,$01,$02   ;C3EF5B  
	.db $25,$10,$00                       ;C3EF63  
	.db $1D,$09                           ;C3EF66
	.db $1D,$09,$06,$00,$18,$04,$01,$02   ;C3EF68  
	.db $25,$10,$00                       ;C3EF70  
	.db $17,$09                           ;C3EF73
	.db $17,$09,$06,$00,$18,$02,$01,$01   ;C3EF75  
	.db $25,$10,$00                       ;C3EF7D  
	.db $18,$09                           ;C3EF80
	.db $18,$09,$06,$00,$18,$02,$01,$01   ;C3EF82
	.db $25,$10,$00                       ;C3EF8A  
	.db $19,$09                           ;C3EF8D
	.db $19,$09,$06,$00,$18,$02,$01,$01   ;C3EF8F  
	.db $25,$10,$00                       ;C3EF97  
	.db $1E,$09                           ;C3EF9A
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EF9C  
	.db $25,$10,$00                       ;C3EFA4  
	.db $4C,$07                           ;C3EFA7
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFA9  
	.db $25,$10,$00                       ;C3EFB1  
	.db $4E,$07                           ;C3EFB4
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFB6  
	.db $25,$10,$00                       ;C3EFBE  
	.db $4F,$07                           ;C3EFC1
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFC3  
	.db $25,$10,$00                       ;C3EFCB  
	.db $57,$07                           ;C3EFCE
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFD0  
	.db $25,$10,$00                       ;C3EFD8  
	.db $5B,$07                           ;C3EFDB
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFDD  
	.db $25,$10,$00                       ;C3EFE5  
	.db $5C,$07                           ;C3EFE8
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFEA  
	.db $25,$10,$00                       ;C3EFF2  
	.db $5D,$07                           ;C3EFF5
	.db $1E,$09,$14,$00,$0A,$04,$01,$02   ;C3EFF7  
	.db $25,$10,$00                       ;C3EFFF  
	.db $6B,$07,$6C,$07,$17,$00,$07,$04   ;C3F002
	.db $01,$02,$25,$10,$00,$7D,$07       ;C3F00A
	.db $7E,$07,$09,$00,$15,$06,$01,$03   ;C3F011  
	.db $25,$10,$00                       ;C3F019  
	.db $9D,$07                           ;C3F01C
	.db $9E,$07,$0F,$00,$0F,$04,$01,$02   ;C3F01E  
	.db $25,$10,$00                       ;C3F026  
	.db $9F,$07                           ;C3F029
	.db $9E,$07,$0F,$00,$0F,$04,$01,$02   ;C3F02B  
	.db $25,$10,$00                       ;C3F033  
	.db $A1,$07                           ;C3F036
	.db $9E,$07,$0F,$00,$0F,$04,$01,$02   ;C3F038  
	.db $25,$10,$00                       ;C3F040  
	.db $AA,$07                           ;C3F043
	.db $AB,$07,$0F,$00,$0F,$06,$01,$03   ;C3F045
	.db $25,$10,$00                       ;C3F04D  
	.db $B5,$07                           ;C3F050
	.db $AB,$07,$0F,$00,$0F,$06,$01,$03   ;C3F052
	.db $25,$10,$00                       ;C3F05A  
	.db $D0,$07                           ;C3F05D
	.db $D1,$07,$13,$00,$0B,$04,$01,$02   ;C3F05F  
	.db $25,$10,$00                       ;C3F067  
	.db $CB,$07                           ;C3F06A
	.db $CC,$07,$17,$00,$07,$04,$01,$02   ;C3F06C  
	.db $25,$10,$00                       ;C3F074  
	.db $48,$08                           ;C3F077
	.db $49,$08,$16,$00,$08,$04,$01,$02   ;C3F079
	.db $25,$10,$00                       ;C3F081  
	.db $42,$08                           ;C3F084
	.db $43,$08,$0E,$00,$10,$08,$01,$04   ;C3F086  
	.db $25,$10,$00                       ;C3F08E  
	.db $0C,$08,$0D,$08,$15,$00,$09,$04   ;C3F091
	.db $01,$02,$25,$10,$00,$BD,$06       ;C3F099
	.db $C8,$06,$14,$00,$0A,$04,$01,$02   ;C3F0A0
	.db $25,$10,$00                       ;C3F0A8  
	.db $C4,$06                           ;C3F0AB
	.db $C8,$06,$14,$00,$0A,$04,$01,$02   ;C3F0AD
	.db $25,$10,$00                       ;C3F0B5  
	.db $C6,$06                           ;C3F0B8
	.db $C8,$06,$14,$00,$0A,$04,$01,$02   ;C3F0BA
	.db $25,$10,$00                       ;C3F0C2  
	.db $64,$08                           ;C3F0C5
	.db $65,$08,$17,$00,$07,$04,$01,$02   ;C3F0C7  
	.db $25,$10,$00                       ;C3F0CF  
	.db $AA,$08                           ;C3F0D2
	.db $FF,$FF,$14,$00,$0A,$02,$02,$01   ;C3F0D4  
	.db $25,$10,$00                       ;C3F0DC  
	.db $FF,$FF,$7A,$01,$14,$00,$0A,$02   ;C3F0DF
	.db $02,$01,$25,$10,$00               ;C3F0E7
	.db $08,$C2,$30,$64,$01,$A5,$00,$48,$22,$19,$7D,$C0,$22,$4E,$85,$C4   ;C3F0EC
	.db $68,$85,$00,$22,$77,$9A,$C4,$22,$23,$F1,$C3,$B0,$13,$A5,$00,$48   ;C3F0FC
	.db $A5,$02,$48,$22,$84,$85,$C4,$68,$85,$02,$68,$85,$00,$28,$18,$6B   ;C3F10C  
	.db $22,$84,$85,$C4,$28,$38,$6B       ;C3F11C  

func_C3F123:
	php
	rep #$30 ;AXY->16
func_C3F126:
	jsl.l func_C49B38
	bcs func_C3F17A
	lda.b wTemp00
	cmp.w #$001F
	bne @lbl_C3F138
;C3F133
	.db $68,$68,$4C,$2F,$EC
@lbl_C3F138:
	lda.b wTemp02
	asl a
	tax
	lda.l DATA8_C3F142,x
	pha
	rts

DATA8_C3F142:
	.db $4D,$F1,$5C,$F1,$65,$F1           ;C3F142
	.db $6C,$F1,$65,$F1,$55,$F1           ;C3F148  
	jsl.l BuildGroundContainerInsertCommand
	bcs func_C3F126
	bra func_C3F177
	jsr.w BuildContainedItemActionCommand
	bcs func_C3F126
	.db $80,$1A                           ;C3F15B  
	lda.b wTemp00
	ora.w #$0080
	sta.b wTemp00
	bra func_C3F177
	lda.w #$0040
	tsb.b wTemp00
	bra func_C3F177
	jsl.l func_C23B7C
	jsl.l func_C3F336
	bra func_C3F126
func_C3F177:
	plp
	clc
	rtl
func_C3F17A:
	plp
	sec
	rtl

BuildGroundContainerInsertCommand:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	phx
	cpx.b #$1F
	beq @lbl_C3F18D
	jsl.l func_C23B7C
	bra @lbl_C3F19D
@lbl_C3F18D:
	lda #$13                                ;C3F18D
	sta $00                                 ;C3F18F
	jsl $C210AC                             ;C3F191
	jsl $C359AF                             ;C3F195
	lda $01                                 ;C3F199
	sta $00                                 ;C3F19B
@lbl_C3F19D:
	jsl.l func_C3F2FD
	lda.b wTemp00
	cmp.b #$0B
	bne func_C3F1BA
	lda.b wTemp01
	ldx.b #$03
@lbl_C3F1AB:
	cmp.l UNREACH_C3F1B6,x
	beq func_C3F1C7
	dex
	bpl @lbl_C3F1AB
	.db $80,$1B                           ;C3F1B4  

UNREACH_C3F1B6:
	.db $B9,$BE,$B5,$C1                   ;C3F1B6  
func_C3F1BA:
	lda.b wTemp01
	ldx.b #$02
@lbl_C3F1BE:
	cmp.l DATA8_C3F1CE,x
	beq func_C3F1D1
	dex
	bpl @lbl_C3F1BE
func_C3F1C7:
	pla
	ora.b #$60
	sta.b wTemp00
	bra func_C3F1F0

DATA8_C3F1CE:
	.db $57,$59,$6D                       ;C3F1CE
func_C3F1D1:
	stz.b wTemp00
	jsl.l func_C23B7C
	lda.b wTemp00
	bmi func_C3F1F3
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C4A0B1
	bcs func_C3F1F3
	lda.b wTemp00
	sta.b wTemp01
	pla
	ora.b #$A0
	sta.b wTemp00
	bra func_C3F177
func_C3F1F0:
	plp
	clc
	rtl
func_C3F1F3:
	pla                                     ;C3F1F3
	plp                                     ;C3F1F4
	sec                                     ;C3F1F5
	rtl                                     ;C3F1F6

BuildContainedItemActionCommand:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	cmp.b #$1F
	beq @lbl_C3F209
	sta.b wTemp00
	jsl.l func_C23B7C
	bra @lbl_C3F219
@lbl_C3F209:
	lda #$13                                ;C3F209
	sta $00                                 ;C3F20B
	jsl $C210AC                             ;C3F20D
	jsl $C359AF                             ;C3F211
	lda $01                                 ;C3F215
	sta $00                                 ;C3F217
@lbl_C3F219:
	jsl.l func_C49A97
	bcc @lbl_C3F223
	pla
	plp
	sec
	rts
@lbl_C3F223:
	lda $02                                 ;C3F223
	beq @lbl_C3F22A                         ;C3F225
	jmp $F2AD                               ;C3F227
@lbl_C3F22A:
	ldy $00                                 ;C3F22A
	plx                                     ;C3F22C
	cpx #$1F                                ;C3F22D
	beq @lbl_C3F23D                         ;C3F22F
	stx $00                                 ;C3F231
	phx                                     ;C3F233
	phy                                     ;C3F234
	jsl $C23B7C                             ;C3F235
	ply                                     ;C3F239
	plx                                     ;C3F23A
	bra @lbl_C3F251                         ;C3F23B
@lbl_C3F23D:
	lda #$13                                ;C3F23D
	sta $00                                 ;C3F23F
	phx                                     ;C3F241
	jsl $C210AC                             ;C3F242
	plx                                     ;C3F246
	phx                                     ;C3F247
	jsl $C359AF                             ;C3F248
	plx                                     ;C3F24C
	lda $01                                 ;C3F24D
	sta $00                                 ;C3F24F
@lbl_C3F251:
	sty $01                                 ;C3F251
	phx                                     ;C3F253
	phy                                     ;C3F254
	jsl $C33AEF                             ;C3F255
	ply                                     ;C3F259
	plx                                     ;C3F25A
	phx                                     ;C3F25B
	phy                                     ;C3F25C
	jsl $C3F2FD                             ;C3F25D
	ply                                     ;C3F261
	plx                                     ;C3F262
	lda $01                                 ;C3F263
	cmp #$57                                ;C3F265
	beq @lbl_C3F27E                         ;C3F267
	cmp #$6D                                ;C3F269
	beq @lbl_C3F27E                         ;C3F26B
	cmp #$59                                ;C3F26D
	beq @lbl_C3F27E                         ;C3F26F
	txa                                     ;C3F271
	ora #$A0                                ;C3F272
	sta $00                                 ;C3F274
	tya                                     ;C3F276
	ora #$80                                ;C3F277
	sta $01                                 ;C3F279
	plp                                     ;C3F27B
	clc                                     ;C3F27C
	rts                                     ;C3F27D
@lbl_C3F27E:
	stz $00                                 ;C3F27E
	phx                                     ;C3F280
	phy                                     ;C3F281
	jsl $C23B7C                             ;C3F282
	ply                                     ;C3F286
	plx                                     ;C3F287
	lda $00                                 ;C3F288
	bmi @lbl_C3F298                         ;C3F28A
	stx $00                                 ;C3F28C
	phx                                     ;C3F28E
	phy                                     ;C3F28F
	jsl $C4A0B1                             ;C3F290
	ply                                     ;C3F294
	plx                                     ;C3F295
	bcc @lbl_C3F29C                         ;C3F296
@lbl_C3F298:
	txa                                     ;C3F298
	jmp $F1FC                               ;C3F299
@lbl_C3F29C:
	lda $00                                 ;C3F29C
	sta $02                                 ;C3F29E
	txa                                     ;C3F2A0
	ora #$C0                                ;C3F2A1
	sta $00                                 ;C3F2A3
	tya                                     ;C3F2A5
	ora #$80                                ;C3F2A6
	sta $01                                 ;C3F2A8
	plp                                     ;C3F2AA
	clc                                     ;C3F2AB
	rts                                     ;C3F2AC
	dec a                                   ;C3F2AD
	bne @lbl_C3F2BF                         ;C3F2AE
	ldy $00                                 ;C3F2B0
	pla                                     ;C3F2B2
	ora #$A0                                ;C3F2B3
	sta $00                                 ;C3F2B5
	tya                                     ;C3F2B7
	ora #$A0                                ;C3F2B8
	sta $01                                 ;C3F2BA
	plp                                     ;C3F2BC
	clc                                     ;C3F2BD
	rts                                     ;C3F2BE
@lbl_C3F2BF:
	dec a                                   ;C3F2BF
	bne @lbl_C3F2D1                         ;C3F2C0
	ldy $00                                 ;C3F2C2
	pla                                     ;C3F2C4
	ora #$A0                                ;C3F2C5
	sta $00                                 ;C3F2C7
	tya                                     ;C3F2C9
	ora #$C0                                ;C3F2CA
	sta $01                                 ;C3F2CC
	plp                                     ;C3F2CE
	clc                                     ;C3F2CF
	rts                                     ;C3F2D0
@lbl_C3F2D1:
	dec a                                   ;C3F2D1
	bne @lbl_C3F2EE                         ;C3F2D2
	ldy $00                                 ;C3F2D4
	plx                                     ;C3F2D6
	phx                                     ;C3F2D7
	stx $00                                 ;C3F2D8
	phy                                     ;C3F2DA
	jsl $C23B7C                             ;C3F2DB
	ply                                     ;C3F2DF
	sty $01                                 ;C3F2E0
	jsl $C33AEF                             ;C3F2E2
	jsl $C3F336                             ;C3F2E6
	pla                                     ;C3F2EA
	jmp $F1FC                               ;C3F2EB
@lbl_C3F2EE:
	ldy $00                                 ;C3F2EE
	pla                                     ;C3F2F0
	ora #$A0                                ;C3F2F1
	sta $00                                 ;C3F2F3
	tya                                     ;C3F2F5
	ora #$E0                                ;C3F2F6
	sta $01                                 ;C3F2F8
	plp                                     ;C3F2FA
	clc                                     ;C3F2FB
	rts                                     ;C3F2FC

func_C3F2FD:
	php
	sep #$30 ;AXY->8
	ldy.b wTemp00
	phy
	jsl.l GetItemDisplayInfo
	ply
	lda.b wTemp01
	cmp.b #$68
	beq @lbl_C3F310
	plp
	rtl
@lbl_C3F310:
	rep #$20                                ;C3F310
	lda $00                                 ;C3F312
	pha                                     ;C3F314
	lda $02                                 ;C3F315
	pha                                     ;C3F317
	lda $04                                 ;C3F318
	pha                                     ;C3F31A
	lda $06                                 ;C3F31B
	pha                                     ;C3F31D
	sty $00                                 ;C3F31E
	jsl $C3091F                             ;C3F320
	ldy $00                                 ;C3F324
	pla                                     ;C3F326
	sta $06                                 ;C3F327
	pla                                     ;C3F329
	sta $04                                 ;C3F32A
	pla                                     ;C3F32C
	sta $02                                 ;C3F32D
	pla                                     ;C3F32F
	sta $00                                 ;C3F330
	sty $01                                 ;C3F332
	plp                                     ;C3F334
	rtl                                     ;C3F335
.ACCU 8

func_C3F336:
	php
	sep #$30 ;AXY->8
	ldy.b wTemp00
	phy
	jsl.l GetItemDisplayInfo
	ply
	lda.b wTemp01
	cmp.b #$68
	beq @lbl_C3F35D
	lda.b wTemp06
	bit.b #$02
	bne @lbl_C3F385
	lda.b wTemp06
	bit.b #$04
	bne @lbl_C3F35D
	phy
	jsl.l FindFreeCustomNameSlot
	ply
	lda.b wTemp00
	bmi @lbl_C3F385
@lbl_C3F35D:
	sty.b wTemp00
	phy
	jsl.l func_C495CD
	ply
	bcs @lbl_C3F385
	rep #$20                                ;C3F367
	lda $06                                 ;C3F369
	pha                                     ;C3F36B
	lda $04                                 ;C3F36C
	pha                                     ;C3F36E
	lda $02                                 ;C3F36F
	pha                                     ;C3F371
	lda $00                                 ;C3F372
	pha                                     ;C3F374
	tsc                                     ;C3F375
	inc a                                   ;C3F376
	sta $04                                 ;C3F377
	stz $06                                 ;C3F379
	sty $00                                 ;C3F37B
	jsl $C6280E                             ;C3F37D
	pla                                     ;C3F381
	pla                                     ;C3F382
	pla                                     ;C3F383
	pla                                     ;C3F384
.ACCU 8
@lbl_C3F385:
	plp
	rtl

ToggleGroundItemDetailsView:
	php
	rep #$20 ;A->16
	lda.l $7F9CE2
	beq @lbl_C3F3A0
	tdc
	sta.l $7F9CE2
	sta.b wTemp00
	jsl.l func_C3E80B
	lda.w #$0006
	bra @lbl_C3F3AE
@lbl_C3F3A0:
	inc a
	sta.l $7F9CE2
	sta.b wTemp00
	jsl.l func_C3E80B
	lda.w #$0004
@lbl_C3F3AE:
	sta.b wTemp00
	jsl.l func_80E5F5
	plp
	rtl

func_C3F3B6:
	php
	sep #$30 ;AXY->8
	lda.l debugMode
	beq @lbl_C3F3C7
	jsl.l func_C62B42
	lda.b wTemp00
	beq @lbl_C3F3E5
@lbl_C3F3C7:
	rep #$30 ;AXY->16
	jsl.l func_80E506
@lbl_C3F3CD:
	jsl.l func_80854A
	lda.w #$0000
	sta.b wTemp00
	jsl.l GetJoypadState
	lda.b wTemp00
	bit.w #$0020
	bne @lbl_C3F3CD
	jsl.l func_80E527
@lbl_C3F3E5:
	plp
	rtl

func_C3F3E7:
	php
	rep #$30 ;AXY->16
	lda.l debugMode
	bne @lbl_C3F40C
	lda #$0002                              ;C3F3F0
	sta $00                                 ;C3F3F3
	jsl $80DC69                             ;C3F3F5
	lda $00                                 ;C3F3F9
	.db $F0,$0F   ;C3F3FB
	bit #$0010                              ;C3F3FD
	.db $D0,$5A   ;C3F400
	bit #$8000                              ;C3F402
	.db $D0,$0A   ;C3F405
	bit #$4000                              ;C3F407
	.db $D0,$02   ;C3F40A
@lbl_C3F40C:
	plp
	rtl
	jmp $F54A                               ;C3F40E
	lda #$0013                              ;C3F411
	sta $00                                 ;C3F414
	jsl $C210AC                             ;C3F416
	lda $00                                 ;C3F41A
	pha                                     ;C3F41C
	jsl $C359AF                             ;C3F41D
	lda $02                                 ;C3F421
	pha                                     ;C3F423
	jsl $C36BB0                             ;C3F424
	ldy $00                                 ;C3F428
	jsl $C6275B                             ;C3F42A
	lda $00                                 ;C3F42E
	sta $04                                 ;C3F430
	sty $05                                 ;C3F432
	lda $01,s                               ;C3F434
	lsr a                                   ;C3F436
	lsr a                                   ;C3F437
	lsr a                                   ;C3F438
	lsr a                                   ;C3F439
	and #$000F                              ;C3F43A
	sta $06                                 ;C3F43D
	pla                                     ;C3F43F
	and #$000F                              ;C3F440
	sta $07                                 ;C3F443
	pla                                     ;C3F445
	sta $02                                 ;C3F446
	lda #$01BD                              ;C3F448
	sta $00                                 ;C3F44B
	jsl $80ECB4                             ;C3F44D
	lda #$00F0                              ;C3F451
	sta $00                                 ;C3F454
	jsl $80F34E                             ;C3F456
	plp                                     ;C3F45A
	rtl                                     ;C3F45B
	lda #$0002                              ;C3F45C
	sta $00                                 ;C3F45F
	jsl $80E5F5                             ;C3F461
	jsl $80F45E                             ;C3F465
	jsl $80854A                             ;C3F469
	lda #$0013                              ;C3F46D
	sta $00                                 ;C3F470
	jsl $C210FF                             ;C3F472
	sep #$10                                ;C3F476
	ldx $04                                 ;C3F478
	ldy $05                                 ;C3F47A
	stx $00                                 ;C3F47C
	sty $01                                 ;C3F47E
	phx                                     ;C3F480
	phy                                     ;C3F481
	jsl $C07D8D                             ;C3F482
	ply                                     ;C3F486
	plx                                     ;C3F487
	bra @lbl_C3F496                         ;C3F488
@lbl_C3F48A:
	phx                                     ;C3F48A
	phy                                     ;C3F48B
	jsl $C07D49                             ;C3F48C
	ply                                     ;C3F490
	plx                                     ;C3F491
	jsl $80854A                             ;C3F492
@lbl_C3F496:
	lda #$0002                              ;C3F496
	sta $00                                 ;C3F499
	phx                                     ;C3F49B
	phy                                     ;C3F49C
	jsl $80DD10                             ;C3F49D
	ply                                     ;C3F4A1
	plx                                     ;C3F4A2
	lda $00                                 ;C3F4A3
	beq @lbl_C3F48A                         ;C3F4A5
	bit #$0040                              ;C3F4A7
	beq @lbl_C3F4AF                         ;C3F4AA
	jmp $F531                               ;C3F4AC
@lbl_C3F4AF:
	bit #$0008                              ;C3F4AF
	beq @lbl_C3F4B9                         ;C3F4B2
	cpy #$00                                ;C3F4B4
	beq @lbl_C3F4B9                         ;C3F4B6
	dey                                     ;C3F4B8
@lbl_C3F4B9:
	bit #$0004                              ;C3F4B9
	beq @lbl_C3F4C3                         ;C3F4BC
	cpy #$29                                ;C3F4BE
	bcs @lbl_C3F4C3                         ;C3F4C0
	iny                                     ;C3F4C2
@lbl_C3F4C3:
	bit #$0002                              ;C3F4C3
	beq @lbl_C3F4CD                         ;C3F4C6
	cpx #$00                                ;C3F4C8
	beq @lbl_C3F4CD                         ;C3F4CA
	dex                                     ;C3F4CC
@lbl_C3F4CD:
	bit #$0001                              ;C3F4CD
	beq @lbl_C3F4D7                         ;C3F4D0
	cpx #$3F                                ;C3F4D2
	bcs @lbl_C3F4D7                         ;C3F4D4
	inx                                     ;C3F4D6
@lbl_C3F4D7:
	bit #$800F                              ;C3F4D7
	beq @lbl_C3F51B                         ;C3F4DA
	pha                                     ;C3F4DC
	phy                                     ;C3F4DD
	phx                                     ;C3F4DE
	lda $01,s                               ;C3F4DF
	sta $00                                 ;C3F4E1
	jsl $C359AF                             ;C3F4E3
	lda $02                                 ;C3F4E7
	pha                                     ;C3F4E9
	jsl $C36BB0                             ;C3F4EA
	ldy $00                                 ;C3F4EE
	jsl $C6275B                             ;C3F4F0
	lda $00                                 ;C3F4F4
	sta $04                                 ;C3F4F6
	sty $05                                 ;C3F4F8
	lda $01,s                               ;C3F4FA
	lsr a                                   ;C3F4FC
	lsr a                                   ;C3F4FD
	lsr a                                   ;C3F4FE
	lsr a                                   ;C3F4FF
	and #$000F                              ;C3F500
	sta $06                                 ;C3F503
	pla                                     ;C3F505
	and #$000F                              ;C3F506
	sta $07                                 ;C3F509
	lda $01,s                               ;C3F50B
	sta $02                                 ;C3F50D
	lda #$01BD                              ;C3F50F
	sta $00                                 ;C3F512
	jsl $80ECB4                             ;C3F514
	plx                                     ;C3F518
	ply                                     ;C3F519
	pla                                     ;C3F51A
@lbl_C3F51B:
	phx                                     ;C3F51B
	ldx #$14                                ;C3F51C
	bit #$000F                              ;C3F51E
	bne @lbl_C3F525                         ;C3F521
	ldx #$50                                ;C3F523
@lbl_C3F525:
	stx $00                                 ;C3F525
	stz $01                                 ;C3F527
	jsl $80F34E                             ;C3F529
	plx                                     ;C3F52D
	jmp $F47C                               ;C3F52E
	lda #$000A                              ;C3F531
	sta $00                                 ;C3F534
	jsl $80E5F5                             ;C3F536
	jsl $80F44F                             ;C3F53A
	jsl $80854A                             ;C3F53E
	jsl $C07BB3                             ;C3F542
	plp                                     ;C3F546
	rtl                                     ;C3F547
	rep #$10                                ;C3F548
	sep #$20                                ;C3F54A
	jsl $C07D19                             ;C3F54C
	jsl $C4854E                             ;C3F550
	lda $7F9CE4                             ;C3F554
	sta $00                                 ;C3F558
	lda $7F9CE5                             ;C3F55A
	sta $01                                 ;C3F55E
	lda $7F9CE6                             ;C3F560
	sta $02                                 ;C3F564
	jsl $C4B4EC                             ;C3F566
	php                                     ;C3F56A
	lda $00                                 ;C3F56B
	sta $7F9CE4                             ;C3F56D
	lda $01                                 ;C3F571
	sta $7F9CE5                             ;C3F573
	lda $02                                 ;C3F577
	sta $7F9CE6                             ;C3F579
	jsl $C48584                             ;C3F57D
	plp                                     ;C3F581
	bcc @lbl_C3F586                         ;C3F582
	plp                                     ;C3F584
	rtl                                     ;C3F585
@lbl_C3F586:
	lda #$13                                ;C3F586
	sta $00                                 ;C3F588
	jsl $C210FF                             ;C3F58A
	lda #$12                                ;C3F58E
	sta $00                                 ;C3F590
	lda $7F9CE4                             ;C3F592
	inc a                                   ;C3F596
	sta $01                                 ;C3F597
	tdc                                     ;C3F599
	lda $7F9CE6                             ;C3F59A
	sta $03                                 ;C3F59E
	asl a                                   ;C3F5A0
	tax                                     ;C3F5A1
	lda $04                                 ;C3F5A2
	sec                                     ;C3F5A4
	sbc $C3F63E,x                           ;C3F5A5
	sta $04                                 ;C3F5A9
	lda $05                                 ;C3F5AB
	sec                                     ;C3F5AD
	sbc $C3F63F,x                           ;C3F5AE
	sta $05                                 ;C3F5B2
	lda #$0C                                ;C3F5B4
	sta $02                                 ;C3F5B6
	stz $06                                 ;C3F5B8
	rep #$20                                ;C3F5BA
	lda $00                                 ;C3F5BC
	pha                                     ;C3F5BE
	lda $02                                 ;C3F5BF
	pha                                     ;C3F5C1
	lda $04                                 ;C3F5C2
	pha                                     ;C3F5C4
	jsl $C06DDF                             ;C3F5C5
	pla                                     ;C3F5C9
	sta $04                                 ;C3F5CA
	pla                                     ;C3F5CC
	sta $02                                 ;C3F5CD
	pla                                     ;C3F5CF
	sta $00                                 ;C3F5D0
	sep #$20                                ;C3F5D2
	lda #$01                                ;C3F5D4
	sta $02                                 ;C3F5D6
	rep #$20                                ;C3F5D8
	lda $04                                 ;C3F5DA
	sta $06                                 ;C3F5DC
	jsl $C06C80                             ;C3F5DE
	sep #$20                                ;C3F5E2
	lda $7F9CE5                             ;C3F5E4
	ora #$80                                ;C3F5E8
	sta $02                                 ;C3F5EA
	jsl $C06C80                             ;C3F5EC
	ldx #$01BC                              ;C3F5F0
	stx $00                                 ;C3F5F3
	lda $7F9CE4                             ;C3F5F5
	inc a                                   ;C3F5F9
	sta $02                                 ;C3F5FA
	jsl $C06DFE                             ;C3F5FC
	lda $7F9CE5                             ;C3F600
	bne @lbl_C3F61A                         ;C3F604
	lda #$13                                ;C3F606
	sta $00                                 ;C3F608
	lda #$40                                ;C3F60A
	sta $02                                 ;C3F60C
	jsl $C210FF                             ;C3F60E
	ldx $04                                 ;C3F612
	stx $06                                 ;C3F614
	jsl $C06C80                             ;C3F616
@lbl_C3F61A:
	ldx #$0008                              ;C3F61A
	stx $00                                 ;C3F61D
	lda $7F9CE4                             ;C3F61F
	inc a                                   ;C3F623
	sta $02                                 ;C3F624
	jsl $C06DFE                             ;C3F626
	jsl $C075BB                             ;C3F62A
	lda #$02                                ;C3F62E
	sta $00                                 ;C3F630
	ldx #$000A                              ;C3F632
	stx $02                                 ;C3F635
	jsl $80DDA4                             ;C3F637
	jmp $F54A                               ;C3F63B
	ora ($00,x)                             ;C3F63E
	ora ($FF,x)                             ;C3F640
	.db $00   ;C3F642
	sbc $FFFFFF,x                           ;C3F643
	.db $00   ;C3F647
	sbc $010001,x                           ;C3F648
	ora ($01,x)                             ;C3F64C
.ACCU 16

.include "code/random.asm"
