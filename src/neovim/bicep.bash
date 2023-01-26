#!/usr/bin/env bash

# installs the bicep language server. <skr 2023-01-25>

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

repo=Azure/bicep
asset=bicep-langserver.zip

dir=/tmp/$repo/
src=$dir/$asset
trg=/usr/local/bin/bicep-langserver

gh release download --clobber \
  --repo            $repo     \
  --dir             $dir      \
  --pattern         $asset 

rm -rf $trg
sudo unzip -d $trg $src
