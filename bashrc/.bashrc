#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias d='cd ~/.dotfiles'
alias c='clear'

# Git fast commit func
gfc() {
    if [ $# -eq 0 ]; then
        echo "Error: You must provide a commit message."
        return 1
    fi

    # Join all arguments into a single commit message
    commit_message="$*"

    git add .
    git commit -m "$commit_message"
    git push
}


PS1='[\u@\h \W]\$ '

eval "$(thefuck --alias)"
export PATH=$PATH:~/.config/emacs/bin
export PATH=$PATH:/usr/lib/aurutils
