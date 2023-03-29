#!/usr/bin/env bash

# REQ: Installs the Microsoft Debian APT repository. <skr 2023-03-28>

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

for package in "${dependencies[@]}"; do
  if status=$(dpkg-query --show --show-format '${db:Status-Status}' "$package"; then
    if [[ "$status" != 'installed' ]]; then
      echo "Unexpected status $status for package $package." >&2
      exit 4
    fi
  else
    if [[ $? -eq 1 ]]; then
      echo "Package $package not found." >&2
      echo "To install:" >&2
      echo "  sudo apt-get install $package" >&2
    else
      echo "dpkg-query failed with unexpected status $status." >&2
      exit 5
    fi
  fi
done

architecture=$(dpkg --print-architecture)

readonly architecture
readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly repository="microsoft-debian-bullseye-prod"
readonly distribution='bullseye'
readonly component='main'

readonly keyserver='https://packages.microsoft.com/keys/microsoft.asc'
readonly fingerprint='0xEB3E94ADBE1229CF'

readonly url="https://packages.microsoft.com/repos/$repository/"
readonly list="/etc/apt/sources.list.d/$repository.list"

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

readonly source="deb [arch=$architecture signed-by=$keyring] $url $distribution main"

sudo bash -c "echo ${source@Q} > ${list@Q}"
cat "$list"

sudo apt-get update
