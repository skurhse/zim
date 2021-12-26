#!/usr/bin/env bash
# REQ: Installs vim with pathogen and syntastic. <skr 2021-12-26>
# ..............................................................................
set +B -Cefuvxo pipefail

# SEE: https://www.vim.org/download.php#unix <>
sudo apt-get update
sudo apt-get install vim

# SEE: https://github.com/tpope/vim-pathogen#installation <>
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# SEE: https://github.com/vim-syntastic/syntastic#22-installing-syntastic-with-pathogen <>
cd ~/.vim/bundle && \
{ [[ -d syntastic ]] || git clone --depth=1 https://github.com/vim-syntastic/syntastic.git;}
