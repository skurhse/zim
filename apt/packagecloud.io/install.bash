#!/usr/bin/env bash

# REQ: Installs the OpenTofu source list, signing key & package. <rbt 2023>

# SEE: https://opentofu.org/docs/intro/install/deb <>

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

keyring=/etc/apt/keyrings/opentofu.gpg
keyserver=https://packagecloud.io/opentofu/tofu/gpgkey
fingerprint=F4AF70F66EAC4337EEECC97407D3DFCD4C61499F

repo=https://packagecloud.io/opentofu/tofu/any/
distro=any
component=main

entry="deb [arch=$arch signed-by=$keyring] $repo $distro $component"

list=/etc/apt/sources.list.d/opentofu.list

package=tofu

# NOBUG: HTTP redirects must be pre-resolved or else gnupg errors. <>

realserver=$(curl -Ls -o /dev/null -w %{url_effective} $keyserver)

sudo gpg --no-default-keyring --keyring "$keyring" \
  --keyserver "$realserver" --recv-keys "$fingerprint"

sudo bash -c "echo ${entry@Q} >${list@Q}"

sudo apt-get update
sudo apt-get install --yes "$package"
