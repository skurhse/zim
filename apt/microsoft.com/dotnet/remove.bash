#!/usr/bin/env bash

# REQ: Removes the .NET SDK.
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

keyring=/etc/apt/keyrings/microsoft.gpg

list=/etc/apt/sources.list.d/dotnet.microsoft.list

package=dotnet-sdk-7.0

sudo apt-get remove --yes "$package"

sudo rm -f "$list"
sudo apt-get update

compgen -G "${list/$package/*}" || sudo rm -f "$keyring"
