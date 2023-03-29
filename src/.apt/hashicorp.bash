#!/usr/bin/env bash

# REQ: Installs the Microsoft Debian APT repository. <skr 2023-03-28>

# SEE: https://github.com/microsoft/linux-package-repositories <>

# PORT: Bookworm not yet supported. <skr 2023-03-27>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly dependencies=('curl' 'gpg')

for package in "${dependencies[@]}"; do
  dpkg-query --show "$package"
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
