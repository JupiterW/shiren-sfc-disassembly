 .bank $00
.org $0000 ;$C00000
.base $C0

.include "gfx/characters/character_sprites_pointer_table.asm"

func_C063B8:
	jsl.l func_C063BD
	rtl

func_C063BD:
	php
	rep #$20 ;A->16
	tdc
	sta.l $7E8462
	plp
	rtl

func_C063C7:
	php
	rep #$30 ;AXY->16
	lda.w #$0001
	sta.b wTemp00
	bra func_C063D6

func_C063D1:
	php
	rep #$30 ;AXY->16
	stz.b wTemp00
func_C063D6:
	jsl.l func_819038
	lda.w #$0000
	sta.l $7E80BC
	tdc
	sta.l $7E81B2
	sta.l $7E81A4
	sta.l $7E8462
	lda.w #$0010
	sta.b wTemp00
	jsl.l func_808F59
	jsl.l func_80B5D6
	lda.w #$00C0
	sta.l $7E80CC
	lda.w #$00A0
	sta.l $7E80CE
	sep #$20 ;A->8
	ldx.w #$0013
	tdc
@lbl_C0640F:
	sta.l $7E80D6,x
	sta.l $7E8112,x
	dex
	bpl @lbl_C0640F
	plp
	rtl

func_C0641C:
	php
	rep #$30 ;AXY->16
	lda.w #$0000
	sta.l $7E80BC
	lda.w #$0100
	sta.b wTemp00
	jsl.l func_809664
	jsl.l func_809684
	lda.w #$0000
	sta.b wTemp00
	jsl.l func_8081FA
	tdc
	sta.l $7E81B2
	sta.l $7E81A4
	lda.w #$0002
	sta.b wTemp00
	jsl.l func_80F3AE
	jsl.l func_80DF50
	jsl.l func_80F2FE
	jsl.l func_819046
	jsl.l func_80DF6B
	jsl.l DisplayAreaTitle
	stz.b wTemp01
	lda.b wTemp00
	sta.l $7E843C
	lda.w #$0014
	sta.b wTemp00
	jsl.l func_808F59
	lda.w #$0004
	sta.b wTemp00
	jsl.l func_808F85
	jsl.l func_8089F6
	lda.w #$000A
	sta.b wTemp00
	lda.w #$FF80
	sta.b wTemp02
	stz.b wTemp04
	jsl.l func_808A5C
	lda.w #$0000
	sta.b wTemp00
	lda.w #$FFA0
	sta.b wTemp02
	stz.b wTemp04
	jsl.l func_808A5C
	lda.w #$0000
	sta.b wTemp00
	lda.w #$0103
	sta.b wTemp02
	jsl.l func_808A5C
	lda.l $7E843C
	beq @lbl_C064BD
	lda.w #$0078
	sta.b wTemp00
	jsl.l func_808EC5
@lbl_C064BD:
	jsl.l func_8085B1
	lda.w #$0080
	sta.b wTemp00
	jsl.l func_809650
	jsl.l func_80854A
	jsl.l func_8190EC
	jsl.l func_80A645
	plp
	rtl

func_C064D8:
	php
	rep #$20 ;A->16
	jsl.l func_8191B1
	jsl.l func_809DBC
	jsl.l func_809684
	jsl.l func_8191BB
	lda.w #$000A
	sta.b wTemp00
	lda.w #$FFA0
	sta.b wTemp02
	stz.b wTemp04
	jsl.l func_808A5C
	jsl.l func_8085B1
	jsl.l func_80854A
	plp
	rtl

func_C06505:
	php
	rep #$30 ;AXY->16
	lda.w #$0000
	sta.l $7E80BC
	lda.w #$0100
	sta.b wTemp00
	jsl.l func_809664
	jsl.l func_809684
	lda.w #$0000
	sta.b wTemp00
	jsl.l func_8081FA
	tdc
	sta.l $7E81B2
	sta.l $7E81A4
	lda.w #$0002
	sta.b wTemp00
	jsl.l func_80F3AE
	jsl.l func_80DF50
	jsl.l func_80F2FE
	jsl.l func_819046
	jsl.l func_80DF6B
	jsl.l func_809DBC
	plp
	rtl

func_C0654D:
	php
	rep #$30 ;AXY->16
	jsl.l func_C07BB3
	lda.w #$0017
	sta.b wTemp00
	jsl.l func_808F59
	lda.w #$0100
	sta.b wTemp00
	jsl.l func_809650
	jsl.l func_80854A
	plp
	rtl

func_C0656C:
	php
	rep #$30 ;AXY->16
	lda.w #$0017
	sta.b wTemp00
	jsl.l func_808F59
	tdc
	tax
@lbl_C0657A:
	phx
	lda.w #$000A
	sta.b wTemp00
	lda.w #$FFC0
	sta.b wTemp02
	stx.b wTemp04
	jsl.l func_808A5C
	lda.w #$0000
	sta.b wTemp00
	lda.w #$0103
	sta.b wTemp02
	jsl.l func_808A5C
	jsl.l func_8085B1
	jsl.l func_80854A
	plx
	inx
	inx
	cpx.w #$0011
	bcc @lbl_C0657A
	lda.l $7E843C
	beq @lbl_C065E0
	jsl.l func_808EBA
	ldx.b wTemp00
	beq @lbl_C065DC
	lda.w #$0000
	sta.b wTemp00
	phx
	jsl.l func_80DD40
	plx
@lbl_C065C2:
	phx
	jsl.l func_80854A
	jsl.l func_808D3D
	lda.w #$0000
	sta.b wTemp00
	jsl.l GetJoypadPressed
	plx
	lda.b wTemp00
	bne @lbl_C065E0
	dex
	bpl @lbl_C065C2
@lbl_C065DC:
	jsl.l func_C5CF82
@lbl_C065E0:
	jsl.l func_808A00
	jsl.l func_8085B1
	jsl.l func_C5CFF6
	jsl.l func_80854A
	lda.w #$0000
	sta.b wTemp00
	lda.w #$F0FF
	sta.b wTemp02
	jsl.l func_80DD6E
	plp
	rtl
	php                                     ;C06600
	sep #$30                                ;C06601
	lda $7E81A4                             ;C06603
	beq @lbl_C06618                         ;C06607
	tax                                     ;C06609
	lda $7E81BA,x                           ;C0660A
	cmp #$14                                ;C0660E
	bcs @lbl_C06618                         ;C06610
	lda $02                                 ;C06612
	sta $7E823A,x                           ;C06614
@lbl_C06618:
	plp                                     ;C06618
	rtl                                     ;C06619
.ACCU 16
.INDEX 16

func_C0661A:
	jsl.l func_C210FF
	php
	sep #$30 ;AXY->8
	lda.l $7E81A4
	beq @lbl_C06631
	dec a
	dec a
	sta.l $7E81A4
	jsl.l func_C06BCA
@lbl_C06631:
	plp
	rtl
	php                                     ;C06633
	sep #$30                                ;C06634
	lda $7E81A4                             ;C06636
	beq @lbl_C0664F                         ;C0663A
	tax                                     ;C0663C
	lda $7E81BA,x                           ;C0663D
	cmp #$14                                ;C06641
	bcc @lbl_C0664F                         ;C06643
	cmp #$FF                                ;C06645
	bcs @lbl_C0664F                         ;C06647
	lda $02                                 ;C06649
	sta $7E823A,x                           ;C0664B
@lbl_C0664F:
	plp                                     ;C0664F
	rtl                                     ;C06650
	php                                     ;C06651
	sep #$30                                ;C06652
	lda $7E81A4                             ;C06654
	beq @lbl_C06669                         ;C06658
	tax                                     ;C0665A
	lda $7E81BA,x                           ;C0665B
	cmp #$FE                                ;C0665F
	bne @lbl_C06669                         ;C06661
	lda $02                                 ;C06663
	sta $7E823A,x                           ;C06665
@lbl_C06669:
	plp                                     ;C06669
	rtl                                     ;C0666A

func_C0666B:
	php
	sep #$30 ;AXY->8
	lda.b #$7E
	pha
	jsl.l func_C06E70
	plb
	ldx.w $81A6
	cpx.w $81A4
	bne @lbl_C06687
	plp
	sec
	rtl
@lbl_C06681:
	dec.w $81AE
	plp
	clc
	rtl
@lbl_C06687:
	rep #$20 ;A->16
	lda.w $823C,x
	sta.b wTemp02
	lda.w $82BC,x
	sta.b wTemp04
	lda.w $833C,x
	sta.b wTemp06
	lda.w $81BC,x
	sta.b wTemp00
	ldy.w $83BD,x
	inx
	inx
	stx.w $81A6
	ldx.w $81AE
	bne @lbl_C06681
	sep #$20 ;A->8
	cmp.b #$14
	bcs @lbl_C066C3
	pha
	phy
	jsl.l func_81C521
	ply
	pla
	sta.b wTemp00
	sty.b wTemp01
	jsl.l func_81C2DC
	plp
	clc
	rtl
@lbl_C066C3:
	cmp.b #$FC
	beq @lbl_C066EE
	cmp.b #$FD
	beq @lbl_C066FD
	cmp.b #$FE
	beq @lbl_C06717
	cmp.b #$FF
	beq @lbl_C0671F
	sec
	sbc.b #$1E
	sta.b wTemp00
	lda.b wTemp02
	bmi @lbl_C066E3
	jsl.l func_81C661
	plp
	clc
	rtl
@lbl_C066E3:
	and #$7F                                ;C066E3
	sta $02                                 ;C066E5
	jsl $81C7F0                             ;C066E7
	plp                                     ;C066EB
	clc                                     ;C066EC
	rtl                                     ;C066ED
@lbl_C066EE:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	jsl.l func_80B815
	plp
	clc
	rtl
@lbl_C066FD:
	lda.b wTemp04
	sta.b wTemp00
	lda.b wTemp05
	sta.b wTemp01
	lda.b wTemp02
	bne @lbl_C06710
;C06709  
	jsl $80B77A                             ;C06709
	plp                                     ;C0670D
	clc                                     ;C0670E
	rtl                                     ;C0670F
@lbl_C06710:
	jsl.l func_80B7E1
	plp
	clc
	rtl
@lbl_C06717:
	lda.b wTemp02
	bmi @lbl_C06722
	jsl.l func_81C874
@lbl_C0671F:
	plp
	clc
	rtl
@lbl_C06722:
	asl a
	tax
	lsr a
	rep #$20 ;A->16
	pea.w $671E
	jmp.w (Jumptable_C0672D,x)

Jumptable_C0672D:
	.dw func_C0673F
	.dw $679D
	.dw $679D
	.dw $679D
	.dw $674F
	.dw func_C0674A
	.dw func_C06740
	.dw $676D
	.dw $6777

func_C0673F:
	rts                                     ;C0673F
	
func_C06740:
	lda #$0041                              ;C06740
	sta $00                                 ;C06743
	jsl $818049                             ;C06745
	rts                                     ;C06749

