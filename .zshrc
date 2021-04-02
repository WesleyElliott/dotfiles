export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="ys"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Load the shell dotfiles:
# - .path for extending PATH
# - .aliases for custom aliases
# - .exports for custom exports
for file in $HOME/.{path,aliases,exports,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source $file;
done;

source $HOME/tools/check_for_updates.sh
