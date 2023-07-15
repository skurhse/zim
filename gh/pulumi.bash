#!/usr/bin/env bash

# REQ: Installs the Pulumi release binary. <eris 2023-07-14>

# SEE: https://github.com/pulumi/pulumi/releases <>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

arch=$(uname --machine)
case $arch in
  x86_64) arch=x64   ;;
  arm64)  arch=amd64 ;;
  *)      exit 1     ;;
esac
readonly arch

kernel=$(uname --kernel-name)
case $kernel in
  Darwin|Linux|Windows) ;;
  *) exit 1             ;;
esac
readonly kernel=${kernel,,}

readonly program='pulumi'
readonly repo="pulumi/pulumi"
readonly tarball="pulumi-*-$kernel-$arch.tar.gz"
readonly checksums='pulumi-*-checksums.txt'
readonly signature='pulumi-*-checksums.txt.sig'

readonly cert_id='https://github.com/pulumi/pulumi/.github/workflows/ci-prepare-release.yml@refs/heads/staging'
readonly cert_oidc_issuer='https://token.actions.githubusercontent.com'

readonly tmpdir='/tmp/pulumi/'
readonly bindir='/usr/local/bin/'

flags+=(--repo "$repo" --skip-existing)
for pattern in "$tarball" "$checksums" "$signature"
do
  flags+=('--pattern' "$pattern")
done

mkdir -p "$tmpdir"; cd "$tmpdir"

gh release download "${flags[@]}"

set +o noglob
tar --extract --gunzip --file $tarball \
  --strip-components 1 --skip-old-files

sha256sum --check $checksums --ignore-missing

cosign verify-blob $checksums \
  --bundle $signature \
  --certificate-oidc-issuer "$cert_oidc_issuer" \
  --certificate-identity "$cert_id"
set -o noglob

sudo cp "$program" "$bindir"
