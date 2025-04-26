#!/usr/bin/env bash

# REQ: Installs the GitHub CLI. <rbt 2023-10-05>

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

readonly extensions=(
  'https://github.com/nektos/gh-act'
)

realpath=$(realpath "${BASH_SOURCE[0]}")
dirname=$(dirname "$realpath")
cd "$dirname"

sudo gpg --no-default-keyring \
  --keyring "$keyring" --keyserver "$keyserver" --recv-keys "$fingerprint"

sudo bash -c "echo ${entry@Q} > ${file@Q}"

sudo apt-get update
sudo apt-get install --assume-yes -- gh

gh extension install --force "${extensions[@]}"
