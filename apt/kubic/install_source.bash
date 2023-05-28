#!/usr/bin/env bash

# REQ: Installs the kubic apt repository and signing key. <eris 2023-05-25>
# SEE: https://podman.io/docs/installation#debian <>

# !!!: Not presently working. <eris 2023-05-26>
# SEE: https://github.com/containers/podman/issues/18704 <>

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

# NOTE: Key must be dearmored and imported. <eris 2023-05-25>
declare -A key
key[download]=https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_Testing/Release.key
key[ring]=/usr/share/keyrings/kubic.gpg
key[fingerprint]=2472D6D0D2F66AF87ABA8DA34D64390375060AA4
readonly key

declare -A src
src[archive_type]=deb
src[architecture]=$(dpkg --print-architecture)
src[signed-by]=${key[ring]}
src[repository_url]=http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/
src[distribution]=/
#src[component]=main
readonly src

readonly list=/etc/apt/sources.list.d/kubic.list

gpg --version

rm -f /tmp/kubic.gpg
curl -fsSL ${key[download]} | gpg --dearmor --output /tmp/kubic.gpg

# check key fingerprint before importing
keys=$(gpg --show-keys --with-colons --with-fingerprint /tmp/kubic.gpg)

actual=$(awk -F: '/^fpr:/ {print $10}' <<<$keys)

if [[ ${actual} != ${key[fingerprint]} ]]; then
  echo "ERROR: Key fingerprint mismatch."
  exit 1
fi

sudo gpg --no-default-keyring --keyring ${key[ring]} --import /tmp/kubic.gpg

entry=${src[archive_type]}
entry+=" [arch=${src[architecture]} signed-by=${src[signed-by]}]"
entry+=" ${src[repository_url]}"
entry+=" ${src[distribution]}"
#entry+=" ${src[component]}"

sudo bash -c "echo ${entry@Q} > ${list@Q}"

sudo apt-get update
