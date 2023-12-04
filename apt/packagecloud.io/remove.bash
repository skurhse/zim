#!/usr/bin/env bash

# REQ: Removes the OpenTofu source list, signing key & package. <rbt 2023>

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

keyring=/etc/apt/keyrings/opentofu.gpg
list=/etc/apt/sources.list.d/opentofu.list
package=tofu

sudo apt-get remove --yes "$package"
sudo rm -f "$keyring" "$list"
sudo apt-get update
