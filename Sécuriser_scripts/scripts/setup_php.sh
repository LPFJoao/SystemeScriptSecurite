#!/bin/bash
set -e

sudo apt update && sudo apt upgrade -y
sudo apt install php-fpm php-mysql php-cli php-zip php-curl php-mbstring php-xml -y
sudo apt install nodejs npm git -y
