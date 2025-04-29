#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Removes neovim stable. <rbt 2025-04-27>

set +o braceexpand

set -o noglob
set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

arch=$(dpkg --print-architecture)
case $arch in
  amd64)
    arch=x86_64
    ;;
  arm64)
    ;;
  *)
    exit 
    ;;
esac

sudo rm -rf "/opt/nvim-linux-$arch/"
