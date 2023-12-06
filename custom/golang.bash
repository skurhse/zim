#!/usr/bin/env bash

# REQ: Installs a go binary release. <rabbit 2023-11-24>

# CAVEAT: Only supports amd64. <>

# SEE: https://go.dev/doc/install <>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

arch=amd64
version=1.21.5
checksum=e2bc0b3e4b64111ec117295c088bde5f00eeed1567999ff77bc859d7df70078e

archive="go$version.linux-$arch.tar.gz"

url="https://golang.org/dl/$archive"

path=/usr/local/go
profile=~/.bash_profile

export=(export "PATH=\"\$PATH:\"${path@Q}/bin")

dir=$(dirname "$path")

cd /tmp
wget --timestamping "$url"

sha256sum --check <<<"$checksum $archive"

sudo rm --recursive --force "$path"
sudo tar --extract --gunzip --directory "$dir" --file "$archive"

if ! grep --quiet --line-regexp --fixed-strings -- "${export[*]}" "$profile"
then
  printf "\n${export[*]}\n" >> "$profile"
fi

eval ${export[@]}
go version
