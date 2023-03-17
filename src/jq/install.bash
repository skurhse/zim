#!/usr/bin/env bash

# REQ: Installs the latest jq from Github Releases. <skr 2023-03-16>

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

autoreconf --version
gh --version
make --version

cd /tmp
rm -rf jq/
mkdir jq
cd jq
gh release download --clobber --repo "$repo" --pattern "$pattern"
tar -xzf $pattern
cd !($pattern)
# HACK: Autoreconf is required to resolve Oniguruma make target. <>
# SEE: https://github.com/stedolan/jq/issues/2172#issuecomment-674547200 <>
autoreconf -fi
./configure
make
sudo make install


