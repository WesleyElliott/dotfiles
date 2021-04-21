#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias dotfiles='/usr/bin/git --git-dir=/home/wesley/.dotfiles --work-tree=/home/wesley'


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
