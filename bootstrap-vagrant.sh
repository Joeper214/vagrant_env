#!/bin/bash

set -e

#Script to bootstrap an App Engine development environment.
sudo yum -y update

echo 'remove old ruby version'
sudo yum -y remove ruby ruby20
echo 'Install ruby version 22'
sudo yum -y install ruby22

echo 'Installing Bundler using gem'
sudo gem install bundler

echo 'Installing npm and nodejs packages with yum and epel repository'
sudo yum -y install nodejs npm --enablerepo=epel
sudo npm -y update -g npm

echo 'Installing bower with npm'
sudo npm -y install bower --global

echo 'Installing other packages that are needed for SkyHopper using yum'
sudo yum -y groupinstall 'Development tools' 'Development Libraries'
sudo yum -y install ruby22-devel sqlite-devel zlib-devel readline-devel openssl-devel libxml2-devel libxslt-devel mysql-devel mysql-server nginx
sudo yum -y --enablerepo=epel install redis


echo 'nginx Proxy Settings'
sudo tee /etc/nginx/nginx.conf <<EOF >/dev/null
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
}
EOF
echo 'Setting reverse proxy'
sudo tee /etc/nginx/conf.d/skyhopper.conf <<EOF >/dev/null
server {
        listen 80;
        server_name skyhopper.local; #Setting the environment

        ### production only from here ###
        location ~ ^/(assets|fonts) {
          root /home/ec2-user/skyhopper/public; # your skyhopper installation is located
        }
        ### production only to here ###

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

echo 'Starting of Services'
sudo chkconfig redis on
sudo service redis start

sudo chkconfig mysqld on
sudo service mysqld start

sudo chkconfig nginx on
sudo service nginx start

echo 'Downloading/Cloning SkyHopper from GitHub'
cd /app
git clone https://github.com/skyarch-networks/skyhopper.git
echo 'Change ower to ec2-user'
sudo chown -R ec2-user.ec2-user skyhopper

echo "Done"
