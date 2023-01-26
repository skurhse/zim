#!/usr/bin/env bash

set +B -Cefuxvo pipefail

# installs the bicep language server. <skr 2023-01-25>

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
