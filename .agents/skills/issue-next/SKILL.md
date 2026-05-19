---
name: issue-next
description: Use when Codex needs to summarize the current planning tracker, report active versus backlog work, and recommend the next issue to work on in a repo that uses the standard Markdown issue tracker.
---

# Issue Next

Use this skill when the user asks what to work on next or wants a quick tracker summary.

## Defaults

- Prefer active work over backlog work when recommending the next issue.
- Within the same status, prefer higher priority and lower issue number.
- Report counts for `active` and `backlog`.
- Do not mutate issue state unless the user explicitly asks for a triage change.

## Command

Use the shared helper:

```bash
python3 ../issue-tracker/scripts/issue_tracker.py next --root "$PWD"
```

If invoked from the repo-local source tree instead of the installed global skills, use `.agents/skills/issue-tracker/scripts/issue_tracker.py`.
