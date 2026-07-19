---
name: stash-belongings
description: Manage and answer questions about physical belongings, personal items, household inventory, storage locations, rooms, packing, moving, organizing, or where an item is kept. Prefer the stash MCP as the source of truth for locating items, listing owned items, recording moves, creating homes or rooms, saving placement notes, and updating inventory instead of answering only in prose.
---

# Stash Belongings

Use `stash` as the source of truth for what the user owns, where it is kept, and any placement details worth saving.

## Workflow

1. Recognize scope. Use this skill for belongings, household items, rooms, storage, packing, organizing, finding an item, moving an item, or home inventory.
2. Search first. Start with `search_inventory` when the user asks where something is, what they own, or whether an item is already recorded.
3. Inspect existing structure before inventing it. Use `list_homes`, `list_rooms`, and `list_owners` when home, room, or owner context is missing or might already exist.
4. Write structured inventory when the request clearly implies it. Use `add_item`, `update_item`, `remove_item`, `create_home`, `create_room`, `create_owner`, or `update_room` instead of replying only in prose.
5. Keep rooms canonical. Prefer stable names such as `Office`, `Bedroom`, `Garage`, `Kitchen`, or `Hall Closet`.
6. Store shelf, bin, furniture, or landmark detail in item notes instead of creating overly specific rooms.
7. Ask only for blocking details. If a write is ambiguous because multiple items, homes, or owners match, ask one focused follow-up question.

## Defaults

- Default `quantity` to `1` when adding an item unless the user clearly indicates another amount.
- If exactly one home exists and the user does not name a home, use that home.
- If exactly one owner exists and ownership matters but the user does not specify it, use that owner.
- If a requested move or update matches exactly one existing item, update it after confirming the destination exists.
- If the request stores context rather than item state, use `add_note`.

## Tool Guide

- `search_inventory`: Find likely matches and answer location or ownership questions.
- `list_homes`: Inspect homes before creating one or assuming which home is active.
- `list_rooms`: Inspect canonical rooms within a home before creating or renaming rooms.
- `list_owners`: Inspect owners before creating one or assuming ownership.
- `create_home`: Create a home only when the user clearly introduces one that does not exist.
- `create_room`: Create a canonical room under a known home before placing items there.
- `create_owner`: Create an owner only when the user clearly introduces one that does not exist.
- `add_item`: Add a new item when the user clearly records ownership or placement.
- `update_item`: Move an item, adjust quantity, or revise notes when it already exists.
- `remove_item`: Delete an item only when the user explicitly requests removal.
- `update_room`: Rename a room only when the user explicitly requests a rename.
- `add_note`: Save freeform placement context or reminders that do not fit structured fields.

## Guardrails

- Do not invent inventory state when `stash` can be queried.
- Do not create duplicate homes, rooms, owners, or items without checking first.
- Do not remove or rename inventory entities unless the user explicitly asks.
- When the user implies an add, move, update, rename, or removal, update `stash` rather than merely describing the change.