func_C0674A:
	lda.w #$0041
	bra @lbl_C06752
	lda.w #$0041
@lbl_C06752:
	sta.b wTemp00
	jsl.l func_818049
	jsl.l func_80B5D6
	jsl.l func_80E68E
	jsl.l func_80B5D6
	jsl.l func_80BE23
	jsl.l func_80854A
	rts
	lda.w #$0012
	sta.b wTemp00
	jsl.l func_C06876
	rts
	lda #$00C5                              ;C06777
	sta $00                                 ;C0677A
	jsl $818049                             ;C0677C
	lda #$0012                              ;C06780
	sta $00                                 ;C06783
	jsl $C06876                             ;C06785
	lda #$020E                              ;C06789
	sta $00                                 ;C0678C
	lda #$0303                              ;C0678E
	sta $02                                 ;C06791
	lda #$022C                              ;C06793
	sta $04                                 ;C06796
	jsl $80D15A                             ;C06798
	rts                                     ;C0679C
	sta $8448                               ;C0679D
	stz $844A                               ;C067A0
	lda #$000C                              ;C067A3
	sta $844E                               ;C067A6
	lda $C067C3,x                           ;C067A9
	sta $02                                 ;C067AD
	lda $04                                 ;C067AF
	sta $844C                               ;C067B1
	phx                                     ;C067B4
	jsl $81C874                             ;C067B5
	plx                                     ;C067B9
	lda $C067C9,x                           ;C067BA
	sta $00                                 ;C067BE
	jsl $818049                             ;C067C0
	rts                                     ;C067C4
	tcs                                     ;C067C5
	.db $00   ;C067C6
	trb $1D00                               ;C067C7
	.db $00   ;C067CA
	dec a                                   ;C067CB
	.db $00   ;C067CC
	tsc                                     ;C067CD
	.db $00   ;C067CE
	bit $2200,x                             ;C067CF
	dec $C067,x                             ;C067D2
	jsl $C067F0                             ;C067D5
	jsl $C06ED7                             ;C067D9
	rtl                                     ;C067DD
	php                                     ;C067DE
	rep #$20                                ;C067DF
	lda #$0001                              ;C067E1
	sta $7E81B2                             ;C067E4
	lda $00                                 ;C067E8
	sta $7E81B4                             ;C067EA
	plp                                     ;C067EE
	rtl                                     ;C067EF
	php                                     ;C067F0
	rep #$20                                ;C067F1
	tdc                                     ;C067F3
	sta $7E81A6                             ;C067F4
	sta $7E81A4                             ;C067F8
	plp                                     ;C067FC
	rtl                                     ;C067FD

func_C067FE:
	php
	sep #$20 ;A->8
	lda.l $7E81AE
	inc a
	sta.l $7E81AE
	plp
	rtl

func_C0680C:
	php
	sep #$20 ;A->8
	lda.l $7E81A8
	inc a
	sta.l $7E81A8
	plp
	rtl

func_C0681A:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.w $81A6
	cpx.w $81A4
	beq @lbl_C0683A
	ldy.b #$01
@lbl_C0682B:
	lda.w $81BC,x
	cmp.b #$FF
	beq @lbl_C0683C
	iny
	inx
	inx
	cpx.w $81A4
	bne @lbl_C0682B
@lbl_C0683A:
	plp
	rtl
@lbl_C0683C:
	tya
	clc
	adc.w $81A8
	sta.w $81A8
	txa
	inx
	inx
	sta.w $81AC
	plp
	rtl
	php                                     ;C0684C
	sep #$20                                ;C0684D
	lda $7E81AA                             ;C0684F
	inc a                                   ;C06853
	sta $7E81AA                             ;C06854
	plp                                     ;C06858
	rtl                                     ;C06859
	php                                     ;C0685A
	rep #$20                                ;C0685B
	lda #$0010                              ;C0685D
	sta $7E8450                             ;C06860
	sta $7E8452                             ;C06864
	jsl $808D3D                             ;C06868
	jsl $808DAD                             ;C0686C
	jsl $8089F6                             ;C06870
	plp                                     ;C06874
	rtl                                     ;C06875
.ACCU 8

func_C06876:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.b wTemp00
	tdc
	lda.b wTemp01
	rep #$30 ;AXY->16
	sta.w $8458
	stz.w $8456
	stz.w $845A
	stz.w $845C
	stz.w $845E
	stz.w $8460
	stx.w $8454
	jmp.w (Jumptable_C0689C,x)

Jumptable_C0689C:
	.dw func_C068B2
	.dw $68C0
	.dw $68D5
	.dw $68E2
	.dw $68E9
	.dw $68E2
	.dw $68BE
	.dw $68BE
	.dw $68C7
	.dw $68BE
	.dw $68BE

func_C068B2:
	jsl.l func_808A07
	lda.b wTemp00
	beq @lbl_C068BE
;C068BA  
	jsl $808A00                             ;C068BA
@lbl_C068BE:
	plp
	rtl
	lda #$0010                              ;C068C0
	sta $7E8456                             ;C068C3
	jsl $808DAD                             ;C068C7
	jsl $808D3D                             ;C068CB
	jsl $8089F6                             ;C068CF
	plp                                     ;C068D3
	rtl                                     ;C068D4
	lda #$0010                              ;C068D5
	sta $7E8456                             ;C068D8
	jsl $808DAD                             ;C068DC
	plp                                     ;C068E0
	rtl                                     ;C068E1
	tdc
	sta.l $7E8456
	bra @lbl_C068F5
	tax
	lda.l UNREACH_C07247,x
	and.w #$00FF
	sta.l $7E8456
@lbl_C068F5:
	jsl.l func_808A07
	lda.b wTemp00
	bne @lbl_C06909
	jsl.l func_808DAD
	jsl.l func_808D3D
	jsl.l func_8089F6
@lbl_C06909:
	plp
	rtl

func_C0690B:
	php
	sep #$30 ;AXY->8
	lda.l $7E81A4
	cmp.b #$80
	bcs @lbl_C06926
	tax
	inc a
	inc a
	sta.l $7E81A4
	tdc
	lda.b wTemp00
	rep #$20 ;A->16
	sta.l $7E81BC,x
@lbl_C06926:
	plp
	rtl
	php                                     ;C06928
	sep #$30                                ;C06929
	ldx $00                                 ;C0692B
	tdc                                     ;C0692D
	sta $7E80D6,x                           ;C0692E
	lda #$02                                ;C06932
	sta $7E80EA,x                           ;C06934
	plp                                     ;C06938
	rtl                                     ;C06939
.ACCU 16

func_C0693A:
	php
	sep #$30 ;AXY->8
	lda.l $7E81A4
	cmp.b #$80
	bcs @lbl_C06952
	tax
	inc a
	inc a
	sta.l $7E81A4
	lda.b #$FF
	sta.l $7E81BC,x
@lbl_C06952:
	plp
	rtl
	php                                     ;C06954
	sep #$30                                ;C06955
	lda $7E81A4                             ;C06957
	cmp #$80                                ;C0695B
	bcs @lbl_C0697A                         ;C0695D
	tax                                     ;C0695F
	inc a                                   ;C06960
	inc a                                   ;C06961
	sta $7E81A4                             ;C06962
	lda #$FD                                ;C06966
	sta $7E81BC,x                           ;C06968
	lda $00                                 ;C0696C
	sta $7E823C,x                           ;C0696E
	rep #$20                                ;C06972
	lda $04                                 ;C06974
	sta $7E82BC,x                           ;C06976
@lbl_C0697A:
	plp                                     ;C0697A
	rtl                                     ;C0697B
.ACCU 8

func_C0697C:
	php
	sep #$30 ;AXY->8
	lda.l $7E81A4
	cmp.b #$80
	bcs @lbl_C069E2
	tax
	inc a
	inc a
	sta.l $7E81A4
	lda.b #$FD
	sta.l $7E81BC,x
	rep #$20 ;A->16
	lda.b wTemp04
	sta.l $7E82BC,x
	sep #$20 ;A->8
	lda.b wTemp00
	cmp.b #$FF
	beq @lbl_C069BD
	phx
	jsl.l GetItemDisplayInfo
	plx
	lda.b wTemp00
	inc a
	ldy.b wTemp05
	cpy.b #$E6
	beq @lbl_C069BD
	ldy.b wTemp01
	cpy.b #$7B
	bne @lbl_C069BE
;C069B9
	lda #$0D                                ;C069B9
	.db $80,$01   ;C069BB
@lbl_C069BD:
	tdc
@lbl_C069BE:
	clc
	adc.b #$E5
	sta.l $7E823C,x
	rep #$20 ;A->16
	lda.l $7E82BC,x
	sta.b wTemp00
	sep #$20 ;A->8
	phx
	jsl.l GetItemData
	plx
	lda.b wTemp01
	cmp.b #$80
	beq @lbl_C069E2
	bcc @lbl_C069E2
;C069DD
	tdc                                     ;C069DD
	sta $7E823C,x                           ;C069DE
@lbl_C069E2:
	plp
	rtl

func_C069E4:
	php
	sep #$30 ;AXY->8
	lda.l $7E81A4
	cmp.b #$80
	bcs @lbl_C06A0C
	tax
	inc a
	inc a
	sta.l $7E81A4
	lda.b #$FC
	sta.l $7E81BC,x
	rep #$20 ;A->16
	lda.b wTemp04
	sta.l $7E82BC,x
	sep #$20 ;A->8
	lda.b wTemp00
	sta.l $7E823C,x
@lbl_C06A0C:
	plp
	rtl

func_C06A0E:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.w $81A4
	cpx.b #$80
	bcs @lbl_C06A37
	lda.b #$FE
	sta.w $81BC,x
	rep #$20 ;A->16
	lda.b wTemp02
	sta.w $823C,x
	lda.b wTemp04
	sta.w $82BC,x
	lda.b wTemp06
	sta.w $833C,x
	inx
	inx
	stx.w $81A4
@lbl_C06A37:
	plp
	rtl

func_C06A39:
	php
	sep #$30 ;AXY->8
	jsl.l func_C210FF
	bankswitch 0x7E
	ldx.w $81A4
	cpx.b #$80
	bcs @lbl_C06A64
	lda.b #$FE
	sta.w $81BC,x
	rep #$20 ;A->16
	lda.b wTemp02
	sta.w $823C,x
	lda.b wTemp04
	sta.w $82BC,x
	sta.w $833C,x
	inx
	inx
	stx.w $81A4
