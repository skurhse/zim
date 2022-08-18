#!/usr/bin/env bash

# REQ: Installs packer from the HashiCorp APT repo. <skr 2022>

# SEE: https://www.packer.io/docs/install <>

set +o braceexpand
set -o noclobber
set -o noglob
set -o nounset

set -o errexit
set -o pipefail

set -o xtrace

function make_packer_repo {
  declare -Ag packer_repo=(
    ['url']='https://apt.releases.hashicorp.com'
    ['keyring']='/usr/share/keyrings/packer-keyring.gpg'
    ['list']='/etc/apt/sources.list.d/packer.list'
    ['package']='packer'
    ['fingerprint']='DA418C88A3219F7B'
  )
  packer_repo['keyserver']="${packer_repo['url']}/gpg"

  arch="$(dpkg --print-architecture)"
  distro="$(lsb_release -cs)"
  component='main'

  packer_repo['entry']="deb"
  packer_repo['entry']+=' '
  packer_repo['entry']+="[arch=$arch signed-by=${packer_repo['keyring']}]"
  packer_repo['entry']+=' '
  packer_repo['entry']+="${packer_repo['url']}"
  packer_repo['entry']+=' '
  packer_repo['entry']+="$distro"
  packer_repo['entry']+=' '
  packer_repo['entry']+="$component"

  readonly packer_repo
}

readonly apt_packages=(
  'gnupg'
  'lsb-release'
)

function main {
  local pat="$1"

  apt-get update
  apt-get install -y "${apt_packages[@]}"

  make_packer_repo

  # ???: Necessary for debian slim image variant. <>c:w
  mkdir -m 600 /root/.gnupg

  gpg --no-default-keyring \
    --keyring "${packer_repo['keyring']}" \
    --keyserver "${packer_repo['keyserver']}" \
    --recv-keys "${packer_repo['fingerprint']}"

  echo "${packer_repo['entry']}" > "${packer_repo['list']}"

  apt-get update
  apt-get install "${packer_repo['package']}"
}

main "$@"
