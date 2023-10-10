#!/usr/bin/env bash

# REQ: Removes PostgreSQL server and client packages. <rbt 2023-10-09>

readonly packages=(
  postgresql
  postgresql-client
)

sudo apt-get update
sudo apt-get install --yes "${packages[@]}"
