export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dracula"
plugins=(git)
plugins+=(gradle-completion)
plugins+=(zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
export IGNORE_UPDATE=false

# Load the shell dotfiles:
# - .path for extending PATH
# - .aliases for custom aliases
# - .exports for custom exports
for file in $HOME/.{path,aliases,exports,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source $file;
done;

source $HOME/tools/check_for_updates.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source local config files
if [[ -f ~/.zshrc-$HOST ]]; then
    source ~/.zshrc-$HOST
fi

# Zoxide setup
eval "$(zoxide init zsh)"

# Theme customization
DRACULA_DISPLAY_CONTEXT=1
DRACULA_DISPLAY_TIME=1
