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
    printf "\n${BLUE}%s${RESET}\n" "[dotfiles] Pushing..."
    if dotfiles push origin $BRANCH --quiet; then
        printf "${GREEN}${BOLD}%s${RESET}\n" "[dotfiles] Push complete!"
    else
        printf "${RED}${BOLD}%s${RESET}\n" "[dotfiles] Push failed."
    fi
}

function pull_dotfiles {
    printf "\n${BLUE}%s${RESET}\n" "[dotfiles] Updating..."
    if dotfiles pull origin $BRANCH --quiet; then
        printf "${GREEN}${BOLD}%s${RESET}\n" "[dotfiles] Update complete!"
    else
        printf "${RED}%s${RESET}\n" "[dotfiles] Pull failed."
    fi
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
if [ "$IGNORE_UPDATE" = true ]; then
    return
fi

if [ $RESULT = 1 ]; then
    # We are ahead, so ask to push changes
    printf "${BLUE}%s${RESET}\n" "[dotfiles] Push changes to origin? [Y/n]"
    read -r -k option
    case "$option" in
        [yY$'\n']) push_dotfiles ;;
        [nN]) echo "[dotfiles] Not pushing.\n" ;;
    esac
elif [ $RESULT = -1 ]; then
    # We are behind, so ask to pull and update
    printf "${BLUE}%s${RESET}\n" "[dotfiles] Would you like to update? [Y/n]"
    read -r -k option
    case "$option" in
        [yY$'\n']) pull_dotfiles ;;
        [nN]) echo "[dotfiles] Not updating.\n" ;;
    esac
elif [ $RESULT = -2 ]; then
    # We have diverged, inform of possible conflics
    printf "${RED}%s${RESET}\n" "[dotfiles] Local and remote are out of sync. Fix conflicts..."
fi
