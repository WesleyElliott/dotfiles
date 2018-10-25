export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="ys"
plugins=(git)

source $ZSH/oh-my-zsh.sh

alias zshconfig="vim ~/.zshrc"

if [[ -f ~/.zshrc-$HOST ]]; then
    source ~/.zshrc-$HOST
fi
