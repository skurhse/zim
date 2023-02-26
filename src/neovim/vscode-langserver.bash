#!/usr/bin/env bash

# REQ: Installs the Visual Studio Code language servers with npm for use with neovim's eslint lspconfig. <skr 2023-02-25>

# SEE: https://github.com/hrsh7th/vscode-langservers-extracted <>
# SEE: https://eslint.org/docs/latest/ <>
# SEE: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o nounset
set -o noglob
set -o pipefail
set -o xtrace

npm --version
sudo npm install --global vscode-langservers-extracted
