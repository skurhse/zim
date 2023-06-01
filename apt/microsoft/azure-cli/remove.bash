#!/usr/bin/env bash

# REQ: Removes the Azure CLI APT repository and signing key. <skr 2023-03-31>

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
readonly repo='https://packages.microsoft.com/repos/azure-cli/'

sudo sed -i "\|$repo|d" "$list"

[ -s "$list" ] || sudo rm -f "$list"

sudo apt-get update
