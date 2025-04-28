#!/usr/bin/env bash

# REQ: Installs ruby with ruby-install. <rbt 2025-04-27>

# SEE: https://github.com/postmodern/ruby-install#install <>
#
set +o braceexpand

set -o noglob
set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

readonly github_url='https://github.com/postmodern' 

readonly release_version='0.8.3'

declare -A key
key[url]="${github_url/github/raw.github}/postmodern.github.io/master/postmodern.asc"
key[file]="${key[url]##*/}" 
key[fingerprint]='0xB9515E77'

declare -A tar
tar[url]="$github_url/ruby-install/archive/v$release_version.tar.gz"
tar[file]="ruby-install-$release_version.tar.gz"

declare -A sig
sig[url]="${github_url/github/raw.github}/ruby-install/master/pkg/${tar[file]}.asc"
sig[file]="${sig[url]##*/}"

src_dir="${tar[file]%.tar.gz}"
tmp_dir='/tmp'

cleanup(){
  cd "$tmp_dir"
  rm --recursive --verbose "$src_dir"
  for e in "${tar[file]}" "${sig[file]}"
  do
    rm --verbose "$e"
  done
}
trap cleanup EXIT

cd "$tmp_dir"

for e in 'key' 'tar' 'sig'
do
  declare -n ref="$e"
  wget --output-document "${ref[file]}" "${ref[url]}" 
done

gpg --import "${key[file]}"
gpg --fingerprint "${key[fingerprint]}"
gpg --verify "${sig[file]}" "${tar[file]}"

tar --extract --ungzip --verbose --file "${tar[file]}"

cd "$src_dir"
sudo make install

