#!/usr/bin/env bash

# REQ: Installs Docker ands configures the current shell, if top-level. <skr 2023-03-31>

# SEE: https://docs.docker.com/engine/install/debian/#install-using-the-repository <>
# SEE: https://docs.docker.com/engine/install/linux-postinstall/ <>

# USAGE: exec custom/docker.bash <>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -o errexit

readonly exec=(exec sudo --preserve-env --user $USER bash)

function handle_int()
{
  echo 'Script Interrupted.'
  if [[ $SHLVL -eq 1 ]]; then
    ${exec[@]}
  fi
}
trap handle_int INT

function handle_exit()
{
  local code=$?
  local err='Something went terribly wrong.'
  
  if [[ $code -ne 0 ]]; then
    echo $err
  else
    if [[ $SHLVL -ne 1 ]]; then
      echo "WARN: Script SHLVL is $SHLVL."
      echo "To complete installation, please refresh your top-level shell process:"
      echo "  ${exec[@]}"
      exit
    fi
  fi
   
  ${exec[@]}
}
trap handle_exit EXIT

readonly packages=(
  containerd.io
  docker-buildx-plugin
  docker-ce
  docker-ce-cli
  docker-compose-plugin
)

# CAVEAT: Group changes must precede service installation. <skr>
sudo groupadd --force docker
sudo usermod --append --groups docker $USER

sudo apt-get update
sudo apt-get install --yes ${packages[@]}
sudo --user $USER bash -c 'docker run hello-world'