@lbl_C06A64:
	plp
	rtl
	php                                     ;C06A66
	rep #$20                                ;C06A67
	sep #$10                                ;C06A69
	lda $02                                 ;C06A6B
	asl a                                   ;C06A6D
	tax                                     ;C06A6E
	lda $C06A7D,x                           ;C06A6F
	sta $04                                 ;C06A73
	sta $06                                 ;C06A75
	jsl $C06A0E                             ;C06A77
	plp                                     ;C06A7B
	rtl                                     ;C06A7C
	.db $00   ;C06A7D
	.db $00   ;C06A7E
	.db $00   ;C06A7F
	.db $00   ;C06A80
	.db $00   ;C06A81
	.db $00   ;C06A82
	.db $00   ;C06A83
	.db $00   ;C06A84
	.db $00   ;C06A85
	.db $00   ;C06A86
	.db $00   ;C06A87
	.db $00   ;C06A88
	.db $02   ;C06A89
	tsb $0F                                 ;C06A8A
	tsb $06                                 ;C06A8C
	ora $09                                 ;C06A8E
	phd                                     ;C06A90
	.db $0D   ;C06A91
	.db $07   ;C06A92

func_C06A93:
	php
	rep #$20 ;A->16
	lda.l $7E8442
	bne @lbl_C06AAC
	lda.b wTemp00
	cmp.l $7E843E
	bne @lbl_C06AAC
	lda.b wTemp02
	cmp.l $7E8440
	beq @lbl_C06AC7
@lbl_C06AAC:
	lda.b wTemp00
	sta.l $7E8444
	sta.l $7E843E
	lda.b wTemp02
	sta.l $7E8446
	sta.l $7E8440
	lda.w #$0001
	sta.l $7E8442
@lbl_C06AC7:
	plp
	rtl

func_C06AC9:
	php
	rep #$20 ;A->16
	lda.l $7E8442
	bne @lbl_C06AE2
	lda.b wTemp00
	cmp.l $7E843E
	bne @lbl_C06AE2
	lda.b wTemp02
	cmp.l $7E8440
	beq @lbl_C06B3D
@lbl_C06AE2:
	lda.b wTemp00
	sta.l $7E8444
	sta.l $7E843E
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	pha
	lda.b wTemp02
	sta.l $7E8446
	sta.l $7E8440
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	pha
	lda.w #$0001
	sta.l $7E8442
	jsl.l func_80854A
	lda.b wTemp03,s
	sta.b wTemp00
	lda.b wTemp01,s
	sta.b wTemp01
	jsl.l FindRoomContainingCoord
	lda.b wTemp00
	sta.l $7E80D4
	lda.l $7E843E
	sta.b wTemp02
	lda.l $7E8440
	sta.b wTemp04
	jsl.l func_80B161
	jsl.l func_819734
	pla
	sta.b wTemp02
	pla
	sta.b wTemp00
	jsl.l func_80BDFD
@lbl_C06B3D:
	plp
	rtl
	php                                     ;C06B3F
	rep #$20                                ;C06B40
	tdc                                     ;C06B42
	sta $7E8442                             ;C06B43
	plp                                     ;C06B47
	rtl                                     ;C06B48

func_C06B49:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldx.w $81A4
	cpx.b #$80
	bcs @lbl_C06B9A
	rep #$20 ;A->16
	lda.b wTemp00
	adc.w #$011E
	sta.w $81BC,x
	lda.b wTemp02
	sta.w $823C,x
	lda.b wTemp04
	sta.w $82BC,x
	lda.b wTemp06
	sta.w $833C,x
	sep #$20 ;A->8
	phx
	call_savebank GetItemDisplayInfo
	plx
	lda.b wTemp05
	cmp.b #$E6
	beq @lbl_C06B8D
	lda.b wTemp01
	cmp.b #Item_InvisibleItem
	bne @lbl_C06B95
;C06B86
	lda #$0D                                ;C06B86
	sta $81BD,x                             ;C06B88
	.db $80,$08   ;C06B8B
@lbl_C06B8D:
	lda $823D,x                             ;C06B8D
	ora #$80                                ;C06B90
	sta $823D,x                             ;C06B92
@lbl_C06B95:
	inx
	inx
	stx.w $81A4
@lbl_C06B9A:
	plp
	rtl
	php                                     ;C06B9C
	sep #$30                                ;C06B9D
	lda #$7E                                ;C06B9F
	pha                                     ;C06BA1
	plb                                     ;C06BA2
	ldx $81A4                               ;C06BA3
	cpx #$80                                ;C06BA6
	bcs @lbl_C06BC8                         ;C06BA8
	rep #$20                                ;C06BAA
	lda $00                                 ;C06BAC
	adc #$011E                              ;C06BAE
	sta $81BC,x                             ;C06BB1
	lda $02                                 ;C06BB4
	sta $823C,x                             ;C06BB6
	lda $04                                 ;C06BB9
	sta $82BC,x                             ;C06BBB
	lda $06                                 ;C06BBE
	sta $833C,x                             ;C06BC0
	inx                                     ;C06BC3
	inx                                     ;C06BC4
	stx $81A4                               ;C06BC5
@lbl_C06BC8:
	plp                                     ;C06BC8
	rtl                                     ;C06BC9
.ACCU 8

func_C06BCA:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	ldx.b #$7E
	phx
	plb
	ldx.w $81A4
	cpx.b #$80
	bcc @lbl_C06BDC
;C06BDA
	plp                                     ;C06BDA
	rtl                                     ;C06BDB
@lbl_C06BDC:
	lda.b wTemp04
	sta.w $82BC,x
	lda.b wTemp06
	sta.w $833C,x

func_C06BE6:
	txa
	inc a
	inc a
	sta.w $81A4
	lda.b wTemp00
	tay
	clc
	adc.w #$0100
	sta.w $81BC,x
	lda.b wTemp02
	sta.w $823C,x
	sep #$20 ;A->8
	cpy.b #$13
	bne @lbl_C06C2D
	lda.w $819E
	bne @lbl_C06C20
	rep #$20 ;A->16
	lda.w $82BC,x
	cmp.w $81A0
	beq @lbl_C06C18
	sta.w $81A0
	lda.w #$FFFF
	bra @lbl_C06C1B
@lbl_C06C18:
	lda.w #$0001
@lbl_C06C1B:
	sta.w $819E
	sep #$20 ;A->8
@lbl_C06C20:
	phx
	jsl.l func_C28603
	plx
	stz.b wTemp06
	lda.w $81BD,x
	bra @lbl_C06C4C
@lbl_C06C2D:
	phx
	jsl.l func_C28603
	plx
	lda.w $81BD,x
	ldy.b wTemp07
	beq @lbl_C06C4C
	sta $01                                 ;C06C3A
	lda $823C,x                             ;C06C3C
	cmp #$82                                ;C06C3F
	.db $B0,$09   ;C06C41
	jsl $81933D                             ;C06C43
	lda $01                                 ;C06C47
	sta $81BD,x                             ;C06C49
@lbl_C06C4C:
	cmp.b #$01
	bne @lbl_C06C59
	lda.b wTemp02
	beq @lbl_C06C59
;C06C54
	lda #$06                                ;C06C54
	sta $823D,x                             ;C06C56
@lbl_C06C59:
	lda.b wTemp06
	ora.b wTemp00
	beq @lbl_C06C67
	lda.w $823D,x
	ora.b #$80
	sta.w $823D,x
@lbl_C06C67:
	lda.w $81BC,x
	sta.b wTemp00
	phx
	jsl.l func_C28E94
	plx
	lda.b wTemp00
	sta.l $7E83BC,x
	lda.b wTemp01
	sta.l $7E83BD,x
	plp
	rtl

func_C06C80:
	php
	rep #$20 ;A->16
	sep #$10 ;XY->8
	ldx.b #$7E
	phx
	plb
	ldx.w $81A4
	cpx.b #$80
	bcs @lbl_C06CB7
	lda.b wTemp04
	sta.w $82BC,x
	lda.b wTemp06
	sta.w $833C,x
	lda.b wTemp00
	tay
	clc
	adc.w #$0100
	sta.w $81BC,x
	lda.b wTemp02
	sta.w $823C,x
	lda.w $8111,y
	and.w #$FF00
	sta.w $83BC,x
	inx
	inx
	stx.w $81A4
@lbl_C06CB7:
	plp
	rtl

func_C06CB9:
	php
	sep #$10 ;XY->8
	jsl.l func_C210FF
	bra func_C06CDA

func_C06CC2:
	php
	sep #$10 ;XY->8
	jsl.l func_C210FF
	ldx.b wTemp06
	stx.b wTemp01
	bra func_C06CDA
	php                                     ;C06CCF
	sep #$10                                ;C06CD0
	ldy $01                                 ;C06CD2
	jsl $C210FF                             ;C06CD4
	sty $01                                 ;C06CD8
func_C06CDA:
	rep #$20 ;A->16
	ldx.b #$7E
	phx
	plb
	ldx.w $81A4
	cpx.b #$80
	bcs @lbl_C06CF2
	lda.b wTemp04
	sta.w $82BC,x
	sta.w $833C,x
	jmp.w func_C06BE6
@lbl_C06CF2:
	plp                                     ;C06CF2
	rtl                                     ;C06CF3

func_C06CF4:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	ldy.b wTemp00
	lda.b wTemp01
	inc a
	sta.w $80D6,y
	lda.w $80EA,y
	beq @lbl_C06D6F
	lda.b wTemp03
	sta.w $818A,y
	lda.b wTemp04
	sta.w $8162,y
	lda.b wTemp05
	sta.w $8176,y
	phy
	jsl.l func_C28603
	ply
	lda.b wTemp02
	bne @lbl_C06D29
	lda.b wTemp05
	beq @lbl_C06D2D
	lda.b #$01
	bra @lbl_C06D33
@lbl_C06D29:
	lda #$05                                ;C06D29
	.db $80,$06   ;C06D2B
@lbl_C06D2D:
	ldx.b wTemp04
	lda.l DATA8_C06DD6,x
@lbl_C06D33:
	sta.w $80FE,y
	tdc
	cpy.b #$13
	beq @lbl_C06D4F
	lda.b wTemp07
	beq @lbl_C06D4D
	lda $80D6,y                             ;C06D3F
	sta $01                                 ;C06D42
	jsl $81933D                             ;C06D44
	lda $01                                 ;C06D48
	sta $80D6,y                             ;C06D4A
@lbl_C06D4D:
	lda.b wTemp06
@lbl_C06D4F:
	ora.b wTemp00
	beq @lbl_C06D5B
	lda.w $818A,y
	ora.b #$80
	sta.w $818A,y
@lbl_C06D5B:
	lda.b #$02
	sta.w $80EA,y
	sty.b wTemp00
	phy
	jsl.l func_C28E94
	ply
	lda.b wTemp01
	sta.w $8112,y
	plp
	rtl
@lbl_C06D6F:
	lda.b wTemp03
	sta.w $814E,y
	lda.b wTemp04
	sta.w $8126,y
	lda.b wTemp05
	sta.w $813A,y
	phy
	jsl.l func_C28603
	ply
	lda.b wTemp02
	bne @lbl_C06D90
	lda.b wTemp05
	beq @lbl_C06D94
	lda.b #$01
	bra @lbl_C06D9A
