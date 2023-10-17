#!/usr/bin/env bash

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

list='/etc/apt/sources.list.d/docker.list'
keyring='/usr/share/keyrings/docker-archive-keyring.gpg'

packages=(
  'docker-ce'
  'docker-ce-cli'
  'containerd.io'
  'docker-buildx-plugin'
  'docker-compose-plugin'
)

sudo rm -f "$list" "$keyring"

sudo apt-get remove --yes "${packages[@]}" 
