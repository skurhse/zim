#!/usr/bin/env bash

# REQ: Installs the k9s release binary. <skr 2023-04-28>

# SEE: https://github.com/derailed/k9s/releases <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

arch=$(dpkg --print-architecture)

readonly repo="derailed/k9s"
readonly tarball="k9s_Linux_$arch.tar.gz"
readonly checksums='checksums.txt'

readonly tmpdir="/tmp/$repo/"
readonly bindir="/usr/local/bin/"

flags+=('--repo' "$repo")
for pattern in "$tarball" "$checksums"; do
  flags+=('--pattern' "$pattern")
done

rm -rf "$tmpdir"
mkdir -p "$tmpdir"
cd "$tmpdir"

gh release download "${flags[@]}"
sha256sum --check "$checksums" --ignore-missing
tar -xzf "$tarball"
sudo mv k9s "$bindir"
