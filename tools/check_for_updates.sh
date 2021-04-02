
function update_dotfiles {
    dotfiles pull
}

function check_remote {
    dotfiles update-index --quiet --refresh
    local CHANGES=0
    dotfiles diff-index --quiet --exit-code HEAD -- || CHANGES=1
    
    return CHANGES
}

check_remote
if [ $? = 1 ]; then
    # There are updates, ask to update
    echo -n "[dotfiles] Would you like to update? [Y/n] "
    read-r -k 1 option
    case "$option" in
        [yY$'\n']) update_dotfiles ;;
        [nN]) echo "Not updating." ;;
    esac
fi
