#!/usr/bin/env bash

echo "Installing (a)NodeJS and (b) Angular-CLI (Command Line Interface)"

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs
# sudo npm install -g @angular/cli --allow-root
