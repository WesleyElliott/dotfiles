#!/usr/bin/env bash

. ./color.sh

DOTFILES_DIR="$(pwd)/.dotfiles"

# Deprecated in favour of linking dotfiles, but kept just in case
copy_dotfiles() {
    # Copy general dotfiles
    echo -e "${GREEN}Copying dotfiles...${NOCOLOR}"
    cp $DOTFILES_DIR/.imwheelrc $DOTFILES_DIR/.vimrc $DOTFILES_DIR/.zshrc ~/
    
    # Copy machine specific dotfiles
    
    if [ -e $DOTFILES_DIR/.zshrc-$HOSTNAME ]; then
        echo -e "${GREEN}zshrc found for $HOSTNAME, copying..${NOCOLOR}"
        cp $DOTFILES_DIR/.zshrc-$HOSTNAME ~/
    fi
}

link_dotfiles() {
    # Link the general dotfiles
    echo -e "${GREEN}Linking dotfiles...${NOCOLOR}"
    ln -sf $DOTFILES_DIR/.imwheelrc ~/.imwheelrc
    ln -sf $DOTFILES_DIR/.vimrc ~/.vimrc
    ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc

    # Link machine specific dotfiles
    if [ -e $DOTFILES_DIR/.zshrc-$HOSTNAME ]; then
        echo -e "${GREEN}zshrc found for $HOSTNAME, linking...${NOCOLOR}"
        ln -sf $DOTFILES_DIR/.zshrc-$HOSTNAME ~/.zshrc-$HOSTNAME
    fi
}

# Run the link
link_dotfiles
