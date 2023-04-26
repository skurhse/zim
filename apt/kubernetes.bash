#!/usr/bin/env bash

# REQ: Installs the google signing key . <2023-04-21>
# REQ: Creates the kubernetes source entry. <>

# SEE: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management <>

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
key[server]=https://packages.cloud.google.com/apt/doc/apt-key.gpg
key[ring]=/usr/share/keyrings/google-cloud.gpg
key[fingerprint]=A362B822F6DEDC652817EA46B53DC80D13EDEF05

declare -A src
src[archive_type]=deb
src[architecture]=$(dpkg --print-architecture)
src[signed-by]=${key[ring]}
src[repository_url]=https://apt.kubernetes.io/
src[distribution]=kubernetes-xenial
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

