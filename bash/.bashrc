# .bashrc

# User specific aliases and functions

bind "set completion-ignore-case on"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls -aFhlG'
alias gogo='cd /Users/rtjandra/Dev/projects/cx-projects/golang/src/github.com'
alias projects='cd /Users/rtjandra/Dev/projects/cx-projects'

alias vim='nvim'


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PATH=$PATH:/usr/local/rvm/bin # Add RVM to PATH for scripting

export CLICOLOR=1
LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

# old
# export PS1='\[\e[0;34m\]${PWD##*/}\[\e[0;97m\] on \[\e[0;35m\]\h \[\e[0;97m\]›\[\e[0m\] '   

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# get current branch in git repo
function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
                STAT=`parse_git_dirty`
                echo "[${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

# get current status of git repo
function parse_git_dirty {
        status=`git status 2>&1 | tee`
        dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
        untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
        ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
        newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
        renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
        deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
        bits=''
        if [ "${renamed}" == "0" ]; then
                bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
                bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
                bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
                bits="?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
                bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
                bits="!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
                echo " ${bits}"
        else
                echo ""
        fi
}

export PS1="\[\e[0;35m\]\h\[\e[m\]:\[\e[0;34m\]\W\[\e[m\]\[\e[33m\]\`parse_git_branch\`\[\e[m\] as \[\e[32m\]\u\[\e[m\] > "

export EDITOR=nvim
