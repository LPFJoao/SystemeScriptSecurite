#!/bin/bash
set -e
sudo mkdir -p /etc/nginx/snippets

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/webapp-selfsigned.key \
-out /etc/ssl/certs/webapp-selfsigned.crt \
-subj "/C=FR/ST=Region/L=Localhost/O=Dev/CN=localhost"

sudo tee /etc/nginx/snippets/self-signed.conf > /dev/null <<EOF
ssl_certificate /etc/ssl/certs/webapp-selfsigned.crt;
ssl_certificate_key /etc/ssl/private/webapp-selfsigned.key;
EOF

sudo tee /etc/nginx/snippets/ssl-params.conf > /dev/null <<EOF
ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers HIGH:!aNULL:!MD5;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
EOF

