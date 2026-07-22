# .agents

Shared agent configuration and repo-local skills.

## Layout

- `skills/` contains agent skills in the standard `skill-name/SKILL.md` layout.

## Notes

- This directory is intended to stay agent-agnostic where possible.
- `setup.sh` keeps `~/.agents` as a real directory and links in the components this repo owns.
- Shared agent skills live under `agents/skills/<skill-name>/SKILL.md` and are linked into `~/.agents/skills/` by `setup.sh`.
