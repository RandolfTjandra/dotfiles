#!bin/sh
if [ -z "$DOTS" ]; then
  echo "where is dotfiles?"
  read dotslocation
  export DOTS=$dotslocation
else
  dotslocation=${DOTS}
fi

# target: ~/.config
ln -sfn $dotslocation/lsd ~/.config/lsd
ln -sfn $dotslocation/kitty ~/.config/kitty
ln -sfn $dotslocation/neofetch ~/.config/neofetch
ln -sfn $dotslocation/nvim ~/.config/nvim
ln -sfn $dotslocation/sketchybar ~/.config/sketchybar
ln -sfn $dotslocation/skhd ~/.config/skhd
ln -sfn $dotslocation/spacebar ~/.config/spacebar
ln -sfn $dotslocation/tmux ~/.config/tmux
ln -sfn $dotslocation/yabai ~/.config/yabai
ln -sfn $dotslocation/zsh ~/.config/zsh
ln -sfn $dotslocation/karabiner ~/.config/karabiner

# target: ~
ln -sfn $dotslocation/.hammerspoon ~/.hammerspoon
ln -sfn $dotslocation/.zprofile ~/.zprofile
ln -sfn $dotslocation/.zshrc ~/.zshrc
ln -sfn $dotslocation/.gitconfig ~/.gitconfig
ln -sfn $dotslocation/.gitmessage ~/.gitmessage

