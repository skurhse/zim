#!/usr/bin/env bash
# installs the hugo program

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

repo='gohugoio/hugo'

platform='Linux'

arch='64bit'

pcre="hugo_[\d]+\.[\d]+\.[\d]+_$platform-$arch.tar.gz"

(( EUID != 0 )) && {echo 'script requires root' 1>&2; exit 1}

cd /tmp

gh auth refresh

tarball="$(gh release view --repo "$repo"|grep --perl-regexp "$pcre"|cut -f2)"

[[ -f "$tarball" ]] && rm "$tarball"
gh release download --repo "$repo" --pattern "$tarball"

tar --extract --file "$tarball"
install hugo /usr/bin/ 
