.bank $01
.org $0000 ;$C10000
.base $c0

func_C10000:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	tsc
	sta.l $7E859F
	lda.b wTemp00
	pha
	jsl.l GetCharacterMapInfo
	ldy.b wTemp04
	cpy.b wTemp03
	beq @lbl_C10029
	.db $68,$85,$02,$A9,$EB,$08,$85,$00
	jsl.l DisplayMessage
	.db $22,$37,$24,$C6   ;C10017
	.db $28,$6B                           ;C10027
@lbl_C10029:
	pla
	sta.b wTemp00
	sep #$30 ;AXY->8
	lda.b wTemp01
	sec
	sbc.b #$3C
	rep #$30 ;AXY->16
	and.w #$00FF
	asl a
	tax
	lda.l DATA8_C1004F,x
	sep #$10 ;XY->8
	pea.w w0046
	pha
	ldx.b wTemp00
	rts
	sep #$30 ;AXY->8
	jsl.l func_C62437
	plp
	rtl

DATA8_C1004F:
	.db $E8,$4A,$70,$4B,$3C,$07,$B2,$07   ;C1004F
	.db $6C,$30,$FA,$3F,$8D,$05           ;C10057  
	.db $97,$44,$ED,$23,$71,$11           ;C1005D
	.db $AE,$11,$0E,$10                   ;C10063  
	.db $A5,$08                           ;C10067
	.db $A3,$44,$8C,$4A,$8C,$4A,$8C,$4A   ;C10069  
	.db $8C,$4A,$35,$3C                   ;C10071  
	.db $B9,$01,$3A,$19                   ;C10075
	.db $1D,$23                           ;C10079  
	.db $AF,$24                           ;C1007B
	.db $F2,$2A                           ;C1007D  
	.db $9B,$3E                           ;C1007F
	.db $45,$2F                           ;C10081  
	.db $8B,$3D,$D2,$3F                   ;C10083
	.db $34,$31                           ;C10087  
	.db $81,$3E                           ;C10089
	.db $C5,$01,$11,$02,$89,$02,$8E,$03   ;C1008B  
	.db $CB,$03,$A5,$2E                   ;C10093
	.db $9F,$04,$FC,$05                   ;C10097
	.db $08,$30,$85,$31,$EE,$4B,$19,$4C,$44,$4C,$DE,$11,$08,$18,$16,$18   ;C1009B
	.db $42,$18,$6C,$18,$94,$18,$01,$32   ;C100AB
	.db $F8,$32                           ;C100B3
	.db $BB,$05,$CF,$37,$0C,$38,$9B,$39   ;C100B5
	.db $DB,$39,$03,$3A,$32,$3A           ;C100BD
	.db $E6,$43                           ;C100C3  
	.db $72,$3A                           ;C100C5
	.db $22,$3B                           ;C100C7  
	.db $4A,$3B                           ;C100C9
	.db $72,$3B                           ;C100CB  
	.db $9A,$3B                           ;C100CD
	.db $C2,$3B,$EA,$3B                   ;C100CF
	.db $12,$3C,$81,$3C,$B5,$3E,$CF,$3E,$E9,$3E,$1D,$3F,$51,$3F,$79,$3F   ;C100D3
	.db $39,$40                           ;C100E3
	.db $5C,$42,$D7,$44,$E5,$44,$F3,$44,$01,$45,$0F,$45,$1D,$45,$2B,$45   ;C100E5  
	.db $39,$45,$47,$45,$6B,$45,$79,$45,$87,$45,$D9,$45,$01,$46,$0F,$46   ;C100F5  
	.db $1D,$46,$2B,$46,$39,$46,$47,$46,$55,$46,$63,$46,$71,$46,$7F,$46   ;C10105  
	.db $8D,$46                           ;C10115
	.db $B2,$46,$03,$47,$2B,$47,$53,$47   ;C10117  
	.db $92,$47,$D0,$30                   ;C1011F  
	.db $C0,$47                           ;C10123
	.db $E8,$47                           ;C10125
	.db $16,$48                           ;C10127
	.db $44,$48,$83,$48,$91,$48,$9F,$48,$AD,$48,$EC,$48,$FA,$48,$08,$49   ;C10129
	.db $16,$49,$24,$49,$32,$49,$88,$49,$BC,$49,$CA,$49,$D8,$49,$E6,$49   ;C10139  
	.db $0C,$4A                           ;C10149
	.db $34,$4A,$42,$4A,$50,$4A,$5E,$4A   ;C1014B  
	.db $8C,$4A,$8D,$4A                   ;C10153  

func_C10157:
	php
	sep #$30 ;AXY->8
	ldx.b #$FF
@lbl_C1015C:
	inx
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C1015C
	cpx.b #$14
	bcs @lbl_C1016F
	lda.b wTemp00
	sta.l wShirenStatus.itemAmounts,x
	plp
	rtl
@lbl_C1016F:
	.db $A6,$00,$A9,$13,$85,$00,$DA,$22,$AC,$10,$C2,$FA,$C2,$20,$A5,$00   ;C1016F  
	.db $85,$02,$86,$00,$22,$D1,$30,$C3   ;C1017F  
	.db $28,$6B                           ;C10187

func_C10189:
	php
	sep #$30 ;AXY->8
	jsl.l func_C28A92
	jsl.l func_C3001F
	jsl.l func_C300D2
	plp
	rts
	.db $08,$E2,$30,$22,$CE,$8A,$C2,$22,$1F,$00,$C3,$22,$D2,$00,$C3,$A9   ;C1019A
	.db $80,$85,$00,$64,$02,$48
	jsl.l _SetEvent
	.db $68,$1A,$D0,$F3,$28,$60   ;C101AA  
	rep #$20 ;A->16
	lda.w #$0689
	sta.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C101E4
	.db $A0,$E0,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C101E2  
@lbl_C101E4:
	GetEvent Event1B
	cmp.b #$02
	bcs @lbl_C10208
	ldy.w #$0693
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event1B $01
	rts
@lbl_C10208:
	.db $A0,$C4,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$30,$BF,$71,$88,$7E   ;C10208
	.db $D0,$18,$C2,$20,$A9,$94,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20   ;C10218  
	.db $A9,$98,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C9,$01,$D0,$EE   ;C10228
	.db $1A,$9F,$71,$88,$7E,$C2,$20,$A9,$95,$06,$85,$00
	jsl.l DisplayMessage
	.db $E2,$20,$22,$67,$11,$C2,$A5,$00,$C5,$01,$D0,$1F,$A9,$9F,$85,$00   ;C10248
	.db $64,$01,$A9,$01,$85,$02
	jsl.l DisplayMessage
	.db $A9,$01,$85,$00,$22,$BF   ;C10258  
	.db $32,$C2,$A9,$01,$85,$00,$22,$71,$32,$C2,$60,$A9,$9E,$85,$00,$64   ;C10268  
	.db $01,$A9,$01,$85,$02
	jsl.l DisplayMessage
	.db $A9,$01,$85,$00,$22,$71,$32   ;C10278  
	.db $C2,$60,$E2,$30,$A6,$00,$BF,$71,$88,$7E,$D0,$0C,$C2,$20,$A9,$A1   ;C10288
	.db $06,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$A9,$9F,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$E2,$10,$5A,$DA,$A9,$99,$06,$85,$00,$22   ;C102A8  
	.db $7E,$2B,$C6,$A4,$00,$F0,$35,$A9,$9D,$06,$85,$00,$22,$7E,$2B,$C6   ;C102B8  
	.db $A4,$00,$F0,$28,$FA,$7A,$84,$00,$5A,$22,$EB,$82,$C2,$7A,$84,$00   ;C102C8  
	.db $22,$35,$0F,$C2,$A9,$01,$09,$85,$00
	jsl.l DisplayMessage
	.db $E2,$20,$A9   ;C102D8  
	.db $80,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$E2,$20,$A3,$01   ;C102E8  
	.db $AA,$BF,$4F,$89,$7E,$85,$00,$22,$10,$07,$C3,$A5,$01,$C9,$B0,$F0   ;C102F8
	.db $42,$C2,$20,$A9,$9A,$06,$85,$00
	jsl.l DisplayMessage
	.db $A9,$9B,$06,$85   ;C10308
	.db $00
	jsl.l DisplayMessage
	.db $E2,$20,$FA,$7A,$BF,$4F,$89,$7E,$85,$00,$DA   ;C10318
	.db $22,$F4,$06,$C3,$FA,$A9,$2A,$85,$00,$DA,$22,$5D,$03,$C3,$FA,$A5   ;C10328  
	.db $00,$9F,$4F,$89,$7E,$85,$02,$C2,$20,$A9,$79,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$A9,$9A,$06,$85,$00
	jsl.l DisplayMessage
	.db $A9,$A0   ;C10348  
	.db $06,$85,$00
	jsl.l DisplayMessage
	.db $E2,$20,$FA,$BF,$4F,$89,$7E,$86,$00   ;C10358  
	.db $48,$22,$4D,$3C,$C2,$68,$85,$00,$22,$F4,$06,$C3,$C2,$20,$A9,$02   ;C10368
	.db $09,$85,$00
	jsl.l DisplayMessage
	.db $7A,$84,$00,$5A,$22,$EB,$82,$C2,$7A   ;C10378
	.db $84,$00,$22,$35,$0F,$C2,$60,$E2,$20,$C2,$10,$BF,$71,$88,$7E,$D0   ;C10388  
	.db $0A,$A0,$A2,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$A5,$06,$84,$00   ;C10398
	.db $DA,$22,$7E,$2B,$C6,$FA,$A5,$00,$F0,$0A,$A0,$A6,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$03,$09,$84,$00,$86,$02
	jsl.l DisplayMessage
	.db $22   ;C103B8  
	.db $F7,$3F,$C3,$60,$E2,$30,$BF,$71,$88,$7E,$D0,$33,$A9,$02,$85,$00   ;C103C8  
	.db $64,$02
	jsl.l _SetEvent
	.db $C2,$20,$A9,$A8,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$A9,$AB,$06,$85,$00,$22,$7E,$2B,$C6,$A6,$00,$F0   ;C103E8  
	.db $0A,$A9,$AC,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$20,$55,$04,$60,$E2   ;C103F8
	.db $20,$C9,$01,$D0,$DD,$1A,$9F,$71,$88,$7E,$A9,$02,$85,$00,$A9,$02   ;C10408  
	.db $85,$02
	jsl.l _SetEvent
	.db $C2,$20,$A9,$A9,$06,$85,$00
	jsl.l DisplayMessage
	.db $20,$36,$04,$A9,$AA,$06,$85,$00
	jsl.l DisplayMessage
	.db $60,$08,$C2   ;C10428  
	.db $20,$E2,$10,$A9,$FF,$FF,$85,$00,$22,$71,$32,$C2,$A4,$00,$F0,$0B   ;C10438  
	.db $84,$02,$A9,$A0,$00,$85,$00
	jsl.l DisplayMessage
	.db $28,$60,$08,$E2,$20   ;C10448  
	.db $C2,$10,$A9,$00,$48,$A2,$00,$00,$80,$1F,$85,$00,$DA,$22,$10,$07   ;C10458
	.db $C3,$FA,$A5,$00,$C9,$06,$D0,$10,$A9,$01,$83,$01,$BF,$4F,$89,$7E   ;C10468  
	.db $85,$00,$DA,$22,$92,$01,$C3,$FA,$E8,$BF,$4F,$89,$7E,$10,$DB,$68   ;C10478  
	.db $F0,$0B,$A2,$04,$09,$86,$00
	jsl.l DisplayMessage
	.db $28,$60,$A2,$5C,$00   ;C10488  
	.db $86,$00
	jsl.l DisplayMessage
	.db $28,$60   ;C10498  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	pha
	jsr.w func_C104AB
	pla
	rts

func_C104AB:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	bne @lbl_C104E0
	ldy.w #$07EB
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C104CC
	.db $A0,$EC,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C104CA  
@lbl_C104CC:
	tdc
	lda.b wTemp03,s
	tax
	lda.b #$01
	sta.l wCharEventFlags,x
	ldy.w #$07F0
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C104E0:
	.db $C9,$02,$B0,$0A,$A0,$F0,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$03   ;C104E0
	.db $90,$03,$4C,$7F,$05,$A9,$89,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9   ;C104F0  
	.db $02,$B0,$72,$A3,$03,$85,$00,$A9,$00,$85,$01,$22,$38,$72,$C2,$A9   ;C10500
	.db $13,$85,$00,$A9,$00,$85,$01,$22,$38,$72,$C2,$A0,$F1,$07,$84,$00   ;C10510  
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$89,$05,$84   ;C10520  
	.db $02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$11,$19,$84,$02,$A3,$03   ;C10530
	.db $85,$00,$22,$51,$79,$C2,$22,$05,$24,$C6,$A0,$F2,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$F3,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$89,$85,$00   ;C10550  
	.db $A9,$02,$85,$02
	jsl.l _SetEvent
	.db $A9,$0C,$85,$00,$A9,$03,$85,$02   ;C10560
	jsl.l _SetEvent
	.db $60,$A0,$F5,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0   ;C10570  
	.db $F6,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$00,$00,$00,$00,$FF,$E2,$20   ;C10580  
	.db $C2,$10,$BF,$71,$88,$7E,$C9,$02,$B0,$0A,$A0,$EE,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$03,$B0,$0A,$A0,$F4,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$F8,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C105B0  
	.db $BF,$71,$88,$7E,$C9,$02,$B0,$0A,$A0,$EF,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$03,$B0,$0A,$A0,$F3,$07,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C105D0  
	.db $C9,$04,$B0,$0F,$1A,$9F,$71,$88,$7E,$A0,$F9,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$FA,$07,$84,$00   ;C105F0  
	jsl.l DisplayMessage
	.db $60               ;C105F8  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	bne @lbl_C10661
	ldy.w #$06CA
	sty.b wTemp00
	phx
	jsl.l DisplayMessage1
	plx
	lda.b wTemp00
	beq @lbl_C10635
	.db $A0,$CB,$06,$84,$00,$DA,$22,$7E,$2B,$C6,$FA,$A5,$00,$F0,$10,$A9   ;C10616
	.db $01,$9F,$71,$88,$7E,$A0,$CC,$06   ;C10626  
	.db $84,$00
	jsl.l DisplayMessage
	.db $60       ;C1062E  
@lbl_C10635:
	lda.b #$03
	sta.b wTemp00
	lda.b #$01
	sta.b wTemp02
	phx
	jsl.l _SetEvent
	plx
	ldy.w #$06CE
	sty.b wTemp00
	phx
	jsl.l DisplayMessage
	plx
	stx.b wTemp00
	jsl.l func_C20F35
	lda.b #$13
	sta.b wTemp00
	lda.b #$32
	sta.b wTemp01
	jsl.l func_C240A7
	rts
@lbl_C10661:
	.db $3A,$D0,$0A,$A0,$CD,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$13   ;C10661
	.db $A9,$03,$85,$00,$A9,$03,$85,$02,$DA
	jsl.l _SetEvent
	.db $FA,$A0,$D1   ;C10671
	.db $06,$80,$C2,$3A,$D0,$52,$A0,$D6,$06,$84,$00,$DA,$22,$7E,$2B,$C6   ;C10681  
	.db $FA,$A5,$00,$F0,$05,$A0,$D8,$06,$80,$AB,$A9,$05,$9F,$71,$88,$7E   ;C10691
	.db $A9,$03,$85,$00,$A9,$04,$85,$02
	jsl.l _SetEvent
	.db $A0,$D7,$06,$84   ;C106A1
	.db $00
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$A9,$32,$85,$01,$22,$A7,$40   ;C106B1
	.db $C2,$22,$05,$24,$C6,$A0,$32,$00,$84,$00,$22,$C7,$00,$C6,$A0,$08   ;C106C1
	.db $09,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$25,$A0,$DB,$06,$84,$00   ;C106D1
	.db $DA,$22,$7E,$2B,$C6,$FA,$A5,$00,$F0,$06,$A0,$D8,$06,$4C,$46,$06   ;C106E1
	.db $A9,$05,$9F,$71,$88,$7E,$A0,$09,$09,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C106F1
	.db $86,$00,$DA,$22,$28,$11,$C2,$FA,$A5,$01,$4A,$4A,$C5,$00,$B0,$22   ;C10701  
	.db $86,$00,$22,$CE,$3B,$C2,$A4,$00,$A5,$00,$D0,$0A,$A0,$DC,$06,$84   ;C10711  
	.db $00
	jsl.l DisplayMessage
	.db $60,$84,$02,$A0,$DD,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$DE,$06,$84,$00
	jsl.l DisplayMessage
	.db $60                   ;C10739  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event_Naoki
	plx
	cmp.b #$08
	bne @lbl_C10754
;C10751  
	.db $4C,$A9,$07
@lbl_C10754:
	lda.l wCharEventFlags,x
	dec a
	bpl @lbl_C10765
	ldy.w #$06B1
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C10765:
	dec a
	dec a
	bpl @lbl_C1077F
	ldy.w #$06CF
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event_Oryu 2
	rts
@lbl_C1077F:
	.db $3A,$10,$03,$4C,$29,$08,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C1077F
	.db $00,$FA,$89,$01,$F0,$0A,$A0,$EF,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C1078F
	.db $A0,$D9,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$7F,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                   ;C107AF  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event_Naoki
	plx
	cmp.b #$08
	bne @lbl_C107CA
;C107C7  
	.db $4C,$1F,$08
@lbl_C107CA:
	lda.l wCharEventFlags,x
	dec a
	bpl @lbl_C107DB
	ldy.w #$06B2
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C107DB:
	dec a
	dec a
	bpl @lbl_C107F5
	ldy.w #$06D0
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event_Oryu 2
	rts
@lbl_C107F5:
	.db $3A,$10,$03,$4C,$68,$08,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C107F5
	.db $00,$FA,$89,$01,$F0,$0A,$A0,$F0,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C10805
	.db $A0,$DA,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$7E,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$8A,$3A,$3A,$85,$00,$86,$02,$A9,$02,$85,$01,$DA   ;C10825  
	.db $20,$1A,$68,$FA,$A0,$D2,$06,$84,$00,$DA,$22,$7E,$2B,$C6,$FA,$A5   ;C10835  
	.db $00,$F0,$0A,$A0,$D3,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A9,$FF,$9F   ;C10845
	.db $71,$88,$7E,$86,$00,$22,$1B,$72,$C2,$A0,$D4,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$8A,$3A,$85,$00,$86,$02,$A9,$02,$85,$01,$DA,$20,$1A   ;C10865  
	.db $68,$FA,$A0,$D2,$06,$84,$00,$DA,$22,$7E,$2B,$C6,$FA,$A5,$00,$F0   ;C10875
	.db $0A,$A0,$D3,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A9,$FF,$9F,$71,$88   ;C10885
	.db $7E,$86,$00,$22,$1B,$72,$C2,$A0,$D5,$06,$84,$00
	jsl.l DisplayMessage
	.db $60                               ;C108A5
	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	pha
	jsr.w func_C108B1
	pla
	rts

func_C108B1:
	jsl.l GetCurrentDungeon
	lda.b wTemp00
	cmp.b #$03
	bne @lbl_C108BE
;C108BB  
	.db $4C,$D0,$0E
@lbl_C108BE:
	phx
	txa
	sta.b wTemp00
	sta.b wTemp02
	lda.b #$02
	sta.b wTemp01
	jsr.w func_C1681A
	plx
	lda.l wCharEventFlags,x
	beq @lbl_C108D5
;C108D2  
	.db $4C,$6D,$0A
@lbl_C108D5:
	GetEvent Event84
	beq @lbl_C108E4
;C108E1  
	.db $4C,$63,$0A
@lbl_C108E4:
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	ldy.w #$0FE1
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	ldy.w #$06E1
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b wTemp03,s
	sta.b wTemp00
	ldy.w #$0FE8
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	lda.b wTemp03,s
	sta.b wTemp00
	jsl.l func_C21591
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b #$C2
	sta.b wTemp01
	lda.b #$05
	sta.b wTemp02
	jsl.l func_C2942A
	jsl.l func_C62405
	ldy.w #$06E2
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	ldy.w #$0FED
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	lda.b #$00
	xba
	lda.b wTemp03,s
	inc a
	tax
	lda.l wCharEventFlags,x
	inc a
	sta.l wCharEventFlags,x
	clc
	adc.b #$62
	sta.b wTemp02
	ldy.w #$06E3
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	ldy.w #$0FF0
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	lda.b wTemp03,s
	sta.b wTemp00
	ldy.w #$0FF3
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	ldy.w #$06E4
	sty.b wTemp00
	jsl.l DisplayMessage
	jsr.w func_C10E35
	cpx.w #$0000
	bmi @lbl_C109BF
	.db $DA,$A0,$E6,$06,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$19,$FA,$A0   ;C109A5
	.db $E7,$06,$84,$00
	jsl.l DisplayMessage
	.db $80,$09                           ;C109BD  
