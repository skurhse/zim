#!/usr/bin/env bash

# REQ: Installs the Kubernetes repository. <eris 2023-06-04>
# REQ: Installs kubelet, kubeadm, and kubectl. <>

# SEE: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ <>

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

readonly keyserver='https://packages.cloud.google.com/apt/doc/apt-key.gpg'
readonly keyring='/usr/share/keyrings/google-cloud.gpg'
readonly fingerprint='A362B822F6DEDC652817EA46B53DC80D13EDEF05'

arch="$(dpkg --print-architecture)"
readonly arch

readonly repo='https://apt.kubernetes.io/'

# PORT: No bookworm support. <eris 2023-06-02>
readonly distro='kubernetes-stretch'
readonly component='main'

readonly list='/etc/apt/sources.list.d/kubernetes.list'

readonly entry="deb [arch=${arch} signed-by=$keyring] ${repo} ${distro} ${component}"

gpg --version

sudo gpg --no-default-keyring \
  --keyring "$keyring" --keyserver "$keyserver" --recv-keys "$fingerprint"


sudo bash -c "echo ${entry@Q} > ${list@Q}"

sudo apt-get update
sudo apt-get install "${packages[@]}"
