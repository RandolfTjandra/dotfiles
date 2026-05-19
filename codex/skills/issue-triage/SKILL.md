---
name: issue-triage
description: Use when Codex needs to move a standard Markdown issue between `backlog`, `active`, and `done`, keep frontmatter status in sync, and regenerate the repo-local `planning/README.md` summary.
---

# Issue Triage

Use this skill when the user wants issue status changed or cleaned up.

## Defaults

- Move the issue file to the folder that matches the requested status.
- Update frontmatter `status` and `updated`.
- Preserve the existing filename slug.
- Regenerate `planning/README.md` after each move.

## Rules

- `backlog` means not started.
- `active` means currently in progress.
- `done` means shipped or otherwise complete.
- If the issue ID cannot be found uniquely, stop and report that instead of guessing.

## Command

Use the shared helper:

```bash
python3 ../issue-tracker/scripts/issue_tracker.py triage --root "$PWD" --issue-id DOT-001 --status active
```

If invoked from the repo-local source tree instead of the installed global skills, use `.agents/skills/issue-tracker/scripts/issue_tracker.py`.
