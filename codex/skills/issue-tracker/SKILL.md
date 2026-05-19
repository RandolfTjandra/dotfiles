---
name: issue-tracker
description: Use when Codex needs to create, update, triage, or summarize repo-local Markdown issues under a standard `planning/` tracker. Bootstrap the tracker on first use, keep one file per issue, treat folder location as the status source of truth, and regenerate `planning/README.md` after each mutation.
---

# Issue Tracker

Use this skill for repo-local issue tracking in any project. The standard tracker lives under `planning/` and uses one Markdown file per issue.

## Defaults

- Bootstrap `planning/` automatically on first use.
- Use `planning/config.json` as the tracker metadata source of truth.
- Keep issue files in `planning/backlog/`, `planning/active/`, or `planning/done/`.
- Treat the containing folder as the status source of truth.
- Keep issue IDs monotonic and never reuse them.
- Regenerate `planning/README.md` after every mutation.

## Prefix Rule

- If `planning/config.json` already exists, reuse its `project_prefix`.
- If the tracker does not exist yet, derive a suggested prefix from the repo name.
- If the derived prefix is obviously awkward or the user explicitly cares about naming, ask once before first mutation.
- Otherwise initialize with the derived suggestion and report the chosen prefix in the result.

## Issue Shape

Each issue file must include:

- frontmatter keys: `id`, `title`, `status`, `priority`, `created`, `updated`, `related`, `blocked_by`
- sections: `Problem`, `Goal`, `Acceptance Criteria`, `Notes`, `Execution Hints`

## Workflow

1. Resolve the repo root from the current working directory.
2. If `planning/` is missing, bootstrap it.
3. If `planning/` exists but `planning/config.json` is missing, stop and propose migration instead of overwriting custom files.
4. Use `scripts/issue_tracker.py` for bootstrap, create, triage, summary, and README refresh operations.
5. After each mutation, confirm the exact issue ID, file path, and resulting status.

## Commands

Use the bundled helper script:

```bash
python3 .agents/skills/issue-tracker/scripts/issue_tracker.py bootstrap --root "$PWD"
python3 .agents/skills/issue-tracker/scripts/issue_tracker.py create --root "$PWD" --title "Add X"
python3 .agents/skills/issue-tracker/scripts/issue_tracker.py triage --root "$PWD" --issue-id DOT-001 --status active
python3 .agents/skills/issue-tracker/scripts/issue_tracker.py next --root "$PWD"
python3 .agents/skills/issue-tracker/scripts/issue_tracker.py refresh --root "$PWD"
```

When the skill is installed globally under `~/.codex/skills/`, run the same script from that installed path instead of the repo-local path.
