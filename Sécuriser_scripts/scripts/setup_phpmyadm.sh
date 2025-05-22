#!/bin/bash
set -e

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | sudo debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
sudo apt install phpmyadmin -y

sudo tee /etc/nginx/snippets/phpmyadmin.conf > /dev/null <<EOF
location /phpmyadmin {
    root /usr/share/;
    index index.php;
    try_files \$uri \$uri/ =404;

    location ~ ^/phpmyadmin/(.+\.php)$ {
        root /usr/share/;
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')-fpm.sock;
    }

    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        root /usr/share/;
    }
}
EOF
