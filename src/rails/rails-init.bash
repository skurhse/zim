#!/bin/bash
# initializes a fresh rails project

repo_NAME="tp-rails"

version_RUBY=2.6.2
version_RAILS=6.0.0.beta3

dir_TMP=/"tmp"/"dev-init-rails-bash"/
dir_SOURCE=~/"src"/

mkdir "$dir_TMP"
pushd "$dir_TMP"

unset GEM_PATH
unset GEM_HOME

# https://github.com/rbenv/rbenv
curl --fail --silent --show-error --location https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
export PATH="$HOME/.rbenv/bin:$PATH"

echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
eval "$(rbenv init -)"

rbenv install $version_RUBY
rbenv local $version_RUBY


# https://yarnpkg.com/
rm -rf ~/.yarn
curl -o- -L https://yarnpkg.com/install.sh | bash

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bash_profile


# https://rubyonrails.org/
# To-do: figure out why this doesn't work
# gem install rails:$version_RAILS
gem install rails --pre

rails new "$repo_NAME"


mkdir "$dir_SOURCE"
mv "$repo_NAME" "${dir_SOURCE}${repo_NAME}"
popd
rm -rf "$dir_TMP"
