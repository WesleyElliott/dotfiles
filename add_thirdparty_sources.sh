#!/usr/bin/env bash

checkSource() {
    REPO=$1
    FILE=$2

    if grep -Fxq "$REPO" "$FILE" ; then
        return 0
    else
        return 1
    fi
}

addChrome() {
    # Add chrome
    echo "==== Adding Chrome ===="
    CHROME_REPO="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
    CHROME_SOURCE="/etc/apt/sources.list.d/google-chrome.list"
    sudo touch "$CHROME_SOURCE"
    if checkSource "$CHROME_REPO" "$CHROME_SOURCE" ; then
        echo "Chrome repo already added"
    else
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        echo "$CHROME_REPO" | sudo tee "$CHROME_SOURCE"
    fi
}

addAtom() {
    # Add atom
    echo "==== Adding Atom ===="
    ATOM_REPO="deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
    ATOM_SOURCE="/etc/apt/sources.list.d/atom.list"
    sudo touch "$ATOM_SOURCE"
    if checkSource "$ATOM_REPO" "$ATOM_SOURCE" ; then
        echo "Atom repo already added"
    else
        wget -q -O - https://packagecloud.io/AtomEditor/gpgkey | sudo apt-key add -
        echo "$ATOM_REPO" | sudo tee "$ATOM_SOURCE"
    fi
}

addPlex() {
    # Add plex media server
    echo "==== Adding Plex ===="
    PLEX_REPO="deb https://downloads.plex.tv/repo/deb public main"
    PLEX_SOURCE="/etc/apt/sources.list.d/plexmediaserver.list"
    sudo touch "$PLEX_SOURCE"
    if checkSource "$PLEX_REPO" "$PLEX_SOURCE" ; then
        echo "Plex repo already added"
    else
        curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
        echo "$PLEX_REPO" | sudo tee "$PLEX_SOURCE"
    fi

}

addPapirus() {
    # Add papirus icons
    echo "==== Adding Papirus ===="
    sudo add-apt-repository -y ppa:papirus/papirus
}

addDocker() {
  # Setup for docker
  echo "=== Adding Docker ==="
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic test"
}

addAll() {
    addChrome
    addAtom
    addPlex
    addPapirus
    addDocker
}

if [ -z $1 ]; then
    addAll
else
    $@
fi

#sudo apt-get update
