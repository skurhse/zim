#!/usr/bin/env bash

# REQ: Installs the minikube binary. <skr 2021-12-19>

# SEE: https://minikube.sigs.k8s.io/docs/start/ <>

# USAGE: minikube/install.bash <>

# ..............................................................................
set +B -Cefuvxo pipefail

cd /tmp

curl --location --remote-name \
  https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

rm minikube-linux-amd64
