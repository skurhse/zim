#!/usr/bin/env bash

# REQ: Installs the MongoDB Server 6.0 APT repository and signing key. <eris>

# SEE: https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/ <>

# PORT: Only x86_64 "Bullseye" is currently supported. <>
# SEE: https://repo.mongodb.org/apt/debian/dists/ <2023-03-31>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly list='/etc/apt/sources.list.d/mongodb.list'
readonly origin='mongodb'

readonly archive_type='deb'
readonly architecture='amd64'
readonly signed_by='/etc/apt/keyrings/mongodb-server-6.0.gpg'
readonly repository_url='https://repo.mongodb.org/apt/debian'
readonly distribution='bullseye/mongodb-org/6.0'
readonly component='main'

readonly keyserver='https://pgp.mongodb.com/server-6.0.asc'
readonly fingerprint='39BD841E4BE5FB195A65400E6A26B1AE64C3C388'

gpg --show-keys <(curl -L "$keyserver")

sudo gpg \
   --no-default-keyring                \
	 --keyring            "$signed_by"   \
	 --keyserver          "$keyserver"   \
   --recv-keys          "$fingerprint"

sudo gpg \
   --no-default-keyring              \
   --keyring            "$signed_by" \
	 --list-keys

source="${archive_type} [arch=${architecture} signed-by=${signed_by}] ${repository_url} ${distribution} ${component}"

sudo bash -c "echo ${source@Q} >${list@Q}"
cat "$list"

sudo apt-get update
sudo aptitude search "?origin(${origin})"
