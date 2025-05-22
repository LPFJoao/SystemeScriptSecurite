#!/bin/bash

echo "Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y

echo "Installation de Nginx..."
sudo apt install nginx -y

echo "Installation de PHP et extensions..."
sudo apt install php-fpm php-mysql php-cli php-zip php-curl php-mbstring php-xml -y

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')

echo "Installation de MariaDB..."
sudo apt install mariadb-server -y

echo "Configuration automatique de la base de données..."
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Préconfiguration de phpMyAdmin (sans Apache ni Lighttpd)..."
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | sudo debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
sudo apt install phpmyadmin -y

echo "Configuration de phpMyAdmin pour Nginx..."
sudo tee /etc/nginx/snippets/phpmyadmin.conf > /dev/null <<EOF
location /phpmyadmin {
    root /usr/share/;
    index index.php;
    try_files \$uri \$uri/ =404;

    location ~ ^/phpmyadmin/(.+\.php)$ {
        root /usr/share/;
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }

    location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        root /usr/share/;
    }
}
EOF

sudo sed -i '/server_name _;/a \    include snippets/phpmyadmin.conf;' /etc/nginx/sites-available/default

echo "Création du dossier /var/www/webapp..."
sudo mkdir -p /var/www/webapp
sudo chown -R www-data:www-data /var/www/webapp

echo "<?php phpinfo(); ?>" | sudo tee /var/www/webapp/index.php > /dev/null

sudo sed -i 's|root /var/www/html;|root /var/www/webapp;|' /etc/nginx/sites-available/default
sudo sed -i 's|index nginx-debian.html;|index index.php index.html index.htm;|' /etc/nginx/sites-available/default

echo "Redémarrage de Nginx et PHP-FPM..."
sudo systemctl restart nginx
sudo systemctl restart php${PHP_VERSION}-fpm

echo "Installation de Node.js et npm..."
sudo apt install nodejs npm -y

echo "Installation de Git..."
sudo apt install git -y

echo "Création d'un utilisateur 'dev' pour MariaDB..."
sudo mysql -e "CREATE USER 'dev'@'localhost' IDENTIFIED BY 'devpass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Installation terminée. Vous pouvez accéder à :"
echo " - http://localhost/phpmyadmin"
echo " - http://localhost/ (fichier index.php dans /webapp)"

