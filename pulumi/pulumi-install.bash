#!/usr/bin/env bash

# Installs the Pulumi CLI.
# Usage: ./pulumi-install.bash

set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://www.pulumi.com/docs/get-started/install/ <dru 2020-09-11>

ver=3.13.0
tmp=/tmp/pulumi/
bin=/usr/local/bin/
url=https://get.pulumi.com/releases/sdk/pulumi-v$ver-linux-x64.tar.gz

sudo apt-get update
sudo apt-get install --yes 'wget'

if [[ -d "$tmp" ]]
then
  rm \
    --force \
    --recursive \
    --verbose \
    -- "$tmp"
fi

mkdir \
  --parents \
  --verbose \
  -- "$tmp"

wget \
  --output-document='-' \
  --verbose \
  -- "$url" \
| tar \
  --extract \
  --directory="$tmp" \
  --gzip \
  --strip-components=1 \
  --verbose

sudo rm \
  --force \
  --recursive \
  --verbose \
  -- "${bin}pulumi-"* "${bin}pulumi"

sudo mv \
  --verbose \
  -- "${tmp}pulumi-"* "${tmp}pulumi" "$bin"

rm \
  --force \
  --recursive \
  --verbose \
  -- "$tmp"
