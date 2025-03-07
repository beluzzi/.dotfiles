#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias d='cd ~/.dotfiles'
alias c='clear'

PS1='[\u@\h \W]\$ '

eval "$(thefuck --alias)"
export PATH=$PATH:~/.config/emacs/bin
export PATH=$PATH:/usr/lib/aurutils
export PATH=$PATH:~/.scripts
