---
name: downloads-cleanup-assistant
description: Use when Codex needs to clean up, reorganize, sort, declutter, or group the user's Downloads folder. Default to `~/Downloads`, scan only loose top-level files unless the user expands scope, propose a concrete foldering plan first, and only apply moves or deletions after explicit confirmation. Prefer stable buckets for installers, archives, documents, images, video, keyboard or device files, project or learning artifacts, temp clutter, and an inbox review bucket for ambiguous files.
---

# Downloads Cleanup Assistant

## Overview

Use this skill for requests about reorganizing `~/Downloads`. Treat the default job as a two-step workflow: first inspect and propose, then apply only after explicit confirmation.

## Defaults

- Default target directory: `~/Downloads`
- Default scope: loose files at the target root only
- Preserve existing folders unless the user explicitly asks for deeper cleanup
- Prefer stable buckets over inventing new structure
- Prefer `00_Inbox-Review` over guessing when a file is ambiguous
- Never delete anything without explicit user confirmation

## Core Buckets

Use these buckets as the default taxonomy for every run:

- `00_Inbox-Review`
- `01_Apps-Installers`
- `02_Archives-Bundles`
- `03_Documents-Records`
- `04_Media-Images`
- `05_Media-Video-GIF`
- `06_Keyboard-Device-Files`
- `07_Projects-Learning`
- `99_Temp-Incomplete`

## Workflow

1. Confirm scope from the prompt. If the user names no directory, use `~/Downloads`. If they name another directory, use that as an explicit override.
2. Inventory the target root. Count loose files and existing folders separately. Do not reorganize inside subfolders unless the user explicitly expands scope.
3. Cluster the loose files into a proposal using the core buckets.
4. Detect exact duplicate archive pairs where `name.zip` and `name/` both exist at the target root.
5. Present a concrete proposal before making changes.
6. Only after explicit confirmation, create the approved folders, move loose files, and optionally delete only the exact duplicate zip files the user confirmed.
7. After applying, verify the root shape, report counts by bucket, list any skips, and list the exact files deleted.

## Classification Rules

- Put installers, `.dmg`, `.pkg`, `.app.zip`, app bundles, and app archives into `01_Apps-Installers`.
- Put generic archives such as `.zip`, `.iso`, `.tar.xz`, and similar bundles into `02_Archives-Bundles`.
- Put statements, receipts, shipping labels, agreements, certificates, lab results, return paperwork, and similar admin records into `03_Documents-Records`.
- Put images, wallpapers, screenshots, references, and similar still media into `04_Media-Images`.
- Put `.mp4`, `.webm`, `.mov`, `.gif`, and similar motion media into `05_Media-Video-GIF`.
- Put firmware, keyboard layouts, VIA or Vial configs, QMK artifacts, device JSON, UF2, HEX, and similar hardware or device files into `06_Keyboard-Device-Files`.
- Put coursework, code snippets, HTML or CSS experiments, reference project files, and similar work artifacts into `07_Projects-Learning`.
- Put partial downloads, hidden temp files, Finder clutter, and system leftovers into `99_Temp-Incomplete`.
- Put anything unclear into `00_Inbox-Review`.

## Extra Bucket Rule

Start from the fixed core buckets every time. You may propose up to two extra scan-specific folders only when at least three loose files form a strong shared theme that would be obscured by the core buckets. Extra folders are proposal-only until the user explicitly confirms them.

## Delete Policy

- Only detect exact same-name top-level zip-folder pairs.
- Always list delete candidates separately from move proposals.
- Never delete those zip files until the user explicitly confirms the exact files.
- Do not broaden duplicate detection to fuzzy matching or content-based guesses.

## Safety Rules

- Never mutate the target directory during the proposal phase.
- Never overwrite an existing destination file; skip it and report the collision.
- Never move files inside existing folders unless the user explicitly expands scope.
- Never silently create extra scan-specific folders.
- Never silently delete duplicate archives.

## Response Shape

For the proposal phase, provide:

- loose-file count and existing-folder count
- the proposed bucket structure
- notable file clusters
- ambiguous items that would go to `00_Inbox-Review`
- exact duplicate zip-delete candidates, if any

For the apply phase, provide:

- which folders were created
- how many files were moved into each bucket
- which files were skipped, if any
- which exact duplicate zip files were deleted
- a short verification summary of the cleaned root

## Suggested Commands

Use fast local inspection commands such as `find`, `rg`, `file`, `wc`, and small inline Python only as needed. Prefer exact top-level inspection over recursive scans unless the user expands scope.
