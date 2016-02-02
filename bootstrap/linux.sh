#!/bin/bash

####################################################
# Script that bootstraps a linux environment.
# All the tools marked with (opt) can be marked
# to install in the file "conf.yml". 
# Before executing this script please, take
# a look at it!
#
# Tested on:
#   - Ubuntu MATE 15.10
#
# Contents:
# 
#   . Utilities & tools
#       - Curl
#       - Composer
#       - KeepassX (opt)
#   · Development
#       - Oracle JVM
#       · Languages
#           - PHP 5
#           - Java 8
#       · VCS
#           - Git
#       · IDE
#           - Vim (w/ Vundle and 256-colors support)
#           - Gvim (opt)
#           - PHPStorm (opt)
#           - WebStorm (opt)
#   · Databases
#       - MySQL
#   · Application server
#       - Apache
#   · Notes
#       - Check available configs for
#           particular tools inside "conf.yml"
####################################################

# """"""""""""""""""""""""""""""""""
# Auxiliary functions
# """"""""""""""""""""""""""""""""""

## Function that parses the YAML conf file.
# Credits to: Stefan Farestam
# http://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

# Read configuration file. Third argument is a prefix for all the variables.
eval $(parse_yaml conf.yml)
# """"""""""""""""""""""""""""""""""
# Minimum libraries
# """"""""""""""""""""""""""""""""""

sudo apt-get -y install make build-essential

# """"""""""""""""""""""""""""""""""
# Utilities and tools
# """"""""""""""""""""""""""""""""""

# Git, vim and curl
sudo apt-get -y install git vim curl
# Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
# KeePassX
if [ -n "$utils_keepassx" ]; then
    sudo apt-get -y install keepassx
fi
if [ -n "$dev_gitconfig" ]; then
    git config --global user.email \"$dev_gitconfig_email\"
    git config --global user.name \"$dev_gitconfig_name\"
fi
# Configure git

# """"""""""""""""""""""""""""""""""
# Development
# """"""""""""""""""""""""""""""""""

## Oracle JVM and Java udo apt-get install oracle-java7-set-default
JAVA_PPA="webupd8team/java"
grep -q "$JAVA_PPA" /etc/apt/sources.list /etc/apt/sources.list.d/*
if [ $? -ne 0 ]; then
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
fi
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo update-java-alternatives -s java-8-oracle
sudo apt-get -y install oracle-java8-set-default

# """"""""""""""""""""""""""""""""""
# Languages
# """"""""""""""""""""""""""""""""""

## PHP
sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

# """"""""""""""""""""""""""""""""""
# IDE
# """"""""""""""""""""""""""""""""""

# Setting 256 colors in terminal
TERM_COLORS=$(cat <<EOF
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
EOF
)
cat ~/.profile | grep -q "xterm-256color"
if [ $? -ne 0 ]; then
    echo "$TERM_COLORS" >> ~/.profile
fi
# Setting custom .vimrc
if [ -n "$dev_vimrc" ]; then
    curl -s -o ~/.vimrc "$dev_vimrc"
fi
# Vundle
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone -q https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
# Executing :PluginInstall
vim -c ':PluginInstall' -c 'qa!' # Quit vim

## Gvim 
if [ -n "$dev_gvim" ]; then
    sudo apt-get -y install vim-gnome
fi

## PHPStorm
if [ -n "$dev_phpstorm" ]; then
    PHPSTORM="PhpStorm-$dev_phpstorm_version";
    wget -P /tmp/ https://download.jetbrains.com/webide/$PHPSTORM.tar.gz
    if [ ! -f /tmp/$PHPSTORM.tar.gz ]; then
        echo "Ups! Something went wrong while downloading $PHPSTORM."
        exit 1
    fi
    sudo tar -zxf /tmp/$PHPSTORM.tar.gz -C /opt/
fi

## PHPStorm
if [ -n "$dev_webstorm" ]; then
    WEBSTORM="WebStorm-$dev_webstorm_version";
    wget -P /tmp/ https://download.jetbrains.com/webstorm/$WEBSTORM.tar.gz
    if [ ! -f /tmp/$WEBSTORM.tar.gz ]; then
        echo "Ups! Something went wrong while downloading $WEBSTORM."
        exit 1
    fi
    sudo tar -zxf /tmp/$WEBSTORM.tar.gz -C /opt/
fi

# """"""""""""""""""""""""""""""""""
# Databases
# """"""""""""""""""""""""""""""""""

## MySQL Server
#   Credentials:
#       - User: root
#       - Password: root
#   If you want a different password, change next two lines.
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_mysql_password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_mysql_password"
sudo apt-get -y install mysql-server php5-mysql

# """"""""""""""""""""""""""""""""""
# Application server
# """"""""""""""""""""""""""""""""""

## Apache
sudo apt-get -y install apache2

# """"""""""""""""""""""""""""""""""
# Recommendations
# """"""""""""""""""""""""""""""""""

echo
echo "------------------ RECOMMENDATIONS"
echo "The script has been successfully executed."
echo "Here are some recommendations:"
## Secure MySQL
echo " - Run 'sudo /usr/bin/mysql_secure_installation' to secure your MySQL installation."
## *Storm IDEs
echo " - For the first time, *Storm IDEs shpuld be accessed by '/opt/*Storm-{VERSION}/bin/*storm.sh'"
