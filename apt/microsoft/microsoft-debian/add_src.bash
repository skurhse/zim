#!/usr/bin/env bash

# REQ: Adds the Microsoft-Debian repository. <eris 2023-05-27>
# SEE: https://github.com/microsoft/linux-package-repositories <>

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

architecture=$(dpkg --print-architecture)
readonly architecture

readonly url='https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod'

# PORT: Bookworm not yet supported. <eris 2023-05-27>
readonly distribution='bullseye'

readonly keyring='/usr/share/keyrings/microsoft.gpg'

readonly source="deb [arch=$architecture signed-by=$keyring] $url $distribution main"

readonly list="/etc/apt/sources.list.d/microsoft-debian.list"

sudo bash -c "echo ${source@Q} > ${list@Q}"
cat "$list"

sudo apt-get update
