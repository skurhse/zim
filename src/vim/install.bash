#!/usr/bin/env bash
#
# REQ: Installs vim, et al. <skr 2021-12-26>
# REQ: Features:
# REQ: Pathogen - plugin manager
# REQ: ALE - syntax checker
# REQ: Vim-Crystal - ftplugin
# ..............................................................................
set +B -Cefuvxo pipefail

# SEE: https://www.vim.org/download.php#unix <>
sudo apt-get update
sudo apt-get install --yes -- git vim

# SEE: https://github.com/tpope/vim-pathogen#installation <>
rm --force --recursive -- ~/.vim/autoload ~/.vim/bundle
mkdir --parents -- ~/.vim/autoload ~/.vim/bundle
curl --fail --location --output ~/.vim/autoload/pathogen.vim -- https://tpo.pe/pathogen.vim

# NOTE: Syntastic is deprecated, using ALE. <>
# SEE: https://github.com/dense-analysis/ale#3ii-installation-with-pathogen <>
cd ~/.vim/bundle
git clone --depth 1 --single-branch -- https://github.com/dense-analysis/ale.git

# SEE: https://github.com/vim-crystal/vim-crystal#installation <>
cd /tmp
rm --force --recursive --verbose -- vim-crystal
git clone --depth 1 --single-branch -- https://github.com/vim-crystal/vim-crystal.git
cd vim-crystal
cp -R autoload ftdetect ftplugin indent plugin syntax syntax_checkers ~/.vim/
