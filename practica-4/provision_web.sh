#!/bin/bash

apt-get update -y
apt-get upgrade -y
apt-get install -y apache2
systemctl enable apache2
echo "<h1>Bienvenido al $(hostname)</h1><p>Esta respuesta viene del servidor: $(hostname -I | awk '{print $2}')</p>" > /var/www/html/index.html
systemctl start apache2
