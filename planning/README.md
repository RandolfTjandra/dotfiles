# Planning Tracker

This repo uses a file-based issue tracker under `planning/`.

## Source of Truth

- `config.json` stores tracker metadata and the next issue number.
- Issue file location is the status source of truth:
  - `backlog/`
  - `active/`
  - `done/`
- Issue frontmatter `status` must match the containing folder.

## Workflow

Use the global Codex skills to manage issues:

- `issue-tracker`
- `issue-create`
- `issue-triage`
- `issue-next`

Those skills regenerate this file after each mutation.

## Tracker Config

- Project: `dotfiles`
- Prefix: `DOT`
- Next issue number: `2`

## Backlog

No issues.

## Active

No issues.

## Done

- `DOT-001` Clean up repository top-level files (medium)
