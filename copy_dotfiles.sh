#!/usr/bin/env bash

. ./color.sh

DOTFILES_DIR=.dotfiles

# Copy general dotfiles
echo -e "${GREEN}Copying dotfiles...${NOCOLOR}"
cp $DOTFILES_DIR/.imwheelrc $DOTFILES_DIR/.vimrc $DOTFILES_DIR/.zshrc ~/

# Copy machine specific dotfiles

if [ -e $DOTFILES_DIR/.zshrc-$HOSTNAME ]; then
    echo -e "${GREEN}zshrc found for $HOSTNAME, copying..${NOCOLOR}"
    cp $DOTFILES_DIR/.zshrc-$HOSTNAME ~/
fi
