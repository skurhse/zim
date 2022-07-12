#!/usr/bin/env bash

# inspects debian packages with apt-cache and dpkg

declare -A flgs
flgs[on]=-
flgs[off]=+

on=(errexit noclobber noglob nounset pipefail xtrace)
off=(verbose)

for flg in ${!flgs[@]}; do
  swt=${flgs[$flg]}
  declare -n opts=$flg
  for opt in ${opts[@]}; do set ${swt}o $opt; done
done

cmds=(madison policy showpkg stat)

# apt-cache's madison command attempts to mimic the output format and a subset of the functionality of
# the Debian archive management tool, madison.
#
# it displays available versions of a package in a tabular format.
madison=(apt-cache madison)

# policy is meant to help debug issues relating to the preferences file.
#
# it prints out detailed information about the priority selection of the named package.
policy=(apt-cache policy)

# showpkg displays information about packages.
#
# the available versions, reverse dependencies and forward dependencies are listed.
showpkg=(apt-cache showpkg)

# report status of specified package.
#
# this just displays the entry in the installed package status database.
stat=(dpkg-query --status)

mkdir /tmp/"$(basename "$0")$(date --iso-8601=ns)"
cd "$_" 

for pkg in "$@"; do
  mkdir "$pkg"
  cd "$_"
  for cmd in "${cmds[@]}"; do
    declare -n wrds="$cmd"
    "${wrds[@]}" "$pkg" > "$cmd.log"
  done
  vim -R .
done
