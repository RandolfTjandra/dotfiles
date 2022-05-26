eval "$(/usr/local/bin/brew shellenv)"
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/randolf_at_crunchyroll_com
ssh-add --apple-use-keychain ~/.ssh/randolftjandra_at_crunchyroll_com
#--apple-use-keychain and --apple-load-keychain



export BASH_STUFF="/Users/rtjandra/Dev/bash-stuff/"

#fortune | cowsay -f $(ls /opt/homebrew/Cellar/cowsay/3.04_1/share/cows | gshuf -n1) | lolcat

#fortune | cowsay | lolcat

# Setting PATH for Python 2.7
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
