#!/usr/bin/env bash

# Installs the docker apt repository and docker

# REQ: https://docs.docker.com/engine/install/debian/ <dru 2020-06-14>

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

keyserver=https://download.docker.com/linux/debian/gpg
keyring=/usr/share/keyrings/docker-archive-keyring.gpg
fingerprint=8D81803C0EBFCD88

list=docker.list

declare -a deps
deps+=(apt-transport-https)
deps+=(ca-certificates)
deps+=(curl)
deps+=(gnupg)
deps+=(lsb-release)
deps+=(software-properties-common)

sudo apt-get update
sudo apt-get install ${deps[@]}

gpg --no-default-keyring --keyring $keyring --keyserver $keyserver --recv-keys $fingerprint
sudo add-apt-repository "deb [arch=amd64 signed-by=$ring] $url $(lsb_release -cs) stable" $list

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
