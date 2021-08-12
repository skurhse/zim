#!/usr/bin/env bash

# installs git from source

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

url='https://www.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz'
tar="${url##*/}"
dir="${tar%.tar.gz}"

sudo apt-get update
sudo apt-get install -y \
  dh-autoreconf       \
  libcurl4-gnutls-dev \
  libexpat1-dev       \
  gettext             \
  libz-dev            \
  libssl-dev          \
                      \
  install-info        \
                      \
  asciidoc            \
  xmlto               \
  docbook2x

cd /tmp

wget "$url"

tar xf "$tar"

cd "$dir"
make configure
./configure --prefix=/usr
make all doc info
sudo make install install-doc install-html install-info

