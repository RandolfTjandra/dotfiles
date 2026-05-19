# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
# [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
[[ $- == *i* ]] && source ~/.config/fzf/completion.zsh 2> /dev/null

# Key bindings
# ------------
source ~/.config/fzf/key-bindings.zsh
