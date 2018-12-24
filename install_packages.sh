#!/usr/bin/env bash

sudo apt-get install curl # needed for some thirdparty apps
./add_thirdparty_sources.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="${DIR}/packages"
PACKAGES="$(cat ${DIR}/default_packages.list)"
ANDROID_STUDIO_PACKAGES="$(cat ${DIR}/android_studio.list)"
TAR_PACKAGES="$(cat ${DIR}/tar_packages.list)"
DEB_PACKAGES="$(cat ${DIR}/deb_packages.list)"

touch unsuccessful.log

while read -r line; do
    NAME="$line"
    echo "Installing package $NAME"
    sudo apt-get install -y $NAME || echo "Package $NAME  unsuccessful" >> unsuccessful.log
done <<< "$PACKAGES"

# Install 32bit libs for Android Studio
while read -r line; do
    NAME="$line"
    echo "Installing package $NAME"
    sudo apt-get install -y $NAME || echo "Package $NAME unsuccessful" >> unsuccessful.log
done <<< "$ANDROID_STUDIO_PACKAGES"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install docker-machine
base=https://github.com/docker/machine/releases/download/v0.16.0
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
sudo install /tmp/docker-machine /usr/local/bin/docker-machine
