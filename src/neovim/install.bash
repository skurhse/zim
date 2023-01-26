#!/usr/bin/env bash

# installs neovim stable. <skr 2023-01-25>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

repo=neovim/neovim
dir=/tmp/$repo
tag=stable
patterns=(*.deb *.deb.sha256sum)

rm -rf $dir
mkdir -p $dir
gh release download $tag \
  --repo    $repo        \
  --dir     $dir         \
  $(for pattern in ${patterns[@]}; do echo " --pattern $pattern"; done)

set +o noglob
cd $dir && sha256sum --check *.deb.sha256sum
sudo apt-get install --assume-yes $dir/*.deb
