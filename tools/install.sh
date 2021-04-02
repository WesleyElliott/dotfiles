#!/bin/sh
set -e

# Repository details

REPO=${REPO:-WesleyElliott/dotfiles.git}
REMOTE=${REMOTE:-https://github.com/${REPO}}

# Default branch is main, but can be specified
BRANCH=${BRANCH:-main}

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

function dotfiles {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# Setup the dotfiles by cloning the bare repo. Alias is set before hand
# to allow using our custom "dotfiles" git alias.
setup_dotfiles() {
    echo "${BLUE}Cloning dotiles...${RESET}"
    command_exists git || {
        printf "%sError: git is not installed%s\n" $BOLD$RED $RESET
        exit 1
    }

    echo ".dotfiles" >> .gitignore
    SUCCESS=0
    git clone --bare --quiet --branch "$BRANCH" "$REMOTE" "$HOME/.dotfiles" > /dev/null || SUCCESS=1
    if [ $SUCCESS = 1 ]; then
        printf "%sError: could not checkout dotfiles. Does .dotfiles exist already?%s\n" $BOLD$RED $RESET
        exit 1
    fi

    mkdir -p .dotfiles-backup
    dotfiles checkout -f
    dotfiles config --local --add remote.origin.fetch "+refs/heads/*:/refs/remotes/origin/*"
    dotfiles fetch origin --quiet
    dotfiles branch -u origin/$BRANCH
    echo "${GREEN}Checked out dotfiles.${RESET}"
    dotfiles config status.showUntrackedFiles no
}

setup_color() {
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

main() {
    setup_color
    echo "${GREEN}Setting up dotfiles...${RESET}"
    sleep 2
    setup_dotfiles
}

main
