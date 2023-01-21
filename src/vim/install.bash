#!/usr/bin/env bash

# REQ: Installs vim, pathogen and ALE. <skr 2023-01-21>

set +o braceexpand
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://www.vim.org/download.php#unix <>
sudo apt-get update
sudo apt-get install --yes -- git vim

# SEE: https://github.com/tpope/vim-pathogen#installation <>
rm --force --recursive -- ~/.vim/autoload ~/.vim/bundle
mkdir --parents -- ~/.vim/autoload ~/.vim/bundle
curl --fail --location --output ~/.vim/autoload/pathogen.vim -- https://tpo.pe/pathogen.vim

# SEE: https://github.com/dense-analysis/ale#3ii-installation-with-pathogen <>
cd ~/.vim/bundle
git clone --depth 1 --single-branch -- https://github.com/dense-analysis/ale.git
