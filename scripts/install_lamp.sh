#!/bin/bash

#Esto es un comentario 
#echo "Esto es un texto"
# Para mostrar los comandos que se van ejecutando
#set -x 
#Actualizamos la lista de repositorios
apt update

# Actualizamos los paquetes del sistema 
#apt upgrade -y

apt install apache2 -y

apt install php libapache2-mod-php php-mysql -y

apt install mysql-server

cp ../conf/000-default.conf /etc/apache2/sites-available

systemctl restart apache2

cp ../php/index.php /var/www/html

chown -R www-data:www-data /var/www/html