@lbl_C06D90:
	lda #$05                                ;C06D90
	.db $80,$06   ;C06D92
@lbl_C06D94:
	ldx.b wTemp04
	lda.l DATA8_C06DD9,x
@lbl_C06D9A:
	sta.w $80FE,y
	tdc
	cpy.b #$13
	beq @lbl_C06DB6
	lda.b wTemp07
	beq @lbl_C06DB4
	lda.w $80D6,y
	sta.b wTemp01
	jsl.l func_81933D
	lda.b wTemp01
	sta.w $80D6,y
@lbl_C06DB4:
	lda.b wTemp06
@lbl_C06DB6:
	ora.b wTemp00
	beq @lbl_C06DC2
	lda.w $814E,y
	ora.b #$80
	sta.w $814E,y
@lbl_C06DC2:
	lda.b #$01
	sta.w $80EA,y
	sty.b wTemp00
	phy
	jsl.l func_C28E94
	ply
	lda.b wTemp01
	sta.w $8112,y
	plp
	rtl

DATA8_C06DD6:
	.db $0A,$0E,$12                       ;C06DD6

DATA8_C06DD9:
	.db $09,$0D,$11                       ;C06DD9

DATA8_C06DDC:
	.db $08,$0C,$10                       ;C06DDC

func_C06DDF:
	php
	sep #$30 ;AXY->8
	inc.b wTemp01
	lda.b #$01
	tsb.b wTemp02
	lda.b wTemp06
	ldx.b wTemp00
	sta.l $7E8112,x
	pha
	jsl.l func_81C322
	pla
	sta.b wTemp01
	jsl.l func_81C2DC
	plp
	rtl

func_C06DFE:
	php
	rep #$30 ;AXY->16
	lda.l $7E8462
	tax
	cpx.w #$0080
	bcs @lbl_C06E26
	phx
	jsl.l func_C4B94F
	plx
	lda.b wTemp00
	sta.l $7E8466,x
	lda.l $7E81A4
	sta.l $7E84E6,x
	inx
	inx
	txa
	sta.l $7E8462
@lbl_C06E26:
	plp
	rtl
	php                                     ;C06E28
	rep #$30                                ;C06E29
	lda $7E8464                             ;C06E2B
	cmp $7E8462                             ;C06E2F
	beq @lbl_C06E49                         ;C06E33
	tax                                     ;C06E35
	lda $7E81A4                             ;C06E36
	beq @lbl_C06E46                         ;C06E3A
	lda $7E81A6                             ;C06E3C
	cmp $7E84E6,x                           ;C06E40
	bcc @lbl_C06E49                         ;C06E44
@lbl_C06E46:
	plp                                     ;C06E46
	clc                                     ;C06E47
	rtl                                     ;C06E48
@lbl_C06E49:
	plp                                     ;C06E49
	sec                                     ;C06E4A
	rtl                                     ;C06E4B

func_C06E4C:
	php
	rep #$30 ;AXY->16
	lda.l $7E8464
	cmp.l $7E8462
	beq @lbl_C06E6D
	tax
	inc a
	inc a
	sta.l $7E8464
	lda.l $7E8466,x
	sta.b wTemp00
	jsl.l func_80EC2C
	plp
	clc
	rtl
@lbl_C06E6D:
	plp                                     ;C06E6D
	sec                                     ;C06E6E
	rtl                                     ;C06E6F

func_C06E70:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	rep #$30 ;AXY->16
	lda.w $8464
	cmp.w $8462
	beq @lbl_C06EC6
	tax
	lda.w $81A4
	beq @lbl_C06E96
@lbl_C06E87:
	lda.w $84E6,x
	cmp.w $81A6
	beq @lbl_C06E91
	bcs @lbl_C06EC6
@lbl_C06E91:
	cmp.w $81AC
	bcc @lbl_C06EC3
@lbl_C06E96:
	lda.w $8464
	tax
	inc a
	inc a
	sta.w $8464
	lda.w $81AA
	bne @lbl_C06EAF
	lda.w $8466,x
	sta.b wTemp00
	call_savebank func_80EC2C
@lbl_C06EAF:
	lda.w $8464
	tax
	cmp.w $8462
	bne @lbl_C06E87
	lda.w $81AA
	beq @lbl_C06EC0
;C06EBD  
	dec $81AA                               ;C06EBD
@lbl_C06EC0:
	plp
	clc
	rtl
@lbl_C06EC3:
	stz $81AA                               ;C06EC3
@lbl_C06EC6:
	plp
	sec
	rtl

func_C06EC9:
	php
	sep #$20 ;A->8
	lda.l $7E81B8
	inc a
	sta.l $7E81B8
	plp
	rtl
	php                                     ;C06ED7
	rep #$20                                ;C06ED8
	tdc                                     ;C06EDA
	sta $7E8464                             ;C06EDB
	sta $7E8462                             ;C06EDF
	plp                                     ;C06EE3
	rtl                                     ;C06EE4
.ACCU 8

func_C06EE5:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	rep #$30 ;AXY->16
	stz.w $843C
	ldx.w $80CC
	ldy.w $80CE
	lda.w $8442
	beq @lbl_C06F02
	ldx.w $8444
	ldy.w $8446
@lbl_C06F02:
	stx.w $843E
	sty.w $8440
	lda.w $8448
	beq @lbl_C06F10
;C06F0D
	jsr $6F85                               ;C06F0D
@lbl_C06F10:
	ldx.w $8454
	beq func_C06F2F
	pea.w $6F70
	jmp.w (Jumptable_C06F1B-2,x)

;jumptable
Jumptable_C06F1B:
	.dw $6F8C
	.dw $6FA5
	.dw $7005
	.dw $702C
	.dw $7061
	.dw $70F6
	.dw $7104
	.dw $7132
	.dw $717A
	.dw $71D5

func_C06F2F:
	lda.w $8450
	beq @lbl_C06F74
	dec $8452                               ;C06F34
	bpl @lbl_C06F44                         ;C06F37
	lda #$0001                              ;C06F39
	sta $81B6                               ;C06F3C
	stz $8450                               ;C06F3F
	.db $80,$2D   ;C06F42
@lbl_C06F44:
	phb                                     ;C06F44
	lda #$000A                              ;C06F45
	sta $00                                 ;C06F48
	lda #$0008                              ;C06F4A
	sta $02                                 ;C06F4D
	lda $8452                               ;C06F4F
	sta $04                                 ;C06F52
	jsl $808A5C                             ;C06F54
	lda #$000A                              ;C06F58
	sta $00                                 ;C06F5B
	lda #$FEC0                              ;C06F5D
	sta $02                                 ;C06F60
	lda $7E8452                             ;C06F62
	sta $04                                 ;C06F66
	jsl $808A5C                             ;C06F68
	jsl $8085B1                             ;C06F6C
	plb                                     ;C06F70
	inc.w $843C
@lbl_C06F74:
	lda.w $843C
	sta.b wTemp04
	lda.w $843E
	sta.b wTemp00
	lda.w $8440
	sta.b wTemp02
	plp
	rtl

	inc $843C                               ;C06F85
	stz $8448                               ;C06F88
	rts                                     ;C06F8B
	dec $845A                               ;C06F8C
	bpl @lbl_C06FCC                         ;C06F8F
	lda #$0003                              ;C06F91
	sta $845A                               ;C06F94
	dec $8456                               ;C06F97
	bpl @lbl_C06FCF                         ;C06F9A
	phb                                     ;C06F9C
	jsl $808D4E                             ;C06F9D
	plb                                     ;C06FA1
	jmp $70EE                               ;C06FA2
	dec $845A                               ;C06FA5
	bpl @lbl_C06FCC                         ;C06FA8
	lda #$0003                              ;C06FAA
	sta $845A                               ;C06FAD
	inc $8456                               ;C06FB0
	lda $8456                               ;C06FB3
	cmp #$0010                              ;C06FB6
	bne @lbl_C06FCF                         ;C06FB9
	phb                                     ;C06FBB
	jsl $808A00                             ;C06FBC
	stz $00                                 ;C06FC0
	stz $02                                 ;C06FC2
	jsl $8087FF                             ;C06FC4
	plb                                     ;C06FC8
	jmp $70EE                               ;C06FC9
@lbl_C06FCC:
	jmp $70F1                               ;C06FCC
@lbl_C06FCF:
	phb                                     ;C06FCF
	lda #$000C                              ;C06FD0
	sta $00                                 ;C06FD3
	lda #$0001                              ;C06FD5
	sta $02                                 ;C06FD8
	lda #$7FFF                              ;C06FDA
	sta $04                                 ;C06FDD
	lda $8456                               ;C06FDF
	sta $06                                 ;C06FE2
	jsl $808A5C                             ;C06FE4
	lda #$000C                              ;C06FE8
	sta $00                                 ;C06FEB
	lda #$FFC0                              ;C06FED
	sta $02                                 ;C06FF0
	lda #$7FFF                              ;C06FF2
	sta $04                                 ;C06FF5
	lda $7E8456                             ;C06FF7
	sta $06                                 ;C06FFB
	jsl $808A5C                             ;C06FFD
	plb                                     ;C07001
	jmp $70F1                               ;C07002
	dec.w $845A
	bpl @lbl_C0705E
	ldx.w $8458
	lda.l UNREACH_C0721D,x
	and.w #$00FF
	sta.w $845A
	inc.w $8456
	lda.l UNREACH_C07247,x
	and.w #$00FF
	cmp.w $8456
	bcs @lbl_C07097
	sta.w $8456
	jmp.w func_C070EE
	dec.w $845A
	bpl @lbl_C0705E
	ldx.w $8458
@lbl_C07034:
	lda.l UNREACH_C07232,x
	and.w #$00FF
	sta.w $845A
	dec.w $8456
	lda.w $8456
	bpl @lbl_C07097
	phb
	lda.w #$0000
	sta.b wTemp00
	lda.l UNREACH_C0729B,x
	sta.b wTemp02
	jsl.l func_808A5C
	jsl.l func_808A00
	plb
	jmp.w func_C070EE
@lbl_C0705E:
	jmp.w func_C070F1
	dec.w $845A
	bpl @lbl_C0705E
	ldx.w $8458
	lda.w $845C
	bne @lbl_C07034
	lda.l UNREACH_C0721D,x
	and.w #$00FF
	sta.w $845A
	inc.w $8456
	lda.l UNREACH_C07247,x
	and.w #$00FF
	cmp.w $8456
	bcs @lbl_C07097
	sta.w $8456
	inc.w $845C
	lda.l UNREACH_C0725C,x
	and.w #$00FF
	sta.w $845A
@lbl_C07097:
	lda.w $8458
	asl a
	tax
	lda.l UNREACH_C0729B,x
	sta.b wTemp02
	lda.l UNREACH_C07271,x
	sta.b wTemp00
	cmp.w #$000C
	beq @lbl_C070CC
	cmp.w #$000A
	beq @lbl_C070DD
	cmp.w #$0006
	beq @lbl_C070DD
	lda.l UNREACH_C072C5,x
	sta.b wTemp04
	bpl @lbl_C070E6
	lda.w $8456
	sta.b wTemp06
	call_savebank func_808A10
	bra @lbl_C070E6
