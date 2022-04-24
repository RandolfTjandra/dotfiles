eval "$(/opt/homebrew/bin/brew shellenv)"

fortune | cowsay -f $(ls /opt/homebrew/Cellar/cowsay/3.04_1/share/cows | gshuf -n1) | lolcat
