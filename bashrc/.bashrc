#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Change this so that there is a user@host whenever SSH is active but I cant be asked to do that rn
PS1='$? \W$(__git_ps1 " (%s)")\$ '

# Color Definitions
RESET='\[\033[0m\]'
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias d='cd ~/.dotfiles'
alias sb='source ~/.bashrc'

eval "$(thefuck --alias)"
export PATH=$PATH:~/.config/emacs/bin
export PATH=$PATH:~/.scripts
export PATH=$PATH:/etc/profile

# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

# Bash history: “ignoredups” and “erasedups” setting conflict with common history across sessions
# https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history/18443#18443?newreg=ad3ea662cd754c148058a0c44d22102f
# https://www.linuxjournal.com/content/using-bash-history-more-efficiently-histcontrol
HISTCONTROL=ignorespace:ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

shopt -s histverify

# Git prompts
# https://mjswensen.com/blog/git-status-prompt-options/
source /usr/share/git/completion/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=verbose
GIT_PS1_DESCRIBE_STYLE=branch
