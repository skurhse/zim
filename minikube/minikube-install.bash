#!/usr/bin/env bash

# installs the minikube debian package

# REQ: https://minikube.sigs.k8s.io/docs/start/ <dru 2020-06-15>

pkg=minikube_latest_amd64.deb
url=https://storage.googleapis.com/minikube/releases/latest/$pkg

cd /tmp

curl -LO $url

sudo dpkg -i $pkg 

rm -v $pkg
