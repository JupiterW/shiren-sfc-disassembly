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
	jsl.l func_C233BE
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
	jsl.l func_C62550
	lda.w #$0160
	sta.b wTemp00
	jsl.l DisplayMessage
	rts

;c309f1
func_C309F1:
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
	jsl.l func_C300D2
	rts

;c30a95
func_C30A95:
	rts

;c30a96
BigBellySeedUseEffect:
	rep #$20 ;A->16
	lda.w #$0064
	sta.b wTemp00
	jsl.l func_C23395
	sep #$20 ;A->8
	lda.b #$0A
	sta.b wTemp02
	jsl.l func_C3E526
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
	jsl.l func_C23395
	sep #$20 ;A->8
	lda.b #$0A
	sta.b wTemp02
	jsl.l func_C3E526
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
	.db $A9,$AD,$85,$00
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
	call_savebank func_C62565
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
	.db $80,$0A
@lbl_C30C68:
	.db $A9,$5C,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $68,$68,$68,$68,$68,$A9   ;C30C68
	.db $01,$85,$00,$28,$6B               ;C30C78  
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
	jsl $C62550                             ;C30C94
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
	.db $8F   ;C30CC7
	.db $5E   ;C30CC8
	.db $93   ;C30CC9
	.db $7E   ;C30CCA
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
	jsl.l func_C62550
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
	.db $A9,$01,$85,$00,$64,$01,$84,$02
	jsl.l DisplayMessage
	.db $A9,$01,$85,$00   ;C30D17
	.db $28,$6B                           ;C30D27
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
	.db $A9,$53,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $68,$68,$68,$A9,$01,$85   ;C30D42
	.db $00,$28,$6B                       ;C30D52
@lbl_C30D55:
	sty.b wTemp00
	phx
	phy
	call_savebank func_C30710
	ply
	plx
	lda.b wTemp05
	cmp.b #$E6
	bne @lbl_C30D73
@lbl_C30D67:
	.db $A9,$82,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $80,$D9                   ;C30D6F  
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
	call_savebank func_C62565
	ply
	plx
	lda.b #$32
	sta.b wTemp00
	stz.b wTemp01
	phx
	phy
	call_savebank func_C233BE
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
	jsl.l func_C285A2
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
	call_savebank func_C62565
	ply
	plx
@lbl_C30DE9:
	lda.w wItemIdentified,x
	bne @lbl_C30E0C
	.db $84,$00,$DA,$5A,$8B,$22,$92,$01,$C3,$AB,$7A,$FA,$A9,$C7,$85,$00   ;C30DEE  
	.db $64,$01,$84,$02,$DA,$5A,$8B
	jsl.l DisplayMessage
	.db $AB,$7A,$FA           ;C30E06  
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
	call_savebank func_C62565
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
	cmp.b #$7B
	beq @lbl_C30E65
	stx.b wTemp00
	jsl.l func_C306F4
	stz.b wTemp00
	plp
	rtl
@lbl_C30E65:
	.db $86,$00,$22,$F4,$06,$C3,$A9,$02   ;C30E65  
	.db $85,$00,$28,$6B                   ;C30E6D  

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
	call_savebank func_C62565
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
	jsl.l func_C21128
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
	jsl.l func_C23209
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
	jsl.l func_C2323C
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0001
	sty.b wTemp02
	jsl.l func_C23209
@lbl_C30EFC:
	rts
RestorativeHerbUseEffect:
	; Heal up to 100 HP. If Shiren is already at max HP, raise max HP by 2 first.
	; Then clear confusion and puzzled status if present.
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C21128
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
	jsl.l func_C23209
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
	jsl.l func_C2323C
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0002
	sty.b wTemp02
	jsl.l func_C23209
@lbl_C30F58:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C285A2
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
	.db $E2,$20,$C2,$10,$A9,$13,$85,$00   ;C30F95
	.db $22,$A2,$85,$C2,$A5,$01,$48,$A5,$03,$48,$A5,$00,$F0,$12,$A0,$13   ;C30F9D  
	.db $00,$84,$00,$22,$A7,$40,$C2,$A0,$9B,$00,$84,$00
	jsl.l DisplayMessage
	.db $68,$F0,$12,$A0,$13,$00,$84,$00,$22,$FF,$3F,$C2,$A0,$67,$00,$84   ;C30FBD
	.db $00
	jsl.l DisplayMessage
	.db $68,$F0,$12,$A0,$13,$00,$84,$00,$22,$73,$40   ;C30FCD
	.db $C2,$A0,$6C,$00,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$30,$A9,$13,$85   ;C30FDD
	.db $00,$22,$28,$11,$C2,$A5,$01,$C5,$00,$F0,$05,$20,$E9,$28,$80,$03   ;C30FED
	.db $20,$FD,$0E,$20,$04,$10,$60       ;C30FFD  

AntidoteHerbUseEffect:
	sep #$20 ;A->8
	jsl.l func_C21167
	lda.b wTemp01
	sec
	sbc.b wTemp00
	beq @lbl_C31021
;C31011  
	.db $85,$00,$22,$71,$32,$C2,$A9,$9D,$85,$00,$64,$01
	jsl.l DisplayMessage
@lbl_C31021:
	rts
StrengthHerbUseEffect:
	.db $E2,$20,$22,$67,$11,$C2,$A5,$00,$C5,$01,$D0,$1F,$A9,$9F,$85,$00   ;C31022
	.db $64,$01,$A9,$01,$85,$02
	jsl.l DisplayMessage
	.db $A9,$01,$85,$00,$22,$BF   ;C31032  
	.db $32,$C2,$A9,$01,$85,$00,$22,$71,$32,$C2,$60,$A9,$9E,$85,$00,$64   ;C31042  
	.db $01,$A9,$01,$85,$02
	jsl.l DisplayMessage
	.db $A9,$01,$85,$00,$22,$71,$32   ;C31052  
	.db $C2,$60,$E2,$20,$22,$67,$11,$C2,$A5,$00,$C5,$01,$D0,$1F,$A9,$9F   ;C31062
	.db $85,$00,$64,$01,$A9,$03,$85,$02
	jsl.l DisplayMessage
	.db $A9,$03,$85,$00   ;C31072  
	.db $22,$BF,$32,$C2,$A9,$03,$85,$00,$22,$71,$32,$C2,$60,$22,$67,$11   ;C31082  
	.db $C2,$A5,$01,$38,$E5,$00,$C9,$03,$90,$02,$A9,$03,$85,$02,$A9,$9E   ;C31092
	.db $85,$00,$64,$01,$A5,$02,$48
	jsl.l DisplayMessage
	.db $68,$85,$02,$A5,$02   ;C310A2  
	.db $85,$00,$22,$71,$32,$C2,$60   ;C310B2
HappinessHerbUseEffect:
	.db $E2,$20,$A9,$13,$85,$00,$E2,$20,$A9   ;C310B9
	.db $01,$85,$01,$22,$79,$35,$C2,$60   ;C310C2
AngelSeedUseEffect:
	.db $E2,$20,$A9,$13,$85,$00,$E2,$20   ;C310CA
	.db $A9,$05,$85,$01,$22,$79,$35,$C2,$60   ;C310D2
BitterHerbUseEffect:
	.db $E2,$20,$A9,$13,$85,$00,$E2   ;C310DB
	.db $20,$A9,$FF,$85,$01,$22,$79,$35,$C2,$60   ;C310E2
MisfortuneHerbUseEffect:
	sep #$20                                ;C310EC
	lda #$13                                ;C310EE
	sta $00                                 ;C310F0
	sep #$20                                ;C310F2
	lda #$FD                                ;C310F4
	sta $01                                 ;C310F6
	jsl $C23579                             ;C310F8
	rts                                     ;C310FC
	sep #$20                                ;C310FD
	lda #$13                                ;C310FF
	sta $00                                 ;C31101
	sep #$30                                ;C31103
	ldx $00                                 ;C31105
	phx                                     ;C31107
	jsl $C21128                             ;C31108
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
	jsl $C23579                             ;C3111E
	plx                                     ;C31122
	stx $00                                 ;C31123
	phx                                     ;C31125
	jsl $C21128                             ;C31126
	plx                                     ;C3112A
	pla                                     ;C3112B
	sec                                     ;C3112C
	.db $E5   ;C3112D
	.db $01   ;C3112E
	sta $02                                 ;C3112F
	stz $03                                 ;C31131
	stx $00                                 ;C31133
	phx                                     ;C31135
	jsl $C2323C                             ;C31136
	plx                                     ;C3113A
	stx $00                                 ;C3113B
	phx                                     ;C3113D
	jsl $C21128                             ;C3113E
	plx                                     ;C31142
	pla                                     ;C31143
	sec                                     ;C31144
	.db $E5   ;C31145
	.db $00   ;C31146
	sta $02                                 ;C31147
	stz $03                                 ;C31149
	stx $00                                 ;C3114B
	jsl $C23209                             ;C3114D
	rts                                     ;C31151
