# Start or continue tmux on new window
# Commented out for cursor
# if [[ -o interactive ]]; then
#   source "$HOME/.config/zsh/tmux_start"
# fi

source "$HOME/.config/zsh/save_tmux_history"

# History Settings
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=50000
SAVEHIST=50000

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
if [[ -o interactive ]]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

if [[ -o interactive ]]; then
  # Load version control information
  autoload -Uz vcs_info
  precmd() { vcs_info }

  # Format the vcs_info_msg_0_ variable
  zstyle ':vcs_info:git:*' formats '[%b]'
fi

if [[ -o interactive ]]; then
  # Set up the prompt (with git branch name)
  setopt PROMPT_SUBST
  PROMPT='%n in ${PWD/#$HOME/~} > '
  # right prompt
  export RPROMPT='${vcs_info_msg_0_}'
fi

# python
# Add these lines to prioritize the new Python version
#export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# export PATH="/usr/local/opt/python@3.11/bin:$PATH"

# work laptop intel
# source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# home
if [[ -o interactive ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  # only show current dir in prompt
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
fi

# fzf
if [[ -o interactive ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  export FZF_DEFAULT_OPTS='--prompt="› " --pointer="›" --marker="›"'
fi

# Set neovim as default editor
export EDITOR=nvim

# auto complete
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# maybe delete
bindkey -e

# Aliases
source "$HOME/.config/zsh/aliases"

# Load local secrets (API keys, etc) if present
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

#export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/randolftjandra/.cargo/bin:/Applications/kitty.app/Contents/MacOS:/opt/homebrew/opt/fzf/bin

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# 1Password auto complete
if [[ -o interactive ]]; then
  eval "$(op completion zsh)"; compdef _op op
  source /Users/randolftjandra/.config/op/plugins.sh
fi

export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function get_profile {
  if [[ "$1" == "prod" ]]; then profile="ellationc"; else profile="ellationengc"; fi
  echo "$profile"
}

function find_bastion_ip {
  ip=$(aws ec2 describe-instances --profile $(get_profile "$1") --region us-west-2 --filters "Name=tag-value,Values=${1}-bastion" --query 'Reservations[*].Instances[*].NetworkInterfaces[*].Association.PublicIp' --output text | head -n1)
  echo $ip | tee >(pbcopy)
}

function find_payments_ip {
  service=$(gum choose "secure-payments" "secure-payments.cc" "secure-payments.cron")
  ip=$(aws ec2 describe-instances --profile $(get_profile "$1") --region us-west-2 --filters "Name=tag-value,Values=${1}-$service" --query 'Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddress' --output text | head -n1)
  echo $ip | tee >(pbcopy)
}

function get-apigateway-url {
  item=$(aws apigateway get-rest-apis --profile=${1} --output=json | jq -r '.items | .[] | .name' | fzf)
  query="items[?name=='$item']";
  result=$(aws apigateway get-rest-apis --profile=${1} --output json --query $query | jq -r '.[0] | [{id: .id, vpc: .endpointConfiguration.vpcEndpointIds[]}] | .[0] | join("-")')
  echo "https://$result.execute-api.us-west-2.amazonaws.com/prod" | tee >(pbcopy)
}

function get-ec2-ip {
  item=$(aws ec2 describe-instances --profile=${1} --query 'Reservations[].Instances[].[Tags[?Key==`Name`]| [0].Value]' | sort | uniq | fzf)
  ip=$(aws ec2 describe-instances --profile=${1}  --region us-west-2 --filters "Name=tag-value,Values=${item}" --query 'Reservations[*].Instances[*].NetworkInterfaces[*].PrivateIpAddress' --output text | head -n1)
  echo $ip | tee >(pbcopy)
}

# aws lambda list-functions --profile=ellationeng --output=json | jq -r '.Functions | .[] | .FunctionName' | gum filter
#  get-apigateway-url $(aws lambda list-functions --profile=ellationeng --output=json | jq -r '.Functions | .[] | .FunctionName' | gum filter) ellationeng
#
#  to set the proto0 ami to whatever is set in prod
#  ef-version secure-payments ami-id proto0 --set $(ef-version secure-payments ami-id prod --get) --commit  --noprecheck
#  then use https://jenkins-build.ellationengc.cxc-mgmt.com/job/secure-payments-deploy-proto0/ to deploy
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@13/bin:$PATH

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="/usr/local/opt/openjdk/bin:$PATH"
# Uncomment if working with JS
# export PATH="$(yarn global bin):$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"

# bun completions
# [ -s "/Users/randolf/.bun/_bun" ] && source "/Users/randolf/.bun/_bun"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
#
# source ~/powerlevel10k/powerlevel10k.zsh-theme

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/randolf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

setopt completealiases
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
