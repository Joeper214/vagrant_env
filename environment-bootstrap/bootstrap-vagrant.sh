#!/bin/bash

set -e

#Script to bootstrap an App Engine development environment.

sudo echo 'Development Environment Bootstrap Script'

echo 'remove ruby20 with yum'

sudo yum remove ruby ruby20

echo 'installing ruby22 with yum'

sudo yum install ruby22

echo 'Installing bunder packages with gem'
sudo gem install bundler

echo 'Installing npm and nodejs packages with yum and epel repository'
sudo yum install nodejs npm --enablerepo=epel

echo 'Installing npm and nodejs packages with yum and epel repository'
sudo npm install bower --global

echo 'Installing other necessary packages for skyhopper'
sudo yum groupinstall 'Development tools' 'Development Libraries'
sudo yum install ruby22-devel sqlite-devel zlib-devel readline-devel openssl-devel libxml2-devel libxslt-devel mysql-devel mysql-server nginx
sudo yum --enablerepo=epel install redis

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
sudo chkconfig redis on
sudo service redis start
sudo chkconfig mysqld on
sudo service mysqld start
sudo chkconfig nginx on
sudo service nginx start

echo 'Cloning into skyhopper'
cd ~
git clone https://github.com/skyarch-networks/skyhopper.git

# Link workspace
ln -s /vagrant /home/vagrant/workspace