IllLuckHerbUseEffect:
	sep #$20                                ;C31152
	lda #$13                                ;C31154
	sta $00                                 ;C31156
	sep #$30                                ;C31158
	ldx $00                                 ;C3115A
	phx                                     ;C3115C
	jsl $C21128                             ;C3115D
	plx                                     ;C31161
	stx $00                                 ;C31162
	lda #$9D                                ;C31164
	sta $01                                 ;C31166
	phx                                     ;C31168
	jsl $C23579                             ;C31169
	plx                                     ;C3116D
	stx $00                                 ;C3116E
	lda #$9D                                ;C31170
	sta $01                                 ;C31172
	phx                                     ;C31174
	jsl $C23579                             ;C31175
	plx                                     ;C31179
	stx $00                                 ;C3117A
	lda #$9D                                ;C3117C
	sta $01                                 ;C3117E
	phx                                     ;C31180
	jsl $C23579                             ;C31181
	plx                                     ;C31185
	stx $00                                 ;C31186
	phx                                     ;C31188
	jsl $C21128                             ;C31189
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
	jsl $C23209                             ;C3119E
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
	jsl.l func_C2323C
	rts
	.db $E2,$20,$A9,$65,$85,$00,$64,$01   ;C311C3
	jsl.l DisplayMessage
	.db $22,$A2   ;C311C2
	.db $5D,$C2,$A9,$13,$85,$00,$E2,$20,$A9,$0B,$85,$01,$22,$BC,$40,$C2   ;C311D2  
	.db $60   ;C311E2
PoisonHerbUseEffect:
	.db $C2,$20,$E2,$10,$A0,$C7,$84,$00,$22,$A6,$3B,$C2,$C2,$20,$E2   ;C311E3
	.db $10,$A9,$3F,$00,$85,$00,$A0,$05,$84,$02
	jsl.l DisplayMessage
	.db $A9,$FB   ;C311F2  
	.db $FF,$85,$02,$A0,$13,$84,$00,$22,$09,$32,$C2,$A9,$FF,$FF,$85,$00   ;C31202  
	.db $22,$71,$32,$C2,$A4,$00,$F0,$0B,$84,$02,$A9,$A0,$00,$85,$00
	jsl.l DisplayMessage
	.db $A0,$13,$84,$00,$22,$D6,$40,$C2,$22,$A2,$5D,$C2,$E2   ;C31222  
	.db $20,$C2,$10,$A0,$64,$01,$84,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$E2   ;C31232  
	.db $10,$A0,$C7,$84,$00,$22,$A6,$3B,$C2,$A9,$3F,$00,$85,$00,$A0,$14   ;C31242  
	.db $84,$02
	jsl.l DisplayMessage
	.db $A9,$EC,$FF,$85,$02,$A0,$13,$84,$00,$22   ;C31252  
	.db $09,$32,$C2,$A9,$FA,$FF,$85,$00,$22,$71,$32,$C2,$A4,$00,$F0,$0B   ;C31262
	.db $84,$02,$A9,$A0,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$22,$67   ;C31272  
	.db $11,$C2,$A9,$01,$38,$E5,$00,$48,$A9,$13,$85,$00,$22,$28,$11,$C2   ;C31282  
	.db $A9,$01,$38,$E5,$00,$48,$49,$FF,$1A,$48,$C2,$20,$E2,$10,$A0,$C7   ;C31292
	.db $84,$00,$22,$A6,$3B,$C2,$A9,$3F,$00,$85,$00,$7A,$F0,$06,$84,$02   ;C312A2  
	jsl.l DisplayMessage
	.db $7A,$F0,$0E,$84,$02,$A0,$FF,$84,$03,$A0,$13,$84   ;C312B2  
	.db $00,$22,$09,$32,$C2,$7A,$84,$00,$22,$71,$32,$C2,$A4,$00,$F0,$0B   ;C312C2
	.db $84,$02,$A9,$A0,$00,$85,$00
	jsl.l DisplayMessage
	.db $60                   ;C312DA  

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
	jsl.l func_C306F4
@lbl_C312FD:
	plp
	rtl

func_C312FF:
	jsr.w func_C328E9
	jsr.w AntidoteHerbUseEffect
	rtl
	.db $20,$0A,$13,$6B                   ;C31306  
	sep #$30 ;AXY->8
	ldx.b wTemp00
	cpx.b #$13
	bne @lbl_C31315
;C31312  
	.db $4C,$EF,$11
@lbl_C31315:
	phx
	jsl.l func_C21128
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
	.db $E2,$20,$A9,$0B,$85,$01,$A9,$13,$85,$00,$22,$FF,$3F,$C2,$A5,$00   ;C31344
	.db $F0,$0A,$A9,$66,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9   ;C31354  
	.db $15,$80,$E1,$E2,$30,$A6,$00,$86,$02,$A9,$04,$85,$00,$64,$01,$DA   ;C31364  
	jsl.l DisplayMessage
	.db $FA,$86,$00,$A9,$0B,$85,$01,$22,$FF,$3F,$C2,$60   ;C31374  
	.db $E2,$30,$A5,$00,$48,$22,$29,$89,$C2,$68,$85,$02,$A9,$04,$A6,$00   ;C31384
	.db $F0,$02,$A9,$05,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60   ;C313A0
SleepHerbUseEffect:
	.db $E2,$20,$A9   ;C313A1
	.db $05,$85,$01,$A9,$13,$85,$00,$22,$80,$40,$C2,$A5,$00,$F0,$0A,$A9   ;C313A4  
	.db $6A,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$0A,$80,$E1   ;C313B4
	.db $E2,$20,$A9,$05,$85,$01,$A5,$00,$48,$22,$80,$40,$C2,$68,$85,$02   ;C313C4
	.db $A9,$3B,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$30,$A5,$00,$48   ;C313D4
	.db $22,$E5,$88,$C2,$68,$85,$02,$A9,$3B,$A6,$00,$F0,$02,$A9,$3C,$85   ;C313E4  
	.db $00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$95,$85,$00,$64,$01   ;C313F4
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$22,$90,$43,$C2,$60,$E2,$20,$A9   ;C31404  
	.db $32,$85,$01,$A9,$13,$85,$00,$22,$A7,$40,$C2,$A9,$99,$85,$00,$64   ;C31414  
	.db $01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$64,$80,$E5,$E2,$20,$A9,$32   ;C31424  
	.db $85,$01,$A5,$00,$48,$22,$A7,$40,$C2,$68,$85,$02,$A9,$BC,$85,$00   ;C31434  
	.db $64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$30,$A5,$00,$48,$22,$B1,$89,$C2   ;C31444  
	.db $68,$85,$02,$A9,$BC,$A6,$00,$F0,$02,$A9,$BD,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$32,$85,$01,$A9,$13,$85,$00,$22,$73   ;C31464  
	.db $40,$C2,$A9,$6B,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9   ;C31474
	.db $64,$80,$E5,$E2,$20,$A9,$32,$85,$01,$A5,$00,$48,$22,$73,$40,$C2   ;C31484  
	.db $68,$85,$02,$A9,$35,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$30   ;C31494
	.db $A5,$00,$48,$22,$6D,$89,$C2,$68,$85,$02,$A9,$35,$A6,$00,$F0,$02   ;C314A4  
	.db $A9,$36,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60                       ;C314BC  
