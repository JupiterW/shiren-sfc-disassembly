.def CURR_ADDR 0
.def CURR_BANK 0

;Thanks to ExHiROM!
;Includes data from a file, allowing for bank boundary crossing
.macro filedata
    .fopen \1 FP\@
    .fsize FP\@ SIZE
    .rept SIZE
        .fread FP\@ DATA
        .db DATA
        .redef CURR_ADDR CURR_ADDR+1
        .if CURR_ADDR == $10000
            .redef CURR_BANK CURR_BANK+1
            .redef CURR_ADDR $0
            .bank CURR_BANK
            .org $0
        .endif
    .endr
    .fclose FP\@
    .undef SIZE
    .undef DATA
.endm

;Outputs the given array as 3 separate arrays for each byte
;1: array, 2: array length
.macro array24
	\1LowByte:
	.define i\@ 0
	.rept \2
		.arrayout \1 i\@ arrayOut
		.db (arrayOut & 0xFF)
		.redef i\@ i\@ + 1
	.endr
	\1MiddleByte:
	.redef i\@ 0
	.rept \2
		.arrayout \1 i\@ arrayOut
		.db ((arrayOut >> 8) & 0xFF)
		.redef i\@ i\@ + 1
	.endr
	\1HighByte:
	.redef i\@ 0
	.rept \2
		.arrayout \1 i\@ arrayOut
		.db ((arrayOut >> 16) & 0xFF)
		.redef i\@ i\@ + 1
	.endr
.endm

; Shared expected item ID for contiguous item-indexed tables.
.define itemTableExpected 0

.macro start_item_table
	.redef itemTableExpected \1
.endm

.macro start_item_price_table
	.redef itemTableExpected \1
.endm

; 1: item constant
; 2: first word
; 3: second word
.macro item_price
	.if \1 != itemTableExpected
		.printt "item_price order mismatch"
		.fail
	.endif
	.dw \2, \3
	.redef itemTableExpected itemTableExpected + 1
.endm

; 1: item constant
; 2: buy bonus
; 3: sell bonus
.macro item_price_bonus
	.if \1 != itemTableExpected
		.printt "item_price_bonus order mismatch"
		.fail
	.endif
	.dw \2, \3
	.redef itemTableExpected itemTableExpected + 1
.endm

.define fuseAbilityExpectedBit $0001

.macro start_fuse_ability_price_table
	.redef fuseAbilityExpectedBit $0001
.endm

; 1: fuse ability bit constant
; 2: buy bonus
; 3: sell bonus
.macro fuse_ability_price
	.if \1 != fuseAbilityExpectedBit
		.printt "fuse_ability_price order mismatch"
		.fail
	.endif
	.dw \2, \3
	.redef fuseAbilityExpectedBit fuseAbilityExpectedBit * 2
.endm

.define monsterMeatExpectedFamily 0
.define monsterMeatExpectedRank 1

.macro start_monster_meat_table
	.redef monsterMeatExpectedFamily \1
	.redef monsterMeatExpectedRank 1
.endm

; 1: monster family constant
; 2: family rank/form (1..3)
; 3: buy price
; 4: sell price
.macro monster_meat_price
	.if \1 != monsterMeatExpectedFamily
		.printt "monster_meat_price family mismatch"
		.fail
	.endif
	.if \2 != monsterMeatExpectedRank
		.printt "monster_meat_price rank mismatch"
		.fail
	.endif
	.dw \3, \4
	.if monsterMeatExpectedRank == 3
		.redef monsterMeatExpectedFamily monsterMeatExpectedFamily + 1
		.redef monsterMeatExpectedRank 1
	.else
		.redef monsterMeatExpectedRank monsterMeatExpectedRank + 1
	.endif
.endm
