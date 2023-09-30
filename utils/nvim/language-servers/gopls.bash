#!/usr/bin/env bash

# REQ: Installs gopls with go get. <skr 2023-04-05>

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

readonly gobin="/usr/local/go/bin"

sudo GOBIN="$gobin" "$gobin/go" install golang.org/x/tools/gopls@latest