DragonHerbUseEffect:
	sep #$30 ;AXY->8
	lda.b #$13
	sta.b wTemp00
	lda.b #$87
	sta.b wTemp02
	jsl.l func_C62565
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
	jsl.l func_C3F69F
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
	.db $86,$00,$A9,$01,$85,$01,$22,$79   ;C31552  
	.db $35,$C2,$60                       ;C3155A  
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
	.db $C2,$30,$A9,$4B,$00,$85,$00
	jsl.l DisplayMessage
	.db $A9,$D0,$07,$85,$00   ;C3157A
	.db $22,$BE,$33,$C2,$A2,$32,$00,$20,$DF,$15,$A9,$D0,$07,$85,$00,$22   ;C3158A  
	.db $BE,$33,$C2,$60                   ;C3159A  
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
	jsl.l func_C233BE
	jsl.l func_C21167
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
	jsl.l func_C21167
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
	.db $68,$85,$00,$22,$95,$33,$C2,$A9,$0A,$00,$85,$02,$22,$26,$E5,$C3   ;C315F9
	.db $A5,$00,$29,$FF,$00,$85,$02,$A9,$4E,$00,$85,$00
	jsl.l DisplayMessage
	.db $A9,$10,$27,$85,$00,$22,$BE,$33,$C2,$38,$60   ;C31619
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
	.db $57   ;C31649
	.db $16   ;C3164A
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
	.db $60,$E2,$20,$A9,$01,$85,$00,$22,$39,$33,$C2,$C2,$20   ;C31669  
	.db $A9,$FA,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$00,$85,$00   ;C31679
	.db $22,$7F,$33,$C2,$C2,$20,$A9,$FB,$00,$85,$00
	jsl.l DisplayMessage
	.db $60   ;C31689  
	.db $E2,$20,$64,$00,$22,$74,$33,$C2,$C2,$20,$A9,$FC,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$22,$88,$84,$C2,$C2,$20,$A9,$30,$01,$85   ;C316A9  
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A9,$13,$85,$00,$22,$28   ;C316B9
	.db $11,$C2,$A5,$01,$38,$E5,$00,$F0,$19,$85,$02,$A0,$40,$00,$84,$00   ;C316C9  
	.db $48
	jsl.l DisplayMessage
	.db $68,$85,$02,$64,$03,$A9,$13,$85,$00,$22,$09   ;C316D9
	.db $32,$C2,$60   ;C316E9
SpoiledOnigiriUseEffect:
	rep #$20                                ;C316EC
	sep #$10                                ;C316EE
	ldy #$C6                                ;C316F0
	sty $00                                 ;C316F2
	jsl $C23BA6                             ;C316F4
	lda #$012C                              ;C316F8
	sta $00                                 ;C316FB
	jsl $C233BE                             ;C316FD
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
	jsl $C23209                             ;C31720
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
	jsl $C23271                             ;C31751
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
	.db $C2,$20,$A9,$97,$00,$85,$00
	jsl.l DisplayMessage
	.db $22,$BD,$7F,$C2,$60,$E2,$20,$22,$5A,$7F,$C2,$A5,$00,$F0   ;C317F9  
	.db $0C,$C2,$20,$A9,$68,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$A9   ;C31809  
	.db $5C,$00,$85,$00
	jsl.l DisplayMessage
	.db $60                               ;C31821
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
	jsl.l func_C285A2
	lda.b wTemp00
	beq @lbl_C31862
	.db $C2,$20,$A9,$B9,$00,$85,$00
	jsl.l DisplayMessage
@lbl_C31862:
	rts
	.db $C2,$20,$A9,$55,$00,$85,$00
	jsl.l DisplayMessage
	.db $60   ;C3186E
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
	jsl.l func_C62550
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
	.db $22,$6E,$87,$C2,$C2,$20,$A9,$63,$01,$85,$00   ;C318A4
	jsl.l DisplayMessage
	.db $60                               ;C318B3
SleepScrollUseEffect:
	jsl.l func_C28790
	rts
	.db $E2,$20,$A9,$1E,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$0B,$A9,$5C   ;C318B9
	.db $85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$22,$51,$88,$C2,$60   ;C318D1
ConfusionScrollUseEffect:
	.db $22,$DA   ;C318D7
	.db $87,$C2,$60   ;C318D9
ExplosionScrollUseEffect:
	.db $22,$A3,$88,$C2,$60   ;C318DC
PowerupScrollUseEffect:
	sep #$20 ;A->8
	lda.b #$13
	sta.b wTemp00
	lda.b #$CC
	sta.b wTemp02
	jsl.l func_C62565
	lda.b #$0B
	sta.b wTemp00
	jsl.l func_C28418
	rts
MonsterHouseScrollUseEffect:
	.db $22,$4D,$2B,$C6,$22,$EA,$69,$C3   ;C318F8  
	.db $60                               ;C31900
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
	.db $A0,$00,$84,$00,$5A,$22,$7C,$3B,$C2,$7A,$A5,$00,$30,$09,$5A,$22   ;C31927
	.db $92,$01,$C3,$7A,$C8,$80,$EB,$A0,$1F,$84,$00,$20,$59,$19,$A4,$00   ;C31937  
	.db $30,$04,$22,$92,$01,$C3,$C2,$20,$A9,$B4,$00,$85,$00
	jsl.l DisplayMessage
	.db $60                           ;C31957  

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
	jsl.l func_C359AF
	lda.b wTemp01
	sta.b wTemp00
	plp
	rts
	.db $E2,$30,$5A,$A5,$01,$85,$00,$20,$59,$19,$A5,$00,$7A,$C4,$00,$D0   ;C3197A
	.db $0B,$A9,$5C,$85,$00,$64,$01
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
	.db $FA,$A9,$AF,$9F,$8C,$8B,$7E,$A9   ;C319DA
	.db $00,$9F,$8C,$8D,$7E,$BF,$0C,$8E,$7E,$C9,$FF,$F0,$0C,$85,$00,$A9   ;C319EA
	.db $FF,$9F,$0C,$8E,$7E,$22,$F4,$06,$C3,$60   ;C319FA
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
	.db $C8   ;C31A21
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
	.db $FA,$68,$18,$7F,$8C,$8C,$7E,$9F,$8C,$8C,$7E,$60,$A9,$5C,$85,$00   ;C31A4A
	.db $64,$01
	jsl.l DisplayMessage
	.db $60,$E2,$20,$22,$7E,$48,$C2,$A5,$00,$D0   ;C31A5A  
	.db $05,$22,$4F,$7F,$C2,$60,$A9,$C5,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$C2,$20,$E2,$10,$A9,$89,$00,$85,$00,$5A
	jsl.l DisplayMessage
	.db $7A   ;C31A7A
	.db $84,$00,$22,$63,$2A,$C6           ;C31A8A

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
	.db $E2,$30,$22,$89,$3B,$C2,$A6,$00,$30,$54,$A9,$13,$85,$00,$A9,$C8   ;C31ACF
	.db $85,$02,$DA,$8B,$22,$65,$25,$C6,$AB,$FA,$BD,$8C,$8C,$C9,$63,$F0   ;C31ADF  
	.db $3D,$A9,$AA,$85,$00,$64,$01,$86,$02,$DA,$8B
	jsl.l DisplayMessage
	.db $AB   ;C31AEF  
	.db $FA,$BD,$8C,$8C,$1A,$9D,$8C,$8C,$A9,$AB,$85,$00,$64,$01,$86,$02   ;C31AFF
	.db $DA,$8B
	jsl.l DisplayMessage
	.db $AB,$FA,$BD,$0C,$8C,$F0,$0D,$9E,$0C,$8C   ;C31B0F
	.db $A9,$52,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $A9,$01,$80,$9B,$A9,$5C   ;C31B1F
	.db $85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60                               ;C31B37

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
	.db $E2,$30,$22,$89,$3B,$C2,$A6,$01,$30,$54,$A9,$13,$85,$00,$A9,$C9   ;C31B7B
	.db $85,$02,$DA,$8B,$22,$65,$25,$C6,$AB,$FA,$BD,$8C,$8C,$C9,$63,$F0   ;C31B8B  
	.db $3D,$A9,$AA,$85,$00,$64,$01,$86,$02,$DA,$8B
	jsl.l DisplayMessage
	.db $AB   ;C31B9B  
	.db $FA,$BD,$8C,$8C,$1A,$9D,$8C,$8C,$A9,$AB,$85,$00,$64,$01,$86,$02   ;C31BAB
	.db $DA,$8B
	jsl.l DisplayMessage
	.db $AB,$FA,$BD,$0C,$8C,$F0,$0D,$9E,$0C,$8C   ;C31BBB
	.db $A9,$52,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $A9,$01,$80,$97,$A9,$5C   ;C31BCB
	.db $85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60   ;C31BE3
