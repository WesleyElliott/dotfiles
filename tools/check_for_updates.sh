#!/usr/bin/env zsh
 
BRANCH=$( dotfiles rev-parse --abbrev-ref HEAD )
RESULT=0

RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
DIM=$(printf '\033[2m')
UNDER=$(printf '\033[4m')
RESET=$(printf '\033[m')

function push_dotfiles {
    printf "${BLUE}%s${RESET}\n" "Pushing..."
    dotfiles push origin $BRANCH --quiet
}

function pull_dotfiles {
    printf "${BLUE}%s${RESET}\n" "Updating..."
    dotfiles pull origin $BRANCH --quiet
}

function check_remote {
    source $HOME/.functions
    source $HOME/.aliases
    dotfiles fetch origin $BRANCH --quiet

    dotfiles_status $BRANCH
    local result=$?
    return $result
}


check_remote
RESULT=$?

if [ $RESULT = 1 ]; then
    # We are ahead, so ask to push changes
    printf "${BLUE}%s${RESET}\n" "Push changes to origin? [Y/n]"
    read -r -k option
    case "$option" in
        [yY$'\n']) push_dotfiles ;;
        [nN]) echo "Not pushing.\n" ;;
    esac
elif [ $RESULT = -1 ]; then
    # We are behind, so ask to pull and update
    printf "${BLUE}%s${RESET}\n" "[dotfiles] Would you like to update? [Y/n]"
    read -r -k option
    case "$option" in
        [yY$'\n']) pull_dotfiles ;;
        [nN]) echo "Not updating.\n" ;;
    esac
elif [ $RESULT = -2 ]; then
    # We have diverged, inform of possible conflics
    printf "${RED}%s${RESET}\n" "[dotfiles] Local and remote are out of sync. Fix conflicts..."
fi

