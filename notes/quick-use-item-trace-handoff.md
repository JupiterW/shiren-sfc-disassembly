# Quick Use Item Trace Handoff

Branch: `quick-use-item-trace`

Latest verified commit before current working changes: `1dd23a0` `Correct ground item exchange path comments`

## What We Established

- Category shortcut slots are:
  - slot 1 = weapon
  - slot 2 = shield
  - slot 3 = armband
  - slot 4 = arrow
- L-button uses the arrow slot.
- The no-arrow-equipped message matched this path in-game.

## Important Renames

- `wShirenStatus.categoryShortcutItemIds`
- `ToggleWeaponShortcutItem`
- `ToggleShieldShortcutItem`
- `ToggleArmbandShortcutItem`
- `ToggleArrowShortcutItem`
- `HandleArrowShortcutAction`
- `RemoveItemFromCategoryShortcutSlots`
- `AssignSelectedInventoryItemToCategoryShortcut`
- `TryClearAssignedCategoryItem`
- `HandleCategoryShortcutSelectionAction`

## Current Read Of HandleCategoryShortcutSelectionAction

`HandleCategoryShortcutSelectionAction` in `code/bank_02.asm` has four modes:

- regular inventory item
- contextual map item (`wTemp00 == $1F`)
- nested/container item (`wTemp01 < 0`)
- ground-item exchange path (`wTemp01 & $40`)

What we established later:

- the `bit $40` path is not pot-exclusive
- gameplay confirmation showed it is the generic underfoot ground-item exchange action
- it swaps the selected inventory item with the ground item
- `wShirenStatus.cantPickUpItems` gates this path

For contained items, the negative `wTemp01` path uses:

- low 5 bits = contained-item index within the linked list
- bits 5-6 = action family
  - `$00` = route into category shortcut/equip handling
  - `$20` = use the contained item
  - `$40` = place the contained item on the ground
  - `$60` = move the contained item into inventory

## Safe Renames Reapplied And Verified

- `HandleContainedItemSelectionAction`
- `DropSelectedInventoryItem`
- `GetContainedItemByIndex`
- `RemoveContainedItemByIndex`
- `InsertContainedItemByIndex`

These all rebuild to an exact match: `shiren.sfc: OK`.

## Matching Build Gotcha

Do not assume symbolically "equivalent" operand rewrites are byte-equivalent.

Concrete failure we hit:

- rewriting `lda.l wShirenStatus.itemAmounts,x`
- into `lda.w $894F,x`

changed the assembled bytes and broke the matching SHA.

Guideline:

- comments are safe
- label renames plus matching callsite renames are usually safe
- operand form rewrites must be tested one at a time with a rebuild

## Next Step

Trace the menu/UI code that constructs the contained-item selector byte so the
`$00/$20/$40/$60` families can be mapped to exact player-facing menu actions.
