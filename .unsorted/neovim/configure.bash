#!/usr/bin/env bash

# REQ: Installs the neovim init configuration from Gist using the Github CLI. <skr 2023-03-02>

set +o braceexpand
set -o errexit
set -o noglob
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

declare -A gist=(
  ['id']='3071390d8a63efdd6e90542ac8c6115d'
  ['user']='skurhse'
  ['filename']='init.lua'
)
gist['url']="https://gist.github.com/${gist['user']}/${gist['id']}"

tmp_dir='/tmp/${gist[url]##*/}/'
source_file="${tmp_dir}/${gist['filename']}"
target_dir=~/'.config/nvim/'

rm --force --recursive --verbose "$tmp_dir"

gh gist clone "${gist['url']}" "$tmp_dir" -- --verbose

mkdir --parents --verbose "$target_dir"

cp --verbose "$source_file" "$target_dir" 
