#!/usr/bin/env bash

# REQ: Connects to a remote server. <skr 2023-02-05>

# NOTE: Uses ZIM_HOST, ZIM_USER and ZIM_KEY environment variables. <>

set +o 'braceexpand'
set -o 'errexit'
set -o 'noclobber'
set -o 'noglob'
set -o 'nounset'
set -o 'pipefail'
set -o 'xtrace'

declare -Ar dependencies=(
  ['openssh-client']='1:8.4p1-5+deb11u1'
)

for package in "${!dependencies[@]}"; do
  version="${dependencies[$package]}"
  actual="$(dpkg-query --show --showformat='${Version}' "$package")"
  if [[ "$actual" != "$version" ]]; then
    echo "ERROR: $package $version required, but $actual installed." >&2
    exit 1
  fi
done

ssh -i "$ZIM_KEY" -- "$ZIM_USER@$ZIM_HOST"
