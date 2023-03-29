#!/usr/bin/env bash

# REQ: Installs the GitHub CLI via APT. <skr 2023-01-21>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o xtrace

realpath=$(realpath "${BASH_SOURCE[0]}")
dirname=$(dirname "$realpath")
cd "$dirname"

source ../../lib/apt.bash

function main() {
  url='https://cli.github.com/packages/githubcli-archive-keyring.gpg'
  file='/usr/share/keyrings/githubcli-archive-keyring.gpg'
  make_keyring

  arch="$(dpkg --print-architecture)"
  component='main'
  distribution='stable'
  file='/etc/apt/sources.list.d/github-cli.list'
  signed_by="${keyring[file]}"
  url='https://cli.github.com/packages'
  make_list

  download_keyring
  install_list

  update_lists
  install_packages gh

  gh version
}

main "$@"

