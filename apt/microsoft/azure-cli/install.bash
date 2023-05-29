#!/usr/bin/env bash

# REQ: Installs the Azure CLI and its extensions. <eris 2023-05-27> 

# REQ: Installs Azure Functions Core Tools. <eris 2023-05-27>

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
  azure-cli
)

readonly extensions=(
  'aks-preview'
)

sudo apt-get update

sudo apt-get install --yes "${packages[@]}"

az upgrade --all

azure -version

for extension in "${extensions[@]}"; do
  az extension add --name "${extension}" --yes
done
azure extension add --upgrade 
