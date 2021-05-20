#!/bin/bash
# Generates favicons from an SVG source

run_pth=$PWD
svg_pth=$(realpath $1)
out_dir=$(realpath $2)

ico_resolutions=(16 24 32 48 64)
ico_pngs=()

pushd /tmp && mkdir tp-bash-favicons || exit
pushd tp-bash-favicons

mkdir png
for i in ${ico_resolutions[@]}
do
  inkscape --without-gui --export-png="png/$i.png" --export-width="$i" --export-height="$i" "${svg_pth}"
  ico_pngs+=(png/$i.png) 
done
inkscape --without-gui --export-png="png/152.png" --export-width="152" --export-height="152" "${svg_pth}"

mkdir favicons
convert ${ico_pngs[@]} favicons/favicon.ico
cp png/152.png favicons/favicon-152.png

cp -an favicons/. "$out_dir"

popd && rm -rf tp-bash-favicons
popd
