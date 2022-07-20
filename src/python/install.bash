#!/usr/bin/env bash

# REQ: Installs CPython from source with all optional modules. <skr 2022-07>

# SEE: https://github.com/python/cpython#build-instructions <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail

set -o xtrace

py_version='3.9.6'
py_method='wget' # 'git'
py_dir='/tmp/python/'

py_deps=(
  'build-essential'
  'ccache'
  'gdb'
  'lcov'
  'libb2-dev'
  'libbz2-dev'
  'libffi-dev'
  'libgdm-dev'
  'libgdbm-compat-dev'
  'liblzma-dev'
  'libncurses5-dev'
  'libreadline6-dev'
  'libsqlite3-dev'
  'libssl-dev'
  'pkg-cconfig'
  'lzma'
  'lzma-dev'
  'tk-dev'
  'uuid-dev'
  'zlib1g-dev'
)

declare -a script_deps
case "$py_method" in
  'git')
    script_deps+=('git') 
    ;;
  'wget')
    script_deps+=('tar') 
    script_deps+=('wget')
    ;;
   *)
    exit 1
    ;;
esac

sudo apt-get update

sudo apt-get build-dep 'python3'

sudo apt-get -y install "${py_deps[@]}" "${script_deps[@]}"

[[ -d "$py_dir" ]] && sudo rm -rf "$py_dir"

case "$py_method" in
  'git')
    py_tag="v$py_version"
    git clone --depth '1' --branch "$py_tag" 'https://github.com/python/cpython' "$py_dir"
    ;;
  'wget')
    py_url="https://www.python.org/ftp/python/$py_version/Python-$py_version.tgz"
    mkdir "$py_dir"
    wget -qO- "$py_url" | tar xvz -C "$py_dir" --strip-components '1'
    ;;
   *)
    exit 1
    ;;
esac

cd "$py_dir"
./configure
make -j2
sudo make install
