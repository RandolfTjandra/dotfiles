---
name: stash-belongings
description: Use when Codex needs to manage or answer questions about physical belongings, personal items, household inventory, storage locations, rooms, packing, moving, organizing, or where something is kept. Prefer the stash MCP as the source of truth for locating items, listing owned items, recording moves, creating homes or rooms, saving placement notes, and updating inventory instead of answering only in prose.
---

# Stash Belongings

## Overview

Use `stash` for requests about physical belongings and storage. Treat `stash` as the source of truth for what the user owns, where it lives, and any placement details worth saving.

## Workflow

1. Recognize scope. Use this skill when the user talks about belongings, household items, rooms, storage, packing, organizing, finding an item, moving an item, or home inventory.
2. Search first. Start with `search_inventory` when the user is asking where something is, what they own, or whether an item is already recorded.
3. Inspect existing structure before inventing it. Use `list_homes`, `list_rooms`, and `list_owners` when home, room, or owner context is missing or might already exist.
4. Write structured inventory when the request clearly implies it. Use `add_item`, `update_item`, `remove_item`, `create_home`, `create_room`, `create_owner`, or `update_room` instead of only replying in prose.
5. Keep rooms canonical. Prefer stable room names such as `Office`, `Bedroom`, `Garage`, `Kitchen`, or `Hall Closet`.
6. Use notes for placement detail. Put shelf, bin, furniture, or landmark detail into item notes instead of turning every nuance into a new room.
7. Ask only for blocking details. If a write is ambiguous because there are multiple matching items, multiple plausible homes, or missing owner context that matters, ask one focused follow-up question.

## Defaults

- Default `quantity` to `1` when adding an item unless the user clearly indicates another amount.
- If exactly one home exists and the user does not name a home, use that home.
- If exactly one owner exists and ownership matters but the user does not specify it, use that owner.
- If a requested move or update matches exactly one existing item, update that item directly after confirming the destination structure exists.
- If the request is about storing context rather than item state, use `add_note`.

## Tool Guide

- `search_inventory`: Find likely matches, confirm whether an item already exists, and answer location questions.
- `list_homes`: Inspect the known homes before creating a new one or assuming which home is active.
- `list_rooms`: Inspect canonical rooms within a home before creating or renaming rooms.
- `list_owners`: Inspect known owners before creating a new owner or assuming ownership.
- `create_home`: Create a home only when the user is clearly introducing one that does not already exist.
- `create_room`: Create a canonical room under a known home before placing items into it.
- `create_owner`: Create an owner only when the user is clearly introducing one that does not already exist.
- `add_item`: Add a new item when the user is clearly recording ownership or placing a new item into inventory.
- `update_item`: Move an item, adjust quantity, or revise notes when the item already exists.
- `remove_item`: Delete an item only when the user explicitly asks to remove it from inventory.
- `update_room`: Rename a room only when the user explicitly asks for a rename.
- `add_note`: Save freeform context, placement detail, or reminders that do not belong in the structured fields alone.

## Request Patterns

- For "Where is X?" or "Do I have X?", search first and answer from `stash`.
- For "Add X to Y room" or "I bought X", create any missing owner or room context and add the item to `stash`.
- For "I moved X from A to B", search for the existing item, then update its room, home, and notes as needed.
- For "Rename this room" or "remove this item", use the explicit rename or delete tools only after the target is unambiguous.
- For "Make a note that X is in the blue bin", keep the room canonical and store `blue bin` in item notes or a freeform note, depending on whether the item already exists.

## Guardrails

- Do not invent inventory state when `stash` can be queried.
- Do not create duplicate homes, rooms, owners, or items without checking for existing matches first.
- Do not create overly specific room names for shelf or bin detail; keep those details in notes.
- Do not remove or rename inventory entities unless the user explicitly asks.
