#!/usr/bin/env bash
# REQ: Installs the latest nightly crystal release. <skr 2022-01-02>
# ..............................................................................
set +B -Cefuvxo pipefail

host=download.opensuse.org
repo=https://$host/repositories/devel:/languages:/crystal:/nightly/Debian_Unstable/
keyserver=${repo}Release.key
fingerprint=321DC2EA7F0A4F06714516B8E456AE72856D1476
keyring=/usr/share/keyrings/crystal-keyring.gpg
list=/etc/apt/sources.list.d/crystal.list

sudo gpg --no-default-keyring --keyring $keyring --keyserver $keyserver --recv-keys $fingerprint

echo "deb [signed-by=$keyring] $repo /" | sudo tee $list >/dev/null

sudo apt-get update
sudo apt-get install crystal --yes

crystal version
