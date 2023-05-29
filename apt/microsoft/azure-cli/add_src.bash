#!/usr/bin/env bash

# REQ: Adds the Azure CLI repository. <eris 2023-05-29>

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

readonly packages=(
  'awk'
  'gnupg'
)

for package in "${packages[@]}"
do
  if status=$(dpkg-query --show --showformat '${db:Status-Status}' "$package")
  then
    if [[ "$status" != 'installed' ]]
    then
      echo "ERROR: unexpected status ${status@Q} for package ${package@Q}." >&2
      exit 3  
    fi
  else
    if [[ $? -eq 1 ]]
    then
      echo "ERROR: package ${package@Q} not found." >&2
      exit 2
    else
      echo "ERROR: dpkg-query failed with exit status ${status@Q}." >&2
      exit 1
    fi
  fi
done

architecture=$(dpkg --print-architecture)
readonly architecture

# PORT: Bookworm not yet supported. <eris 2023-05-29>
# release=$(lsb_release -cs)
readonly release='bullseye'

readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly fingerprint='BC528686B50D79E339D3721CEB3E94ADBE1229CF'

readonly repository='https://packages.microsoft.com/repos/azure-cli/'
readonly component='main'

readonly list='/etc/apt/sources.list.d/azure-cli.list'

for package in "${dependencies[@]}"; do
  dpkg-query --show "$package"
done

key=$(gpg --show-keys --with-colons --with-fingerprint "$keyring")

actual=$(awk -F: '/^fpr:/ {print $10}' <<<$key)

if [[ $actual != $fingerprint ]]
then
  echo "ERROR: fingerprint mismatch. Expected: $fingerprint Actual: $actual" >&2
  exit 5
fi

str="deb [arch=$architecture signed-by=$keyring] $repository $release $component"

sudo bash -c "echo ${str@Q} > $list"
cat $list

sudo apt-get update
