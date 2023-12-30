#!/usr/bin/env bash

# REQ: Installs kind using go. <rbt 2023>

# SEE: https://go.dev/ref/mod#go-install <>

# SEE: https://kind.sigs.k8s.io/docs/user/quick-start/#installing-with-go-install <>

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

go install sigs.k8s.io/kind@latest
