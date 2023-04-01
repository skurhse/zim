#!/usr/bin/env bash

# REQ: Installs the Azure CLI APT repository and signing key. <skr 2023-03-31>

# SEE: https://github.com/microsoft/linux-package-repositories <>

# PORT: Bookworm not yet supported. <skr 2023-03-29>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly dependencies=('curl' 'gpg' 'lsb-release')

readonly keyserver='https://packages.microsoft.com/keys/microsoft.asc'
readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly fingerprint='BC528686B50D79E339D3721CEB3E94ADBE1229CF'

arch=$(dpkg --print-architecture)
release="$(lsb_release -cs)"

readonly arch
readonly repo='https://packages.microsoft.com/repos/azure-cli/'
readonly release='bullseye'
readonly component='main'

readonly list='/etc/apt/sources.list.d/microsoft.list'

for package in "${dependencies[@]}"; do
  dpkg-query --show "$package"
done

gpg --show-keys <(curl "$keyserver")

sudo gpg \
  --no-default-keyring \
  --keyring   "$keyring" \
  --keyserver "$keyserver" \
  --recv-keys "$fingerprint"

sudo gpg \
  --no-default-keyring \
  --keyring   "$keyring" \
  --list-keys

str="deb [arch=$arch signed-by=$keyring] $repo $release $component"

sudo bash -c "echo ${str@Q} > $list"
cat $list

sudo apt-get update
