#!/usr/bin/env bash

sudo apt-get install curl # needed for some thirdparty apps
./add_thirdparty_sources.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="${DIR}/packages"
PACKAGES="$(cat ${DIR}/default_packages.list)"
NPM_PACKAGES="$(cat ${DIR}/npm_packages.list)"
DESKTOP_SESSION_PACKAGES="$(cat ${DIR}/${DESKTOP_SESSION}.list)"

touch unsuccessful.log

while read -r line; do
    NAME="$line"
    echo "Installing package $NAME"
    sudo apt-get install -y $NAME || echo "Package $NAME  unsuccessful" >> unsuccessful.log
done <<< "$PACKAGES"

# Install npm packages
while read -r line; do
    NAME="$line"
    echo "Installing $NAME"
    npm install -g $NAME || echo "NPM Package $NAME unsuccessful" >> unsuccessful.log
done <<< "$NPM_PACKAGES"

# Install desktop session specific packages
while read -r line; do
    NAME="$line"
    echo "Installing $DESKTOP_SESSION $NAME"
    sudo apt-get install -y $NAME || echo "$DESKTOP_SESSION Package $NAME  unsuccessful" >> unsuccessful.log
done <<< "$DESKTOP_SESSION_PACKAGES"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install docker-machine
base=https://github.com/docker/machine/releases/download/v0.16.0
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
sudo install /tmp/docker-machine /usr/local/bin/docker-machine
