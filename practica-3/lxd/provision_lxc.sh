#!/bin/bash

apt-get install lxd-installer -y
newgrp lxd
lxd init --auto
lxc launch ubuntu:22.04 website
sleep 10 # Mientras el contenedor obtiene una IP
lxc exec website -- apt-get update -y
lxc exec website -- apt-get install -y apache2
lxc exec website -- systemctl enable apache2
# lxc exec website -- bash -c "cat /vagrant/index.html > /var/www/html/index.html"
lxc file push /vagrant/index.html website/var/www/html/index.html
lxc exec website -- systemctl start apache2
lxc config device add website http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
