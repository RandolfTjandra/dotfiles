# Start or continue tmux on new window
source "$HOME/.config/zsh/tmux_start"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '[%b]'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%n in ${PWD/#$HOME/~} > '

# right prompt
export RPROMPT='${vcs_info_msg_0_}'

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# only show current dir in prompt
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--prompt="› " --pointer="›" --marker="›"'

# Set neovim as default editor
export EDITOR=nvim

# auto complete
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# maybe delete
bindkey -e

export PATH=~/Library/Python/2.7/bin:$PATH

# Aliases
source "$HOME/.config/zsh/aliases"

# Wk
export WK_KEY="c030d600-1051-417f-84c2-fe0f5546d96d"

# charmbracelet mods
export OPENAI_API_KEY="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"

#export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/randolftjandra/.cargo/bin:/Applications/kitty.app/Contents/MacOS:/opt/homebrew/opt/fzf/bin

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# 1Password auto complete
eval "$(op completion zsh)"; compdef _op op
source /Users/randolftjandra/.config/op/plugins.sh
