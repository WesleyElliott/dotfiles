#!/usr/bin/env bash

sudo apt-get install curl # needed for some thirdparty apps
./add_thirdparty_sources.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="${DIR}/packages"
PACKAGES="$(cat ${DIR}/default_packages.list)"
TAR_PACKAGES="$(cat ${DIR}/tar_packages.list)"
DEB_PACKAGES="$(cat ${DIR}/deb_packages.list)"

touch unsuccessful.log

while read -r line; do
  NAME="$line"
  echo "Installing package $NAME"
  sudo apt-get install -y $NAME || echo "Package $NAME  unsuccessful" >> unsuccessful.log
done <<< "$PACKAGES"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
