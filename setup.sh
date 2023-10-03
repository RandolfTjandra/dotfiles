#!bin/sh
if [ -z "$DOTS" ]; then
  echo "where is dotfiles?"
  read dotslocation
  export DOTS=$dotslocation
else
  dotslocation=${DOTS}
fi

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

