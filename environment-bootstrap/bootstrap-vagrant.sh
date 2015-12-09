a#!/bin/bash

set -e

#Script to bootstrap an App Engine development environment.
sudo yum -y update





echo 'Installing npm and nodejs packages with yum and epel repository'
sudo yum -y install nodejs npm --enablerepo=epel

echo 'Installing bower with npm'
sudo npm -y install bower --global

wget ftp://ftp.pbone.net/mirror/ftp.centos.org/7.1.1503/cloud/x86_64/openstack-liberty/common/libunwind-1.1-3.el7.x86_64.rpm
rpm -i libunwind-1.1-3.el7.x86_64.rpm
echo 'Installing other necessary packages for skyhopper'
sudo yum -y install sqlite-devel zlib-devel readline-devel openssl-devel libxml2-devel libxslt-devel mysql-devel nginx
sudo yum -y --enablerepo=epel install redis


wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum -y update
sudo yum -y install mysql-server

echo 'remove ruby20 with yum'

sudo yum -y remove ruby ruby20
echo 'remove ruby20 with yum'
# 1. Install the Software Collections tools:
sudo yum -y install scl-utils

# 2. Download a package with repository for your system.
#  (See the Yum Repositories section below. You can use `wget URL`.)
wget https://www.softwarecollections.org/en/scls/rhscl/rh-ruby22/epel-7-x86_64/download/rhscl-rh-ruby22-epel-7-x86_64.noarch.rpm

# 3. Install the repo package:
echo 'sudo yum -y install rhscl-rh-ruby22-*.noarch.rpm'
sudo yum -y install rhscl-rh-ruby22-*.noarch.rpm

# 4. Install the collection:
sudo yum -y install rh-ruby22

# 5. Start using software collections:
# scl enable rh-ruby22 bash

sudo echo 'Development Environment Bootstrap Script'
sudo yum -y groups install "Development Tools" "Development Libraries"
sudo yum --enablerepo=epel -y install gdbm-devel libdb4-devel libffi-devel libyaml libyaml-devel ncurses-devel openssl-devel readline-devel tcl-devel


# echo 'Installing bunder packages with gem'
# gem install bundler

echo 'setting up reverse proxy for nginx'
sudo tee /etc/nginx/conf.d/skyhopper.conf <<EOF >/dev/null
server {
        listen 80;
        server_name skyhopper.local; #環境に合わせて設定

        location / {
            proxy_set_header    X-Real-IP   \$remote_addr;
            proxy_set_header    Host    \$http_host;
            proxy_pass  http://127.0.0.1:3000;
        }

        location /ws {
            proxy_http_version 1.1;
            proxy_set_header    Upgrade \$http_upgrade;
            proxy_set_header    Connection "upgrade";
            proxy_set_header    Host    \$http_host;
            proxy_pass http://127.0.0.1:3210;
        }
}
EOF

echo 'Starting services'
sudo systemctl enable redis
sudo systemctl start redis
sudo systemctl enable mysqld
sudo systemctl start mysqld
sudo systemctl enable nginx
sudo systemctl start nginx

# Link workspace
ln -s /vagrant /home/vagrant/workspace

echo 'Cleaning up....'
rm libunwind-1.1-3.el7.x86_64.rpm
rm mysql-community-release-el7-5.noarch.rpm
rm rhscl-rh-ruby22-epel-7-x86_64.noarch.rpm
