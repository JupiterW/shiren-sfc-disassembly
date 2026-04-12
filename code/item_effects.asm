;c3087e
MonsterMeatUseEffect:
	sep #$30 ;AXY->8
	lda.w wItemModification1,y
	sta.b wTemp00
	pha
	lda.w wItemModification2,y
	sta.b wTemp01
	jsl.l func_C2414A
	pla
	cmp.b #$1A
	beq @lbl_C3089F
	lda.b #$64
	sta.b wTemp00
	stz.b wTemp01
	jsl.l ModifyShirenHunger
	rts
@lbl_C3089F:
	jmp.w func_C315AE

;c308a2
BlankScrollUseEffect:
	sep #$30 ;AXY->8
	lda.b wTemp01
	pha
	phy
	lda.w wItemModification1,y
	cmp.b #$FF ;Has the scroll been named?
	bne @named
	pla ;weird decision to pop into a
	pla
	lda.b #$32
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage ;print BlankScrollUseText
	rts
@named:
	sty wTemp00
	phb
	jsl.l CheckBlankScrollName
	plb
	tdc
	lda.b wTemp00
	cmp.b #$FF ;Is the scroll name invalid?
	bne @validScroll
	pla
	sta.b wTemp02
	pla
	lda.b #$31
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage ;print InvalidBlankScrollText
	rts
@validScroll:
	rep #$30 ;AXY->16
	asl a
	tax
	lda.l ItemUseEffectFunctionTable,x
	sep #$10 ;XY->8
	ply
	plx
	stx.b wTemp01
	pha
	sep #$30 ;AXY->8
	rts

;c308f0
BlankScrollThrowEffect:
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	phy
	sty.b wTemp00
	phb
	jsl.l CheckBlankScrollName
	plb
	sep #$20 ;A->8
	tdc
	lda.b wTemp00
	cmp.b #$FF ;Is the scroll name invalid?
	bne @validScroll
	lda.b #Item_LightScroll
@validScroll:
	rep #$30 ;AXY->16
	asl a
	tax
	lda.l ItemThrowEffectFunctionTable,x
	sep #$10 ;XY->8
	ply
	rep #$10 ;XY->16
	plx
	stx.b wTemp00
	pha
	sep #$30 ;AXY->8
	rts

;c3091f
;Checks whether the blank scroll corresponding to the given item index
;has a valid name or not. If it is, the corresponding item id is returned,
;otherwise FF is returned.
;wTemp00: item index, returned scroll type
CheckBlankScrollName:
	php 
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wItemModification1,y
	sta.l $7E9360
	lda.w wItemModification2,y
	sta.l $7E9361
	lda.w wItemFuseAbility1,y
	sta.l $7E9362
	lda.w wItemFuseAbility2,y
	sta.l $7E9363
	lda.w wItemIsCursed,y
	sta.l $7E9364
	lda.w wItemTimesIdentified,y
	sta.l $7E9365
	lda.b #$FF
	sta.l $7E9366
	rep #$10 ;XY->16
	;Check each possible scroll name (text ids 1202-1228) for a match
	ldx.w #1202 ;Text1202
@loop1:
	stx.b wTemp00
	ldy.w #$9360
	sty.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	phx
	jsl.l CheckIfItemNameEqualToTextEntry
	plx
	bcs @noMatch1 ;Go to the next one if the name didn't match
	rep #$20 ;A->16
	txa
	;Subtract the id of the first scroll name, then add the first scroll id
	;to get the item id
	sec 
	sbc.w #1202 ;Text1202
	clc 
	adc.w #Item_BlessingScroll
	sta.b wTemp00
	plp 
	rtl
@noMatch1:
	sep #$20 ;A->8
	inx 
	cpx.w #(1228+1) ;Text1229
	bne @loop1 ;continue if not at text id 1229
	lda.b #$03
	;Check ids 1230-1233 (variations of monster house)
@loop2:
	pha
	inx
	stx.b wTemp00
	ldy.w #$9360
	sty.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	phx
	jsl.l CheckIfItemNameEqualToTextEntry
	plx
	bcs @noMatch2
	pla
	lda.b #Item_MonsterHouseScroll
	sta.b wTemp00
	plp 
	rtl
@noMatch2:
	pla
	dec a
	bpl @loop2
	lda.b #$01
	;Check text ids 1234-1235
@loop3:
	pha
	inx 
	stx.b wTemp00
	ldy.w #$9360
	sty.b wTemp02
	lda.b #$7E
	sta.b wTemp04
	phx
	jsl.l CheckIfItemNameEqualToTextEntry
	plx
	bcs @noMatch3
	pla
	lda.b #Item_6F
	sta.b wTemp00
	plp
	rtl
@noMatch3:
	pla
	dec a
	bpl @loop3
	;the scroll name is invalid, return FF
	lda.b #$FF
	sta.b wTemp00
	plp 
	rtl

;c309d1
ItemUseNoEffect:
	rts

;c309d2
UnusedItemUseEffect:
	rts

;c309d3
WanderingScrollUseEffect:
	jsl.l func_C36734
	rep #$20 ;A->16
	lda.w #$0013
	sta.b wTemp00
	lda.w #$00D0
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.w #$0160
	sta.b wTemp00
	jsl.l DisplayMessage
	rts

;c309f1
ShowNothingHappensMessage:
	sep #$30 ;AXY->8
	lda.b #$5C
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	rts

;c309fe
VictoryHerbUseEffect:
	sep #$30 ;AXY->8
	lda.b #$14
	sta.b wTemp00
	jsl.l func_C28428
	rep #$20 ;A->16
	lda.w #$00F5
	sta.b wTemp00
	jsl.l DisplayMessage

;c30a14
KignyHerbUseEffect:
	rts

;c30a15
func_C30A15:
	sep #$30 ;AXY->8
	ldx.b #$13
	stx.b wTemp00
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b #$32
	sta.b wTemp01
	phx
	jsl.l func_C28433
	plx
	rep #$20 ;A->16
	lda.w #$0100
	sta.b wTemp00
	stx.b wTemp02
	jsl.l DisplayMessage
	rts

;c30a36
AmnesiaHerbUseEffect:
	sep #$30 ;AXY->8
	lda.b #$04
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage
	ldx.b #$E5
@lbl_C30A46:
	lda.l wItemIdentified,x
	beq @lbl_C30A72
	lda.l DATA8_C341BB,x
	cmp.b #$00
	beq @lbl_C30A64
	cmp.b #$01
	beq @lbl_C30A64
	cmp.b #$07
	beq @lbl_C30A64
	cmp.b #$06
	beq @lbl_C30A64
	cmp.b #$0B
	bne @lbl_C30A72
@lbl_C30A64:
	lda.b #$00
	sta.l wItemIdentified,x
	lda.l wItemUnidentifiedName,x
	sta.l wItemHasCustomName,x
@lbl_C30A72:
	dex 
	cpx.b #$FF
	bne @lbl_C30A46
	ldx.b #$7E
@lbl_C30A79:
	lda.b #$00
	sta.l wItemTimesIdentified,x
	lda.l wItemType,x
	cmp.b #$68
	bne @lbl_C30A8D
	lda.b #$FF
	sta.l wItemModification1,x
@lbl_C30A8D:
	dex 
	bpl @lbl_C30A79
	jsl.l PreIdentifyDungeonItems
	rts

;c30a95
NullItemEffect:
	rts

;c30a96
BigBellySeedUseEffect:
	rep #$20 ;A->16
	lda.w #$0064
	sta.b wTemp00
	jsl.l ModifyShirenMaxHunger
	sep #$20 ;A->8
	lda.b #$0A
	sta.b wTemp02
	jsl.l Divide16Bit
	lda.b wTemp00
	sta.b wTemp02
	rep #$20 ;A->16
	lda.w #$004E
	sta.b wTemp00
	jsl.l DisplayMessage
	rts

;c30abb
LittleBellySeedUseEffect:
	rep #$20 ;A->16
	lda.w #$FF9C
	sta.b wTemp00
	jsl.l ModifyShirenMaxHunger
	sep #$20 ;A->8
	lda.b #$0A
	sta.b wTemp02
	jsl.l Divide16Bit
	lda.b wTemp00
	sta.b wTemp02
	rep #$20 ;A->16
	lda.w #$004F
	sta.b wTemp00
	jsl.l DisplayMessage
	rts

;c30ae0
TalkSeedUseEffect:
	jsl.l func_C286C8
	rts

ExecuteSelectedItemActionByCategory:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	lda.b wTemp04
	sta.l $7E935E
	ldy.b wTemp00
	ldx.w wItemType,y
	lda.l DATA8_C341BB,x
	; Register the selected item into its category shortcut slot:
	; $03=weapons, $05=shields, $06=armbands, $04=arrows.
	; For equip categories, assigning the slot also applies the item's effect,
	; and replacing an occupied slot first tries to clear the previous item.
	cmp.b #$03
	bne @lbl_C30B0D
	sty.b wTemp00
	phx
	phy
	call_savebank ToggleWeaponShortcutItem
	ply
	plx
	bra @lbl_C30B3E
@lbl_C30B0D:
	cmp.b #$05
	bne @lbl_C30B1F
	sty.b wTemp00
	phx
	phy
	call_savebank ToggleShieldShortcutItem
	ply
	plx
	bra @lbl_C30B3E
@lbl_C30B1F:
	cmp.b #$06
	bne @lbl_C30B31
	sty.b wTemp00
	phx
	phy
	call_savebank ToggleArmbandShortcutItem
	ply
	plx
	bra @lbl_C30B3E
@lbl_C30B31:
	cmp.b #$04
	beq @lbl_C30B38
	jmp.w func_C30BD3
@lbl_C30B38:
	sty.b wTemp00
	jsl.l ToggleArrowShortcutItem
@lbl_C30B3E:
	lda.b wTemp00
	beq @lbl_C30B5D
	dec a
	bne @lbl_C30B5F
	lda.b #$AC
	sta.b wTemp00
	lda.l DATA8_C341BB,x
	cmp.b #$06
	bne @lbl_C30B55
;C30B51
	lda #$AD                                ;C30B51
	sta $00                                 ;C30B53
@lbl_C30B55:
	stz.b wTemp01
	sty.b wTemp02
	jsl.l DisplayMessage
@lbl_C30B5D:
	bra @lbl_C30BCB
@lbl_C30B5F:
	lda.b #$01
	sta.w wItemTimesIdentified,y
	lda.l DATA8_C341BB,x
	cmp.b #$06
	beq @lbl_C30B80
	lda.b #$19
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	bra @lbl_C30B92
@lbl_C30B80:
	lda.b #$1B
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
@lbl_C30B92:
	lda.w wItemIsCursed,y
	beq @lbl_C30BB9
	lda.b #$62
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.b #$8A
	sta.b wTemp00
	stz.b wTemp01
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
@lbl_C30BB9:
	lda.b #$01
	sta.b wTemp00
	rep #$30 ;AXY->16
	txa
	asl a
	tax
	lda.l ItemUseEffectFunctionTable,x
	pea.w $0BCA
	pha
	rts
@lbl_C30BCB:
	sep #$20 ;A->8
	lda.b #$01
	sta.b wTemp00
	plp
	rtl

func_C30BD3:
	sep #$30 ;AXY->8
	cmp.b #$07
	beq @lbl_C30BDC
	jmp.w func_C30D11
@lbl_C30BDC:
	pha
	pha
	lda.b wTemp01
	pha
	rep #$20 ;A->16
	lda.b wTemp02
	pha
	lda.w #$0001
	sta.b wTemp00
	sty.b wTemp02
	phy
	call_savebank DisplayMessage
	ply
	sep #$20 ;A->8
	lda.b #$13
	cmp.l $7E935E
	bne @lbl_C30C1D
	sta.b wTemp00
	call_savebank GetCharacterMapInfo
	lda.b wTemp04
	cmp.b #$00
	bne @lbl_C30C1D
	lda.b #$13
	sta.b wTemp00
	lda.b #$85
	sta.b wTemp02
	phy
	call_savebank PlayCharacterEffect
	ply
@lbl_C30C1D:
	lda.w wItemModification1,y
	beq @lbl_C30C68
	dec a
	sta.w wItemModification1,y
	lda.b wTemp03,s
	sta.b wTemp00
	stz.b wTemp01
	rep #$20 ;A->16
	lda.b wTemp01,s
	sta.b wTemp02
	sep #$20 ;A->8
	phy
	call_savebank func_C32FEE
	ply
	lda.b wTemp00
	pha
	rep #$20 ;A->16
	lda.b wTemp02
	sta.b wTemp06
	sta.b wTemp05,s
	lda.b wTemp02,s
	sta.b wTemp04
	sep #$20 ;A->8
	sty.b wTemp00
	lda.b #$07
	sta.b wTemp01
	lda.b #$00
	sta.b wTemp02
	lda.b wTemp04,s
	sta.b wTemp03
	phy
	call_savebank func_C626CA
	ply
	pla
	bpl @lbl_C30C7D
;C30C66  
	.db $80,$0A   ;C30C66
@lbl_C30C68:
	lda #$5C                                ;C30C68
	sta $00                                 ;C30C6A
	stz $01                                 ;C30C6C
	jsl.l DisplayMessage
	pla                                     ;C30C72
	pla                                     ;C30C73
	pla                                     ;C30C74
	pla                                     ;C30C75
	pla                                     ;C30C76
	lda #$01                                ;C30C77
	sta $00                                 ;C30C79
	plp                                     ;C30C7B
	rtl                                     ;C30C7C
@lbl_C30C7D:
	pha
	sta.b wTemp00
	phy
	jsl.l func_C28E4C
	ply
	lda.b wTemp00
	beq @lbl_C30CCE
	lda $01,s                               ;C30C8A
	sta $00                                 ;C30C8C
	lda #$12                                ;C30C8E
	sta $02                                 ;C30C90
	phy                                     ;C30C92
	phb                                     ;C30C93
	jsl PlayVisualEffect                             ;C30C94
	plb                                     ;C30C98
	ply                                     ;C30C99
	rep #$20                                ;C30C9A
	lda $02,s                               ;C30C9C
	sta $06                                 ;C30C9E
	lda $05,s                               ;C30CA0
	sta $04                                 ;C30CA2
	sep #$20                                ;C30CA4
	sty $00                                 ;C30CA6
	lda #$07                                ;C30CA8
	sta $01                                 ;C30CAA
	lda #$00                                ;C30CAC
	sta $02                                 ;C30CAE
	lda $04,s                               ;C30CB0
	eor #$04                                ;C30CB2
	sta $03                                 ;C30CB4
	phy                                     ;C30CB6
	phb                                     ;C30CB7
	jsl $C626CA                             ;C30CB8
	plb                                     ;C30CBC
	ply                                     ;C30CBD
	lda $7E935E                             ;C30CBE
	tax                                     ;C30CC2
	lda $01,s                               ;C30CC3
	ora #$80                                ;C30CC5
	sta $7E935E                             ;C30CC7
	txa                                     ;C30CCB
	sta $01,s                               ;C30CCC
@lbl_C30CCE:
	pla
	phb
	phy
	sta.b wTemp00
	pha
	jsl.l func_C27FAA
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b #$0A
	sta.b wTemp02
	jsl.l PlayVisualEffect
	pla
	sta.b wTemp00
	lda.l $7E935E
	and.b #$7F
	sta.b wTemp01
	ply
	plb
	pla
	pla
	pla
	pla
	pla
	lda.w wItemType,y
	rep #$30 ;AXY->16
	and.w #$00FF
	asl a
	tax
	lda.l ItemUseEffectFunctionTable,x
	pea.w $0D08
	pha
	rts
	sep #$20 ;A->8
	lda.b #$01
	sta.b wTemp00
	plp
	rtl

func_C30D11:
	sep #$30 ;AXY->8
	cmp.b #$0A
	bne @lbl_C30D29
	lda #$01                                ;C30D17
	sta $00                                 ;C30D19
	stz $01                                 ;C30D1B
	sty $02                                 ;C30D1D
	jsl.l DisplayMessage
	lda #$01                                ;C30D23
	sta $00                                 ;C30D25
	plp                                     ;C30D27
	rtl                                     ;C30D28
@lbl_C30D29:
	cmp.b #$0B
	bne @lbl_C30D30
	jmp.w func_C30E71
@lbl_C30D30:
	rep #$20 ;A->16
	lda.b wTemp02
	pha
	sep #$30 ;AXY->8
	lda.b wTemp01
	pha
	jsl.l func_C23367
	lda.b wTemp00
	beq @lbl_C30D55
	lda #$53                                ;C30D42
	sta $00                                 ;C30D44
	stz $01                                 ;C30D46
	jsl.l DisplayMessage
	pla                                     ;C30D4C
	pla                                     ;C30D4D
	pla                                     ;C30D4E
	lda #$01                                ;C30D4F
	sta $00                                 ;C30D51
	plp                                     ;C30D53
	rtl                                     ;C30D54
@lbl_C30D55:
	sty.b wTemp00
	phx
	phy
	call_savebank GetItemDisplayInfo
	ply
	plx
	lda.b wTemp05
	cmp.b #$E6
	bne @lbl_C30D73
@lbl_C30D67:
	lda #$82                                ;C30D67
	sta $00                                 ;C30D69
	stz $01                                 ;C30D6B
	jsl.l DisplayMessage
	.db $80,$D9   ;C30D71
@lbl_C30D73:
	lda.l DATA8_C341BB,x
	cmp.b #$00
	bne @lbl_C30DB1
	lda.b #$18
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.b #$13
	sta.b wTemp00
	lda.b #$C4
	sta.b wTemp02
	phx
	phy
	call_savebank PlayCharacterEffect
	ply
	plx
	lda.b #$32
	sta.b wTemp00
	stz.b wTemp01
	phx
	phy
	call_savebank ModifyShirenHunger
	ply
	plx
	bra @lbl_C30DE9
@lbl_C30DB1:
	cmp.b #$01
	bne @lbl_C30E0E
	lda.b #$13
	sta.b wTemp00
	phx
	phy
	jsl.l GetCharacterStatusEffects
	ply
	plx
	lda.b wTemp00
	bne @lbl_C30D67
	lda.b #$1A
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.b #$13
	sta.b wTemp00
	lda.b #$C2
	sta.b wTemp02
	phx
	phy
	call_savebank PlayCharacterEffect
	ply
	plx
@lbl_C30DE9:
	lda.w wItemIdentified,x
	bne @lbl_C30E0C
	sty $00                                 ;C30DEE
	phx                                     ;C30DF0
	phy                                     ;C30DF1
	phb                                     ;C30DF2
	jsl $C30192                             ;C30DF3
	plb                                     ;C30DF7
	ply                                     ;C30DF8
	plx                                     ;C30DF9
	lda #$C7                                ;C30DFA
	sta $00                                 ;C30DFC
	stz $01                                 ;C30DFE
	sty $02                                 ;C30E00
	phx                                     ;C30E02
	phy                                     ;C30E03
	phb                                     ;C30E04
	jsl.l DisplayMessage
	plb                                     ;C30E08
	ply                                     ;C30E09
	plx                                     ;C30E0A
@lbl_C30E0C:
	bra @lbl_C30E3C
@lbl_C30E0E:
	phx
	ldx.b #$C3
	cmp.b #$09
	bne @lbl_C30E17
	ldx.b #$C5
@lbl_C30E17:
	lda.b #$2A
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$13
	sta.b wTemp02
	sty.b wTemp03
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.b #$13
	sta.b wTemp00
	stx.b wTemp02
	phy
	call_savebank PlayCharacterEffect
	ply
	plx
@lbl_C30E3C:
	pla
	sta.b wTemp01
	pla
	pla
	phy
	rep #$30 ;AXY->16
	txa
	asl a
	tax
	lda.l ItemUseEffectFunctionTable,x
	pea.w $0E4F
	pha
	rts
	sep #$30 ;AXY->8
	plx
	lda.l wItemType,x
	cmp.b #Item_InvisibleItem
	beq @lbl_C30E65
	stx.b wTemp00
	jsl.l FreeFloorItemSlot
	stz.b wTemp00
	plp
	rtl
@lbl_C30E65:
	stx $00                                 ;C30E65
	jsl $C306F4                             ;C30E67
	lda #$02                                ;C30E6B
	sta $00                                 ;C30E6D
	plp                                     ;C30E6F
	rtl                                     ;C30E70

func_C30E71:
	sep #$20 ;A->8
	lda.b wTemp01
	pha
	lda.b #$13
	sta.b wTemp00
	lda.b #$C6
	sta.b wTemp02
	phx
	phy
	call_savebank PlayCharacterEffect
	ply
	plx
	pla
	sta.b wTemp01
	rep #$30 ;AXY->16
	txa
	asl a
	tax
	lda.l ItemUseEffectFunctionTable,x
	pea.w $0E98
	pha
	rts
	sep #$30 ;AXY->8
	lda.b #$01
	sta.b wTemp00
	plp
	rtl
MedicinalHerbUseEffect:
	; Heal up to 25 HP. If Shiren is already at max HP, raise max HP by 1 first.
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStats
	lda.b wTemp01
	sec
	sbc.b wTemp00
	beq @lbl_C30ED5
	cmp.b #$19
	bcc @lbl_C30EBA
	lda.b #$19
@lbl_C30EBA:
	sta.b wTemp02
	ldy.w #$0040
	sty.b wTemp00
	pha
	jsl.l DisplayMessage
	pla
	sta.b wTemp02
	stz.b wTemp03
	lda.b #$13
	sta.b wTemp00
	jsl.l ModifyCharacterHP
	bra @lbl_C30EFC
@lbl_C30ED5:
	ldy.w #$0087
	sty.b wTemp00
	lda.b #$01
	sta.b wTemp02
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0001
	sty.b wTemp02
	jsl.l ModifyCharacterMaxHP
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0001
	sty.b wTemp02
	jsl.l ModifyCharacterHP
@lbl_C30EFC:
	rts
RestorativeHerbUseEffect:
	; Heal up to 100 HP. If Shiren is already at max HP, raise max HP by 2 first.
	; Then clear confusion and puzzled status if present.
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStats
	lda.b wTemp01
	sec
	sbc.b wTemp00
	beq @lbl_C30F31
	cmp.b #$64
	bcc @lbl_C30F16
	lda.b #$64
@lbl_C30F16:
	sta.b wTemp02
	ldy.w #$0040
	sty.b wTemp00
	pha
	jsl.l DisplayMessage
	pla
	sta.b wTemp02
	stz.b wTemp03
	lda.b #$13
	sta.b wTemp00
	jsl.l ModifyCharacterHP
	bra @lbl_C30F58
@lbl_C30F31:
	ldy.w #$0087
	sty.b wTemp00
	lda.b #$02
	sta.b wTemp02
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0002
	sty.b wTemp02
	jsl.l ModifyCharacterMaxHP
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0002
	sty.b wTemp02
	jsl.l ModifyCharacterHP
@lbl_C30F58:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStatusEffects
	lda.b wTemp01
	pha
	lda.b wTemp03
	pha
	pla
	beq @lbl_C30F7F
	ldy.w #$0013
	sty.b wTemp00
	jsl.l func_C23FFF
	ldy.w #$0067
	sty.b wTemp00
	jsl.l DisplayMessage
@lbl_C30F7F:
	pla
	beq @lbl_C30F94
	ldy.w #$0013
	sty.b wTemp00
	jsl.l func_C24073
	ldy.w #$006C
	sty.b wTemp00
	jsl.l DisplayMessage
@lbl_C30F94:
	rts
	sep #$20                                ;C30F95
	rep #$10                                ;C30F97
	lda #$13                                ;C30F99
	sta $00                                 ;C30F9B
	jsl GetCharacterStatusEffects                             ;C30F9D
	lda $01                                 ;C30FA1
	pha                                     ;C30FA3
	lda $03                                 ;C30FA4
	pha                                     ;C30FA6
	lda $00                                 ;C30FA7
	.db $F0,$12   ;C30FA9
	ldy #$0013                              ;C30FAB
	sty $00                                 ;C30FAE
	jsl $C240A7                             ;C30FB0
	ldy #$009B                              ;C30FB4
	sty $00                                 ;C30FB7
	jsl.l DisplayMessage
	pla                                     ;C30FBD
	.db $F0,$12   ;C30FBE
	ldy #$0013                              ;C30FC0
	sty $00                                 ;C30FC3
	jsl $C23FFF                             ;C30FC5
	ldy #$0067                              ;C30FC9
	sty $00                                 ;C30FCC
	jsl.l DisplayMessage
	pla                                     ;C30FD2
	.db $F0,$12   ;C30FD3
	ldy #$0013                              ;C30FD5
	sty $00                                 ;C30FD8
	jsl $C24073                             ;C30FDA
	ldy #$006C                              ;C30FDE
	sty $00                                 ;C30FE1
	jsl.l DisplayMessage
	rts                                     ;C30FE7
	sep #$30                                ;C30FE8
	lda #$13                                ;C30FEA
	sta $00                                 ;C30FEC
	jsl.l GetCharacterStats                             ;C30FEE
	lda $01                                 ;C30FF2
	cmp $00                                 ;C30FF4
	beq @lbl_C30FFD                         ;C30FF6
	jsr $28E9                               ;C30FF8
	bra @lbl_C31000                         ;C30FFB
@lbl_C30FFD:
	jsr $0EFD                               ;C30FFD
@lbl_C31000:
	jsr $1004                               ;C31000
	rts                                     ;C31003

AntidoteHerbUseEffect:
	sep #$20 ;A->8
	jsl.l GetShirenCoreStatus
	lda.b wTemp01
	sec
	sbc.b wTemp00
	beq @lbl_C31021
