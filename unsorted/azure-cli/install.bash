#!/usr/bin/env bash

# REQ: Installs the latest Azure CLI from the APT repository. <skr 2023-03-24>

# SEE: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux <>

# PORT: Hardcodes the release to 'bullseye' until bookworm support is added. <2023-03-24>

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
readonly fingerprint='0xEB3E94ADBE1229CF'

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

gpg --show-keys --keyid-format 0xLONG <(curl "$keyserver")

sudo gpg --no-default-keyring \
  --keyring   "$keyring" \
  --keyserver "$keyserver" \
  --recv-keys "$fingerprint"

sudo gpg --no-default-keyring \
  --keyring      "$keyring" \
  --keyid-format 0xLONG \
  --list-keys

str="deb [arch=$arch signed-by=$keyring] $repo $release $component"

sudo bash -c "echo ${str@Q} > $list"
cat $list

sudo apt-get update
sudo apt-get --assume-yes install azure-cli
