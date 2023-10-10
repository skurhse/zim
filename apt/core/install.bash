#!/usr/bin/env bash

# REQ: Installs packages from core. <eris 2023-05-13>

# SEE: https://packages.debian.org/bookworm/ <>

# TODO: Get rid of this file. <rbt 2023-10-09>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://docs.haskellstack.org/en/stable/install_and_upgrade/#linux-packages <>
sudo apt-get install 'haskell-stack'
stack upgrade --binary-only

# SEE: https://wiki.debian.org/KDE#Installation <>
kde_packages=(
  'kde-full'
  'breeze-gtk-theme'
  'kde-config-gtk-style'
  'kde-config-gtk-style-preview'
)
sudo apt-get install "${kde_packages[@]}"

# SEE: https://packages.debian.org/bookworm/xrdp <>
sudo apt-get install 'xrdp'

declare -a packages
packages+=('dnsutils')
packages+=('htop')
packages+=('ffmpeg')
packages+=('gnupg2')
packages+=('grep')
packages+=('imagemagick')
packages+=('neofetch')
packages+=('rsync')
packages+=('sed')
packages+=('tar')
packages+=('telnet')
packages+=('traceroute')
packages+=('webp')

dirname=$(dirname "$0")
cd "$dirname"

sudo apt-get update
sudo apt-get install -y "${packages[@]}"
