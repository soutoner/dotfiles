#!/usr/bin/env bash

## Build packages and requirements
sudo apt-get -y install make build-essential libssl-dev libreadline-dev zlib1g-dev

## Git and NodeJS
sudo apt-get -y install git nodejs

## Perl locale warning fix
sudo locale-gen es_ES.UTF-8
sudo dpkg-reconfigure locales

## MySQL Server
# Credentials:
#   User: root
#   Password: root
# If you want a different password, change next two lines.
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server

## Rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
# Ruby-build (rbenv install)
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bashrc

## Install Ruby 2.2.3
sudo -H -u vagrant bash -i -c 'rbenv install 2.2.3'
# Set as global version
sudo -H -u vagrant bash -i -c 'rbenv global 2.2.3'

# Gems: bundler and rails
sudo -H -u vagrant bash -i -c 'gem install bundler --no-ri --no-rdoc'
sudo -H -u vagrant bash -i -c 'gem install rails'
sudo -H -u vagrant bash -i -c 'rbenv rehash'
