#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Removes ruby-install. <rbt 2025-04-28>

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
