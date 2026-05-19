---
id: DOT-001
title: Clean up repository top-level files
status: done
priority: medium
created: 2026-05-20
updated: 2026-05-20
related: []
blocked_by: []
---

# DOT-001 Clean up repository top-level files

## Problem
The repository root has accumulated editor logs, shell-specific files, setup scripts, and application directories in one flat list. That makes it harder to scan the important entry points and distinguish intentional dotfiles from generated or obsolete files.

## Goal
Audit the root directory and reduce top-level clutter without breaking existing symlinks, setup scripts, or documented workflows.

## Acceptance Criteria
- [x] Inventory every top-level file and directory and classify it as required root entry point, app/module directory, generated artifact, obsolete file, or candidate for relocation.
- [x] Leave generated artifacts such as logs or OS metadata ignored and untracked.
- [x] Move or consolidate root-level helper scripts and configs where doing so improves scanability and does not break setup behavior.
- [x] Update README or setup documentation for any path changes.
- [x] Verify setup scripts, symlink assumptions, and tracked file status after cleanup.

## Notes
- Current root includes generated-looking files such as `.DS_Store`, `.nvimlog`, and `nvim.log`.
- Be careful with shell dotfiles and setup scripts because they may be directly symlinked or referenced by bootstrap commands.
- Resolved by commit `6dd8684`, which moved home dotfiles to `home/`, local executables to `bin/`, setup notes/examples to `docs/`, updated `setup.sh` and `README.md`, fixed the Hammerspoon symlink target, and removed stale tracked root helpers.
- Generated local artifacts were intentionally left in place after review because they are ignored and not part of the tracked cleanup.

## Execution Hints
- Start with `git ls-files` and `git status --ignored --short` to distinguish tracked clutter from ignored local files.
- Search for references before moving root files: `rg 'setup.sh|symlink-gitconfigs.sh|requirements.md|pyrightconfig.example.json|stylua.toml'`.
- Prefer small, reversible changes and commit moves separately from deletions if the cleanup becomes broad.
