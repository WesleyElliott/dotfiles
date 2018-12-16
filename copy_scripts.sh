#!/usr/bin/env bash

. ./color.sh

SCRIPTS_DIR="$(pwd)/.scripts"

link_scripts() {
    # Link the general scripts
    
    # Check for machine specific scripts
    if [ -e $SCRIPTS_DIR/$HOSTNAME ]; then
        # Make the directory if it doesn't exist
        mkdir -p ~/.scripts
        
        # Link each machine specific script
        for FILE in $SCRIPTS_DIR/$HOSTNAME/*; do
            echo -e "${GREEN}Linking script: $FILE...${NOCOLOR}"
            FILENAME=${FILE##*/}
            ln -sf $FILE ~/.scripts/$FILENAME
        done
    fi
}

# Run the link
link_scripts
