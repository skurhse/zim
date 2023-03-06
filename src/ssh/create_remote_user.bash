#!/usr/bin/env bash

# Creates a remote ssh user. <skr 2023-03-05>

# NOTE: Uses ZIM_HOST, ZIM_USER and ZIM_KEY environment variables. <>
# NOTE: Uses ZIM_TARGET_USER and ZIM_TARGET_PUBKEY environment variables. <>

# NOHACK: ZIM_USER must have sudo privileges on ZIM_HOST. <>

set +o 'braceexpand'
set -o 'errexit'
set -o 'noclobber'
set -o 'noglob'
set -o 'nounset'
set -o 'pipefail'
set -o 'xtrace'

declare -Ar dependencies=(
  ['dpkg']='1.20.12'
  ['rsync']='3.2.3-4+deb11u1'
)

for package in "${!dependencies[@]}"; do
  version="${dependencies[$package]}"
  actual="$(dpkg-query --show --showformat='${Version}' "$package")"
  if [[ "$actual" != "$version" ]]; then
    echo "ERROR: $package $version required, but $actual installed." >&2
    exit 1
  fi
done

readonly remote_init_script='!#/usr/bin/env bash

set +o '\''braceexpand'\''
set -o '\''errexit'\''
set -o '\''noclobber'\''
set -o '\''noglob'\''
set -o '\''nounset'\''
set -o '\''pipefail'\''
set -o '\''xtrace'\''

declare -Ar dependencies=(
  ['\''passwd'\'']='\''1:4.8.1-1'\''
)

for package in "${!dependencies[@]}"; do
  version="${dependencies[$package]}"
  actual="$(dpkg-query --show --showformat='\''${Version}'\'' "$package")"
  if [[ "$actual" != "$version" ]]; then
    echo "ERROR: $package $version required, but $actual installed." >&2
    exit 1
  fi
done
'

if [[ $ZIM_TARGET_SUDOER == 'true' ]]; then
  remote_init_script+="sudo useradd -m -G sudo -- ${ZIM_TARGET_USER@Q}"$'\n'
else
  remote_init_script+="sudo useradd -m -- '${ZIM_TARGET_USER@Q}"$'\n'
fi

ssh -i "$ZIM_KEY" "${ZIM_USER}@${ZIM_HOST}" <<<$remote_init_script

rsync \
  --ignore-existing \
  --no-owner \
  --no-group \
  --chown "$ZIM_TARGET_USER:$ZIM_TARGET_USER" \
  --no-perms \
  --chmod 'ugo=rwX' \
  --rsh   "ssh -i $ZIM_KEY" \
-- "$ZIM_TARGET_PUBKEY" "$ZIM_USER@$ZIM_HOST:/home/$ZIM_TARGET_USER/.ssh/authorized_keys"
