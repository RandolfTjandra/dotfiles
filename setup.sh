echo where is bash-stuff?

read bashstufflocation

echo creating .zshrc for $bashstufflocation/.zshrc
ln -s $bashstufflocation/.zshrc ~/.zshrc

echo creating .zprofilefor $bashstufflocation/.zprofile
ln -s $bashstufflocation/.zprofile ~/.zprofile
