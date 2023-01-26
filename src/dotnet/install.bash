#!/usr/bin/env bash

# installs the dotnet sdk with apt. <skr 2023-01-25>

# https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

repo=microsoft-debian-bullseye-prod
package=dotnet-sdk-7.0

keyserver=https://packages.microsoft.com/keys/microsoft.asc
keyring=/usr/share/keyrings/microsoft.gpg
fingerprint=0xEB3E94ADBE1229CF

url=https://packages.microsoft.com/repos/$repo/
arch=amd64
list=/etc/apt/sources.list.d/dotnet.list

gpg --show-keys --keyid-format 0xLONG <(curl $keyserver)

sudo gpg --no-default-keyring               \
	 --keyring             $keyring     \
	 --keyserver           $keyserver   \
         --recv-keys           $fingerprint

sudo gpg --no-default-keyring          \
	 --keyring            $keyring \
	 --keyid-format       0xLONG   \
	 --list-keys

str="deb [arch=$arch signed-by=$keyring] $url $(lsb_release -cs) main"

sudo bash -c "echo ${str@Q} > $list"
cat $list

sudo apt-get update
sudo apt-get --assume-yes install $package

dotnet --version
