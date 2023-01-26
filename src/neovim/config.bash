#!/usr/bin/env bash

# installs init.lua. <skr 2023-01-25>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

url=https://gist.github.com/skurhse/3071390d8a63efdd6e90542ac8c6115d
file=init.lua
dir=/tmp/${url##*/}/
src=$dir/$file
trg=~/.config/neovim/

rm -rf $dir
gh gist clone $url $dir
mkdir -p $trg
cp $src $trg 
