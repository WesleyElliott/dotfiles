BRANCH=$( dotfiles rev-parse --abbrev-ref HEAD )
RESULT=0

function push_dotfiles {
    dotfiles push origin $BRANCH --quiet
}

function pull_dotfiles {
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
    echo -n "[dotfiles] Unpushed changes found, push to origin? [Y/n]\n"
    read -r -k option
    case "$option" in
        [yY$'\n']) push_dotfiles ;;
        [nN]) echo "Not pushing.\n" ;;
    esac
elif [ $RESULT = -1 ]; then
    # We are behind, so ask to pull and update
    echo -n "[dotfiles] Would you like to update? [Y/n]\n"
    read -r -k option
    case "$option" in
        [yY$'\n']) pull_dotfiles ;;
        [nN]) echo "Not updating.\n" ;;
    esac
elif [ $RESULT = -2 ]; then
    # We have diverged, inform of possible conflics
    echo -n "[dotfiles] Local and remote changes found, please deal with conflicts and update\n"
fi