;C31011  
	sta $00                                 ;C31011
	jsl ModifyShirenStrength                             ;C31013
	lda #$9D                                ;C31017
	sta $00                                 ;C31019
	stz $01                                 ;C3101B
	jsl.l DisplayMessage
@lbl_C31021:
	rts
StrengthHerbUseEffect:
	sep #$20                                ;C31022
	jsl GetShirenCoreStatus                             ;C31024
	lda $00                                 ;C31028
	cmp $01                                 ;C3102A
	.db $D0,$1F   ;C3102C
	lda #$9F                                ;C3102E
	sta $00                                 ;C31030
	stz $01                                 ;C31032
	lda #$01                                ;C31034
	sta $02                                 ;C31036
	jsl.l DisplayMessage
	lda #$01                                ;C3103C
	sta $00                                 ;C3103E
	jsl ModifyShirenMaxStrength                             ;C31040
	lda #$01                                ;C31044
	sta $00                                 ;C31046
	jsl ModifyShirenStrength                             ;C31048
	rts                                     ;C3104C
	lda #$9E                                ;C3104D
	sta $00                                 ;C3104F
	stz $01                                 ;C31051
	lda #$01                                ;C31053
	sta $02                                 ;C31055
	jsl.l DisplayMessage
	lda #$01                                ;C3105B
	sta $00                                 ;C3105D
	jsl ModifyShirenStrength                             ;C3105F
	rts                                     ;C31063
	sep #$20                                ;C31064
	jsl GetShirenCoreStatus                             ;C31066
	lda $00                                 ;C3106A
	cmp $01                                 ;C3106C
	.db $D0,$1F   ;C3106E
	lda #$9F                                ;C31070
	sta $00                                 ;C31072
	stz $01                                 ;C31074
	lda #$03                                ;C31076
	sta $02                                 ;C31078
	jsl.l DisplayMessage
	lda #$03                                ;C3107E
	sta $00                                 ;C31080
	jsl ModifyShirenMaxStrength                             ;C31082
	lda #$03                                ;C31086
	sta $00                                 ;C31088
	jsl ModifyShirenStrength                             ;C3108A
	rts                                     ;C3108E
	jsl GetShirenCoreStatus                             ;C3108F
	lda $01                                 ;C31093
	sec                                     ;C31095
	sbc $00                                 ;C31096
	cmp #$03                                ;C31098
	bcc @lbl_C3109E                         ;C3109A
	lda #$03                                ;C3109C
@lbl_C3109E:
	sta $02                                 ;C3109E
	lda #$9E                                ;C310A0
	sta $00                                 ;C310A2
	stz $01                                 ;C310A4
	lda $02                                 ;C310A6
	pha                                     ;C310A8
	jsl.l DisplayMessage
	pla                                     ;C310AC
	sta $02                                 ;C310AD
	lda $02                                 ;C310AF
	sta $00                                 ;C310B2
	jsl ModifyShirenStrength                             ;C310B4
	rts                                     ;C310B8
HappinessHerbUseEffect:
	sep #$20                                ;C310B9
	lda #$13                                ;C310BB
	sta $00                                 ;C310BD
HappinessHerbThrowEffect:
	sep #$20                                ;C310BF
	lda #$01                                ;C310C1
	sta $01                                 ;C310C3
	jsl ApplyCharacterLevelGains                             ;C310C5
	rts                                     ;C310C9
AngelSeedUseEffect:
	sep #$20                                ;C310CA
	lda #$13                                ;C310CC
	sta $00                                 ;C310CE
	sep #$20                                ;C310D0
	lda #$05                                ;C310D2
	sta $01                                 ;C310D4
	jsl ApplyCharacterLevelGains                             ;C310D6
	rts                                     ;C310DA
BitterHerbUseEffect:
	sep #$20                                ;C310DB
	lda #$13                                ;C310DD
	sta $00                                 ;C310DF
BitterHerbThrowEffect:
	sep #$20                                ;C310E1
	lda #$FF                                ;C310E3
	sta $01                                 ;C310E5
	jsl ApplyCharacterLevelGains                             ;C310E7
	rts                                     ;C310EB
MisfortuneHerbUseEffect:
	sep #$20                                ;C310EC
	lda #$13                                ;C310EE
	sta $00                                 ;C310F0
MisfortuneHerbThrowEffect:
	sep #$20                                ;C310F2
	lda #$FD                                ;C310F4
	sta $01                                 ;C310F6
	jsl ApplyCharacterLevelGains                             ;C310F8
	rts                                     ;C310FC
	sep #$20                                ;C310FD
	lda #$13                                ;C310FF
	sta $00                                 ;C31101
	sep #$30                                ;C31103
	ldx $00                                 ;C31105
	phx                                     ;C31107
	jsl.l GetCharacterStats                             ;C31108
	plx                                     ;C3110C
	lda $00                                 ;C3110D
	pha                                     ;C3110F
	lda $01                                 ;C31110
	pha                                     ;C31112
	stx $00                                 ;C31113
	lda $05                                 ;C31115
	dec a                                   ;C31117
	eor #$FF                                ;C31118
	inc a                                   ;C3111A
	sta $01                                 ;C3111B
	phx                                     ;C3111D
	jsl ApplyCharacterLevelGains                             ;C3111E
	plx                                     ;C31122
	stx $00                                 ;C31123
	phx                                     ;C31125
	jsl.l GetCharacterStats                             ;C31126
	plx                                     ;C3112A
	pla                                     ;C3112B
	sec                                     ;C3112C
	sbc $01                                 ;C3112D
	sta $02                                 ;C3112F
	stz $03                                 ;C31131
	stx $00                                 ;C31133
	phx                                     ;C31135
	jsl ModifyCharacterMaxHP                             ;C31136
	plx                                     ;C3113A
	stx $00                                 ;C3113B
	phx                                     ;C3113D
	jsl.l GetCharacterStats                             ;C3113E
	plx                                     ;C31142
	pla                                     ;C31143
	sec                                     ;C31144
	sbc $00                                 ;C31145
	sta $02                                 ;C31147
	stz $03                                 ;C31149
	stx $00                                 ;C3114B
	jsl ModifyCharacterHP                             ;C3114D
	rts                                     ;C31151
IllLuckHerbUseEffect:
	sep #$20                                ;C31152
	lda #$13                                ;C31154
	sta $00                                 ;C31156
IllLuckHerbThrowEffect:
	sep #$30                                ;C31158
	ldx $00                                 ;C3115A
	phx                                     ;C3115C
	jsl.l GetCharacterStats                             ;C3115D
	plx                                     ;C31161
	stx $00                                 ;C31162
	lda #$9D                                ;C31164
	sta $01                                 ;C31166
	phx                                     ;C31168
	jsl ApplyCharacterLevelGains                             ;C31169
	plx                                     ;C3116D
	stx $00                                 ;C3116E
	lda #$9D                                ;C31170
	sta $01                                 ;C31172
	phx                                     ;C31174
	jsl ApplyCharacterLevelGains                             ;C31175
	plx                                     ;C31179
	stx $00                                 ;C3117A
	lda #$9D                                ;C3117C
	sta $01                                 ;C3117E
	phx                                     ;C31180
	jsl ApplyCharacterLevelGains                             ;C31181
	plx                                     ;C31185
	stx $00                                 ;C31186
	phx                                     ;C31188
	jsl.l GetCharacterStats                             ;C31189
	plx                                     ;C3118D
	lda #$00                                ;C3118E
	xba                                     ;C31190
	lda $00                                 ;C31191
	rep #$20                                ;C31193
	dec a                                   ;C31195
	eor #$FFFF                              ;C31196
	inc a                                   ;C31199
	sta $02                                 ;C3119A
	stx $00                                 ;C3119C
	jsl ModifyCharacterHP                             ;C3119E
	rts                                     ;C311A2
LifeHerbUseEffect:
	; Increase Shiren's max HP by 5, which also heals by the same amount.
	sep #$20 ;A->8
	lda.b #$87
	sta.b wTemp00
	stz.b wTemp01
	lda.b #$05
	sta.b wTemp02
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	sep #$20 ;A->8
	lda.b #$05
	sta.b wTemp02
	stz.b wTemp03
	jsl.l ModifyCharacterMaxHP
	rts
	sep #$20                                ;C311C3
	lda #$65                                ;C311C5
	sta $00                                 ;C311C7
	stz $01                                 ;C311C9
	jsl.l DisplayMessage
	.db $22   ;C311CF
	.db $A2   ;C311D0
	eor $A9C2,x                             ;C311D2
	ora ($85,s),y                           ;C311D5
	.db $00   ;C311D7
	sep #$20                                ;C311D8
	lda #$0B                                ;C311DA
	sta $01                                 ;C311DC
	jsl $C240BC                             ;C311DE
	rts                                     ;C311E2
PoisonHerbUseEffect:
	rep #$20                                ;C311E3
	sep #$10                                ;C311E5
	ldy #$C7                                ;C311E7
	sty $00                                 ;C311E9
	jsl $C23BA6                             ;C311EB
	rep #$20                                ;C311EF
	sep #$10                                ;C311F1
	lda #$003F                              ;C311F3
	sta $00                                 ;C311F6
	ldy #$05                                ;C311F8
	sty $02                                 ;C311FA
.ACCU 8
	jsl.l DisplayMessage
	lda #$FB                                ;C31200
	sbc $A00285,x                           ;C31202
	.db $13   ;C31206
	sty $00                                 ;C31207
	jsl ModifyCharacterHP                             ;C31209
	lda #$FF                                ;C3120D
	sbc $220085,x                           ;C3120F
	adc ($32),y                             ;C31213
	rep #$A4                                ;C31215
	.db $00   ;C31217
	.db $F0,$0B   ;C31218
	sty $02                                 ;C3121A
	lda #$00A0                              ;C3121C
	sta $00                                 ;C3121F
	jsl.l DisplayMessage
	ldy #$13                                ;C31225
	sty $00                                 ;C31227
	jsl $C240D6                             ;C31229
	jsl $C25DA2                             ;C3122D
	sep #$20                                ;C31231
	rep #$10                                ;C31233
	ldy #$0164                              ;C31235
	sty $00                                 ;C31238
	jsl.l DisplayMessage
	rts                                     ;C3123E
	rep #$20                                ;C3123F
	sep #$10                                ;C31241
	ldy #$C7                                ;C31243
	sty $00                                 ;C31245
	jsl $C23BA6                             ;C31247
	lda #$003F                              ;C3124B
	sta $00                                 ;C3124E
	ldy #$14                                ;C31250
	sty $02                                 ;C31252
	jsl.l DisplayMessage
	lda #$FFEC                              ;C31258
	sta $02                                 ;C3125B
	ldy #$13                                ;C3125D
	sty $00                                 ;C3125F
	jsl ModifyCharacterHP                             ;C31261
	lda #$FFFA                              ;C31265
	sta $00                                 ;C31268
	jsl ModifyShirenStrength                             ;C3126A
	ldy $00                                 ;C3126E
	.db $F0,$0B   ;C31270
	sty $02                                 ;C31272
	lda #$00A0                              ;C31274
	sta $00                                 ;C31277
	jsl.l DisplayMessage
	rts                                     ;C3127D
	sep #$20                                ;C3127E
	jsl GetShirenCoreStatus                             ;C31280
	lda #$01                                ;C31284
	sec                                     ;C31286
	sbc $00                                 ;C31287
	pha                                     ;C31289
	lda #$13                                ;C3128A
	sta $00                                 ;C3128C
	jsl.l GetCharacterStats                             ;C3128E
	lda #$01                                ;C31292
	sec                                     ;C31294
	sbc $00                                 ;C31295
	pha                                     ;C31297
	eor #$FF                                ;C31298
	inc a                                   ;C3129A
	pha                                     ;C3129B
	rep #$20                                ;C3129C
	sep #$10                                ;C3129E
	ldy #$C7                                ;C312A0
	sty $00                                 ;C312A2
	jsl $C23BA6                             ;C312A4
	lda #$003F                              ;C312A8
	sta $00                                 ;C312AB
	ply                                     ;C312AD
	.db $F0,$06   ;C312AE
	sty $02                                 ;C312B0
	jsl.l DisplayMessage
	ply                                     ;C312B6
	beq @lbl_C312C7                         ;C312B7
	sty $02                                 ;C312B9
	ldy #$FF                                ;C312BB
	sty $03                                 ;C312BD
	ldy #$13                                ;C312BF
	sty $00                                 ;C312C1
	jsl ModifyCharacterHP                             ;C312C3
@lbl_C312C7:
	ply                                     ;C312C7
	sty $00                                 ;C312C8
	jsl ModifyShirenStrength                             ;C312CA
	ldy $00                                 ;C312CE
	.db $F0,$0B   ;C312D0
	sty $02                                 ;C312D2
	lda #$00A0                              ;C312D4
	sta $00                                 ;C312D7
	jsl.l DisplayMessage
	rts                                     ;C312DD

func_C312DE:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.b #$40
	sta.l wItemType,x
	lda.b #$00
	sta.l wItemTimesIdentified,x
	lda.l wItemPotNextItem,x
	cmp.b #$FF
	bne @lbl_C312FD
	sta.b wTemp00
	jsl.l FreeFloorItemSlot
@lbl_C312FD:
	plp
	rtl

func_C312FF:
	jsr.w func_C328E9
	jsr.w AntidoteHerbUseEffect
	rtl
	jsr $130A                               ;C31306
	rtl                                     ;C31309
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	bne @lbl_C31315
;C31312  
	jmp $11EF                               ;C31312
@lbl_C31315:
	phx
	jsl.l GetCharacterStats
	plx
	lda.b wTemp07
	lsr a
	lsr a
	adc.b #$00
	eor.b #$FF
	inc a
	sta.b wTemp01
	stx.b wTemp00
	phx
	jsl.l func_C234AB
	plx
	stx.b wTemp00
	jsl.l func_C240D6
	jsl.l func_C25DA2
	rep #$10 ;XY->16
	ldy.w #$0164
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
ConfusionHerbUseEffect:
	sep #$20                                ;C31344
	lda #$0B                                ;C31346
	sta $01                                 ;C31348
	lda #$13                                ;C3134A
	sta $00                                 ;C3134C
	jsl $C23FFF                             ;C3134E
	lda $00                                 ;C31352
	.db $F0,$0A   ;C31354
	lda #$66                                ;C31356
	sta $00                                 ;C31358
	stz $01                                 ;C3135A
	jsl.l DisplayMessage
	rts                                     ;C31360
	sep #$20                                ;C31361
	lda #$15                                ;C31363
	.db $80,$E1   ;C31365
	sep #$30                                ;C31367
	ldx $00                                 ;C31369
	stx $02                                 ;C3136B
	lda #$04                                ;C3136D
	sta $00                                 ;C3136F
	stz $01                                 ;C31371
	phx                                     ;C31373
	jsl.l DisplayMessage
	plx                                     ;C31378
	stx $00                                 ;C31379
	lda #$0B                                ;C3137B
	sta $01                                 ;C3137D
	jsl $C23FFF                             ;C3137F
	rts                                     ;C31383
	sep #$30                                ;C31384
	lda $00                                 ;C31386
	pha                                     ;C31388
	jsl $C28929                             ;C31389
	pla                                     ;C3138D
	sta $02                                 ;C3138E
	lda #$04                                ;C31390
	ldx $00                                 ;C31392
	beq @lbl_C31398                         ;C31394
	lda #$05                                ;C31396
@lbl_C31398:
	sta $00                                 ;C31398
	stz $01                                 ;C3139A
	jsl.l DisplayMessage
	rts                                     ;C313A0
SleepHerbUseEffect:
	sep #$20                                ;C313A1
	lda #$05                                ;C313A3
	sta $01                                 ;C313A5
	lda #$13                                ;C313A7
	sta $00                                 ;C313A9
	jsl $C24080                             ;C313AB
	lda $00                                 ;C313AF
	.db $F0,$0A   ;C313B1
	lda #$6A                                ;C313B3
	sta $00                                 ;C313B5
	stz $01                                 ;C313B7
	jsl.l DisplayMessage
	rts                                     ;C313BD
	sep #$20                                ;C313BE
	lda #$0A                                ;C313C0
	.db $80,$E1   ;C313C2
	sep #$20                                ;C313C4
	lda #$05                                ;C313C6
	sta $01                                 ;C313C8
	lda $00                                 ;C313CA
	pha                                     ;C313CC
	jsl $C24080                             ;C313CD
	pla                                     ;C313D1
	sta $02                                 ;C313D2
	lda #$3B                                ;C313D4
	sta $00                                 ;C313D6
	stz $01                                 ;C313D8
	jsl.l DisplayMessage
	rts                                     ;C313DE
	sep #$30                                ;C313DF
	lda $00                                 ;C313E1
	pha                                     ;C313E3
	jsl $C288E5                             ;C313E4
	pla                                     ;C313E8
	sta $02                                 ;C313E9
	lda #$3B                                ;C313EB
	ldx $00                                 ;C313ED
	beq @lbl_C313F3                         ;C313EF
	lda #$3C                                ;C313F1
@lbl_C313F3:
	sta $00                                 ;C313F3
	stz $01                                 ;C313F5
	jsl.l DisplayMessage
	rts                                     ;C313FB
	sep #$20                                ;C313FC
	lda #$95                                ;C313FE
	sta $00                                 ;C31400
	stz $01                                 ;C31402
	jsl.l DisplayMessage
	lda #$13                                ;C31408
	sta $00                                 ;C3140A
	jsl $C24390                             ;C3140C
	rts                                     ;C31410
	sep #$20                                ;C31411
	lda #$32                                ;C31413
	sta $01                                 ;C31415
	lda #$13                                ;C31417
	sta $00                                 ;C31419
	jsl $C240A7                             ;C3141B
	lda #$99                                ;C3141F
	sta $00                                 ;C31421
	stz $01                                 ;C31423
	jsl.l DisplayMessage
	rts                                     ;C31429
	sep #$20                                ;C3142A
	lda #$64                                ;C3142C
	.db $80,$E5   ;C3142E
	sep #$20                                ;C31430
	lda #$32                                ;C31432
	sta $01                                 ;C31434
	lda $00                                 ;C31436
	pha                                     ;C31438
	jsl $C240A7                             ;C31439
	pla                                     ;C3143D
	sta $02                                 ;C3143E
	lda #$BC                                ;C31440
	sta $00                                 ;C31442
	stz $01                                 ;C31444
	jsl.l DisplayMessage
	rts                                     ;C3144A
	sep #$30                                ;C3144B
	lda $00                                 ;C3144D
	pha                                     ;C3144F
	jsl $C289B1                             ;C31450
	pla                                     ;C31454
	sta $02                                 ;C31455
	lda #$BC                                ;C31457
	ldx $00                                 ;C31459
	beq @lbl_C3145F                         ;C3145B
	lda #$BD                                ;C3145D
@lbl_C3145F:
	sta $00                                 ;C3145F
	stz $01                                 ;C31461
	jsl.l DisplayMessage
	rts                                     ;C31467
	sep #$20                                ;C31468
	lda #$32                                ;C3146A
	sta $01                                 ;C3146C
	lda #$13                                ;C3146E
	sta $00                                 ;C31470
	jsl $C24073                             ;C31472
	lda #$6B                                ;C31476
	sta $00                                 ;C31478
	stz $01                                 ;C3147A
	jsl.l DisplayMessage
	rts                                     ;C31480
	sep #$20                                ;C31481
	lda #$64                                ;C31483
	.db $80,$E5   ;C31485
	sep #$20                                ;C31487
	lda #$32                                ;C31489
	sta $01                                 ;C3148B
	lda $00                                 ;C3148D
	pha                                     ;C3148F
	jsl $C24073                             ;C31490
	pla                                     ;C31494
	sta $02                                 ;C31495
	lda #$35                                ;C31497
	sta $00                                 ;C31499
	stz $01                                 ;C3149B
	jsl.l DisplayMessage
	rts                                     ;C314A1
	sep #$30                                ;C314A2
	lda $00                                 ;C314A4
	pha                                     ;C314A6
	jsl $C2896D                             ;C314A7
	pla                                     ;C314AB
	sta $02                                 ;C314AC
	lda #$35                                ;C314AE
	ldx $00                                 ;C314B0
	beq @lbl_C314B6                         ;C314B2
	lda #$36                                ;C314B4
@lbl_C314B6:
	sta $00                                 ;C314B6
	stz $01                                 ;C314B8
	jsl.l DisplayMessage
	rts                                     ;C314BE
DragonHerbUseEffect:
	sep #$30 ;AXY->8
	lda.b #$13
	sta.b wTemp00
	lda.b #$87
	sta.b wTemp02
	jsl.l PlayCharacterEffect
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp00
	pha
	lda.b wTemp01
	pha
	lda.b wTemp02
	pha
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b #$FF
	sta.b wTemp01
	lda.b wTemp03,s
	sta.b wTemp02
	lda.b wTemp02,s
	sta.b wTemp03
	jsl.l func_C32FEE
	ldx.b wTemp00
	lda.b wTemp02
	sta.b wTemp06
	lda.b wTemp03
	sta.b wTemp07
	lda.b #$7F
	sta.b wTemp00
	lda.b #$0D
	sta.b wTemp01
	lda.b #$01
	sta.b wTemp02
	pla
	sta.b wTemp03
	pla
	sta.b wTemp05
	pla
	sta.b wTemp04
	phx
	jsl.l func_C626CA
	plx
	cpx.b #$00
	bmi @lbl_C31551
	stx.b wTemp00
	phx
	jsl.l func_C20E3A
	plx
	lda.b wTemp00
	bmi @lbl_C31551
	stx.b wTemp00
	phx
	jsl.l GetCharacterMapInfo
	plx
	lda.b wTemp04
	cmp.b #$08
	beq @lbl_C31552
	lda.b #$41
	sta.b wTemp00
	lda.b #$4B
	sta.b wTemp01
	phx
	jsl.l GetRandomInRange
	plx
	lda.b wTemp00
	sta.b wTemp02
	stx.b wTemp00
	lda.b #$13
	sta.b wTemp01
	jsl.l func_C228DF
@lbl_C31551:
	rts
@lbl_C31552:
	stx $00                                 ;C31552
	lda #$01                                ;C31554
	sta $01                                 ;C31556
	jsl ApplyCharacterLevelGains                             ;C31558
	rts                                     ;C3155C
SightHerbUseEffect:
	rep #$20 ;A->16
	lda.w #$0075
	sta.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C283A0
	lda.w #$0013
	sta.b wTemp00
	jsl.l func_C240A7
	jsl.l func_C35FA2
	rts
	rep #$30                                ;C31579
	lda #$004B                              ;C3157B
	sta $00                                 ;C3157E
.INDEX 8
	jsl.l DisplayMessage
	lda #$07D0                              ;C31585
	sta $00                                 ;C31588
	jsl ModifyShirenHunger                             ;C3158A
	ldx #$32                                ;C3158E
	.db $00   ;C31590
	jsr $15DF                               ;C31591
	lda #$07D0                              ;C31594
	sta $00                                 ;C31597
	jsl ModifyShirenHunger                             ;C31599
	rts                                     ;C3159D
OnigiriUseEffect:
	rep #$30 ;AXY->16
	ldx.w #$000A
	jsr.w func_C315DF
	bcc @lbl_C315A9
	rts
@lbl_C315A9:
	lda.w #$01F4
	bra func_C315BC

func_C315AE:
	rep #$30 ;AXY->16
	ldx.w #$0014
	jsr.w func_C315DF
	bcc @lbl_C315B9
	rts
@lbl_C315B9:
	lda.w #$03E8
func_C315BC:
	sta.b wTemp00
	jsl.l ModifyShirenHunger
	jsl.l GetShirenCoreStatus
	lda.b wTemp06
	pha
	jsl.l func_C2338A
	pla
	ldx.w #$004B
	cmp.b wTemp00
	bcs @lbl_C315D8
	ldx.w #$004D
@lbl_C315D8:
	stx.b wTemp00
	jsl.l DisplayMessage
	rts

func_C315DF:
	rep #$30 ;AXY->16
	phx
	jsl.l GetShirenCoreStatus
	lda.b wTemp06
	clc
	adc.w #$0005
	pha
	jsl.l func_C2338A
	pla
	cmp.b wTemp00
	bcs @lbl_C315F9
	plx
	clc
	rts
@lbl_C315F9:
	pla                                     ;C315F9
	sta $00                                 ;C315FA
	jsl ModifyShirenMaxHunger                             ;C315FC
	lda #$000A                              ;C31600
	sta $02                                 ;C31603
	jsl Divide16Bit                             ;C31605
	lda $00                                 ;C31609
	and #$00FF                              ;C3160B
	sta $02                                 ;C3160E
	lda #$004E                              ;C31610
	sta $00                                 ;C31613
	jsl.l DisplayMessage
	lda #$2710                              ;C31619
	sta $00                                 ;C3161C
	jsl ModifyShirenHunger                             ;C3161E
	sec                                     ;C31622
	rts                                     ;C31623
SpecialOnigiriUseEffect:
	rep #$30                                ;C31624
	ldx #$000A                              ;C31626
	jsr $15DF                               ;C31629
	bcs @lbl_C31634                         ;C3162C
	lda #$012C                              ;C3162E
	jsr $15BC                               ;C31631
@lbl_C31634:
	sep #$30                                ;C31634
