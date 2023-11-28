#!/usr/bin/env bash

# REQ: Installs the latest minikube package from the Google CDN. <rbt 2023>

# SEE: https://minikube.sigs.k8s.io/docs/start/ <>

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

arch=$(dpkg --print-architecture)

rel='latest'
pkg="minikube_${rel}_${arch}.deb"
url="https://storage.googleapis.com/minikube/releases/$rel/$pkg"

tmpdir='/tmp/'

trap "rm -f ${tmpdir@Q}${pkg@Q}" INT TERM EXIT

cd "$tmpdir"
curl --location --remote-name -- "$url"
sudo dpkg -i "$pkg"
