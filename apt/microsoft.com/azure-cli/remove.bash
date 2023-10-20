#!/usr/bin/env bash

# REQ: Removes the Azure CLI:
# 1. Remove package
# 2. Remove source list
# 3. Remove signing key if unused
# <rbt 2023-10-20>

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

keyring=/usr/share/keyrings/microsoft.gpg
keyserver=https://packages.microsoft.com/keys/microsoft.asc
key=BC528686B50D79E339D3721CEB3E94ADBE1229CF

repo=https://packages.microsoft.com/repos/azure-cli/
component=main
mask=/etc/apt/sources.list.d/microsoft-
list="${mask}azure-cli.list"
package=azure-cli

sudo gpg --no-default-keyring --keyring "$keyring" \
  --keyserver "$keyserver" --recv-keys "$key"

arch=$(dpkg --print-architecture)

# PORT: Trixie not yet supported. <rbt 2023-10-20>
distro=$(lsb_release --short --codename)
[[ $distro == trixie ]] && distro=bookworm

entry="deb [arch=$arch signed-by=$keyring] $repo $distro $component"

sudo bash -c "echo ${entry@Q} >${list@Q}"

sudo apt-get remove --yes "${packages[@]}"
sudo rm -f "$list"
compgen -G "$mask*" || sudo rm -f "$keyring"
