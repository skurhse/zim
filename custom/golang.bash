#!/usr/bin/env bash

# REQ: Installs a go binary release. <skr 2023-04-05>

# SEE: https://go.dev/doc/install <>
# SEE: https://go.dev/dl/ <>

# TODO: Setup for exec and SHLVL. <>

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

declare -A release
release[version]='1.20.3'
release[architecture]=$(dpkg --print-architecture)
release[archive]="go${release[version]}.linux-${release[architecture]}.tar.gz"
release[url]="https://golang.org/dl/${release[archive]}"

declare -A install
install[path]='/usr/local/go'
install[dir]=$(dirname ${install[path]})
install[export]='export PATH="$PATH:"'${install[path]@Q}'/bin'
install[profile]=~/.bash_profile

export=(export 'PATH="$PATH:"'${install[path]@Q}'/bin')

cd /tmp
wget --version
wget --timestamping -- ${release[url]}

sudo rm --recursive --force -- ${install[path]}
sudo tar --directory ${install[dir]} --extract -gunzip --file ${release[archive]}

grep --version
if ! grep --quiet --line-regexp --fixed-strings -- "${export[*]}" ${install[profile]}
then
  printf "\n${export[*]}\n" >> ${install[profile]}
fi

eval ${export[@]}
go version