@lbl_C109BF:
	ldy.w #$06E5
	sty.b wTemp00
	jsl.l DisplayMessage
	jsr.w func_C10E5D
	rts
	.db $A3,$05,$85,$00,$A0,$F5,$0F,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93   ;C109CC  
	.db $C2,$A0,$E8,$06,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C109E6
	lda $05,s                               ;C109EA
	sta $00                                 ;C109EC
	ldy #$0FE8                              ;C109EE
	sty $02                                 ;C109F1
	lda #$C1                                ;C109F3
	sta $04                                 ;C109F5
	jsl $C2938C                             ;C109F7
	lda $05,s                               ;C109FB
	sta $00                                 ;C109FD
	jsl $C21591                             ;C109FF
	plx                                     ;C10A03
	lda $7E894F,x                           ;C10A04
	stx $00                                 ;C10A08
	pha                                     ;C10A0A
	jsl $C23C4D                             ;C10A0B
	pla                                     ;C10A0F
	sta $00                                 ;C10A10
	pha                                     ;C10A12
	jsl $C30710                             ;C10A13
	pla                                     ;C10A17
	ldx $01                                 ;C10A18
	sta $00                                 ;C10A1A
	phx                                     ;C10A1C
	jsl $C306F4                             ;C10A1D
	plx                                     ;C10A21
	stx $01                                 ;C10A22
	lda $03,s                               ;C10A24
	sta $00                                 ;C10A26
	jsl $C2942A                             ;C10A28
	jsl $C62405                             ;C10A2C
	lda $03,s                               ;C10A30
	sta $00                                 ;C10A32
	ldy #$0FF3                              ;C10A34
	sty $02                                 ;C10A37
	lda #$C1                                ;C10A39
	sta $04                                 ;C10A3B
	jsl $C2938C                             ;C10A3D
	ldy #$06E9                              ;C10A41
	sty $00                                 ;C10A44
	jsl.l DisplayMessage
	.db $A9,$84   ;C10A3C  
	.db $85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $A9,$04,$85,$00,$A9,$01   ;C10A4C  
	.db $85,$02
	jsl.l _SetEvent
	.db $60,$A0,$EA,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$F0,$03,$4C,$08,$0B,$A9,$84,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C10A6C
	.db $00,$D0,$7F,$A3,$03,$1A,$85,$00,$A0,$E1,$0F,$84,$02,$A9,$C1,$85   ;C10A7C
	.db $04,$22,$8C,$93,$C2,$A0,$EB,$06,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C10A9A
	lda $03,s                               ;C10A9E
	sta $00                                 ;C10AA0
	ldy #$0FE8                              ;C10AA2
	sty $02                                 ;C10AA5
	lda #$C1                                ;C10AA7
	sta $04                                 ;C10AA9
	jsl $C2938C                             ;C10AAB
	lda $03,s                               ;C10AAF
	sta $00                                 ;C10AB1
	jsl $C21591                             ;C10AB3
	lda $03,s                               ;C10AB7
	sta $00                                 ;C10AB9
	lda #$C3                                ;C10ABB
	sta $01                                 ;C10ABD
	lda #$05                                ;C10ABF
	sta $02                                 ;C10AC1
	jsl $C2942A                             ;C10AC3
	jsl $C62405                             ;C10AC7
	lda $03,s                               ;C10ACB
	sta $00                                 ;C10ACD
	ldy #$0FF3                              ;C10ACF
	sty $02                                 ;C10AD2
	lda #$C1                                ;C10AD4
	sta $04                                 ;C10AD6
	jsl $C2938C                             ;C10AD8
	ldy #$06EC                              ;C10ADC
	sty $00                                 ;C10ADF
	jsl.l DisplayMessage
	.db $A9,$84,$85,$00,$A9,$01,$85   ;C10ADC
	.db $02
	jsl.l _SetEvent
	.db $A9,$04,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$A0,$ED,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$F0,$03,$4C   ;C10AFC  
	.db $F9,$0C,$A9,$84,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$F0,$03,$4C,$EF   ;C10B0C  
	.db $0C,$20,$35,$0E,$E0,$00,$00,$10,$0D,$A0,$EE,$06,$84,$00
	jsl.l DisplayMessage
	.db $20,$B9,$0E,$60,$A3,$03,$1A,$85,$00,$A0,$E1,$0F,$84,$02   ;C10B2C  
	.db $A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$EF,$06,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$E8,$0F,$84,$02,$A9,$C1   ;C10B4C  
	.db $85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00,$22,$91,$15,$C2,$A3,$03   ;C10B5C  
	.db $85,$00,$A9,$C4,$85,$01,$A9,$05,$85,$02,$22,$2A,$94,$C2,$22,$05   ;C10B6C  
	.db $24,$C6,$A0,$F0,$06,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3   ;C10B7C  
	.db $03,$85,$00,$A0,$FC,$0F,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2   ;C10B8C  
	.db $A0,$F1,$06,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85   ;C10B9C
	.db $00,$A0,$FE,$0F,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03   ;C10BAC
	.db $85,$00,$22,$91,$15,$C2,$A0,$F2,$06,$84,$00
	jsl.l DisplayMessage
	.db $22   ;C10BBC  
	.db $05,$24,$C6,$A3,$03,$85,$00,$A0,$01,$10,$84,$02,$A9,$C1,$85,$04   ;C10BCC  
	.db $22,$8C,$93,$C2,$A0,$F3,$06,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24   ;C10BDC  
	.db $C6,$A3,$03,$1A,$85,$00,$A0,$E1,$0F,$84,$02,$A9,$C1,$85,$04,$22   ;C10BEC  
	.db $8C,$93,$C2,$A3,$03,$85,$00,$A0,$E8,$0F,$84,$02,$A9,$C1,$85,$04   ;C10BFC  
	.db $22,$8C,$93,$C2,$A0,$F4,$06,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$85   ;C10C0C  
	.db $00,$22,$91,$15,$C2,$A3,$03,$85,$00,$A9,$C2,$85,$01,$A9,$05,$85   ;C10C1C
	.db $02,$22,$2A,$94,$C2,$22,$05,$24,$C6,$A3,$03,$1A,$85,$00,$A0,$E1   ;C10C2C
	.db $0F,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00,$A0   ;C10C3C  
	.db $E8,$0F,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$F4,$06,$84   ;C10C4C
	.db $00
	jsl.l DisplayMessage
	.db $A3,$03,$85,$00,$22,$91,$15,$C2,$A3,$03,$85   ;C10C5C
	.db $00,$A9,$C2,$85,$01,$A9,$05,$85,$02,$22,$2A,$94,$C2,$22,$05,$24   ;C10C6C
	.db $C6,$A3,$03,$1A,$85,$00,$A0,$E1,$0F,$84,$02,$A9,$C1,$85,$04,$22   ;C10C7C  
	.db $8C,$93,$C2,$A3,$03,$85,$00,$A0,$E8,$0F,$84,$02,$A9,$C1,$85,$04   ;C10C8C  
	.db $22,$8C,$93,$C2,$A0,$F4,$06,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$85   ;C10C9C  
	.db $00,$22,$91,$15,$C2,$A3,$03,$85,$00,$A9,$C2,$85,$01,$A9,$05,$85   ;C10CAC
	.db $02,$22,$2A,$94,$C2,$22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$F3,$0F   ;C10CBC
	.db $84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A9,$84,$85,$00,$A9,$01   ;C10CCC  
	.db $85,$02
	jsl.l _SetEvent
	.db $A9,$04,$85,$00,$A9,$03,$85,$02
	jsl.l _SetEvent
	.db $60,$A0,$F5,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$F0,$03   ;C10CEC  
	.db $4C,$C7,$0D,$A9,$84,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$F0,$03,$4C   ;C10CFC  
	.db $BD,$0D,$A0,$F7,$06,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3   ;C10D0C  
	.db $03,$1A,$85,$00,$A0,$E1,$0F,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93   ;C10D1C  
	.db $C2,$A0,$F8,$06,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C10D36
	lda $03,s                               ;C10D3A
	sta $00                                 ;C10D3C
	ldy #$0FE8                              ;C10D3E
	sty $02                                 ;C10D41
	lda #$C1                                ;C10D43
	sta $04                                 ;C10D45
	jsl $C2938C                             ;C10D47
	lda $03,s                               ;C10D4B
	sta $00                                 ;C10D4D
	jsl $C21591                             ;C10D4F
	lda $03,s                               ;C10D53
	sta $00                                 ;C10D55
	lda #$C5                                ;C10D57
	sta $01                                 ;C10D59
	lda #$05                                ;C10D5B
	sta $02                                 ;C10D5D
	jsl $C2942A                             ;C10D5F
	jsl $C62405                             ;C10D63
	lda $03,s                               ;C10D67
	sta $00                                 ;C10D69
	ldy #$0003                              ;C10D6B
	sty $02                                 ;C10D6E
	jsl $C62550                             ;C10D70
	lda $03,s                               ;C10D74
	sta $00                                 ;C10D76
	ldy #$0082                              ;C10D78
	sty $02                                 ;C10D7B
	jsl $C62550                             ;C10D7D
	lda $03,s                               ;C10D81
	inc a                                   ;C10D83
	sta $00                                 ;C10D84
	ldy #$0082                              ;C10D86
	sty $02                                 ;C10D89
	jsl $C62550                             ;C10D8B
	jsl $C625CE                             ;C10D8F
	lda $03,s                               ;C10D93
	inc a                                   ;C10D95
	sta $00                                 ;C10D96
	ldy #$100D                              ;C10D98
	sty $02                                 ;C10D9B
	lda #$C1                                ;C10D9D
	sta $04                                 ;C10D9F
	jsl $C2938C                             ;C10DA1
	lda #$84                                ;C10DA5
	sta $00                                 ;C10DA7
	lda #$01                                ;C10DA9
	sta $02                                 ;C10DAB
	jsl.l _SetEvent
	.db $A9,$04,$85,$00,$A9,$04,$85,$02
	jsl.l _SetEvent
	.db $A0,$F9,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$5E,$A9,$84   ;C10DBC  
	.db $85,$00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$22,$A0,$FC,$06,$84,$00
	jsl.l DisplayMessage
	.db $A9,$04,$85,$00,$A9,$05,$85,$02
	jsl.l _SetEvent
	.db $A9   ;C10DDC  
	.db $84,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $60,$3A,$D0,$2D,$A9   ;C10DEC  
	.db $84,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $A0,$FD,$06,$84,$00   ;C10DFC  
	.db $22,$7E,$2B,$C6,$A5,$00,$F0,$0A,$A0,$FE,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$B9,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$FF,$06,$84   ;C10E1C  
	.db $00,$22,$7E,$2B,$C6,$A5,$00,$80   ;C10E2C
	.db $DD                               ;C10E34  

func_C10E35:
	ldx.w #$0000
	bra @lbl_C10E53
@lbl_C10E3A:
	sta.b wTemp00
	phx
	jsl.l func_C30710
	plx
	lda.b wTemp00
	cmp.b #$0B
	bne @lbl_C10E52
	.db $A5,$01,$C9,$BE,$F0,$04,$C9,$C1   ;C10E48  
	.db $D0,$0A                           ;C10E50  
@lbl_C10E52:
	inx
@lbl_C10E53:
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C10E3A
	ldx.w #$FFFF
	rts

func_C10E5D:
	lda.b #$47
	sta.b wTemp00
	jsl.l func_C23BA6
	jsl.l func_C62405
	lda.b wTemp05,s
	inc a
	sta.b wTemp00
	ldy.w #$1005
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	lda.b wTemp05,s
	inc a
	sta.b wTemp00
	jsl.l func_C21591
	lda.b #$13
	sta.b wTemp00
	lda.b wTemp05,s
	inc a
	sta.b wTemp01
	jsl.l func_C2444B
	jsl.l func_C62405
	lda.b wTemp05,s
	inc a
	sta.b wTemp00
	ldy.w #$1008
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	ldy.w #$2528
	sty.b wTemp02
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C27951
	jsl.l func_C6080E
	rts
	.db $22,$05,$24,$C6,$A9,$13,$85,$00,$A0,$0B,$10,$84,$02,$A9,$C1,$85   ;C10EB9  
	.db $04,$22,$8C,$93,$C2,$80,$D7,$BF,$71,$88,$7E,$C9,$08,$90,$03,$4C   ;C10EC9  
	.db $D6,$0F,$A9,$04,$85,$00,$A9,$08,$85,$02
	jsl.l _SetEvent
	.db $A0,$76   ;C10ED9  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$85,$00,$22,$AC,$10,$C2,$A5   ;C10EE9
	.db $02,$1A,$29,$04,$49,$04,$85,$01,$A3,$03,$85,$00,$22,$38,$72,$C2   ;C10EF9
	.db $A3,$03,$85,$00,$22,$91,$15,$C2,$A3,$03,$85,$00,$A9,$C2,$85,$01   ;C10F09  
	.db $A9,$05,$85,$02,$22,$2A,$94,$C2,$22,$05,$24,$C6,$A0,$77,$08,$84   ;C10F19
	.db $00
	jsl.l DisplayMessage
	.db $A3,$03,$85,$00,$22,$91,$15,$C2,$A3,$03,$85   ;C10F29
	.db $00,$A9,$C2,$85,$01,$A9,$05,$85,$02,$22,$2A,$94,$C2,$22,$05,$24   ;C10F39
	.db $C6,$A0,$78,$08,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$85,$00,$22,$91   ;C10F49  
	.db $15,$C2,$A3,$03,$85,$00,$A9,$C2,$85,$01,$A9,$05,$85,$02,$22,$2A   ;C10F59  
	.db $94,$C2,$22,$05,$24,$C6,$A3,$03,$85,$00,$22,$1B,$72,$C2,$A0,$79   ;C10F69  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$7A,$08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$C5,$85,$00,$22,$5D,$03,$C3,$A5,$00,$30,$04,$22,$57,$01,$C1   ;C10F89
	.db $22,$37,$24,$C6,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$09,$04   ;C10F99  
	.db $85,$02,$A9,$17,$85,$00
	jsl.l _SetEvent
	.db $A9,$8D,$85,$00,$A9,$01   ;C10FA9  
	.db $85,$02
	jsl.l _SetEvent
	.db $22,$71,$27,$C6,$85,$02,$A9,$90,$85,$00   ;C10FB9  
	jsl.l _SetEvent
	.db $A0,$0A,$01,$84,$00,$22,$23,$2A,$C6,$A0,$7C,$08   ;C10FC9  
	.db $84,$00
	jsl.l DisplayMessage
	.db $80,$9F,$04,$20,$C2,$05,$00,$14,$FF,$06   ;C10FD9  
	.db $21,$02,$10,$FF,$02,$14,$FF,$06   ;C10FE9
	.db $14,$FF,$16,$FF                   ;C10FF1
	.db $06,$20,$C2,$05,$02,$16,$FF,$06,$FF,$02,$10,$FF,$06,$02,$16,$FF   ;C10FF5  
	.db $04,$16,$FF,$00,$14,$FF           ;C11005
	.db $06,$FF,$11,$FF,$E2,$20,$C2,$10,$8A,$48,$20,$1A,$10,$68,$60,$E2   ;C1100B  
	.db $20,$C2,$10,$DA,$A9,$04,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$C9   ;C1101B  
	.db $06,$90,$03,$4C,$A4,$10,$DA,$8A,$85,$02,$3A,$85,$00,$A9,$02,$85   ;C1102B  
	.db $01,$20,$1A,$68,$FA,$BF,$70,$88,$7E,$D0,$0A,$A0,$F6,$06,$84,$00   ;C1103B  
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$0A,$A0,$F6,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$0A,$A0,$F6,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A   ;C1105B  
	.db $D0,$0A,$A0,$FA,$06,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$20,$A9   ;C1106B  
	.db $84,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$0A,$A0,$FB,$06,$84,$00   ;C1107B  
	jsl.l DisplayMessage
	.db $60,$A0,$00,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0   ;C1108B  
	.db $02,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$07,$90,$03,$4C,$51,$11   ;C1109B
	.db $A3,$03,$85,$00,$85,$02,$64,$01,$20,$1A,$68,$A3,$03,$85,$00,$22   ;C110AB  
	.db $1B,$72,$C2,$A0,$6F,$08,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6   ;C110BB
	.db $A3,$03,$85,$00,$A0,$6C,$11,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93   ;C110CB  
	.db $C2,$A9,$13,$85,$00,$A0,$6E,$11,$84,$02,$A9,$C1,$85,$04,$22,$8C   ;C110DB
	.db $93,$C2,$A0,$70,$08,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A0   ;C110EB  
	.db $71,$08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$22,$1B,$72,$C2,$A9,$13,$85   ;C1110B  
	.db $00,$A9,$00,$85,$01,$22,$38,$72,$C2,$A9,$04,$85,$00,$A9,$07,$85   ;C1111B
	.db $02
	jsl.l _SetEvent
	.db $A0,$72,$08,$84,$00,$22,$7E,$2B,$C6,$A5,$00   ;C1112B
	.db $D0,$0A,$A0,$75,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$73,$08,$84   ;C1113B  
	.db $00
	jsl.l DisplayMessage
	.db $60,$C9,$08,$B0,$0D,$A0,$74,$08,$84,$00,$22   ;C1114B
	.db $7E,$2B,$C6,$A5,$00,$80,$D9,$A0,$7B,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$03,$FF,$03,$03,$12,$FF       ;C1116B
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event_Gaibara
	plx
	cmp.b #$06
	bcs @lbl_C11190
	ldy.w #$06B8
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C11190:
	.db $BF,$71,$88,$7E,$D0,$0F,$1A,$9F,$71,$88,$7E,$A0,$6D,$08,$84,$00   ;C11190  
	jsl.l DisplayMessage
	.db $60,$A0,$6E,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2   ;C111A0  
	.db $20,$C2,$10,$DA,$8A,$85,$02,$3A,$3A,$85,$00,$A9,$02,$85,$01,$20   ;C111B0  
	.db $1A,$68,$FA,$BF,$6F,$88,$7E,$C9,$04,$B0,$0A,$A0,$E0,$06,$84,$00   ;C111C0
	jsl.l DisplayMessage
	.db $60,$A0,$01,$07   ;C111D0  
	.db $84,$00
	jsl.l DisplayMessage
	.db $60       ;C111D8  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	pha
	jsr.w func_C111EA
	pla
	rts

func_C111EA:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	beq @lbl_C111F7
;C111F4  
	.db $4C,$EA,$12
@lbl_C111F7:
	GetEvent Event_Kechi_85
	cmp.b #$02
	bcc @lbl_C11212
	.db $A0,$04,$07,$84,$00,$22,$7E,$2B   ;C11205
	.db $C6,$A5,$00,$80,$17               ;C1120D  
@lbl_C11212:
	SetEvent Event_Kechi_85 $02
	ldy.w #$0703
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C1123F
	.db $A0,$05,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C11233  
@lbl_C11235:
	.db $A0,$06,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C1123D  
@lbl_C1123F:
	ldy.w #$00C8
	sty.b wTemp00
	ldy.w #$0000
	sty.b wTemp02
	jsl.l func_C25BB7
	lda.b wTemp00
	bne @lbl_C11235
	ldy.w #$090B
	sty.b wTemp00
	jsl.l DisplayMessage
	ldy.w #$0707
	sty.b wTemp00
	jsl.l DisplayMessage
	ldy.w #$012F
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp02
	eor.b #$04
	sta.b wTemp01
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C27238
	lda.b wTemp03,s
	sta.b wTemp00
	jsl.l func_C2721B
	lda.b wTemp03,s
	sta.b wTemp00
	jsl.l func_C21591
	ldy.w #$0708
	sty.b wTemp00
	jsl.l DisplayMessage
	lda.b wTemp03,s
	sta.b wTemp00
	jsl.l func_C21591
	jsr.w func_C1173F
	bcs @lbl_C112DD
	.db $A0,$0B,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$03,$4C,$2B,$12   ;C112AC
	.db $A0,$C8,$00,$84,$00,$A0,$00,$00,$84,$02,$22,$B7,$5B,$C2,$A5,$00   ;C112BC
	.db $F0,$03,$4C,$35,$12,$A0,$0B,$09,$84,$00
	jsl.l DisplayMessage
	.db $4C,$A7   ;C112CC  
	.db $12                               ;C112DC  
