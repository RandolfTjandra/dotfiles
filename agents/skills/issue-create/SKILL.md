---
name: issue-create
description: Use when Codex needs to create a new implementation-ready Markdown issue in the standard `planning/` tracker for the current repo. Bootstrap the tracker if missing, assign the next repo-prefixed issue ID, and write the issue into `planning/backlog/`.
---

# Issue Create

Use this skill when the user wants a new repo-local issue created.

## Defaults

- Bootstrap the standard tracker if it does not exist yet.
- Create new issues in `planning/backlog/`.
- Use implementation-ready content by default, not a placeholder ticket.
- Increment `next_issue_number` and regenerate `planning/README.md`.

## Creation Rules

- Prefer a concrete verb-first title.
- Fill `Problem`, `Goal`, and `Acceptance Criteria` from the user request when possible.
- If the user gives only a rough idea, create a useful first draft rather than a one-line stub.
- Use `medium` priority unless the user or context makes priority obvious.

## Command

Use the shared helper:

```bash
python3 ../issue-tracker/scripts/issue_tracker.py create --root "$PWD" --title "Add X"
```

If invoked from the repo-local source tree instead of the installed global skills, use `.agents/skills/issue-tracker/scripts/issue_tracker.py`.
