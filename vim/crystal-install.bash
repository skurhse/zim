#!/usr/bin/env bash
# REQ: Installs vim filetype support for crystal. <skr 2021-12-26>
# ..............................................................................
set +B -Cefuvxo pipefail

sudo apt-get update
sudo apt-get install --yes -- git

cd /tmp
rm --force --recursive --verbose -- vim-crystal
git clone https://github.com/vim-crystal/vim-crystal.git

# SEE: https://github.com/vim-crystal/vim-crystal#installation <>
cd vim-crystal
cp -R autoload ftdetect ftplugin indent plugin syntax syntax_checkers ~/.vim/
