#!/usr/bin/env bash

# REQ: Removes the .NET SDK. <eris rbt 2023-10-09>

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

readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly list='/etc/apt/sources.list.d/microsoft.list'
readonly repo='https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod/'

readonly packages=(
  'dotnet-sdk-7.0'
)

sudo sed -i "\|$repo|d" "$list"

sudo apt-get remove --yes "${packages[@]}"

[ -s "$list" ] || sudo rm -f "$list"

sudo apt-get update
