#!/usr/bin/env bash

# https://github.com/wslutilities/wslu#debian

# install wslu with apt

sudo apt-get install gnupg2 apt-transport-https

wget -O - https://access.patrickwu.space/wslu/public.asc | sudo apt-key add -
echo "deb https://access.patrickwu.space/wslu/debian buster main" | sudo tee -a /etc/apt/sources.list
sudo apt update

sudo apt install wslu
