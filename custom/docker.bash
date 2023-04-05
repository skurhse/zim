#!/usr/bin/env bash

# REQ: Installs Docker ands configures the current shell, if top-level. <skr 2023-03-31>

# SEE: https://docs.docker.com/engine/install/debian/#install-using-the-repository <>
# SEE: https://docs.docker.com/engine/install/linux-postinstall/ <>

# USAGE: exec custom/docker.bash <>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly packages=(
  containerd.io
  docker-buildx-plugin
  docker-ce
  docker-ce-cli
  docker-compose-plugin
)

readonly exec=(exec sudo --preserve-env --user $USER -- bash)

function handle_interrupt()
{
  echo 'ZIM: I was rudely interrupted.'

  if [[ $SHLVL -eq 1 ]]; then
    ${exec[@]}
  fi
}
trap handle_interrupt INT

function handle_exit()
{
  set +o xtrace

  if [[ $? -ne 0 ]]; then
    echo 'ZIM: I am afraid something went terribly wrong.'
    exit 1
  fi

  if [[ $SHLVL -ne 1 ]]; then
    echo "ZIM: Script SHLVL is $SHLVL."
    echo "To complete installation, please refresh your top-level shell process:"
    echo "  ${exec[@]}"
    exit 0
  fi

  echo 'ZIM: Bravo! You have successfully installed Docker.'
  ${exec[@]}
}
trap handle_exit EXIT

# CAVEAT: Group changes must precede service installation. <skr>
sudo groupadd --force -- docker
sudo usermod --append --groups docker -- $USER

sudo apt-get update --
sudo apt-get install --yes -- ${packages[@]}
sudo --user $USER -- bash -c 'docker run hello-world'
