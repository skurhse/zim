#!/usr/bin/env bash

# Installs the docker apt repository and docker.

# REQ: https://docs.docker.com/engine/install/debian/ <>
# REQ: https://docs.docker.com/engine/install/linux-postinstall/ <>

# HACK: update-alternatives --config iptables for WSL2. <dru 2021-09-28>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail

# set -o verbose
# set -o xtrace

keyserver='https://download.docker.com/linux/debian/gpg'
keyring='/usr/share/keyrings/docker-archive-keyring.gpg'
fingerprint='8D81803C0EBFCD88'
list='/etc/apt/sources.list.d/docker.list'

declare -ar dependencies=(
  'apt-transport-https'
  'ca-certificates'
  'curl'
  'gnupg'
  'lsb-release'
)

declare -a packages=(
    'docker-ce'
    'docker-ce-cli'
    'containerd.io'
)

sudo apt-get update
sudo apt-get install "${dependencies[@]}"

sudo gpg \
  --no-default-keyring \
  --keyring "$keyring" \
  --keyserver "$keyserver" \
  --recv-keys "$fingerprint"

sudo bash -c "echo 'deb [arch=amd64 signed-by=$keyring] ${keyserver%/*} $(lsb_release -cs) stable' > $list"

sudo apt update
sudo apt install "${packages[@]}"

sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
