#!/usr/bin/env bash

# REQ: Uninstalls element desktop. <eris 2023-05-30>

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

readonly keyring=/usr/share/keyrings/element-io-archive-keyring.gpg
readonly list=/etc/apt/sources.list.d/kubic.list
readonly package=element-desktop

if status=$(dpkg-query --show --showformat '${db:Status-Status}' "$package")
then
  [[ "$status" == 'installed' ]] && sudo apt-get remove --yes "$package"
else
  [[ $? -ne 1 ]] && exit 1
fi

sudo rm -f "$keyring" "$list"

sudo apt-get update
