#!/usr/bin/env bash

# REQ: Installs packages from core. <eris 2023-05-07>

# SEE: https://packages.debian.org/bookworm/ <>

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

dirname=$(dirname "$0")
cd "$dirname"

readarray -t packages < core-packages.txt

sudo apt-get update
sudo apt-get install -y "${packages[@]}"
sudo apt-get autoremove
