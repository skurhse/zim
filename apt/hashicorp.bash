#!/usr/bin/env bash

# REQ: Installs the Hashicorp APT repository. <skr 2023-03-28>

# SEE: https://www.hashicorp.com/official-packaging-guide <>

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
  if status=$(dpkg-query --show --showformat '${db:Status-Status}' "$package"); then
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
distribution=$(lsb_release -cs)

readonly architecture
readonly keyring='/usr/share/keyrings/hashicorp.gpg'
readonly repository="hashicorp"
readonly distribution

readonly component='main'

readonly keyserver='https://apt.releases.hashicorp.com/gpg'
readonly fingerprint='798AEC654E5C15428C8E42EEAA16FCBCA621E701'

readonly url='https://apt.releases.hashicorp.com'
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
