---
id: DOT-001
title: Clean up repository top-level files
status: backlog
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
- [ ] Inventory every top-level file and directory and classify it as required root entry point, app/module directory, generated artifact, obsolete file, or candidate for relocation.
- [ ] Remove generated artifacts such as logs or OS metadata from the repo if they are not intentionally tracked.
- [ ] Move or consolidate root-level helper scripts and configs where doing so improves scanability and does not break setup behavior.
- [ ] Update README or setup documentation for any path changes.
- [ ] Verify setup scripts, symlink assumptions, and tracked file status after cleanup.

## Notes
- Current root includes generated-looking files such as `.DS_Store`, `.nvimlog`, and `nvim.log`.
- Be careful with shell dotfiles and setup scripts because they may be directly symlinked or referenced by bootstrap commands.

## Execution Hints
- Start with `git ls-files` and `git status --ignored --short` to distinguish tracked clutter from ignored local files.
- Search for references before moving root files: `rg 'setup.sh|symlink-gitconfigs.sh|requirements.md|pyrightconfig.example.json|stylua.toml'`.
- Prefer small, reversible changes and commit moves separately from deletions if the cleanup becomes broad.
