#!/usr/bin/env bash

# REQ: Installs git from source. <skr 2023-03-02>

# SEE: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git <skr 2020-08-19>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

version='2.39.2'
url="https://www.kernel.org/pub/software/scm/git/git-${version}.tar.gz"
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

