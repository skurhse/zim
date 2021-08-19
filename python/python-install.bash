#!/usr/bin/env bash

# installs a python source release

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://devguide.python.org/setup/ <dru 2020-08-19>

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

wget "$url"
tar xf "$tgz"

cd "$dir"
./configure --with-pydebug
make -s -j2

mv "/tmp/$dir" ~/python

# SEE: https://docs.python.org/3/using/cmdline.html#environment-variables <dru 2020-08-19>
# HACK: the make'd lib folder must be added to PYTHONPATH <dru 2020-08-19>
# export PYTHONPATH=~/'python/Lib'
