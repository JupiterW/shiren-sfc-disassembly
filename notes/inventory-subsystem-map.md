# Inventory Subsystem Map

Branch: `quick-use-item-trace`

This note groups the main inventory-related routines by behavior instead of by
bank/file placement.

## Top-Level Action Flow

Player input and command dispatch:

- [GetPlayerActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_06.asm#L116)
  - Main player action-command source used by the gameplay loop.
- [GetLivePlayerActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11001)
  - Polls input and builds the live action command byte.
- [HandlePlayerActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L5176)
  - Main action dispatcher for movement, item actions, sort, shortcut actions, and menu-derived item commands.

Fixed inventory-related commands currently understood:

- `$1B` -> [SortShirenInventory](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L8859)
- `$1D` -> [HandleArrowShortcutAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4738)
- command family `$40` -> [DropSelectedInventoryItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4128)
- command families `$60/$80/$A0/$C0/$E0` feed item-selection and ground/container action paths

## Where Item Data Lives

There are three main layers to item data in this codebase:

Reusable helper:

- [tools/item_pipeline.py](/Users/jupiter.whitworth/Development/new/shiren/tools/item_pipeline.py)
  - Query `item -> category -> use handler -> throw handler`
  - Supports direct item lookup plus reverse lookup by handler substring
- [tools/function_xref.py](/Users/jupiter.whitworth/Development/new/shiren/tools/function_xref.py)
  - Query symbol/address definitions, callers, and table references with optional context
  - Useful for tracing unnamed item handlers from raw table entries like `$0EA0`

1. Item ids / canonical item definitions

- [constants/items.asm](/Users/jupiter.whitworth/Development/new/shiren/constants/items.asm)
  - Defines the canonical item ids like `Item_Cudgel`, `Item_WoodArrow`, `Item_BlankScroll`, `Item_HoldingJar`, etc.
  - This is the stable "what item type is this?" layer.

2. Live item-instance storage in WRAM

- [ShirenStatus.itemAmounts](/Users/jupiter.whitworth/Development/new/shiren/structs/structs.asm#L10)
  - Shiren's inventory list: 20 item-slot ids/references at `7E:894F`.
- [wItemType](/Users/jupiter.whitworth/Development/new/shiren/wram.asm#L1547)
  - Item type/id for each live item instance.
- [wItemModification1](/Users/jupiter.whitworth/Development/new/shiren/wram.asm#L1555)
- [wItemModification2](/Users/jupiter.whitworth/Development/new/shiren/wram.asm#L1559)
- [wItemPotNextItem](/Users/jupiter.whitworth/Development/new/shiren/wram.asm#L1567)
- [wItemGoods](/Users/jupiter.whitworth/Development/new/shiren/wram.asm#L1571)
  - These arrays hold per-instance state such as stack/count-like values, curse/identify-related state, linked-list membership for container contents, and item-specific parameters.

3. Decoded item metadata / behavior dispatch

- [func_C30710](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L852)
  - Central item metadata decoder.
  - Input: item instance index in `wTemp00`
  - Output: decoded item properties in temp vars such as:
    - `wTemp00` category from [DATA8_C341BB](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L1881)
    - `wTemp01` item type/id
    - `wTemp02/wTemp03` modification bytes
    - `wTemp04` derived item-strength/value-style byte
    - `wTemp05` resolved display/name id
    - `wTemp06` item state/flags
    - `wTemp07` curse flag

Item behavior then dispatches primarily through:

- [ItemUseEffectFunctionTable](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L2122)
- [ItemThrowEffectFunctionTable](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L2357)

Those tables are where item-specific functions live for most "use" and "throw" behavior.

## Category Shortcut / Equip State

Structure and slot meanings:

- [ShirenStatus.categoryShortcutItemIds](/Users/jupiter.whitworth/Development/new/shiren/structs/structs.asm#L14)
  - `[0]` weapon
  - `[1]` shield
  - `[2]` armband
  - `[3]` arrow

Slot helpers:

- [GetCategoryShortcutItemIds](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3663)
- [ToggleWeaponShortcutItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3716)
- [ToggleShieldShortcutItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3728)
- [ToggleArmbandShortcutItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3722)
- [ToggleArrowShortcutItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3701)
- [RemoveItemFromCategoryShortcutSlots](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3764)
- [TryClearAssignedCategoryItem](/Users/jupiter.whitworth/Development/new/shiren/code/item_effects.asm#L2551)

Selection / assignment:

- [HandleCategoryShortcutSelectionAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3803)
  - Routes the current selected item source into one of:
    - normal inventory item
    - underfoot item
    - contained item
    - ground-item exchange path
- [AssignSelectedInventoryItemToCategoryShortcut](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4084)
  - Feeds a selected inventory item into the category-based assignment/equip path.

Shared category application logic:

- [ExecuteSelectedItemActionByCategory](/Users/jupiter.whitworth/Development/new/shiren/code/item_effects.asm#L362)
  - Shared category-based item action routine used by both player-side flows and AI-related callers
  - Handles category shortcut/equip categories first, then falls through to broader category-specific item-use behavior

## Underfoot Ground Item Actions

Ground-item menu:

- [OpenGroundItemActionMenu](/Users/jupiter.whitworth/Development/new/shiren/code/bank_04.asm#L13029)
  - Opens the underfoot ground-item action menu and returns a menu result.
- [BuildGroundItemActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11321)
  - Converts the ground-item menu result into the action byte(s) consumed by [HandlePlayerActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L5176).

Ground-item menu cases currently understood:

- `throw`
  - Direct case from [BuildGroundItemActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11321) builds `wTemp00 = $9F`
  - This routes into [HandleThrowItemAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4772)
- `pick up`
  - One fallback case builds fixed command `$5F`
  - This routes into [HandleUnderfootItemPickupAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L5104)
- `examine`
  - One direct case toggles [ToggleGroundItemDetailsView](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11843)
  - This is a UI/details toggle rather than an item mutation path
- `exchange`
  - Direct case builds `wTemp00 = $BF` and sets `wTemp01 |= $40`
  - This routes into the underfoot exchange path in [HandleCategoryShortcutSelectionAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3803)
  - Gameplay-confirmed: swaps the selected inventory item with the ground item
- `name`
  - One menu case routes through [func_C3F336](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11802)
  - This is the blank-scroll-specific helper and matches the ground-item `name` option

Ground-item helpers:

- [DropSelectedInventoryItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4128)
  - Drops the selected inventory item onto the ground if the tile is valid
  - Removes category shortcut assignment if needed before placing it
- [HandleThrowItemAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4772)
  - Handles the throw action family for either a selected inventory item or the underfoot item
  - Normal path forwards to [ThrowSelectedItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4795)
  - [PrepareSelectedThrowableItem](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L1048) splits arrow stacks into a temporary single-arrow item when needed
  - Special slot `1F` handles the underfoot item directly

Ground-container / pot-specific ground-menu builders:

- [BuildGroundContainerInsertCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11684)
  - Likely `put inside` for a ground container
  - Opens an inventory-style chooser through [func_C4A0B1](/Users/jupiter.whitworth/Development/new/shiren/code/bank_04.asm#L13573)
- [BuildContainedItemActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11749)
  - Likely the builder for actions on an item selected from inside a ground container
  - Opens a contained-item chooser through [func_C49A97](/Users/jupiter.whitworth/Development/new/shiren/code/bank_04.asm#L12989)

## Contained Item Actions

Contained-item dispatcher:

- [HandleContainedItemSelectionAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3990)
  - Main dispatcher for actions on items inside a container

Contained-item selector encoding:

- low 5 bits = contained-item index inside the linked list
- bits 5-6 = action family
  - `$00` = route into category shortcut/equip handling
  - `$20` = use the contained item
  - `$40` = place the contained item on the ground
  - `$60` = move the contained item into inventory

Contained-item linked-list helpers:

- [GetContainedItemByIndex](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L1135)
- [RemoveContainedItemByIndex](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L1148)
- [InsertContainedItemByIndex](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L1176)

## Jar / Pot Related Helpers

- [TryPrepareSelectedItemForJarInsertion](/Users/jupiter.whitworth/Development/new/shiren/code/item_effects.asm#L2452)
  - Used by jar-specific effect paths
- [TryAddSelectedItemToInventory](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3500)
  - Validates a selected item source and inserts it into inventory

Important correction:

- The special `wTemp01 & $40` path in [HandleCategoryShortcutSelectionAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L3803) is not pot-exclusive
- Gameplay confirmation showed it is the general underfoot `exchange` action

## Sort / Shortcut Action Paths

- [SortShirenInventory](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L8859)
  - Triggered by fixed player action command `$1B`
- [HandleArrowShortcutAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4738)
  - Triggered by fixed player action command `$1D`
  - Uses the arrow category shortcut slot

## Unresolved / Intentionally Unnamed

These are left unnamed because the behavior boundary is not yet proven tightly enough:

- [HandleThrowItemAction](/Users/jupiter.whitworth/Development/new/shiren/code/bank_02.asm#L4772)
  - throw action family for inventory and underfoot items
- [func_C30AE5](/Users/jupiter.whitworth/Development/new/shiren/code/item_effects.asm#L362)
  - shared category-based item assignment/apply routine
- some raw subcases inside [BuildGroundItemActionCommand](/Users/jupiter.whitworth/Development/new/shiren/code/bank_03.asm#L11321)
  - enough is known to map `use`, `exchange`, and `name`
  - other ground-item menu options still need one more pass

## Matching Build Rule

Do not assume symbolically equivalent operand rewrites are byte-equivalent.

Concrete known failure:

- rewriting `lda.l wShirenStatus.itemAmounts,x`
- into `lda.w $894F,x`

changed the assembled bytes and broke the matching SHA.

Safe so far in this subsystem:

- comments
- label renames plus matching callsite renames

Unsafe unless tested one at a time:

- operand form rewrites
- local blob-to-assembly lifts combined with additional semantic cleanup in the same pass
