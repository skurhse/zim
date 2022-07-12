#!/usr/bin/env bash

# installs a python source release

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://github.com/python/cpython#build-instructions <dru 2020-08-19>

py_version='3.9.6'
py_method='wget' # 'git'
py_dir='/tmp/python/'

# CAVEAT: defines *additional* build dependencies <dru 2020-08-19>
declare -a py_deps
py_deps+=('build-essential')
py_deps+=('gdb')
py_deps+=('git')
py_deps+=('lcov')
py_deps+=('libbz2-dev')
py_deps+=('libffi-dev')
py_deps+=('libgdbm-dev')
py_deps+=('liblzma-dev')
py_deps+=('libncurses5-dev')
py_deps+=('libreadline6-dev')
py_deps+=('libsqlite3-dev')
py_deps+=('libssl-dev')
py_deps+=('lzma')
py_deps+=('lzma-dev')
py_deps+=('tk-dev')
py_deps+=('uuid-dev')
py_deps+=('zlib1g-dev')

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