@lbl_C112DD:
	SetEvent Event_Kechi $01
	rts
	.db $3A,$F0,$03,$4C,$ED,$14,$A9,$85,$85,$00
	jsl.l _GetEvent
	.db $A5,$00   ;C112EA
	.db $3A,$F0,$2F,$3A,$F0,$0A,$A0,$0F,$07,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C112FA
	.db $A0,$0E,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$85,$85,$00,$A9,$03,$85   ;C1130A
	.db $02
	jsl.l _SetEvent
	.db $A9,$05,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$A3,$03,$85,$00,$85,$02,$A9,$04,$85,$01,$20,$1A,$68,$A0   ;C1132A  
	.db $0C,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$18,$69   ;C1133A  
	tsb $48                                 ;C1134A
	sta $00                                 ;C1134C
	ldy #$17E9                              ;C1134E
	sty $02                                 ;C11351
	lda #$C1                                ;C11353
	sta $04                                 ;C11355
	jsl $C2938C                             ;C11357
	pla                                     ;C1135B
	sta $00                                 ;C1135C
	jsl $C21584                             ;C1135E
	lda $03,s                               ;C11362
	sta $00                                 ;C11364
	jsl $C2159E                             ;C11366
	jsl $C62405                             ;C1136A
	lda $03,s                               ;C1136E
	clc                                     ;C11370
	adc #$03                                ;C11371
	pha                                     ;C11373
	sta $00                                 ;C11374
	ldy #$17EC                              ;C11376
	sty $02                                 ;C11379
	lda #$C1                                ;C1137B
	sta $04                                 ;C1137D
	jsl $C2938C                             ;C1137F
	pla                                     ;C11383
	sta $00                                 ;C11384
	jsl $C21584                             ;C11386
	lda $03,s                               ;C1138A
	sta $00                                 ;C1138C
	jsl $C2159E                             ;C1138E
	jsl $C62405                             ;C11392
	lda $03,s                               ;C11396
	inc a                                   ;C11398
	inc a                                   ;C11399
	pha                                     ;C1139A
	sta $00                                 ;C1139B
	ldy #$17EF                              ;C1139D
	sty $02                                 ;C113A0
	lda #$C1                                ;C113A2
	sta $04                                 ;C113A4
	jsl $C2938C                             ;C113A6
	pla                                     ;C113AA
	sta $00                                 ;C113AB
	jsl $C21584                             ;C113AD
	lda $03,s                               ;C113B1
	sta $00                                 ;C113B3
	jsl $C2159E                             ;C113B5
	jsl $C62405                             ;C113B9
	lda $03,s                               ;C113BD
	inc a                                   ;C113BF
	pha                                     ;C113C0
	sta $00                                 ;C113C1
	ldy #$17F2                              ;C113C3
	sty $02                                 ;C113C6
	lda #$C1                                ;C113C8
	sta $04                                 ;C113CA
	jsl $C2938C                             ;C113CC
	pla                                     ;C113D0
	sta $00                                 ;C113D1
	jsl $C21584                             ;C113D3
	lda $03,s                               ;C113D7
	sta $00                                 ;C113D9
	jsl $C2159E                             ;C113DB
	jsl $C62405                             ;C113DF
	lda $03,s                               ;C113E3
	sta $00                                 ;C113E5
	ldy #$17E1                              ;C113E7
	sty $02                                 ;C113EA
	lda #$C1                                ;C113EC
	sta $04                                 ;C113EE
	jsl $C2938C                             ;C113F0
	lda $03,s                               ;C113F4
	sta $00                                 ;C113F6
	jsl $C21584                             ;C113F8
	ldy #$090E                              ;C113FC
	sty $00                                 ;C113FF
	jsl.l DisplayMessage
	.db $A3,$03,$18,$69,$04   ;C113FA  
	.db $85,$00,$48,$22,$9E,$15,$C2,$68,$85,$00,$48,$22,$EB,$82,$C2,$68   ;C1140A  
	.db $85,$00,$22,$35,$0F,$C2,$22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$E3   ;C1141A  
	.db $17,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00,$22   ;C1142A  
	.db $84,$15,$C2,$A0,$0F,$09,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$18,$69   ;C1143A  
	.db $03,$85,$00,$48,$22,$9E,$15,$C2,$68,$85,$00,$48,$22,$EB,$82,$C2   ;C1144A  
	.db $68,$85,$00,$22,$35,$0F,$C2,$22,$05,$24,$C6,$A3,$03,$85,$00,$A0   ;C1145A
	.db $E5,$17,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00   ;C1146A  
	.db $22,$84,$15,$C2,$A0,$10,$09,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$1A   ;C1147A  
	.db $1A,$85,$00,$48,$22,$9E,$15,$C2,$68,$85,$00,$48,$22,$EB,$82,$C2   ;C1148A
	.db $68,$85,$00,$22,$35,$0F,$C2,$22,$05,$24,$C6,$A3,$03,$85,$00,$A0   ;C1149A
	.db $E7,$17,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00   ;C114AA  
	.db $22,$84,$15,$C2,$A0,$11,$09,$84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$1A   ;C114BA  
	.db $85,$00,$48,$22,$9E,$15,$C2,$68,$85,$00,$48,$22,$EB,$82,$C2,$68   ;C114CA  
	.db $85,$00,$22,$35,$0F,$C2,$A9,$85,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$3A,$F0,$03,$4C,$5C,$16,$A9,$85,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$02,$B0,$12,$A3,$03,$85,$00,$22,$1B,$72,$C2,$A0   ;C114FA  
	.db $15,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A3,$03,$85,$00,$85,$02,$A9   ;C1150A  
	.db $04,$85,$01,$20,$1A,$68,$A3,$03,$85,$00,$22,$1B,$72,$C2,$A0,$15   ;C1151A  
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$16,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$17,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85   ;C1153A
	.db $00,$A9,$04,$85,$01,$22,$38,$72,$C2,$A0,$18,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$1A,$1A,$1A,$85,$00,$A9,$06,$85   ;C1155A  
	.db $01,$22,$38,$72,$C2,$A0,$19,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05   ;C1156A  
	.db $24,$C6,$A3,$03,$1A,$1A,$85,$00,$A9,$02,$85,$01,$22,$38,$72,$C2   ;C1157A  
	.db $A0,$1A,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$1A   ;C1158A
	.db $1A,$1A,$85,$00,$A9,$07,$85,$01,$22,$38,$72,$C2,$A3,$03,$1A,$1A   ;C1159A
	.db $85,$00,$A9,$00,$85,$01,$22,$38,$72,$C2,$A0,$1B,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C115BD
	lda $03,s                               ;C115C1
	clc                                     ;C115C3
	adc #$03                                ;C115C4
	sta $00                                 ;C115C6
	ldy #$17FA                              ;C115C8
	sty $02                                 ;C115CB
	lda #$C1                                ;C115CD
	sta $04                                 ;C115CF
	jsl $C2938C                             ;C115D1
	lda $03,s                               ;C115D5
	inc a                                   ;C115D7
	sta $00                                 ;C115D8
	ldy #$1804                              ;C115DA
	sty $02                                 ;C115DD
	lda #$C1                                ;C115DF
	sta $04                                 ;C115E1
	jsl $C2938C                             ;C115E3
	lda $03,s                               ;C115E7
	inc a                                   ;C115E9
	inc a                                   ;C115EA
	sta $00                                 ;C115EB
	ldy #$17FF                              ;C115ED
	sty $02                                 ;C115F0
	lda #$C1                                ;C115F2
	sta $04                                 ;C115F4
	jsl $C2938C                             ;C115F6
	lda $03,s                               ;C115FA
	clc                                     ;C115FC
	adc #$04                                ;C115FD
	sta $00                                 ;C115FF
	ldy #$17F4                              ;C11601
	sty $02                                 ;C11604
	lda #$C1                                ;C11606
	sta $04                                 ;C11608
	jsl $C2938C                             ;C1160A
	lda $03,s                               ;C1160E
	clc                                     ;C11610
	adc #$04                                ;C11611
	sta $00                                 ;C11613
	jsl $C20F35                             ;C11615
	lda $03,s                               ;C11619
	clc                                     ;C1161B
	adc #$03                                ;C1161C
	sta $00                                 ;C1161E
	jsl $C20F35                             ;C11620
	lda $03,s                               ;C11624
	inc a                                   ;C11626
	inc a                                   ;C11627
	sta $00                                 ;C11628
	jsl $C20F35                             ;C1162A
	lda $03,s                               ;C1162E
	inc a                                   ;C11630
	sta $00                                 ;C11631
	jsl $C20F35                             ;C11633
	jsl $C62405                             ;C11637
	lda #$05                                ;C1163B
	sta $00                                 ;C1163D
	lda #$03                                ;C1163F
	sta $02                                 ;C11641
	jsl.l _SetEvent
	.db $A3,$03,$85   ;C1163A  
	.db $00,$22,$1B,$72,$C2,$A0,$1C,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00   ;C1164A
	.db $80,$16,$3A,$D0,$3D,$A3,$03,$85,$00,$22,$1B,$72,$C2,$A0,$1E,$07   ;C1165A  
	.db $84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$14,$A0,$1D,$07,$84,$00
	jsl.l DisplayMessage
	.db $7B,$A3,$03,$AA,$A9,$03,$9F,$71,$88,$7E,$60,$A0,$12   ;C1167A  
	.db $09,$84,$00
	jsl.l DisplayMessage
	.db $7B,$A3,$03,$AA,$A9,$04,$9F,$71,$88   ;C1168A
	.db $7E,$60,$A9,$85,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$3A,$D0,$58,$A0   ;C1169A  
	.db $1F,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$0A,$A0,$20,$07,$84   ;C116AA  
	.db $00
	jsl.l DisplayMessage
	.db $60,$A9,$85,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $A9,$13,$85,$00,$22,$AC,$10,$C2,$A5,$02,$49,$04,$85,$01   ;C116CA  
	.db $A9,$13,$85,$00,$22,$38,$72,$C2,$A3,$03,$85,$00,$22,$1B,$72,$C2   ;C116DA
	.db $A3,$03,$85,$00,$22,$91,$15,$C2,$20,$3F,$17,$B0,$09,$A0,$21,$07   ;C116EA  
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$A3,$03,$85,$00,$22,$28,$11,$C2,$A5   ;C116FA  
	.db $01,$4A,$4A,$C5,$00,$B0,$24,$A3,$03,$85,$00,$22,$CE,$3B,$C2,$A4   ;C1170A  
	.db $00,$A5,$00,$D0,$0A,$A0,$24,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$84   ;C1171A
	.db $02,$A0,$22,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$23,$07,$84,$00   ;C1172A
	jsl.l DisplayMessage
	.db $60               ;C1173A  

func_C1173F:
	ldy.w #$0709
	sty.b wTemp00
	jsl.l DisplayMessage
	lda.b wTemp05,s
	sta.b wTemp00
	jsl.l func_C21591
	ldy.w #$090C
	sty.b wTemp00
	jsl.l DisplayMessage
	lda.b #$13
	sta.b wTemp00
	lda.b #$87
	sta.b wTemp02
	jsl.l func_C626F6
	ldy.w #$012F
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C21128
	lda.b wTemp00
	cmp.b wTemp01
	bne @lbl_C1178A
	.db $22,$67,$11,$C2,$A5,$00,$C5,$01   ;C11780  
	.db $F0,$0A                           ;C11788  
@lbl_C1178A:
	jsl.l Random
	lda.b wTemp00
	cmp.b #$55
	bcs @lbl_C117DB
	.db $A0,$0A,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$0D,$09,$84,$00
	jsl.l DisplayMessage
	.db $A9,$DE,$85,$00,$22,$A6,$3B,$C2,$A9,$13,$85,$00,$A0,$F6   ;C117A4  
	.db $FF,$84,$02,$22,$09,$32,$C2,$A9,$FC,$85,$00,$22,$71,$32,$C2,$A0   ;C117B4  
	.db $D4,$FE,$84,$00,$22,$BE,$33,$C2,$A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$18,$60       ;C117D4  
@lbl_C117DB:
	jsl.l func_C312FF
	sec
	rts
	.db $14,$FF,$15,$FF,$16,$FF,$17,$FF,$02,$10,$FF,$03,$11,$FF,$03,$12   ;C117E1  
	.db $FF,$03,$FF,$05,$04,$04,$04,$04,$FF,$05,$04,$04,$04,$FF,$04,$04   ;C117F1  
	.db $04,$04,$FF,$03,$04,$04,$04,$FF,$E2,$20,$C2,$10,$A0,$0D,$07,$84   ;C11801  
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$DA,$8A,$3A,$3A,$3A,$3A   ;C11811
	.db $85,$00,$86,$02,$A9,$04,$85,$01,$20,$1A,$68,$FA,$A9,$01,$9F,$71   ;C11821  
	.db $88,$7E,$CA,$CA,$CA,$CA,$DA,$A0,$11,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$76,$E2,$20,$C2,$10,$DA,$8A,$3A,$3A,$3A,$85,$00,$86,$02,$A9   ;C11841  
	.db $04,$85,$01,$20,$1A,$68,$FA,$A9,$01,$9F,$71,$88,$7E,$CA,$CA,$CA   ;C11851  
	.db $DA,$A0,$10,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$4C,$E2,$20,$C2,$10   ;C11861
	.db $DA,$8A,$3A,$3A,$85,$00,$86,$02,$A9,$04,$85,$01,$20,$1A,$68,$FA   ;C11871
	.db $A9,$01,$9F,$71,$88,$7E,$CA,$CA,$DA,$A0,$13,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$24,$E2,$20,$C2,$10,$DA,$8A,$3A,$85,$00,$86,$02,$A9   ;C11891  
	.db $04,$85,$01,$20,$1A,$68,$FA,$A9,$01,$9F,$71,$88,$7E,$CA,$DA,$A0   ;C118A1  
	.db $12,$07,$84,$00
	jsl.l DisplayMessage
	.db $FA,$BF,$72,$88,$7E,$3F,$73,$88   ;C118B1  
	.db $7E,$3F,$74,$88,$7E,$3F,$75,$88,$7E,$D0,$01,$60,$8A,$48,$A0,$14   ;C118C1  
	.db $07,$84,$00
	jsl.l DisplayMessage
	lda $01,s                               ;C118D8
	clc                                     ;C118DA
	adc #$04                                ;C118DB
	sta $00                                 ;C118DD
	jsl $C21584                             ;C118DF
	lda $01,s                               ;C118E3
	sta $00                                 ;C118E5
	jsl $C2159E                             ;C118E7
	jsl $C62405                             ;C118EB
	lda $01,s                               ;C118EF
	clc                                     ;C118F1
	adc #$03                                ;C118F2
	sta $00                                 ;C118F4
	jsl $C21584                             ;C118F6
	lda $01,s                               ;C118FA
	sta $00                                 ;C118FC
	jsl $C2159E                             ;C118FE
	jsl $C62405                             ;C11902
	lda $01,s                               ;C11906
	inc a                                   ;C11908
	inc a                                   ;C11909
	sta $00                                 ;C1190A
	jsl $C21584                             ;C1190C
	lda $01,s                               ;C11910
	sta $00                                 ;C11912
	jsl $C2159E                             ;C11914
	jsl $C62405                             ;C11918
	lda $01,s                               ;C1191C
	inc a                                   ;C1191E
	sta $00                                 ;C1191F
	jsl $C21584                             ;C11921
	lda $01,s                               ;C11925
	sta $00                                 ;C11927
	jsl $C2159E                             ;C11929
	lda #$85                                ;C1192D
	sta $00                                 ;C1192F
	lda #$02                                ;C11931
	sta $02                                 ;C11933
	jsl.l _SetEvent
	.db $68,$60                           ;C11939
	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	pha
	jsr.w func_C11946
	pla
	rts

func_C11946:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	beq @lbl_C11953
;C11950  
	.db $4C,$4C,$1B
@lbl_C11953:
	GetEvent Event_Pekeji_86
	cmp.b #$02
	bcc @lbl_C11964
	jmp.w func_C11A07
@lbl_C11964:
	lda.b wTemp03,s
	sta.b wTemp00
	sta.b wTemp02
	lda.b #$01
	sta.b wTemp01
	jsr.w func_C1681A
	lda.b wTemp03,s
	sta.b wTemp00
	ldy.w #$230F
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	jsr.w func_C12244
	jsl.l func_C62405
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	ldy.w #$2316
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	jsl.l func_C21584
	lda.b wTemp03,s
	sta.b wTemp00
	jsl.l func_C2159E
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b #$04
	sta.b wTemp01
	jsl.l func_C27238
	ldy.w #$0725
	sty.b wTemp00
	jsl.l DisplayMessage
	ldy.w #$012F
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	lda.b #$06
	sta.b wTemp01
	jsl.l func_C27238
	ldy.w #$0726
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b wTemp03,s
	inc a
	sta.b wTemp00
	ldy.w #$231A
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	SetEvent Event_Pekeji_86 $05
	rts

func_C11A07:
	cmp.b #$03
	bcs @lbl_C11A15
	ldy.w #$072A
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C11A15:
	cmp.b #$04
	bcc @lbl_C11A1C
	jmp.w func_C11B11
@lbl_C11A1C:
	lda #$13                                ;C11A1C
	sta $00                                 ;C11A1E
	lda #$02                                ;C11A20
	sta $01                                 ;C11A22
	jsl $C27238                             ;C11A24
	lda $03,s                               ;C11A28
	sta $00                                 ;C11A2A
	ldy #$2334                              ;C11A2C
	sty $02                                 ;C11A2F
	jsl $C27951                             ;C11A31
	jsl $C62405                             ;C11A35
	lda $03,s                               ;C11A39
	sta $00                                 ;C11A3B
	ldy #$22F0                              ;C11A3D
	sty $02                                 ;C11A40
	lda #$C1                                ;C11A42
	sta $04                                 ;C11A44
	jsl $C2938C                             ;C11A46
	lda #$13                                ;C11A4A
	sta $00                                 ;C11A4C
	lda #$04                                ;C11A4E
	sta $01                                 ;C11A50
	jsl $C27238                             ;C11A52
	lda #$10                                ;C11A56
	sta $00                                 ;C11A58
	lda #$01                                ;C11A5A
	sta $01                                 ;C11A5C
	jsl $C62AEE                             ;C11A5E
	ldy #$072B                              ;C11A62
	sty $00                                 ;C11A65
	jsl $C62B7E                             ;C11A67
	lda $00                                 ;C11A6B
	.db $F0,$0B   ;C11A6D
	ldy #$072D                              ;C11A6F
	sty $00                                 ;C11A72
	jsl.l DisplayMessage
	.db $80,$09,$A0,$2C   ;C11A6C
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2E,$07,$84,$00,$22,$7E,$2B,$C6   ;C11A7C  
	.db $A5,$00,$F0,$0B,$A0,$30,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$09,$A0   ;C11A8C  
	.db $2F,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$31,$07,$84,$00,$22,$7E,$2B   ;C11A9C  
	.db $C6,$A5,$00,$F0,$0B,$A0,$33,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$09   ;C11AAC  
	.db $A0,$32,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$34,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$F6,$22,$84,$02,$A9   ;C11ACC  
	.db $C1,$85,$04,$22,$8C,$93,$C2,$A9,$02,$85,$01,$22,$EE,$2A,$C6,$A3   ;C11ADC  
	.db $03,$85,$00,$A0,$33,$04,$84,$02,$22,$51,$79,$C2,$A9,$86,$85,$00   ;C11AEC  
	.db $A9,$04,$85,$02
	jsl.l _SetEvent
	.db $A9,$06,$85,$00,$A9,$01,$85,$02   ;C11AFC
	jsl.l _SetEvent
	.db $60               ;C11B0C  

func_C11B11:
	cmp.b #$05
	bcs @lbl_C11B1F
	.db $A0,$35,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C11B1D  
@lbl_C11B1F:
	ldy.w #$0727
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C11B36
	.db $A0,$28,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C11B34  
