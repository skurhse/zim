#!/usr/bin/env bash

# REQ: Installs neovim's init.lua from Gist using the Github CLI. <skr 2023-02-25>

# SEE: https://neovim.io/doc/user/lua-guide.html <>
# SEE: https://neovim.io/doc/user/lua.html <>

set +o braceexpand
set -o errexit
set -o noglob
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

url=https://gist.github.com/skurhse/3071390d8a63efdd6e90542ac8c6115d
file=init.lua
dir=/tmp/${url##*/}/
src=$dir/$file
trg=~/.config/nvim/


rm -rf $dir
gh gist clone $url $dir
mkdir -p $trg
cp $src $trg 
