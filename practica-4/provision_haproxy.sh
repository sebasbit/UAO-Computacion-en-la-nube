#!/bin/bash

apt-get update -y
apt-get update -y
apt-get install -y haproxy
systemctl enable haproxy
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bkp # Backup para pruebas
cat <<EOT >> /etc/haproxy/haproxy.cfg

# Configuración del Laboratorio
backend web-backend
    balance roundrobin
    stats enable
    stats auth admin:admin
    stats uri /haproxy?stats
    
    server web1 192.168.100.7:80 check
    server web2 192.168.100.8:80 check

frontend http
    bind *:80
    default_backend web-backend
EOT
systemctl restart haproxy
