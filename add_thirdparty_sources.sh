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

addDocker() {
  # Setup for docker
  echo "=== Adding Docker ==="
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic test"
}

addAll() {
    addDocker
}

if [ -z $1 ]; then
    addAll
else
    $@
fi

#sudo apt-get update
