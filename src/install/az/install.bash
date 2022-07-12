#!/usr/bin/env bash

# installs the azure cli with apt

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

# SEE: https://docs.microsoft.com/e6n-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions <dru 2021-08-26>

declare -A key
key['server']='https://packages.microsoft.com/keys/microsoft.asc'
key['ring']='/usr/share/keyrings/microsoft.gpg' 
key['fingerprint']=''

declare -A repo
repo['url']='https://packages.microsoft.com/repos/azure-cli/'
repo['arch']='amd64'

# TODO: determine what's actually necessary with gpg implementation. <dru 2021-08-26>
declare -a deps
deps+=('apt-transport-https')
deps+=('ca-certificates')
deps+=('curl')
deps+=('gnupg')
deps+=('lsb-release')
# deps+=('software-properties-common')

sudo apt-get update --quiet=2
sudo apt-get install --quiet=2 "${deps[@]}"

sudo gpg \
  --no-default-keyring \
  --keyring "${key['ring']}" \
  --keyserver "${key['server']}" \
  --recv-keys

# CAVEAT: apt-add-repository does not support signed-by. <dru 2021-08-26>
sudo bash -c "echo 'deb [arch=${repo['arch']} signed-by=${key['ring']}] ${repo['url']} $(lsb_release -cs) stable' >> /etc/apt/sources.list"

# SEE: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver#install-the-aks-preview-cli-extension <dru 2021-08-26>
az extension add --name aks-preview
az extension update --name aks-preview
