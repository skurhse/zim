#!/usr/bin/env bash

# REQ: Installs the Docker APT repository and signing key. <skr 2023-03-31>

# SEE: https://docs.docker.com/engine/install/debian/ <>
# SEE: https://docs.docker.com/engine/install/linux-postinstall/ <>

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

readonly dependencies=('gnupg')

for package in "${dependencies[@]}"; do
  if status=$(dpkg-query --show --showformat '${db:Status-Status}' "$package"); then
    if [[ "$status" != 'installed' ]]; then
      echo "Unexpected status $status for package $package." >&2
      exit 3  
    fi
  else
    if [[ $? -eq 1 ]]; then
      echo "Package $package not found." >&2
      echo "To install:" >&2
      echo "  sudo apt-get install $package" >&2
      exit 2
    else
      echo "dpkg-query failed with status $status." >&2
      exit 1
    fi
  fi
done

readonly list='/etc/apt/sources.list.d/docker.list'

readonly archive_type='deb'
architecture=$(dpkg --print-architecture)
readonly architecture
readonly signed_by='/usr/share/keyrings/docker-archive-keyring.gpg'
readonly repository_url='https://download.docker.com/linux/debian/'
source /etc/os-release
distribution="$VERSION_CODENAME"
readonly distribution
readonly component='stable'

readonly keyserver='https://download.docker.com/linux/debian/gpg'
readonly keyring='/usr/share/keyrings/docker-archive-keyring.gpg'
readonly fingerprint='9DC858229FC7DD38854AE2D88D81803C0EBFCD88'

sudo gpg \
  --no-default-keyring                \
  --keyring            "$keyring"     \
  --keyserver          "$keyserver"   \
  --recv-keys          "$fingerprint"

readonly source="${archive_type} [arch=${architecture} signed-by=${signed_by}] ${repository_url} ${distribution} ${component}"

sudo bash -c "echo ${source@Q} > ${list@Q}"

sudo apt update
