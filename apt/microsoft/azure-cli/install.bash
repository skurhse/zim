#!/usr/bin/env bash

# REQ: Adds the Azure CLI repository to the Microsoft source list. <eris 2023-05-29>

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

awk --version
gpg --version

arch=$(dpkg --print-architecture)
readonly arch

# PORT: Bookworm not yet supported. <eris 2023-05-29>
# release=$(lsb_release -cs)
readonly release='bullseye'

readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly fingerprint='BC528686B50D79E339D3721CEB3E94ADBE1229CF'

readonly repo='https://packages.microsoft.com/repos/azure-cli/'
readonly component='main'

readonly list='/etc/apt/sources.list.d/microsoft.list'
readonly packages=(
  'azure-cli'
)

readonly extensions=(
  'aks-preview'
)

entry="deb [arch=$arch signed-by=$keyring] $repo $release $component"

sudo bash -c "echo ${entry@Q} >>${list@Q}"

sudo apt-get update

sudo apt-get install --yes "${packages[@]}"

az upgrade --all

for extension in "${extensions[@]}"; do
  az extension add --upgrade --name "${extension}" --yes
done
