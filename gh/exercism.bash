#!/usr/bin/env bash

# REQ: Installs the Exercism CLI release binary. <skr 2023-05-21>

# SEE: https://exercism.org/cli-walkthrough <> 

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

# CAVEAT: Disqualifies `dpkg --print-architecture by requiring 'x86_64'. <>
architecture=$(uname -m)
readonly architecture

kernel=$(uname -s)
readonly kernel=${kernel,,}

readonly program='exercism'
readonly repository="exercism/cli"
readonly tarball="exercism-*-$kernel-$architecture.tar.gz"
readonly checksums='exercism_checksums.txt'
readonly signature='exercism_checksums.txt.sig'

readonly tmpdir="/tmp/$repository/"

readonly bindir="/usr/local/bin/"

flags+=('--repo' "$repository")
for pattern in "$tarball" "$checksums" "$signature"; do
  flags+=('--pattern' "$pattern")
done

rm -rf "$tmpdir"
mkdir -p "$tmpdir"
cd "$tmpdir"

gh release download "${flags[@]}"

sha256sum --check "$checksums" --ignore-missing

# NOBUG: Public key is not available. <2023-05-22>
# gpg --verify "$signature" "$checksums"

set +o noglob
tar -xzf $tarball
set -o noglob

sudo mv "$program" "$bindir"
