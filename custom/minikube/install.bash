#!/usr/bin/env bash

# REQ: Installs the latest minikube package from the Google APIs CDN. <skr 2023-04-05>

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

curl --version 

declare -A pkg
pkg[release]='latest'
pkg[arch]=$(dpkg --print-architecture)
pkg[url]="https://storage.googleapis.com/minikube/releases/${pkg[release]}/minikube_${pkg[release]}_${pkg[arch]}.deb"
pkg[name]=${pkg[url]##*/}

function cleanup()
{
  rm -f /tmp/${pkg[name]}
}
trap cleanup INT TERM EXIT

cd /tmp
curl --location --remote-name -- ${pkg[url]}
sudo dpkg -i ${pkg[name]}

