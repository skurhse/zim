#!/usr/bin/env bash

# REQ: Removes the kubic apt repository and signing key. <eris 2023-05-25>
# SEE: https://podman.io/docs/installation#debian <>

# !!!: Not presently working. <eris 2023-05-27>
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
key[ring]=/usr/share/keyrings/kubic.gpg

readonly list=/etc/apt/sources.list.d/kubic.list

gpg --version

sudo rm -f ${key[ring]} ${list}
sudo apt-get update
