#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Installs jq latest. <rbt 2025-04-27>

# SEE: https://github.com/stedolan/jq <>

set +o braceexpand
set +o noglob

set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

shopt -s extglob

readonly repo="stedolan/jq"
readonly pattern="*.tar.gz"

gh --version
make --version
gcc --version

cd /tmp
rm -rf jq/
mkdir jq

cd jq
gh release download --clobber --repo "$repo" --pattern "$pattern"
tar -xzf $pattern

cd !($pattern)
./configure
make
sudo make install

sudo mv jq /usr/local/bin/

jq --version
