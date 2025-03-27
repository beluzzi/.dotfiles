#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

# Change this so that there is a user@host whenever SSH is active but I cant be asked to do that rn
PS1='$? \W$(__git_ps1 " (%s)")\$ '
# Set Bash to save each command to history, right after it has been executed.
PROMPT_COMMAND='history -a;   # Write current session history
                history -n;   # Read new history from file
                '
# Ignore lines which begin with a <space> and match previous entries.
# Erase duplicate entries in history file.
HISTCONTROL=ignoreboth:erasedups

# Ignore saving short- and other listed commands to the history file.
HISTIGNORE=?:??:history

# The maximum number of lines in the history file.
HISTFILESIZE=99999

# The number of entries to save in the history file.
HISTSIZE=99999

# Save multi-line commands in one history entry.
shopt -s cmdhist

# Append commands to the history file, instead of overwriting it.
# History substitution are not immediately passed to the shell parser.
shopt -s histappend histverify

# Git prompts
# https://mjswensen.com/blog/git-status-prompt-options/
source /usr/share/git/completion/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=verbose
GIT_PS1_DESCRIBE_STYLE=branch
