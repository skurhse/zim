#!/usr/bin/env bash

# REQ: Installs pip via apt. <skr 2022-07>

set -o errexit

sudo apt-get update
sudo apt-get install python3-pip --assume-yes
