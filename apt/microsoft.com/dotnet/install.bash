#!/usr/bin/env bash

# REQ: Installs the .NET SDK:
# 1. Imports the Microsoft signing key
# 2. Writes the source list
# 3. Installs the package
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

arch=$(dpkg --print-architecture)

# PORT: Trixie not yet supported. <rbt 2023-10-20>
distro=$(lsb_release --short --codename)
[[ $distro == trixie ]] && distro=bookworm

keyring=/etc/apt/keyrings/microsoft.gpg
keyserver=https://packages.microsoft.com/keys/microsoft.asc
key=BC528686B50D79E339D3721CEB3E94ADBE1229CF

repo=https://packages.microsoft.com/repos/microsoft-debian-bookworm-prod/
component=main

list=/etc/apt/sources.list.d/dotnet.microsoft.list

package=dotnet-sdk-7.0

entry="deb [arch=$arch signed-by=$keyring] $repo $distro $component"
sudo gpg --no-default-keyring --keyring "$keyring" \
  --keyserver "$keyserver" --recv-keys "$key"

sudo bash -c "echo ${entry@Q} >${list@Q}"

sudo apt-get update
sudo apt-get install --yes "$package"

dotnet --version
