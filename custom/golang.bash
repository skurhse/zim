#!/usr/bin/env bash

# REQ: Installs a go binary release. <rabbit 2023-09-19>

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

arch=$(dpkg --print-architecture); readonly arch

readonly version='1.21.1'
readonly checksum='b3075ae1ce5dab85f89bc7905d1632de23ca196bd8336afd93fa97434cfa55ae'

readonly archive="go$version.linux-$arch.tar.gz"
readonly url="https://golang.org/dl/$archive"

readonly path='/usr/local/go'
readonly profile=~/'.bash_profile'

readonly export=(export "PATH=\"\$PATH:\"${path@Q}/bin")

dir=$(dirname "$path"); readonly dir

cd /tmp
wget --version
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