@lbl_C31636:
	jsl $C3F65F                             ;C31636
	lda $00                                 ;C3163A
	and #$07                                ;C3163C
	cmp #$07                                ;C3163E
	bcs @lbl_C31636                         ;C31640
	asl a                                   ;C31642
	tax                                     ;C31643
	rep #$20                                ;C31644
	jmp ($1649,x)                           ;C31646
	eor [$16],y                             ;C31649
	.db $6D   ;C3164B
	.db $16   ;C3164C
	sta $16,s                               ;C3164D
	.db $99   ;C3164F
	.db $16   ;C31650
	lda $102216,x                           ;C31651
	.db $AD   ;C31655
	.db $16   ;C31656
	sep #$20                                ;C31657
	lda #$01                                ;C31659
	sta $00                                 ;C3165B
	jsl $C2332E                             ;C3165D
	rep #$20                                ;C31661
	lda #$00F9                              ;C31663
	sta $00                                 ;C31666
	jsl.l DisplayMessage
	rts                                     ;C3166C
	sep #$20                                ;C3166D
	lda #$01                                ;C3166F
	sta $00                                 ;C31671
	jsl $C23339                             ;C31673
	rep #$20                                ;C31677
	lda #$00FA                              ;C31679
	sta $00                                 ;C3167C
	jsl.l DisplayMessage
	rts                                     ;C31682
	sep #$20                                ;C31683
	lda #$00                                ;C31685
	sta $00                                 ;C31687
	jsl $C2337F                             ;C31689
	rep #$20                                ;C3168D
	lda #$00FB                              ;C3168F
	sta $00                                 ;C31692
	jsl.l DisplayMessage
	rts                                     ;C31698
	sep #$20                                ;C31699
	stz $00                                 ;C3169B
	jsl $C23374                             ;C3169D
	rep #$20                                ;C316A1
	lda #$00FC                              ;C316A3
	sta $00                                 ;C316A6
	jsl.l DisplayMessage
	rts                                     ;C316AC
	sep #$20                                ;C316AD
	jsl $C28488                             ;C316AF
	rep #$20                                ;C316B3
	lda #$0130                              ;C316B5
	sta $00                                 ;C316B8
	jsl.l DisplayMessage
	rts                                     ;C316BE
	sep #$20                                ;C316BF
	rep #$10                                ;C316C1
	lda #$13                                ;C316C3
	sta $00                                 ;C316C5
	jsl.l GetCharacterStats                             ;C316C7
	lda $01                                 ;C316CB
	sec                                     ;C316CD
	sbc $00                                 ;C316CE
	.db $F0,$19   ;C316D0
	sta $02                                 ;C316D2
	ldy #$0040                              ;C316D4
	sty $00                                 ;C316D7
	pha                                     ;C316D9
	jsl.l DisplayMessage
	pla                                     ;C316DD
	sta $02                                 ;C316DE
	stz $03                                 ;C316E0
	lda #$13                                ;C316E2
	sta $00                                 ;C316E4
	jsl ModifyCharacterHP                             ;C316E6
	rts                                     ;C316EA
SpoiledOnigiriUseEffect:
	rep #$20                                ;C316EC
	sep #$10                                ;C316EE
	ldy #$C6                                ;C316F0
	sty $00                                 ;C316F2
	jsl $C23BA6                             ;C316F4
	lda #$012C                              ;C316F8
	sta $00                                 ;C316FB
	jsl ModifyShirenHunger                             ;C316FD
	lda #$004C                              ;C31701
	sta $00                                 ;C31704
	jsl.l DisplayMessage
	lda #$003F                              ;C3170A
	sta $00                                 ;C3170D
	ldy #$05                                ;C3170F
	sty $02                                 ;C31711
	jsl.l DisplayMessage
	lda #$FFFB                              ;C31717
	sta $02                                 ;C3171A
	ldy #$13                                ;C3171C
	sty $00                                 ;C3171E
	jsl ModifyCharacterHP                             ;C31720
	sep #$20                                ;C31724
@lbl_C31726:
	jsl $C3F65F                             ;C31726
	lda $00                                 ;C3172A
	and #$07                                ;C3172C
	cmp #$06                                ;C3172E
	bcs @lbl_C31726                         ;C31730
	asl a                                   ;C31732
	tax                                     ;C31733
	rep #$20                                ;C31734
	lda $C3173C,x                           ;C31736
	pha                                     ;C3173A
	rts                                     ;C3173B
	.dw $1747                               ;C3173C
	.dw $1343                               ;C3173E
	.dw $1467                               ;C31740
	.dw $1410                               ;C31742
	.dw $13A0                               ;C31744
	.dw $10DA                               ;C31746
	rep #$20                                ;C31748
	sep #$10                                ;C3174A
	lda #$FFFD                              ;C3174C
	sta $00                                 ;C3174F
	jsl ModifyShirenStrength                             ;C31751
	ldy $00                                 ;C31755
	.db $F0,$0B   ;C31757
	lda #$00A0                              ;C31759
	sta $00                                 ;C3175C
	sty $02                                 ;C3175E
	jsl.l DisplayMessage
	rts                                     ;C31764
	rep #$20                                ;C31765
	lda #$007C                              ;C31767
	sta $00                                 ;C3176A
	jsl.l DisplayMessage
	sep #$20                                ;C31770
	rep #$10                                ;C31772
	lda #$13                                ;C31774
	sta $00                                 ;C31776
	jsl $C210AC                             ;C31778
	jsl $C3631A                             ;C3177C
	ldx $00                                 ;C31780
	bmi @lbl_C317A8                         ;C31782
	jsl $C62771                             ;C31784
	lda $00                                 ;C31788
	stx $00                                 ;C3178A
	sta $02                                 ;C3178C
	phx                                     ;C3178E
	jsl $C20BE7                             ;C3178F
	plx                                     ;C31793
	lda $00                                 ;C31794
	bmi @lbl_C317A8                         ;C31796
	stx $00                                 ;C31798
	sta $02                                 ;C3179A
	pha                                     ;C3179C
	jsl $C35B7A                             ;C3179D
	pla                                     ;C317A1
	sta $00                                 ;C317A2
	jsl $C27FAA                             ;C317A4
@lbl_C317A8:
	rts                                     ;C317A8
TrapScrollUseEffect:
	sep #$20 ;A->8                       ;C317A9
	rep #$10 ;XY->16                    ;C317AB
	ldx.w #$008C                        ;C317AD
	stx.b wTemp00                       ;C317B0
	jsl.l DisplayMessage
	lda.b #$1E                          ;C317B6
@lbl_C317B8:
	pha                                 ;C317B8
	jsl.l func_C36287                   ;C317B9
	ldx.b wTemp00                       ;C317BD
	bmi @lbl_C317DF                     ;C317BF
	jsl.l $C62771                       ;C317C1
	lda.b wTemp00                       ;C317C5
	stx.b wTemp00                       ;C317C7
	sta.b wTemp02                       ;C317C9
	phx                                 ;C317CB
	jsl.l func_C3D3AB                   ;C317CC
	plx                                 ;C317D0
	lda.b wTemp00                       ;C317D1
	bmi @lbl_C317DF                     ;C317D3
	stx.b wTemp00                       ;C317D5
	ora.b #$C0                          ;C317D7
	sta.b wTemp02                       ;C317D9
	jsl.l func_C35BA2                   ;C317DB
@lbl_C317DF:
	pla                                 ;C317DF
	dec a                               ;C317E0
	bne @lbl_C317B8                     ;C317E1
	lda.l $7E8975                       ;C317E3
	bit.b #$01                          ;C317E7
	beq @lbl_C317EF                     ;C317E9
	jsl.l func_C35FA2                   ;C317EB
@lbl_C317EF:
	rts                                 ;C317EF
	rep #$20                                ;C317EF
	lda #$0097                              ;C317F1
	sta $00                                 ;C317F4
.ACCU 8
	jsl.l DisplayMessage
	jsl $C27FBD                             ;C317FA
	rts                                     ;C317FE
	sep #$20                                ;C317FF
	jsl $C27F5A                             ;C31801
	lda $00                                 ;C31805
	.db $F0,$0C   ;C31807
	rep #$20                                ;C31809
	lda #$0068                              ;C3180B
	sta $00                                 ;C3180E
	jsl.l DisplayMessage
	rts                                     ;C31814
	rep #$20                                ;C31815
	lda #$005C                              ;C31817
	sta $00                                 ;C3181A
	jsl.l DisplayMessage
	rts                                     ;C31821
LightScrollUseEffect:
	rep #$20 ;A->16
	lda.w #$0013
	sta.b wTemp00
	lda.w #$0000
	sta.b wTemp02
	jsl.l func_C626F6
	lda.w #$0072
	sta.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C35E5A
	jsl.l func_C35F6D
	jsl.l func_C35EF8
	bra @lbl_C31849
@lbl_C31849:
	sep #$20 ;A->8
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStatusEffects
	lda.b wTemp00
	beq @lbl_C31862
	rep #$20                                ;C31857
	lda #$00B9                              ;C31859
	sta $00                                 ;C3185C
.ACCU 8
	jsl.l DisplayMessage
@lbl_C31862:
	rts
	rep #$20                                ;C31863
	lda #$0055                              ;C31865
	sta $00                                 ;C31868
.ACCU 8
	jsl.l DisplayMessage
	rts                                     ;C3186E
RemovalScrollUseEffect:
	rep #$20 ;A->16                    ;C3186F
	lda.w #$0162
	sta.b wTemp00
	jsl.l DisplayMessage
	rts
SilenceScrollUseEffect:
	rep #$20 ;A->16                    ;C3187B
	lda.w #$0013
	sta.b wTemp00
	lda.w #$00D1
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.w #$0084
	sta.b wTemp00
	jsl.l DisplayMessage
	sep #$20 ;A->8
	lda.b #$01
	sta.b wTemp00
	jsl.l $C2335A
	rts
BlastwaveScrollUseEffect:
	jsl.l func_C28672                   ;C3189F
	rts                                ;C318A3
HasteScrollUseEffect:
	jsl $C2876E                             ;C318A4
	rep #$20                                ;C318A8
	lda #$0163                              ;C318AA
	sta $00                                 ;C318AD
.ACCU 8
	jsl.l DisplayMessage
	rts                                     ;C318B3
SleepScrollUseEffect:
	jsl.l func_C28790
	rts
	sep #$20                                ;C318B9
	lda #$1E                                ;C318BB
	sta $00                                 ;C318BD
	jsl.l _GetEvent
	lda $00                                 ;C318C3
	.db $D0,$0B   ;C318C5
	lda #$5C                                ;C318C7
	sta $00                                 ;C318C9
	stz $01                                 ;C318CB
	jsl.l DisplayMessage
	rts                                     ;C318D1
	jsl $C28851                             ;C318D2
	rts                                     ;C318D6
ConfusionScrollUseEffect:
	jsl $C287DA                             ;C318D7
	rts                                     ;C318DB
ExplosionScrollUseEffect:
	jsl $C288A3                             ;C318DC
	rts                                     ;C318E0
PowerupScrollUseEffect:
	sep #$20 ;A->8
	lda.b #$13
	sta.b wTemp00
	lda.b #$CC
	sta.b wTemp02
	jsl.l PlayCharacterEffect
	lda.b #$0B
	sta.b wTemp00
	jsl.l func_C28418
	rts
MonsterHouseScrollUseEffect:
	jsl $C62B4D                             ;C318F8
	jsl $C369EA                             ;C318FC
	rts                                     ;C31900
IdentityScrollUseEffect:
	sep #$30 ;AXY->8
	ldy.b wTemp01
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$02
	beq @lbl_C3191D
	cmp.b #$03
	beq @lbl_C3191D
	jsl.l Random
	lda.b wTemp00
	and.b #$1F
	beq @lbl_C31927
@lbl_C3191D:
	sty.b wTemp00
	jsr.w func_C31959
	jsl.l func_C324F9
	rts
@lbl_C31927:
	ldy #$00                                ;C31927
@lbl_C31929:
	sty $00                                 ;C31929
	phy                                     ;C3192B
	jsl $C23B7C                             ;C3192C
	ply                                     ;C31930
	lda $00                                 ;C31931
	bmi @lbl_C3193E                         ;C31933
	phy                                     ;C31935
	jsl $C30192                             ;C31936
	ply                                     ;C3193A
	iny                                     ;C3193B
	bra @lbl_C31929                         ;C3193C
@lbl_C3193E:
	ldy #$1F                                ;C3193E
	sty $00                                 ;C31940
	jsr $1959                               ;C31942
	ldy $00                                 ;C31945
	bmi @lbl_C3194D                         ;C31947
	jsl $C30192                             ;C31949
@lbl_C3194D:
	rep #$20                                ;C3194D
	lda #$00B4                              ;C3194F
	sta $00                                 ;C31952
	jsl.l DisplayMessage
	rts                                     ;C31958

func_C31959:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b #$1F
	beq @lbl_C31968
	jsl.l func_C23B7C
	plp
	rts
@lbl_C31968:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	jsl.l GetItemData
	lda.b wTemp01
	sta.b wTemp00
	plp
	rts
	sep #$30                                ;C3197A
	phy                                     ;C3197C
	lda $01                                 ;C3197D
	sta $00                                 ;C3197F
	jsr $1959                               ;C31981
	lda $00                                 ;C31984
	ply                                     ;C31986
	cpy $00                                 ;C31987
	.db $D0,$0B   ;C31989
	lda #$5C                                ;C3198B
	sta $00                                 ;C3198D
	stz $01                                 ;C3198F
	jsl.l DisplayMessage
	rts                                     ;C31995
	tax                                     ;C31996
	lda #$00                                ;C31997
	sta $7E8C0C,x                           ;C31999
	jsl $C23B89                             ;C3199D
	cpx $00                                 ;C319A1
	bne @lbl_C319AF                         ;C319A3
	stx $00                                 ;C319A5
	phx                                     ;C319A7
	jsl $C23C02                             ;C319A8
	plx                                     ;C319AC
	bra @lbl_C319D5                         ;C319AD
@lbl_C319AF:
	cpx $01                                 ;C319AF
	bne @lbl_C319BD                         ;C319B1
	stx $00                                 ;C319B3
	phx                                     ;C319B5
	jsl $C23C10                             ;C319B6
	plx                                     ;C319BA
	bra @lbl_C319D5                         ;C319BB
@lbl_C319BD:
	cpx $02                                 ;C319BD
	bne @lbl_C319CB                         ;C319BF
	stx $00                                 ;C319C1
	phx                                     ;C319C3
	jsl $C23C09                             ;C319C4
	plx                                     ;C319C8
	bra @lbl_C319D5                         ;C319C9
@lbl_C319CB:
	cpx $03                                 ;C319CB
	bne @lbl_C319D5                         ;C319CD
	stx $00                                 ;C319CF
	jsl $C23BE1                             ;C319D1
@lbl_C319D5:
	stx $02                                 ;C319D5
	lda #$15                                ;C319D7
	sta $00                                 ;C319D9
	stz $01                                 ;C319DB
	phx                                     ;C319DD
	jsl.l DisplayMessage
	plx                                     ;C319E1
	lda #$AF                                ;C319E2
	sta $7E8B8C,x                           ;C319E4
	lda #$00                                ;C319E8
	sta $7E8D8C,x                           ;C319EA
	lda $7E8E0C,x                           ;C319EE
	cmp #$FF                                ;C319F2
	beq @lbl_C31A02                         ;C319F4
	sta $00                                 ;C319F6
	lda #$FF                                ;C319F8
	sta $7E8E0C,x                           ;C319FA
	jsl $C306F4                             ;C319FE
@lbl_C31A02:
	rts                                     ;C31A02
BigpotScrollUseEffect:
	sep #$30                                ;C31A04
	ldx $01                                 ;C31A06
	stx $00                                 ;C31A08
	jsr $1959                               ;C31A0A
	ldx $00                                 ;C31A0D
	txy                                     ;C31A0F
	lda $7E8B8C,x                           ;C31A10
	tax                                     ;C31A14
	lda $C341BB,x                           ;C31A15
	tyx                                     ;C31A19
	cmp #$0B                                ;C31A1A
	.db $D0,$38   ;C31A1C
	phx                                     ;C31A1E
	ldy #$FF                                ;C31A1F
@lbl_C31A21:
	iny                                     ;C31A21
	lda $7E8E0C,x                           ;C31A22
	tax                                     ;C31A26
	cmp #$FF                                ;C31A27
	bne @lbl_C31A21                         ;C31A29
	plx                                     ;C31A2B
	tya                                     ;C31A2C
	clc                                     ;C31A2D
	adc $7E8C8C,x                           ;C31A2E
	ldy #$01                                ;C31A32
	cmp #$0A                                ;C31A34
	bcc @lbl_C31A3A                         ;C31A36
	ldy #$00                                ;C31A38
@lbl_C31A3A:
	sty $03                                 ;C31A3A
	phy                                     ;C31A3C
	lda #$12                                ;C31A3D
	sta $00                                 ;C31A3F
	stz $01                                 ;C31A41
	stx $02                                 ;C31A43
	phx                                     ;C31A45
	jsl.l DisplayMessage
	plx                                     ;C31A4A
	pla                                     ;C31A4B
	clc                                     ;C31A4C
	adc $7E8C8C,x                           ;C31A4D
	sta $7E8C8C,x                           ;C31A51
	rts                                     ;C31A55
	lda #$5C                                ;C31A56
	sta $00                                 ;C31A58
	stz $01                                 ;C31A5A
	jsl.l DisplayMessage
	rts                                     ;C31A60
	sep #$20                                ;C31A61
	jsl $C2487E                             ;C31A63
	lda $00                                 ;C31A67
	bne @lbl_C31A70                         ;C31A69
	jsl $C27F4F                             ;C31A6B
	rts                                     ;C31A6F
@lbl_C31A70:
	lda #$C5                                ;C31A70
	sta $00                                 ;C31A72
	stz $01                                 ;C31A74
	jsl.l DisplayMessage
	rts                                     ;C31A7A
	rep #$20                                ;C31A7B
	sep #$10                                ;C31A7D
	lda #$0089                              ;C31A7F
	sta $00                                 ;C31A82
	phy                                     ;C31A84
.ACCU 8
	jsl.l DisplayMessage
	ply                                     ;C31A88
	sty $00                                 ;C31A8A
	jsl $C62A63                             ;C31A8C

;c31a90
WeaponUseEffect:
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	phy
	jsr.w func_C31AB4
	lda.b #$00
	sta.b wTemp00
	sta.b wTemp01
	plx
	pla
	beq @lbl_C31AAF
	lda.l wItemFuseAbility1,x
	sta.b wTemp00
	lda.l wItemFuseAbility2,x
	sta.b wTemp01
@lbl_C31AAF:
	jsl.l func_C284B2
	rts

func_C31AB4:
	sep #$30 ;AXY->8
	ldx.w wItemType,y
	lda.l DATA8_C342A3,x
	clc
	adc.w wItemModification1,y
	ldx.b wTemp00
	bne @lbl_C31AC8
	eor.b #$FF
	inc a
@lbl_C31AC8:
	sta.b wTemp00
	jsl.l func_C2342B
	rts
AirBlessScrollUseEffect:
	sep #$30                                ;C31ACF
	jsl $C23B89                             ;C31AD1
	ldx $00                                 ;C31AD5
	.db $30,$54   ;C31AD7
	lda #$13                                ;C31AD9
	sta $00                                 ;C31ADB
	lda #$C8                                ;C31ADD
	sta $02                                 ;C31ADF
	phx                                     ;C31AE1
	phb                                     ;C31AE2
	jsl PlayCharacterEffect                             ;C31AE3
	plb                                     ;C31AE7
	plx                                     ;C31AE8
	lda $8C8C,x                             ;C31AE9
	cmp #$63                                ;C31AEC
	.db $F0,$3D   ;C31AEE
	lda #$AA                                ;C31AF0
	sta $00                                 ;C31AF2
	stz $01                                 ;C31AF4
	stx $02                                 ;C31AF6
	phx                                     ;C31AF8
	phb                                     ;C31AF9
	jsl.l DisplayMessage
	plb                                     ;C31AFD
	plx                                     ;C31AFF
	lda $8C8C,x                             ;C31B00
	inc a                                   ;C31B03
	sta $8C8C,x                             ;C31B04
	lda #$AB                                ;C31B07
	sta $00                                 ;C31B09
	stz $01                                 ;C31B0B
	stx $02                                 ;C31B0D
	phx                                     ;C31B0F
	phb                                     ;C31B10
	jsl.l DisplayMessage
	plb                                     ;C31B14
	plx                                     ;C31B15
	lda $8C0C,x                             ;C31B16
	.db $F0,$0D   ;C31B19
	stz $8C0C,x                             ;C31B1B
	lda #$52                                ;C31B1E
	sta $00                                 ;C31B20
	stz $01                                 ;C31B22
	jsl.l DisplayMessage
	lda #$01                                ;C31B28
	.db $80,$9B   ;C31B2A
	lda #$5C                                ;C31B2C
	sta $00                                 ;C31B2E
	stz $01                                 ;C31B30
	jsl.l DisplayMessage
	rts                                     ;C31B37

;c31b38
ShieldUseEffect:
	sep #$30 ;AXY->8
	lda.b wTemp00
	pha
	phy
	jsr.w func_C31B5C
	lda.b #$00
	sta.b wTemp00
	sta.b wTemp01
	plx
	pla
	beq @lbl_C31B57
	lda.l wItemFuseAbility1,x
	sta.b wTemp00
	lda.l wItemFuseAbility2,x
	sta.b wTemp01
@lbl_C31B57:
	jsl.l func_C284BD
	rts

func_C31B5C:
	sep #$30 ;AXY->8
	ldx.w wItemType,y
	lda.l DATA8_C342A3,x
	clc
	adc.w wItemModification1,y
	ldx.b wTemp00
	bne @lbl_C31B70
	eor.b #$FF
	inc a
@lbl_C31B70:
	sta.b wTemp01
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C234BF
	rts
EarthBlessScrollUseEffect:
	sep #$30                                ;C31B7B
	jsl $C23B89                             ;C31B7D
	ldx $01                                 ;C31B81
	.db $30,$54   ;C31B83
	lda #$13                                ;C31B85
	sta $00                                 ;C31B87
	lda #$C9                                ;C31B89
	sta $02                                 ;C31B8B
	phx                                     ;C31B8D
	phb                                     ;C31B8E
	jsl PlayCharacterEffect                             ;C31B8F
	plb                                     ;C31B93
	plx                                     ;C31B94
	lda $8C8C,x                             ;C31B95
	cmp #$63                                ;C31B98
	.db $F0,$3D   ;C31B9A
	lda #$AA                                ;C31B9C
	sta $00                                 ;C31B9E
	stz $01                                 ;C31BA0
	stx $02                                 ;C31BA2
	phx                                     ;C31BA4
	phb                                     ;C31BA5
	jsl.l DisplayMessage
	plb                                     ;C31BA9
	plx                                     ;C31BAB
	lda $8C8C,x                             ;C31BAC
	inc a                                   ;C31BAF
	sta $8C8C,x                             ;C31BB0
	lda #$AB                                ;C31BB3
	sta $00                                 ;C31BB5
	stz $01                                 ;C31BB7
	stx $02                                 ;C31BB9
	phx                                     ;C31BBB
	phb                                     ;C31BBC
	jsl.l DisplayMessage
	plb                                     ;C31BC0
	plx                                     ;C31BC1
	lda $8C0C,x                             ;C31BC2
	.db $F0,$0D   ;C31BC5
	stz $8C0C,x                             ;C31BC7
	lda #$52                                ;C31BCA
	sta $00                                 ;C31BCC
	stz $01                                 ;C31BCE
	jsl.l DisplayMessage
	lda #$01                                ;C31BD4
	.db $80,$97   ;C31BD6
	lda #$5C                                ;C31BD8
	sta $00                                 ;C31BDA
	stz $01                                 ;C31BDC
	jsl.l DisplayMessage
	rts                                     ;C31BE3
PlatingScrollUseEffect:
	sep #$30                                ;C31BE4
	jsl $C23B89                             ;C31BE6
	lda $00                                 ;C31BEA
	and $01                                 ;C31BEC
	.db $30,$75   ;C31BEE
	lda $01                                 ;C31BF0
	pha                                     ;C31BF2
	lda $00                                 ;C31BF3
	pha                                     ;C31BF5
	bmi @lbl_C31C04                         ;C31BF6
	lda #$13                                ;C31BF8
	sta $00                                 ;C31BFA
	lda #$CA                                ;C31BFC
	sta $02                                 ;C31BFE
	jsl PlayCharacterEffect                             ;C31C00
@lbl_C31C04:
	lda $02,s                               ;C31C04
	bmi @lbl_C31C14                         ;C31C06
	lda #$13                                ;C31C08
	sta $00                                 ;C31C0A
	lda #$CB                                ;C31C0C
	sta $02                                 ;C31C0E
	jsl PlayCharacterEffect                             ;C31C10
