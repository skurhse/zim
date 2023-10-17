#!/usr/bin/env bash

# REQ: Installs the Microsoft signing key. <eris 2023-05-27>

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

gpg --version

sudo gpg \
  --no-default-keyring \
  --keyring   '/usr/share/keyrings/microsoft.gpg' \
  --keyserver 'https://packages.microsoft.com/keys/microsoft.asc' \
  --recv-keys 'BC528686B50D79E339D3721CEB3E94ADBE1229CF'
