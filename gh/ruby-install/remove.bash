#!/usr/bin/env bash

# REQ: Removes ruby-install. <rbt 2025-04-27>

set +o braceexpand
set +o noglob

set -o noclobber
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

shopt -s extglob

readonly src='/usr/local/src/ruby-install'

readonly keyring='/usr/share/keyrings/postmodern.gpg'

gh --version
gpg --version

cd "$src"
sudo make uninstall

sudo rm --recursive --force "$src"