@lbl_C31C14:
	lda #$8E                                ;C31C14
	sta $00                                 ;C31C16
	stz $01                                 ;C31C18
	jsl.l DisplayMessage
	plx                                     ;C31C1E
	.db $30,$20   ;C31C1F
	lda $7E8F8C,x                           ;C31C21
	ora #$08                                ;C31C25
	sta $7E8F8C,x                           ;C31C27
	lda $7E8C0C,x                           ;C31C2B
	.db $F0,$10   ;C31C2F
	lda #$00                                ;C31C31
	sta $7E8C0C,x                           ;C31C33
	lda #$52                                ;C31C37
	sta $00                                 ;C31C39
	stz $01                                 ;C31C3B
	jsl.l DisplayMessage
	plx                                     ;C31C41
	.db $30,$20   ;C31C42
	lda $7E8F8C,x                           ;C31C44
	ora #$08                                ;C31C48
	sta $7E8F8C,x                           ;C31C4A
	lda $7E8C0C,x                           ;C31C4E
	.db $F0,$10   ;C31C52
	lda #$00                                ;C31C54
	sta $7E8C0C,x                           ;C31C56
	lda #$52                                ;C31C5A
	sta $00                                 ;C31C5C
	stz $01                                 ;C31C5E
	jsl.l DisplayMessage
	rts                                     ;C31C64
	lda #$5C                                ;C31C65
	sta $00                                 ;C31C67
	stz $01                                 ;C31C69
	jsl.l DisplayMessage
	rts                                     ;C31C6F
BlessingScrollUseEffect:
	sep #$30 ;AXY->8
	lda.b #$13
	sta.b wTemp00
	lda.b #$CD
	sta.b wTemp02
	call_savebank PlayCharacterEffect
	jsl.l GetCategoryShortcutItemIds
	ldx.b wTemp02
	phx
	ldx.b wTemp01
	phx
	ldx.b wTemp00
	phx
	ldy.b #$03
@lbl_C31C8F:
	plx
	bmi @lbl_C31C97
	lda.w wItemIsCursed,x
	bne @lbl_C31CAD
@lbl_C31C97:
	dey
	bne @lbl_C31C8F
	lda #$5C                                ;C31C9A
	sta $00                                 ;C31C9C
	stz $01                                 ;C31C9E
	jsl.l DisplayMessage
	rts                                     ;C31CA4
@lbl_C31CA5:
	plx                                     ;C31CA5
	.db $30,$18   ;C31CA6
	lda $8C0C,x                             ;C31CA8
	.db $F0,$13   ;C31CAB
@lbl_C31CAD:
	stz.w wItemIsCursed,x
	lda.b #$8F
	sta.b wTemp00
	stz.b wTemp01
	stx.b wTemp02
	phy
	call_savebank DisplayMessage
	ply
	dey
	bne @lbl_C31CA5
	rts
	sep #$30                                ;C31CC4
	jsl $C23B89                             ;C31CC6
	ldx $02                                 ;C31CCA
	phx                                     ;C31CCC
	ldx $01                                 ;C31CCD
	phx                                     ;C31CCF
	ldx $00                                 ;C31CD0
	phx                                     ;C31CD2
	ldy #$03                                ;C31CD3
@lbl_C31CD5:
	plx                                     ;C31CD5
	bmi @lbl_C31CDD                         ;C31CD6
	lda $8C0C,x                             ;C31CD8
	.db $F0,$16   ;C31CDB
@lbl_C31CDD:
	dey                                     ;C31CDD
	bne @lbl_C31CD5                         ;C31CDE
	lda #$5C                                ;C31CE0
	sta $00                                 ;C31CE2
	stz $01                                 ;C31CE4
	jsl.l DisplayMessage
	rts                                     ;C31CEA
	plx                                     ;C31CEB
	.db $30,$1A   ;C31CEC
	lda $8C0C,x                             ;C31CEE
	.db $D0,$15   ;C31CF1
	lda #$01                                ;C31CF3
	sta $8C0C,x                             ;C31CF5
	lda #$8D                                ;C31CF8
	sta $00                                 ;C31CFA
	stz $01                                 ;C31CFC
	stx $02                                 ;C31CFE
	phy                                     ;C31D00
	phb                                     ;C31D01
	jsl.l DisplayMessage
	plb                                     ;C31D06
	ply                                     ;C31D07
	dey                                     ;C31D08
	.db $D0,$E0   ;C31D09
	rts                                     ;C31D0B
	sep #$30                                ;C31D0C
	lda #$01                                ;C31D0E
	ldx $00                                 ;C31D10
	bne @lbl_C31D16                         ;C31D12
	lda #$00                                ;C31D14
@lbl_C31D16:
	sta $00                                 ;C31D16
	jsl $C23309                             ;C31D18
	rts                                     ;C31D1C
	sep #$30                                ;C31D1D
	lda #$01                                ;C31D1F
	ldx $00                                 ;C31D21
	bne @lbl_C31D27                         ;C31D23
	lda #$00                                ;C31D25
@lbl_C31D27:
	sta $00                                 ;C31D27
	jsl $C23314                             ;C31D29
	rts                                     ;C31D2D
	sep #$30                                ;C31D2E
	lda #$01                                ;C31D30
	ldx $00                                 ;C31D32
	bne @lbl_C31D38                         ;C31D34
	lda #$00                                ;C31D36
@lbl_C31D38:
	sta $00                                 ;C31D38
	jsl $C23323                             ;C31D3A
	rts                                     ;C31D3E
	sep #$30                                ;C31D3F
	lda #$01                                ;C31D41
	ldx $00                                 ;C31D43
	bne @lbl_C31D49                         ;C31D45
	lda #$00                                ;C31D47
@lbl_C31D49:
	sta $00                                 ;C31D49
	jsl $C23344                             ;C31D4B
	rts                                     ;C31D4F
	sep #$30                                ;C31D50
	lda $8C8C,y                             ;C31D52
	ldx $00                                 ;C31D55
	bne @lbl_C31D5C                         ;C31D57
	eor #$FF                                ;C31D59
	inc a                                   ;C31D5B
@lbl_C31D5C:
	cmp #$00                                ;C31D5C
	bmi @lbl_C31D6F                         ;C31D5E
	sta $00                                 ;C31D60
	pha                                     ;C31D62
	jsl ModifyShirenMaxStrength                             ;C31D63
	pla                                     ;C31D67
	sta $00                                 ;C31D68
	jsl ModifyShirenStrength                             ;C31D6A
	rts                                     ;C31D6E
@lbl_C31D6F:
	sta $00                                 ;C31D6F
	pha                                     ;C31D71
	jsl ModifyShirenStrength                             ;C31D72
	pla                                     ;C31D76
	sta $00                                 ;C31D77
	jsl ModifyShirenMaxStrength                             ;C31D79
	rts                                     ;C31D7D
	jsl $C283B3                             ;C31D7E
	rts                                     ;C31D82
	sep #$30 ;AXY->8
	jsl.l func_C283D2
	rts
	sep #$30                                ;C31D8A
	jsl $C283E1                             ;C31D8C
	rts                                     ;C31D90
	sep #$30                                ;C31D91
	jsl $C283EC                             ;C31D93
	rts                                     ;C31D97
	sep #$30                                ;C31D98
	jsl $C283F7                             ;C31D9A
	rts                                     ;C31D9E
	sep #$30                                ;C31D9F
	jsl $C28402                             ;C31DA1
	rts                                     ;C31DA5
	sep #$30                                ;C31DA6
	jsl $C2840D                             ;C31DA8
	rts                                     ;C31DAC
	sep #$30                                ;C31DAD
	jsl $C2845C                             ;C31DAF
	rts                                     ;C31DB3
	sep #$30                                ;C31DB4
	jsl $C28467                             ;C31DB6
	rts                                     ;C31DBA
	sep #$30                                ;C31DBB
	jsl $C2847D                             ;C31DBD
	rts                                     ;C31DC1
	sep #$30                                ;C31DC2
	jsl $C28497                             ;C31DC4
	rts                                     ;C31DC8
	rts
	sep #$30                                ;C31DCA
	ldy $00                                 ;C31DCC
	ldx $01                                 ;C31DCE
	lda #$12                                ;C31DD0
	sta $00                                 ;C31DD2
	lda #$16                                ;C31DD4
	sta $01                                 ;C31DD6
	phx                                     ;C31DD8
	phy                                     ;C31DD9
	jsl $C3F69F                             ;C31DDA
	ply                                     ;C31DDE
	plx                                     ;C31DDF
	lda $00                                 ;C31DE0
	sta $02                                 ;C31DE2
	stx $01                                 ;C31DE4
	sty $00                                 ;C31DE6
	jsl $C228DF                             ;C31DE8
	rts                                     ;C31DEC
	jsl.l func_C24390
	rts
	jsl $C240D6                             ;C31DF2
	jsl $C25DA2                             ;C31DF6
	rts                                     ;C31DFA
	jsl.l func_C240BC
	rts
	sep #$20                                ;C31E00
	lda #$06                                ;C31E02
	sta $01                                 ;C31E04
	jsl $C24080                             ;C31E06
	rts                                     ;C31E0A
	rts                                     ;C31E0B
KnockbackStaffUseEffect:
	jsl.l func_C2444B
	rts
DoppelgangerStaffUseEffect:
	sep #$20 ;A->8
	lda.b #$32
	sta.b wTemp01
	jsl.l func_C2402A
	rts
SwitchingStaffUseEffect:
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	xba
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp00
	pha
	lda.b wTemp03,s
	sta.b wTemp00
	ldx.b #$0F
	stx.b wTemp02
	jsl.l func_C210FF
	pla
	sta.b wTemp06
	lda.b wTemp04
	pha
	jsl.l func_C626A0
	lda.b wTemp04,s
	sta.b wTemp00
	ldx.b #$10
	stx.b wTemp02
	jsl.l func_C210FF
	pla
	sta.b wTemp06
	jsl.l func_C626A0
	pla
	sta.b wTemp00
	jsl.l func_C289F5
	rts
BufusStaffUseEffect:
	rep #$20 ;A->16
	sep #$10 ;XY->8
	ldx.b wTemp00
	cpx.b #$13
	beq @lbl_C31EB5
	stx.b wTemp00
	phx
	jsl.l GetCharacterMapInfo
	plx
	ldy.b wTemp03
	cpy.b #$3C
	bcs @lbl_C31EB4
	cpy.b #$28
	beq @lbl_C31EB4
	lda.b wTemp00
	pha
	phy
	stx.b wTemp00
	phx
	jsl.l HandleCharacterDeath
	plx
	stx.b wTemp00
	phx
	jsl.l func_C625B9
	plx
	stx.b wTemp00
	jsl.l GetCharacterStats
	ply
	ldx.b #$E0
	stx.b wTemp00
	sty.b wTemp01
	ldx.b wTemp05
	stx.b wTemp02
	jsl.l SpawnFloorItem
	ldx.b wTemp00
	cpx.b #$FF
	beq @lbl_C31EB3
	pla
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C330D1
	rts
@lbl_C31EB3:
	pla                                     ;C31EB3
@lbl_C31EB4:
	rts
@lbl_C31EB5:
	jsl $C2433A                             ;C31EB5
	lda #$0001                              ;C31EB9
	sta $02                                 ;C31EBC
	jsl $C625E5                             ;C31EBE
	rts                                     ;C31EC2
SkullStaffUseEffect:
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	ldx.b wTemp01
	lda.l $7E935D
	bpl @lbl_C31ED4
;C31ED2  
	ldx $00                                 ;C31ED2
@lbl_C31ED4:
	stx.b wTemp00
	phx
	jsl.l GetCharacterMapInfo
	plx
	ldy.b wTemp04
	cpy.b #$00
	bne func_C31EFB
	jsl.l Random
	lda.b wTemp00
	and.w #$0003
	asl a
	tax
	pla
	sta.b wTemp00
	jmp.w (Jumptable_C31EF3,x)

Jumptable_C31EF3:
	.dw $1DF2
	.dw $1E00
	.dw $1FFE
	.dw $1DED

func_C31EFB:
	sep #$30 ;AXY->8
	stx.b wTemp00
	jsl.l GetCharacterStats
	lda.b wTemp05
	dec a
	asl a
	asl a
	asl a
	pha
@loop:
	sep #$20 ;A->8
	jsl.l Random
	lda.b wTemp00
	and.b #$07
	ora.b wTemp01,s
	asl a
	tax
	rep #$20 ;A->16
	lda.l Jumptable_C31F29,x
	beq @loop ;go back if the chosen jumptable entry was null
	ply
	rep #$20 ;A->16
	pla
	sta.b wTemp00
	jmp.w (Jumptable_C31F29,x)

Jumptable_C31F29:
	.dw $1DFB
	.dw $0000
	.dw $1E0C
	.dw $1E1C
	.dw $1DED
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $1FFE
	.dw $206F
	.dw $2048
	.dw $1DCA
	.dw $1FCC
	.dw $0000
	.dw $0000
	.dw MisfortuneStaffUseEffect
	.dw $1E00
	.dw $1DF2
	.dw $1E5E
	.dw $203E
	.dw $1E11
	.dw $0000
	.dw $0000
HappinessStaffUseEffect:
	.dw $30E2
	.dw $00A5
	.dw $13C9
	.dw $1DD0
	.dw $F4A9
	.dw $0285
	.dw $01A9
	.dw $0385
	.dw $00A9
	.dw $0485
	.dw $D322
	.dw $C234
	.dw $13A9
	.dw $0085
	.dw $01A9
	.dw $0285
	.dw $5022
	.dw $C625
	.dw $2260
	.dw $25CE
	.dw $A9C6
	.dw $8501
	.dw $A501
	.dw $4800
	.dw $7922
	.dw $C235
	.dw $8568
	.dw $A900
	.dw $8501
	.dw $2202
	.dw $262B
	.dw $60C6

MisfortuneStaffUseEffect:
	sep #$20 ;A->8
	jsl.l func_C625CE
	lda.b #$FF
	sta.b wTemp01
	lda.b wTemp00
	pha
	jsl.l ApplyCharacterLevelGains
	pla
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp02
	jsl.l func_C6262B
	rts
	sep #$20                                ;C31FB6
	jsl $C2816C                             ;C31FB8
	lda $00                                 ;C31FBC
	.db $D0,$0B   ;C31FBE
	rep #$20                                ;C31FC0
	lda #$005C                              ;C31FC2
	sta $00                                 ;C31FC5
	jsl.l DisplayMessage
	rts                                     ;C31FCB
	sep #$30                                ;C31FCC
	ldy $00                                 ;C31FCE
	phy                                     ;C31FD0
	jsl $C2801B                             ;C31FD1
	ply                                     ;C31FD5
	cpy #$13                                ;C31FD6
	beq @lbl_C31FFD                         ;C31FD8
	cpy $00                                 ;C31FDA
	beq @lbl_C31FF5                         ;C31FDC
	ldx $00                                 ;C31FDE
	.db $E0   ;C31FE0
	sbc $A90AF0,x                           ;C31FE1
	.db $02   ;C31FE5
	sta $02                                 ;C31FE6
	phy                                     ;C31FE8
	jsl PlayVisualEffect                             ;C31FE9
	ply                                     ;C31FED
	sty $00                                 ;C31FEE
	jsl $C625B9                             ;C31FF0
	rts                                     ;C31FF4
@lbl_C31FF5:
	lda #$01                                ;C31FF5
	sta $02                                 ;C31FF7
	jsl PlayVisualEffect                             ;C31FF9
@lbl_C31FFD:
	rts                                     ;C31FFD
	sep #$20                                ;C31FFE
	lda #$0B                                ;C32000
	sta $01                                 ;C32002
	jsl $C23FFF                             ;C32004
	rts                                     ;C32008
InvisibilityHerbUseEffect:
	sep #$20                                ;C32009
	lda #$13                                ;C3200B
	sta $00                                 ;C3200D
	lda #$15                                ;C3200F
	sta $01                                 ;C32011
	lda $00                                 ;C32013
	pha                                     ;C32015
	jsl $C282F8                             ;C32016
	pla                                     ;C3201A
	sta $02                                 ;C3201B
	rep #$20                                ;C3201D
	lda #$015D                              ;C3201F
	sta $00                                 ;C32022
	jsl.l DisplayMessage
	rts                                     ;C32028
InvisibilityHerbThrowEffect:
	sep #$20                                ;C32029
	lda #$15                                ;C3202B
	sta $01                                 ;C3202D
	lda $00                                 ;C3202F
	jsl $C282F8                             ;C32031
	lda #$01                                ;C32035
	sta $02                                 ;C32037
	jsl PlayVisualEffect                             ;C32039
	rts                                     ;C3203D
SlothStaffUseEffect:
	jsl $C28305                             ;C3203E
	rts                                     ;C32042
	jsl $C28350                             ;C32043
	rts                                     ;C32047
ParalysisStaffUseEffect:
	sep #$20 ;A->8
	lda.b #$03
	sta.b wTemp02
	lda.b wTemp00
	pha
	jsl.l PlayVisualEffect
	pla
	sta.b wTemp00
	lda.b wTemp00
	pha
	jsl.l func_C27EA9
	pla
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp02
	jsl.l PlayVisualEffect
	jsl.l func_C625CE
	rts
PostponeStaffUseEffect:
	sep #$30 ;AXY->8
	ldx.b wTemp00
	phx
	stx.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b #$80
	sta.b wTemp02
	jsl.l func_C35B7A
	jsl.l func_C36778
	lda.b wTemp00
	bmi @lbl_C320A8
	jsl.l func_C3631A
	lda.b wTemp00
	bmi @lbl_C320A8
	plx
	stx.b wTemp00
	sta.b wTemp02
	lda.b wTemp01
	sta.b wTemp03
	phx
	jsl.l func_C24380
	plx
	stx.b wTemp00
	jsl.l func_C27E92
	rts
@lbl_C320A8:
	plx                                     ;C320A8
	stx $00                                 ;C320A9
	jsl $C24390                             ;C320AB
	rts                                     ;C320AF
PainSplitStaffUseEffect:
	sep #$30 ;AXY->8
	jsl.l func_C28451
	rts
	sep #$30                                ;C320B7
	ldy $00                                 ;C320B9
	ldx $01                                 ;C320BB
	phx                                     ;C320BD
	jsl.l GetCharacterStats                             ;C320BE
	plx                                     ;C320C2
	lda $00                                 ;C320C3
	cmp #$01                                ;C320C5
	beq @lbl_C320DB                         ;C320C7
	eor #$FF                                ;C320C9
	inc a                                   ;C320CB
	inc a                                   ;C320CC
	sta $02                                 ;C320CD
	lda #$FF                                ;C320CF
	sta $03                                 ;C320D1
	sty $00                                 ;C320D3
	phx                                     ;C320D5
	jsl ModifyCharacterHP                             ;C320D6
	plx                                     ;C320DA
@lbl_C320DB:
	stx $00                                 ;C320DB
	phx                                     ;C320DD
	jsl.l GetCharacterStats                             ;C320DE
	plx                                     ;C320E2
	lda $00                                 ;C320E3
	lsr a                                   ;C320E5
	eor #$FF                                ;C320E6
	inc a                                   ;C320E8
	beq @lbl_C320F7                         ;C320E9
	sta $02                                 ;C320EB
	lda #$FF                                ;C320ED
	sta $03                                 ;C320EF
	stx $00                                 ;C320F1
	jsl ModifyCharacterHP                             ;C320F3
@lbl_C320F7:
	rts                                     ;C320F7
	sep #$30                                ;C320F8
	ldy $00                                 ;C320FA
	ldx $01                                 ;C320FC
	stx $00                                 ;C320FE
	phx                                     ;C32100
	jsl.l GetCharacterStats                             ;C32101
	plx                                     ;C32105
	lda $00                                 ;C32106
	lsr a                                   ;C32108
	pha                                     ;C32109
	eor #$FF                                ;C3210A
	inc a                                   ;C3210C
	beq @lbl_C3211D                         ;C3210D
	sta $02                                 ;C3210F
	lda #$FF                                ;C32111
	sta $03                                 ;C32113
	stx $00                                 ;C32115
	phy                                     ;C32117
	jsl ModifyCharacterHP                             ;C32118
	ply                                     ;C3211C
@lbl_C3211D:
	pla                                     ;C3211D
	sta $02                                 ;C3211E
	stz $03                                 ;C32120
	sty $00                                 ;C32122
	jsl ModifyCharacterHP                             ;C32124
	rts                                     ;C32128
GreatHallScrollUseEffect:
	sep #$20                                ;C32129
	jsl $C369DF                             ;C3212B
	lda $00                                 ;C3212F
	.db $D0,$29   ;C32131
	jsl $C627DB                             ;C32133
	lda $00                                 ;C32137
	cmp #$0A                                ;C32139
	.db $F0,$1F   ;C3213B
	cmp #$0C                                ;C3213D
	.db $F0,$1B   ;C3213F
	lda #$13                                ;C32141
	sta $00                                 ;C32143
	lda #$03                                ;C32145
	sta $02                                 ;C32147
	jsl $C626F6                             ;C32149
	jsl $C366F6                             ;C3214D
	lda #$E7                                ;C32151
	sta $00                                 ;C32153
	stz $01                                 ;C32155
	jsl.l DisplayMessage
	rts                                     ;C3215B
	lda #$5C                                ;C3215C
	sta $00                                 ;C3215E
	stz $01                                 ;C32160
	jsl.l DisplayMessage
	rts                                     ;C32166
NeedScrollUseEffect:
	sep #$30 ;AXY->8
	ldy.b #$01
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStats
	lda.b wTemp01
	sec
	sbc.b wTemp00
	beq @lbl_C3219B
	pha
	dey
	sta.b wTemp02
	lda.b #$40
	sta.b wTemp00
	lda.b #$00
	sta.b wTemp01
	phy
	jsl.l DisplayMessage
	ply
	lda.b #$13
	sta.b wTemp00
	pla
	sta.b wTemp02
	stz.b wTemp03
	phy
	jsl.l ModifyCharacterHP
	ply
@lbl_C3219B:
	phy
	jsl.l func_C27F5A
	ply
	lda.b wTemp00
	beq @lbl_C321B0
	lda.b #$68
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	rts
@lbl_C321B0:
	jsl.l GetShirenCoreStatus
	lda.b wTemp06
	ora.b wTemp07
	bne @lbl_C321BD
;C321BA  
	jmp $15AE                               ;C321BA
@lbl_C321BD:
	lda.b #$13
	sta.b wTemp00
	phy
	jsl.l GetCharacterStatusEffects
	ply
	lda.b wTemp01
	ora.b wTemp03
	ora.b wTemp00
	beq @lbl_C321D2
;C321CF  
	jmp $0F95                               ;C321CF
@lbl_C321D2:
	jsl.l func_C21184
	lda.b wTemp00
	ora.b wTemp01
	beq @lbl_C321E1
;C321DC  
	jsl $C21195                             ;C321DC
	rts                                     ;C321E0
@lbl_C321E1:
	jsl.l GetShirenCoreStatus
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C321EE
;C321EB  
	jmp $1004                               ;C321EB
@lbl_C321EE:
	jsl.l GetCategoryShortcutItemIds
	ldx.b wTemp02
	bmi @lbl_C321FC
	lda.l wItemIsCursed,x
	bne @lbl_C32210
@lbl_C321FC:
	ldx.b wTemp01
	bmi @lbl_C32206
	lda.l wItemIsCursed,x
	bne @lbl_C32210
@lbl_C32206:
	ldx.b wTemp00
	bmi @lbl_C32213
;C3220A  
	lda $7E8C0C,x                           ;C3220A
	.db $F0,$03   ;C3220E
@lbl_C32210:
	jmp $1C70                               ;C32210
@lbl_C32213:
	jsl.l GetShirenCoreStatus
	lda.b wTemp02
	ora.b wTemp03
	ora.b wTemp04
	bne @lbl_C3224E
	phy                                     ;C3221F
	jsl $C305F3                             ;C32220
	ply                                     ;C32224
	ldx $00                                 ;C32225
	.db $30,$25   ;C32227
	lda $7E8D0C,x                           ;C32229
	xba                                     ;C3222D
	lda $7E8C8C,x                           ;C3222E
	rep #$20                                ;C32232
	asl a                                   ;C32234
	sta $00                                 ;C32235
	asl a                                   ;C32237
	asl a                                   ;C32238
	clc                                     ;C32239
	adc $00                                 ;C3223A
	sep #$20                                ;C3223C
	sta $7E8C8C,x                           ;C3223E
	xba                                     ;C32242
	sta $7E8D0C,x                           ;C32243
	stx $00                                 ;C32247
	jsl $C23A02                             ;C32249
	rts                                     ;C3224D
@lbl_C3224E:
	tya
	beq @lbl_C3225B
	lda #$5C                                ;C32251
	sta $00                                 ;C32253
	stz $01                                 ;C32255
	jsl.l DisplayMessage
@lbl_C3225B:
	rts
ExtractionScrollUseEffect:
	sep #$30                                ;C3225C
	lda $01                                 ;C3225E
	sta $00                                 ;C32260
	jsr $1959                               ;C32262
	lda $00                                 ;C32265
	tay                                     ;C32267
	tax                                     ;C32268
	lda $7E8B8C,x                           ;C32269
	tax                                     ;C3226D
	lda $C341BB,x                           ;C3226E
	cmp #$0B                                ;C32272
	.db $D0,$2E   ;C32274
	lda #$13                                ;C32276
	sta $00                                 ;C32278
	lda #$CE                                ;C3227A
	sta $02                                 ;C3227C
	phy                                     ;C3227E
	jsl PlayCharacterEffect                             ;C3227F
	ply                                     ;C32283
	lda #$13                                ;C32284
	sta $00                                 ;C32286
	jsl $C210AC                             ;C32288
	rep #$20                                ;C3228C
	lda $00                                 ;C3228E
	pha                                     ;C32290
	tyx                                     ;C32291
	lda #$00F4                              ;C32292
	sta $00                                 ;C32295
	stx $02                                 ;C32297
	phx                                     ;C32299
	jsl.l DisplayMessage
	plx                                     ;C3229D
	pla                                     ;C3229E
	jsr $31B2                               ;C3229F
	rts                                     ;C322A2
	sep #$20                                ;C322A3
	lda #$5C                                ;C322A5
	sta $00                                 ;C322A7
	stz $01                                 ;C322A9
