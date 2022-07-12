#!/usr/bin/env bash
# REQ: Installs helm from script. <skr 2021-12-09>
# SEE: https://helm.sh/docs/intro/install/#from-script <>
# USAGE: helm/install.bash <>
# .............................................................................
set +B -Cefuvxo pipefail

url=https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
file=/tmp/get_helm.sh

sudo apt-get update --yes
sudo apt-get install --yes -- curl

# NOTE: --fail overrides --silent --show-error. <skr>
curl --fail --location \
 --output $file \
-- $url

chmod 700 $file
$file

helm version
