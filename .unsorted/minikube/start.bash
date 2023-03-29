#!/usr/bin/env bash

set +B -Cefuvxo pipefail

sudo service docker start
minikube start