.ACCU 16
	jsl.l DisplayMessage
	rts                                     ;C322B0
HandsFullScrollUseEffect:
	rep #$20 ;A->16                      ;C322B1
	lda.w #$0013
	sta.b wTemp00
	lda.w #$00CF
	sta.b wTemp02
	jsl.l PlayVisualEffect
	lda.w #$0105
	sta.b wTemp00
	jsl.l DisplayMessage
	jsl.l $C28472                         ;C322CA
	rts                                  ;C322CE
	php                                     ;C322CF
	rep #$30                                ;C322D0
@lbl_C322D2:
	jsl $C3F65F                             ;C322D2
	lda $00                                 ;C322D6
	and #$000F                              ;C322D8
	cmp #$0008                              ;C322DB
	bcs @lbl_C322D2                         ;C322DE
	asl a                                   ;C322E0
	tax                                     ;C322E1
	lda $C322ED,x                           ;C322E2
	.db $F4   ;C322E6
	nop                                     ;C322E7
	jsl $286048                             ;C322E8
	rtl                                     ;C322EC
	.db $FC   ;C322ED
	jsl $EA2340                             ;C322EE
	.db $23   ;C322F2
	asl a                                   ;C322F3
	bit $A2                                 ;C322F4
	bit $A8                                 ;C322F6
	bit $B4                                 ;C322F8
	bit $E8                                 ;C322FA
	bit $C2                                 ;C322FC
	jsr $4522                               ;C322FE
	and $C3                                 ;C32301
	jsl $C32545                             ;C32303
	jsl $C32545                             ;C32307
	lda #$0076                              ;C3230B
	sta $00                                 ;C3230E
	jsl.l DisplayMessage
	lda #$000B                              ;C32314
	sta $00                                 ;C32317
	lda #$0003                              ;C32319
	sta $02                                 ;C3231C
	jsl.l DisplayMessage
	rts                                     ;C32322
	rep #$20                                ;C32323
	jsl $C325FB                             ;C32325
	lda #$0076                              ;C32329
	sta $00                                 ;C3232C
	jsl.l DisplayMessage
	lda #$000A                              ;C32332
	sta $00                                 ;C32335
	lda #$0001                              ;C32337
	sta $02                                 ;C3233A
	jsl.l DisplayMessage
	rts                                     ;C32340
	sep #$20                                ;C32341
	lda #$13                                ;C32343
	sta $00                                 ;C32345
	lda #$03                                ;C32347
	sta $02                                 ;C32349
	stz $03                                 ;C3234B
	jsl ModifyCharacterMaxHP                             ;C3234D
	lda #$13                                ;C32351
	sta $00                                 ;C32353
	lda #$03                                ;C32355
	sta $02                                 ;C32357
	stz $03                                 ;C32359
	jsl ModifyCharacterHP                             ;C3235B
	lda #$03                                ;C3235F
	sta $00                                 ;C32361
	jsl ModifyShirenMaxStrength                             ;C32363
	lda #$03                                ;C32367
	sta $00                                 ;C32369
	jsl ModifyShirenStrength                             ;C3236B
	rep #$20                                ;C3236F
	lda #$0023                              ;C32371
	sta $00                                 ;C32374
	sep #$20                                ;C32376
	lda #$13                                ;C32378
	sta $02                                 ;C3237A
	jsl.l DisplayMessage
	rep #$20                                ;C32380
	lda #$000B                              ;C32382
	sta $00                                 ;C32385
	sep #$20                                ;C32387
	lda #$03                                ;C32389
	sta $02                                 ;C3238B
	jsl.l DisplayMessage
	rts                                     ;C32391
	sep #$20                                ;C32392
	lda #$C8                                ;C32394
	sta $00                                 ;C32396
	jsl $C23BA6                             ;C32398
	rep #$20                                ;C3239C
	lda #$0023                              ;C3239E
	sta $00                                 ;C323A1
	sep #$20                                ;C323A3
	lda #$13                                ;C323A5
	sta $02                                 ;C323A7
	jsl.l DisplayMessage
	rep #$20                                ;C323AD
	lda #$000A                              ;C323AF
	sta $00                                 ;C323B2
	sep #$20                                ;C323B4
	lda #$01                                ;C323B6
	sta $02                                 ;C323B8
	jsl.l DisplayMessage
	lda #$13                                ;C323BE
	sta $00                                 ;C323C0
	lda #$FF                                ;C323C2
	sta $02                                 ;C323C4
	sta $03                                 ;C323C6
	jsl ModifyCharacterHP                             ;C323C8
	lda #$13                                ;C323CC
	sta $00                                 ;C323CE
	lda #$FF                                ;C323D0
	sta $02                                 ;C323D2
	sta $03                                 ;C323D4
	jsl ModifyCharacterMaxHP                             ;C323D6
	lda #$FF                                ;C323DA
	sta $00                                 ;C323DC
	jsl ModifyShirenStrength                             ;C323DE
	lda #$FF                                ;C323E2
	sta $00                                 ;C323E4
	jsl ModifyShirenMaxStrength                             ;C323E6
	rts                                     ;C323EA
	rep #$20                                ;C323EB
	jsl $C36562                             ;C323ED
	lda #$0077                              ;C323F1
	sta $00                                 ;C323F4
	jsl.l DisplayMessage
	rts                                     ;C323FA
	rep #$20                                ;C323FB
	jsl $C365A2                             ;C323FD
	lda #$0071                              ;C32401
	sta $00                                 ;C32404
	jsl.l DisplayMessage
	rts                                     ;C3240A
	rep #$20                                ;C3240B
	jsl $C20E89                             ;C3240D
	lda #$0078                              ;C32411
	sta $00                                 ;C32414
	jsl.l DisplayMessage
	rts                                     ;C3241A
	sep #$20                                ;C3241B
	jsl $C23B1C                             ;C3241D
	lda $00                                 ;C32421
	.db $30,$1F   ;C32423
	sta $02                                 ;C32425
	rep #$20                                ;C32427
	lda #$000E                              ;C32429
	sta $00                                 ;C3242C
	lda $02                                 ;C3242E
	pha                                     ;C32430
	jsl.l DisplayMessage
	pla                                     ;C32434
	sta $02                                 ;C32435
	sep #$20                                ;C32437
	lda $02                                 ;C32439
	sta $00                                 ;C3243B
	jsl $C306F4                             ;C3243D
	.db $80,$0B   ;C32441
	rep #$20                                ;C32443
	lda #$005C                              ;C32445
	sta $00                                 ;C32448
	jsl.l DisplayMessage
	rts                                     ;C3244F
	sep #$20                                ;C32450
	jsl $C23B1C                             ;C32452
	lda $00                                 ;C32456
	.db $30,$3D   ;C32458
	sta $02                                 ;C3245A
	lda $02                                 ;C3245C
	pha                                     ;C3245E
	jsl $C3041A                             ;C3245F
	pla                                     ;C32463
	sta $02                                 ;C32464
	lda $00                                 ;C32466
	.db $30,$2D   ;C32468
	sta $03                                 ;C3246A
	rep #$20                                ;C3246C
	lda #$000C                              ;C3246E
	sta $00                                 ;C32471
	lda $02                                 ;C32473
	pha                                     ;C32475
	jsl.l DisplayMessage
	pla                                     ;C32479
	sta $02                                 ;C3247A
	sep #$20                                ;C3247C
	lda $03                                 ;C3247E
	sta $00                                 ;C32480
	lda $02                                 ;C32482
	pha                                     ;C32484
	jsl $C23A02                             ;C32485
	pla                                     ;C32489
	sta $02                                 ;C3248A
	lda $02                                 ;C3248C
	sta $00                                 ;C3248E
	jsl $C306F4                             ;C32490
	.db $80,$0B   ;C32494
	rep #$20                                ;C32496
	lda #$005C                              ;C32498
	sta $00                                 ;C3249B
	jsl.l DisplayMessage
	rts                                     ;C324A1
	rep #$20                                ;C324A2
	jsl $C62AAE                             ;C324A4
	rep #$20                                ;C324A8
	lda #$0313                              ;C324AA
	sta $00                                 ;C324AD
	jsl ApplyCharacterLevelGains                             ;C324AF
	rts                                     ;C324B3
	rep #$20                                ;C324B4
	lda #$00C4                              ;C324B6
	sta $00                                 ;C324B9
	jsl.l DisplayMessage
	lda #$03E8                              ;C324C0
	sta $00                                 ;C324C3
	jsl ModifyShirenHunger                             ;C324C5
	lda #$0013                              ;C324C9
	sta $00                                 ;C324CC
	lda #$00FF                              ;C324CE
	sta $02                                 ;C324D1
	jsl ModifyCharacterHP                             ;C324D3
	sep #$20                                ;C324D7
	jsl GetShirenCoreStatus                             ;C324D9
	lda $01                                 ;C324DD
	sec                                     ;C324DF
	sbc $00                                 ;C324E0
	sta $00                                 ;C324E2
	jsl ModifyShirenStrength                             ;C324E4
	rts                                     ;C324E8
	rep #$20                                ;C324E9
	lda #$00C3                              ;C324EB
	sta $00                                 ;C324EE
	jsl.l DisplayMessage
	jsl $C27FD5                             ;C324F4
	rts                                     ;C324F8

func_C324F9:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	ldy.b wTemp00
	lda.l wItemType,x
	tax
	lda.l wItemIdentified,x
	bne @lbl_C3252F
	lda.b #$62
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	phy
	jsl.l DisplayMessage
	ply
	sty.b wTemp00
	phy
	jsl.l IdentifyItem
	ply
	lda.b #$10
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	jsl.l DisplayMessage
	plp
	rtl
@lbl_C3252F:
	sty $00                                 ;C3252F
	phy                                     ;C32531
	jsl $C30192                             ;C32532
	ply                                     ;C32536
	lda #$57                                ;C32537
	sta $00                                 ;C32539
	stz $01                                 ;C3253B
	sty $02                                 ;C3253D
	jsl.l DisplayMessage
	plp                                     ;C32543
	rtl                                     ;C32544
	php                                     ;C32545
	sep #$30                                ;C32546
	ldy #$00                                ;C32548
@lbl_C3254A:
	sty $00                                 ;C3254A
	phy                                     ;C3254C
	jsl $C23B7C                             ;C3254D
	ply                                     ;C32551
	lda $00                                 ;C32552
	bmi @lbl_C32571                         ;C32554
	pha                                     ;C32556
	phy                                     ;C32557
	jsl $C30710                             ;C32558
	ply                                     ;C3255C
	lda $00                                 ;C3255D
	cmp #$03                                ;C3255F
	beq @lbl_C32573                         ;C32561
	cmp #$05                                ;C32563
	beq @lbl_C32596                         ;C32565
	cmp #$07                                ;C32567
	beq @lbl_C325BD                         ;C32569
	lda $01                                 ;C3256B
	pla                                     ;C3256D
@lbl_C3256E:
	iny                                     ;C3256E
	bra @lbl_C3254A                         ;C3256F
@lbl_C32571:
	plp                                     ;C32571
	rtl                                     ;C32572
@lbl_C32573:
	plx                                     ;C32573
	lda $7E8C8C,x                           ;C32574
	cmp #$7F                                ;C32578
	beq @lbl_C32593                         ;C3257A
	inc a                                   ;C3257C
	sta $7E8C8C,x                           ;C3257D
	jsl $C23B89                             ;C32581
	cpx $00                                 ;C32585
	bne @lbl_C32593                         ;C32587
	lda #$01                                ;C32589
	sta $00                                 ;C3258B
	phy                                     ;C3258D
	jsl $C2342B                             ;C3258E
	ply                                     ;C32592
@lbl_C32593:
	brl @lbl_C3256E                         ;C32593
@lbl_C32596:
	plx                                     ;C32596
	lda $7E8C8C,x                           ;C32597
	cmp #$7F                                ;C3259B
	beq @lbl_C325BA                         ;C3259D
	inc a                                   ;C3259F
	sta $7E8C8C,x                           ;C325A0
	jsl $C23B89                             ;C325A4
	cpx $01                                 ;C325A8
	bne @lbl_C325BA                         ;C325AA
	lda #$13                                ;C325AC
	sta $00                                 ;C325AE
	lda #$01                                ;C325B0
	sta $01                                 ;C325B2
	phy                                     ;C325B4
	jsl $C234BF                             ;C325B5
	ply                                     ;C325B9
@lbl_C325BA:
	brl @lbl_C3256E                         ;C325BA
@lbl_C325BD:
	plx                                     ;C325BD
	lda $7E8C8C,x                           ;C325BE
	cmp #$7F                                ;C325C2
	beq @lbl_C325CB                         ;C325C4
	inc a                                   ;C325C6
	sta $7E8C8C,x                           ;C325C7
@lbl_C325CB:
	brl @lbl_C3256E                         ;C325CB
	plx                                     ;C325CE
	lda $7E8C8C,x                           ;C325CF
	cmp #$7F                                ;C325D3
	beq @lbl_C325F8                         ;C325D5
	inc a                                   ;C325D7
	sta $7E8C8C,x                           ;C325D8
	jsl $C23B89                             ;C325DC
	cpx $02                                 ;C325E0
	bne @lbl_C325F8                         ;C325E2
	lda #$01                                ;C325E4
	sta $00                                 ;C325E6
	phy                                     ;C325E8
	jsl ModifyShirenMaxStrength                             ;C325E9
	ply                                     ;C325ED
	lda #$01                                ;C325EE
	sta $00                                 ;C325F0
	phy                                     ;C325F2
	jsl ModifyShirenStrength                             ;C325F3
	ply                                     ;C325F7
@lbl_C325F8:
	brl @lbl_C3256E                         ;C325F8
	php                                     ;C325FB
	sep #$30                                ;C325FC
	ldy #$00                                ;C325FE
@lbl_C32600:
	sty $00                                 ;C32600
	phy                                     ;C32602
	jsl $C23B7C                             ;C32603
	ply                                     ;C32607
	lda $00                                 ;C32608
	bmi @lbl_C32627                         ;C3260A
	pha                                     ;C3260C
	phy                                     ;C3260D
	jsl $C30710                             ;C3260E
	ply                                     ;C32612
	lda $00                                 ;C32613
	cmp #$03                                ;C32615
	beq @lbl_C32629                         ;C32617
	cmp #$05                                ;C32619
	beq @lbl_C3264A                         ;C3261B
	cmp #$07                                ;C3261D
	beq @lbl_C3266F                         ;C3261F
	lda $01                                 ;C32621
	pla                                     ;C32623
@lbl_C32624:
	iny                                     ;C32624
	bra @lbl_C32600                         ;C32625
@lbl_C32627:
	plp                                     ;C32627
	rtl                                     ;C32628
@lbl_C32629:
	plx                                     ;C32629
	lda $7E8C8C,x                           ;C3262A
	beq @lbl_C32647                         ;C3262E
	dec a                                   ;C32630
	sta $7E8C8C,x                           ;C32631
	jsl $C23B89                             ;C32635
	cpx $00                                 ;C32639
	bne @lbl_C32647                         ;C3263B
	lda #$FF                                ;C3263D
	sta $00                                 ;C3263F
	phy                                     ;C32641
	jsl $C2342B                             ;C32642
	ply                                     ;C32646
@lbl_C32647:
	brl @lbl_C32624                         ;C32647
@lbl_C3264A:
	plx                                     ;C3264A
	lda $7E8C8C,x                           ;C3264B
	beq @lbl_C3266C                         ;C3264F
	dec a                                   ;C32651
	sta $7E8C8C,x                           ;C32652
	jsl $C23B89                             ;C32656
	cpx $01                                 ;C3265A
	bne @lbl_C3266C                         ;C3265C
	lda #$13                                ;C3265E
	sta $00                                 ;C32660
	lda #$FF                                ;C32662
	sta $01                                 ;C32664
	phy                                     ;C32666
	jsl $C234BF                             ;C32667
	ply                                     ;C3266B
@lbl_C3266C:
	brl @lbl_C32624                         ;C3266C
@lbl_C3266F:
	plx                                     ;C3266F
	lda $7E8C8C,x                           ;C32670
	beq @lbl_C3267B                         ;C32674
	dec a                                   ;C32676
	sta $7E8C8C,x                           ;C32677
@lbl_C3267B:
	brl @lbl_C32624                         ;C3267B
	plx                                     ;C3267E
	lda $7E8C8C,x                           ;C3267F
	cmp #$F7                                ;C32683
	beq @lbl_C326A8                         ;C32685
	dec a                                   ;C32687
	sta $7E8C8C,x                           ;C32688
	jsl $C23B89                             ;C3268C
	cpx $02                                 ;C32690
	bne @lbl_C326A8                         ;C32692
	lda #$FF                                ;C32694
	sta $00                                 ;C32696
	phy                                     ;C32698
	jsl ModifyShirenMaxStrength                             ;C32699
	ply                                     ;C3269D
	lda #$FF                                ;C3269E
	sta $00                                 ;C326A0
	phy                                     ;C326A2
	jsl ModifyShirenStrength                             ;C326A3
	ply                                     ;C326A7
@lbl_C326A8:
	brl @lbl_C32624                         ;C326A8

;c326ab
JarUseEffect:
	sep #$30 ;AXY->8
	ldx.b wTemp01
	cpx.b #$1F
	bne @lbl_C326C6
	lda.l wShirenStatus.cantPickUpItems
	beq @lbl_C326C6
	lda #$2B                                ;C326B9
	sta $00                                 ;C326BB
	lda #$01                                ;C326BD
	sta $01                                 ;C326BF
	jsl.l DisplayMessage
	rts
@lbl_C326C6:
	sty.b wTemp00
	phx
	phy
	call_savebank func_C62B69
	ply
	plx
	stx.b wTemp00
	phx
	phy
	phb
	jsr.w func_C31959
	plb
	ply
	plx
	lda.b wTemp00
	stx.b wTemp00
	tax
	lda.l wItemType,x
	phx
	tax
	lda.l DATA8_C341BB,x
	plx
	cmp.b #$0B
	bne @lbl_C326FC
	lda.b #$CD
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
	rts
@lbl_C326FC:
	lda.w wItemModification1,y
	bne @lbl_C3270C
	lda #$CF                                ;C32701
	sta $00                                 ;C32703
	stz $01                                 ;C32705
	jsl.l DisplayMessage
	rts
@lbl_C3270C:
	phx
	phy
	phb
	jsr.w TryPrepareSelectedItemForJarInsertion
	plb
	ply
	plx
	lda.b wTemp00
	beq @lbl_C3277B
	lda.b #$CB
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	stx.b wTemp03
	phx
	phy
	call_savebank DisplayMessage
	ply
	plx
	lda.w wItemType,y
	cmp.b #$B8
	bne @lbl_C32742
	stx $00                                 ;C32734
	phx                                     ;C32736
	phy                                     ;C32737
	phb                                     ;C32738
	jsl $C30192                             ;C32739
	plb                                     ;C3273D
	ply                                     ;C3273E
	plx                                     ;C3273F
	.db $80,$16   ;C32740
@lbl_C32742:
	cmp.b #$BD
	beq @lbl_C3277C
	cmp.b #$BA
	bne @lbl_C3274D
;C3274A  
	jmp $2849                               ;C3274A
@lbl_C3274D:
	cmp.b #$BF
	beq @lbl_C3278C
	cmp.b #$B6
	bne @lbl_C32758
;C32755  
	jmp $27D6                               ;C32755
@lbl_C32758:
	lda.w wItemModification1,y
	dec a
	sta.w wItemModification1,y
	pha
	phy
	bra @lbl_C32764
@lbl_C32763:
	tay
@lbl_C32764:
	lda.w wItemPotNextItem,y
	cmp.b #$FF
	bne @lbl_C32763
	txa
	sta.w wItemPotNextItem,y
	ply
	pla
	lda.w wItemType,y
	cmp.b #$C0
	bne @lbl_C3277B
;C32778  
	jmp $2A2D                               ;C32778
@lbl_C3277B:
	rts
@lbl_C3277C:
	sep #$30                                ;C3277C
	lda $8C8C,y                             ;C3277E
	dec a                                   ;C32781
	sta $8C8C,y                             ;C32782
	stx $00                                 ;C32785
	jsl $C306F4                             ;C32787
	rts                                     ;C3278B
@lbl_C3278C:
	sep #$30 ;AXY->8
	phy
	phb
	stx.b wTemp00
	jsl.l FreeFloorItemSlot
	jsl.l Random
	lda.b wTemp00
	cmp.b #$02
	bcs @lbl_C327B4
	jsl $C3F65F                             ;C327A0
	lda #$06                                ;C327A4
	ldy $00                                 ;C327A6
	bmi @lbl_C327AC                         ;C327A8
	lda #$1C                                ;C327AA
@lbl_C327AC:
	sta $00                                 ;C327AC
	jsl $C3035D                             ;C327AE
	.db $80,$04   ;C327B2
@lbl_C327B4:
	jsl.l SpawnRandomDungeonFloorItem
	ldx.b wTemp00
	plb
	ply
	lda.w wItemModification1,y
	dec a
	sta.w wItemModification1,y
	pha
	phy
	bra @lbl_C327C8
@lbl_C327C7:
	tay                                     ;C327C7
@lbl_C327C8:
	lda.w wItemPotNextItem,y
	cmp.b #$FF
	bne @lbl_C327C7
	txa
	sta.w wItemPotNextItem,y
	ply
	pla
	rts
	sep #$30                                ;C327D6
	lda $8C8C,y                             ;C327D8
	dec a                                   ;C327DB
	sta $8C8C,y                             ;C327DC
	phy                                     ;C327DF
	bra @lbl_C327E3                         ;C327E0
@lbl_C327E2:
	tay                                     ;C327E2
@lbl_C327E3:
	lda $8E0C,y                             ;C327E3
	cmp #$FF                                ;C327E6
	bne @lbl_C327E2                         ;C327E8
	txa                                     ;C327EA
	sta $8E0C,y                             ;C327EB
	ply                                     ;C327EE
	lda $8C8C,y                             ;C327EF
	beq @lbl_C3283B                         ;C327F2
	dec a                                   ;C327F4
	sta $8C8C,y                             ;C327F5
	lda $8B8C,x                             ;C327F8
	sta $00                                 ;C327FB
	lda $8C8C,x                             ;C327FD
	sta $01                                 ;C32800
	lda $8D0C,x                             ;C32802
	sta $02                                 ;C32805
	lda $8C0C,x                             ;C32807
	pha                                     ;C3280A
	lda $8D8C,x                             ;C3280B
	pha                                     ;C3280E
	lda $8F0C,x                             ;C3280F
	pha                                     ;C32812
	lda $8F8C,x                             ;C32813
	pha                                     ;C32816
	phy                                     ;C32817
	phb                                     ;C32818
	jsl $C30295                             ;C32819
	plb                                     ;C3281D
	ply                                     ;C3281E
	ldx $00                                 ;C3281F
	.db $E0   ;C32821
	sbc $6812F0,x                           ;C32822
	sta $8F8C,x                             ;C32826
	pla                                     ;C32829
	sta $8F0C,x                             ;C3282A
	pla                                     ;C3282D
	sta $8D8C,x                             ;C3282E
	pla                                     ;C32831
	sta $8C0C,x                             ;C32832
	bra @lbl_C3283D                         ;C32835
	pla                                     ;C32837
	pla                                     ;C32838
	pla                                     ;C32839
	pla                                     ;C3283A
@lbl_C3283B:
	rts                                     ;C3283B
@lbl_C3283C:
	tay                                     ;C3283C
@lbl_C3283D:
	lda $8E0C,y                             ;C3283D
	cmp #$FF                                ;C32840
	bne @lbl_C3283C                         ;C32842
	txa                                     ;C32844
	sta $8E0C,y                             ;C32845
	rts                                     ;C32848
	sep #$30                                ;C32849
	lda $8C8C,y                             ;C3284B
	dec a                                   ;C3284E
	sta $8C8C,y                             ;C3284F
	lda $7E8E8C,x                           ;C32852
	bne @lbl_C32879                         ;C32856
	phx                                     ;C32858
	phb                                     ;C32859
	jsl $C16C7D                             ;C3285A
	plb                                     ;C3285E
	lda #$00                                ;C3285F
@lbl_C32861:
	sta $06                                 ;C32861
	pha                                     ;C32863
	jsl $C6051F                             ;C32864
	pla                                     ;C32868
	ldy $00                                 ;C32869
	.db $C0   ;C3286B
	sbc $1A21F0,x                           ;C3286C
	cmp #$19                                ;C32870
	bcc @lbl_C32861                         ;C32872
	jsl $C16B75                             ;C32874
	plx                                     ;C32878
@lbl_C32879:
	lda #$13                                ;C32879
	sta $00                                 ;C3287B
	phx                                     ;C3287D
	jsl $C210AC                             ;C3287E
	plx                                     ;C32882
	rep #$20                                ;C32883
	lda $00                                 ;C32885
	sta $02                                 ;C32887
	stx $00                                 ;C32889
	jsl $C330DA                             ;C3288B
	rts                                     ;C3288F
	sep #$30                                ;C32890
	plx                                     ;C32892
	sta $06                                 ;C32893
	lda $8B8C,x                             ;C32895
	sta $00                                 ;C32898
	lda $8C0C,x                             ;C3289A
	sta $01                                 ;C3289D
	lda $8C8C,x                             ;C3289F
	sta $02                                 ;C328A2
	lda $8D0C,x                             ;C328A4
	sta $03                                 ;C328A7
	lda $8F0C,x                             ;C328A9
	sta $04                                 ;C328AC
	lda $8F8C,x                             ;C328AE
	sta $05                                 ;C328B1
	phx                                     ;C328B3
	jsl $C6054A                             ;C328B4
	plx                                     ;C328B8
	stx $00                                 ;C328B9
	jsl $C306F4                             ;C328BB
	jsl $C16B75                             ;C328BF
	rts                                     ;C328C3
	sep #$30 ;AXY->8
	tyx
	phx
	jsr.w func_C32BAD
	plx
	lda.l wItemModification1,x
	beq @lbl_C328DE
	dec a
	sta.l wItemModification1,x
	jsr.w func_C328E9
	jsr.w AntidoteHerbUseEffect
	rts
