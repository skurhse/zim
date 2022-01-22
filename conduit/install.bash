#!/usr/bin/env bash
# REQ: Installs conduit from the official release binary. <skr 2021-01-22>
# SEE: https://gitlab.com/famedly/conduit/-/blob/next/DEPLOY.md#installing-conduit <>
# ..............................................................................
set +B -Cefuvxo pipefail

realpath=$(realpath "${BASH_SOURCE[0]}")
dirname=$(dirname "$realpath")

release=x86_64-unknown-linux-musl
binary=conduit-$release
url=https://gitlab.com/famedly/conduit/-/jobs/artifacts/master/raw/$binary?job=build:release:cargo:$release

sudo apt-get update
sudo apt-get install --yes wget

cd /tmp
mkdir --parents conduit
cd conduit
wget --timestamping $url

sudo adduser --system conduit --no-create-home

sudo install --compare --owner conduit --group nogroup --mode 100 \
  $(basename $url) /usr/local/bin/matrix-conduit
sudo install --compare --directory --owner conduit --group nogroup --mode 100 \
  /etc/matrix-conduit
sudo install --compare --owner conduit --group nogroup --mode 400 \
  $dirname/conduit.toml /etc/matrix-conduit/conduit.toml
sudo install --compare --directory --owner conduit --group nogroup --mode 700 \
  /var/lib/matrix-conduit/conduit_db


