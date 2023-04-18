#!/usr/bin/env bash

# REQ: Installs openlens from github releases. <skr 2023-04-18>

# SEE: https://github.com/MuhammedKalkan/OpenLens <>

set +B -Cefuvxo pipefail

repo=MuhammedKalkan/OpenLens
dir=/tmp/$repo
arch=$(dpkg --print-architecture)

deb=*.$arch.deb
sha256=$deb.sha256
patterns=($deb $sha256)

flags+=(--repo $repo)
flags+=(--dir $dir)

for pattern in "${patterns[@]}"; do
  flags+=(--pattern "$pattern")
done

rm -rf $dir
mkdir -p $dir
gh release download "${flags[@]}"

cd $dir
set +o noglob
sha256sum --check $sha256
sudo apt-get install --assume-yes ./$deb
