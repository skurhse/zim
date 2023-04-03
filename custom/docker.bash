#!/usr/bin/env bash

# REQ: Installs Docker ands configures the current shell. <skr 2023-03-31>

# SEE: https://docs.docker.com/engine/install/debian/#install-using-the-repository <>
# SEE: https://docs.docker.com/engine/install/linux-postinstall/ <>

# NOTE: This script is intended to be sourced. <>

set -o xtrace

function main()
{
  set -o errexit

  readonly packages=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
  )

  # CAVEAT: Group changes must precede service installation. <skr>
  sudo groupadd -f docker
  sudo usermod -aG docker $USER

  sudo apt-get update
  sudo apt-get install --yes ${packages[@]}
}

main && exec sudo --preserve-env --user $USER bash -c 'docker run hello-world;exec bash'
