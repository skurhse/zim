#!/usr/bin/env bash

# Installs neovim stable. <rbt 2025-04-26>

# SEE: https://github.com/neovim/neovim/blob/master/INSTALL.md#linux <>

set +o braceexpand

set -o noglob
set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

readonly repo=neovim/neovim
readonly tag=stable

gh --version

arch=$(dpkg --print-architecture)
case $arch in
  amd64)
    arch=x86_64
    ;;
  arm64)
    ;;
  *)
    exit 
    ;;
esac
 
cd /tmp

gh release download "$tag" \
  --repo "$repo" \
  --pattern "nvim-linux-$arch.tar.gz" \
  --pattern shasum.txt \
  --clobber

sha256sum --check --ignore-missing shasum.txt 

sudo rm -rf "/opt/nvim-linux-$arch/"

sudo tar \
  -C /opt/nvim \
  -xzf "nvim-linux-$arch.tar.gz" \

export=(export "PATH=\"\$PATH\":/opt/nvim-linux-$arch/bin")
profile=~/.bash_profile

if ! grep --quiet --line-regexp --fixed-strings -- "${export[*]}" "$profile"
then
  printf "\n${export[*]}\n" >> "$profile"
fi

eval "${export[@]}"

nvim --version