@lbl_C11B36:
	ldy.w #$0729
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event_Pekeji_86 $02
	rts
	.db $3A,$F0,$03,$4C,$1C,$1D,$A9,$86,$85,$00
	jsl.l _GetEvent
	.db $A5,$00   ;C11B4C
	.db $C9,$02,$B0,$16,$A0,$37,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$86,$85   ;C11B5C
	.db $00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$C9,$03,$B0,$3B,$A0,$38   ;C11B6C
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A3,$03,$85,$00,$22,$F8,$77,$C2   ;C11B7C  
	.db $A5,$01,$C9,$00,$D0,$19,$A9,$10,$85,$00,$A9,$01,$85,$01,$22,$EE   ;C11B8C  
	.db $2A,$C6,$A0,$3B,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$80,$5F,$A0   ;C11B9C
	.db $30,$07,$84,$00
	jsl.l DisplayMessage
	rts                                     ;C11BB4
	cmp #$04                                ;C11BB5
	.db $B0,$CB   ;C11BB7
	lda #$13                                ;C11BB9
	sta $00                                 ;C11BBB
	lda #$02                                ;C11BBD
	sta $01                                 ;C11BBF
	jsl $C27238                             ;C11BC1
	lda $03,s                               ;C11BC5
	sta $00                                 ;C11BC7
	ldy #$2334                              ;C11BC9
	sty $02                                 ;C11BCC
	jsl $C27951                             ;C11BCE
	jsl $C62405                             ;C11BD2
	lda $03,s                               ;C11BD6
	sta $00                                 ;C11BD8
	ldy #$22F0                              ;C11BDA
	sty $02                                 ;C11BDD
	lda #$C1                                ;C11BDF
	sta $04                                 ;C11BE1
	jsl $C2938C                             ;C11BE3
	lda #$13                                ;C11BE7
	sta $00                                 ;C11BE9
	lda #$04                                ;C11BEB
	sta $01                                 ;C11BED
	jsl $C27238                             ;C11BEF
	lda #$10                                ;C11BF3
	sta $00                                 ;C11BF5
	lda #$01                                ;C11BF7
	sta $01                                 ;C11BF9
	jsl $C62AEE                             ;C11BFB
	ldy #$0739                              ;C11BFF
	sty $00                                 ;C11C02
	jsl $C62B7E                             ;C11C04
	lda $00                                 ;C11C08
	.db $D0,$1E   ;C11C0A
	ldy #$073A                              ;C11C0C
	sty $00                                 ;C11C0F
	jsl.l DisplayMessage
	.db $A9,$02,$85,$01,$22,$EE,$2A   ;C11C0C
	.db $C6,$A9,$86,$85,$00,$A9,$04,$85,$02
	jsl.l _SetEvent
	.db $60,$A0,$3C   ;C11C1C  
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0   ;C11C2C  
	.db $FB,$22,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$22,$67,$11,$C2   ;C11C3C
	.db $A4,$04,$D0,$07,$A4,$02,$C0,$E8,$03,$90,$1A,$A0,$15,$89,$84,$00   ;C11C4C  
	.db $22,$7E,$2B,$C6,$A5,$00,$D0,$3B,$A0,$3D,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$FF,$22,$84,$02,$A9,$C1   ;C11C6C  
	.db $85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00,$22,$35,$0F,$C2,$A9,$02   ;C11C7C  
	.db $85,$01,$22,$EE,$2A,$C6,$A9,$06,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$A3,$03,$85,$00,$A0,$01,$23,$84,$02,$A9,$C1,$85,$04   ;C11C9C  
	.db $22,$8C,$93,$C2,$A0,$E8,$03,$84,$00,$A0,$00,$00,$84,$02,$22,$B7   ;C11CAC  
	.db $5B,$C2,$A0,$42,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A0   ;C11CBC
	.db $16,$09,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A0,$43,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05   ;C11CDC  
	.db $24,$C6,$A3,$03,$85,$00,$A0,$F6,$22,$84,$02,$A9,$C1,$85,$04,$22   ;C11CEC  
	.db $8C,$93,$C2,$A3,$03,$85,$00,$22,$35,$0F,$C2,$A9,$02,$85,$01,$22   ;C11CFC  
	.db $EE,$2A,$C6,$A9,$06,$85,$00,$A9,$04,$85,$02
	jsl.l _SetEvent
	.db $60   ;C11D0C  
	.db $3A,$F0,$03,$4C,$23,$1D,$60,$3A,$F0,$03,$4C,$AD,$1D,$A9,$86,$85   ;C11D1C
	.db $00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$02,$B0,$16,$A0,$3F,$07,$84,$00   ;C11D2C
	jsl.l DisplayMessage
	.db $A9,$86,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$C9,$03,$B0,$0A,$A0,$38,$07,$84,$00
	jsl.l DisplayMessage
	rts                                     ;C11D5A
	lda #$13                                ;C11D5B
	sta $00                                 ;C11D5D
	lda #$02                                ;C11D5F
	sta $01                                 ;C11D61
	jsl $C27238                             ;C11D63
	lda $03,s                               ;C11D67
	sta $00                                 ;C11D69
	ldy #$2334                              ;C11D6B
	sty $02                                 ;C11D6E
	jsl $C27951                             ;C11D70
	jsl $C62405                             ;C11D74
	lda $03,s                               ;C11D78
	sta $00                                 ;C11D7A
	ldy #$22F0                              ;C11D7C
	sty $02                                 ;C11D7F
	lda #$C1                                ;C11D81
	sta $04                                 ;C11D83
	jsl $C2938C                             ;C11D85
	lda #$13                                ;C11D89
	sta $00                                 ;C11D8B
	lda #$04                                ;C11D8D
	sta $01                                 ;C11D8F
	jsl $C27238                             ;C11D91
	lda #$10                                ;C11D95
	sta $00                                 ;C11D97
	lda #$01                                ;C11D99
	sta $01                                 ;C11D9B
	jsl $C62AEE                             ;C11D9D
	ldy #$0741                              ;C11DA1
	sty $00                                 ;C11DA4
	jsl.l DisplayMessage
	.db $4C,$33   ;C11D9C  
	.db $1C,$3A,$F0,$03,$4C,$49,$20,$A3,$03,$85,$00,$A9,$02,$85,$01,$22   ;C11DAC  
	.db $38,$72,$C2,$20,$95,$21,$A3,$03,$85,$00,$22,$9E,$15,$C2,$A0,$47   ;C11DBC
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A9   ;C11DCC  
	.db $04,$85,$01,$22,$38,$72,$C2,$A9,$13,$85,$00,$A9,$00,$85,$01,$22   ;C11DDC  
	.db $38,$72,$C2,$A9,$10,$85,$00,$A9,$01,$85,$01,$22,$EE,$2A,$C6,$A0   ;C11DEC
	.db $48,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$1A,$89,$84,$00,$22,$7E,$2B   ;C11DFC
	.db $C6,$A5,$00,$30,$02,$D0,$58,$A0,$49,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$1B,$89,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$30,$02,$D0,$20,$A0   ;C11E1C
	.db $4A,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$19,$89,$84,$00,$22,$7E,$2B   ;C11E2C
	.db $C6,$A5,$00,$A0,$4B,$07,$84,$00
	jsl.l DisplayMessage
	.db $4C,$1A,$1F,$A0   ;C11E3C  
	.db $4B,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$18,$89,$84,$00,$22,$7E,$2B   ;C11E4C
	.db $C6,$A5,$00,$A0,$4A,$07,$84,$00
	jsl.l DisplayMessage
	.db $4C,$1A,$1F,$3A   ;C11E5C  
	.db $D0,$56,$A0,$4A,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$1C,$89,$84,$00   ;C11E6C  
	.db $22,$7E,$2B,$C6,$A5,$00,$30,$02,$D0,$1F,$A0,$49,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$19,$89,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$A0,$4B   ;C11E8C  
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $80,$75,$A0,$4B,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$17,$89,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$A0,$49,$07   ;C11EAC  
	.db $84,$00
	jsl.l DisplayMessage
	.db $80,$56,$A0,$4B,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$1D,$89,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$30,$02,$D0,$1F   ;C11ECC  
	.db $A0,$49,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$18,$89,$84,$00,$22,$7E   ;C11EDC
	.db $2B,$C6,$A5,$00,$A0,$4A,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$1F,$A0   ;C11EEC
	.db $4A,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$17,$89,$84,$00,$22,$7E,$2B   ;C11EFC
	.db $C6,$A5,$00,$A0,$49,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$00,$A0,$1E   ;C11F0C  
	.db $89,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$0D,$A0,$4C,$07,$84,$00   ;C11F1C
	.db $22,$7E,$2B,$C6,$A5,$00,$80,$F1,$22,$05,$24,$C6,$A9,$13,$85,$00   ;C11F2C  
	.db $22,$84,$15,$C2,$A0,$1F,$09,$84,$00
	jsl.l DisplayMessage
	.db $20,$C8,$21   ;C11F3C  
	.db $A0,$20,$09,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85   ;C11F4C
	.db $00,$A0,$06,$23,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$4D   ;C11F5C
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$4E,$07,$84,$00,$22,$7E,$2B,$C6   ;C11F6C  
	.db $A5,$00,$F0,$48,$A0,$4F,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0   ;C11F7C  
	.db $3B,$A0,$50,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03   ;C11F8C
	.db $85,$00,$A0,$0A,$23,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3   ;C11F9C  
	.db $03,$85,$00,$22,$35,$0F,$C2,$A9,$02,$85,$01,$22,$EE,$2A,$C6,$A9   ;C11FAC  
	.db $06,$85,$00,$A9,$FF,$85,$02
	jsl.l _SetEvent
	.db $60,$A9,$07,$85,$00   ;C11FBC  
	.db $A9,$00,$85,$02
	jsl.l _SetEvent
	.db $22,$05,$24,$C6,$AF,$70,$89,$7E   ;C11FCC
	.db $48,$A9,$FF,$8F,$70,$89,$7E,$A9,$13,$85,$00,$22,$84,$15,$C2,$A3   ;C11FDC
	.db $04,$48,$48,$48,$A0,$1F,$09,$84,$00
	jsl.l DisplayMessage
	.db $20,$05,$22   ;C11FEC  
	.db $A0,$20,$09,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$20,$2B,$22   ;C11FFC
	.db $68,$68,$68,$68,$8F,$70,$89,$7E,$A0,$51,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$21,$09,$84,$00
	jsl.l DisplayMessage
	.db $A9,$06,$85,$00,$A9,$05   ;C1201C  
	.db $85,$02
	jsl.l _SetEvent
	.db $7B,$A3,$03,$AA,$A9,$06,$9F,$71,$88,$7E   ;C1202C  
	.db $22,$0D,$8B,$C2,$A9,$02,$85,$01,$22,$EE,$2A,$C6,$60,$3A,$F0,$03   ;C1203C  
	.db $4C,$B7,$20,$A9,$07,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$04,$B0   ;C1204C  
	.db $40,$C9,$02,$B0,$2F,$A0,$5B,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00   ;C1205C
	.db $D0,$18,$A9,$07,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$1A,$85,$02,$A9   ;C1206C  
	.db $07,$85,$00
	jsl.l _SetEvent
	.db $4C,$D4,$1F,$A0,$30,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$5C,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$80   ;C1208C  
	.db $CF,$A0,$5D,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$D0,$03,$4C,$D4   ;C1209C  
	.db $1F,$A0,$30,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$42,$A3,$03   ;C120AC  
	.db $85,$00,$22,$28,$11,$C2,$A5,$01,$4A,$4A,$C5,$00,$B0,$28,$A3,$03   ;C120BC  
	.db $85,$00,$22,$CE,$3B,$C2,$A4,$00,$A5,$00,$D0,$0A,$A0,$5E,$07,$84   ;C120CC  
	.db $00
	jsl.l DisplayMessage
	.db $60,$C9,$50,$F0,$2D,$84,$02,$A0,$5F,$07,$84   ;C120DC
	.db $00
	jsl.l DisplayMessage
	.db $60,$A0,$60,$07,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C120EC
	.db $3A,$D0,$0A,$A0,$52,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$5A,$07   ;C120FC
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$56,$07,$84,$00,$22,$7E,$2B,$C6   ;C1210C  
	.db $A5,$00,$F0,$0A,$A0,$5E,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$57   ;C1211C  
	.db $07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$14,$7B,$A3,$03,$AA,$A9   ;C1212C  
	.db $08,$9F,$71,$88,$7E,$A0,$59,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$22   ;C1213C
	.db $05,$24,$C6,$AF,$70,$89,$7E,$48,$A9,$FF,$8F,$70,$89,$7E,$A9,$13   ;C1214C  
	.db $85,$00,$22,$84,$15,$C2,$A3,$04,$48,$48,$48,$A0,$1F,$09,$84,$00   ;C1215C  
	jsl.l DisplayMessage
	.db $20,$05,$22,$A0,$20,$09,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$20,$2B,$22,$68,$68,$68,$68,$8F,$70,$89,$7E,$A0   ;C1217C  
	.db $58,$07,$84,$00
	jsl.l DisplayMessage
	rts                                     ;C12194
	lda #$13                                ;C12195
	sta $00                                 ;C12197
	jsl $C210AC                             ;C12199
	ldy $00                                 ;C1219D
	iny                                     ;C1219F
	lda $05,s                               ;C121A0
	sta $00                                 ;C121A2
	sty $02                                 ;C121A4
	phy                                     ;C121A6
	jsl $C27951                             ;C121A7
	ply                                     ;C121AB
	sty $06                                 ;C121AC
	ldy #$1033                              ;C121AE
	sty $04                                 ;C121B1
	lda $05,s                               ;C121B3
	sta $00                                 ;C121B5
	lda #$50                                ;C121B7
	sta $01                                 ;C121B9
	lda #$0B                                ;C121BB
	sta $02                                 ;C121BD
	lda #$02                                ;C121BF
	sta $03                                 ;C121C1
	jsl $C626A0                             ;C121C3
	rts                                     ;C121C7
	lda $05,s                               ;C121C8
	sta $00                                 ;C121CA
	jsl $C210AC                             ;C121CC
	ldy $00                                 ;C121D0
	tyx                                     ;C121D2
	iny                                     ;C121D3
	iny                                     ;C121D4
	iny                                     ;C121D5
	lda $05,s                               ;C121D6
	sta $00                                 ;C121D8
	sty $02                                 ;C121DA
	phx                                     ;C121DC
	phy                                     ;C121DD
	jsl $C27951                             ;C121DE
	ply                                     ;C121E2
	plx                                     ;C121E3
	stx $04                                 ;C121E4
	sty $06                                 ;C121E6
	lda $05,s                               ;C121E8
	sta $00                                 ;C121EA
	lda #$50                                ;C121EC
	sta $01                                 ;C121EE
	lda #$0B                                ;C121F0
	sta $02                                 ;C121F2
	lda #$04                                ;C121F4
	sta $03                                 ;C121F6
	jsl $C626A0                             ;C121F8
	lda $05,s                               ;C121FC
	sta $00                                 ;C121FE
	jsl $C2159E                             ;C12200
	rts                                     ;C12204
	lda #$13                                ;C12205
	sta $00                                 ;C12207
	jsl $C210AC                             ;C12209
	ldx $00                                 ;C1220D
	lda $05,s                               ;C1220F
	sta $00                                 ;C12211
	phx                                     ;C12213
	jsl $C210AC                             ;C12214
	plx                                     ;C12218
	stx $02                                 ;C12219
	rep #$20                                ;C1221B
	lda $00                                 ;C1221D
	asl a                                   ;C1221F
	sec                                     ;C12220
	sbc $02                                 ;C12221
	tay                                     ;C12223
	sep #$20                                ;C12224
	ldx $00                                 ;C12226
	jmp $21D6                               ;C12228
	lda $05,s                               ;C1222B
	sta $00                                 ;C1222D
	jsl $C2785E                             ;C1222F
	ldy $04                                 ;C12233
	sty $02                                 ;C12235
	lda $05,s                               ;C12237
	sta $00                                 ;C12239
	jsl $C27951                             ;C1223B
	jsl $C62428                             ;C1223F
	rts                                     ;C12243

func_C12244:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp06,s
	sta.b wTemp00
	ldy.b #$15
	sty.b wTemp02
	jsl.l func_C62550
	lda.w #$0004
@lbl_C12258:
	pha
	lda.b w0008,s
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp00
	pha
	jsl.l func_C36410
	lda.b wTemp00
	pha
	bpl @lbl_C1227B
@lbl_C1226D:
	.db $68,$68,$68,$48,$22,$CE,$25,$C6   ;C1226D
	.db $68,$3A,$10,$F7,$28,$60           ;C12275
@lbl_C1227B:
	lda.b wTemp05,s
	sta.b wTemp00
	jsr.w func_C122CA
	ldx.b wTemp00
	bmi @lbl_C1226D
	ldy.b #$42
	jsr.w func_C122A5
	jsl.l func_C6253A
	lda.b wTemp01,s
	sta.b wTemp02
	stx.b wTemp00
	jsl.l func_C330DA
	jsl.l func_C62545
	pla
	pla
	pla
	dec a
	bpl @lbl_C12258
	plp
	rts

func_C122A5:
	phy
	stx.b wTemp00
	phx
	jsl.l func_C30710
	plx
	ldy.b wTemp00
	stx.b wTemp00
	sty.b wTemp01
	ply
	sty.b wTemp02
	ldy.b #$02
	sty.b wTemp03
	lda.b wTemp05,s
	sta.b wTemp04
	lda.b wTemp03,s
	sta.b wTemp06
	phx
	jsl.l func_C626CA
	plx
	rts

func_C122CA:
	php
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l DATA8_C122EB,x
	sta.b wTemp00
	jsl.l func_C3035D
	ldx.b wTemp00
	bmi @lbl_C122E7
	lda.b #$01
	sta.b wTemp01
	phx
	jsl.l func_C33A92
	plx
@lbl_C122E7:
	stx.b wTemp00
	plp
	rts

DATA8_C122EB:
	.db $57,$2C,$7D,$B4,$AF               ;C122EB
	.db $02,$02,$02,$02,$10,$FF,$06,$06,$06,$06,$FF,$06,$06,$06,$FF,$06   ;C122F0
	.db $FF,$02,$02,$02,$10,$FF,$04,$04   ;C12300  
	.db $04,$FF,$00,$00,$00,$00,$FF       ;C12308  
	.db $05,$03,$04,$06,$06,$00,$FF,$00   ;C1230F
	.db $07,$10,$FF,$03,$04,$17,$FF       ;C12317
	.db $E2,$20,$C2,$10,$DA,$A9,$09,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA   ;C1231E
	.db $C9,$08,$D0,$03,$4C,$DD,$23,$8A,$85,$00,$22,$1B,$72,$C2,$A9,$06   ;C1232E
	.db $85,$00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$0A,$A0,$26,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$02,$B0,$0A,$A0,$36,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$03,$B0,$23,$A9,$86,$85,$00
	jsl.l _GetEvent
	.db $A5,$00   ;C1235E  
	.db $C9,$03,$B0,$0A,$A0,$3E,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$44   ;C1236E
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $60,$60,$C9,$04,$B0,$22,$A9,$86,$85   ;C1237E  
	.db $00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$03,$B0,$0A,$A0,$40,$07,$84,$00   ;C1238E
	jsl.l DisplayMessage
	.db $60,$A0,$44,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9   ;C1239E  
	.db $05,$B0,$22,$A9,$86,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$03,$B0   ;C123AE  
	.db $0A,$A0,$45,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$44,$07,$84,$00   ;C123BE
	jsl.l DisplayMessage
	.db $60,$A0,$46,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$8A   ;C123CE  
	.db $85,$00,$22,$1B,$72,$C2,$A0,$83,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C123DE  


	sep #$20 ;A->8
	rep #$10 ;XY->16
	GetEvent Event_Gaibara
	cmp.b #$03
	bcs @lbl_C1240A
	ldy.w #$06B7
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C1240A:
	.db $A9,$87,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$02,$B0,$2F,$A9,$08   ;C1240A
	.db $85,$00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$16,$A0,$61,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$87,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60   ;C1242A  
	.db $A0,$67,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$80,$19,$C9,$03,$B0   ;C1243A
	.db $0A,$A0,$62,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$65,$07,$84,$00   ;C1244A
	.db $22,$7E,$2B,$C6,$A5,$00,$F0,$0A,$A0,$66,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A9,$00,$48,$A2,$00,$00,$80,$1F,$85,$00,$DA,$22,$10,$07   ;C1246A  
	.db $C3,$FA,$A5,$00,$C9,$0B,$D0,$10,$A9,$01,$83,$01,$BF,$4F,$89,$7E   ;C1247A  
	.db $85,$00,$DA,$22,$92,$01,$C3,$FA,$E8,$BF,$4F,$89,$7E,$10,$DB,$68   ;C1248A  
	.db $F0,$0A,$A0,$23,$09,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$5C,$00,$84   ;C1249A  
	.db $00
	jsl.l DisplayMessage
	.db $60           ;C124AA


	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	pha
	jsr.w func_C124BB
	pla
	rts

func_C124BB:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	cmp.b #$02
	bcc @lbl_C124CA
;C124C7  
	.db $4C,$B4,$25
@lbl_C124CA:
	phx
	GetEvent Event_Naoki_88
	cmp.b #$02
	bcs @lbl_C1251A
	plx
	lda.b #$82
	sta.b wTemp00
	stz.b wTemp01
	stz.b wTemp02
	jsl.l func_C30295
	lda.b wTemp00
	bmi @lbl_C12510
	pha
	ldy.w #$0768
	sty.b wTemp00
	jsl.l DisplayMessage
	pla
	sta.b wTemp00
	pha
	jsl.l func_C30192
	pla
	sta.b wTemp00
	jsl.l func_C10157
	SetEvent Event_Naoki_88 $02
	rts
@lbl_C12510:
	.db $A0,$5C,$00,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C12518  
@lbl_C1251A:
	cmp.b #$03
	bcc @lbl_C12521
;C1251E  
	.db $4C,$A9,$25
@lbl_C12521:
	jsr.w func_C12ABD
	bcs @lbl_C12531
	plx
	ldy.w #$0769
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C12531:
	ldy.w #$076A
	sty.b wTemp00
	jsl.l DisplayMessage
	plx
	stx.b wTemp00
	lda.b #$81
	sta.b wTemp02
	jsl.l func_C62550
	SetEvent Event_Naoki_88 $03
	SetEvent Event_Naoki $01
	ldy.w #$076B
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C12574
	.db $A0,$6D,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C12572  
@lbl_C12574:
	lda.b #$03
	sta.b wTemp00
	jsl.l func_C232BF
	lda.b #$13
	sta.b wTemp00
	ldy.w #$0005
	sty.b wTemp02
	jsl.l func_C2323C
	ldy.w #$2710
	sty.b wTemp00
	jsl.l func_C233BE
	ldy.w #$076E
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	ldy.w #$076F
	sty.b wTemp00
	jsl.l DisplayMessage
	rts


	.db $FA,$A0,$70,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$03,$B0,$5E,$A9   ;C125A9
	.db $88,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$02,$B0,$43,$A0,$8C,$07   ;C125B9
	.db $84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$16,$A0,$8D,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$88,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60   ;C125D9  
	.db $A0,$8F,$07,$84,$00
	jsl.l DisplayMessage
	.db $7B,$A3,$03,$AA,$A9,$03,$9F   ;C125E9
	.db $71,$88,$7E,$A9,$88,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $60   ;C125F9  
	.db $A0,$8E,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$80,$BB,$C9,$04,$B0   ;C12609
	.db $0A,$A0,$90,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$05,$90,$03,$4C   ;C12619
	.db $CF,$29,$A9,$88,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$02,$B0,$44   ;C12629  
	.db $A9,$13,$85,$00,$A9,$00,$85,$01,$22,$38,$72,$C2,$A0,$97,$07,$84   ;C12639
	.db $00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$71,$2A   ;C12649
	.db $84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$85,$00,$A0,$38   ;C12659  
	.db $03,$84,$02,$22,$51,$79,$C2,$A9,$88,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	rts                                     ;C1267C
	cmp #$03                                ;C1267D
	bcc @lbl_C12684                         ;C1267F
	jmp $287E                               ;C12681
@lbl_C12684:
	lda #$13                                ;C12684
	sta $00                                 ;C12686
	jsl $C210AC                             ;C12688
	lda $01                                 ;C1268C
	cmp #$06                                ;C1268E
	beq @lbl_C126BA                         ;C12690
	bcc @lbl_C126A7                         ;C12692
	lda #$13                                ;C12694
	sta $00                                 ;C12696
	ldy #$2A77                              ;C12698
	sty $02                                 ;C1269B
	lda #$C1                                ;C1269D
	sta $04                                 ;C1269F
	jsl $C2938C                             ;C126A1
	bra @lbl_C12684                         ;C126A5
@lbl_C126A7:
	lda #$13                                ;C126A7
	sta $00                                 ;C126A9
	ldy #$2A79                              ;C126AB
	sty $02                                 ;C126AE
	lda #$C1                                ;C126B0
	sta $04                                 ;C126B2
	jsl $C2938C                             ;C126B4
	bra @lbl_C12684                         ;C126B8