@lbl_C328DE:
	lda #$5C                                ;C328DE
	sta $00                                 ;C328E0
	stz $01                                 ;C328E2
	jsl.l DisplayMessage
	rts                                     ;C328E8

func_C328E9:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStats
	lda.b wTemp01
	sec
	sbc.b wTemp00
	beq @lbl_C32915
	sta.b wTemp02
	ldy.w #$0040
	sty.b wTemp00
	pha
	jsl.l DisplayMessage
	pla
	sta.b wTemp02
	stz.b wTemp03
	lda.b #$13
	sta.b wTemp00
	jsl.l ModifyCharacterHP
@lbl_C32915:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStatusEffects
	lda.b wTemp01
	pha
	lda.b wTemp03
	pha
	lda.b wTemp00
	beq @lbl_C32939
	ldy #$0013                              ;C32927
	sty $00                                 ;C3292A
	jsl $C240A7                             ;C3292C
	ldy #$009B                              ;C32930
	sty $00                                 ;C32933
	jsl.l DisplayMessage
@lbl_C32939:
	pla
	beq @lbl_C3294E
	ldy #$0013                              ;C3293C
	sty $00                                 ;C3293F
	jsl $C23FFF                             ;C32941
	ldy #$0067                              ;C32945
	sty $00                                 ;C32948
	jsl.l DisplayMessage
@lbl_C3294E:
	pla
	beq @lbl_C32963
	ldy #$0013                              ;C32951
	sty $00                                 ;C32954
	jsl $C24073                             ;C32956
	ldy #$006C                              ;C3295A
	sty $00                                 ;C3295D
	jsl.l DisplayMessage
@lbl_C32963:
	rts
WalrusJarUseEffect:
	sep #$30 ;AXY->8
	tyx
	phx
	jsr.w func_C32BAD
	plx
	lda.l wItemModification1,x
	bne @lbl_C3297D
	lda #$5C                                ;C32971
	sta $00                                 ;C32973
	stz $01                                 ;C32975
	jsl.l DisplayMessage
	rts                                     ;C3297B
@lbl_C3297D:
	dec a
	sta.l wItemModification1,x
	phx
	lda.b #$13
	sta.b wTemp00
	lda.b #$C7
	sta.b wTemp02
	jsl.l PlayCharacterEffect
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	ldy.b wTemp02
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	sta.b wTemp02
	sty.b wTemp00
	phy
	jsl.l func_C3303C
	ply
	lda.b wTemp01,s
	sta.b wTemp04
	lda.b wTemp02
	pha
	sta.b wTemp06
	ldx.b #$13
	stx.b wTemp02
	ldx.b wTemp00
	phx
	sty.b wTemp03
	phy
	jsl.l func_C626DF
	ply
	lda.b wTemp02,s
	sta.b wTemp04
	lda.b wTemp04,s
	sta.b wTemp06
	sty.b wTemp03
	ldy.b #$14
	sty.b wTemp02
	jsl.l func_C626DF
	lda.w #$0013
	sta.b wTemp00
	lda.w #$0001
	sta.b wTemp02
	jsl.l PlayCharacterEffect
	plx
	pla
	sta.b wTemp02
	pla
	sep #$20 ;A->8
	txa
	bmi @lbl_C32A1F
	pha
	rep #$20 ;A->16
	lda.b wTemp02
	sta.b wTemp00
	sep #$20 ;A->8
	lda.b #$80
	sta.b wTemp02
	jsl.l func_C35BA2
	ply
	pla
@lbl_C329FD:
	tax
	lda.l wItemPotNextItem,x
	bpl @lbl_C329FD
	tya
	sta.l wItemPotNextItem,x
	tax
	lda.b #$00
	sta.l wItemGoods,x
	stx.b wTemp02
	lda.b #$02
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp01
	jsl.l DisplayMessage
	rts
@lbl_C32A1F:
	plx                                     ;C32A1F
	lda #$03                                ;C32A20
	sta $00                                 ;C32A22
	lda #$01                                ;C32A24
	sta $01                                 ;C32A26
	jsl.l DisplayMessage
	rts                                     ;C32A2C
	sep #$30                                ;C32A2D
	tya                                     ;C32A2F
@lbl_C32A30:
	tyx                                     ;C32A30
	tay                                     ;C32A31
	lda $8E0C,y                             ;C32A32
	bpl @lbl_C32A30                         ;C32A35
	stx $00                                 ;C32A37
	sty $01                                 ;C32A39
	ldx $8B8C,y                             ;C32A3B
	lda $C341BB,x                           ;C32A3E
	ldy $00                                 ;C32A42
	ldx $8B8C,y                             ;C32A44
	cmp $C341BB,x                           ;C32A47
	beq @lbl_C32A4E                         ;C32A4B
	rts                                     ;C32A4D
@lbl_C32A4E:
	ldx $00                                 ;C32A4E
	ldy $01                                 ;C32A50
	cmp #$03                                ;C32A52
	bne @lbl_C32ABB                         ;C32A54
	lda $8F0C,x                             ;C32A56
	ora $8F0C,y                             ;C32A59
	sta $8F0C,x                             ;C32A5C
	lda $8F8C,x                             ;C32A5F
	ora $8F8C,y                             ;C32A62
	ora #$80                                ;C32A65
	sta $8F8C,x                             ;C32A67
@lbl_C32A6A:
	lda $8C0C,x                             ;C32A6A
	ora $8C0C,y                             ;C32A6D
	sta $8C0C,x                             ;C32A70
@lbl_C32A73:
	lda #$01                                ;C32A73
	sta $8D8C,x                             ;C32A75
	lda $8C8C,x                             ;C32A78
	clc                                     ;C32A7B
	adc $8C8C,y                             ;C32A7C
	bvs @lbl_C32AA3                         ;C32A7F
	bmi @lbl_C32A8B                         ;C32A81
	cmp #$64                                ;C32A83
	bcc @lbl_C32A89                         ;C32A85
	lda #$63                                ;C32A87
@lbl_C32A89:
	bra @lbl_C32AA1                         ;C32A89
@lbl_C32A8B:
	phy                                     ;C32A8B
	phx                                     ;C32A8C
	ldy $8B8C,x                             ;C32A8D
	tyx                                     ;C32A90
	clc                                     ;C32A91
	adc $C342A3,x                           ;C32A92
	bpl @lbl_C32A9A                         ;C32A96
	lda #$00                                ;C32A98
@lbl_C32A9A:
	sec                                     ;C32A9A
	sbc $C342A3,x                           ;C32A9B
	plx                                     ;C32A9F
	ply                                     ;C32AA0
@lbl_C32AA1:
	bra @lbl_C32AB6                         ;C32AA1
@lbl_C32AA3:
	bmi @lbl_C32AB4                         ;C32AA3
	phx                                     ;C32AA5
	lda $8B8C,x                             ;C32AA6
	tax                                     ;C32AA9
	lda #$00                                ;C32AAA
	sec                                     ;C32AAC
	sbc $C342A3,x                           ;C32AAD
	plx                                     ;C32AB1
	bra @lbl_C32AB6                         ;C32AB2
@lbl_C32AB4:
	lda #$63                                ;C32AB4
@lbl_C32AB6:
	sta $8C8C,x                             ;C32AB6
	bra @lbl_C32AF0                         ;C32AB9
@lbl_C32ABB:
	cmp #$05                                ;C32ABB
	bne @lbl_C32AE3                         ;C32ABD
	lda $8F8C,x                             ;C32ABF
	ora $8F8C,y                             ;C32AC2
	ora #$80                                ;C32AC5
	sta $8F8C,x                             ;C32AC7
	lda $8F0C,x                             ;C32ACA
	ora $8F0C,y                             ;C32ACD
	sta $8F0C,x                             ;C32AD0
	and #$03                                ;C32AD3
	cmp #$03                                ;C32AD5
	bne @lbl_C32AE1                         ;C32AD7
	lda $8F0C,x                             ;C32AD9
	and #$FC                                ;C32ADC
	sta $8F0C,x                             ;C32ADE
@lbl_C32AE1:
	bra @lbl_C32A6A                         ;C32AE1
@lbl_C32AE3:
	cmp #$07                                ;C32AE3
	bne @lbl_C32AEF                         ;C32AE5
	lda $8B8C,x                             ;C32AE7
	cmp $8B8C,y                             ;C32AEA
	beq @lbl_C32A73                         ;C32AED
@lbl_C32AEF:
	rts                                     ;C32AEF
@lbl_C32AF0:
	lda #$FF                                ;C32AF0
	sta $8E0C,x                             ;C32AF2
	sty $00                                 ;C32AF5
	jsl $C306F4                             ;C32AF7
	rts                                     ;C32AFB

; Validates and normalizes the currently selected item source before a jar
; insertion/use path continues. Handles both ordinary inventory items and the
; contextual map-item selection mode.
TryPrepareSelectedItemForJarInsertion:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	cmp.b #$1F
	beq @lbl_C32B0B
;C32B05  
	jsl $C23C4D                             ;C32B05
	plp                                     ;C32B09
	rts                                     ;C32B0A
@lbl_C32B0B:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	jsl.l GetItemData
	ldx.b wTemp01
	stx.b wTemp00
	phx
	jsl.l CheckIsNamedSanctuaryScrollAlt
	plx
	ldy.b wTemp00
	bne @lbl_C32B3A
;C32B2A
	pla                                     ;C32B2A
	stx $02                                 ;C32B2B
	lda #$00C6                              ;C32B2D
	sta $00                                 ;C32B30
	jsl.l DisplayMessage
	stz $00                                 ;C32B36
	plp                                     ;C32B38
	rts                                     ;C32B39
@lbl_C32B3A:
	stx.b wTemp00
	phx
	jsl.l NullItemHandler
	plx
	stz.b wTemp00
	stx.b wTemp00
	phx
	jsl.l func_C25AFD
	plx
	ldy.b #$80
	sty.b wTemp02
	pla
	sta.b wTemp00
	jsl.l func_C35BA2
	ldx.b #$01
	stx.b wTemp00
	plp
	rts
MonsterJarUseEffect:
	sep #$30                                ;C32B5D
	tyx                                     ;C32B5F
	phx                                     ;C32B60
	jsr $2BAD                               ;C32B61
	plx                                     ;C32B64
	lda $7E8C8C,x                           ;C32B65
	phx                                     ;C32B69
	jsr $2BC0                               ;C32B6A
	plx                                     ;C32B6D
	stx $00                                 ;C32B6E
	phx                                     ;C32B70
	jsl $C30192                             ;C32B71
	plx                                     ;C32B75
	stx $00                                 ;C32B76
	jsl $C306F4                             ;C32B78
	pla                                     ;C32B7C
	pla                                     ;C32B7D
	stz $00                                 ;C32B7E
	plp                                     ;C32B80
	rtl                                     ;C32B81
HidingJarUseEffect:
	sep #$30 ;AXY->8
	tyx
	phx
	lda.b #$E6
	sta.b wTemp00
	stz.b wTemp01
	stx.b wTemp02
	phx
	jsl.l DisplayMessage
	plx
	jsl.l func_C240FC
	plx
	stx.b wTemp00
	phx
	jsl.l IdentifyItem
	plx
	stx.b wTemp00
	jsl.l FreeFloorItemSlot
	pla
	pla
	stz.b wTemp00
	plp
	rtl

func_C32BAD:
	php
	sep #$30 ;AXY->8
	lda.b #$D1
	sta.b wTemp00
	stz.b wTemp01
	stx.b wTemp02
	phx
	jsl.l DisplayMessage
	plx
	plp
	rts
	php                                     ;C32BC0
	sep #$20                                ;C32BC1
	rep #$10                                ;C32BC3
	pha                                     ;C32BC5
	lda #$13                                ;C32BC6
	sta $00                                 ;C32BC8
	jsl $C210AC                             ;C32BCA
	ldx $00                                 ;C32BCE
	pla                                     ;C32BD0
@lbl_C32BD1:
	pha                                     ;C32BD1
	phx                                     ;C32BD2
	stx $00                                 ;C32BD3
	jsl $C3631A                             ;C32BD5
	ldx $00                                 ;C32BD9
	bmi @lbl_C32C00                         ;C32BDB
	stx $00                                 ;C32BDD
	phx                                     ;C32BDF
	jsl $C20BE7                             ;C32BE0
	plx                                     ;C32BE4
	lda $00                                 ;C32BE5
	bmi @lbl_C32C00                         ;C32BE7
	stx $00                                 ;C32BE9
	sta $02                                 ;C32BEB
	pha                                     ;C32BED
	jsl $C35B7A                             ;C32BEE
	pla                                     ;C32BF2
	sta $00                                 ;C32BF3
	jsl $C27FAA                             ;C32BF5
	plx                                     ;C32BF9
	pla                                     ;C32BFA
	dec a                                   ;C32BFB
	bne @lbl_C32BD1                         ;C32BFC
	plp                                     ;C32BFE
	rts                                     ;C32BFF
@lbl_C32C00:
	plx                                     ;C32C00
	pla                                     ;C32C01
	plp                                     ;C32C02
	rts                                     ;C32C03
	php                                     ;C32C04
	sep #$20                                ;C32C05
	rep #$10                                ;C32C07
	ldx $00                                 ;C32C09
@lbl_C32C0B:
	pha                                     ;C32C0B
	phx                                     ;C32C0C
	stx $00                                 ;C32C0D
	jsl $C3631A                             ;C32C0F
	ldx $00                                 ;C32C13
	bmi @lbl_C32C46                         ;C32C15
	stx $00                                 ;C32C17
	phx                                     ;C32C19
	jsl $C20BE7                             ;C32C1A
	plx                                     ;C32C1E
	lda $00                                 ;C32C1F
	bmi @lbl_C32C46                         ;C32C21
	stx $00                                 ;C32C23
	sta $02                                 ;C32C25
	pha                                     ;C32C27
	jsl $C35B7A                             ;C32C28
	pla                                     ;C32C2C
	sta $00                                 ;C32C2D
	pha                                     ;C32C2F
	jsl $C27FAA                             ;C32C30
	pla                                     ;C32C34
	sta $00                                 ;C32C35
	lda #$14                                ;C32C37
	sta $01                                 ;C32C39
	jsl $C23FFF                             ;C32C3B
	plx                                     ;C32C3F
	pla                                     ;C32C40
	dec a                                   ;C32C41
	bne @lbl_C32C0B                         ;C32C42
	plp                                     ;C32C44
	rts                                     ;C32C45
@lbl_C32C46:
	plx                                     ;C32C46
	pla                                     ;C32C47
	plp                                     ;C32C48
	rts                                     ;C32C49
	php                                     ;C32C4A
	sep #$20                                ;C32C4B
	rep #$10                                ;C32C4D
	ldx $00                                 ;C32C4F
	bra @lbl_C32C87                         ;C32C51
@lbl_C32C53:
	pha                                     ;C32C53
	phx                                     ;C32C54
	stx $00                                 ;C32C55
	jsl $C3631A                             ;C32C57
	ldx $00                                 ;C32C5B
	bmi @lbl_C32C8C                         ;C32C5D
	stx $00                                 ;C32C5F
	lda #$06                                ;C32C61
	sta $02                                 ;C32C63
	lda #$0A                                ;C32C65
	sta $03                                 ;C32C67
	phx                                     ;C32C69
	jsl $C2007D                             ;C32C6A
	plx                                     ;C32C6E
	lda $00                                 ;C32C6F
	bmi @lbl_C32C8C                         ;C32C71
	stx $00                                 ;C32C73
	sta $02                                 ;C32C75
	pha                                     ;C32C77
	jsl $C35B7A                             ;C32C78
	pla                                     ;C32C7C
	sta $00                                 ;C32C7D
	pha                                     ;C32C7F
	jsl $C27FAA                             ;C32C80
	pla                                     ;C32C84
	plx                                     ;C32C85
	pla                                     ;C32C86
@lbl_C32C87:
	dec a                                   ;C32C87
	bpl @lbl_C32C53                         ;C32C88
	plp                                     ;C32C8A
	rts                                     ;C32C8B
@lbl_C32C8C:
	plx                                     ;C32C8C
	pla                                     ;C32C8D
	plp                                     ;C32C8E
	rts                                     ;C32C8F

TryClearAssignedCategoryItem:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wItemIsCursed,y
	beq @lbl_C32CAE
;C32C9E
	lda #$0D                                ;C32C9E
	sta $00                                 ;C32CA0
	stz $01                                 ;C32CA2
	sty $02                                 ;C32CA4
	jsl.l DisplayMessage
	stz $00                                 ;C32CAA
	plp                                     ;C32CAC
	rtl                                     ;C32CAD
@lbl_C32CAE:
	lda.w wItemType,y
	stz.b wTemp00
	rep #$30 ;AXY->16
	and.w #$00FF
	asl a
	tax
	lda.l ItemUseEffectFunctionTable,x
	pea.w $2CC2
	pha
	rts
	sep #$20 ;A->8
	lda.b #$01
	sta.b wTemp00
	plp
	rtl

; wTemp00: item slot index
; returns:
;   wTemp00/wTemp01 = current fuse ability bytes
;   wTemp02/wTemp03 = default fuse ability bytes for the item type
LoadItemFuseAbilitiesAndDefaults:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemFuseAbility1,x
	sta.b wTemp00
	lda.l wItemFuseAbility2,x
	sta.b wTemp01
	lda.l wItemType,x
	asl a
	tax
	rep #$20 ;A->16
	lda.l ItemDefaultFuseAbility1ByType,x
	sta.b wTemp02
	plp
	rtl
	php                                     ;C32CEC
	sep #$20                                ;C32CED
	tdc                                     ;C32CEF
	lda $00                                 ;C32CF0
	asl a                                   ;C32CF2
	rep #$30                                ;C32CF3
	tax                                     ;C32CF5
	lda $C30301,x                           ;C32CF6
	sta $00                                 ;C32CFA
	plp                                     ;C32CFC
	rtl                                     ;C32CFD

func_C32CFE:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	phx
	jsl.l GetCategoryShortcutItemIds
	ldx.b wTemp02
	lda.l wItemType,x
	plx
	cmp.b #$98
	beq @lbl_C32D6A
	stx.b wTemp00
	phx
	jsl.l GetItemDisplayInfo
	plx
	lda.l wItemFuseAbility1,x
	bit.b #$04
	bne @lbl_C32D50
	lda.l wItemFuseAbility2,x
	bit.b #$08
	bne @lbl_C32D5E
	lda.b wTemp04
	beq @lbl_C32D4E
	lda.l wItemModification1,x
	dec a
	sta.l wItemModification1,x
	lda.b #$13
	sta.b wTemp00
	lda.b #$FF
	sta.b wTemp01
	jsl.l func_C234BF
	lda.b #$8B
	sta.b wTemp00
	stz.b wTemp01
	jsl.l DisplayMessage
@lbl_C32D4E:
	plp
	rtl
@lbl_C32D50:
	lda #$A9                                ;C32D50
	sta $00                                 ;C32D52
	stz $01                                 ;C32D54
	stx $02                                 ;C32D56
	jsl.l DisplayMessage
	plp                                     ;C32D5C
	rtl                                     ;C32D5D
@lbl_C32D5E:
	lda #$A8                                ;C32D5E
	sta $00                                 ;C32D60
	stz $01                                 ;C32D62
	jsl.l DisplayMessage
	plp                                     ;C32D68
	rtl                                     ;C32D69
@lbl_C32D6A:
	lda #$D7                                ;C32D6A
	sta $00                                 ;C32D6C
	stz $01                                 ;C32D6E
	jsl.l DisplayMessage
	plp                                     ;C32D74
	rtl                                     ;C32D75
	php                                     ;C32D76
	sep #$30                                ;C32D77
	ldx $00                                 ;C32D79
	phx                                     ;C32D7B
	jsl $C23B89                             ;C32D7C
	ldx $02                                 ;C32D80
	lda $7E8B8C,x                           ;C32D82
	plx                                     ;C32D86
	cmp #$98                                ;C32D87
	.db $F0,$41   ;C32D89
	stx $00                                 ;C32D8B
	phx                                     ;C32D8D
	jsl $C30710                             ;C32D8E
	plx                                     ;C32D92
	lda $7E8F8C,x                           ;C32D93
	bit #$08                                ;C32D97
	.db $D0,$23   ;C32D99
	lda $04                                 ;C32D9B
	.db $F0,$1D   ;C32D9D
	lda $7E8C8C,x                           ;C32D9F
	dec a                                   ;C32DA3
	sta $7E8C8C,x                           ;C32DA4
	lda #$FF                                ;C32DA8
	sta $00                                 ;C32DAA
	jsl $C2342B                             ;C32DAC
	lda #$10                                ;C32DB0
	sta $00                                 ;C32DB2
	lda #$01                                ;C32DB4
	sta $01                                 ;C32DB6
	jsl.l DisplayMessage
	plp                                     ;C32DBC
	rtl                                     ;C32DBD
	lda #$11                                ;C32DBE
	sta $00                                 ;C32DC0
	lda #$01                                ;C32DC2
	sta $01                                 ;C32DC4
	jsl.l DisplayMessage
	plp                                     ;C32DCA
	rtl                                     ;C32DCB
	lda #$D7                                ;C32DCC
	sta $00                                 ;C32DCE
	stz $01                                 ;C32DD0
	jsl.l DisplayMessage
	plp                                     ;C32DD6
	rtl                                     ;C32DD7
	php                                     ;C32DD8
	sep #$30                                ;C32DD9
	ldx $00                                 ;C32DDB
	lda $7E8F8C,x                           ;C32DDD
	bit #$08                                ;C32DE1
	.db $F0,$18   ;C32DE3
	and #$F7                                ;C32DE5
	sta $7E8F8C,x                           ;C32DE7
	lda #$13                                ;C32DEB
	sta $00                                 ;C32DED
	lda #$01                                ;C32DEF
	sta $01                                 ;C32DF1
	jsl.l DisplayMessage
	lda #$01                                ;C32DF7
	sta $00                                 ;C32DF9
	plp                                     ;C32DFB
	rtl                                     ;C32DFC
	bit #$80                                ;C32DFD
	bne @lbl_C32E05                         ;C32DFF
	stz $00                                 ;C32E01
	plp                                     ;C32E03
	rtl                                     ;C32E04
@lbl_C32E05:
	phx                                     ;C32E05
	stx $00                                 ;C32E06
	jsl $C32CCB                             ;C32E08
	rep #$30                                ;C32E0C
	lda $00                                 ;C32E0E
	sta $06                                 ;C32E10
	lda $02                                 ;C32E12
	ora #$0200                              ;C32E14
	sta $04                                 ;C32E17
	ora #$8800                              ;C32E19
	eor #$FFFF                              ;C32E1C
	bit $00                                 ;C32E1F
	bne @lbl_C32E2C                         ;C32E21
	sep #$30                                ;C32E23
	plx                                     ;C32E25
	stz $00                                 ;C32E26
	plp                                     ;C32E28
	rtl                                     ;C32E29
	rep #$30                                ;C32E2A
@lbl_C32E2C:
	lda #$0A01                              ;C32E2C
	sta $00                                 ;C32E2F
	lda $04                                 ;C32E31
	pha                                     ;C32E33
	lda $06                                 ;C32E34
	pha                                     ;C32E36
	jsl $C3F69F                             ;C32E37
	pla                                     ;C32E3B
	sta $06                                 ;C32E3C
	pla                                     ;C32E3E
	sta $04                                 ;C32E3F
	lda $00                                 ;C32E41
	and #$00FF                              ;C32E43
	tax                                     ;C32E46
	tay                                     ;C32E47
	lda #$0001                              ;C32E48
@lbl_C32E4B:
	dey                                     ;C32E4B
	beq @lbl_C32E51                         ;C32E4C
	asl a                                   ;C32E4E
	bra @lbl_C32E4B                         ;C32E4F
@lbl_C32E51:
	bit $04                                 ;C32E51
	bne @lbl_C32E2C                         ;C32E53
	sta $02                                 ;C32E55
	eor #$FFFF                              ;C32E57
	sta $00                                 ;C32E5A
	lda $06                                 ;C32E5C
	bit $02                                 ;C32E5E
	beq @lbl_C32E2C                         ;C32E60
	lda $06                                 ;C32E62
	and $00                                 ;C32E64
	pha                                     ;C32E66
	txa                                     ;C32E67
	dec a                                   ;C32E68
	asl a                                   ;C32E69
	tax                                     ;C32E6A
	lda $C32EB8,x                           ;C32E6B
	sta $00                                 ;C32E6F
	jsl.l DisplayMessage
	pla                                     ;C32E75
	sep #$30                                ;C32E76
	plx                                     ;C32E78
	txy                                     ;C32E79
	sta $7E8F0C,x                           ;C32E7A
	sta $00                                 ;C32E7E
	sta $02                                 ;C32E80
	xba                                     ;C32E82
	sta $7E8F8C,x                           ;C32E83
	sta $01                                 ;C32E87
	and #$77                                ;C32E89
	sta $03                                 ;C32E8B
	lda $7E8B8C,x                           ;C32E8D
	asl a                                   ;C32E91
	tax                                     ;C32E92
	rep #$20                                ;C32E93
	lda $C30301,x                           ;C32E95
	cmp $02                                 ;C32E99
	bne @lbl_C32EAC                         ;C32E9B
	sep #$20                                ;C32E9D
	tyx                                     ;C32E9F
	lda $7E8F8C,x                           ;C32EA0
	and #$7F                                ;C32EA4
	sta $7E8F8C,x                           ;C32EA6
	sta $01                                 ;C32EAA
