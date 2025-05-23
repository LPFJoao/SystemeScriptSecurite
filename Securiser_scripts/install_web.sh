#!/bin/bash
set -e

./scripts/setup_php.sh
./scripts/setup_user.sh
./scripts/setup_phpmyadmin.sh
./scripts/setup_nginx.sh
./scripts/setup_ssl.sh

sudo systemctl reload nginx

echo "Installation terminée. Accédez à https://localhost/"

echo "Identifiants MariaDB : dev / devpass"
