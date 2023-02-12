#!/usr/bin/env bash

# REQ: Installs python-lsp-server with all optional providers. <skr 2023-02-11>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

sudo pip install "python-lsp-server[all]"
