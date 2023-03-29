#!/usr/bin/env bash

# REQ: Installs the .NET 7.0 SDK. <skr 2023-03-28>

# SEE: https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly package='dotnet-sdk-7.0'

if ! apt-cache show "$package"; then
  if [[ $PIPESTATUS == 100 ]]; then
    dirname=$(dirname -- "$0")
    path=$(realpath -- "$dirname/../apt/microsoft-debian.bash")
    echo "The microsoft debian repository is not installed."
    echo "To install, run:"
    echo "$path"
    exit 4
  else
    echo "Unexpected apt-cache show exit code: $PIPESTATUS"
    exit 5
  fi
fi

if status=$(dpkg-query --show --showformat='${db:Status-Status}' "$package"); then
  if [[ "$status" == 'installed' ]]; then
    echo "$package is already installed."
    exit 2
  else
    echo "Unexpected dpkg-query status: $status"
    exit 5
  fi
else
  if [[ $? != 1 ]]; then
    echo "Unexpected dpkg-query exit code: $?"
    exit 5
  fi
fi

sudo apt-get install --assume-yes -- "$package"

dotnet --version