@lbl_C126BA:
	lda #$13                                ;C126BA
	sta $00                                 ;C126BC
	lda #$00                                ;C126BE
	sta $01                                 ;C126C0
	jsl $C27238                             ;C126C2
	jsl $C62405                             ;C126C6
	lda $03,s                               ;C126CA
	sta $00                                 ;C126CC
	ldy #$2A7B                              ;C126CE
	sty $02                                 ;C126D1
	lda #$C1                                ;C126D3
	sta $04                                 ;C126D5
	jsl $C2938C                             ;C126D7
	ldy #$079A                              ;C126DB
	sty $00                                 ;C126DE
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3   ;C126D9  
	.db $03,$1A,$1A,$1A,$85,$00,$A0,$81,$2A,$84,$02,$A9,$C1,$85,$04,$22   ;C126E9  
	.db $8C,$93,$C2,$A3,$03,$1A,$85,$00,$A0,$88,$2A,$84,$02,$A9,$C1,$85   ;C126F9  
	.db $04,$22,$8C,$93,$C2,$A3,$03,$1A,$1A,$85,$00,$A0,$8E,$2A,$84,$02   ;C12709  
	.db $A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$9B,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$9C,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$9D,$07,$84,$00,$22   ;C12729  
	.db $7E,$2B,$C6,$A5,$00,$F0,$0D,$A0,$9F,$07,$84,$00,$22,$7E,$2B,$C6   ;C12739  
	.db $A5,$00,$80,$F1,$A3,$03,$85,$00,$A9,$04,$85,$01,$22,$38,$72,$C2   ;C12749  
	.db $A0,$A0,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$0D,$A0,$A1,$07   ;C12759
	.db $84,$00,$22,$7E,$2B,$C6,$A5,$00,$80,$CB,$A0,$A2,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$1A,$1A,$1A,$85,$00,$A0,$93   ;C12779  
	.db $2A,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$1A,$85,$00   ;C12789
	.db $A0,$97,$2A,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$1A   ;C12799
	.db $1A,$85,$00,$A0,$9C,$2A,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2   ;C127A9
	.db $A0,$A3,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$A4,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$A5,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$A6,$07,$84,$00   ;C127C9  
	jsl.l DisplayMessage
	jsl $C62405                             ;C127DD
	lda $03,s                               ;C127E1
	sta $00                                 ;C127E3
	ldy #$2AA0                              ;C127E5
	sty $02                                 ;C127E8
	lda #$C1                                ;C127EA
	sta $04                                 ;C127EC
	jsl $C2938C                             ;C127EE
	lda $03,s                               ;C127F2
	inc a                                   ;C127F4
	inc a                                   ;C127F5
	sta $00                                 ;C127F6
	ldy #$2AA6                              ;C127F8
	sty $02                                 ;C127FB
	lda #$C1                                ;C127FD
	sta $04                                 ;C127FF
	jsl $C2938C                             ;C12801
	lda $03,s                               ;C12805
	inc a                                   ;C12807
	sta $00                                 ;C12808
	ldy #$2AAD                              ;C1280A
	sty $02                                 ;C1280D
	lda #$C1                                ;C1280F
	sta $04                                 ;C12811
	jsl $C2938C                             ;C12813
	lda $03,s                               ;C12817
	inc a                                   ;C12819
	inc a                                   ;C1281A
	inc a                                   ;C1281B
	sta $00                                 ;C1281C
	ldy #$2AB5                              ;C1281E
	sty $02                                 ;C12821
	lda #$C1                                ;C12823
	sta $04                                 ;C12825
	jsl $C2938C                             ;C12827
	lda $03,s                               ;C1282B
	sta $00                                 ;C1282D
	ldy #$071E                              ;C1282F
	sty $02                                 ;C12832
	jsl $C27951                             ;C12834
	lda $03,s                               ;C12838
	inc a                                   ;C1283A
	sta $00                                 ;C1283B
	ldy #$071C                              ;C1283D
	sty $02                                 ;C12840
	jsl $C27951                             ;C12842
	lda $03,s                               ;C12846
	inc a                                   ;C12848
	inc a                                   ;C12849
	sta $00                                 ;C1284A
	ldy #$0C1D                              ;C1284C
	sty $02                                 ;C1284F
	jsl $C27951                             ;C12851
	lda $03,s                               ;C12855
	inc a                                   ;C12857
	inc a                                   ;C12858
	inc a                                   ;C12859
	sta $00                                 ;C1285A
	ldy #$0619                              ;C1285C
	sty $02                                 ;C1285F
	jsl $C27951                             ;C12861
	lda #$88                                ;C12865
	sta $00                                 ;C12867
	lda #$03                                ;C12869
	sta $02                                 ;C1286B
	jsl.l _SetEvent
	.db $A9,$09,$85,$00,$A9,$05,$85,$02   ;C12869
	jsl.l _SetEvent
	.db $60,$A9,$0B,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$48   ;C12879  
	.db $A9,$0A,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$48,$7A,$C0,$10,$27,$90   ;C12889
	.db $0A,$A0,$AF,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$AA,$07,$84,$00   ;C12899
	.db $22,$7E,$2B,$C6,$A5,$00,$F0,$3D,$C9,$01,$F0,$2D,$A9,$0B,$85,$00   ;C128A9  
	jsl.l _GetEvent
	.db $A5,$00,$48,$A9,$0A,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C128B9  
	.db $00,$48,$C2,$20,$A9,$10,$27,$38,$E3,$01,$85,$02,$68,$E2,$20,$A0   ;C128C9
	.db $AC,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$22,$67,$11,$C2,$46,$04,$66   ;C128D9  
	.db $03,$66,$02,$80,$04,$22,$67,$11,$C2,$A5,$04,$D0,$09,$A4,$02,$F0   ;C128E9  
	.db $BB,$C0,$10,$27,$90,$03,$A0,$10,$27,$5A,$A9,$0B,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$48,$A9,$0A,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$48   ;C12909  
	.db $C2,$20,$A3,$01,$18,$63,$03,$B0,$58,$C9,$10,$27,$B0,$53,$83,$01   ;C12919
	.db $A3,$03,$85,$00,$64,$02,$22,$B7,$5B,$C2,$22,$05,$24,$C6,$A3,$03   ;C12929  
	.db $85,$02,$A0,$AD,$07,$84,$00
	jsl.l DisplayMessage
	.db $E2,$20,$A9,$0A,$85   ;C12939  
	.db $00,$A3,$01,$85,$02
	jsl.l _SetEvent
	.db $A9,$0B,$85,$00,$A3,$02,$85   ;C12949
	.db $02
	jsl.l _SetEvent
	.db $C2,$20,$A9,$10,$27,$38,$E3,$01,$85,$04,$A3   ;C12959
	.db $03,$85,$02,$E2,$20,$7A,$7A,$A0,$AE,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C2,$20,$A9,$10,$27,$38,$E3,$01,$83,$03,$85,$00,$64,$02,$22   ;C12979
	.db $B7,$5B,$C2,$22,$05,$24,$C6,$A3,$03,$85,$02,$E2,$20,$A0,$AD,$07   ;C12989  
	.db $84,$00
	jsl.l DisplayMessage
	.db $7A,$7A,$A0,$AF,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$0A,$85,$00,$A9,$10,$85,$02
	jsl.l _SetEvent
	.db $A9,$0B,$85   ;C129A9  
	.db $00,$A9,$27,$85,$02
	jsl.l _SetEvent
	.db $A9,$09,$85,$00,$A9,$06,$85   ;C129B9
	.db $02
	jsl.l _SetEvent
	.db $60,$C9,$08,$B0,$34,$A9,$0B,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$48,$A9,$0A,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$48   ;C129D9  
	.db $7A,$C0,$10,$27,$90,$0A,$A0,$AF,$07,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C129E9
	.db $A0,$B5,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$4C,$AF,$28,$A0,$84   ;C129F9
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$E0,$85,$00,$A9,$1E,$85,$01,$A9   ;C12A09
	.db $01,$85,$02,$22,$95,$02,$C3,$A5,$00,$30,$04,$22,$57,$01,$C1,$22   ;C12A19  
	.db $37,$24,$C6,$A9,$09,$85,$00,$A9,$0A,$85,$02
	jsl.l _SetEvent
	.db $A9   ;C12A29  
	.db $17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$09,$02,$85,$02,$A9,$17,$85   ;C12A39  
	.db $00
	jsl.l _SetEvent
	.db $A9,$8C,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $22,$71,$27,$C6,$85,$02,$A9,$90,$85,$00
	jsl.l _SetEvent
	.db $A0   ;C12A59  
	.db $0A,$01,$84,$00,$22,$23,$2A,$C6,$00,$00,$00,$00,$00,$FF,$02,$FF   ;C12A69
	.db $06,$FF,$06,$06,$06,$04,$10,$FF,$06,$06,$06,$06,$04,$12,$FF,$06   ;C12A79  
	.db $06,$06,$06,$13,$FF,$06,$06,$06,$14,$FF,$04,$03,$10,$FF,$04,$04   ;C12A89  
	.db $04,$11,$FF,$05,$04,$12,$FF,$00,$02,$02,$02,$16,$FF,$00,$01,$02   ;C12A99  
	.db $02,$02,$16,$FF,$00,$00,$01,$02,$02,$02,$16,$FF,$07,$00,$01,$02   ;C12AA9
	.db $02,$02,$10,$FF                   ;C12AB9

func_C12ABD:
	ldx.w #$0000
	bra @lbl_C12AD7
@lbl_C12AC2:
	sta.b wTemp00
	phx
	jsl.l func_C30710
	plx
	lda.b wTemp01
	cmp.b #$E0
	bne @lbl_C12AD6
	lda.b wTemp02
	cmp.b #$01
	beq @lbl_C12ADF
@lbl_C12AD6:
	inx
@lbl_C12AD7:
	lda.l wShirenStatus.itemAmounts,x
	bpl @lbl_C12AC2
	clc
	rts
@lbl_C12ADF:
	lda.l wShirenStatus.itemAmounts,x
	stx.b wTemp00
	pha
	jsl.l RemoveItemFromCategoryShortcutSlots
	pla
	sta.b wTemp00
	jsl.l func_C306F4
	sec
	rts


	.db $E2,$20,$C2,$10,$8A,$48,$20,$FE,$2A,$68,$60,$E2,$20,$C2,$10,$A3   ;C12AF3
	.db $03,$85,$00,$DA,$22,$AC,$10,$C2,$FA,$DA,$22,$AF,$59,$C3,$FA,$A5   ;C12B03  
	.db $02,$C9,$02,$F0,$0A,$A0,$71,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$BF   ;C12B13
	.db $71,$88,$7E,$C9,$02,$90,$03,$4C,$F4,$2D,$A9,$88,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$F0,$0A,$A0,$8B,$07,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C12B33  
	.db $A3,$03,$85,$00,$85,$02,$A9,$02,$85,$01,$20,$1A,$68,$A0,$77,$07   ;C12B43  
	.db $84,$00
	jsl.l DisplayMessage
	.db $20,$C4,$2F,$22,$05,$24,$C6,$A3,$03,$1A   ;C12B53  
	.db $1A,$85,$00,$A0,$CD,$31,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2   ;C12B63
	.db $A0,$78,$07,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85   ;C12B73
	.db $00,$A0,$C9,$31,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$79   ;C12B83
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$1A,$85,$00,$A9,$03,$85,$01,$22,$38,$72   ;C12BA3  
	.db $C2,$A3,$03,$85,$00,$A9,$07,$85,$01,$22,$38,$72,$C2,$A0,$7A,$07   ;C12BB3
	.db $84,$00
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22   ;C12BC3  
	.db $05,$24,$C6,$A3,$03,$1A,$1A,$85,$00,$A9,$02,$85,$01,$22,$38,$72   ;C12BD3  
	.db $C2,$A3,$03,$85,$00,$A9,$06,$85,$01,$22,$38,$72,$C2,$A0,$7B,$07   ;C12BE3
	.db $84,$00
	jsl.l DisplayMessage
	.db $A3,$03,$1A,$85,$00,$A9,$06,$85,$01,$22   ;C12BF3  
	.db $38,$72,$C2,$A3,$03,$85,$00,$A9,$07,$85,$01,$22,$38,$72,$C2,$A3   ;C12C03
	.db $03,$1A,$1A,$85,$00,$A9,$07,$85,$01,$22,$38,$72,$C2,$A3,$03,$85   ;C12C13  
	.db $00,$A9,$07,$85,$01,$22,$38,$72,$C2,$A0,$7C,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C12C35
	lda #$13                                ;C12C39
	sta $00                                 ;C12C3B
	ldy #$31D2                              ;C12C3D
	sty $02                                 ;C12C40
	lda #$C1                                ;C12C42
	sta $04                                 ;C12C44
	jsl $C2938C                             ;C12C46
	lda $03,s                               ;C12C4A
	inc a                                   ;C12C4C
	sta $00                                 ;C12C4D
	ldy #$31D5                              ;C12C4F
	sty $02                                 ;C12C52
	lda #$C1                                ;C12C54
	sta $04                                 ;C12C56
	jsl $C2938C                             ;C12C58
@lbl_C12C5C:
	ldy #$077D                              ;C12C5C
	sty $00                                 ;C12C5F
	jsl $C62B7E                             ;C12C61
	lda $00                                 ;C12C65
	bmi @lbl_C12C5C                         ;C12C67
	bne @lbl_C12C7D                         ;C12C69
	ldy #$0785                              ;C12C6B
	phy                                     ;C12C6E
	ldy #$0782                              ;C12C6F
	phy                                     ;C12C72
	ldy #$077F                              ;C12C73
	phy                                     ;C12C76
	ldy #$FED4                              ;C12C77
	phy                                     ;C12C7A
	bra @lbl_C12CA2                         ;C12C7B
@lbl_C12C7D:
	dec a                                   ;C12C7D
	bne @lbl_C12C92                         ;C12C7E
	ldy #$0786                              ;C12C80
	phy                                     ;C12C83
	ldy #$0783                              ;C12C84
	phy                                     ;C12C87
	ldy #$0780                              ;C12C88
	phy                                     ;C12C8B
	ldy #$FE70                              ;C12C8C
	phy                                     ;C12C8F
	bra @lbl_C12CA2                         ;C12C90
@lbl_C12C92:
	ldy #$0787                              ;C12C92
	phy                                     ;C12C95
	ldy #$0784                              ;C12C96
	phy                                     ;C12C99
	ldy #$0781                              ;C12C9A
	phy                                     ;C12C9D
	ldy #$FE0C                              ;C12C9E
	phy                                     ;C12CA1
@lbl_C12CA2:
	ply                                     ;C12CA2
	sty $00                                 ;C12CA3
	ldy #$FFFF                              ;C12CA5
	sty $02                                 ;C12CA8
	jsl $C25BE0                             ;C12CAA
	ply                                     ;C12CAE
	sty $00                                 ;C12CAF
	jsl.l DisplayMessage
	jsl $C62405                             ;C12CB5
	lda $07,s                               ;C12CB9
	sta $00                                 ;C12CBB
	ldy #$31D8                              ;C12CBD
	sty $02                                 ;C12CC0
	lda #$C1                                ;C12CC2
	sta $04                                 ;C12CC4
	jsl $C2938C                             ;C12CC6
	lda $07,s                               ;C12CCA
	inc a                                   ;C12CCC
	inc a                                   ;C12CCD
	sta $00                                 ;C12CCE
	ldy #$31D8                              ;C12CD0
	sty $02                                 ;C12CD3
	lda #$C1                                ;C12CD5
	sta $04                                 ;C12CD7
	jsl $C2938C                             ;C12CD9
	lda $07,s                               ;C12CDD
	inc a                                   ;C12CDF
	sta $00                                 ;C12CE0
	ldy #$31DC                              ;C12CE2
	sty $02                                 ;C12CE5
	lda #$C1                                ;C12CE7
	sta $04                                 ;C12CE9
	jsl $C2938C                             ;C12CEB
	lda $07,s                               ;C12CEF
	sta $00                                 ;C12CF1
	jsl $C21591                             ;C12CF3
	jsl $C62405                             ;C12CF7
	lda $07,s                               ;C12CFB
	sta $00                                 ;C12CFD
	ldy #$31E1                              ;C12CFF
	sty $02                                 ;C12D02
	lda #$C1                                ;C12D04
	sta $04                                 ;C12D06
	jsl $C2938C                             ;C12D08
	ply                                     ;C12D0C
	sty $00                                 ;C12D0D
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$05,$85   ;C12D13
	.db $00,$A0,$E7,$31,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$7A,$84   ;C12D23
	.db $00
	jsl.l DisplayMessage
	.db $A9,$FD,$85,$00,$22,$71,$32,$C2,$A9,$13,$85   ;C12D33
	.db $00,$A0,$F6,$FF,$84,$02,$22,$3C,$32,$C2,$A0,$F0,$D8,$84,$00,$22   ;C12D43
	.db $BE,$33,$C2,$A0,$64,$00,$84,$00,$22,$BE,$33,$C2,$A0,$88,$07,$84   ;C12D53  
	.db $00
	jsl.l DisplayMessage
	.db $A0,$89,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2F   ;C12D63
	.db $01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A9,$13,$85,$00,$A0   ;C12D73  
	.db $EC,$31,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0,$8A,$07,$84   ;C12D83  
	.db $00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$85,$00,$A0,$EF,$31   ;C12D93
	.db $84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$1A,$85,$00,$A0   ;C12DA3  
	.db $F4,$31,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A3,$03,$1A,$1A   ;C12DB3  
	.db $85,$00,$A0,$F4,$31,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A0   ;C12DC3  
	.db $8B,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$88,$85,$00,$A9,$01,$85,$02   ;C12DD3
	jsl.l _SetEvent
	.db $A9,$09,$85,$00,$A9,$02,$85,$02
	jsl.l _SetEvent
	.db $60,$C9,$04,$B0,$0A,$A0,$95,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9   ;C12DF3
	.db $05,$B0,$0A,$A0,$A7,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$06,$B0   ;C12E03  
	.db $0A,$A0,$B1,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$07,$B0,$54,$A9   ;C12E13
	.db $09,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$07,$F0,$3C,$A9,$82,$85   ;C12E23
	.db $00,$22,$5D,$03,$C3,$A5,$00,$30,$26,$48,$A0,$C1,$07,$84,$00
	jsl.l DisplayMessage
	.db $68,$85,$00,$48,$22,$92,$01,$C3,$68,$85,$00,$22,$57   ;C12E43  
	.db $01,$C1,$A9,$09,$85,$00,$A9,$07,$85,$02
	jsl.l _SetEvent
	.db $60,$A0   ;C12E53  
	.db $5C,$00,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$C2,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$0A,$B0,$22,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C12E73  
	.db $00,$89,$01,$D0,$0A,$A0,$C9,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0   ;C12E83
	.db $DC,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$85,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$BF,$71,$88,$7E,$C9,$02,$B0,$0A,$A0   ;C12EA3  
	.db $8B,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$04,$B0,$0A,$A0,$96,$07   ;C12EB3
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$05,$B0,$0A,$A0,$A8,$07,$84,$00   ;C12EC3  
	jsl.l DisplayMessage
	.db $60,$C9,$06,$B0,$0A,$A0,$B0,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$07,$B0,$2C,$A9,$88,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C12EE3  
	.db $00,$D0,$16,$A0,$C0,$07,$84,$00
	jsl.l DisplayMessage
	.db $A9,$88,$85,$00   ;C12EF3
	.db $A9,$01,$85,$02
	jsl.l _SetEvent
	.db $60,$A0,$C3,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$0A,$B0,$22,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C12F13  
	.db $00,$89,$01,$D0,$0A,$A0,$C8,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0   ;C12F23
	.db $DD,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$86,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$BF,$71,$88,$7E,$C9,$02,$B0,$0A,$A0   ;C12F43  
	.db $8B,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$04,$B0,$0A,$A0,$94,$07   ;C12F53
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$05,$B0,$0A,$A0,$A9,$07,$84,$00   ;C12F63  
	jsl.l DisplayMessage
	.db $60,$C9,$06,$B0,$0A,$A0,$B2,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$07,$B0,$0A,$A0,$C4,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$0A,$B0,$22,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$89   ;C12F93
	.db $01,$D0,$0A,$A0,$CA,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$DE,$08   ;C12FA3  
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$87,$08,$84,$00
	jsl.l DisplayMessage
	rts                                     ;C12FC3
	lda $05,s                               ;C12FC4
	inc a                                   ;C12FC6
	sta $00                                 ;C12FC7
	jsl $C210AC                             ;C12FC9
	ldx $00                                 ;C12FCD
	inc $01                                 ;C12FCF
	inc $01                                 ;C12FD1
	inc $01                                 ;C12FD3
	ldy $00                                 ;C12FD5
	lda $05,s                               ;C12FD7
	inc a                                   ;C12FD9
	sta $00                                 ;C12FDA
	sty $02                                 ;C12FDC
	phx                                     ;C12FDE
	phy                                     ;C12FDF
	jsl $C27951                             ;C12FE0
	ply                                     ;C12FE4
	plx                                     ;C12FE5
	stx $04                                 ;C12FE6
	sty $06                                 ;C12FE8
	lda $05,s                               ;C12FEA
	inc a                                   ;C12FEC
	sta $00                                 ;C12FED
	lda #$50                                ;C12FEF
	sta $01                                 ;C12FF1
	lda #$0B                                ;C12FF3
	sta $02                                 ;C12FF5
	lda #$04                                ;C12FF7
	sta $03                                 ;C12FF9
	jsl $C626A0                             ;C12FFB
	lda $05,s                               ;C12FFF
	inc a                                   ;C13001
	sta $00                                 ;C13002
	jsl $C2159E                             ;C13004
	rts                                     ;C13008
	sep #$20                                ;C13009
	rep #$10                                ;C1300B
	lda $7E8871,x                           ;C1300D
	cmp #$02                                ;C13011
	.db $B0,$11   ;C13013
	txa                                     ;C13015
	sta $00                                 ;C13016
	jsl $C2721B                             ;C13018
	ldy #$0772                              ;C1301C
	sty $00                                 ;C1301F
	jsl.l DisplayMessage
	.db $60,$C9,$06,$B0,$0A,$A0,$91,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$07,$B0,$11,$8A,$85,$00,$22,$1B,$72,$C2,$A0,$B8,$07,$84   ;C13033
	.db $00
	jsl.l DisplayMessage
	.db $60,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5   ;C13043
	.db $00,$FA,$89,$01,$F0,$0A,$A0,$F9,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C13053
	.db $A0,$C5,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$BF,$71   ;C13063
	.db $88,$7E,$C9,$02,$B0,$11,$8A,$85,$00,$22,$1B,$72,$C2,$A0,$73,$07   ;C13073
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$06,$B0,$0A,$A0,$92,$07,$84,$00   ;C13083  
	jsl.l DisplayMessage
	.db $60,$C9,$07,$B0,$11,$8A,$85,$00,$22,$1B,$72,$C2   ;C13093  
	.db $A0,$B9,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$FA,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$C6,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C130C3  
	.db $C2,$10,$BF,$71,$88,$7E,$C9,$02,$B0,$11,$8A,$85,$00,$22,$1B,$72   ;C130D3
	.db $C2,$A0,$74,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$06,$B0,$0A,$A0   ;C130E3
	.db $93,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$07,$B0,$11,$8A,$85,$00   ;C130F3  
	.db $22,$1B,$72,$C2,$A0,$BA,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$DA,$A9   ;C13103  
	.db $17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$FB   ;C13113  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$C7,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$8A,$48,$20,$40,$31,$68,$60,$E2,$20,$C2   ;C13133  
	.db $10,$BF,$71,$88,$7E,$C9,$04,$B0,$11,$8A,$85,$00,$22,$1B,$72,$C2   ;C13143  
	.db $A0,$75,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$05,$B0,$1B,$BF,$72   ;C13153
	.db $88,$7E,$D0,$15,$E8,$8A,$83,$03,$3A,$85,$00,$85,$02,$A9,$01,$85   ;C13163
	.db $01,$DA,$20,$1A,$68,$FA,$4C,$A4,$31,$A0,$99,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$8A,$48,$20,$91,$31,$68,$60,$E2,$20   ;C13183  
	.db $C2,$10,$8A,$85,$02,$3A,$85,$00,$A9,$01,$85,$01,$DA,$20,$1A,$68   ;C13193
	.db $FA,$A9,$01,$9F,$71,$88,$7E,$A0,$98,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C131B3
	lda $03,s                               ;C131B7
	sta $00                                 ;C131B9
	ldy #$31DC                              ;C131BB
	sty $02                                 ;C131BE
	lda #$C1                                ;C131C0
	sta $04                                 ;C131C2
	jsl $C2938C                             ;C131C4
	rts                                     ;C131C8
	asl $06                                 ;C131C9
	asl $FF                                 ;C131CB
	asl $06                                 ;C131CD
	asl $10                                 ;C131CF
	sbc $FF1200,x                           ;C131D1
	asl $10                                 ;C131D5
	sbc $020202,x                           ;C131D7
	sbc $020202,x                           ;C131DB
	.db $02   ;C131DF
	sbc $060606,x                           ;C131E0
	ora [$10]                               ;C131E4
	sbc $020203,x                           ;C131E6
	.db $02   ;C131EA
	sbc $FF1604,x                           ;C131EB
	ora [$06]                               ;C131EF
	asl $06                                 ;C131F1
	sbc $060605,x                           ;C131F3
	ora [$FF],y                             ;C131F7
	asl $06                                 ;C131F9
	asl $06                                 ;C131FB
	asl $FF                                 ;C131FD
	tsb $10                                 ;C131FF
	.db $FF   ;C13201


	sep #$20 ;A->8
	rep #$10 ;XY->16
	stx.b wTemp00
	stz.b wTemp01
	stx.b wTemp02
	jsr.w func_C1681A
	ldy.w #$01F4
	jsr.w NPCScriptFunction_C15BB6
	bcs @lbl_C13222
	.db $A0,$E8,$03,$20,$D3,$5B,$B0,$03   ;C13217
	.db $A0,$D0,$07                       ;C1321F
