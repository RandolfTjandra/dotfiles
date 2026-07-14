#!/bin/sh

# Set DOTFILES variable if not already set
if [ -z "$DOTFILES" ]; then
  echo "Setting DOTFILES to current directory: $(pwd)"
  export DOTFILES="$(pwd)"
fi
dotslocation="${DOTFILES}"

# Ensure ~/.config exists
if [ ! -d "$HOME/.config" ]; then
  echo "Creating $HOME/.config directory"
  mkdir -p "$HOME/.config"
fi

echo "Linking config directories..."

for dir in cmux fzf ghostty lsd kitty neofetch nvim sketchybar skhd spacebar tmux yabai zsh karabiner; do
  src="${dotslocation}/${dir}"
  dest="$HOME/.config/${dir}"
  if [ -e "$src" ]; then
    ln -sfn "$src" "$dest"
    echo "Linked $src -> $dest"
  else
    echo "Warning: $src does not exist, skipping."
  fi
done

echo "Linking home files..."

for file in .bashrc .fzf.bash .fzf.zsh .gitconfig .gitmessage .p10k.zsh .screenrc .zprofile .zshrc; do
  src="${dotslocation}/home/${file}"
  dest="$HOME/${file}"
  if [ -e "$src" ]; then
    ln -sfn "$src" "$dest"
    echo "Linked $src -> $dest"
  else
    echo "Warning: $src does not exist, skipping."
  fi
done

gitignore_src="${dotslocation}/.gitignore"
gitignore_dest="$HOME/.gitignore"
if [ -e "$gitignore_src" ]; then
  ln -sfn "$gitignore_src" "$gitignore_dest"
  echo "Linked $gitignore_src -> $gitignore_dest"
else
  echo "Warning: $gitignore_src does not exist, skipping."
fi

hammerspoon_src="${dotslocation}/hammerspoon"
hammerspoon_dest="$HOME/.hammerspoon"
if [ -d "$hammerspoon_src" ]; then
  ln -sfn "$hammerspoon_src" "$hammerspoon_dest"
  echo "Linked $hammerspoon_src -> $hammerspoon_dest"
else
  echo "Warning: $hammerspoon_src does not exist, skipping."
fi

codex_root_dest="$HOME/.codex"
if [ ! -d "$codex_root_dest" ]; then
  echo "Creating $codex_root_dest directory"
  mkdir -p "$codex_root_dest"
fi

codex_config_src="${dotslocation}/codex/config.toml"
codex_config_dest="${codex_root_dest}/config.toml"
if [ -e "$codex_config_src" ]; then
  ln -sfn "$codex_config_src" "$codex_config_dest"
  echo "Linked $codex_config_src -> $codex_config_dest"
else
  echo "Warning: $codex_config_src does not exist, skipping."
fi

codex_skills_src="${dotslocation}/codex/skills"
codex_skills_dest="${codex_root_dest}/skills"
if [ -d "$codex_skills_src" ]; then
  ln -sfn "$codex_skills_src" "$codex_skills_dest"
  echo "Linked $codex_skills_src -> $codex_skills_dest"
else
  echo "Warning: $codex_skills_src does not exist, skipping."
fi

agents_src="${dotslocation}/.agents"
agents_dest="$HOME/.agents"
if [ -d "$agents_src" ]; then
  ln -sfn "$agents_src" "$agents_dest"
  echo "Linked $agents_src -> $agents_dest"
else
  echo "Warning: $agents_src does not exist, skipping."
fi

claude_root_dest="$HOME/.claude"
if [ ! -d "$claude_root_dest" ]; then
  echo "Creating $claude_root_dest directory"
  mkdir -p "$claude_root_dest"
fi

claude_settings_src="${dotslocation}/claude/settings.json"
claude_settings_dest="${claude_root_dest}/settings.json"
if [ -e "$claude_settings_src" ]; then
  ln -sfn "$claude_settings_src" "$claude_settings_dest"
  echo "Linked $claude_settings_src -> $claude_settings_dest"
else
  echo "Warning: $claude_settings_src does not exist, skipping."
fi

claude_themes_src="${dotslocation}/claude/themes"
claude_themes_dest="${claude_root_dest}/themes"
if [ -d "$claude_themes_src" ]; then
  ln -sfn "$claude_themes_src" "$claude_themes_dest"
  echo "Linked $claude_themes_src -> $claude_themes_dest"
else
  echo "Warning: $claude_themes_src does not exist, skipping."
fi

claude_skills_dest="${claude_root_dest}/skills"
mkdir -p "$claude_skills_dest"
agents_skills_src="${dotslocation}/.agents/skills"
if [ -d "$agents_skills_src" ]; then
  for skill_dir in "$agents_skills_src"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    ln -sfn "$skill_dir" "${claude_skills_dest}/${skill_name}"
    echo "Linked $skill_dir -> ${claude_skills_dest}/${skill_name}"
  done
else
  echo "Warning: $agents_skills_src does not exist, skipping."
fi

claude_skills_src="${dotslocation}/claude/skills"
if [ -d "$claude_skills_src" ]; then
  for skill_dir in "$claude_skills_src"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    ln -sfn "$skill_dir" "${claude_skills_dest}/${skill_name}"
    echo "Linked $skill_dir -> ${claude_skills_dest}/${skill_name}"
  done
else
  echo "Warning: $claude_skills_src does not exist, skipping."
fi

echo "Linking binaries..."

mkdir -p "$HOME/.local/bin"

for bin in diff-so-fancy; do
  src="${dotslocation}/bin/${bin}"
  dest="$HOME/.local/bin/${bin}"
  if [ -e "$src" ]; then
    ln -sfn "$src" "$dest"
    echo "Linked $src -> $dest"
  else
    echo "Warning: $src does not exist, skipping."
  fi
done

# Link git templates and hooks if they exist
if [ -e "${dotslocation}/git/.git-templates" ]; then
  ln -sfn "${dotslocation}/git/.git-templates" "$HOME/.git-templates"
  echo "Linked ${dotslocation}/git/.git-templates -> $HOME/.git-templates"
else
  echo "Warning: ${dotslocation}/git/.git-templates does not exist, skipping."
fi

if [ -e "${dotslocation}/git/hooks" ]; then
  ln -sfn "${dotslocation}/git/hooks" "$HOME/.git-hooks"
  echo "Linked ${dotslocation}/git/hooks -> $HOME/.git-hooks"
else
  echo "Warning: ${dotslocation}/git/hooks does not exist, skipping."
fi

# Symlink the entire gitconfig directory for environment-specific git configs
if [ -d "${dotslocation}/gitconfig" ]; then
  ln -sfn "${dotslocation}/gitconfig" "$HOME/.config/gitconfig"
  echo "Symlinked ${dotslocation}/gitconfig -> $HOME/.config/gitconfig"
else
  echo "Warning: ${dotslocation}/gitconfig does not exist, skipping."
fi

echo "Dotfiles setup complete."
