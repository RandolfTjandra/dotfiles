#!bin/sh
if [ -z "$DOTFILES" ]; then
  echo "Setting DOTFILES=$(pwd)"
  export DOTFILES=$(pwd)
fi
dotslocation=${DOTFILES}

# target: ~/.config
ln -sfn $dotslocation/lsd ~/.config
ln -sfn $dotslocation/kitty ~/.config
ln -sfn $dotslocation/neofetch ~/.config
ln -sfn $dotslocation/nvim ~/.config
ln -sfn $dotslocation/sketchybar ~/.config
ln -sfn $dotslocation/skhd ~/.config
ln -sfn $dotslocation/spacebar ~/.config
ln -sfn $dotslocation/tmux ~/.config
ln -sfn $dotslocation/yabai ~/.config
ln -sfn $dotslocation/zsh ~/.config
ln -sfn $dotslocation/karabiner ~/.config

# target: ~
ln -sfn $dotslocation/.hammerspoon ~/.hammerspoon
ln -sfn $dotslocation/.zprofile ~/.zprofile
ln -sfn $dotslocation/.zshrc ~/.zshrc
ln -sfn $dotslocation/.gitconfig ~/.gitconfig
ln -sfn $dotslocation/.gitmessage ~/.gitmessage
ln -sfn $dotslocation/.gitignore ~/.gitignore
ln -sfn $dotslocation/git/.git-templates ~/.git-templates
ln -sfn $dotslocation/git/hooks ~/.git-hooks

