#!/usr/bin/env bash

# setup your global git config

declare -A h

h[user.name]='drruruu'
h[user.email]='drruruu@transprogrammer.org'
h[core.editor]='vim'
h[merge.tool]='vimdiff'

for k in "${!h[@]}"
do
  git config --global "$k" "${h[$k]}"
done

git config --global --list
