#!/usr/bin/env bash
# REQ: Installs deps and builds crystal. <skr 2022-01-15>
# ..............................................................................
set +B -Cefuvxo pipefail

sudo apt-get update

sudo apt-get install --yes \
  automake \
  build-essential \
  git \
  libbsd-dev \
  libedit-dev \
  libevent-dev \
  libgmp-dev \
  libgmpxx4ldbl \
  libpcre3-dev \
  libssl-dev \
  libtool \
  libxml2-dev \
  libyaml-dev \
  lld \
  llvm \
  llvm-dev

# SEE: /usr/bin/ld: cannot find -lpcre2-8 (this usually means you need to install the development package for libpcre2-8) <skr 2022-01-15>
sudo apt-get install --yes r-base-dev

cd /tmp
rm --force --recursive --verbose /tmp/crystal/
gh repo clone crystal-lang/crystal

cd crystal
make

bin/crystal version
