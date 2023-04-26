#!/usr/bin/env bash

# REQ: Installs the helm signing key and apt repository. <skr 2023-04-25>

# SEE: https://helm.sh/docs/intro/install/#from-apt-debianubuntu <>

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

declare -A key
key[server]=https://baltocdn.com/helm/signing.asc
key[ring]=/usr/share/keyrings/helm.gpg
key[fingerprint]=81BF832E2F19CD2AA0471959294AC4827C1A168A

declare -A src
src[archive_type]=deb
src[architecture]=$(dpkg --print-architecture)
src[signed-by]=${key[ring]}
src[repository_url]=https://baltocdn.com/helm/stable/debian/
src[distribution]=all
src[component]=main

readonly list=/etc/apt/sources.list.d/kubernetes.list

gpg --version

sudo gpg \
  --no-default-keyring                     \
  --keyring            ${key[ring]}        \
  --keyserver          ${key[server]}      \
  --recv-keys          ${key[fingerprint]}

entry=${src[archive_type]}
entry+=" [arch=${src[architecture]} signed-by=${src[signed-by]}]"
entry+=" ${src[repository_url]}"
entry+=" ${src[distribution]}"
entry+=" ${src[component]}"

sudo bash -c "echo ${entry@Q} > ${list@Q}"

sudo apt-get update

