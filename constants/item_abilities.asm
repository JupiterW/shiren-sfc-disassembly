; item fuse ability bitmasks
;
; These values live in wItemFuseAbility1/wItemFuseAbility2. Meanings are
; category-specific, so only define the weapon mapping that is currently
; grounded by default item data and the weapon price bonus handler.

; weapon fuse ability bits
WeaponFuseAbility_Dragonkiller = $0001
WeaponFuseAbility_SickleSlayer = $0002
WeaponFuseAbility_CyclopsKiller = $0004
WeaponFuseAbility_DrainBuster = $0008
WeaponFuseAbility_BufusCleaver = $0010
WeaponFuseAbility_WallDig = $0020 ; default on Item_Pickaxe
WeaponFuseAbility_HomingBlade = $0040
WeaponFuseAbility_MinotaursAxe = $0080
WeaponFuseAbility_RazorWind = $0100
WeaponFuseAbility_PickaxeSecondary = $0200 ; default on Item_Pickaxe, no direct price bonus

; shield fuse ability bits
ShieldFuseAbility_HideShield = $0001 ; default on Item_HideShield
ShieldFuseAbility_ArmorWard = $0002
ShieldFuseAbility_WoodShield = $0004 ; default on Item_HideShield and Item_WoodShield
ShieldFuseAbility_AntiPoisonShield = $0008
ShieldFuseAbility_Dragonward = $0010
ShieldFuseAbility_SpikedWard = $0020
ShieldFuseAbility_EchoShield = $0040
ShieldFuseAbility_EvasiveShield = $0080
ShieldFuseAbility_FragileShield = $0100
ShieldFuseAbility_BlastShield = $0200
ShieldFuseAbility_WalrusShield = $0400
ShieldFuseAbility_PostPriceBonus = $0800 ; handled after the priced bit scan
