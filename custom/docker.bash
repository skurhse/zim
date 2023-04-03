#!/usr/bin/env bash

# REQ: Installs and configures Docker. <skr 2023-03-31

# SEE: https://docs.docker.com/engine/install/debian/#install-using-the-repository <>
# SEE: https://docs.docker.com/engine/install/linux-postinstall/ <>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly packages=(
  'docker-ce'
  'docker-ce-cli'
  'containerd.io'
  'docker-buildx-plugin'
  'docker-compose-plugin'
)

sudo apt-get update
sudo apt-get install "${packages[@]}"

sudo groupadd -f docker
sudo usermod -aG docker $USER
newgrp docker <<'EOF'
docker run hello-world
EOF
