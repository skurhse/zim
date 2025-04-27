#!/usr/bin/env bash

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