PlatingScrollUseEffect:
	.db $E2,$30,$22,$89,$3B,$C2,$A5   ;C31BE4
	.db $00,$25,$01,$30,$75,$A5,$01,$48,$A5,$00,$48,$30,$0C,$A9,$13,$85   ;C31BEB
	.db $00,$A9,$CA,$85,$02,$22,$65,$25,$C6,$A3,$02,$30,$0C,$A9,$13,$85   ;C31BFB
	.db $00,$A9,$CB,$85,$02,$22,$65,$25,$C6,$A9,$8E,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $FA,$30,$20,$BF,$8C,$8F,$7E,$09,$08,$9F,$8C,$8F,$7E   ;C31C1B  
	.db $BF,$0C,$8C,$7E,$F0,$10,$A9,$00,$9F,$0C,$8C,$7E,$A9,$52,$85,$00   ;C31C2B  
	.db $64,$01
	jsl.l DisplayMessage
	.db $FA,$30,$20,$BF,$8C,$8F,$7E,$09,$08,$9F   ;C31C3B  
	.db $8C,$8F,$7E,$BF,$0C,$8C,$7E,$F0,$10,$A9,$00,$9F,$0C,$8C,$7E,$A9   ;C31C4B  
	.db $52,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60,$A9,$5C,$85,$00,$64,$01   ;C31C5B  
	jsl.l DisplayMessage
	.db $60               ;C31C6B  
BlessingScrollUseEffect:
	sep #$30 ;AXY->8
	lda.b #$13
	sta.b wTemp00
	lda.b #$CD
	sta.b wTemp02
	call_savebank func_C62565
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
	.db $A9,$5C,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60                       ;C31CA2  
@lbl_C31CA5:
	.db $FA,$30,$18,$BD,$0C,$8C,$F0,$13
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
	.db $E2,$30,$22,$89,$3B,$C2,$A6,$02,$DA,$A6,$01,$DA,$A6,$00,$DA,$A0   ;C31CC4
	.db $03,$FA,$30,$05,$BD,$0C,$8C,$F0,$16,$88,$D0,$F5,$A9,$5C,$85,$00   ;C31CD4  
	.db $64,$01
	jsl.l DisplayMessage
	.db $60,$FA,$30,$1A,$BD,$0C,$8C,$D0,$15,$A9   ;C31CE4  
	.db $01,$9D,$0C,$8C,$A9,$8D,$85,$00,$64,$01,$86,$02,$5A,$8B
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
	.db $1A   ;C31D5B
@lbl_C31D5C:
	cmp #$00                                ;C31D5C
	bmi @lbl_C31D6F                         ;C31D5E
	sta $00                                 ;C31D60
	pha                                     ;C31D62
	jsl $C232BF                             ;C31D63
	pla                                     ;C31D67
	sta $00                                 ;C31D68
	jsl $C23271                             ;C31D6A
	rts                                     ;C31D6E
@lbl_C31D6F:
	sta $00                                 ;C31D6F
	pha                                     ;C31D71
	jsl $C23271                             ;C31D72
	pla                                     ;C31D76
	sta $00                                 ;C31D77
	jsl $C232BF                             ;C31D79
	rts                                     ;C31D7D
	jsl $C283B3                             ;C31D7E
	rts                                     ;C31D82
	sep #$30 ;AXY->8
	jsl.l func_C283D2
	rts
	.db $E2,$30,$22,$E1,$83,$C2,$60,$E2,$30,$22,$EC,$83,$C2,$60,$E2,$30   ;C31D8A
	.db $22,$F7,$83,$C2,$60,$E2,$30,$22,$02,$84,$C2,$60,$E2,$30,$22,$0D   ;C31D9A  
	.db $84,$C2,$60,$E2,$30,$22,$5C,$84,$C2,$60,$E2,$30,$22,$67,$84,$C2   ;C31DAA  
	.db $60,$E2,$30,$22,$7D,$84,$C2,$60   ;C31DBA
	.db $E2,$30,$22,$97,$84,$C2,$60       ;C31DC2
	rts
	.db $E2,$30,$A4,$00,$A6,$01,$A9,$12,$85,$00,$A9,$16,$85,$01,$DA,$5A   ;C31DCA
	.db $22,$9F,$F6,$C3,$7A,$FA,$A5,$00,$85,$02,$86,$01,$84,$00,$22,$DF   ;C31DDA  
	.db $28,$C2,$60                       ;C31DEA
	jsl.l func_C24390
	rts
	.db $22,$D6,$40,$C2,$22,$A2,$5D,$C2   ;C31DF2  
	.db $60                               ;C31DFA
	jsl.l func_C240BC
	rts
	.db $E2,$20,$A9,$06,$85,$01,$22,$80   ;C31E00
	.db $40,$C2,$60,$60                   ;C31E08
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
	jsl.l func_C20F35
	plx
	stx.b wTemp00
	phx
	jsl.l func_C625B9
	plx
	stx.b wTemp00
	jsl.l func_C21128
	ply
	ldx.b #$E0
	stx.b wTemp00
	sty.b wTemp01
	ldx.b wTemp05
	stx.b wTemp02
	jsl.l func_C30295
	ldx.b wTemp00
	cpx.b #$FF
	beq @lbl_C31EB3
	pla
	stx.b wTemp00
	sta.b wTemp02
	jsl.l func_C330D1
	rts
@lbl_C31EB3:
	.db $68
@lbl_C31EB4:
	rts
@lbl_C31EB5:
	.db $22,$3A,$43,$C2,$A9,$01,$00,$85   ;C31EB5  
	.db $02,$22,$E5,$25,$C6,$60           ;C31EBD
SkullStaffUseEffect:
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	ldx.b wTemp01
	lda.l $7E935D
	bpl @lbl_C31ED4
;C31ED2  
	.db $A6,$00
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
	jsl.l func_C21128
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
	jsl.l func_C23579
	pla
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp02
	jsl.l func_C6262B
	rts
	.db $E2,$20,$22,$6C,$81,$C2,$A5,$00,$D0,$0B,$C2,$20,$A9,$5C,$00,$85   ;C31FB6
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$30,$A4,$00,$5A,$22,$1B,$80,$C2,$7A   ;C31FC6
	.db $C0,$13,$F0,$23,$C4,$00,$F0,$17,$A6,$00,$E0,$FF,$F0,$0A,$A9,$02   ;C31FD6
	.db $85,$02,$5A,$22,$50,$25,$C6,$7A,$84,$00,$22,$B9,$25,$C6,$60,$A9   ;C31FE6  
	.db $01,$85,$02,$22,$50,$25,$C6,$60,$E2,$20,$A9,$0B,$85,$01,$22,$FF   ;C31FF6  
	.db $3F,$C2,$60   ;C32006
InvisibilityHerbUseEffect:
	.db $E2,$20,$A9,$13,$85,$00,$A9,$15,$85,$01,$A5,$00,$48   ;C32009
	.db $22,$F8,$82,$C2,$68,$85,$02,$C2,$20,$A9,$5D,$01,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$15,$85,$01,$A5,$00,$22,$F8,$82,$C2,$A9   ;C32026  
	.db $01,$85,$02,$22,$50,$25,$C6,$60   ;C32036
SlothStaffUseEffect:
	.db $22,$05,$83,$C2,$60,$22,$50,$83   ;C3203E
	.db $C2,$60                           ;C32046
ParalysisStaffUseEffect:
	sep #$20 ;A->8
	lda.b #$03
	sta.b wTemp02
	lda.b wTemp00
	pha
	jsl.l func_C62550
	pla
	sta.b wTemp00
	lda.b wTemp00
	pha
	jsl.l func_C27EA9
	pla
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp02
	jsl.l func_C62550
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
	.db $FA,$86,$00,$22,$90,$43,$C2,$60   ;C320A8
PainSplitStaffUseEffect:
	sep #$30 ;AXY->8
	jsl.l func_C28451
	rts
	sep #$30                                ;C320B7
	ldy $00                                 ;C320B9
	ldx $01                                 ;C320BB
	phx                                     ;C320BD
	jsl $C21128                             ;C320BE
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
	jsl $C23209                             ;C320D6
	plx                                     ;C320DA
