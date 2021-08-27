#!/usr/bin/env bash

# installs the pulumi cli from source

set -o errexit
set -o noclobber
# set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://www.pulumi.com/docs/get-started/install/ <dru 2020-08-22>

declare -A pulumi
pulumi['version']='3.11.0'
pulumi['dir']='/tmp/pulumi/'
pulumi['url']="https://get.pulumi.com/releases/sdk/pulumi-v${pulumi['version']}-linux-x64.tar.gz"

sudo apt-get update --quiet=2
sudo apt-get install --quiet=2 wget

[[ -d "${pulumi['dir']}" ]] && rm -rf "${pulumi['dir']}"
mkdir --parents "${pulumi['dir']}"

wget -qO- "${pulumi['url']}" | tar xvz -C "${pulumi['dir']}" --strip-components 1

sudo mv "${pulumi['dir']}"* /usr/local/bin/
