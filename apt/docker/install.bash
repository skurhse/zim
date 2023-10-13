#!/usr/bin/env bash

# REQ: Installs the Docker package suite. <>

# SEE: https://docs.docker.com/engine/install/debian/ <>

# USAGE: exec apt/docker/install.bash <>

# NOTE: The invoking shell's supplementary groups must be refreshed. <>
# NOTE: To do so, call `exec sudo --preserve-env --user $USER bash` <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

arch=$(dpkg --print-architecture)

repo='https://download.docker.com/linux/debian/'
list='/etc/apt/sources.list.d/docker.list'
keyring='/usr/share/keyrings/docker-archive-keyring.gpg'

source /etc/os-release
distro="$VERSION_CODENAME"

# NOBUG: No trixie support. <2023-10-12>
[[ $distro == 'trixie' ]] && distro='bookworm'

# NOBUG: Inheriting a semantic error from Docker team <>
# SEE: https://wiki.debian.org/SourcesList#Component <>
component='stable' 

source="deb [arch=$arch signed-by=$keyring] $repo $distro $component"

keyserver='https://download.docker.com/linux/debian/gpg'
fingerprint='9DC858229FC7DD38854AE2D88D81803C0EBFCD88'

packages=(
  'docker-ce'
  'docker-ce-cli'
  'containerd.io'
  'docker-buildx-plugin'
  'docker-compose-plugin'
)

sudo gpg --no-default-keyring --keyring "$keyring" \
  --keyserver "$keyserver" --recv-keys "$fingerprint"

sudo bash -c "echo ${source@Q} > ${list@Q}"

sudo apt update

# CAVEAT: Group changes must precede installation. <>
sudo groupadd --force -- docker
sudo usermod --append --groups docker -- $USER

sudo apt-get install "${packages[@]}" 

sudo --user $USER -- bash -c 'docker run hello-world'
