#!/usr/bin/env bash

# Installs the latest Azure CLI. <skr 2023-03-05>

# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux <>

set +o 'braceexpand'
set -o 'errexit'
set -o 'noclobber'
set -o 'noglob'
set -o 'nounset'
set -o 'pipefail'
set -o 'xtrace'

declare -Ar dependencies=(
  [curl]='7.74.0-1.3+deb11u7'
  [gpg]='2.2.27-2+deb11u2'
  [lsb-release]='11.1.0'
)

readonly keyserver='https://packages.microsoft.com/keys/microsoft.asc'
readonly keyring='/usr/share/keyrings/microsoft.gpg'
readonly fingerprint='0xEB3E94ADBE1229CF'

readonly repo='https://packages.microsoft.com/repos/azure-cli/'
readonly arch='amd64'
readonly list='/etc/apt/sources.list.d/microsoft.list'

for package in "${!dependencies[@]}"; do
  actual="$(dpkg-query --show --showformat='${Version}' "$package")"
  if [[ "$actual" != "${dependencies[$package]}" ]]; then
    echo "Package $package is version $actual, expected ${dependencies[$package]}"
    exit 1
  fi
done

gpg --show-keys --keyid-format '0xLONG' <(curl "$keyserver")

sudo gpg --no-default-keyring \
  --keyring   "$keyring" \
  --keyserver "$keyserver" \
  --recv-keys "$fingerprint"

sudo gpg --no-default-keyring \
  --keyring      "$keyring" \
  --keyid-format '0xLONG' \
  --list-keys

release="$(lsb_release -cs)"
str="deb [arch=$arch signed-by=$keyring] $repo $release main"

sudo bash -c "echo ${str@Q} > $list"
cat $list

sudo apt-get update
sudo apt-get --assume-yes install azure-cli
