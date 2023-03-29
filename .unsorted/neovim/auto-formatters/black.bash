#!/usr/bin/env bash

# REQ: Installs black, the python auto-formatter. <skr 2023-02-11>

# SEE: https://black.readthedocs.io/en/stable/integrations/editors.html#vim <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail

sudo pip install black
