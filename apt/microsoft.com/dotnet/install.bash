#!/usr/bin/env bash

# REQ: Installs the .NET SDK. <rbt 2023-10-09>

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

arch=$(dpkg --print-architecture)
readonly arch

readonly repo='https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod/'

# PORT: Bookworm not yet supported. <eris 2023-05-27>
readonly distro='bullseye'
readonly components=('main')

readonly keyring='/usr/share/keyrings/microsoft.gpg'

readonly entry="deb [arch=$arch signed-by=$keyring] $repo $distro ${components[*]}"

readonly list="/etc/apt/sources.list.d/microsoft.list"

readonly packages=(
  'dotnet-sdk-7.0'
  'azure-functions-core-tools'
)

grep --line-regexp --fixed-strings "$entry" "$list" || sudo bash -c "echo ${entry@Q} >>${list@Q}"

sudo apt-get update

sudo apt-get install --yes "${packages[@]}"

dotnet --version
func --version
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
if ! grep --line-regexp --silent "export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1" ~/.bash_profile; then
  echo "export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1" >> ~/.bash_profile
fi
