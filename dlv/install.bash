#!/usr/bin/env bash
# REQ: Installs delve with `go install`. <skr 2022-01-15>
# SEE: https://github.com/go-delve/delve/tree/master/Documentation/installation
# ..............................................................................
set +B -Cefuvxo pipefail

go install github.com/go-delve/delve/cmd/dlv@latest

dlv version
