# .agents

Shared agent configuration and repo-local skills.

## Layout

- `skills/` contains agent skills in the standard `skill-name/SKILL.md` layout.

## Notes

- This directory is intended to stay agent-agnostic where possible.
- `setup.sh` symlinks this directory to `~/.agents`.
- Codex skills should live under `.agents/skills/<skill-name>/SKILL.md`.