@lbl_C320DB:
	stx $00                                 ;C320DB
	phx                                     ;C320DD
	jsl $C21128                             ;C320DE
	plx                                     ;C320E2
	lda $00                                 ;C320E3
	.db $4A   ;C320E5
	eor #$FF                                ;C320E6
	inc a                                   ;C320E8
	beq @lbl_C320F7                         ;C320E9
	sta $02                                 ;C320EB
	lda #$FF                                ;C320ED
	sta $03                                 ;C320EF
	stx $00                                 ;C320F1
	jsl $C23209                             ;C320F3
@lbl_C320F7:
	rts                                     ;C320F7
	sep #$30                                ;C320F8
	ldy $00                                 ;C320FA
	ldx $01                                 ;C320FC
	stx $00                                 ;C320FE
	phx                                     ;C32100
	jsl $C21128                             ;C32101
	plx                                     ;C32105
	lda $00                                 ;C32106
	.db $4A   ;C32108
	pha                                     ;C32109
	eor #$FF                                ;C3210A
	inc a                                   ;C3210C
	beq @lbl_C3211D                         ;C3210D
	sta $02                                 ;C3210F
	lda #$FF                                ;C32111
	sta $03                                 ;C32113
	stx $00                                 ;C32115
	phy                                     ;C32117
	jsl $C23209                             ;C32118
	ply                                     ;C3211C
@lbl_C3211D:
	pla                                     ;C3211D
	sta $02                                 ;C3211E
	stz $03                                 ;C32120
	sty $00                                 ;C32122
	jsl $C23209                             ;C32124
	rts                                     ;C32128
GreatHallScrollUseEffect:
	.db $E2,$20,$22,$DF,$69,$C3,$A5,$00,$D0,$29,$22,$DB,$27,$C6   ;C32129
	.db $A5,$00,$C9,$0A,$F0,$1F,$C9,$0C,$F0,$1B,$A9,$13,$85,$00,$A9,$03   ;C32137  
	.db $85,$02,$22,$F6,$26,$C6,$22,$F6,$66,$C3,$A9,$E7,$85,$00,$64,$01   ;C32147  
	jsl.l DisplayMessage
	.db $60,$A9,$5C,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60   ;C32157  
NeedScrollUseEffect:
	sep #$30 ;AXY->8
	ldy.b #$01
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C21128
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
	jsl.l func_C23209
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
	jsl.l func_C21167
	lda.b wTemp06
	ora.b wTemp07
	bne @lbl_C321BD
;C321BA  
	.db $4C,$AE,$15
@lbl_C321BD:
	lda.b #$13
	sta.b wTemp00
	phy
	jsl.l func_C285A2
	ply
	lda.b wTemp01
	ora.b wTemp03
	ora.b wTemp00
	beq @lbl_C321D2
;C321CF  
	.db $4C,$95,$0F
@lbl_C321D2:
	jsl.l func_C21184
	lda.b wTemp00
	ora.b wTemp01
	beq @lbl_C321E1
;C321DC  
	.db $22,$95,$11,$C2,$60
@lbl_C321E1:
	jsl.l func_C21167
	lda.b wTemp00
	cmp.b #$01
	bne @lbl_C321EE
;C321EB  
	.db $4C,$04,$10
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
	.db $BF,$0C,$8C,$7E,$F0,$03
@lbl_C32210:
	.db $4C,$70,$1C
@lbl_C32213:
	jsl.l func_C21167
	lda.b wTemp02
	ora.b wTemp03
	ora.b wTemp04
	bne @lbl_C3224E
	.db $5A,$22,$F3,$05,$C3,$7A,$A6,$00,$30,$25,$BF,$0C,$8D,$7E,$EB,$BF   ;C3221F
	.db $8C,$8C,$7E,$C2,$20,$0A,$85,$00,$0A,$0A,$18,$65,$00,$E2,$20,$9F   ;C3222F  
	.db $8C,$8C,$7E,$EB,$9F,$0C,$8D,$7E   ;C3223F  
	.db $86,$00,$22,$02,$3A,$C2,$60       ;C32247  
@lbl_C3224E:
	tya
	beq @lbl_C3225B
	.db $A9,$5C,$85,$00,$64,$01
	jsl.l DisplayMessage
@lbl_C3225B:
	rts
ExtractionScrollUseEffect:
	.db $E2,$30,$A5,$01,$85,$00,$20,$59,$19,$A5,$00,$A8,$AA,$BF,$8C,$8B   ;C3225C
	.db $7E,$AA,$BF,$BB,$41,$C3,$C9,$0B,$D0,$2E,$A9,$13,$85,$00,$A9,$CE   ;C3226C  
	.db $85,$02,$5A,$22,$65,$25,$C6,$7A,$A9,$13,$85,$00,$22,$AC,$10,$C2   ;C3227C  
	.db $C2,$20,$A5,$00,$48,$BB,$A9,$F4,$00,$85,$00,$86,$02,$DA
	jsl.l DisplayMessage
	.db $FA,$68,$20,$B2,$31,$60,$E2,$20,$A9,$5C,$85,$00,$64,$01   ;C3229C  
	jsl.l DisplayMessage
	.db $60   ;C322B0
HandsFullScrollUseEffect:
	rep #$20 ;A->16                      ;C322B1
	lda.w #$0013
	sta.b wTemp00
	lda.w #$00CF
	sta.b wTemp02
	jsl.l func_C62550
	lda.w #$0105
	sta.b wTemp00
	jsl.l DisplayMessage
	jsl.l $C28472                         ;C322CA
	rts                                  ;C322CE
	.db $08   ;C322CF
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
	.db $EA   ;C322E7
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
	.db $A9,$0B,$00,$85,$00,$A9,$03,$00   ;C3230C  
	.db $85,$02
	jsl.l DisplayMessage
	.db $60,$C2,$20,$22,$FB,$25,$C3,$A9,$76,$00   ;C3231C  
	.db $85,$00
	jsl.l DisplayMessage
	.db $A9,$0A,$00,$85,$00,$A9,$01,$00,$85,$02   ;C3232C  
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$13,$85,$00,$A9,$03,$85,$02,$64   ;C3233C  
	.db $03,$22,$3C,$32,$C2,$A9,$13,$85,$00,$A9,$03,$85,$02,$64,$03,$22   ;C3234C  
	.db $09,$32,$C2,$A9,$03,$85,$00,$22,$BF,$32,$C2,$A9,$03,$85,$00,$22   ;C3235C
	.db $71,$32,$C2,$C2,$20,$A9,$23,$00,$85,$00,$E2,$20,$A9,$13,$85,$02   ;C3236C  
	jsl.l DisplayMessage
	.db $C2,$20,$A9,$0B,$00,$85,$00,$E2,$20,$A9,$03,$85   ;C3237C  
	.db $02
	jsl.l DisplayMessage
	.db $60,$E2,$20,$A9,$C8,$85,$00,$22,$A6,$3B,$C2   ;C3238C
	.db $C2,$20,$A9,$23,$00,$85,$00,$E2,$20,$A9,$13,$85,$02
	jsl.l DisplayMessage
	.db $C2,$20,$A9,$0A,$00,$85,$00,$E2,$20,$A9,$01,$85,$02
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$A9,$FF,$85,$02,$85,$03,$22,$09,$32,$C2   ;C323BC  
	.db $A9,$13,$85,$00,$A9,$FF,$85,$02,$85,$03,$22,$3C,$32,$C2,$A9,$FF   ;C323CC
	.db $85,$00,$22,$71,$32,$C2,$A9,$FF,$85,$00,$22,$BF,$32,$C2,$60,$C2   ;C323DC  
	.db $20,$22,$62,$65,$C3,$A9,$77,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2   ;C323EC  
	.db $20,$22,$A2,$65,$C3,$A9,$71,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2   ;C323FC  
	.db $20,$22,$89,$0E,$C2,$A9,$78,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2   ;C3240C  
	.db $20,$22,$1C,$3B,$C2,$A5,$00,$30,$1F,$85,$02,$C2,$20,$A9,$0E,$00   ;C3241C  
	.db $85,$00,$A5,$02,$48
	jsl.l DisplayMessage
	.db $68,$85,$02,$E2,$20,$A5,$02   ;C3242C  
	.db $85,$00,$22,$F4,$06,$C3,$80,$0B,$C2,$20,$A9,$5C,$00,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$22,$1C,$3B,$C2,$A5,$00,$30,$3D,$85,$02   ;C3244C  
	.db $A5,$02,$48,$22,$1A,$04,$C3,$68,$85,$02,$A5,$00,$30,$2D,$85,$03   ;C3245C  
	.db $C2,$20,$A9,$0C,$00,$85,$00,$A5,$02,$48
	jsl.l DisplayMessage
	.db $68,$85   ;C3246C
	.db $02,$E2,$20,$A5,$03,$85,$00,$A5,$02,$48,$22,$02,$3A,$C2,$68,$85   ;C3247C
	.db $02,$A5,$02,$85,$00,$22,$F4,$06,$C3,$80,$0B,$C2,$20,$A9,$5C,$00   ;C3248C
	.db $85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$22,$AE,$2A,$C6,$C2,$20,$A9   ;C3249C  
	.db $13,$03,$85,$00,$22,$79,$35,$C2,$60,$C2,$20,$A9,$C4,$00,$85,$00   ;C324AC  
	jsl.l DisplayMessage
	.db $A9,$E8,$03,$85,$00,$22,$BE,$33,$C2,$A9,$13,$00   ;C324BC  
	.db $85,$00,$A9,$FF,$00,$85,$02,$22,$09,$32,$C2,$E2,$20,$22,$67,$11   ;C324CC  
	.db $C2,$A5,$01,$38,$E5,$00,$85,$00,$22,$71,$32,$C2,$60,$C2,$20,$A9   ;C324DC
	.db $C3,$00,$85,$00
	jsl.l DisplayMessage
	.db $22,$D5,$7F,$C2,$60               ;C324F4  

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
	jsl.l func_C30192
	ply
	lda.b #$10
	sta.b wTemp00
	stz.b wTemp01
	sty.b wTemp02
	jsl.l DisplayMessage
	plp
	rtl
