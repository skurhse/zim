#!/usr/bin/env bash

# REQ: Installs Docker ands configures the current shell. <skr 2023-03-31>

# SEE: https://docs.docker.com/engine/install/debian/#install-using-the-repository <>
# SEE: https://docs.docker.com/engine/install/linux-postinstall/ <>

# USAGE: exec custom/docker.bash <>

set -o errexit -o xtrace

trap 'exec sudo --preserve-env --user $USER bash' INT EXIT

readonly packages=(
  docker-ce
  docker-ce-cli
  containerd.io
  docker-buildx-plugin
  docker-compose-plugin
)

# CAVEAT: Group changes must precede service installation. <skr>
sudo groupadd --force docker
sudo usermod --append --groups docker $USER

sudo apt-get update
sudo apt-get install --yes ${packages[@]}

sudo --user $USER bash -c 'docker run hello-world'
