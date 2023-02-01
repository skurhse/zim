#!/usr/bin/env bash

# installs mongodb with apt. <skr 2023-01-31>

# https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/ <>

set +B -Cefuxo pipefail

package='mongodb-org'
version='6.0'

keyserver='https://pgp.mongodb.com/server-6.0.asc'
keyring='/usr/share/keyrings/mongodb-server-6.0.gpg'
fingerprint='0x6A26B1AE64C3C388'

archive_type='deb'
repository_url='https://repo.mongodb.org/apt/debian'
architecture=$(dpkg --print-architecture)
distribution="$(lsb_release -cs)/$package/$version"
component='main'
list='/etc/apt/sources.list.d/dotnet.list'


gpg --show-keys --keyid-format 0xLONG <(curl -L $keyserver)

sudo gpg --no-default-keyring               \
	 --keyring             $keyring     \
	 --keyserver           $keyserver   \
         --recv-keys           $fingerprint

sudo gpg --no-default-keyring          \
	 --keyring            $keyring \
	 --keyid-format       0xLONG   \
	 --list-keys

str="$archive_type [arch=$architecture signed-by=$keyring] $repository_url $distribution $component"

sudo bash -c "echo ${str@Q} > $list"
cat $list

sudo apt-get update
sudo apt-get --assume-yes install $package

mongosh --version