@lbl_C070CC:
	lda.l UNREACH_C072C5,x
	sta.b wTemp04
	lda.w #$0010
	sec
	sbc.w $8456
	sta.b wTemp06
	bra @lbl_C070E6
@lbl_C070DD:
	lda #$0010                              ;C070DD
	sec                                     ;C070E0
	sbc $8456                               ;C070E1
	sta $04                                 ;C070E4
@lbl_C070E6:
	call_savebank func_808A5C
	bra func_C070F1

func_C070EE:
	stz.w $8454
func_C070F1:
	jsl.l func_8085B1
	rts
	lda.w #$0788
	sta.b wTemp00
	jsl.l func_8089AA
	jsl.l func_8085B1
	rts
	phb                                     ;C07104
	lda #$0000                              ;C07105
	sta $00                                 ;C07108
	lda #$0180                              ;C0710A
	sta $02                                 ;C0710D
	jsl $808A5C                             ;C0710F
	lda #$000A                              ;C07113
	sta $00                                 ;C07116
	lda #$01A0                              ;C07118
	sta $02                                 ;C0711B
	stz $04                                 ;C0711D
	jsl $808A5C                             ;C0711F
	jsl $8085B1                             ;C07123
	lda #$0608                              ;C07127
	sta $00                                 ;C0712A
	jsl $C06876                             ;C0712C
	plb                                     ;C07130
	rts                                     ;C07131
	lda $845A                               ;C07132
	bne @lbl_C0716D                         ;C07135
	inc $845A                               ;C07137
	lda #$0003                              ;C0713A
	sta $845C                               ;C0713D
	phb                                     ;C07140
	lda #$0010                              ;C07141
	sta $00                                 ;C07144
	lda #$FC80                              ;C07146
	sta $02                                 ;C07149
	lda #$7FFF                              ;C0714B
	sta $04                                 ;C0714E
	jsl $808A5C                             ;C07150
	lda #$0010                              ;C07154
	sta $00                                 ;C07157
	lda #$FEA0                              ;C07159
	sta $02                                 ;C0715C
	lda #$7FFF                              ;C0715E
	sta $04                                 ;C07161
	jsl $808A5C                             ;C07163
	jsl $8085B1                             ;C07167
	plb                                     ;C0716B
	rts                                     ;C0716C
@lbl_C0716D:
	dec $845C                               ;C0716D
	bpl @lbl_C07179                         ;C07170
	jsl $808A00                             ;C07172
	stz $8454                               ;C07176
@lbl_C07179:
	rts                                     ;C07179
	dec.w $845A
	bpl @lbl_C071C0
	lda.w #$0001
	sta.w $845A
	inc.w $845C
	lda.w $845C
	bit.w #$0001
	beq @lbl_C071C1
	phb
	jsl.l func_8089F6
	lda.w #$0010
	sta.b wTemp00
	lda.w #$FC80
	sta.b wTemp02
	lda.w #$7FFF
	sta.b wTemp04
	jsl.l func_808A5C
	lda.w #$0010
	sta.b wTemp00
	lda.w #$FEA0
	sta.b wTemp02
	lda.w #$7FFF
	sta.b wTemp04
	jsl.l func_808A5C
	jsl.l func_8085B1
	plb
@lbl_C071C0:
	rts
@lbl_C071C1:
	jsl.l func_808A00
	jsl.l func_8085B1
	lda.w $845C
	cmp.w #$0008
	bcc @lbl_C071D4
	stz.w $8454
@lbl_C071D4:
	rts
	dec.w $845A
	bpl @lbl_C07208
	lda.w #$0000
	sta.w $845A
	inc.w $845C
	lda.w $845C
	bit.w #$0001
	beq @lbl_C07209
	phb
	jsl.l func_8089F6
	lda.w #$0010
	sta.b wTemp00
	lda.w #$CEC0
	sta.b wTemp02
	lda.w #$7FFF
	sta.b wTemp04
	jsl.l func_808A5C
	jsl.l func_8085B1
	plb
@lbl_C07208:
	rts
@lbl_C07209:
	jsl.l func_808A00
	jsl.l func_8085B1
	lda.w $845C
	cmp.w #$0004
	bcc @lbl_C0721C
	stz.w $8454
@lbl_C0721C:
	rts

UNREACH_C0721D:
	ora ($00,x)                             ;C0721D
	ora ($00,x)                             ;C0721F
	ora ($01,x)                             ;C07221
	.db $00   ;C07223
	.db $00   ;C07224
	ora ($00,x)                             ;C07225
	ora ($00,x)                             ;C07227
	.db $00   ;C07229
	.db $00   ;C0722A
	.db $00   ;C0722B
	.db $00   ;C0722C
	.db $00   ;C0722D
	.db $00   ;C0722E
	.db $00   ;C0722F
	ora ($01,x)                             ;C07230

UNREACH_C07232:
	ora ($00,x)                             ;C07232
	ora ($00,x)                             ;C07234
	ora ($01,x)                             ;C07236
	.db $00   ;C07238
	ora ($00,x)                             ;C07239
	.db $00   ;C0723B
	.db $02   ;C0723C
	.db $02   ;C0723D
	.db $02   ;C0723E
	ora ($00,x)                             ;C0723F
	.db $00   ;C07241
	.db $00   ;C07242
	.db $00   ;C07243
	.db $00   ;C07244
	ora ($01,x)                             ;C07245

UNREACH_C07247:
	asl $10                                 ;C07247
	asl $10                                 ;C07249
	.db $10,$10   ;C0724B
	bpl @lbl_C07257                         ;C0724D
	ora #$0C10                              ;C0724F
	tsb $100C                               ;C07252
	.db $10,$10   ;C07255
@lbl_C07257:
	php                                     ;C07257
	asl $0810                               ;C07258
	.db $10   ;C0725B

UNREACH_C0725C:
	ora $050F05                             ;C0725C
	ora [$07]                               ;C07260
	.db $00   ;C07262
	ora ($01,x)                             ;C07263
	ora [$1F]                               ;C07265
	ora [$17],y                             ;C07267
	ora [$17],y                             ;C07269
	ora [$01],y                             ;C0726B
	ora $010103                             ;C0726D

UNREACH_C07271:
	.db $02   ;C07271
	.db $00   ;C07272
	.db $02   ;C07273
	.db $00   ;C07274
	.db $02   ;C07275
	.db $00   ;C07276
	.db $02   ;C07277
	.db $00   ;C07278
	.db $02   ;C07279
	.db $00   ;C0727A
	.db $02   ;C0727B
	.db $00   ;C0727C
	asl a                                   ;C0727D
	.db $00   ;C0727E
	asl a                                   ;C0727F
	.db $00   ;C07280
	asl a                                   ;C07281
	.db $00   ;C07282
	tsb $0200                               ;C07283
	.db $00   ;C07286
	.db $02   ;C07287
	.db $00   ;C07288
	.db $02   ;C07289
	.db $00   ;C0728A
	.db $02   ;C0728B
	.db $00   ;C0728C
	tsb $0C00                               ;C0728D
	.db $00   ;C07290
	tsb $0C00                               ;C07291
	.db $00   ;C07294
	tsb $00                                 ;C07295
	asl a                                   ;C07297
	.db $00   ;C07298
	tsb $00                                 ;C07299

UNREACH_C0729B:
	ldy #$A001                              ;C0729B
	ora ($A0,x)                             ;C0729E
	ora ($A0,x)                             ;C072A0
	tsb $20C0                               ;C072A2
	cpy #$A020                              ;C072A5
	ora ($80,x)                             ;C072A8
	ora ($80,x)                             ;C072AA
	jsr ($FEC0,x)                           ;C072AC
	ldy #$C00E                              ;C072AF
	dec $FEC0                               ;C072B2
	ldy #$C00F                              ;C072B5
	jsr $20C0                               ;C072B8
	cpy #$A0FE                              ;C072BB
	ora ($C0,x)                             ;C072BE
	sbc $8001A0,x                           ;C072C0
	.db $01   ;C072C4

UNREACH_C072C5:
	.db $10,$82,$80,$F8,$10,$82,$1F,$80,$1F,$80,$1F,$80,$00,$00,$00,$00   ;C072C5  
	.db $00,$00,$FF,$7F                   ;C072D5
	.db $FF,$FF,$FF,$FF,$FF,$FF,$10,$82,$E0,$7F,$F0,$43,$1F,$00,$84,$50   ;C072D9
	.db $FF,$CF,$00,$00,$FF,$FF           ;C072E9  

func_C072EF:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	rep #$20 ;A->16
	stz.w $8454
	stz.w $8442
	stz.w $8448
	stz.w $8450
	stz.w $81A6
	stz.w $8464
	stz.w $81B6
	stz.w $81AE
	stz.w $81AA
	stz.w $81AC
	stz.w $81B0
	lda.w #$0005
	sta.w $80BC
	jsl.l func_80B5D6
	jsl.l func_81A61D
	jsl.l func_C5CFFB
	plp
	rtl
	php                                     ;C0732D
	rep #$30                                ;C0732E
	lda #$0001                              ;C07330
	sta $7E81A2                             ;C07333
	.db $80,$08   ;C07337

func_C07339:
	php
	rep #$30 ;AXY->16
	tdc
	sta.l $7E81A2
	lda.l $7E81A4
	ora.l $7E8462
	bne @lbl_C0735A
	tdc
	sta.l $7E81B2
	sta.l $7E81A4
	sta.l $7E8462
	plp
	rtl
@lbl_C0735A:
	lda.w #$0013
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.l $7E81B2
	beq @lbl_C0738E
	tdc                                     ;C07369
	sta $7E81B0                             ;C0736A
	lda $7E81B4                             ;C0736E
	sep #$20                                ;C07372
	clc                                     ;C07374
	adc #$05                                ;C07375
	sec                                     ;C07377
	sbc $00                                 ;C07378
	.db $90,$CF   ;C0737A
	cmp #$0B                                ;C0737C
	.db $B0,$CB   ;C0737E
	xba                                     ;C07380
	adc #$04                                ;C07381
	sec                                     ;C07383
	sbc $01                                 ;C07384
	.db $90,$C3   ;C07386
	cmp #$09                                ;C07388
	.db $B0,$BF   ;C0738A
	rep #$20                                ;C0738C
@lbl_C0738E:
	lda.l $7E819E
	bne @lbl_C073A4
	lda.l $7E81A4
	beq @lbl_C073B4
	lda.b wTemp00
	cmp.l $7E81A0
	beq @lbl_C073B4
;C073A2  
	.db $80,$06   ;C073A2
