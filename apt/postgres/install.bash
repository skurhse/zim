#!/usr/bin/env bash

# REQ: Installs PostgreSQL server and client packages. <rbt 2023-10-09>

# SEE: https://wiki.debian.org/PostgreSql <>


readonly packages=(
  postgresql
  postgresql-client
)

sudo apt-get update
sudo apt-get install --yes "${packages[@]}"
