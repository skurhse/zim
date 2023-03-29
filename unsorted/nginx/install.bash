#!/usr/bin/env bash
# REQ: Installs the official NGINX repository and package. <skr 2022-01-22>
# SEE: https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-prebuilt-debian-packages <>
# ..............................................................................
set +B -Cefuvxo pipefail

codename=bullseye

origin=https://nginx.org:443

repo=$origin/packages/mainline/debian/

keyserver=$origin/keys/nginx_signing.key

fingerprint=ABF5BD827BD9BF62

keyring=/usr/share/keyrings/nginx-keyring.gpg

list=/etc/apt/sources.list.d/nginx.list

sudo gpg --no-default-keyring --keyring $keyring --keyserver $keyserver --recv-keys $fingerprint

echo "deb [signed-by=$keyring] $repo $codename main" | sudo tee $list >/dev/null
echo "deb-src [signed-by=$keyring] $repo $codename main" | sudo tee $list >/dev/null

sudo apt-get update
sudo apt-get install nginx --yes

nginx -v
