echo where is bash-stuff?

read bashstufflocation

echo creating .zshrc for $bashstufflocation/.zshrc
ln -s $bashstufflocation/.zshrc ~/.zshrc

echo creating .zprofile for $bashstufflocation/.zprofile
ln -s $bashstufflocation/.zprofile ~/.zprofile

echo creating symlink to $bashstufflocation/zsh
ln -s $bashstufflocation/zsh ~/.config/zsh
