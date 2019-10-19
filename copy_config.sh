#!/usr/bin/env bash

. ./color.sh

CONFIG_DIR="$(pwd)/.config"

link_config() {
    # Link the config
    
    # Check for machine specific scripts
    if [ -e $CONFIG_DIR/$HOSTNAME ]; then
        # Make the directory if it doesn't exist
        mkdir -p ~/.config
        
        # Link each machine specific script
        for FILE in $CONFIG_DIR/$HOSTNAME/*; do
            echo -e "${GREEN}Linking config: $FILE...${NOCOLOR}"
            FILENAME=${FILE##*/}
            ln -sf $FILE ~/.config/$FILENAME
        done
    fi
}

# Run the link
echo "Linking config"
link_config
