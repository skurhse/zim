#!/usr/bin/env bash

# REQ: Installs the Microsoft Debian APT signing key. <eris 2023-05-27>
# SEE: https://github.com/microsoft/linux-package-repositories <>

# PORT: Bookworm not yet supported. <skr 2023-03-27>

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

readonly dependencies=('curl' 'gpg')

for package in "${dependencies[@]}"
do
  if status=$(dpkg-query --show --showformat '${db:Status-Status}' "$package")
  then
    if [[ "$status" != 'installed' ]]
    then
      echo "Unexpected status $status for package $package." >&2
      exit 3
    fi
  else
    if [[ $? -eq 1 ]]
    then
      echo "Package $package not found." >&2
      echo "To install:" >&2
      echo "  sudo apt-get install $package" >&2
    else
      echo "dpkg-query failed with unexpected status $status." >&2
      exit 1
    fi
  fi
done

architecture=$(dpkg --print-architecture)

readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly keyserver='https://packages.microsoft.com/keys/microsoft.asc'
readonly fingerprint='BC528686B50D79E339D3721CEB3E94ADBE1229CF'

gpg --show-keys --keyid-format 0xLONG <(curl "$keyserver")

sudo gpg \
  --no-default-keyring       \
  --keyring   "$keyring"     \
  --keyserver "$keyserver"   \
  --recv-keys "$fingerprint"

sudo gpg \
  --no-default-keyring      \
  --keyring      "$keyring" \
  --keyid-format 0xLONG     \
  --list-keys