@lbl_C073A4:
	bpl @lbl_C073B4
	lda $7E81A0                             ;C073A6
	pha                                     ;C073AA
	jsr $7554                               ;C073AB
	pla                                     ;C073AE
	sta $00                                 ;C073AF
	jsr $7C05                               ;C073B1
@lbl_C073B4:
	jsl.l func_C28B23
	ldx.w #$0001
	stz.b wTemp01
	lda.b wTemp00
	bne @lbl_C073D1
	jsl.l func_C627F1
	stz.b wTemp01
	lda.b wTemp00
	cmp.w #$0000
	beq @lbl_C073D1
	ldx.w #$0000
@lbl_C073D1:
	stx.b wTemp00
	jsl.l func_80F375
	jsl.l func_C072EF
	jsl.l func_80B5D6
	lda.l debugMode
	bne @lbl_C073F5
;C073E5
	lda #$0002                              ;C073E5
	sta $00                                 ;C073E8
	jsl $80DC0C                             ;C073EA
	lda $00                                 ;C073EE
	bit #$0010                              ;C073F0
	.db $D0,$28   ;C073F3
@lbl_C073F5:
	jsl.l func_C0666B
	bcc @lbl_C073FE
	jmp.w @lbl_C074C8
@lbl_C073FE:
	tdc
	sta.l $7E81A8
	sta.l $7E81B8
	lda.l $7E81A2
	beq @lbl_C07420
	lda #$0000                              ;C0740D
	sta $00                                 ;C07410
	jsl $80DC69                             ;C07412
	lda $00                                 ;C07416
	bit #$F0FF                              ;C07418
	.db $F0,$03   ;C0741B
	jmp $750B                               ;C0741D
@lbl_C07420:
	jsl.l func_C06EE5
	lda.b wTemp04
	pha
	jsl.l func_81A65E
	pla
	clc
	adc.b wTemp00
	pha
	lda.l $7E8442
	beq @lbl_C0746E
	lda.l $7E843E
	clc
	adc.w #$0010
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b wTemp00
	lda.l $7E8440
	clc
	adc.w #$0010
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b wTemp01
	jsl.l FindRoomContainingCoord
	lda.b wTemp00
	sta.l $7E80D4
	lda.l $7E843E
	sta.b wTemp02
	lda.l $7E8440
	sta.b wTemp04
	jsl.l func_80B161
@lbl_C0746E:
	lda.l $7E843E
	sta.b wTemp00
	lda.l $7E8440
	sta.b wTemp02
	jsl.l func_80C593
	jsl.l func_80D19F
	jsl.l func_81C29C
	jsl.l func_80B5DD
	bcc @lbl_C07496
	jsl $80854A                             ;C0748C
	jsl $80BE23                             ;C07490
	.db $80,$0A   ;C07494
@lbl_C07496:
	jsl.l func_80854A
	lda.l $7E81B0
	bne @lbl_C0750A
	lda.l $7E81A8
	beq @lbl_C074B3
@lbl_C074A6:
	pha
	jsl.l func_C0666B
	pla
	dec a
	bne @lbl_C074A6
	pla
@lbl_C074B0:
	jmp.w @lbl_C073FE
@lbl_C074B3:
	lda.l $7E81B8
	beq @lbl_C074C2
@lbl_C074B9:
	pha
	jsl.l func_C06E4C
	pla
	dec a
	bne @lbl_C074B9
@lbl_C074C2:
	pla
	bne @lbl_C074B0
	jmp.w @lbl_C073F5
@lbl_C074C8:
	jsl.l func_C06E70
	bcc @lbl_C074C8
	jsl.l func_C07BB3
	tdc
	sta.l $7E81A4
	sta.l $7E8462
	lda.l $7E81A2
	bne @lbl_C0751E
	lda.l $7E81B6
	beq @lbl_C07504
	jsl $80854A                             ;C074E7
	lda #$0100                              ;C074EB
	sta $00                                 ;C074EE
	jsl $809664                             ;C074F0
	jsl $809684                             ;C074F4
	jsl $808A00                             ;C074F8
	jsl $8085B1                             ;C074FC
	jsl $80854A                             ;C07500
@lbl_C07504:
	jsl.l func_C5D05D
	plp
	rtl
@lbl_C0750A:
	pla                                     ;C0750A
	jsl $81BEED                             ;C0750B
	tdc                                     ;C0750F
	sta $7E81A4                             ;C07510
	sta $7E8462                             ;C07514
	jsr $7524                               ;C07518
	plp                                     ;C0751B
	sec                                     ;C0751C
	rtl                                     ;C0751D
@lbl_C0751E:
	jsr $7524                               ;C0751E
	plp                                     ;C07521
	clc                                     ;C07522
	rtl                                     ;C07523
	lda $7E81A2                             ;C07524
	beq @lbl_C07537                         ;C07528
	lda #$0100                              ;C0752A
	sta $00                                 ;C0752D
	jsl $809664                             ;C0752F
	jsl $809684                             ;C07533
@lbl_C07537:
	jsl $808A07                             ;C07537
	lda $00                                 ;C0753B
	beq @lbl_C07553                         ;C0753D
	jsl $80854A                             ;C0753F
	jsl $808A00                             ;C07543
	jsl $808D4E                             ;C07547
	jsl $8085B1                             ;C0754B
	jsl $80854A                             ;C0754F
@lbl_C07553:
	rts                                     ;C07553
	php                                     ;C07554
	sep #$20                                ;C07555
	rep #$10                                ;C07557
	lda #$7E                                ;C07559
	pha                                     ;C0755B
	plb                                     ;C0755C
	ldx #$0013                              ;C0755D
	lda #$01                                ;C07560
@lbl_C07562:
	sta $80EA,x                             ;C07562
	dex                                     ;C07565
	bpl @lbl_C07562                         ;C07566
	ldx $81A4                               ;C07568
	beq @lbl_C07598                         ;C0756B
	ldx #$0000                              ;C0756D
@lbl_C07570:
	tdc                                     ;C07570
	lda $81BC,x                             ;C07571
	cmp #$14                                ;C07574
	bcs @lbl_C07591                         ;C07576
	sta $00                                 ;C07578
	tay                                     ;C0757A
	lda $80EA,y                             ;C0757B
	beq @lbl_C07591                         ;C0757E
	tdc                                     ;C07580
	sta $80EA,y                             ;C07581
	ldy $82BC,x                             ;C07584
	sty $04                                 ;C07587
	phx                                     ;C07589
	phb                                     ;C0758A
	jsl $81C482                             ;C0758B
	plb                                     ;C0758F
	plx                                     ;C07590
@lbl_C07591:
	inx                                     ;C07591
	inx                                     ;C07592
	cpx $81A4                               ;C07593
	bne @lbl_C07570                         ;C07596
@lbl_C07598:
	ldx #$0013                              ;C07598
@lbl_C0759B:
	lda $80EA,x                             ;C0759B
	beq @lbl_C075B6                         ;C0759E
	stx $00                                 ;C075A0
	phx                                     ;C075A2
	jsl $C210D4                             ;C075A3
	plx                                     ;C075A7
	lda $00                                 ;C075A8
	beq @lbl_C075B6                         ;C075AA
	stx $00                                 ;C075AC
	phx                                     ;C075AE
	phb                                     ;C075AF
	jsl $81C482                             ;C075B0
	plb                                     ;C075B4
	plx                                     ;C075B5
@lbl_C075B6:
	dex                                     ;C075B6
	bpl @lbl_C0759B                         ;C075B7
	plp                                     ;C075B9
	rts                                     ;C075BA
.ACCU 16

func_C075BB:
	php
	rep #$30 ;AXY->16
	lda.w #$0000
	sta.b wTemp00
	jsl.l func_80DD40
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_81A0EE
	jsl.l func_80854A
	jsl.l func_C072EF
	lda.l $7E81A4
	beq @lbl_C07634
@lbl_C075E5:
	jsl.l func_C0666B
	bcs @lbl_C07634
@lbl_C075EB:
	tdc
	sta.l $7E81A8
	lda.w #$0000
	sta.b wTemp00
	jsl.l func_80DCC6
	lda.b wTemp00
	bit.w #$F0FF
	beq @lbl_C07603
@lbl_C07600:
	jmp $7643                               ;C07600
@lbl_C07603:
	lda.l $7E81B0
	bne @lbl_C07600
	jsl.l func_C06EE5
	lda.b wTemp04
	pha
	jsl.l func_81A65E
	pla
	clc
	adc.b wTemp00
	pha
	jsl.l func_80854A
	lda.l $7E81A8
	beq @lbl_C0762F
@lbl_C07623:
	pha
	jsl.l func_C0666B
	pla
	dec a
	bne @lbl_C07623
	pla
@lbl_C0762D:
	bra @lbl_C075EB
@lbl_C0762F:
	pla
	bne @lbl_C0762D
	bra @lbl_C075E5
@lbl_C07634:
	tdc
	sta.l $7E81A4
	sta.l $7E8462
	jsr.w func_C07656
	plp
	clc
	rtl
	jsl $81BEED                             ;C07643
	tdc                                     ;C07647
	sta $7E81A4                             ;C07648
	sta $7E8462                             ;C0764C
	jsr $7656                               ;C07650
	plp                                     ;C07653
	sec                                     ;C07654
	rtl                                     ;C07655

func_C07656:
	jsl.l func_808A07
	lda.b wTemp00
	beq @lbl_C07662
;C0765E  
	jsl $808A00                             ;C0765E
@lbl_C07662:
	rts

func_C07663:
	php
	rep #$30 ;AXY->16
	tdc
	sta.l $7E81BA
	inc a
	sta.l $7E81A8
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_81A0EE
	jsl.l func_80854A
	jsl.l func_C072EF
	plp
	rtl

func_C0768A:
	php
	rep #$30 ;AXY->16
	lda.l $7E81A8
	beq @lbl_C0769E
@lbl_C07693:
	pha
	jsl.l func_C0666B
	pla
	dec a
	bne @lbl_C07693
	bra @lbl_C076AA
@lbl_C0769E:
	lda.l $7E81BA
	bne @lbl_C076AA
	jsl.l func_C0666B
	bcs @lbl_C076CE
@lbl_C076AA:
	tdc
	sta.l $7E81A8
	lda.l $7E81B0
	beq @lbl_C076B8
;C076B5  
	jmp $7643                               ;C076B5
@lbl_C076B8:
	jsl.l func_C06EE5
	lda.b wTemp04
	pha
	jsl.l func_81A65E
	pla
	clc
	adc.b wTemp00
	sta.l $7E81BA
	plp
	clc
	rtl
@lbl_C076CE:
	tdc
	sta.l $7E81A4
	sta.l $7E81A6
	sta.l $7E8462
	sta.l $7E81BA
	sta.l $7E81A8
	jsr.w func_C07656
	plp
	sec
	rtl

