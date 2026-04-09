# Item Handler Edge Cases

This note tracks cases where the normal item-handler promotion workflow is not enough.

Normal workflow:
- use `tools/item_rename_candidates.py` to pick unique raw handlers
- use `tools/promote_raw_item_handler_label.py` to promote one label
- rebuild and verify with `shiren.sfc: OK`

## Proven Tool-Safe Cases

These are now covered by the promotion tooling:
- raw handler starts in the middle of a plain `.db` line
- raw handler starts at the beginning of a plain `.db` line
- handler starts at an unlabeled asm entry immediately after a raw byte line
- handler starts inside a mixed raw/asm region where comment addresses are stale, as long as computed address flow is enough to locate it

Examples:
- `HappinessHerbUseEffect`
- `AngelSeedUseEffect`
- `SightHerbUseEffect`
- `DragonHerbUseEffect`
- `SleepHerbUseEffect`

## Edge Case Classes

### Shared Handler

These should not be renamed as item-specific handlers until the shared behavior is understood.

Current examples:
- `RevivalHerb` / `Weeds` use shared `$09F0`
- `BigOnigiri` use `$15AD`
  - extra jump caller from `MonsterMeatUseEffect`

### Unknown Item Identity

These should not be named semantically until the item itself is identified.

Current examples:
- `Item_36` use `$0A94`
- `Item_B3`
- `Item_5C`
- `Item_62`
- `Item_70`

### Symbol Address Mismatch

Some old lifted `func_C...` labels do not match the actual assembled address implied by the name.
Do not assume table entries always want `Label-1`.

Use:
- original table value
- actual symbol address from `shiren.sym`

Current confirmed example:
- `KignyHerbUseEffect`
  - table wants `Label`
  - not `Label-1`

### No Promotable Region Found

The current promotion tool could not map the raw pointer to:
- a plain `.db` split point
- an unlabeled asm entry
- or a mixed-region computed entry point

Current examples:
- currently none in the tracked item families after the latest tool improvements

Likely meaning:
- the region needs another address-walking rule
- or the handler begins in a more complex partially lifted block

### SHA Drift After Promotion

The label can be inserted, but the resulting assembled bytes no longer match.

Current examples:
- `SwitchingStaffUseEffect`
- `BlastwaveScrollUseEffect`
- `SilenceScrollUseEffect`
- `TrapScrollUseEffect`
- `HasteScrollUseEffect`
- `HandsFullScrollUseEffect`
- `HugeOnigiriUseEffect`

Likely meaning:
- local boundaries or entry assumptions are wrong
- or the promoted line changes operand/layout behavior in a way the current tool did not model

### Local Label / Scope Breakage

Promotion can fail because the inserted global label changes local-label ownership or assembler scope.

Current examples:
- `BufusStaffUseEffect`
  - broke on reference to `DoppelgangerStaffUseEffect@lbl_C31EB5`

Likely meaning:
- the target is inside a region using local labels that currently belong to a neighboring function
- safe promotion may require lifting a larger function cluster together

## Current Family Status

### Herbs

- use handlers named: `44/47`
- unresolved:
  - `Item_36` use `$0A94`
  - shared `RevivalHerb` / `Weeds` use `$09F0`
  - `PoisonHerbUseEffect`
    - current raw-lift tooling should skip `C311E3-C312DD` for now
    - source-driven and ROM-backed full-function lifts both still drift SHA
    - next likely fix is regenerating the whole function from ROM bytes with exact byte-equivalent instruction forms instead of preserving any mixed source inside the range

### Staffs

Safe promotions completed:
- `SlothStaffUseEffect`
- `KnockbackStaffUseEffect`
- `HappinessStaffUseEffect`
- `MisfortuneStaffUseEffect`
- `DoppelgangerStaffUseEffect`
- `SwitchingStaffUseEffect`
- `BufusStaffUseEffect`
- `SkullStaffUseEffect`
- `ParalysisStaffUseEffect`
- `PostponeStaffUseEffect`
- `PainSplitStaffUseEffect`

Known edge cases:
- no unique raw use-handler edge cases remain in the staff family

### Scrolls

Safe promotions completed:
- `BlessingScrollUseEffect`
- `IdentityScrollUseEffect`
- `LightScrollUseEffect`
- `BigpotScrollUseEffect`
- `NeedScrollUseEffect`
- `HasteScrollUseEffect`
- `SleepScrollUseEffect`
- `PowerupScrollUseEffect`
- `ExplosionScrollUseEffect`
- `GreatHallScrollUseEffect`
- `MonsterHouseScrollUseEffect`
- `ConfusionScrollUseEffect`
- `AirBlessScrollUseEffect`
- `EarthBlessScrollUseEffect`
- `PlatingScrollUseEffect`
- `ExtractionScrollUseEffect`

Known edge cases:
- SHA drift:
  - `TrapScrollUseEffect`
  - `HandsFullScrollUseEffect`

Still unnamed raw unique scroll handlers not resolved in this pass:
- `Item_5C`
- `Item_62`
- `Item_70`

### Jars

Safe promotions completed:
- `HidingJarUseEffect`
- `MonsterJarUseEffect`
- `WalrusJarUseEffect`

Known edge cases:
- no unique raw use-handler edge cases remain in the jar family

### Onigiri

Safe promotions completed:
- `OnigiriUseEffect`
- `SpoiledOnigiriUseEffect`
- `SpecialOnigiriUseEffect`

Known edge cases:
- shared handler:
  - `BigOnigiri` use `$15AD`
- SHA drift / boundary issue:
  - `HugeOnigiriUseEffect`

## Tool Coverage Wins

Recent tool improvements resolved cases that originally looked like real edge cases:
- `.dw` stream promotion unlocked:
  - `HappinessStaffUseEffect`
- jump-table target anchoring unlocked:
  - `PostponeStaffUseEffect`
- better opcode-size accounting in mixed lifted asm unlocked:
  - `BufusStaffUseEffect`
  - `SwitchingStaffUseEffect`
  - `WalrusJarUseEffect`
  - `RemovalScrollUseEffect`
- local cluster lift using the raw decoder unlocked:
  - `SilenceScrollUseEffect`
  - `BlastwaveScrollUseEffect`

## Workflow Notes

- Run `make clean` before git commands.
- Prefer tool-driven promotion over manual raw `.db` edits.
- For auto-renames, trust verification more than assumptions.
- For iterative raw lifts, use `--skip-range START-END` to park known hard cases like `C311E3-C312DD` and keep the batch loop moving.
- When promotion fails, classify the failure into one of the edge case classes above before adding more special-case code.
