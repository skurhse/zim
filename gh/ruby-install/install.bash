#!/usr/bin/env bash

# REQ: Installs ruby-install. <rbt 2025-04-28>

# SEE: https://github.com/postmodern/ruby-install#install <>

set +o braceexpand
set +o noglob

set -o noclobber
set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

shopt -s extglob

readonly keyring='/usr/share/keyrings/postmodern.gpg'

readonly tmp='/tmp/ruby-install'
readonly src='/usr/local/src/ruby-install'

readonly repo='https://github.com/postmodern/ruby-install'

readonly key='repos/postmodern/postmodern.github.io/contents/postmodern.asc'
readonly fingerprint='04B2F3EA654140BCC7DA1B5754C3D9E9B9515E77'

gh --version
gpg --version

rm --recursive --force "$tmp"
mkdir "$tmp"
cd "$tmp"

gh release download \
  --repo "$repo" \
  --pattern 'ruby-install-*.tar.gz' \
  --pattern 'ruby-install-*.tar.gz.asc'

gh api \
  --header Accept:application/vnd.github.v3.raw \
  --method GET \
-- "$key" > postmodern.asc

sudo gpg \
  --import \
  --no-default-keyring --keyring "$keyring" \
-- postmodern.asc

gpg \
  --no-default-keyring --keyring "$keyring" \
  --fingerprint "$fingerprint"

tar --extract --ungzip --file ruby-install-*.tar.gz

gpg \
  --no-default-keyring --keyring "$keyring" \
  --verify ruby-install-*.tar.gz.asc ruby-install-*.tar.gz

sudo cp -r !(*.tar.gz|*.asc) "$src"
cd "$src"

sudo make install

ruby-install --version
