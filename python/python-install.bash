#!/usr/bin/env bash

# installs a python source release

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://github.com/python/cpython#build-instructions <dru 2020-08-19>

sudo apt-get update

# TODO: use git as recommended in dev guide <dru 2020-08-19>
sudo apt-get install -y wget

sudo apt-get build-dep python3

sudo apt-get -y install build-essential gdb lcov libbz2-dev libffi-dev \
      libgdbm-dev liblzma-dev libncurses5-dev libreadline6-dev \
      libsqlite3-dev libssl-dev lzma lzma-dev tk-dev uuid-dev zlib1g-dev

cd /tmp

url='https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz'
tgz="${url##*/}"
dir="${tgz%.*}"

wget -O "$tgz" "$url"
tar xf "$tgz"

cd "$dir"
# HACK: make fails without debug flag <dru 2020-08-19>
./configure --with-pydebug
make -j2
# make test
sudo make install