@lbl_C13222:
	phy
	jsr.w func_C13228
	ply
	rts

func_C13228:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	rep #$20 ;A->16
	lda.b wTemp03,s
	sta.b wTemp02
	sep #$20 ;A->8
	ldy.w #$07CB
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C1324B
	.db $A0,$CD,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13249  
@lbl_C1324B:
	rep #$20 ;A->16
	lda.b wTemp03,s
	sta.b wTemp00
	sep #$20 ;A->8
	ldy.w #$0000
	sty.b wTemp02
	jsl.l func_C25BB7
	lda.b wTemp00
	beq @lbl_C1326A
	.db $A0,$CE,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13268  
@lbl_C1326A:
	jsl.l func_C62405
	ldy.w #$0050
	sty.b wTemp00
	jsl.l func_C62B19
	ldy.w #$2710
	sty.b wTemp00
	jsl.l func_C233BE
	lda.b #$63
	sta.b wTemp00
	jsl.l func_C23271
	lda.b #$13
	pha
	bra @lbl_C132A6
@lbl_C1328D:
	pha
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C21128
	lda.b wTemp00
	beq @lbl_C132DB
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C24373
	lda.b wTemp00
	bpl @lbl_C132DB
@lbl_C132A6:
	lda.b wTemp01,s
	sta.b wTemp00
	ldy.w #$00FA
	sty.b wTemp02
	jsl.l func_C23209
	lda.b wTemp01,s
	sta.b wTemp00
	stz.b wTemp01
	jsl.l func_C23FFF
	lda.b wTemp01,s
	sta.b wTemp00
	stz.b wTemp01
	jsl.l func_C240A7
	lda.b wTemp01,s
	sta.b wTemp00
	stz.b wTemp01
	jsl.l func_C24073
	lda.b wTemp01,s
	sta.b wTemp00
	stz.b wTemp01
	jsl.l func_C24080
@lbl_C132DB:
	pla
	dec a
	bpl @lbl_C1328D
	lda.b #$13
	sta.b wTemp00
	lda.b #$19
	sta.b wTemp02
	jsl.l func_C626F6
	jsl.l func_C62405
	ldy.w #$07CF
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	pha
	jsr.w func_C13304
	pla
	rts

func_C13304:
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	stx.b wTemp00
	stz.b wTemp01
	stx.b wTemp02
	jsr.w func_C1681A
	plx
	stx.b wTemp00
	jsl.l func_C277F8
	lda.b wTemp01
	dec a
	cmp.b #$03
	bcs @lbl_C1332A
	.db $A0,$DC,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13328  
@lbl_C1332A:
	tdc
	lda.b wTemp03,s
	tax
	lda.l wCharEventFlags,x
	beq @lbl_C1333E
	ldy.w #$07EA
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C1333E:
	jsr.w NPCScriptFunction_C15B99
	lda.b #$5A
	bcs @lbl_C13347
	lda.b #$5B
@lbl_C13347:
	sta.b wTemp06
	jsl.l func_C6051F
	lda.b wTemp00
	cmp.b #$FF
	beq @lbl_C1339B
	.db $22,$71,$06,$C3,$A5,$00,$30,$40,$48,$85,$00,$22,$92,$01,$C3,$A3   ;C13353  
	.db $01,$85,$02,$85,$03,$A0,$E9,$07,$84,$00
	jsl.l DisplayMessage
	.db $68,$85   ;C13363  
	.db $00,$22,$57,$01,$C1,$7B,$A3,$03,$AA,$A9,$01,$9F,$71,$88,$7E,$20   ;C13373
	.db $99,$5B,$A9,$5A,$B0,$02,$A9,$5B,$85,$06,$A0,$FF,$FF,$84,$00,$84   ;C13383  
	.db $02,$84,$04,$22,$4A,$05,$C6,$60   ;C13393
@lbl_C1339B:
	ldy.w #$07D0
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C133B2
	.db $A0,$D2,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C133B0  
@lbl_C133B2:
	ldy.w #$03E8
	sty.b wTemp00
	ldy.w #$0000
	sty.b wTemp02
	jsl.l func_C25BB7
	lda.b wTemp00
	beq @lbl_C133CE
	.db $A0,$D3,$07,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C133CC  
@lbl_C133CE:
	jsl.l func_C62405
	ldy.w #$0050
	sty.b wTemp00
	jsl.l func_C62B19
@lbl_C133DB:
	ldy.w #$07D4
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	bpl @lbl_C13404
	ldy.w #$03E8
	sty.b wTemp00
	ldy.w #$0000
	sty.b wTemp02
	jsl.l func_C25BE0
	jsl.l func_C62405
	ldy.w #$07D7
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13404:
	tdc
	lda.b wTemp00
	tax
	lda.l wShirenStatus.itemAmounts,x
	phx
	sta.b wTemp00
	jsl.l func_C30710
	lda.b wTemp02
	cmp.b #$63
	bne @lbl_C1341F
;C13419  
	.db $A5,$01,$C9,$1C,$F0,$18
@lbl_C1341F:
	lda.b wTemp00
	cmp.b #$03
	beq @lbl_C13437
	plx
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp02
	ldy.w #$07D5
	sty.b wTemp00
	jsl.l DisplayMessage
	bra @lbl_C133DB
@lbl_C13437:
	lda.b wTemp01
	cmp.b #$00
	beq @lbl_C1344D
	cmp.b #$16
	beq @lbl_C1344D
	cmp.b #$19
	beq @lbl_C1344D
	cmp.b #$24
	beq @lbl_C1344D
	cmp.b #$1B
	bne @lbl_C13460
@lbl_C1344D:
	plx
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp02
	ldy.w #$07D6
	sty.b wTemp00
	jsl.l DisplayMessage
	jmp.w @lbl_C133DB
@lbl_C13460:
	plx
	stx.b wTemp00
	lda.l wShirenStatus.itemAmounts,x
	pha
	jsl.l RemoveItemFromCategoryShortcutSlots
	lda.b wTemp00
	bne @lbl_C13474
;C13470
	.db $68,$4C,$DB,$33
@lbl_C13474:
	tdc
	lda.b wTemp04,s
	tax
	lda.b #$01
	sta.l wCharEventFlags,x
	GetEvent Event17
	bit.b #$01
	beq @lbl_C1349D
	.db $A3,$01,$85,$00,$22,$10,$07,$C3,$A5,$01,$C9,$08,$D0,$03,$4C,$19   ;C1348C  
	.db $37                               ;C1349C  
@lbl_C1349D:
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C30710
	lda.b wTemp02
	cmp.b #$63
	bne @lbl_C134C2
	.db $A5,$01,$C9,$03,$D0,$03,$4C,$62,$35,$C9,$06,$D0,$03,$4C,$E1,$35   ;C134AB  
	.db $C9,$1C,$D0,$03,$4C,$9A,$36       ;C134BB
@lbl_C134C2:
	lda.b wTemp01,s
	sta.b wTemp02
	ldy.w #$07D8
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	lda.b wTemp04,s
	sta.b wTemp00
	ldy.w #$37C2
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	ldy.w #$00C4
	sty.b wTemp00
	jsl.l func_C62B19
	ldy.w #$0032
	sty.b wTemp00
	jsl.l func_C600C7
	lda.b wTemp04,s
	sta.b wTemp00
	ldy.w #$37C9
	sty.b wTemp02
	lda.b #$C1
	sta.b wTemp04
	jsl.l func_C2938C
	lda.b wTemp04,s
	sta.b wTemp00
	jsl.l func_C2721B
	jsl.l Random
	lda.b wTemp00
	cmp.b #$10
	bcc @lbl_C1353F
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C30659
	ldy.w #$07D9
	sty.b wTemp00
	jsl.l DisplayMessage
	lda.b wTemp01,s
	sta.b wTemp00
	jsl.l func_C10157
	pla
	sta.b wTemp02
	ldy.w #$07DA
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C1353F:
	.db $A3,$01,$85,$00,$22,$59,$06,$C3,$A3,$01,$85,$00,$22,$59,$06,$C3   ;C1353F  
	.db $A3,$01,$85,$00,$22,$59,$06,$C3,$A0,$DB,$07,$84,$00
	jsl.l DisplayMessage
	.db $80,$C8,$A3,$01,$85,$02,$A0,$DD,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C1356F
	lda $04,s                               ;C13573
	sta $00                                 ;C13575
	ldy #$37C2                              ;C13577
	sty $02                                 ;C1357A
	lda #$C1                                ;C1357C
	sta $04                                 ;C1357E
	jsl $C2938C                             ;C13580
	ldy #$00C4                              ;C13584
	sty $00                                 ;C13587
	jsl $C62B19                             ;C13589
	ldy #$0032                              ;C1358D
	sty $00                                 ;C13590
	jsl $C600C7                             ;C13592
	lda $04,s                               ;C13596
	sta $00                                 ;C13598
	ldy #$37C9                              ;C1359A
	sty $02                                 ;C1359D
	lda #$C1                                ;C1359F
	sta $04                                 ;C135A1
	jsl $C2938C                             ;C135A3
	lda $04,s                               ;C135A7
	sta $00                                 ;C135A9
	jsl $C2721B                             ;C135AB
	lda $01,s                               ;C135AF
	sta $00                                 ;C135B1
	jsl $C306F4                             ;C135B3
	lda #$0E                                ;C135B7
	sta $00                                 ;C135B9
	jsl $C3035D                             ;C135BB
	lda $00                                 ;C135BF
	sta $01,s                               ;C135C1
	ldy #$07DE                              ;C135C3
	sty $00                                 ;C135C6
	jsl.l DisplayMessage
	.db $A3,$01,$85   ;C135BF  
	.db $00,$22,$57,$01,$C1,$68,$85,$02,$A0,$DA,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A3,$01,$85,$02,$A0,$DF,$07,$84,$00,$22,$7E,$2B,$C6,$A5   ;C135DF  
	.db $00,$F0,$2D,$68,$85,$00,$22,$57,$01,$C1,$7B,$A3,$03,$AA,$A9,$00   ;C135EF
	.db $9F,$71,$88,$7E,$A0,$E8,$03,$84,$00,$A0,$00,$00,$84,$02,$22,$E0   ;C135FF  
	.db $5B,$C2,$22,$05,$24,$C6,$A0,$E0,$07,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C1360F
	.db $A0,$E2,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C13628
	lda $04,s                               ;C1362C
	sta $00                                 ;C1362E
	ldy #$37C2                              ;C13630
	sty $02                                 ;C13633
	lda #$C1                                ;C13635
	sta $04                                 ;C13637
	jsl $C2938C                             ;C13639
	ldy #$00C4                              ;C1363D
	sty $00                                 ;C13640
	jsl $C62B19                             ;C13642
	ldy #$0032                              ;C13646
	sty $00                                 ;C13649
	jsl $C600C7                             ;C1364B
	lda $04,s                               ;C1364F
	sta $00                                 ;C13651
	ldy #$37C9                              ;C13653
	sty $02                                 ;C13656
	lda #$C1                                ;C13658
	sta $04                                 ;C1365A
	jsl $C2938C                             ;C1365C
	lda $04,s                               ;C13660
	sta $00                                 ;C13662
	jsl $C2721B                             ;C13664
	lda $01,s                               ;C13668
	sta $00                                 ;C1366A
	jsl $C306F4                             ;C1366C
	lda #$0F                                ;C13670
	sta $00                                 ;C13672
	jsl $C3035D                             ;C13674
	lda $00                                 ;C13678
	sta $01,s                               ;C1367A
	ldy #$07E3                              ;C1367C
	sty $00                                 ;C1367F
	jsl.l DisplayMessage
	.db $A3,$01,$85,$00,$22,$57,$01,$C1,$68,$85   ;C1367F  
	.db $02,$A0,$DA,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A3,$01,$85,$02,$A0   ;C1368F
	.db $E4,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C136A7
	lda $04,s                               ;C136AB
	sta $00                                 ;C136AD
	ldy #$37C2                              ;C136AF
	sty $02                                 ;C136B2
	lda #$C1                                ;C136B4
	sta $04                                 ;C136B6
	jsl $C2938C                             ;C136B8
	ldy #$00C4                              ;C136BC
	sty $00                                 ;C136BF
	jsl $C62B19                             ;C136C1
	ldy #$0032                              ;C136C5
	sty $00                                 ;C136C8
	jsl $C600C7                             ;C136CA
	lda $04,s                               ;C136CE
	sta $00                                 ;C136D0
	ldy #$37C9                              ;C136D2
	sty $02                                 ;C136D5
	lda #$C1                                ;C136D7
	sta $04                                 ;C136D9
	jsl $C2938C                             ;C136DB
	lda $04,s                               ;C136DF
	sta $00                                 ;C136E1
	jsl $C2721B                             ;C136E3
	lda $01,s                               ;C136E7
	sta $00                                 ;C136E9
	jsl $C306F4                             ;C136EB
	lda #$25                                ;C136EF
	sta $00                                 ;C136F1
	jsl $C3035D                             ;C136F3
	lda $00                                 ;C136F7
	sta $01,s                               ;C136F9
	ldy #$07E5                              ;C136FB
	sty $00                                 ;C136FE
	jsl.l DisplayMessage
	.db $A3,$01,$85,$00,$22,$57,$01,$C1,$68,$85,$02   ;C136FF
	.db $A0,$DA,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A3,$01,$85,$02,$85,$03   ;C1370F
	.db $A0,$E6,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$2D,$68,$85,$00   ;C1371F
	.db $22,$57,$01,$C1,$7B,$A3,$03,$AA,$A9,$00,$9F,$71,$88,$7E,$A0,$E8   ;C1372F  
	.db $03,$84,$00,$A0,$00,$00,$84,$02,$22,$E0,$5B,$C2,$22,$05,$24,$C6   ;C1373F  
	.db $A0,$E7,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$E8,$07,$84,$00
	jsl.l DisplayMessage
	jsl $C62405                             ;C13762
	lda $04,s                               ;C13766
	sta $00                                 ;C13768
	ldy #$37C2                              ;C1376A
	sty $02                                 ;C1376D
	lda #$C1                                ;C1376F
	sta $04                                 ;C13771
	jsl $C2938C                             ;C13773
	lda $04,s                               ;C13777
	sta $00                                 ;C13779
	ldy #$37C9                              ;C1377B
	sty $02                                 ;C1377E
	lda #$C1                                ;C13780
	sta $04                                 ;C13782
	jsl $C2938C                             ;C13784
	lda $04,s                               ;C13788
	sta $00                                 ;C1378A
	jsl $C2721B                             ;C1378C
	jsr $5B99                               ;C13790
	php                                     ;C13793
	lda $02,s                               ;C13794
	sta $00                                 ;C13796
	jsl $C306C9                             ;C13798
	lda $05                                 ;C1379C
	and #$FD                                ;C1379E
	sta $05                                 ;C137A0
	lda #$5A                                ;C137A2
	plp                                     ;C137A4
	bcs @lbl_C137A9                         ;C137A5
	lda #$5B                                ;C137A7
@lbl_C137A9:
	sta $06                                 ;C137A9
	jsl $C6054A                             ;C137AB
	lda $01,s                               ;C137AF
	sta $00                                 ;C137B1
	jsl $C306F4                             ;C137B3
	ldy #$07EA                              ;C137B7
	sty $00                                 ;C137BA
	jsl.l DisplayMessage
	.db $68,$60                       ;C137BF  
	.db $02,$02,$02,$02,$02,$02,$FF,$06   ;C137C2
	.db $06,$06,$06,$06,$06,$FF           ;C137CA
	.db $E2,$20,$C2,$10,$DA,$86,$00,$A9,$01,$85,$01,$86,$02,$20,$1A,$68   ;C137D0
	.db $FA,$BF,$71,$88,$7E,$F0,$6A,$C9,$02,$B0,$11,$8A,$85,$00,$22,$1B   ;C137E0
	.db $72,$C2,$A0,$00,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$8A,$85,$00,$22   ;C137F0  
	.db $1B,$72,$C2,$A0,$02,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2   ;C13800
	.db $10,$DA,$8A,$3A,$85,$00,$A9,$01,$85,$01,$86,$02,$20,$1A,$68,$FA   ;C13810  
	.db $BF,$70,$88,$7E,$F0,$26,$C9,$02,$B0,$11,$8A,$85,$00,$22,$1B,$72   ;C13820  
	.db $C2,$A0,$FF,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$8A,$85,$00,$22,$1B   ;C13830
	.db $72,$C2,$A0,$05,$08,$84,$00
	jsl.l DisplayMessage
	rts                                     ;C1384B
	sep #$20                                ;C1384C
	rep #$10                                ;C1384E
	dex                                     ;C13850
	sep #$20                                ;C13851
	rep #$10                                ;C13853
	txa                                     ;C13855
	pha                                     ;C13856
	pha                                     ;C13857
	jsr $385E                               ;C13858
	pla                                     ;C1385B
	pla                                     ;C1385C
	rts                                     ;C1385D
	sep #$20                                ;C1385E
	rep #$10                                ;C13860
	ldx #$FFFF                              ;C13862
@lbl_C13865:
	inx                                     ;C13865
	lda $7E894F,x                           ;C13866
	bpl @lbl_C13865                         ;C1386A
	cpx #$0000                              ;C1386C
	bne @lbl_C13874                         ;C1386F
	jmp $3979                               ;C13871
@lbl_C13874:
	txa                                     ;C13874
	sta $01                                 ;C13875
	lda #$01                                ;C13877
	sta $00                                 ;C13879
	jsl $C3F69F                             ;C1387B
	lda $00                                 ;C1387F
	sta $04,s                               ;C13881
	lda $03,s                               ;C13883
	sta $00                                 ;C13885
	jsl $C2721B                             ;C13887
	lda $04,s                               ;C1388B
	sta $02                                 ;C1388D
	ldy #$07FB                              ;C1388F
	sty $00                                 ;C13892
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$1A,$85,$00,$A9,$00,$85,$01,$22,$38   ;C138A0  
	.db $72,$C2,$A0,$FC,$07,$84,$00
	jsl.l DisplayMessage
	.db $A3,$04,$85,$02,$85   ;C138B0  
	.db $03,$A0,$FD,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A3,$03,$1A,$85,$00,$22,$1B,$72,$C2   ;C138D0  
	.db $A3,$04,$85,$02,$A0,$FE,$07,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0   ;C138E0  
	.db $1D,$A0,$FF,$07,$84,$00
	jsl.l DisplayMessage
	.db $A0,$00,$08,$84,$00
	jsl.l DisplayMessage
	.db $7B,$A3,$03,$AA,$A9,$01,$9F,$71,$88,$7E,$60,$7B,$A3   ;C13900  
	.db $04,$3A,$85,$00,$AA,$BF,$4F,$89,$7E,$83,$04,$22,$4D,$3C,$C2,$A5   ;C13910  
	.db $00,$D0,$0F,$A0,$2F,$01,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6   ;C13920
	.db $80,$BF,$A3,$04,$85,$02,$A0,$01,$08,$84,$00
	jsl.l DisplayMessage
	.db $A3   ;C13930  
	.db $04,$85,$00,$22,$F4,$06,$C3,$A0,$02,$08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$03,$08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$04,$08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$5E,$85,$00,$22,$5D,$03,$C3,$22,$57,$01,$C1,$7B,$A3   ;C13960  
	.db $03,$AA,$A9,$02,$9F,$71,$88,$7E,$60,$A3,$03,$85,$00,$A9,$04,$85   ;C13970  
	.db $01,$22,$38,$72,$C2,$A3,$03,$1A,$85,$00,$A9,$00,$85,$01,$22,$38   ;C13980  
	.db $72,$C2,$A0,$06,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C13990  
	.db $A9,$09,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$08,$F0,$24,$DA,$A9   ;C139A0
	.db $17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$F1   ;C139B0  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$07,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$82,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                   ;C139D8


	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C139FA
	.db $A0,$F3,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C139F8  
