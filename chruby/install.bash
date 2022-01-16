#!/usr/bin/env bash
# REQ: <>
# SEE: https://github.com/postmodern/chruby#install <skr 2022>
# ..............................................................................
set +B -Cefuvxo pipefail

version=0.3.9

arch_file=v$version.tar.gz
arch_url=https://github.com/postmodern/chruby/archive/$arch_file
arch_dir=chruby-$version/

key_file=chruby-$version.tar.gz.asc
key_url=https://raw.github.com/postmodern/chruby/master/pkg/$key_file

# NOTE: timestamp-checking is not supported in combination with -O. <>
cd /tmp
wget --timestamping $arch_url
tar --extract --gunzip --file $arch_file

wget --timestamping $key_url
gpg --verify $key_file $arch_file

cd $arch_dir
sudo make install

set +u
source /usr/local/share/chruby/chruby.sh
chruby --version
