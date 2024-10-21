#!/usr/bin/env bash

# installs neovim stable. <skr 2023-01-25>

# see: https://github.com/neovim/neovim/blob/master/INSTALL.md#linux <rbt 2024-10-01>

set +B -Cefuxo pipefail

repo=neovim/neovim
tag=stable
name=nvim-linux64

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
