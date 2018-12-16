#!/usr/bin/env bash

. ./color.sh

SCRIPTS_DIR="$(pwd)/.scripts/*"

link_scripts() {
    # Link the general scripts

    # First make the ~/.scripts folder if it doesn't exist
    mkdir -p ~/.scripts

    for FILE in $SCRIPTS_DIR; do
        echo -e "${GREEN}Linking script: $FILE...${NOCOLOR}"
        FILENAME=${FILE##*/}
        ln -sf $FILE ~/.scripts/$FILENAME
    done
}

# Run the link
link_scripts
