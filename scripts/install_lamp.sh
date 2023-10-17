#!/bin/bash

#Esto es un comentario 
#echo "Esto es un texto"
# Para mostrar los comandos que se van ejecutando
#set -x 
#Actualizamos la lista de repositorios
apt update

# Actualizamos los paquetes del sistema 
#apt upgrade -y

# instalamos el apache 
apt install apache2 -y

# instalamos php
apt install php libapache2-mod-php php-mysql -y

apt install mysql-server

# copiamos el archivo de configuración de apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# reinacioamos el el servicio de apache
systemctl restart apache2


# copiamos el archivo de pruba de php 
cp ../php/index.php /var/www/html

# cambiamos el usaurio y el prpopietario de la directorio de /var/www/html
chown -R www-data:www-data /var/www/html

