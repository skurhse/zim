#!/usr/bin/env bash

# installs neovim stable. <skr 2023-01-25>

set +B -Cefuxo pipefail

repo=neovim/neovim
dir=/tmp/$repo
tag=stable

rm -rf $dir; mkdir -p $dir

gh release download $tag    \
  --repo    $repo           \
  --dir     $dir            \
  --pattern *.deb           \
  --pattern *.deb.sha256sum

set +o noglob

cd $dir && sha256sum --check *.deb.sha256sum

sudo apt-get install --assume-yes $dir/*.deb
