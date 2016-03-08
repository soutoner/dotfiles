#!/bin/bash
# Setting up Ubuntu Server 14.04
# 03-2016
# By Adrián & Nicolás

###### Funciones ######

#Borra una linea de un fichero que concuerde con una expresion regular usando sed
seddelete() { sed -i "/$1/d" $2; } # Uso: seddelete regexp file

#En un fichero, sustituye una cadena que concuerde con una expresion regular por otra cosa, usando sed
sedreplace() { sed -i "s/$1/$2/" $3; } # Uso: sedreplace regexp_needle replacement file

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$  ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

#######################

USAGE_TOOL="Usage: $0 <LOCAL_IP>"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1"  ]
  then echo "$USAGE_TOOL"
  exit
fi

if valid_ip $1;
    then echo "good";
else
    echo "Bad IP address"
    exit;
fi

#######################

# Add PHP 5.6 repository

apt-add-repository -y ppa:ondrej/php5-5.6

# Update & Upgrade

apt-get -y update && apt-get -y upgrade
apt-get install -y build-essential software-properties-common python-software-properties

## Perl locale warning fix

sudo locale-gen es_ES.UTF-8
sudo dpkg-reconfigure locales

# Install MySQL

## MySQL Server
# Credentials:
#   User: root
#   Password: <no password>
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server-5.6 mysql-client-5.6 php5-mysql

# Install Apache2

apt-get install -y apache2 libapache2-mod-php5

# Install PHP5.6

apt-get install -y php5 php5-cli php5-dev php-pear php5-mcrypt php5-curl php5-intl php5-gd php5-imagick php5-imap php5-mhash php5-xsl
php5enmod mcrypt intl curl

# XDebug

apt-get -y install php5-xdebug

read -r -d '' XDEBUG_CONF << ROTO
;zend_extension='xdebug.so'
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=$2
xdebug.remote_port=9000
xdebug.remote_log=/var/log/xdebug.log
xdebug.remote_autostart=1
ROTO

echo "$XDEBUG_CONF" > /etc/php5/apache2/conf.d/20-xdebug.ini

service apache2 restart

# Utilities

apt-get install -y curl htop git dos2unix unzip vim grc gcc make re2c libpcre3 libpcre3-dev lsb-core autoconf

# MySQL configuration
# Allow us to remote from Vagrant with port

cp /etc/mysql/my.cnf /etc/mysql/my.bkup.cnf
# Note: Since the MySQL bind-address has a tab character I comment out the end line
sed -i 's/bind-address/bind-address = 0.0.0.0#/' /etc/mysql/my.cnf


# Grant all privilege to root for remote access

mysql -u root -Bse "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;"
service mysql restart


# Composer for PHP

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Apache VHost
# Remember to change with your project name

cd ~
echo '<VirtualHost *:80>
        DocumentRoot /vagrant/projectname
        ErrorLog  /vagrant/projectname/log/projects-error.log
        CustomLog /vagrant/projectname/log/projects-access.log combined
</VirtualHost>
<Directory "/vagrant/projectname">
        Options Indexes Followsymlinks
        AllowOverride All
        Require all granted
</Directory>' > vagrant.conf

mv vagrant.conf /etc/apache2/sites-available
a2enmod rewrite

# Update PHP Error Reporting

sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/apache2/php.ini
sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/apache2/php.ini
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
#  Append session save location to /tmp to prevent errors in an odd situation..
sudo sed -i '/\[Session\]/a session.save_path = "/tmp"' /etc/php5/apache2/php.ini

# Reload apache

sudo a2ensite vagrant
sudo a2dissite 000-default
sudo service apache2 restart

# Setting aliases to avoid xdebug for composer

read -r -d '' ALIASES << ROTO
# Load xdebug Zend extension with php command
alias php='php -dzend_extension=xdebug.so'
# PHPUnit needs xdebug for coverage. In this case, just make an alias with php command prefix.
alias phpunit='php $(which phpunit)'
ROTO

echo "$ALIASES" >> ~/.bash_aliases

echo "alias sudo='sudo '" >> ~/.bashrc

# Cleanup

sudo apt-get autoremove -y

sudo usermod -a -G www-data vagrant