@lbl_C32EAC:
	jsl $C284B2                             ;C32EAC
	sep #$20                                ;C32EB0
	lda #$01                                ;C32EB2
	sta $00                                 ;C32EB4
	plp                                     ;C32EB6
	rtl                                     ;C32EB7
	ora $01,x                               ;C32EB8
	asl $01,x                               ;C32EBA
	ora [$01],y                             ;C32EBC
	clc                                     ;C32EBE
	.db $01   ;C32EBF
	ora $1A01,y                             ;C32EC0
	ora ($1B,x)                             ;C32EC3
	ora ($1C,x)                             ;C32EC5
	ora ($1D,x)                             ;C32EC7
	ora ($08,x)                             ;C32EC9
	sep #$30                                ;C32ECB
	ldx $00                                 ;C32ECD
	lda $7E8F8C,x                           ;C32ECF
	bit #$08                                ;C32ED3
	.db $F0,$18   ;C32ED5
	and #$F7                                ;C32ED7
	sta $7E8F8C,x                           ;C32ED9
	lda #$1E                                ;C32EDD
	sta $00                                 ;C32EDF
	lda #$01                                ;C32EE1
	sta $01                                 ;C32EE3
	jsl.l DisplayMessage
	lda #$01                                ;C32EE9
	sta $00                                 ;C32EEB
	plp                                     ;C32EED
	rtl                                     ;C32EEE
	bit #$80                                ;C32EEF
	bne @lbl_C32EF7                         ;C32EF1
	stz $00                                 ;C32EF3
	plp                                     ;C32EF5
	rtl                                     ;C32EF6
@lbl_C32EF7:
	phx                                     ;C32EF7
	stx $00                                 ;C32EF8
	jsl $C32CCB                             ;C32EFA
	rep #$30                                ;C32EFE
	lda $00                                 ;C32F00
	sta $06                                 ;C32F02
	lda $02                                 ;C32F04
	ora #$0102                              ;C32F06
	sta $04                                 ;C32F09
	ora #$8800                              ;C32F0B
	eor #$FFFF                              ;C32F0E
	bit $00                                 ;C32F11
	bne @lbl_C32F1E                         ;C32F13
	sep #$30                                ;C32F15
	plx                                     ;C32F17
	stz $00                                 ;C32F18
	plp                                     ;C32F1A
	rtl                                     ;C32F1B
	rep #$30                                ;C32F1C
@lbl_C32F1E:
	lda #$0B01                              ;C32F1E
	sta $00                                 ;C32F21
	lda $04                                 ;C32F23
	pha                                     ;C32F25
	lda $06                                 ;C32F26
	pha                                     ;C32F28
	jsl $C3F69F                             ;C32F29
	pla                                     ;C32F2D
	sta $06                                 ;C32F2E
	pla                                     ;C32F30
	sta $04                                 ;C32F31
	lda $00                                 ;C32F33
	and #$00FF                              ;C32F35
	tax                                     ;C32F38
	tay                                     ;C32F39
	lda #$0001                              ;C32F3A
@lbl_C32F3D:
	dey                                     ;C32F3D
	beq @lbl_C32F43                         ;C32F3E
	asl a                                   ;C32F40
	bra @lbl_C32F3D                         ;C32F41
@lbl_C32F43:
	bit $04                                 ;C32F43
	bne @lbl_C32F1E                         ;C32F45
	sta $02                                 ;C32F47
	eor #$FFFF                              ;C32F49
	sta $00                                 ;C32F4C
	lda $06                                 ;C32F4E
	bit $02                                 ;C32F50
	beq @lbl_C32F1E                         ;C32F52
	lda $06                                 ;C32F54
	and $00                                 ;C32F56
	pha                                     ;C32F58
	txa                                     ;C32F59
	dec a                                   ;C32F5A
	asl a                                   ;C32F5B
	tax                                     ;C32F5C
	lda $C32FAA,x                           ;C32F5D
	sta $00                                 ;C32F61
	jsl.l DisplayMessage
	pla                                     ;C32F67
	sep #$30                                ;C32F68
	plx                                     ;C32F6A
	txy                                     ;C32F6B
	sta $7E8F0C,x                           ;C32F6C
	sta $00                                 ;C32F70
	sta $02                                 ;C32F72
	xba                                     ;C32F74
	sta $7E8F8C,x                           ;C32F75
	sta $01                                 ;C32F79
	and #$77                                ;C32F7B
	sta $03                                 ;C32F7D
	lda $7E8B8C,x                           ;C32F7F
	asl a                                   ;C32F83
	tax                                     ;C32F84
	rep #$20                                ;C32F85
	lda $C30301,x                           ;C32F87
	cmp $02                                 ;C32F8B
	bne @lbl_C32F9E                         ;C32F8D
	sep #$20                                ;C32F8F
	tyx                                     ;C32F91
	lda $7E8F8C,x                           ;C32F92
	and #$7F                                ;C32F96
	sta $7E8F8C,x                           ;C32F98
	sta $01                                 ;C32F9C
@lbl_C32F9E:
	jsl $C284BD                             ;C32F9E
	sep #$20                                ;C32FA2
	lda #$01                                ;C32FA4
	sta $00                                 ;C32FA6
	plp                                     ;C32FA8
	rtl                                     ;C32FA9
	jsr $2101                               ;C32FAA
	.db $01   ;C32FAD
	jsl $012301                             ;C32FAE
	bit $01                                 ;C32FB2
	and $01                                 ;C32FB4
	rol $01                                 ;C32FB6
	and [$01]                               ;C32FB8
	plp                                     ;C32FBA
	.db $01   ;C32FBB
	and #$01                                ;C32FBC
	rol a                                   ;C32FBE
	.db $01   ;C32FBF

func_C32FC0:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemFuseAbility2,x
	bit.b #$01
	beq @lbl_C32FEC
	phx                                     ;C32FCD
	jsl $C30710                             ;C32FCE
	plx                                     ;C32FD2
	lda $04                                 ;C32FD3
	.db $F0,$15   ;C32FD5
	lda $7E8C8C,x                           ;C32FD7
	dec a                                   ;C32FDB
	sta $7E8C8C,x                           ;C32FDC
	lda #$13                                ;C32FE0
	sta $00                                 ;C32FE2
	lda #$FF                                ;C32FE4
	sta $01                                 ;C32FE6
	jsl $C234BF                             ;C32FE8
@lbl_C32FEC:
	plp
	rtl

func_C32FEE:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	tax
	rep #$20 ;A->16
	lda.l DATA8_C334CD,x
	pha
	lda.b wTemp02
	ldy.b wTemp01
@lbl_C33000:
	clc
	adc.b wTemp01,s
	sta.b wTemp00
	pha
	jsl.l GetItemData
	sep #$20 ;A->8
	lda.b wTemp02
	asl a
	and.b wTemp02
	asl a
	rep #$20 ;A->16
	pla
	bcs @lbl_C33020
	ldx.b wTemp00
	bpl @lbl_C3302C
	dey
	bne @lbl_C33000
	bra @lbl_C33023
@lbl_C33020:
	sec
	sbc.b wTemp01,s
@lbl_C33023:
	ldx.b #$FF
@lbl_C33025:
	stx.b wTemp00
	sta.b wTemp02
	pla
	plp
	rtl
@lbl_C3302C:
	stx.b wTemp00
	pha
	phx
	jsl.l func_C20E3A
	plx
	pla
	ldy.b wTemp00
	bpl @lbl_C33025
	.db $80,$E4   ;C3303A

func_C3303C:
	php
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$00
	pha
	lda.b wTemp00
	pha
	ldy.b wTemp02
	phy
	sty.b wTemp00
	jsl.l GetItemData
	lda.b wTemp02
	bit.b #$F0
	bne @lbl_C33066
	sta.b wTemp00
	jsl.l func_C366B7
	lda.b wTemp00
	bit.b #$20
	beq @lbl_C33066
;C33062
	lda #$01                                ;C33062
	sta $04,s                               ;C33064
@lbl_C33066:
	ply
	sty.b wTemp02
	pla
	sta.b wTemp00
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	tax
	rep #$20 ;A->16
	lda.l DATA8_C334CD,x
	pha
	lda.b wTemp02
	sta.b wTemp04
@lbl_C3307D:
	rep #$20 ;A->16
	lda.b wTemp04
	clc
	adc.b wTemp01,s
	sta.b wTemp00
	pha
	jsl.l GetItemData
	pla
	sta.b wTemp04
	sep #$20 ;A->8
	lda.b wTemp02
	asl a
	and.b wTemp02
	bmi @lbl_C330BA
	lda.b wTemp00
	bpl @lbl_C330BA
	ldx.b wTemp01
	bmi @lbl_C3307D
	lda.l wItemType,x
	tax
	lda.l DATA8_C341BB,x
	cmp.b #$0B
	beq @lbl_C3307D
	ldx.b wTemp01
	lda.b wTemp03,s
	beq @lbl_C330C5
;C330B2  
	lda $7E8E8C,x                           ;C330B2
	.db $D0,$C5   ;C330B6
	.db $80,$0B   ;C330B8
@lbl_C330BA:
	rep #$20                                ;C330BA
	lda $04                                 ;C330BC
	sec                                     ;C330BE
	sbc $01,s                               ;C330BF
	sta $04                                 ;C330C1
	ldx #$FF                                ;C330C3
.ACCU 8
@lbl_C330C5:
	rep #$20 ;A->16
	stx.b wTemp00
	lda.b wTemp04
	sta.b wTemp02
	pla
	ply
	plp
	rtl

func_C330D1:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	ldy.b #$00
	bra func_C330FC

func_C330DA:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	tax
	lda.l DATA8_C341BB,x
	cmp.b #$0B
	bne @lbl_C330F8
	jsl.l func_C33170
	lda.b #$FF
	sta.b wTemp00
	sta.b wTemp01
	plp
	rtl
@lbl_C330F8:
	rep #$20 ;A->16
	ldy.b #$01
func_C330FC:
	phy
	ldx.b wTemp00
	lda.b wTemp02
	sta.b wTemp00
	phx
	jsl.l func_C36783
	plx
	lda.b wTemp00
	bpl @lbl_C3312A
	ply                                     ;C3310D
	.db $F0,$0D   ;C3310E
	lda #$0017                              ;C33110
	sta $00                                 ;C33113
	stx $02                                 ;C33115
	phx                                     ;C33117
	jsl.l DisplayMessage
	plx                                     ;C3311C
	stx $00                                 ;C3311D
	jsl $C306F4                             ;C3311F
	lda #$FFFF                              ;C33123
	sta $00                                 ;C33126
	plp                                     ;C33128
	rtl                                     ;C33129
@lbl_C3312A:
	cpx.b #$7F
	bne @lbl_C3313B
	pha
	phx
	jsl.l RestoreItemFromThrowTemp
	plx
	pla
	ldy.b wTemp00
	bmi @lbl_C3315B
	tyx
@lbl_C3313B:
	sta.b wTemp00
	stx.b wTemp02
	pha
	phx
	jsl.l func_C35BA2
	plx
	pla
	ply
	beq @lbl_C33157
	pha
	lda.w #$0016
	sta.b wTemp00
	stx.b wTemp02
	jsl.l DisplayMessage
	pla
@lbl_C33157:
	sta.b wTemp00
	plp
	rtl
@lbl_C3315B:
	ply                                     ;C3315B
	.db $F0,$0B   ;C3315C
	lda #$0017                              ;C3315E
	sta $00                                 ;C33161
	stx $02                                 ;C33163
	jsl.l DisplayMessage
	lda #$FFFF                              ;C33169
	sta $00                                 ;C3316C
	plp                                     ;C3316E
	rtl                                     ;C3316F

func_C33170:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemType,x
	cmp.b #$C4
	beq @lbl_C3319B
	rep #$20 ;A->16
	lda.b wTemp02
	pha
	lda.w #$00CE
	sta.b wTemp00
	stx.b wTemp02
	phx
	jsl.l DisplayMessage
	plx
	pla
	jsr.w func_C331B2
	stx.b wTemp00
	jsl.l FreeFloorItemSlot
	plp
	rtl
@lbl_C3319B:
	rep #$20                                ;C3319B
	stx $00                                 ;C3319D
	lda #$0045                              ;C3319F
	sta $02                                 ;C331A2
	phx                                     ;C331A4
	jsl $C62642                             ;C331A5
	plx                                     ;C331A9
	stx $00                                 ;C331AA
	jsl $C306F4                             ;C331AC
	plp                                     ;C331B0
	rtl                                     ;C331B1

func_C331B2:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	phx
	pha
	sep #$30 ;AXY->8
	lda.l wItemType,x
	cmp.b #$BE
	bne @lbl_C331DE
	rep #$20                                ;C331C3
	lda $01,s                               ;C331C5
	sta $00                                 ;C331C7
	sep #$20                                ;C331C9
	phx                                     ;C331CB
	lda $7E8C8C,x                           ;C331CC
	jsr $2C04                               ;C331D0
	plx                                     ;C331D3
	stx $00                                 ;C331D4
	phx                                     ;C331D6
	jsl $C30192                             ;C331D7
	plx                                     ;C331DB
	.db $80,$44   ;C331DC
@lbl_C331DE:
	cmp.b #$BD
	bne @lbl_C331F1
	rep #$20                                ;C331E2
	lda $01,s                               ;C331E4
	sta $00                                 ;C331E6
	sep #$20                                ;C331E8
	phx                                     ;C331EA
	jsr $329C                               ;C331EB
	plx                                     ;C331EE
	.db $80,$31   ;C331EF
@lbl_C331F1:
	cmp.b #$C1
	bne @lbl_C33210
	rep #$20                                ;C331F5
	lda $01,s                               ;C331F7
	sta $00                                 ;C331F9
	sep #$20                                ;C331FB
	phx                                     ;C331FD
	lda $7E8C8C,x                           ;C331FE
	jsr $2C4A                               ;C33202
	plx                                     ;C33205
	stx $00                                 ;C33206
	phx                                     ;C33208
	jsl $C30192                             ;C33209
	plx                                     ;C3320D
	.db $80,$12   ;C3320E
@lbl_C33210:
	cmp.b #$C5
	bne @lbl_C33222
	rep #$20                                ;C33214
	lda $01,s                               ;C33216
	sta $00                                 ;C33218
	sep #$20                                ;C3321A
	phx                                     ;C3321C
	jsl $C3D9F7                             ;C3321D
	plx                                     ;C33221
@lbl_C33222:
	bra @lbl_C33280
@lbl_C33224:
	sep #$20                                ;C33224
	lda $04,s                               ;C33226
	tax                                     ;C33228
	lda $7E8C8C,x                           ;C33229
	inc a                                   ;C3322D
	sta $7E8C8C,x                           ;C3322E
	ldy #$00                                ;C33232
	plx                                     ;C33234
	lda $7E8E0C,x                           ;C33235
	pha                                     ;C33239
	cmp #$FF                                ;C3323A
	beq @lbl_C33245                         ;C3323C
	iny                                     ;C3323E
	lda #$FF                                ;C3323F
	sta $7E8E0C,x                           ;C33241
@lbl_C33245:
	rep #$20                                ;C33245
	stx $00                                 ;C33247
	lda $02,s                               ;C33249
	sta $02                                 ;C3324B
	phx                                     ;C3324D
	phy                                     ;C3324E
	jsl $C330D1                             ;C3324F
	ply                                     ;C33253
	plx                                     ;C33254
	lda $00                                 ;C33255
	bmi @lbl_C33277                         ;C33257
	sta $06                                 ;C33259
	lda $02,s                               ;C3325B
	sta $04                                 ;C3325D
	stx $00                                 ;C3325F
	lda $7E8B8C,x                           ;C33261
	tax                                     ;C33265
	lda $C341BB,x                           ;C33266
	sta $01                                 ;C3326A
	lda #$0240                              ;C3326C
	sta $02                                 ;C3326F
	phy                                     ;C33271
	jsl $C626CA                             ;C33272
	ply                                     ;C33276
@lbl_C33277:
	cpy #$01                                ;C33277
	beq @lbl_C33224                         ;C33279
	plx                                     ;C3327B
	sep #$20                                ;C3327C
	.db $80,$13   ;C3327E
@lbl_C33280:
	sep #$20 ;A->8
	lda.l wItemPotNextItem,x
	cmp.b #$FF
	beq @lbl_C33293
	pha                                     ;C3328A
	lda #$FF                                ;C3328B
	sta $7E8E0C,x                           ;C3328D
	.db $80,$91   ;C33291
@lbl_C33293:
	jsl.l func_C625CE
	pla
	pla
	plx
	plp
	rts
	php                                     ;C3329C
	rep #$20                                ;C3329D
	sep #$10                                ;C3329F
	lda $00                                 ;C332A1
	sta $00                                 ;C332A3
	pha                                     ;C332A5
	jsl $C359AF                             ;C332A6
	pla                                     ;C332AA
	ldx $02                                 ;C332AB
	bmi @lbl_C332D5                         ;C332AD
	ldx $01                                 ;C332AF
	bmi @lbl_C332C3                         ;C332B1
	cpx #$7F                                ;C332B3
	bcs @lbl_C332CB                         ;C332B5
	stx $00                                 ;C332B7
	pha                                     ;C332B9
	phx                                     ;C332BA
	jsl $C306F4                             ;C332BB
	plx                                     ;C332BF
	pla                                     ;C332C0
	bra @lbl_C332CB                         ;C332C1
@lbl_C332C3:
	cpx #$80                                ;C332C3
	beq @lbl_C332CB                         ;C332C5
	cpx #$C0                                ;C332C7
	bcc @lbl_C332D5                         ;C332C9
@lbl_C332CB:
	ldx #$E0                                ;C332CB
	sta $00                                 ;C332CD
	stx $02                                 ;C332CF
	jsl $C35BA2                             ;C332D1
@lbl_C332D5:
	plp                                     ;C332D5
	rts                                     ;C332D6

func_C332D7:
	php
	sep #$30 ;AXY->8
	ldx.b #$7E
@lbl_C332DC:
	lda.l wItemType,x
	cmp.b #$B7
	bne @lbl_C332F6
	phx                                     ;C332E4
@lbl_C332E5:
	phx                                     ;C332E5
	jsr $3319                               ;C332E6
	plx                                     ;C332E9
	lda $7E8E0C,x                           ;C332EA
	tax                                     ;C332EE
	cmp #$FF                                ;C332EF
	bne @lbl_C332E5                         ;C332F1
	plx                                     ;C332F3
	.db $80,$1E   ;C332F4
@lbl_C332F6:
	cmp.b #$BB
	bne @lbl_C33314
	phx                                     ;C332FA
@lbl_C332FB:
	phx                                     ;C332FB
	jsr $3347                               ;C332FC
	plx                                     ;C332FF
	phx                                     ;C33300
	jsr $3347                               ;C33301
	plx                                     ;C33304
	phx                                     ;C33305
	jsr $3347                               ;C33306
	plx                                     ;C33309
	lda $7E8E0C,x                           ;C3330A
	tax                                     ;C3330E
	cmp #$FF                                ;C3330F
	bne @lbl_C332FB                         ;C33311
	plx                                     ;C33313
@lbl_C33314:
	dex
	bpl @lbl_C332DC
	plp
	rtl
	php                                     ;C33319
	sep #$30                                ;C3331A
	stx $00                                 ;C3331C
	phx                                     ;C3331E
	jsl $C30710                             ;C3331F
	plx                                     ;C33323
	lda $00                                 ;C33324
	cmp #$03                                ;C33326
	beq @lbl_C33336                         ;C33328
	cmp #$05                                ;C3332A
	beq @lbl_C33336                         ;C3332C
	cmp #$07                                ;C3332E
	beq @lbl_C33336                         ;C33330
	lda $01                                 ;C33332
	bra @lbl_C33345                         ;C33334
@lbl_C33336:
	lda $7E8C8C,x                           ;C33336
	bmi @lbl_C33340                         ;C3333A
	cmp #$63                                ;C3333C
	bpl @lbl_C33345                         ;C3333E
@lbl_C33340:
	inc a                                   ;C33340
	sta $7E8C8C,x                           ;C33341
@lbl_C33345:
	plp                                     ;C33345
	rts                                     ;C33346
	php                                     ;C33347
	sep #$30                                ;C33348
	stx $00                                 ;C3334A
	phx                                     ;C3334C
	jsl $C30710                             ;C3334D
	plx                                     ;C33351
	lda $01                                 ;C33352
	lda $00                                 ;C33354
	cmp #$03                                ;C33356
	beq @lbl_C33362                         ;C33358
	cmp #$05                                ;C3335A
	beq @lbl_C33362                         ;C3335C
	cmp #$07                                ;C3335E
	bne @lbl_C3336F                         ;C33360
@lbl_C33362:
	lda $04                                 ;C33362
	beq @lbl_C3336F                         ;C33364
	lda $7E8C8C,x                           ;C33366
	dec a                                   ;C3336A
	sta $7E8C8C,x                           ;C3336B
@lbl_C3336F:
	plp                                     ;C3336F
	rts                                     ;C33370
	lda $7E8C8C,x                           ;C33371
	bpl @lbl_C3337B                         ;C33375
	cmp #$F7                                ;C33377
	bmi @lbl_C33380                         ;C33379
@lbl_C3337B:
	dec a                                   ;C3337B
	sta $7E8C8C,x                           ;C3337C
@lbl_C33380:
	plp                                     ;C33380
	rts                                     ;C33381

ExecutePreparedThrowEffect:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp05
	phx
	ldx.b wTemp00
	phx
	lda.l wItemType,x
	pha
	lda.b wTemp04
	pha
	lda.b wTemp01
	pha
	rep #$20 ;A->16
	lda.b wTemp02
	pha
	sep #$20 ;A->8
	lda.b wTemp04,s
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp04
	cmp.b #$00
	beq @lbl_C333AD
	bra @lbl_C333C8
@lbl_C333AD:
	sep #$20 ;A->8
	lda.b #$13
	sta.b wTemp00
	ldy.b #$84
	lda.b wTemp05,s
	tax
	lda.l DATA8_C341BB,x
	cmp.b #$04
	bne @lbl_C333C2
	ldy.b #$83
@lbl_C333C2:
	sty.b wTemp02
	jsl.l PlayCharacterEffect
@lbl_C333C8:
	lda.b wTemp07,s
	bne @lbl_C333D2
	lda.b wTemp05,s
	cmp.b #$12
	bne @lbl_C333D5
@lbl_C333D2:
	jmp $34ED                               ;C333D2
@lbl_C333D5:
	sep #$20 ;A->8
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b #$0A
	sta.b wTemp01
	rep #$20 ;A->16
	lda.b wTemp01,s
	sta.b wTemp02
	jsl.l func_C32FEE
	ldy.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp04
	lda.b wTemp02
	sta.b wTemp06
	sta.b wTemp01,s
	sep #$20 ;A->8
	lda.b wTemp06,s
	sta.b wTemp00
	lda.b wTemp05,s
	tax
	lda.l DATA8_C341BB,x
	sta.b wTemp01
	lda.b #$44
	sta.b wTemp02
	lda.b wTemp03,s
	sta.b wTemp03
	phy
	jsl.l func_C626CA
	ply
	cpy.b #$00
	bmi @lbl_C33495
	sty.b wTemp00
	lda.b wTemp04,s
	sta.b wTemp01
	phy
	jsl.l func_C2286F
	ply
	ldx.b wTemp00
	beq @lbl_C33495
	jsr.w func_C335FE
	cmp.b #$00
	beq @lbl_C33489
	lda.b wTemp05,s
	tax
	lda.l DATA8_C341BB,x
	cmp.b #$00
	beq @lbl_C33440
	cmp.b #$07
	bne @lbl_C3344C
	lda.b #$0A
	bra @lbl_C33442
@lbl_C33440:
	lda.b #$0E
@lbl_C33442:
	sta.b wTemp02
	sty.b wTemp00
	phy
	jsl.l PlayVisualEffect
	ply
@lbl_C3344C:
	sty.b wTemp03
	stz.b wTemp01
	lda.b wTemp06,s
	sta.b wTemp02
	lda.b wTemp05,s
	tax
	lda.l DATA8_C341BB,x
	ldx.b #$14 ;print Text20
	cmp.b #$04
	bne @lbl_C33463
	ldx.b #$BE ;print Text190
@lbl_C33463:
	stx.b wTemp00
	phy
	jsl.l DisplayMessage
	ply
	sty.b wTemp00
	lda.b wTemp04,s
	sta.b wTemp01
	lda.b wTemp06,s
	tay
	lda.b wTemp05,s
	rep #$30 ;AXY->16
	and.w #$00FF
	asl a
	tax
	pea.w $3488
	lda.l ItemThrowEffectFunctionTable,x
	pha
	sep #$10 ;XY->8
	tyx
	rts