func_C076E9:
	php
	sep #$30 ;AXY->8
	lda.l debugMode
	bne @lbl_C07712
	lda #$02                                ;C076F2
	sta $00                                 ;C076F4
	jsl $80DC0C                             ;C076F6
	lda $00                                 ;C076FA
	bit #$10                                ;C076FC
	.db $F0,$12   ;C076FE
	jsl $80E7DF                             ;C07700
	jsl $80E69B                             ;C07704
	jsl $80E8C5                             ;C07708
	jsl $C07BB3                             ;C0770C
	plp                                     ;C07710
	rtl                                     ;C07711
@lbl_C07712:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStatusEffects
	stz.b wTemp01
	stz.b wTemp00
	lda.b wTemp02
	bne @lbl_C07728
	lda.b wTemp03
	beq @lbl_C07728
	inc.b wTemp00
@lbl_C07728:
	jsl.l func_81A169
	bankswitch 0x7E
	ldy.b #$13
@lbl_C07732:
	lda.w $80EA,y
	beq @lbl_C07767
	lda.w $80FE,y
	sta.b wTemp02
	sty.b wTemp00
	lda.w $80D6,y
	sta.b wTemp01
	beq @lbl_C07754
	lda.w $814E,y
	sta.b wTemp03
	lda.w $8126,y
	sta.b wTemp04
	lda.w $813A,y
	sta.b wTemp05
@lbl_C07754:
	phy
	call_savebank func_81C322
	ply
	sty.b wTemp00
	lda.w $8112,y
	sta.b wTemp01
	jsl.l func_81C2DC
@lbl_C07767:
	dey
	bpl @lbl_C07732
	lda.w $8139
	sta.w $81A0
	lda.w $814D
	sta.w $81A1
	rep #$30 ;AXY->16
	stz.w $819E
	lda.w #$0004
	sta.w $80BC
	lda.w $80C4
	sta.w $80C0
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80C8
	lda.w $80C6
	sta.w $80C2
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80CA
	lda.w $8139
	and.w #$00FF
	sta.w $80C4
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80CC
	lda.w $814D
	and.w #$00FF
	sta.w $80C6
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80CE
	lda.w $80C4
	sta.b wTemp00
	lda.w $80C6
	sta.b wTemp01
	jsl.l FindRoomContainingCoord
	lda.b wTemp00
	bpl @lbl_C077D5
	ldx.w $80C8
	ldy.w $80CA
	bra @lbl_C077DB
@lbl_C077D5:
	ldx.w $80CC
	ldy.w $80CE
@lbl_C077DB:
	sta.w $80D4
	stx.b wTemp02
	sty.b wTemp04
	call_savebank func_80B177
	lda.w $80C4
	sec
	sbc.w $80C0
	tax
	asl a
	sta.w $80D0
	lda.w $80C6
	sec
	sbc.w $80C2
	tay
	asl a
	sta.w $80D2
	inx
	cpx.w #$0003
	bcs @lbl_C0780C
	iny
	cpy.w #$0003
	bcc @lbl_C07812
@lbl_C0780C:
	jsl $C07BB3                             ;C0780C
	plp                                     ;C07810
	rtl                                     ;C07811
@lbl_C07812:
	stz.w $80BE
	jsl.l func_81A0AB

func_C07819:
	lda.w $80D0
	clc
	adc.w $80C8
	sta.w $80C8
	sta.b wTemp00
	lda.w $80D2
	clc
	adc.w $80CA
	sta.w $80CA
	sta.b wTemp02
	call_savebank func_80C593
	lda.w $80BE
	cmp.w #$000F
	beq @lbl_C078A0
	inc a
	sta.w $80BE
	sta.b wTemp04
	asl a
	tax
	lda.l Jumptable_C07989-2,x
	phb
	pha
	lda.w $80C8
	sta.b wTemp00
	lda.w $80CA
	sta.b wTemp02
	jsl.l func_81A104
	ldy.b wTemp00
	phy
	jsl.l func_80D19F
	jsl.l func_81C29C
	ply
	rts
	jsl.l func_80E8ED
	jsl.l func_80E8D2
@lbl_C07870:
	jsl.l func_80854A
	plb
	jmp.w func_C07819
	tya
	beq @lbl_C07881
	jsl.l func_80E7DF
	bra @lbl_C07870
@lbl_C07881:
	plb
	jsl.l func_80E7DF
	jsl.l func_80E69B
	jsl.l func_81A074
	jsl.l func_80B5DD
	bcc @lbl_C078C6
	jsl $80854A                             ;C07894
	.db $80,$3A   ;C07898
	jsl.l func_80E69B
	bra @lbl_C07870
@lbl_C078A0:
	jsl.l func_80B5DD
	php
	jsl.l func_81A074
	lda.l $7E80C8
	sta.b wTemp00
	lda.l $7E80CA
	sta.b wTemp02
	plp
	bcs @lbl_C078D0
	stz.b wTemp04
	jsl.l func_81A104
	jsl.l func_80D19F
	jsl.l func_81C29C
@lbl_C078C6:
	jsl.l func_80854A
	jsl.l func_80BE5F
	plp
	rtl
@lbl_C078D0:
	jsl.l func_8196DC
	lda.l $7E80C4
	sta.b wTemp00
	lda.l $7E80C6
	sta.b wTemp02
	jsl.l func_80BDFD
	jsl.l func_80BE5F
	plp
	rtl
	tya
	bne @lbl_C07870
	lda.w #$0008
	sta.l $7E80BE
	jsl.l func_81A074
	jsl.l func_80E8ED
	jsl.l func_80E8D2
	jsl.l func_81A0C8
	jsl.l func_80854A
	plb
	sep #$30 ;AXY->8
	ldx.b #$12
@lbl_C0790D:
	lda.w $80EA,x
	bne @lbl_C07952
	stx.b wTemp00
	phx
	jsl.l func_C210D4
	plx
	lda.b wTemp00
	beq @lbl_C0797E
	ldy.b wTemp03
	stx.b wTemp00
	phx
	phy
	jsl.l func_C28603
	ply
	plx
	sty.b wTemp03
	lda.b wTemp02
	bne @lbl_C07938
	lda.b wTemp05
	beq @lbl_C0793C
	lda.b #$00
	bra @lbl_C07944
@lbl_C07938:
	lda.b #$04
	bra @lbl_C07944
@lbl_C0793C:
	txy
	ldx.b wTemp04
	lda.l DATA8_C06DDC,x
	tyx
@lbl_C07944:
	sta.b wTemp02
	stx.b wTemp00
	phx
	call_savebank func_81C4C6
	plx
	bra @lbl_C0797E
@lbl_C07952:
	cmp.b #$02
	bne @lbl_C0797B
	stx.b wTemp00
	lda.w $80D6,x
	sta.b wTemp01
	beq @lbl_C07973
	lda.w $818A,x
	sta.b wTemp03
	lda.w $80FE,x
	sta.b wTemp02
	lda.w $8162,x
	sta.b wTemp04
	lda.w $8176,x
	sta.b wTemp05
@lbl_C07973:
	phx
	call_savebank func_81C322
	plx
@lbl_C0797B:
	stz.w $80EA,x
@lbl_C0797E:
	dex
	bpl @lbl_C0790D
	stz.w $80FD
	rep #$30 ;AXY->16
	jmp.w func_C07819

;jumptable
;c07989
Jumptable_C07989:
	sbc #$6F78                              ;C07989
	sei                                     ;C0798C
	adc $786F78                             ;C0798D
	adc [$78]                               ;C07991
	adc $786F78                             ;C07993
	ora $79,s                               ;C07997
	adc [$78],y                             ;C07999
	adc $786F78                             ;C0799B
	adc $789978                             ;C0799F
	adc $786F78                             ;C079A3

func_C079A7:
	php
	sep #$30 ;AXY->8
	bankswitch 0x7E
	rep #$30 ;AXY->16
	lda.w #$0004
	sta.w $80BC
	jsl.l func_81A0AB
	stz.w $80BE
@lbl_C079BD:
	inc.w $80BE
	lda.w $80BE
	cmp.w #$0011
	bcs @lbl_C079F3
	sta.b wTemp04
	lda.w $80CC
	sta.b wTemp00
	lda.w $80CE
	sta.b wTemp02
	call_savebank func_81A104
	jsl.l func_80854A
	lda.w #$0000
	sta.b wTemp00
	call_savebank func_80DCC6
	lda.b wTemp00
	bit.w #$F0FF
	beq @lbl_C079BD
	plp
	sec
	rtl
@lbl_C079F3:
	plp
	clc
	rtl

func_C079F6:
	php
	sep #$30 ;AXY->8
	jsl.l GetStairsDirection
	lda.b wTemp00
	pha
	cmp.b #$02
	beq @lbl_C07A09
	ldx.b #$FF
	jmp.w func_C07A9C
@lbl_C07A09:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	lda.b wTemp01
	pha
	lda.b wTemp00
	pha
	dec.b wTemp01
	jsl.l GetItemData
	ldy.b wTemp01
	lda.b wTemp01,s
	sta.b wTemp00
	lda.b wTemp02,s
	inc a
	sta.b wTemp01
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C07A40
	cpy.b #$83
	beq @lbl_C07A54
	jsl $C359AF                             ;C07A32
	lda $02                                 ;C07A36
	bit #$80                                ;C07A38
	.db $F0,$18   ;C07A3A
	ldx #$06                                ;C07A3C
	.db $80,$5A   ;C07A3E
@lbl_C07A40:
	jsl.l GetItemData
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C07A54
	lda.b wTemp01
	cmp.b #$83
	beq @lbl_C07A54
	ldx.b #$02
	bra @lbl_C07A9A
@lbl_C07A54:
	lda.b wTemp01,s
	dec a
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	jsl.l GetItemData
	ldy.b wTemp01
	lda.b wTemp01,s
	inc a
	sta.b wTemp00
	lda.b wTemp02,s
	sta.b wTemp01
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C07A84
	cpy.b #$83
	beq @lbl_C07A98
	jsl.l GetItemData
	lda.b wTemp02
	bit.b #$80
	beq @lbl_C07A98
	ldx.b #$00
	bra @lbl_C07A9A
@lbl_C07A84:
	jsl.l GetItemData
	lda.b wTemp02
	bit.b #$80
	bne @lbl_C07A98
	lda.b wTemp01
	cmp.b #$83
	beq @lbl_C07A98
	ldx.b #$04
	bra @lbl_C07A9A
@lbl_C07A98:
	ldx #$FF                                ;C07A98
@lbl_C07A9A:
	pla
	pla

func_C07A9C:
	phx
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C210FF
	plx
	bmi @lbl_C07AC5
	lda.b #$7F
	trb.b wTemp03
	txa
	tsb.b wTemp03
	lda.l DATA8_C07B9D,x
	clc
	adc.b wTemp04
	sta.b wTemp04
	lda.l DATA8_C07BA5,x
	clc
	adc.b wTemp05
	sta.b wTemp05
	jsl.l func_C06CF4
