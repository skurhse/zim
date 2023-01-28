#!/usr/bin/env bash

set +B -Cefuxvo pipefail

# installs the bicep language server. <skr 2023-01-28>

# https://github.com/OmniSharp/omnisharp-roslyn#downloading-omnisharp <>

repo='OmniSharp/omnisharp-roslyn'
asset='omnisharp-linux-x64-net6.0.tar.gz'

dir="/tmp/$repo/"
src="$dir$asset"
trg='/usr/local/bin/omnisharp-roslyn'

gh release download --clobber \
  --repo            $repo     \
  --dir             $dir      \
  --pattern         $asset 

sudo rm -rf $trg
sudo mkdir -p $trg
sudo tar -xf $src -C $trg
