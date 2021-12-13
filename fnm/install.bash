#!/usr/bin/env bash

# REQ: Installs fast node manager. <skr 2021-12-13>

# SEE: https://github.com/Schniz/fnm#using-a-script-macoslinux <>

# USAGE: fnm/install.bash <>

# ..............................................................................
set +B -Cefuvxo pipefail

curl -fsSL https://fnm.vercel.app/install | bash

export PATH="/home/skr/.fnm:$PATH"
eval "$(fnm env)"

fnm --version
