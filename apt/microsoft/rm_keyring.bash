#!/usr/bin/env bash

# REQ: Removes the Microsoft signing key. <eris 2023-05-29>

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

for list in 'azure-cli' 'microsoft-debian'
do
  if [[ -f "/etc/apt/sources.list.d/$list" ]]
  then
    echo "ERROR: cannot delete keyring ${keyring@Q}: list ${list@Q} exists and is a file." >&2
    exit 4
  fi
done

sudo rm --force --verbose "$keyring"
