#!/usr/bin/env bash

# installs the dotnet sdk

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail

# SEE: https://github.com/dotnet/core/blob/main/release-notes/6.0/preview/6.0.0-preview.4-install-instructions.md
# NOBUG: Eschewing the snap implementation. <dru 2021-09-07>

url='https://aka.ms/install-dotnet-preview'
sudo apt-get update -q2
sudo apt-get install curl moreutils vim -q2

# CAVEAT: vipe is used for user confirmation <dru 2021-09-07>
cd '/tmp/'
curl -L "$url" | EDITOR='vim -R' vipe | sudo bash
