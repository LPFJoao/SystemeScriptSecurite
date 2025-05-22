#!/bin/bash
set -e

sudo apt install nginx -y

sudo mkdir -p /var/www/webapp
sudo chown -R www-data:www-data /var/www/webapp

echo "<?php phpinfo(); ?>" | sudo tee /var/www/webapp/index.php > /dev/null

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')

sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    server_name _;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl default_server;
    server_name _;

    root /var/www/webapp;
    index index.php index.html index.htm;

    include snippets/self-signed.conf;
    include snippets/ssl-params.conf;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

    include snippets/phpmyadmin.conf;
}
EOF
