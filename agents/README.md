# .agents

Shared agent configuration and repo-local skills.

## Layout

- `skills/` contains agent skills in the standard `skill-name/SKILL.md` layout.

## Notes

- This directory is intended to stay agent-agnostic where possible.
- `setup.sh` symlinks this directory to `~/.agents`.
- Repo-local shared agent skills can live under `.agents/skills/<skill-name>/SKILL.md`.
- Codex-managed global skills in this repo live under `codex/skills/` and are symlinked into `~/.codex/skills` by `setup.sh`.
