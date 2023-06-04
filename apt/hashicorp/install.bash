#!/usr/bin/env bash

# REQ: Installs the Hashicorp repo. <eris 2023-06-04>
# REQ: Installs Packer, Terraform and Terraform Language Server. <>

# SEE: https://www.hashicorp.com/official-packaging-guide <>

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

gpg --version
lsb_release --version

readonly packages=(
  'packer'
  'terraform'
  'terraform-ls'
)

arch=$(dpkg --print-architecture)
readonly arch

readonly keyring='/usr/share/keyrings/hashicorp.gpg'
readonly repo="hashicorp"

distro=$(lsb_release --short --codename)
readonly distro

readonly component='main'

readonly keyserver='https://apt.releases.hashicorp.com/gpg'
readonly fingerprint='798AEC654E5C15428C8E42EEAA16FCBCA621E701'

readonly url='https://apt.releases.hashicorp.com'
readonly list='/etc/apt/sources.list.d/hashicorp.list'

readonly entry="deb [arch=$arch signed-by=$keyring] $url $distro main"

sudo gpg --no-default-keyring \
  --keyring "$keyring" --keyserver "$keyserver" --recv-keys "$fingerprint"

sudo bash -c "echo ${entry@Q} > ${list@Q}"

sudo apt-get update
sudo apt-get install --yes "${packages[@]}"
