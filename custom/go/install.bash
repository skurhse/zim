#!/usr/bin/env bash

# REQ: Installs a go binary release. <rabbit 2024-06-07>

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
version=1.22.4

# SEE: https://go.dev/dl/
checksum=ba79d4526102575196273416239cca418a651e049c2b099f3159db85e7bade7d

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