@lbl_C3252F:
	.db $84,$00,$5A,$22,$92,$01,$C3,$7A,$A9,$57,$85,$00,$64,$01,$84,$02   ;C3252F  
	jsl.l DisplayMessage
	.db $28   ;C32543
	rtl                                     ;C32544
	.db $08   ;C32545
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
	.db $C8   ;C3256E
	bra @lbl_C3254A                         ;C3256F
@lbl_C32571:
	.db $28   ;C32571
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
	jsl $C232BF                             ;C325E9
	ply                                     ;C325ED
	lda #$01                                ;C325EE
	sta $00                                 ;C325F0
	phy                                     ;C325F2
	jsl $C23271                             ;C325F3
	ply                                     ;C325F7
@lbl_C325F8:
	brl @lbl_C3256E                         ;C325F8
	.db $08   ;C325FB
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
	.db $C8   ;C32624
	bra @lbl_C32600                         ;C32625
@lbl_C32627:
	.db $28   ;C32627
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
	jsl $C232BF                             ;C32699
	ply                                     ;C3269D
	lda #$FF                                ;C3269E
	sta $00                                 ;C326A0
	phy                                     ;C326A2
	jsl $C23271                             ;C326A3
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
	.db $A9,$2B,$85,$00,$A9,$01,$85,$01   ;C326B9
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
	.db $A9,$CF,$85,$00,$64,$01
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
	.db $86,$00,$DA,$5A,$8B,$22,$92,$01   ;C32734  
	.db $C3,$AB,$7A,$FA,$80,$16           ;C3273C  
@lbl_C32742:
	cmp.b #$BD
	beq @lbl_C3277C
	cmp.b #$BA
	bne @lbl_C3274D
;C3274A  
	.db $4C,$49,$28
@lbl_C3274D:
	cmp.b #$BF
	beq @lbl_C3278C
	cmp.b #$B6
	bne @lbl_C32758
;C32755  
	.db $4C,$D6,$27
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
	.db $4C,$2D,$2A
@lbl_C3277B:
	rts
@lbl_C3277C:
	.db $E2,$30,$B9,$8C,$8C,$3A,$99,$8C,$8C,$86,$00,$22,$F4,$06,$C3,$60
@lbl_C3278C:
	sep #$30 ;AXY->8
	phy
	phb
	stx.b wTemp00
	jsl.l func_C306F4
	jsl.l Random
	lda.b wTemp00
	cmp.b #$02
	bcs @lbl_C327B4
	.db $22,$5F,$F6,$C3,$A9,$06,$A4,$00,$30,$02,$A9,$1C,$85,$00,$22,$5D   ;C327A0  
	.db $03,$C3,$80,$04                   ;C327B0  
@lbl_C327B4:
	jsl.l func_C3041A
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
	.db $A8
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
	.db $99   ;C327DC
	.db $8C   ;C327DD
	.db $8C   ;C327DE
	phy                                     ;C327DF
	bra @lbl_C327E3                         ;C327E0
@lbl_C327E2:
	tay                                     ;C327E2
@lbl_C327E3:
	lda $8E0C,y                             ;C327E3
	cmp #$FF                                ;C327E6
	bne @lbl_C327E2                         ;C327E8
	.db $8A   ;C327EA
	.db $99   ;C327EB
	.db $0C   ;C327EC
	.db $8E   ;C327ED
	ply                                     ;C327EE
	lda $8C8C,y                             ;C327EF
	beq @lbl_C3283B                         ;C327F2
	dec a                                   ;C327F4
	.db $99   ;C327F5
	.db $8C   ;C327F6
	.db $8C   ;C327F7
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
	.db $8A   ;C32844
	.db $99   ;C32845
	.db $0C   ;C32846
	.db $8E   ;C32847
	rts                                     ;C32848
	sep #$30                                ;C32849
	lda $8C8C,y                             ;C3284B
	dec a                                   ;C3284E
	.db $99   ;C3284F
	.db $8C   ;C32850
	.db $8C   ;C32851
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
	.db $A9,$5C,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60                       ;C328E6  

func_C328E9:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C21128
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
	jsl.l func_C23209
@lbl_C32915:
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C285A2
	lda.b wTemp01
	pha
	lda.b wTemp03
	pha
	lda.b wTemp00
	beq @lbl_C32939
	.db $A0,$13,$00,$84,$00,$22,$A7,$40,$C2,$A0,$9B,$00,$84,$00
	jsl.l DisplayMessage
@lbl_C32939:
	pla
	beq @lbl_C3294E
	.db $A0,$13,$00,$84,$00,$22,$FF,$3F,$C2,$A0,$67,$00,$84,$00
	jsl.l DisplayMessage
@lbl_C3294E:
	pla
	beq @lbl_C32963
	.db $A0,$13,$00,$84,$00,$22,$73,$40,$C2,$A0,$6C,$00,$84,$00
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
	.db $A9,$5C,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $60                       ;C3297A  
@lbl_C3297D:
	dec a
	sta.l wItemModification1,x
	phx
	lda.b #$13
	sta.b wTemp00
	lda.b #$C7
	sta.b wTemp02
	jsl.l func_C62565
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
	jsl.l func_C62565
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
	.db $FA,$A9,$03,$85,$00,$A9,$01,$85,$01
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
	.db $22,$4D,$3C,$C2,$28,$60
@lbl_C32B0B:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	jsl.l func_C359AF
	ldx.b wTemp01
	stx.b wTemp00
	phx
	jsl.l func_C30824
	plx
	ldy.b wTemp00
	bne @lbl_C32B3A
;C32B2A
	.db $68,$86,$02,$A9,$C6,$00,$85,$00
	jsl.l DisplayMessage
	.db $64,$00,$28,$60
@lbl_C32B3A:
	stx.b wTemp00
	phx
	jsl.l func_C30823
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
	.db $E2,$30,$BB,$DA,$20,$AD,$2B,$FA,$BF,$8C,$8C,$7E,$DA,$20,$C0,$2B   ;C32B5D
	.db $FA,$86,$00,$DA,$22,$92,$01,$C3,$FA,$86,$00,$22,$F4,$06,$C3,$68   ;C32B6D
	.db $68,$64,$00,$28,$6B               ;C32B7D
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
	jsl.l func_C30192
	plx
	stx.b wTemp00
	jsl.l func_C306F4
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
	.db $08   ;C32BC0
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
	.db $28   ;C32BFE
	rts                                     ;C32BFF
@lbl_C32C00:
	plx                                     ;C32C00
	pla                                     ;C32C01
	.db $28   ;C32C02
	rts                                     ;C32C03
	.db $08   ;C32C04
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
	.db $28   ;C32C44
	rts                                     ;C32C45