@lbl_C139FA:
	ldy.w #$0808
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	txa
	sta.b wTemp00
	jsl.l func_C2721B
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13A29
	.db $A0,$F4,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13A27  
@lbl_C13A29:
	ldy.w #$0809
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	GetEvent Event_Naoki
	cmp.b #$08
	beq @lbl_C13A69
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13A5F
	.db $A0,$F5,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13A5D  
@lbl_C13A5F:
	ldy.w #$080A
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13A69:
	.db $A0,$7D,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13A71  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13A91
	.db $A0,$F7,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13A8F  
@lbl_C13A91:
	lda.l wCharEventFlags,x
	beq @lbl_C13AA1
	.db $A0,$12,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13A9F  
@lbl_C13AA1:
	;fortune teller dialogue
	;Both the fortune you get and the tip he gives are completely random. It doesn't
	;seem like it saves the result for later/influences your luck at all.
	inc a
	sta.l wCharEventFlags,x
	ldy.w #$080C
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C13ABD
	.db $A0,$0E,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13ABB  
@lbl_C13ABD:
	ldy.w #$080F
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l Random
	tdc
	lda.b wTemp00
	and.b #$07 ;8 possible messages
	asl a
	tax
	rep #$20 ;A->16
	lda.l FortuneTellerResultsText,x
	sta.b wTemp00
	sep #$20 ;A->8
	jsl.l DisplayMessage
	ldy.w #$0810
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l Random
	tdc
	lda.b wTemp00
	and.b #$03 ;4 possible messages
	asl a
	tax
	rep #$20 ;A->16
	lda.l FortuneTellerTipsText,x
	sta.b wTemp00
	sep #$20 ;A->8
	jsl.l DisplayMessage 
	ldy.w #$0811
	sty.b wTemp00
	jsl.l DisplayMessage 
	rts

FortuneTellerResultsText:
	.dw $813
	.dw $814
	.dw $815
	.dw $816
	.dw $817
	.dw $818
	.dw $819
	.dw $81A

FortuneTellerTipsText:
	.dw $81B
	.dw $81C
	.dw $81D
	.dw $81E
	
;c13b23
	.db $E2,$20,$C2,$10   ;C13B1F  
	.db $DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A   ;C13B27
	.db $A0,$FD,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$20,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                   ;C13B47  

	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13B69
	.db $A0,$FE,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13B67  
@lbl_C13B69:
	ldy.w #$0821
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $E2,$20,$C2,$10,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA   ;C13B73
	.db $89,$01,$F0,$0A,$A0,$FF,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$22   ;C13B83
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C13B93
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13BB9
	.db $A0,$FC,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13BB7  
@lbl_C13BB9:
	ldy.w #$0823
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $E2,$20,$C2,$10,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA   ;C13BC3
	.db $89,$01,$F0,$0A,$A0,$DF,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$24   ;C13BD3
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$DA,$A9,$17,$85   ;C13BE3
	.db $00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$F8,$08,$84   ;C13BF3
	.db $00
	jsl.l DisplayMessage
	.db $60,$A0,$1F,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C13C03
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	bne @lbl_C13C2C
	inc a
	sta.l wCharEventFlags,x
	ldy.w #$082A
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13C2C:
	ldy.w #$082B
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13C54
	.db $A0,$D0,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13C52  
@lbl_C13C54:
	lda.l wCharEventFlags,x
	beq @lbl_C13C64
	.db $A0,$88,$06,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13C62  
@lbl_C13C64:
	inc a
	sta.l wCharEventFlags,x
	jsr.w NPCScriptFunction_C163C9
	bcc @lbl_C13C78
	ldy.w #$0687
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13C78:
	.db $A0,$2C,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13C80  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13CD9
	.db $A9,$95,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$2D,$A9,$95,$85,$00   ;C13C96
	.db $A9,$01,$85,$02
	jsl.l _SetEvent
	.db $A0,$D1,$08,$84,$00,$22,$7E,$2B   ;C13CA6
	.db $C6,$A5,$00,$D0,$0B,$A0,$31,$08,$84,$00
	jsl.l DisplayMessage
	.db $80,$09   ;C13CB6  
	.db $A0,$32,$08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$D2,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                       ;C13CD6  
@lbl_C13CD9:
	lda.l wCharEventFlags,x
	bne @lbl_C13D17
	GetEvent Event95
	bne @lbl_C13D0D
	SetEvent Event20 $01
	SetEvent Event95 $01
	ldy.w #$082D
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13D0D:
	.db $A0,$2E,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13D15  
@lbl_C13D17:
	GetEvent Event95
	beq @lbl_C13D2D
	.db $A0,$2E,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13D2B  
@lbl_C13D2D:
	SetEvent Event95 $01
	ldy.w #$082F
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l Random
	tdc
	lda.b wTemp00
	and.b #$07
	asl a
	tax
	rep #$20 ;A->16
	lda.l UNREACH_C13D7C,x
	sta.b wTemp00
	sep #$20 ;A->8
	jsl.l DisplayMessage
	ldy.w #$0830
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	bne @lbl_C13D72
	ldy.w #$0831
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13D72:
	.db $A0,$32,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13D7A  

UNREACH_C13D7C:
	.db $33,$08,$34,$08,$35,$08,$36,$08,$37,$08,$38,$08,$39,$08,$3A,$08   ;C13D7C  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13DAA
	.db $A0,$D5,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13DA8  
@lbl_C13DAA:
	lda.l wCharEventFlags,x
	bne @lbl_C13E1E
	GetEvent Event82
	beq @lbl_C13DC6
	.db $A0,$90,$06,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13DC4  
@lbl_C13DC6:
	ldy.w #$068D
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C13DDD
	.db $A0,$8E,$06,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13DDB  
@lbl_C13DDD:
	SetEvent Event1F $01
	ldy.w #$068F
	sty.b wTemp00
	jsl.l DisplayMessage
	lda.b #$AF
	sta.b wTemp00
	jsl.l func_C3035D
	lda.b wTemp00
	bmi @lbl_C13E1D
	sta.b wTemp02
	pha
	ldy.w #$0679
	sty.b wTemp00
	jsl.l DisplayMessage
	pla
	sta.b wTemp00
	jsl.l func_C10157
	SetEvent Event82 $01
@lbl_C13E1D:
	rts
@lbl_C13E1E:
	GetEvent Event82
	bne @lbl_C13E78
	ldy.w #$083F
	sty.b wTemp00
	jsl.l DisplayMessage
	lda.b #$AF
	sta.b wTemp00
	jsl.l func_C3035D
	lda.b wTemp00
	bmi @lbl_C13E5E
	sta.b wTemp02
	pha
	ldy.w #$0679
	sty.b wTemp00
	jsl.l DisplayMessage
	pla
	sta.b wTemp00
	jsl.l func_C10157
	SetEvent Event82 $01
@lbl_C13E5E:
	GetEvent Event1F
	cmp.b #$02
	bcs @lbl_C13E81
	SetEvent Event1F $02
@lbl_C13E78:
	ldy.w #$0840
	sty.b wTemp00
	jsl.l DisplayMessage
@lbl_C13E81:
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$0692
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event0F $01
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$068B
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event0F $01
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$083B
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event10 $01
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$083C
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event11 $01
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13F08
	.db $A0,$D3,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13F06  
@lbl_C13F08:
	ldy.w #$083D
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event12 $01
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13F3C
	.db $A0,$D4,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13F3A  
@lbl_C13F3C:
	ldy.w #$083E
	sty.b wTemp00
	jsl.l DisplayMessage
	SetEvent Event13 $01
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13F70
	.db $A0,$E5,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13F6E  
@lbl_C13F70:
	ldy.w #$0841
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13F98
	.db $A0,$E6,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13F96  
@lbl_C13F98:
	ldy.w #$0842
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	bne @lbl_C13FAF
	ldy.w #$0844
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C13FAF:
	dec a
	bne @lbl_C13FBC
	.db $A0,$45,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13FBA  
@lbl_C13FBC:
	dec a
	bne @lbl_C13FC9
	.db $A0,$46,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13FC7  
@lbl_C13FC9:
	ldy.w #$0847
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C13FF1
	.db $A0,$D6,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C13FEF  
@lbl_C13FF1:
	ldy.w #$0691
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C14019
	.db $A0,$E4,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C14017  
@lbl_C14019:
	ldy.w #$0848
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C14030
	.db $A0,$4A,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C1402E  
@lbl_C14030:
	ldy.w #$084B
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	stx.b wTemp00
	stz.b wTemp01
	stx.b wTemp02
	jsr.w func_C1681A
	GetEvent Event8E
	beq @lbl_C14056
;C14053  
	.db $4C,$FC,$41
@lbl_C14056:
	GetEvent Event8A
	beq @lbl_C14065
	jmp.w func_C140E5
@lbl_C14065:
	GetEvent Event17
	and.b #$17
	cmp.b #$17
	bne @lbl_C14078
;C14075  
	.db $4C,$88,$41
@lbl_C14078:
	GetEvent Event_Fei
	beq @lbl_C14091
	ldy.w #$084E
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	bra @lbl_C140A8
@lbl_C14091:
	SetEvent Event_Fei $01
	ldy.w #$084C
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
@lbl_C140A8:
	beq @lbl_C140B4
	.db $A0,$4D,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C140B2  
@lbl_C140B4:
	ldy.w #$084F
	sty.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62405
	jsr.w func_C14214
	SetEvent Event8A $01
	GetEvent Event16
	inc a
	sta.b wTemp01
	lda.b #$08
	sta.b wTemp00
	jsl.l func_C62A23

func_C140E5:
	cmp.b #$02
	bcs @lbl_C14103
	.db $A9,$8A,$85,$00,$A9,$00,$85,$02
	jsl.l _SetEvent
	.db $A0,$50,$08,$84   ;C140E9
	.db $00,$22,$7E,$2B,$C6,$A5,$00,$4C   ;C140F9
	.db $A8,$40                           ;C14101
@lbl_C14103:
	cmp.b #$03
	bcs @lbl_C1417E
	SetEvent Event8A $03
	GetEvent Event16
	pha
	inc a
	cmp.b #$32
	bne @lbl_C1413B
	.db $A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$09,$10,$85,$02,$A9,$17   ;C14123
	.db $85,$00
	jsl.l _SetEvent
	.db $A9,$00   ;C14133  
@lbl_C1413B:
	sta.b wTemp02
	lda.b #Event16
	sta.b wTemp00
	jsl.l _SetEvent
	ldy.w #$0851
	sty.b wTemp00
	jsl.l DisplayMessage
	pla
	ldy.w #$0002
	cmp.b #$18
	bcc @lbl_C14160
	.db $A0,$00,$00,$C9,$29,$90,$03,$A0   ;C14156
	.db $01,$00                           ;C1415E  
@lbl_C14160:
	sty.b wTemp00
	jsl.l func_C303E9
	lda.b wTemp00
	bmi @lbl_C1417D
	sta.b wTemp02
	pha
	ldy.w #$0852
	sty.b wTemp00
	jsl.l DisplayMessage
	pla
	sta.b wTemp00
	jsl.l func_C10157
@lbl_C1417D:
	rts
@lbl_C1417E:
	ldy.w #$0853
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $A9,$14,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$03,$B0,$48,$A0,$54   ;C14188
	.db $08,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$16,$A9,$14,$85,$00,$A9   ;C14198
	.db $03,$85,$02
	jsl.l _SetEvent
	.db $A0,$55,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A9,$14,$85,$00,$A9,$04,$85,$02
	jsl.l _SetEvent
	.db $A0,$57,$08   ;C141B8
	.db $84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$20,$14,$42,$A0,$04,$01   ;C141C8  
	.db $84,$00,$22,$23,$2A,$C6,$C9,$04,$B0,$0D,$A0,$56,$08,$84,$00,$22   ;C141D8  
	.db $7E,$2B,$C6,$A5,$00,$80,$B2,$A0,$58,$08,$84,$00,$22,$7E,$2B,$C6   ;C141E8  
	.db $A5,$00,$80,$A5,$A9,$8E,$85,$00,$A9,$00,$85,$02
	jsl.l _SetEvent
	.db $A0,$AA,$08,$84,$00,$22,$7E,$2B   ;C14208
	.db $C6,$A5,$00,$60                   ;C14210  

func_C14214:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	tdc
	lda.b wTemp02
	asl a
	tax
	rep #$20 ;A->16
	lda.l UNREACH_C1423B,x
	sta.b wTemp02
	sep #$20 ;A->8
	lda.b #$C1
	sta.b wTemp04
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C2938C
	jsr.w func_C10189
	rts

UNREACH_C1423B:
	.dw Data_c1424b
	.dw Data_c1424d
	.dw Data_c14252
	.dw Data_c14256
	.dw Data_c1425a
	.dw Data_c1424b
	.dw Data_c1424b
	.dw Data_c1424b

Data_c1424b:
	.db $02,$FF
Data_c1424d:
	.db $00,$01,$02,$02,$FF
Data_c14252:
	.db $01,$02,$02,$FF
Data_c14256:
	.db $02,$02,$02,$FF
Data_c1425a:
	.db $02,$02,$FF
	
Data_c1425d:
	.db $E2,$20,$C2,$10,$8A,$48,$20,$68,$42,$68,$60,$E2,$20   ;C1425A
	.db $C2,$10,$A9,$15,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$05,$90,$03   ;C1426A
	.db $4C,$68,$43,$7B,$A3,$03,$AA,$BF,$71,$88,$7E,$F0,$27,$A9,$15,$85   ;C1427A  
	.db $00
	jsl.l _GetEvent
	.db $A5,$00,$D0,$0D,$A0,$5B,$08,$84,$00,$22,$7E   ;C1428A
	.db $2B,$C6,$A5,$00,$80,$3B,$A0,$5B,$08,$84,$00,$22,$7E,$2B,$C6,$A5   ;C1429A
	.db $00,$4C,$32,$43,$1A,$9F,$71,$88,$7E,$A9,$15,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$C9,$02,$90,$03,$4C,$17,$43,$A9,$15,$85,$00,$A9,$02   ;C142BA  
	.db $85,$02
	jsl.l _SetEvent
	.db $A0,$59,$08,$84,$00,$22,$7E,$2B,$C6,$A5   ;C142CA  
	.db $00,$F0,$0A,$A0,$5A,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$5C,$08   ;C142DA
	.db $84,$00
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$A9,$1A,$85,$02,$22,$F6   ;C142EA  
	.db $26,$C6,$A0,$5D,$08,$84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A0   ;C142FA  
	.db $0A,$06,$84,$00,$A0,$14,$06,$84,$02,$22,$EC,$29,$C6,$C9,$03,$B0   ;C1430A
	.db $23,$A9,$15,$85,$00,$A9,$03,$85,$02
	jsl.l _SetEvent
	.db $A0,$5E,$08   ;C1431A  
	.db $84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$B3,$A0,$5F,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$C9,$04,$B0,$19,$A9,$15,$85,$00,$A9,$04,$85,$02   ;C1433A  
	jsl.l _SetEvent
	.db $A0,$60,$08,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$80   ;C1434A  
	.db $D7,$A0,$61,$08,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$80,$CA,$C9,$06   ;C1435A  
	.db $B0,$6E,$A9,$15,$85,$00,$A9,$06,$85,$02
	jsl.l _SetEvent
	.db $A0,$62   ;C1436A  
	.db $08,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$0A,$A0,$5F,$08,$84,$00   ;C1437A
	jsl.l DisplayMessage
	.db $60,$A0,$64,$08,$84,$00,$22,$7E,$2B,$C6,$A5,$00   ;C1438A  
	.db $30,$E9,$D0,$0C,$A0,$66,$08,$84,$00
	jsl.l DisplayMessage
	.db $4C,$F0,$42   ;C1439A  
	.db $A0,$67,$08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$A9,$1A,$85   ;C143AA
	.db $02,$22,$F6,$26,$C6,$A0,$5D,$08,$84,$00
	jsl.l DisplayMessage
	.db $22,$05   ;C143BA
	.db $24,$C6,$A0,$0A,$0A,$84,$00,$A0,$15,$25,$84,$02,$22,$EC,$29,$C6   ;C143CA  
	.db $A0,$63,$08,$84,$00,$22,$7E,$2B   ;C143DA
	.db $C6,$A5,$00,$80,$9C               ;C143E2  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	GetEvent Event15
	cmp.b #$06
	bcs @lbl_C14403
	ldy.w #$080B
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C14403:
	.db $C9,$07,$B0,$48,$A9,$15,$85,$00,$A9,$07,$85,$02
	jsl.l _SetEvent
	.db $A0,$68,$08,$84,$00,$22,$7E,$2B,$C6,$A5,$00,$F0,$0A,$A0,$69,$08   ;C14413
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$6B,$08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$13,$85,$00,$A9,$1A,$85,$02,$22,$F6,$26,$C6,$A0,$6C,$08,$84   ;C14433
	.db $00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$4C,$CC,$43,$A0,$6A,$08,$84   ;C14443
	.db $00,$22,$7E,$2B,$C6,$A5,$00,$80   ;C14453
	.db $C2

;why are these here?
	
NPCScriptFunction_C1445C:
	.db $08,$E2,$20,$A9,$15,$85,$00   ;C1445B
	jsl.l _GetEvent
	.db $A5,$00,$D0,$0C,$A9,$15,$85,$00,$A9,$01,$85,$02   ;C14463  
	jsl.l _SetEvent
	.db $28,$60           ;C14473
	
NPCScriptFunction_C14479:
	php
	sep #$20 ;A->8
	GetEvent Event15
	cmp.b #$05
	bcs @lbl_C14496
	SetEvent Event15 $05
@lbl_C14496:
	plp
	rts
	rep #$20 ;A->16
	lda.w #$06B6
	sta.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $E2,$20,$C2,$10,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA   ;C144A4
	.db $89,$01,$F0,$0A,$A0,$DB,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$BA   ;C144B4
	.db $06,$84,$00
	jsl.l DisplayMessage
	.db $A9,$1C,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $60,$E2,$20,$C2,$10,$A0,$88,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$89,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C144E4  
	.db $E2,$20,$C2,$10,$A0,$8A,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C144F4
	.db $C2,$10,$A0,$8B,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C14504
	.db $A0,$8C,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$8D   ;C14514
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$8E,$08,$84   ;C14524
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$99,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$BF,$71,$88,$7E,$D0,$10,$A9,$01   ;C14544  
	.db $9F,$71,$88,$7E,$A0,$9A,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$9B   ;C14554  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$9C,$08,$84   ;C14564
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$9D,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$E1,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$DA,$A9,$0C,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$C9,$03   ;C145A4  
	.db $90,$10,$DA,$A9,$89,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$C9,$02   ;C145B4  
	.db $90,$0A,$A0,$9E,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$F7,$07,$84   ;C145C4  
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$E2,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$9F,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C145F4  
	.db $C2,$10,$A0,$A0,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C14604
	.db $A0,$A1,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$A2   ;C14614
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$A3,$08,$84   ;C14624
	.db $00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$A4,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$A5,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$A6,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C14654  
	.db $E2,$20,$C2,$10,$A0,$A7,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C14664
	.db $C2,$10,$A0,$A8,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C14674
	.db $A0,$A9,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C1468C  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	ldy.w #$08AB
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	bne @lbl_C146A9
	ldy.w #$08AC
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C146A9:
	.db $A0,$AD,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$8A,$48   ;C146A9
	.db $85,$00,$22,$AC,$10,$C2,$A5,$02,$48,$A9,$07,$48,$A3,$02,$18,$63   ;C146B9  
	.db $01,$29,$07,$85,$01,$A3,$03,$85,$00,$22,$38,$72,$C2,$A3,$01,$3A   ;C146C9  
	.db $83,$01,$10,$E8,$68,$68,$68,$DA,$A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0,$E7,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$AE,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$DA   ;C146F9
	.db $A9,$17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$0A,$A0   ;C14709
	.db $E8,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$AF,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                       ;C14729  
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C1474A
	.db $A0,$E9,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C14748  
@lbl_C1474A:
	ldy.w #$08B0
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C14772
	.db $A0,$EA,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C14770  
@lbl_C14772:
	ldy.w #$08B1
	sty.b wTemp00
	jsl.l DisplayMessage1
	lda.b wTemp00
	beq @lbl_C14789
	ldy.w #$08B2
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C14789:
	ldy.w #$08B3
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $E2,$20,$C2,$10,$BF,$71,$88,$7E,$D0,$0D,$22,$5F,$F6,$C3,$A5,$00   ;C14793
	.db $29,$01,$1A,$9F,$71,$88,$7E,$3A,$D0,$0A,$A0,$B4,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$B5,$08,$84   ;C147B3  
	.db $00
	jsl.l DisplayMessage
	.db $60           ;C147BB
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C147DF
	.db $A0,$D7,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C147DD  