@lbl_C07AC5:
	pla
	asl a
	tax
	rep #$20 ;A->16
	lda.l DATA8_C07BAD
	sta.b wTemp00
	sep #$20 ;A->8
	jsl.l func_818049
	bankswitch 0x7E
	lda.w $80FD
	beq @lbl_C07B11
	lda.w $8111
	sta.b wTemp02
	lda.w $80E9
	sta.b wTemp01
	beq @lbl_C07AFA
	lda.w $8161
	sta.b wTemp03
	lda.w $8139
	sta.b wTemp04
	lda.w $814D
	sta.b wTemp05
@lbl_C07AFA:
	lda.b #$13
	sta.b wTemp00
	call_savebank func_81C322
	lda.b #$13
	sta.b wTemp00
	lda.w $8125
	sta.b wTemp01
	jsl.l func_81C2DC
@lbl_C07B11:
	rep #$30 ;AXY->16
	lda.w #$0006
	sta.w $80BC
	lda.w $80C4
	sta.w $80C0
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80C8
	lda.w $80C6
	sta.w $80C2
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80CA
	stz.w $80D0
	stz.w $80D2
	jsl.l func_81A0AB
	lda.w #$00B4
	sta.b wTemp00
	jsl.l func_809664
	stz.w $80BE
@lbl_C07B49:
	inc.w $80BE
	lda.w $80BE
	sta.b wTemp04
	lda.w $80C8
	sta.b wTemp00
	lda.w $80CA
	sta.b wTemp02
	phb
	jsl.l func_81A104
	jsl.l func_80D19F
	jsl.l func_81C29C
	jsl.l func_80854A
	jsl.l func_80D19F
	jsl.l func_81C29C
	jsl.l func_80854A
	jsl.l func_80969A
	plb
	lda.b wTemp00
	beq @lbl_C07B9B
	lda.w #$0000
	sta.b wTemp00
	call_savebank GetJoypadPressed
	lda.b wTemp00
	bit.w #$F0FF
	beq @lbl_C07B49
	jsl.l func_80967A
	jsl.l func_80854A
@lbl_C07B9B:
	plp
	rtl

DATA8_C07B9D:
	.db $01                               ;C07B9D
	.db $01                               ;C07B9E  
	.db $00                               ;C07B9F
	.db $FF                               ;C07BA0  
	.db $FF                               ;C07BA1
	.db $FF,$00,$01                       ;C07BA2  

DATA8_C07BA5:
	.db $00                               ;C07BA5
	.db $FF                               ;C07BA6  
	.db $FF                               ;C07BA7
	.db $FF                               ;C07BA8  
	.db $00                               ;C07BA9
	.db $01,$01,$01                       ;C07BAA  

DATA8_C07BAD:
	.db $4E,$00                           ;C07BAD
	.db $4D,$00,$4D,$00                   ;C07BAF  

func_C07BB3:
	php
	sep #$30 ;AXY->8
	jsl.l func_C07DB7
	jsl.l func_80B5D6
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStatusEffects
	lda.b wTemp02
	bne @lbl_C07BCE
	lda.b wTemp03
	bne @lbl_C07BD6
@lbl_C07BCE:
	stz.b wTemp01
	stz.b wTemp00
	jsl.l func_81A169
@lbl_C07BD6:
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterMapInfo
	jsr.w func_C07C05
	rep #$20 ;A->16
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_81A0EE
	jsl.l func_80D19F
	jsl.l func_81C29C
	jsl.l func_80854A
	jsl.l func_80BE5F
	plp
	rtl

func_C07C05:
	php
	sep #$20 ;A->8
	bankswitch 0x7E
	tdc
	lda.b wTemp00
	sta.w $8139
	lda.b wTemp01
	sta.w $814D
	rep #$30 ;AXY->16
	sta.w $80C2
	sta.w $80C6
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80CA
	sta.w $80CE
	lda.b wTemp00
	sta.w $81A0
	stz.w $819E
	and.w #$00FF
	sta.w $80C0
	sta.w $80C4
	xba
	lsr a
	lsr a
	lsr a
	sta.w $80C8
	sta.w $80CC
	stz.w $80D0
	stz.w $80D2
	lda.w #$0001
	sta.w $80BC
	jsl.l FindRoomContainingCoord
	lda.b wTemp00
	sta.w $80D4
	lda.w $80CC
	sta.b wTemp02
	lda.w $80CE
	sta.b wTemp04
	jsl.l func_80B161
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_8196DC
	lda.l $7E80C4
	sta.b wTemp00
	lda.l $7E80C6
	sta.b wTemp02
	jsl.l func_80BDFD
	plp
	rts

func_C07C89:
	php
func_C07C8A:
	rep #$20 ;A->16
	lda.l $7E80BC
	cmp.w #$0002
	beq @lbl_C07CA9
	cmp.w #$0003
	beq @lbl_C07CA9
	lda.w #$0002
	sta.l $7E80BC
	jsl.l func_C07DB7
	jsl.l func_C07D52
@lbl_C07CA9:
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_81A12A
	jsl.l func_80D19F
	jsl.l func_81C29C
	jsl.l func_80854A
	plp
	rtl

func_C07CC7:
	php
	sep #$20 ;A->8
	lda.b #$13
	sta.b wTemp00
	jsl.l GetCharacterStatusEffects
	lda.b wTemp02
	bne func_C07C8A
	lda.b wTemp03
	beq func_C07C8A
	rep #$20 ;A->16
	lda.l $7E80BC
	cmp.w #$0002
	beq @lbl_C07CF2
	cmp.w #$0003
	beq @lbl_C07CF9
	jsl.l func_C07DB7
	jsl.l func_C07D52
@lbl_C07CF2:
	lda.w #$0003
	sta.l $7E80BC
@lbl_C07CF9:
	rep #$20 ;A->16
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_81A141
	jsl.l func_80D19F
	jsl.l func_81C29C
	jsl.l func_80854A
	plp
	rtl

func_C07D19:
	php
	rep #$20 ;A->16
	jsl.l func_81A1A8
	lda.b wTemp00
	beq @lbl_C07D47
	lda #$0002                              ;C07D24
	sta $7E80BC                             ;C07D27
	lda $7E80CC                             ;C07D2B
	sta $00                                 ;C07D2F
	lda $7E80CE                             ;C07D31
	sta $02                                 ;C07D35
	jsl $81A12A                             ;C07D37
	jsl $80D19F                             ;C07D3B
	jsl $81C29C                             ;C07D3F
	jsl $80854A                             ;C07D43
@lbl_C07D47:
	plp
	rtl

func_C07D49:
	jsl.l func_80D19F
	jsl.l func_81C29C
	rtl

func_C07D52:
	php
	rep #$20 ;A->16
	lda.l $7E8139
	sta.b wTemp00
	lda.l $7E814D
	sta.b wTemp01
	jsl.l FindRoomContainingCoord
	lda.b wTemp00
	sta.l $7E80D4
	lda.l $7E80CC
	sta.b wTemp02
	lda.l $7E80CE
	sta.b wTemp04
	jsl.l func_80B161
	lda.l $7E80CC
	sta.b wTemp00
	lda.l $7E80CE
	sta.b wTemp02
	jsl.l func_80ADC2
	plp
	rtl
	php                                     ;C07D8D
	rep #$20                                ;C07D8E
	lda $00                                 ;C07D90
	pha                                     ;C07D92
	jsl $C07DB7                             ;C07D93
	pla                                     ;C07D97
	sta $00                                 ;C07D98
	sep #$30                                ;C07D9A
	jsr $7C05                               ;C07D9C
	rep #$20                                ;C07D9F
	lda $7E80CC                             ;C07DA1
	sta $00                                 ;C07DA5
	lda $7E80CE                             ;C07DA7
	sta $02                                 ;C07DAB
	jsl $81A0EE                             ;C07DAD
	jsl $80854A                             ;C07DB1
	plp                                     ;C07DB5
	rtl                                     ;C07DB6
.INDEX 16

func_C07DB7:
	php
	sep #$30 ;AXY->8
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C28603
	bankswitch 0x7E
	ldx.b #$13
@lbl_C07DC8:
	stz.w $80EA,x
	dex
	bpl @lbl_C07DC8
	lda.b wTemp02
	bne @lbl_C07DDA
	lda.b wTemp05
	beq @lbl_C07DDE
	lda.b #$03
	bra @lbl_C07DE4
@lbl_C07DDA:
	lda #$07                                ;C07DDA
	.db $80,$06   ;C07DDC
@lbl_C07DDE:
	ldx.b wTemp04
	lda.l DATA8_C07E8B,x
@lbl_C07DE4:
	sta.b wTemp02
	ldy.b wTemp00
	lda.b #$13
	sta.b wTemp00
	phx
	jsl.l func_C210D4
	plx
	lda.b wTemp00
	beq @lbl_C07E00
	tya
	beq @lbl_C07DFD
;C07DF9
	lda #$80                                ;C07DF9
	tsb $03                                 ;C07DFB
@lbl_C07DFD:
	lda.b wTemp01
	inc a
@lbl_C07E00:
	sta.b wTemp01
	lda.b #$13
	sta.b wTemp00
	call_savebank func_81C322
	lda.b #$13
	sta.b wTemp00
	jsl.l func_C28E94
	lda.b #$13
	sta.b wTemp00
	jsl.l func_81C2DC
	ldy.b #$12
@lbl_C07E1E:
	sty.b wTemp00
	jsl.l func_C210D4
	lda.b wTemp00
	beq @lbl_C07E5D
	sty.b wTemp00
	phy
	jsl.l func_C28603
	ply
	lda.b wTemp02
	bne @lbl_C07E3C
	lda.b wTemp05
	beq @lbl_C07E40
	lda.b #$03
	bra @lbl_C07E46
@lbl_C07E3C:
	lda.b #$07
	bra @lbl_C07E46
@lbl_C07E40:
	ldx.b wTemp04
	lda.l DATA8_C07E8B,x
@lbl_C07E46:
	sta.b wTemp02
	ldx.b wTemp07
	phx
	lda.b wTemp06
	ora.b wTemp00
	beq @lbl_C07E61
	sty.b wTemp00
	jsl.l func_C210D4
	lda.b #$80
	tsb.b wTemp03
	bra @lbl_C07E67
@lbl_C07E5D:
	stz.b wTemp01
	bra @lbl_C07E70
@lbl_C07E61:
	sty.b wTemp00
	jsl.l func_C210D4
@lbl_C07E67:
	inc.b wTemp01
	plx
	beq @lbl_C07E70
	jsl.l func_81933D
@lbl_C07E70:
	sty.b wTemp00
	phy
	jsl.l func_81C322
	ply
	sty.b wTemp00
	phy
	jsl.l func_C28E94
	ply
	sty.b wTemp00
	jsl.l func_81C2DC
	dey
	bpl @lbl_C07E1E
	plp
	rtl

DATA8_C07E8B:
	.db $0B,$0F,$13                       ;C07E8B
