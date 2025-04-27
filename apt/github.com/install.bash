#!/usr/bin/env bash

# REQ: Installs the GitHub CLI. <rbt 2023-04-26>

# SEE: https://github.com/cli/cli/blob/trunk/docs/install_linux.md <>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o xtrace

readonly keyserver='https://cli.github.com/packages/githubcli-archive-keyring.gpg'
readonly keyring='/etc/apt/keyrings/githubcli-archive-keyring.gpg'
readonly fingerprint='2C6106201985B60E6C7AC87323F3D4EA75716059'

arch="$(dpkg --print-architecture)"
readonly component='main'
readonly distro='stable'
readonly file='/etc/apt/sources.list.d/github-cli.list'
readonly url='https://cli.github.com/packages'

readonly entry="deb [arch=$arch signed-by=$keyring] $url $distro $component"

realpath=$(realpath "${BASH_SOURCE[0]}")
dirname=$(dirname "$realpath")
cd "$dirname"

sudo gpg \
  --no-default-keyring --keyring "gnupg-ring:$keyring" \
  --keyserver "$keyserver" --recv-keys "$fingerprint" 

# NOTE: Must be readable by sandbox user '_apt'. <>
sudo chmod 444 "$keyring"

sudo bash -c "echo ${entry@Q} > ${file@Q}"

sudo apt-get update
sudo apt-get install --assume-yes -- gh

gh --version