@lbl_C33489:
	sep #$30 ;AXY->8
	lda.b wTemp06,s
	sta.b wTemp00
	jsl.l FreeFloorItemSlot
	bra @lbl_C334C5
@lbl_C33495:
	rep #$20 ;A->16
	lda.b wTemp01,s
	sta.b wTemp02
	sep #$20 ;A->8
	lda.b wTemp06,s
	sta.b wTemp00
	phy
	jsl.l func_C330DA
	ply
	lda.b wTemp00
	bmi @lbl_C334BB
	sta.b wTemp04
	lda.b wTemp01
	sta.b wTemp05
	lda.b wTemp06,s
	sta.b wTemp00
	phy
	jsl.l func_C62720
	ply
@lbl_C334BB:
	cpy.b #$00
	bmi @lbl_C334C5
	sty.b wTemp00
	jsl.l func_C22C1C
@lbl_C334C5:
	rep #$20 ;A->16
	pla
	pla
	pla
	plx
	plp
	rtl

DATA8_C334CD:
	.db $01,$00,$01,$FF,$00,$FF,$FF,$FE   ;C334CD
	.db $FF,$FF,$FF,$00,$00,$01           ;C334D5
	.db $01,$01,$3C,$3C,$00,$C4,$C4,$C4,$00,$3C,$00,$C4,$C4,$C4,$00,$3C   ;C334DB  
	.db $3C,$3C   ;C334EB
	sep #$30                                ;C334ED
	lda $06,s                               ;C334EF
	sta $00                                 ;C334F1
	lda $05,s                               ;C334F3
	tax                                     ;C334F5
	lda $C341BB,x                           ;C334F6
	sta $01                                 ;C334FA
	lda #$44                                ;C334FC
	sta $02                                 ;C334FE
	lda $03,s                               ;C33500
	sta $03                                 ;C33502
	tax                                     ;C33504
	rep #$20                                ;C33505
	lda $01,s                               ;C33507
	sta $04                                 ;C33509
	sep #$20                                ;C3350B
	clc                                     ;C3350D
	adc $C334DD,x                           ;C3350E
	sta $06                                 ;C33512
	bpl @lbl_C33518                         ;C33514
	stz $06                                 ;C33516
@lbl_C33518:
	xba                                     ;C33518
	clc                                     ;C33519
	adc $C334E5,x                           ;C3351A
	sta $07                                 ;C3351E
	bpl @lbl_C33524                         ;C33520
	stz $07                                 ;C33522
@lbl_C33524:
	jsl $C626CA                             ;C33524
	lda $03,s                               ;C33528
	asl a                                   ;C3352A
	tax                                     ;C3352B
	ldy #$00                                ;C3352C
@lbl_C3352E:
	phx                                     ;C3352E
	phy                                     ;C3352F
	rep #$20                                ;C33530
	lda $C334CD,x                           ;C33532
	clc                                     ;C33536
	adc $03,s                               ;C33537
	sta $03,s                               ;C33539
	sta $00                                 ;C3353B
	sep #$20                                ;C3353D
	jsl $C359AF                             ;C3353F
	lda $02                                 ;C33543
	cmp #$F0                                ;C33545
	beq @lbl_C33554                         ;C33547
	ldx $00                                 ;C33549
	bpl @lbl_C33566                         ;C3354B
@lbl_C3354D:
	ply                                     ;C3354D
	plx                                     ;C3354E
	dey                                     ;C3354F
	bne @lbl_C3352E                         ;C33550
	bra @lbl_C33556                         ;C33552
@lbl_C33554:
	ply                                     ;C33554
	plx                                     ;C33555
@lbl_C33556:
	lda $06,s                               ;C33556
	sta $00                                 ;C33558
	jsl $C306F4                             ;C3355A
	rep #$20                                ;C3355E
	pla                                     ;C33560
	pla                                     ;C33561
	pla                                     ;C33562
	plx                                     ;C33563
	plp                                     ;C33564
	rtl                                     ;C33565
@lbl_C33566:
	sep #$20                                ;C33566
	stx $00                                 ;C33568
	phx                                     ;C3356A
	jsl $C20E3A                             ;C3356B
	plx                                     ;C3356F
	ldy $00                                 ;C33570
	bmi @lbl_C3354D                         ;C33572
	stx $00                                 ;C33574
	lda $06,s                               ;C33576
	sta $01                                 ;C33578
	phx                                     ;C3357A
	jsl $C2286F                             ;C3357B
	plx                                     ;C3357F
	ldy $00                                 ;C33580
	.db $F0,$71   ;C33582
	txy                                     ;C33584
	lda $07,s                               ;C33585
	tax                                     ;C33587
	lda $C341BB,x                           ;C33588
	cmp #$00                                ;C3358C
	beq @lbl_C33598                         ;C3358E
	cmp #$07                                ;C33590
	bne @lbl_C335A4                         ;C33592
	lda #$0A                                ;C33594
	bra @lbl_C3359A                         ;C33596
@lbl_C33598:
	lda #$0E                                ;C33598
@lbl_C3359A:
	sta $02                                 ;C3359A
	sty $00                                 ;C3359C
	phy                                     ;C3359E
	jsl PlayVisualEffect                             ;C3359F
	ply                                     ;C335A3
@lbl_C335A4:
	sty $03                                 ;C335A4
	lda $07,s                               ;C335A6
	tax                                     ;C335A8
	lda $C341BB,x                           ;C335A9
	ldx #$14                                ;C335AD
	cmp #$04                                ;C335AF
	bne @lbl_C335B5                         ;C335B1
	ldx #$BE                                ;C335B3
@lbl_C335B5:
	stx $00                                 ;C335B5
	stz $01                                 ;C335B7
	lda $08,s                               ;C335B9
	sta $02                                 ;C335BB
	phy                                     ;C335BD
	jsl.l DisplayMessage
	ply                                     ;C335C1
	sty $00                                 ;C335C2
	lda $06,s                               ;C335C4
	sta $01                                 ;C335C6
	lda $08,s                               ;C335C8
	tay                                     ;C335CA
	lda $07,s                               ;C335CB
	rep #$30                                ;C335CD
	and #$00FF                              ;C335CF
	asl a                                   ;C335D2
	tax                                     ;C335D3
	pea $35F2                               ;C335D4
	lda $C3472B,x                           ;C335D7
	cmp #$377B                              ;C335DB
	beq @lbl_C335EA                         ;C335DE
	cmp #$3716                              ;C335E0
	beq @lbl_C335EA                         ;C335E3
	cmp #$36F2                              ;C335E5
	bne @lbl_C335ED                         ;C335E8
@lbl_C335EA:
	lda #$3877                              ;C335EA
@lbl_C335ED:
	pha                                     ;C335ED
	sep #$10                                ;C335EE
	tyx                                     ;C335F0
	rts                                     ;C335F1
	sep #$30                                ;C335F2
	stx $00                                 ;C335F4
	jsl $C22C1C                             ;C335F6
	jmp $354D                               ;C335FA

func_C335FE:
	php
	sep #$30 ;AXY->8
	sty.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp04
	cmp.b #$08
	beq @lbl_C33611
	lda.b #$01
	plp
	rts
@lbl_C33611:
	rep #$20 ;A->16
	lda.b wTemp00
	sta.b wTemp04
	sta.b wTemp06
	sep #$20 ;A->8
	lda.b w0009,s
	tax
	sta.b wTemp00
	lda.b #$46
	sta.b wTemp02
	lda.b #$06
	sta.b wTemp03
	lda.l wItemType,x
	tax
	lda.l DATA8_C341BB,x
	sta.b wTemp01
	phx
	phy
	jsl.l func_C626CA
	ply
	plx
	cpx.b #$2C
	bne @lbl_C3364B
	sty $00                                 ;C3363F
	lda #$01                                ;C33641
	sta $01                                 ;C33643
	phy                                     ;C33645
	jsl ApplyCharacterLevelGains                             ;C33646
	ply                                     ;C3364A
@lbl_C3364B:
	lda.b #$00
	plp
	rts
	sep #$30                                ;C3364F
	txy                                     ;C33651
	lda $7E8B8C,x                           ;C33652
	tax                                     ;C33656
	lda $C342A3,x                           ;C33657
	tyx                                     ;C3365B
	clc                                     ;C3365C
	adc $7E8C8C,x                           ;C3365D
	sta $02                                 ;C33661
	jsl $C22D1A                             ;C33663
	rts                                     ;C33667
	sep #$30                                ;C33668
	txy                                     ;C3366A
	lda $7E8B8C,x                           ;C3366B
	tax                                     ;C3366F
	lda $C342A3,x                           ;C33670
	tyx                                     ;C33674
	clc                                     ;C33675
	adc $7E8C8C,x                           ;C33676
	rep #$10                                ;C3367A
	ldx $00                                 ;C3367C
	sta $01                                 ;C3367E
	sta $00                                 ;C33680
	dec a                                   ;C33682
	bmi @lbl_C33687                         ;C33683
	sta $00                                 ;C33685
@lbl_C33687:
	phx                                     ;C33687
	jsl $C3F69F                             ;C33688
	plx                                     ;C3368C
	lda $00                                 ;C3368D
	sta $02                                 ;C3368F
	stx $00                                 ;C33691
	jsl $C228DF                             ;C33693
	rts                                     ;C33697
	sep #$30 ;AXY->8
	lda.b #$05
@lbl_C3369C:
	ldy.b wTemp00
	cpy.b #$13
	beq @lbl_C336A9
	sta.b wTemp02
	jsl.l func_C22D1A
	rts
@lbl_C336A9:
	ldy.b wTemp01
	ldx.b wTemp00
	sty.b wTemp00
	phx
	jsl.l GetCharacterStats
	plx
	lda.b wTemp07
	sta.b wTemp02
	stx.b wTemp00
	sty.b wTemp01
	jsl.l func_C228EF
	rts
	sep #$30 ;AXY->8
	lda.b #$0C
	bra @lbl_C3369C
	sep #$30                                ;C336C8
	lda #$0A                                ;C336CA
	.db $80,$CE   ;C336CC
	sep #$30                                ;C336CE
	phy                                     ;C336D0
	lda #$43                                ;C336D1
	sta $02                                 ;C336D3
	jsl $C62642                             ;C336D5
	jsl $C2412A                             ;C336D9
	lda $00                                 ;C336DD
	ply                                     ;C336DF
	sty $00                                 ;C336E0
	pha                                     ;C336E2
	jsl $C30192                             ;C336E3
	pla                                     ;C336E7
	sta $00                                 ;C336E8
	lda #$01                                ;C336EA
	sta $02                                 ;C336EC
	jsl PlayVisualEffect                             ;C336EE
	rts                                     ;C336F2
	rep #$20                                ;C336F3
	sep #$10                                ;C336F5
	lda $00                                 ;C336F7
	phx                                     ;C336F9
	pha                                     ;C336FA
	jsr $3878                               ;C336FB
	rep #$20                                ;C336FE
	sep #$10                                ;C33700
	pla                                     ;C33702
	sta $00                                 ;C33703
	jsl $C210AC                             ;C33705
	lda $00                                 ;C33709
	sta $02                                 ;C3370B
	plx                                     ;C3370D
	stx $00                                 ;C3370E
	phx                                     ;C33710
	jsl $C33170                             ;C33711
	plx                                     ;C33715
	rts                                     ;C33716
	rep #$20                                ;C33717
	sep #$10                                ;C33719
	lda $00                                 ;C3371B
	stx $00                                 ;C3371D
	sta $02                                 ;C3371F
	jsl $C33170                             ;C33721
	rts                                     ;C33725
	sep #$20                                ;C33726
	rep #$10                                ;C33728
	ldy $00                                 ;C3372A
	phy                                     ;C3372C
	jsl $C210AC                             ;C3372D
	lda $03                                 ;C33731
	cmp #$5D                                ;C33733
	beq @lbl_C3373D                         ;C33735
	ply                                     ;C33737
	sty $00                                 ;C33738
	jmp $3878                               ;C3373A
@lbl_C3373D:
	plx                                     ;C3373D
	sep #$10                                ;C3373E
	lda #$01                                ;C33740
	.db $9F   ;C33742
	.db $71   ;C33743
	dey                                     ;C33744
	.db $7E   ;C33745
	phx                                     ;C33746
	lda #$01                                ;C33747
	sta $00                                 ;C33749
	lda #$01                                ;C3374B
	sta $02                                 ;C3374D
	jsl.l _SetEvent
	jsl $C62405                             ;C33753
	rep #$10                                ;C33757
	ldx #$06A3                              ;C33759
	stx $00                                 ;C3375C
.INDEX 8
	jsl.l DisplayMessage
	ldx #$03                                ;C33762
	ora #$86                                ;C33764
	.db $00   ;C33766
	pla                                     ;C33767
	sta $02                                 ;C33768
	jsl.l DisplayMessage
	ldx #$A4                                ;C3376E
	asl $86                                 ;C33770
	.db $00   ;C33772
	jsl.l DisplayMessage
	jsl $C62437                             ;C33777
	rts                                     ;C3377B
	sep #$20                                ;C3377C
	rep #$10                                ;C3377E
	ldy $00                                 ;C33780
	phy                                     ;C33782
	phx                                     ;C33783
	jsl $C210AC                             ;C33784
	plx                                     ;C33788
	lda $03                                 ;C33789
	cmp #$44                                ;C3378B
	bne @lbl_C3379C                         ;C3378D
	ldy $00                                 ;C3378F
	sty $02                                 ;C33791
	stx $00                                 ;C33793
	jsl $C33170                             ;C33795
	jmp $37B9                               ;C33799
@lbl_C3379C:
	ply                                     ;C3379C
	sty $00                                 ;C3379D
	jmp $36F3                               ;C3379F
	sep #$20                                ;C337A2
	rep #$10                                ;C337A4
	ldy $00                                 ;C337A6
	phy                                     ;C337A8
	jsl $C210AC                             ;C337A9
	lda $03                                 ;C337AD
	cmp #$44                                ;C337AF
	beq @lbl_C337B9                         ;C337B1
	ply                                     ;C337B3
	sty $00                                 ;C337B4
	jmp $3878                               ;C337B6
@lbl_C337B9:
	lda $01,s                               ;C337B9
	sta $00                                 ;C337BB
	jsl $C2159E                             ;C337BD
	jsl $C62405                             ;C337C1
	ldy #$0764                              ;C337C5
	sty $00                                 ;C337C8
	jsl.l DisplayMessage
	ldy #$0922                              ;C337CE
	sty $00                                 ;C337D1
	jsl.l DisplayMessage
	lda #$08                                ;C337D7
	sta $00                                 ;C337D9
	lda #$01                                ;C337DB
	sta $02                                 ;C337DD
	jsl.l _SetEvent
	lda #$87                                ;C337E3
	sta $00                                 ;C337E5
	lda #$03                                ;C337E7
	sta $02                                 ;C337E9
	jsl.l _SetEvent
	ply                                     ;C337EF
	rts                                     ;C337F0
	sep #$30                                ;C337F1
	lda $00                                 ;C337F3
	cmp #$13                                ;C337F5
	beq @lbl_C337FC                         ;C337F7
	jmp $3878                               ;C337F9
@lbl_C337FC:
	lda $00                                 ;C337FC
	pha                                     ;C337FE
	lda $01                                 ;C337FF
	pha                                     ;C33801
	ldx #$00                                ;C33802
	bra @lbl_C33830                         ;C33804
@lbl_C33806:
	phx                                     ;C33806
	tax                                     ;C33807
	lda $7E8C8C,x                           ;C33808
	beq @lbl_C3382E                         ;C3380C
	lda $7E8B8C,x                           ;C3380E
	cmp #$B4                                ;C33812
	beq @lbl_C3383F                         ;C33814
	cmp #$B6                                ;C33816
	beq @lbl_C3383F                         ;C33818
	cmp #$B7                                ;C3381A
	beq @lbl_C3383F                         ;C3381C
	cmp #$B8                                ;C3381E
	beq @lbl_C3383F                         ;C33820
	cmp #$BB                                ;C33822
	beq @lbl_C3383F                         ;C33824
	cmp #$C0                                ;C33826
	beq @lbl_C3383F                         ;C33828
	cmp #$BF                                ;C3382A
	beq @lbl_C3383F                         ;C3382C
@lbl_C3382E:
	plx                                     ;C3382E
	inx                                     ;C3382F
@lbl_C33830:
	lda $7E894F,x                           ;C33830
	bpl @lbl_C33806                         ;C33834
	pla                                     ;C33836
	sta $01                                 ;C33837
	pla                                     ;C33839
	sta $00                                 ;C3383A
	jmp $3878                               ;C3383C
@lbl_C3383F:
	pla                                     ;C3383F
	lda $7E8C8C,x                           ;C33840
	dec a                                   ;C33844
	sta $7E8C8C,x                           ;C33845
	txy                                     ;C33849
	bra @lbl_C3384D                         ;C3384A
@lbl_C3384C:
	tax                                     ;C3384C
@lbl_C3384D:
	lda $7E8E0C,x                           ;C3384D
	bpl @lbl_C3384C                         ;C33851
	lda #$40                                ;C33853
	sta $00                                 ;C33855
	phx                                     ;C33857
	phy                                     ;C33858
	jsl $C3035D                             ;C33859
	ply                                     ;C3385D
	plx                                     ;C3385E
	lda $00                                 ;C3385F
	.db $30,$12   ;C33861
	sta $7E8E0C,x                           ;C33863
	lda #$0D                                ;C33867
	sta $00                                 ;C33869
	lda #$01                                ;C3386B
	sta $01                                 ;C3386D
	sty $02                                 ;C3386F
	jsl.l DisplayMessage
	pla                                     ;C33875
	pla                                     ;C33876
	rts                                     ;C33877
@lbl_C33878:
	rep #$20                                ;C33878
	lda $00                                 ;C3387A
	pha                                     ;C3387C
	lda #$0201                              ;C3387D
	sta $00                                 ;C33880
	jsl $C3F69F                             ;C33882
	lda $00                                 ;C33886
	sta $02                                 ;C33888
	pla                                     ;C3388A
	sta $00                                 ;C3388B
	jsl $C228DF                             ;C3388D
	rts                                     ;C33891
	rep #$20                                ;C33892
	sep #$10                                ;C33894
	lda $00                                 ;C33896
	pha                                     ;C33898
	jsl $C210AC                             ;C33899
	pla                                     ;C3389D
	sta $00                                 ;C3389E
	ldx $03                                 ;C338A0
	cpx #$50                                ;C338A2
	beq @lbl_C338BE                         ;C338A4
	cpx #$23                                ;C338A6
	bne @lbl_C33878                         ;C338A8
	pha                                     ;C338AA
	jsl.l GetCharacterStats                             ;C338AB
	lda $00                                 ;C338AF
	and #$00FF                              ;C338B1
	sta $02                                 ;C338B4
	pla                                     ;C338B6
	sta $00                                 ;C338B7
	jsl $C228DF                             ;C338B9
	rts                                     ;C338BD
@lbl_C338BE:
	sep #$30                                ;C338BE
	ldx $00                                 ;C338C0
	lda $7E8871,x                           ;C338C2
	cmp #$07                                ;C338C6
	.db $D0,$11   ;C338C8
	dec a                                   ;C338CA
	sta $7E8871,x                           ;C338CB
	lda #$53                                ;C338CF
	sta $00                                 ;C338D1
	lda #$07                                ;C338D3
	sta $01                                 ;C338D5
	jsl.l DisplayMessage
	rts                                     ;C338DB
	rep #$20                                ;C338DC
	lda $00                                 ;C338DE
	pha                                     ;C338E0
	sep #$30                                ;C338E1
	lda $7E8D0C,x                           ;C338E3
	sta $01                                 ;C338E7
	lda $7E8C8C,x                           ;C338E9
	sta $00                                 ;C338ED
	rep #$20                                ;C338EF
	lda $00                                 ;C338F1
	cmp #$09F6                              ;C338F3
	sep #$20                                ;C338F6
	bcc @lbl_C338FE                         ;C338F8
	lda #$FF                                ;C338FA
	bra @lbl_C33908                         ;C338FC
@lbl_C338FE:
	lda #$0A                                ;C338FE
	sta $02                                 ;C33900
	jsl Divide16Bit                             ;C33902
	lda $00                                 ;C33906
@lbl_C33908:
	sta $02                                 ;C33908
	rep #$20                                ;C3390A
	pla                                     ;C3390C
	sta $00                                 ;C3390D
	jsl $C228DF                             ;C3390F
	rts                                     ;C33913
	sep #$30                                ;C33914
	lda $00                                 ;C33916
	pha                                     ;C33918
	lda $7E8C8C,x                           ;C33919
	sta $01                                 ;C3391D
	lda $7E8D0C,x                           ;C3391F
	sta $02                                 ;C33923
	jsl $C280D4                             ;C33925
	ldy $00                                 ;C33929
	lda #$0C                                ;C3392B
	sta $02                                 ;C3392D
	phy                                     ;C3392F
	jsl PlayVisualEffect                             ;C33930
	ply                                     ;C33934
	pla                                     ;C33935
	sta $00                                 ;C33936
	cpy $00                                 ;C33938
	beq @lbl_C33940                         ;C3393A
	jsl $C625B9                             ;C3393C
@lbl_C33940:
	rts                                     ;C33940
	rep #$20                                ;C33941
	lda $00                                 ;C33943
	pha                                     ;C33945
	lda #$0201                              ;C33946
	sta $00                                 ;C33949
	jsl $C3F69F                             ;C3394B
	lda $00                                 ;C3394F
	sta $02                                 ;C33951
	pla                                     ;C33953
	sta $00                                 ;C33954
	jsl $C228DF                             ;C33956
	rts                                     ;C3395A
	sep #$20                                ;C3395B
	lda $00                                 ;C3395D
	pha                                     ;C3395F
	jsl $C28A40                             ;C33960
	pla                                     ;C33964
	sta $02                                 ;C33965
	rep #$20                                ;C33967
	lda #$0161                              ;C33969
	sta $00                                 ;C3396C
	jsl.l DisplayMessage
	rts                                     ;C33972
DragonHerbThrowEffect:
	sep #$20                                ;C33973
	rep #$10                                ;C33975
	ldy $00                                 ;C33977
	lda #$09                                ;C33979
	sta $02                                 ;C3397B
	phy                                     ;C3397D
	jsl PlayVisualEffect                             ;C3397E
	ply                                     ;C33982
	lda #$23                                ;C33983
	sta $00                                 ;C33985
	lda #$28                                ;C33987
	sta $01                                 ;C33989
	phy                                     ;C3398B
	jsl $C3F69F                             ;C3398C
	ply                                     ;C33990
	lda $00                                 ;C33991
	sta $02                                 ;C33993
	sty $00                                 ;C33995
	jsl $C228DF                             ;C33997
	rts                                     ;C3399B
	sep #$20                                ;C3399C
	lda $00                                 ;C3399E
	stz $01                                 ;C339A0
	pha                                     ;C339A2
	jsl $C282F8                             ;C339A3
	pla                                     ;C339A7
	sta $00                                 ;C339A8
	stz $01                                 ;C339AA
	jsl $C240A7                             ;C339AC
	rts                                     ;C339B0
MedicinalHerbThrowEffect:
	sep #$30                                ;C339B1
	lda #$19                                ;C339B3
	bra lbl_C339BB                         ;C339B5
RestorativeHerbThrowEffect:
	sep #$30                                ;C339B7
	lda #$64                                ;C339B9
lbl_C339BB:
	pha                                     ;C339BB
	ldx $00                                 ;C339BC
	ldy $01                                 ;C339BE
	phx                                     ;C339C0
	jsl $C210AC                             ;C339C1
	plx                                     ;C339C5
	lda $03                                 ;C339C6
	cmp #$02                                ;C339C8
	beq lbl_C339ED                         ;C339CA
	cmp #$11                                ;C339CC
	beq lbl_C339ED                         ;C339CE
	cmp #$13                                ;C339D0
	beq lbl_C339ED                         ;C339D2
	cmp #$0E                                ;C339D4
	beq lbl_C339ED                         ;C339D6
	cmp #$21                                ;C339D8
	beq lbl_C339ED                         ;C339DA
	cmp #$18                                ;C339DC
	beq lbl_C339ED                         ;C339DE
	pla                                     ;C339E0
	sta $02                                 ;C339E1
	stz $03                                 ;C339E3
	stx $00                                 ;C339E5
	jsl ModifyCharacterHP                             ;C339E7
	rts                                     ;C339EB
	rts                                     ;C339EC
lbl_C339ED:
	pla                                     ;C339ED
	sta $02                                 ;C339EE
	stx $00                                 ;C339F0
	sty $01                                 ;C339F2
	jsl $C228DF                             ;C339F4
	rts                                     ;C339F8
AntidoteHerbThrowEffect:
	sep #$30                                ;C339F9
	ldx $00                                 ;C339FB
	ldy $01                                 ;C339FD
	phx                                     ;C339FF
	jsl $C210AC                             ;C33A00
	plx                                     ;C33A04
	lda $03                                 ;C33A05
	cmp #$12                                ;C33A07
	beq lbl_C33A0C                         ;C33A09
	rts                                     ;C33A0B
lbl_C33A0C:
	lda #$32                                ;C33A0C
	sta $02                                 ;C33A0E
	stx $00                                 ;C33A10
	sty $01                                 ;C33A12
	phx                                     ;C33A14
	jsl $C228DF                             ;C33A15
	plx                                     ;C33A19
	stx $00                                 ;C33A1A
	jsl $C28305                             ;C33A1C
	rts                                     ;C33A20
