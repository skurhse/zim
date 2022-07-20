#!/usr/bin/env bash
# REQ: Installs bundler with rubygems. <skr 2022-01-16> 
# SEE: https://bundler.io/ <>
# ..............................................................................
set +B -Cefuvxo pipefail

gem install bundler

bundle version
