#!/usr/bin/env bash

# REQ: Installs nodejs using apt. <skr 2023-02-11> 

# SEE: https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

keyserver='https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
keyring='/usr/share/keyrings/nodesource.gpg'
fingerprint='0x1655A0AB68576280'

repo='https://deb.nodesource.com/node_18.x'
arch='amd64'
list='/etc/apt/sources.list.d/nodesource.list'
package='nodejs'

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
cat "$list"

sudo apt-get update
sudo apt-get --assume-yes install "$package"
