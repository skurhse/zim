#!/usr/bin/env bash

# Installs neovim stable. <rbt 2025-04-26>

# SEE: https://github.com/neovim/neovim/blob/master/INSTALL.md#linux <rbt 2024-10-01>

set +o braceexpand
set -o errexit
set -o noclobber
set +o noglob
set -o nounset
set -o pipefail
set -o xtrace

repo=neovim/neovim
tag=stable
name=nvim-linux64

gh --version

cd /tmp

gh release download --clobber $tag --repo $repo --dir /tmp --pattern "$name*"

sha256sum --check $name.tar.gz.sha256sum

sudo rm -rf /opt/$name

sudo tar -C /opt -xzf $name.tar.gz

export=(export "PATH=\"\$PATH\":/opt/$name/bin")
profile=~/.bash_profile

if ! grep --quiet --line-regexp --fixed-strings -- "${export[*]}" "$profile"
then
  printf "\n${export[*]}\n" >> "$profile"
fi

eval ${export[@]}

nvim -V1 --version
