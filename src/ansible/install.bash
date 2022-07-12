#!/usr/bin/env bash

# REQ: Installs ansible with pip3. <skr 2022-07>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

function main {
  pip3 -V || return 1

  sudo pip3 install --system ansible
}

main
