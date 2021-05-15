#!/usr/bin/env bash
# installs the hugo program

set -o xtrace

    repo='gohugoio/hugo'
platform='Linux'
    arch='64bit'

pcre="hugo_[\d]+\.[\d]+\.[\d]+_$platform-$arch.tar.gz"

if (( EUID != 0 ))
then
  echo 'script requires root' 1>&2
  exit 1
fi

cd /tmp

gh auth refresh
tarball="$(gh release view --repo "$repo"|grep --perl-regexp "$pcre"|cut -f2)"
gh release download --repo "$repo" latest "$tarball"
tar --extract --file "$tarball"

install hugo /usr/bin/ 
