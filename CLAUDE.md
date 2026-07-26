# dotfiles

Personal macOS config, installed by symlinking this repo into `$HOME`.
`setup.sh` is the only installer; there is no build, test, or lint step.

## Gotchas

**`setup.sh` links an explicit allowlist, not a glob.** New top-level config
directories are invisible to it until added to the `for dir in ...` list near
the top. A directory existing in the repo does not mean it is installed — this
is the repo's main source of drift. Run the `dotfiles-auditor` agent to find it.

**Three separate agent-config roots, and they are easy to confuse:**

| Repo path | Installs to | Scope |
|---|---|---|
| `agents/skills/` | `~/.agents/skills` *and* `~/.claude/skills` | agent-agnostic, shared |
| `claude/` | `~/.claude/` | Claude-specific, global to every project |
| `codex/` | `~/.codex/` | Codex-specific |
| `.claude/` | nowhere — read in place | this repo only |

`claude/agents/` is portable and lands in `~/.claude/agents` on every machine.
`.claude/agents/` applies only when working inside this repo. A skill name
present in both `agents/skills/` and `claude/skills/` resolves to the
`claude/skills/` copy, because it is linked second.

**`~/.claude`, `~/.agents`, and `~/.codex` are real directories, never
symlinks to this repo.** Those tools write their own state there (plugin
installs, `.skill-lock.json`, credentials). Only individual components are
linked in. Anything that lands in one of them wholesale will pull tool-generated
state into the repo.

**`ln -sfn` nests instead of replacing when the destination is a real
directory.** This silently creates `dest/name/name`. The per-item loops for
skills and agents guard against it by checking `[ -d "$dest" ] && [ ! -L "$dest" ]`
and warning. Any new per-item linking loop needs the same guard.

**`~/.codex/config.toml` is deliberately untracked.** Codex writes machine
state into it (absolute paths, trust entries, MCP credentials). The tracked
profile at `codex/dots.config.toml` is layered on top via `codex -p dots`.

**`setup.sh` is `/bin/sh`, not bash.** No arrays, no `[[ ]]`.

## Conventions

Themes are per-tool files scattered across `nvim/`, `kitty/`, `alacritty/`,
`tmux/`, and `claude/themes/`; changing a theme in one place does not change it
elsewhere. The `theme-consistency` agent reports mismatches.

`output/` is gitignored scratch space.
