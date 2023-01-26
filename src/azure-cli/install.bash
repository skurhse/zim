#!/usr/bin/env bash

# installs the azure cli from the microsoft apt repository. <skr 2023-01-25>

# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

keyserver=https://packages.microsoft.com/keys/microsoft.asc
keyring=/usr/share/keyrings/microsoft.gpg
fingerprint=0xEB3E94ADBE1229CF

repo=https://packages.microsoft.com/repos/azure-cli/
arch=amd64
list=/etc/apt/sources.list.d/microsoft.list

sudo apt-get update
sudo apt-get install --assume-yes curl gpg lsb-release

gpg --show-keys --keyid-format 0xLONG <(curl $keyserver)

sudo gpg --no-default-keyring               \
	 --keyring             $keyring     \
	 --keyserver           $keyserver   \
         --recv-keys           $fingerprint

sudo gpg --no-default-keyring          \
	 --keyring            $keyring \
	 --keyid-format       0xLONG   \
	 --list-keys

str="deb [arch=$arch signed-by=$keyring] $repo $(lsb_release -cs) main"

sudo bash -c "echo ${str@Q} > $list"

cat $list

sudo apt-get update
sudo apt-get --assume-yes install azure-cli

az --version
