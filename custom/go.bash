#!/usr/bin/env bash
# REQ: Installs go from the official release archive. <skr 2021-01-16>
# SEE: https://go.dev/doc/install <>
# ..............................................................................
set +B -Cefuxvo pipefail

version=1.17.6
archive=go$version.linux-amd64.tar.gz

cd /tmp

wget --timestamping https://go.dev/dl/$archive

sudo rm --recursive --force /usr/local/go/

sudo tar --directory /usr/local --extract --gunzip --file $archive

export PATH="$PATH:/usr/local/go/bin"

go version