@lbl_C32C46:
	plx                                     ;C32C46
	pla                                     ;C32C47
	.db $28   ;C32C48
	rts                                     ;C32C49
	.db $08   ;C32C4A
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
	.db $28   ;C32C8A
	rts                                     ;C32C8B
@lbl_C32C8C:
	plx                                     ;C32C8C
	pla                                     ;C32C8D
	.db $28   ;C32C8E
	rts                                     ;C32C8F

TryClearAssignedCategoryItem:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.w wItemIsCursed,y
	beq @lbl_C32CAE
;C32C9E
	.db $A9,$0D,$85,$00,$64,$01,$84,$02
	jsl.l DisplayMessage
	.db $64,$00,$28,$6B
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

func_C32CCB:
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
	lda.l DATA8_C30301,x
	sta.b wTemp02
	plp
	rtl
	.db $08,$E2,$20,$7B,$A5,$00,$0A,$C2,$30,$AA,$BF,$01,$03,$C3,$85,$00   ;C32CEC
	.db $28,$6B                           ;C32CFC

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
	jsl.l func_C30710
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
	.db $A9,$A9,$85,$00,$64,$01,$86,$02   ;C32D50
	jsl.l DisplayMessage
	.db $28,$6B           ;C32D58  
@lbl_C32D5E:
	.db $A9,$A8,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $28,$6B                   ;C32D66  
@lbl_C32D6A:
	.db $A9,$D7,$85,$00,$64,$01
	jsl.l DisplayMessage
	plp                                     ;C32D74
	rtl                                     ;C32D75
	.db $08   ;C32D76
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
	.db $28,$6B,$A9,$11,$85,$00,$A9,$01,$85,$01
	jsl.l DisplayMessage
	.db $28,$6B,$A9,$D7,$85,$00,$64,$01
	jsl.l DisplayMessage
	.db $28,$6B,$08,$E2   ;C32DCA
	.db $30,$A6,$00,$BF,$8C,$8F,$7E,$89,$08,$F0,$18,$29,$F7,$9F,$8C,$8F   ;C32DDA  
	.db $7E,$A9,$13,$85,$00,$A9,$01,$85,$01
	jsl.l DisplayMessage
	lda #$01                                ;C32DF7
	sta $00                                 ;C32DF9
	.db $28   ;C32DFB
	rtl                                     ;C32DFC
	bit #$80                                ;C32DFD
	bne @lbl_C32E05                         ;C32DFF
	stz $00                                 ;C32E01
	.db $28   ;C32E03
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
	.db $24   ;C32E1F
	.db $00   ;C32E20
	bne @lbl_C32E2C                         ;C32E21
	sep #$30                                ;C32E23
	plx                                     ;C32E25
	stz $00                                 ;C32E26
	.db $28   ;C32E28
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
	.db $24   ;C32E51
	.db $04   ;C32E52
	bne @lbl_C32E2C                         ;C32E53
	sta $02                                 ;C32E55
	eor #$FFFF                              ;C32E57
	sta $00                                 ;C32E5A
	lda $06                                 ;C32E5C
	.db $24   ;C32E5E
	.db $02   ;C32E5F
	beq @lbl_C32E2C                         ;C32E60
	lda $06                                 ;C32E62
	.db $25   ;C32E64
	.db $00   ;C32E65
	pha                                     ;C32E66
	.db $8A   ;C32E67
	dec a                                   ;C32E68
	asl a                                   ;C32E69
	tax                                     ;C32E6A
	lda $C32EB8,x                           ;C32E6B
	sta $00                                 ;C32E6F
	jsl.l DisplayMessage
	pla                                     ;C32E75
	sep #$30                                ;C32E76
	plx                                     ;C32E78
	.db $9B   ;C32E79
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
	.db $28   ;C32EB6
	rtl                                     ;C32EB7
	.db $15   ;C32EB8
	.db $01   ;C32EB9
	.db $16   ;C32EBA
	.db $01   ;C32EBB
	.db $17   ;C32EBC
	.db $01   ;C32EBD
	clc                                     ;C32EBE
	.db $01   ;C32EBF
	ora $1A01,y                             ;C32EC0
	.db $01   ;C32EC3
	.db $1B   ;C32EC4
	.db $01   ;C32EC5
	.db $1C   ;C32EC6
	.db $01   ;C32EC7
	.db $1D   ;C32EC8
	.db $01   ;C32EC9
	.db $08   ;C32ECA
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
	.db $26   ;C32FB6
	.db $01   ;C32FB7
	.db $27   ;C32FB8
	.db $01   ;C32FB9
	plp                                     ;C32FBA
	.db $01   ;C32FBB
	and #$01                                ;C32FBC
	.db $2A   ;C32FBE
	.db $01   ;C32FBF

func_C32FC0:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wItemFuseAbility2,x
	bit.b #$01
	beq @lbl_C32FEC
	.db $DA,$22,$10,$07,$C3,$FA,$A5,$04,$F0,$15,$BF,$8C,$8C,$7E,$3A,$9F   ;C32FCD
	.db $8C,$8C,$7E,$A9,$13,$85,$00,$A9   ;C32FDD  
	.db $FF,$85,$01,$22,$BF,$34,$C2       ;C32FE5  
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
	jsl.l func_C359AF
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
	.db $80,$E4                           ;C3303A  

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
	jsl.l func_C359AF
	lda.b wTemp02
	bit.b #$F0
	bne @lbl_C33066
	sta.b wTemp00
	jsl.l func_C366B7
	lda.b wTemp00
	bit.b #$20
	beq @lbl_C33066
;C33062
	.db $A9,$01,$83,$04
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
	jsl.l func_C359AF
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
	.db $BF,$8C,$8E,$7E,$D0,$C5,$80,$0B
@lbl_C330BA:
	.db $C2,$20,$A5,$04,$38,$E3,$01,$85   ;C330BA
	.db $04,$A2,$FF                       ;C330C2  
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
	.db $7A,$F0,$0D,$A9,$17,$00,$85,$00,$86,$02,$DA
	jsl.l DisplayMessage
	.db $FA   ;C3310D
	.db $86,$00,$22,$F4,$06,$C3,$A9,$FF   ;C3311D  
	.db $FF,$85,$00,$28,$6B               ;C33125  
@lbl_C3312A:
	cpx.b #$7F
	bne @lbl_C3313B
	pha
	phx
	jsl.l func_C33A21
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
	.db $7A,$F0,$0B,$A9,$17,$00,$85,$00,$86,$02
	jsl.l DisplayMessage
	.db $A9,$FF   ;C3315B
	.db $FF,$85,$00,$28,$6B               ;C3316B  

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
	jsl.l func_C306F4
	plp
	rtl
@lbl_C3319B:
	.db $C2,$20,$86,$00,$A9,$45,$00,$85,$02,$DA,$22,$42,$26,$C6,$FA,$86   ;C3319B
	.db $00,$22,$F4,$06,$C3,$28,$6B       ;C331AB

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
	.db $C2,$20,$A3,$01,$85,$00,$E2,$20,$DA,$BF,$8C,$8C,$7E,$20,$04,$2C   ;C331C3
	.db $FA,$86,$00,$DA,$22,$92,$01,$C3   ;C331D3
	.db $FA,$80,$44                       ;C331DB
@lbl_C331DE:
	cmp.b #$BD
	bne @lbl_C331F1
	.db $C2,$20,$A3,$01,$85,$00,$E2,$20   ;C331E2
	.db $DA,$20,$9C,$32,$FA,$80,$31       ;C331EA
@lbl_C331F1:
	cmp.b #$C1
	bne @lbl_C33210
	.db $C2,$20,$A3,$01,$85,$00,$E2,$20,$DA,$BF,$8C,$8C,$7E,$20,$4A,$2C   ;C331F5
	.db $FA,$86,$00,$DA,$22,$92,$01,$C3   ;C33205
	.db $FA,$80,$12                       ;C3320D
@lbl_C33210:
	cmp.b #$C5
	bne @lbl_C33222
	.db $C2,$20,$A3,$01,$85,$00,$E2,$20   ;C33214
	.db $DA,$22,$F7,$D9,$C3,$FA           ;C3321C
@lbl_C33222:
	bra @lbl_C33280
@lbl_C33224:
	sep #$20                                ;C33224
	.db $A3   ;C33226
	.db $04   ;C33227
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
	.db $C8   ;C3323E
	lda #$FF                                ;C3323F
	sta $7E8E0C,x                           ;C33241
