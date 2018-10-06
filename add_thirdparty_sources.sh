#!/usr/bin/env bash

## Google
# Add google upstream key
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# add the repo for chrome
sudo touch /etc/apt/sources.list.d/google-chrome.list
REPO_LINE="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
if grep -Fxq "$REPO_LINE" /etc/apt/sources.list.d/google-chrome.list
then
    echo "Google Repo already added"
else
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
fi

# Adds atom

sudo add-apt-repository -y ppa:webupd8team/atom

# Add plex media server
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

# Add papirus icons
sudo add-apt-repository -y ppa:papirus/papirus

# Update apt
sudo apt-get update
