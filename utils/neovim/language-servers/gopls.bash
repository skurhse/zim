#!/usr/bin/env bash

# REQ: Installs gopls with go get. <skr 2023-04-05>

sudo GOBIN=/usr/local/go/bin go install golang.org/x/tools/gopls@latest