@lbl_C33245:
	rep #$20                                ;C33245
	stx $00                                 ;C33247
	.db $A3   ;C33249
	.db $02   ;C3324A
	sta $02                                 ;C3324B
	phx                                     ;C3324D
	phy                                     ;C3324E
	jsl $C330D1                             ;C3324F
	ply                                     ;C33253
	plx                                     ;C33254
	lda $00                                 ;C33255
	bmi @lbl_C33277                         ;C33257
	sta $06                                 ;C33259
	.db $A3   ;C3325B
	.db $02   ;C3325C
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
	.db $C0   ;C33277
	.db $01   ;C33278
	beq @lbl_C33224                         ;C33279
	plx                                     ;C3327B
	sep #$20                                ;C3327C
	.db $80,$13   ;C3327E
@lbl_C33280:
	sep #$20 ;A->8
	lda.l wItemPotNextItem,x
	cmp.b #$FF
	beq @lbl_C33293
	.db $48,$A9,$FF,$9F,$0C,$8E,$7E,$80   ;C3328A
	.db $91                               ;C33292  
@lbl_C33293:
	jsl.l func_C625CE
	pla
	pla
	plx
	plp
	rts
	.db $08,$C2,$20,$E2,$10,$A5,$00,$85,$00,$48,$22,$AF,$59,$C3,$68,$A6   ;C3329C
	.db $02,$30,$26,$A6,$01,$30,$10,$E0,$7F,$B0,$14,$86,$00,$48,$DA,$22   ;C332AC
	.db $F4,$06,$C3,$FA,$68,$80,$08,$E0,$80,$F0,$04,$E0,$C0,$90,$0A,$A2   ;C332BC  
	.db $E0,$85,$00,$86,$02,$22,$A2,$5B   ;C332CC
	.db $C3,$28,$60                       ;C332D4  

func_C332D7:
	php
	sep #$30 ;AXY->8
	ldx.b #$7E
@lbl_C332DC:
	lda.l wItemType,x
	cmp.b #$B7
	bne @lbl_C332F6
	.db $DA,$DA,$20,$19,$33,$FA,$BF,$0C,$8E,$7E,$AA,$C9,$FF,$D0,$F2,$FA   ;C332E4
	.db $80,$1E                           ;C332F4  
@lbl_C332F6:
	cmp.b #$BB
	bne @lbl_C33314
	.db $DA,$DA,$20,$47,$33,$FA,$DA,$20,$47,$33,$FA,$DA,$20,$47,$33,$FA   ;C332FA
	.db $BF,$0C,$8E,$7E,$AA,$C9,$FF,$D0   ;C3330A  
	.db $E8,$FA                           ;C33312
@lbl_C33314:
	dex
	bpl @lbl_C332DC
	plp
	rtl
	.db $08   ;C33319
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
	.db $28   ;C33345
	rts                                     ;C33346
	.db $08   ;C33347
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
	.db $28   ;C3336F
	rts                                     ;C33370
	lda $7E8C8C,x                           ;C33371
	bpl @lbl_C3337B                         ;C33375
	cmp #$F7                                ;C33377
	bmi @lbl_C33380                         ;C33379
@lbl_C3337B:
	dec a                                   ;C3337B
	sta $7E8C8C,x                           ;C3337C
@lbl_C33380:
	.db $28   ;C33380
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
	jsl.l func_C62565
@lbl_C333C8:
	lda.b wTemp07,s
	bne @lbl_C333D2
	lda.b wTemp05,s
	cmp.b #$12
	bne @lbl_C333D5
@lbl_C333D2:
	.db $4C,$ED,$34
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
	jsl.l func_C62550
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
	jsl.l func_C306F4
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
	jsl $C62550                             ;C3359F
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
	.db $7A,$84,$00,$A3,$06,$85,$01,$A3,$08   ;C335BB  
	.db $A8,$A3,$07,$C2,$30,$29,$FF,$00,$0A,$AA,$F4,$F2,$35,$BF,$2B,$47   ;C335CB
	.db $C3,$C9,$7B,$37,$F0,$0A,$C9,$16,$37,$F0,$05,$C9,$F2,$36,$D0,$03   ;C335DB  
	.db $A9,$77,$38,$48,$E2,$10,$BB,$60,$E2,$30,$86,$00,$22,$1C,$2C,$C2   ;C335EB
	.db $4C,$4D,$35                       ;C335FB  

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
	.db $84,$00,$A9,$01,$85,$01,$5A,$22   ;C3363F  
	.db $79,$35,$C2,$7A                   ;C33647  
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
	jsl.l func_C21128
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
	jsl $C62550                             ;C336EE
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
	.db $22,$05,$24,$C6,$C2   ;C33748  
	.db $10,$A2,$A3,$06,$86,$00
	jsl.l DisplayMessage
	.db $A2,$03,$09,$86,$00,$68   ;C33758  
	.db $85,$02
	jsl.l DisplayMessage
	.db $A2,$A4,$06,$86,$00
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
	.db $A0,$22,$09,$84,$00
	jsl.l DisplayMessage
	.db $A9   ;C337C8  
	.db $08,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $A9,$87,$85,$00,$A9   ;C337D8
	.db $03,$85,$02
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
	.db $E8   ;C3382F
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
	.db $9F   ;C33845
	.db $8C   ;C33846
	.db $8C   ;C33847
	.db $7E   ;C33848
	.db $9B   ;C33849
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
	.db $9F   ;C33863
	.db $0C   ;C33864
	.db $8E   ;C33865
	.db $7E   ;C33866
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
	.db $E0   ;C338A2
	.db $50   ;C338A3
	beq @lbl_C338BE                         ;C338A4
	.db $E0   ;C338A6
	.db $23   ;C338A7
	bne @lbl_C33878                         ;C338A8
	pha                                     ;C338AA
	jsl $C21128                             ;C338AB
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
	jsl $C3E526                             ;C33902
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
	jsl $C62550                             ;C33930
	ply                                     ;C33934
	pla                                     ;C33935
	sta $00                                 ;C33936
	.db $C4   ;C33938
	.db $00   ;C33939
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
	sep #$20                                ;C33973
	rep #$10                                ;C33975
	ldy $00                                 ;C33977
	lda #$09                                ;C33979
	sta $02                                 ;C3397B
	phy                                     ;C3397D
	jsl $C62550                             ;C3397E
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
	sep #$30                                ;C339B1
	lda #$19                                ;C339B3
	bra @lbl_C339BB                         ;C339B5
	sep #$30                                ;C339B7
	lda #$64                                ;C339B9
@lbl_C339BB:
	pha                                     ;C339BB
	ldx $00                                 ;C339BC
	ldy $01                                 ;C339BE
	phx                                     ;C339C0
	jsl $C210AC                             ;C339C1
	plx                                     ;C339C5
	lda $03                                 ;C339C6
	cmp #$02                                ;C339C8
	beq @lbl_C339ED                         ;C339CA
	cmp #$11                                ;C339CC
	beq @lbl_C339ED                         ;C339CE
	cmp #$13                                ;C339D0
	beq @lbl_C339ED                         ;C339D2
	cmp #$0E                                ;C339D4
	beq @lbl_C339ED                         ;C339D6
	cmp #$21                                ;C339D8
	beq @lbl_C339ED                         ;C339DA
	cmp #$18                                ;C339DC
	beq @lbl_C339ED                         ;C339DE
	pla                                     ;C339E0
	sta $02                                 ;C339E1
	stz $03                                 ;C339E3
	stx $00                                 ;C339E5
	jsl $C23209                             ;C339E7
	rts                                     ;C339EB
	rts                                     ;C339EC
@lbl_C339ED:
	pla                                     ;C339ED
	sta $02                                 ;C339EE
	stx $00                                 ;C339F0
	sty $01                                 ;C339F2
	jsl $C228DF                             ;C339F4
	rts                                     ;C339F8
	sep #$30                                ;C339F9
	ldx $00                                 ;C339FB
	ldy $01                                 ;C339FD
	phx                                     ;C339FF
	jsl $C210AC                             ;C33A00
	plx                                     ;C33A04
	lda $03                                 ;C33A05
	cmp #$12                                ;C33A07
	beq @lbl_C33A0C                         ;C33A09
	rts                                     ;C33A0B
@lbl_C33A0C:
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
