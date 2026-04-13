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

for dir in cmux ghostty lsd kitty neofetch nvim sketchybar skhd spacebar tmux yabai zsh karabiner; do
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

for file in .hammerspoon .zprofile .zshrc .gitconfig .gitmessage .gitignore; do
  src="${dotslocation}/${file}"
  dest="$HOME/${file}"
  if [ -e "$src" ]; then
    ln -sfn "$src" "$dest"
    echo "Linked $src -> $dest"
  else
    echo "Warning: $src does not exist, skipping."
  fi
done

codex_src="${dotslocation}/codex"
codex_dest="$HOME/.codex"
if [ -d "$codex_src" ]; then
  ln -sfn "$codex_src" "$codex_dest"
  echo "Linked $codex_src -> $codex_dest"
else
  echo "Warning: $codex_src does not exist, skipping."
fi

agents_src="${dotslocation}/.agents"
agents_dest="$HOME/.agents"
if [ -d "$agents_src" ]; then
  ln -sfn "$agents_src" "$agents_dest"
  echo "Linked $agents_src -> $agents_dest"
else
  echo "Warning: $agents_src does not exist, skipping."
fi

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
