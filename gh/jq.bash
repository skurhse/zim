#!/usr/bin/env bash

# REQ: Installs the latest jq from Github Releases. <rbt 2025-04-20>

# SEE: https://github.com/stedolan/jq <>

set +o braceexpand
set -o errexit
set -o noclobber
set +o noglob
set -o nounset
set -o pipefail
set -o xtrace

shopt -s extglob

readonly repo="stedolan/jq"
readonly pattern="*.tar.gz"

gh --version
make --version

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

jq --version
