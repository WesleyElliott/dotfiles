
function get_current_branch {
    return git rev-parse --abbrev-ref HEAD
}

function push_dotfiles {
    local branch=$(get_current_branch)
    dotfiles push origin $branch
}

function pull_dotfiles {
    local branch=$(get_current_branch)
    dotfiles pull origin $branch
}

function check_remote {
    local branch=$(get_current_branch)
    source $HOME/.functions
    dotfiles fetch
    
    return dotfiles_status $branch
}

check_remote
if [ $? = 1 ]; then
    # We are ahead, so ask to push changes
    echo -n "[dotfiles] Unpushed changes found, push to origin? [Y/n]\n"
    read -r -k option
    case "$option" in
        [yY$'\n']) push_dotfiles ;;
        [nN]) echo "Not pushing.\n" ;;
    esac
elif [ $? = -1 ]; then
    # We are behind, so ask to pull and update
    echo -n "[dotfiles] Would you like to update? [Y/n]\n"
    read -r -k option
    case "$option" in
        [yY$'\n']) pull_dotfiles ;;
        [nN]) echo "Not updating.\n" ;;
    esac
elif [ $? = -2 ]; then
    # We have diverged, inform of possible conflics
    echo -n "[dotfiles] Local and remote changes found, please deal with conflicts and update\n"
fi