@lbl_C147DF:
	ldy.w #$08B6
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $E2,$20,$C2,$10,$BF,$71,$88,$7E,$D0,$0D,$22,$5F,$F6,$C3,$A5,$00   ;C147E9
	.db $29,$01,$1A,$9F,$71,$88,$7E,$3A,$D0,$0A,$A0,$B7,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$B8,$08,$84   ;C14809  
	.db $00
	jsl.l DisplayMessage
	.db $60           ;C14811
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	bne @lbl_C1482E
	jsl.l Random
	lda.b wTemp00
	and.b #$01
	inc a
	sta.l wCharEventFlags,x
@lbl_C1482E:
	dec a
	bne @lbl_C1483B
	.db $A0,$B9,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C14839  
@lbl_C1483B:
	ldy.w #$08BA
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	lda.l wCharEventFlags,x
	bne @lbl_C14860
@lbl_C1484F:
	jsl.l Random
	lda.b wTemp00
	and.b #$03
	cmp.b #$03
	bcs @lbl_C1484F
	inc a
	sta.l wCharEventFlags,x
@lbl_C14860:
	dec a
	bne @lbl_C1486D
	ldy.w #$08BB
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
@lbl_C1486D:
	.db $3A,$D0,$0A,$A0,$BC,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$BD,$08   ;C1486D
	.db $84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$BE,$08,$84,$00   ;C1487D  
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$BF,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$C0,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$BF,$71,$88,$7E,$D0,$11,$22,$5F,$F6,$C3,$A5   ;C148AD
	.db $00,$29,$03,$C9,$03,$B0,$F4,$1A,$9F,$71,$88,$7E,$3A,$D0,$0A,$A0   ;C148BD
	.db $C1,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$3A,$D0,$0A,$A0,$C2,$08,$84   ;C148CD  
	.db $00
	jsl.l DisplayMessage
	.db $60,$A0,$C3,$08,$84,$00
	jsl.l DisplayMessage
	.db $60   ;C148DD
	.db $E2,$20,$C2,$10,$A0,$BC,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C148ED
	.db $C2,$10,$A0,$BB,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C148FD
	.db $A0,$BD,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$BE   ;C1490D
	.db $07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$BF,$07,$84   ;C1491D  
	.db $00
	jsl.l DisplayMessage
	.db $60           ;C1492D
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C14951
	.db $A0,$DA,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C1494F  
@lbl_C14951:
	GetEvent Event1A
	cmp.b #$08
	bcs @lbl_C1497F
	ldy.w #$08C5
	sty.b wTemp00
	jsl.l DisplayMessage
	GetEvent Event1A
	ora.b #$04
	sta.b wTemp02
	lda.b #Event1A
	sta.b wTemp00
	jsl.l _SetEvent
	rts
@lbl_C1497F:
	.db $A0,$C8,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$DA,$A9   ;C1497F
	.db $17,$85,$00
	jsl.l _GetEvent
	.db $A5,$00,$FA,$89,$01,$F0,$16,$A0,$E3   ;C1498F  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$1D,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $60,$A0,$C9,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C149AF  
	.db $C2,$10,$A0,$CA,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C149BF
	.db $A0,$CB,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A0,$CC   ;C149CF
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$A9,$09,$85,$00   ;C149DF
	jsl.l _GetEvent
	.db $A5,$00,$C9,$05,$B0,$0A,$A0,$CD,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$CF,$08,$84   ;C149FF  
	.db $00
	jsl.l DisplayMessage
	.db $60           ;C14A07
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C14A2B
	.db $A0,$F6,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                           ;C14A29  
@lbl_C14A2B:
	ldy.w #$08CE
	sty.b wTemp00
	jsl.l DisplayMessage
	rts
	.db $E2,$20,$C2,$10,$A0,$B3,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20   ;C14A35
	.db $C2,$10,$A0,$B4,$07,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10   ;C14A45
	.db $A0,$EC,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$E2,$20,$C2,$10,$BF,$71   ;C14A55
	.db $88,$7E,$D0,$0D,$22,$5F,$F6,$C3,$A5,$00,$29,$01,$1A,$9F,$71,$88   ;C14A65
	.db $7E,$3A,$D0,$0A,$A0,$ED,$08,$84,$00
	jsl.l DisplayMessage
	.db $60,$A0,$EE   ;C14A75  
	.db $08,$84,$00
	jsl.l DisplayMessage
	.db $60,$60,$E2,$20,$C2,$10,$A9,$13,$85   ;C14A85
	.db $00,$A0,$DE,$4A,$84,$02,$A9,$C1,$85,$04,$22,$8C,$93,$C2,$A9,$13   ;C14A95
	.db $85,$00,$A9,$DF,$85,$02,$22,$50,$25,$C6,$22,$05,$24,$C6,$A9,$17   ;C14AA5  
	.db $85,$00
	jsl.l _GetEvent
	.db $A5,$00,$09,$01,$85,$02,$A9,$17,$85,$00   ;C14AB5  
	jsl.l _SetEvent
	.db $A9,$8B,$85,$00,$A9,$01,$85,$02
	jsl.l _SetEvent
	.db $A0,$0A,$01,$84,$00,$22,$23,$2A,$C6,$02,$02,$02,$02,$02,$02,$02   ;C14AD5
	.db $02,$02,$02,$FF                   ;C14AE5
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event_Naoki
	plx
	cmp.b #$08
	beq @lbl_C14B60
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C14B1E
	.db $8A,$85,$00,$22,$1B,$72,$C2,$A0,$D9,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                               ;C14B1D
@lbl_C14B1E:
	phx
	GetEvent Event1A
	cmp.b #$08
	bcs @lbl_C14B4E
	plx
	ldy.w #$06AF
	sty.b wTemp00
	jsl.l DisplayMessage
	GetEvent Event1A
	ora.b #$01
	sta.b wTemp02
	lda.b #Event1A
	sta.b wTemp00
	jsl.l _SetEvent
	rts
@lbl_C14B4E:
	.db $FA,$8A,$85,$00,$22,$1B,$72,$C2,$A0,$C7,$08,$84,$00
	jsl.l DisplayMessage
	rts
@lbl_C14B60:
	.db $8A,$85,$00,$22,$1B,$72,$C2,$A0,$81,$08,$84,$00
	jsl.l DisplayMessage
	rts
	sep #$20 ;A->8
	rep #$10 ;XY->16
	phx
	GetEvent Event_Naoki
	plx
	cmp.b #$08
	beq @lbl_C14BDE
	phx
	GetEvent Event17
	plx
	bit.b #$01
	beq @lbl_C14BA6
	.db $8A,$85,$00,$22,$1B,$72,$C2,$A0,$D8,$08,$84,$00
	jsl.l DisplayMessage
	.db $60                               ;C14BA5
@lbl_C14BA6:
	GetEvent Event1A
	cmp.b #$08
	bcs @lbl_C14BD4
	ldy.w #$06B0
	sty.b wTemp00
	jsl.l DisplayMessage
	GetEvent Event1A
	ora.b #$02
	sta.b wTemp02
	lda.b #Event1A
	sta.b wTemp00
	jsl.l _SetEvent
	rts
@lbl_C14BD4:
	.db $A0,$C6,$08,$84,$00
	jsl.l DisplayMessage
	rts
@lbl_C14BDE:
	.db $8A,$85,$00,$22,$1B,$72,$C2,$A0,$80,$08,$84,$00
	jsl.l DisplayMessage
	rts
	rep #$20                                ;C14BEF
	sep #$10                                ;C14BF1
	phx                                     ;C14BF3
	lda #$06C1                              ;C14BF4
	pha                                     ;C14BF7
	lda #$06C9                              ;C14BF8
	pha                                     ;C14BFB
	lda #$06C6                              ;C14BFC
	pha                                     ;C14BFF
	lda #$06BE                              ;C14C00
	pha                                     ;C14C03
	lda #$06BF                              ;C14C04
	pha                                     ;C14C07
	lda #$06C0                              ;C14C08
	pha                                     ;C14C0B
	lda #$06C2                              ;C14C0C
	pha                                     ;C14C0F
	lda #$06C7                              ;C14C10
	pha                                     ;C14C13
	lda #$3A32                              ;C14C14
	pha                                     ;C14C17
	bra @lbl_C14C6E                         ;C14C18
	rep #$20                                ;C14C1A
	sep #$10                                ;C14C1C
	phx                                     ;C14C1E
	lda #$06C1                              ;C14C1F
	pha                                     ;C14C22
	lda #$06C9                              ;C14C23
	pha                                     ;C14C26
	lda #$06C4                              ;C14C27
	pha                                     ;C14C2A
	lda #$06BE                              ;C14C2B
	pha                                     ;C14C2E
	lda #$06BF                              ;C14C2F
	pha                                     ;C14C32
	lda #$06C0                              ;C14C33
	pha                                     ;C14C36
	lda #$06C2                              ;C14C37
	pha                                     ;C14C3A
	lda #$06C5                              ;C14C3B
	pha                                     ;C14C3E
	lda #$2D1E                              ;C14C3F
	pha                                     ;C14C42
	bra @lbl_C14C6E                         ;C14C43
	rep #$20                                ;C14C45
	sep #$10                                ;C14C47
	phx                                     ;C14C49
	lda #$06C1                              ;C14C4A
	pha                                     ;C14C4D
	lda #$06C9                              ;C14C4E
	pha                                     ;C14C51
	lda #$06BD                              ;C14C52
	pha                                     ;C14C55
	lda #$06BE                              ;C14C56
	pha                                     ;C14C59
	lda #$06BF                              ;C14C5A
	pha                                     ;C14C5D
	lda #$06C0                              ;C14C5E
	pha                                     ;C14C61
	lda #$06C2                              ;C14C62
	pha                                     ;C14C65
	lda #$06C3                              ;C14C66
	pha                                     ;C14C69
	lda #$1900                              ;C14C6A
	pha                                     ;C14C6D
@lbl_C14C6E:
	sep #$30                                ;C14C6E
	lda $13,s                               ;C14C70
	tax                                     ;C14C72
	lda $7E8871,x                           ;C14C73
	.db $F0,$0C   ;C14C77
	rep #$20                                ;C14C79
	lda $05,s                               ;C14C7B
	sta $00                                 ;C14C7D
.ACCU 8
.INDEX 16
	jsl.l DisplayMessage
	.db $80,$29,$E2,$30,$22,$7D,$6C,$C1,$A3,$01,$85   ;C14C7E
	.db $06,$48,$22,$1F,$05,$C6,$68,$A4,$00,$C0,$FF,$F0,$1E,$1A,$C3,$02   ;C14C8E  
	.db $90,$ED,$C2,$20,$A3,$03,$85,$00
	jsl.l DisplayMessage
	.db $22,$75,$6B,$C1   ;C14C9E  
	.db $68,$68,$68,$68,$68,$68,$68,$68,$68,$FA,$60,$E2,$20,$83,$01,$C2   ;C14CAE
	.db $20,$A3,$0D,$85,$00,$22,$7E,$2B,$C6,$A4,$00,$F0,$0A,$A3,$0B,$85   ;C14CBE  
	.db $00
	jsl.l DisplayMessage
	.db $80,$D5,$A3,$09,$85,$00,$22,$7E,$2B,$C6,$A6   ;C14CCE
	.db $00,$E0,$80,$F0,$E8,$BF,$4F,$89,$7E,$85,$00,$48,$DA,$22,$10,$07   ;C14CDE
	.db $C3,$FA,$68,$A4,$00,$C0,$0B,$F0,$41,$86,$00,$AA,$DA,$22,$4D,$3C   ;C14CEE  
	.db $C2,$FA,$A4,$00,$F0,$A6,$86,$02,$A3,$07,$85,$00,$DA
	jsl.l DisplayMessage
	plx                                     ;C14D0F
	stx $00                                 ;C14D10
	phx                                     ;C14D12
	jsl $C306C9                             ;C14D13
	plx                                     ;C14D17
	lda $01,s                               ;C14D18
	sta $06                                 ;C14D1A
	phx                                     ;C14D1C
	jsl $C6054A                             ;C14D1D
	plx                                     ;C14D21
	stx $00                                 ;C14D22
	jsl $C306F4                             ;C14D24
	sep #$20                                ;C14D28
	lda $13,s                               ;C14D2A
	tax                                     ;C14D2C
	lda #$01                                ;C14D2D
	sta $7E8871,x                           ;C14D2F
	rep #$20                                ;C14D33
	jmp $4CAA                               ;C14D35
	sta $02                                 ;C14D38
	lda $11,s                               ;C14D3A
	sta $00                                 ;C14D3C
	phx                                     ;C14D3E
	jsl $C62B7E                             ;C14D3F
	plx                                     ;C14D43
	ldy $00                                 ;C14D44
	beq @lbl_C14D4B                         ;C14D46
	jmp $4CCB                               ;C14D48
@lbl_C14D4B:
	lda $7E894F,x                           ;C14D4B
	stx $00                                 ;C14D4F
	tax                                     ;C14D51
	phx                                     ;C14D52
	jsl $C23C4D                             ;C14D53
	plx                                     ;C14D57
	lda $0F,s                               ;C14D58
	sta $00                                 ;C14D5A
	phx                                     ;C14D5C
.ACCU 8
	jsl.l DisplayMessage
	.db $FA,$80,$AC           ;C14D5E  

func_C14D64:
	php
	sep #$30 ;AXY->8
	lda.b wTemp00
	asl a
	tay
	jsl.l Get7ED5EE
	lda.b wTemp00
	cmp.b #$0A
	bne @lbl_C14DBF
	jsl.l GetShuffleDungeonIndex
	lda.b wTemp00
	dec a
	asl a
	tax
	rep #$20 ;A->16
	lda.w #$004B
	sta.b wTemp00
	phx
	phy
	jsl.l func_C62B19
	ply
	plx
	lda.l DATA8_C14E92,x
	sta.b wTemp00
	restorebank
	lda.b ($00),y
	cmp.w #$8000
	beq @lbl_C14DC1
	cmp.w #$8001
	beq @lbl_C14DCD
	cmp.w #$8002
	beq @lbl_C14DD9
	cmp.w #$8003
	beq @lbl_C14DE5
	cmp.w #$0825
	beq @lbl_C14E08
	cmp.w #$092C
	beq @lbl_C14DF1
	sta.b wTemp00
	jsl.l DisplayMessage
	jsl.l func_C62437
@lbl_C14DBF:
	plp
	rtl
@lbl_C14DC1:
	sep #$30 ;AXY->8
	lda.b #$00
	sta.b wTemp00
	jsl.l func_C62BF2
	plp
	rtl
@lbl_C14DCD:
	.db $E2,$30,$A9,$05,$85,$00,$22,$F2   ;C14DCD
	.db $2B,$C6,$28,$6B                   ;C14DD5
@lbl_C14DD9:
	.db $E2,$30,$A9,$06,$85,$00,$22,$F2   ;C14DD9
	.db $2B,$C6,$28,$6B                   ;C14DE1
@lbl_C14DE5:
	.db $E2,$30,$A9,$07,$85,$00,$22,$F2   ;C14DE5
	.db $2B,$C6,$28,$6B                   ;C14DED
@lbl_C14DF1:
	.db $C2,$20,$85,$00
	jsl.l DisplayMessage
	.db $22,$37,$24,$C6,$A9,$01,$00,$85   ;C14DF1
	.db $00,$22,$F2,$2B,$C6,$28,$6B       ;C14E01
@lbl_C14E08:
	.db $E2,$20,$C2,$10,$A0,$25,$08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$2F,$01   ;C14E08
	.db $84,$00
	jsl.l DisplayMessage
	.db $22,$05,$24,$C6,$A9,$13,$85,$00,$A9,$00   ;C14E18  
	.db $85,$01,$22,$38,$72,$C2,$A0,$26,$08,$84,$00,$22,$7E,$2B,$C6,$A5   ;C14E28  
	.db $00,$F0,$18,$A0,$27,$08,$84,$00
	jsl.l DisplayMessage
	.db $A0,$38,$1B,$84   ;C14E38
	.db $00,$A9,$AA,$85,$02,$22,$A2,$5B,$C3,$28,$6B,$A0,$00,$80,$84,$00   ;C14E48
	.db $22,$19,$2B,$C6,$A0,$29,$08,$84,$00
	jsl.l DisplayMessage
	.db $A9,$13,$85   ;C14E58  
	.db $00,$A0,$E8,$03,$84,$02,$A0,$00,$00,$84,$04,$22,$D3,$34,$C2,$A0   ;C14E68
	.db $38,$1B,$84,$00,$A9,$80,$85,$02,$22,$A2,$5B,$C3,$22,$37,$24,$C6   ;C14E78
	.db $A9,$02,$85,$01,$22,$EE,$2A,$C6   ;C14E88
	.db $28,$6B                           ;C14E90

DATA8_C14E92:
	.db $82,$4F                           ;C14E92
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$A8,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14E94  
	.db $92,$4F                           ;C14EA4
	.db $92,$4F,$C8,$4F,$CE,$4F,$CE,$4F   ;C14EA6  
	.db $B2,$4F                           ;C14EAE
	.db $CE,$4F,$CE,$4F,$BA,$4F,$BA,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14EB0  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14EC0  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14ED0  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$92,$4F,$92,$4F   ;C14EE0  
	.db $CE,$4F,$82,$4F,$92,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14EF0  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F00  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F10  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F20  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F30  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F40  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F50  
	.db $CE,$4F,$A8,$4F,$82,$4F,$92,$4F,$A8,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F60  
	.db $CE,$4F,$CE,$4F,$CE,$4F,$CC,$4F,$CE,$4F,$CE,$4F,$CE,$4F,$CE,$4F   ;C14F70  
	.db $CE,$4F,$32,$09,$33,$09,$34,$09   ;C14F80  
	.db $3D,$09                           ;C14F88  
	.db $00,$80                           ;C14F8A
	.db $01,$80,$02,$80,$03,$80,$24,$09   ;C14F8C  
	.db $25,$09,$26,$09,$27,$09           ;C14F94  
	.db $28,$09                           ;C14F9A
	.db $29,$09,$2A,$09,$2B,$09,$2C,$09,$25,$08,$28,$08,$2D,$09,$2E,$09   ;C14F9C
	.db $2F,$09,$30,$09,$31,$09           ;C14FAC  
	.db $35,$09                           ;C14FB2
	.db $36,$09,$37,$09,$38,$09,$39,$09,$92,$08,$93,$08,$94,$08,$95,$08   ;C14FB4  
	.db $96,$08,$97,$08,$3A,$09,$3B,$09   ;C14FC4  
	.db $3C,$09,$3D,$09                   ;C14FCC  

func_C14FD0:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	lda.b wTemp00
	pha
	jsl.l GetCurrentDungeon
	ldx.b wTemp00
	cpx.b #$01
	bne @lbl_C14FF0
	jsl.l GetCurrentFloor
	ldx.b wTemp00
	cpx.b #$02
	bcc @lbl_C14FF0
	cpx.b #$11
	bcc @lbl_C14FF7
@lbl_C14FF0:
	pla
	sta.b wTemp00
	stz.b wTemp02
	plp
	rtl
@lbl_C14FF7:
	pla
	sta.b wTemp00
	plp
	php
	rep #$20 ;A->16
	lda.b wTemp00
	pha
	sep #$30 ;AXY->8
	ldx.b wTemp00
	lda.l wShirenStatus.itemAmounts,x
	sta.b wTemp00
	jsl.l func_C30710
	lda.b wTemp00
	cmp.b #$02
	bne @lbl_C1508F
	jsr.w func_C1509A
	cmp.b #$00
	beq @lbl_C1508F
	.db $A9,$80,$85,$00
	jsl.l _GetEvent
	lda $00                                 ;C15024
	.db $D0,$67   ;C15026
	lda #$13                                ;C15028
	sta $00                                 ;C1502A
	jsl $C210AC                             ;C1502C
	jsl $C3631A                             ;C15030
	lda $00                                 ;C15034
	.db $30,$57   ;C15036
	ldy #$06                                ;C15038
	sty $02                                 ;C1503A
	ldy #$5C                                ;C1503C
	sty $03                                 ;C1503E
	lda $00                                 ;C15040
	pha                                     ;C15042
	jsl $C2007D                             ;C15043
	pla                                     ;C15047
	ldy $00                                 ;C15048
	.db $30,$43   ;C1504A
	sta $00                                 ;C1504C
	sty $02                                 ;C1504E
	phy                                     ;C15050
	jsl $C35B7A                             ;C15051
	sep #$20                                ;C15055
	lda $01,s                               ;C15057
	sta $00                                 ;C15059
	jsl $C277F8                             ;C1505B
	lda $01,s                               ;C1505F
	sta $00                                 ;C15061
	jsl $C20E7C                             ;C15063
	jsl $C62405                             ;C15067
	lda #$80                                ;C1506B
	sta $00                                 ;C1506D
	lda #$01                                ;C1506F
	sta $02                                 ;C15071
	jsl.l _SetEvent
	.db $7A,$A3,$01,$AA,$20   ;C1506C  
	.db $AC,$02,$22,$37,$24,$C6,$C2,$20,$68,$85,$00,$E2,$30,$A9,$01,$85   ;C1507C  
	.db $02,$28,$6B                       ;C1508C
@lbl_C1508F:
	rep #$20 ;A->16
	pla
	sta.b wTemp00
	sep #$30 ;AXY->8
	stz.b wTemp02
	plp
	rtl

func_C1509A:
	php
	sep #$30 ;AXY->8
	jsl.l Random
	lda.b wTemp00
	cmp.b #$10
	bcc @lbl_C150AB
	lda.b #$00
	plp
	rts
@lbl_C150AB:
	.db $A2,$00,$DA,$80,$14,$85,$00,$DA,$22,$10,$07,$C3,$FA,$A5,$00,$C9   ;C150AB
	.db $02,$D0,$05,$A3,$01,$1A,$83,$01,$E8,$BF,$4F,$89,$7E,$10,$E6,$68   ;C150BB
	.db $C9,$01,$F0,$04,$A9,$00,$28,$60   ;C150CB
	.db $A9,$01,$28,$60                   ;C150D3

.include "code/npc_events_script_manager.asm"
