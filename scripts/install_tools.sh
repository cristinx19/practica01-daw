#!/bin/bash

#Esto es un comentario 
#echo "Esto es un texto"
# Para mostrar los comandos que se van ejecutando
set -x 

source .env

# exit

#Actualizamos la lista de repositorios
apt update

# Actualizamos los paquetes del sistema 
# apt upgrade -y

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections

sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl


#DROP USER IF EXISTS 'nombre_usuario'@'localhost';

#CREATE USER 'nombre_usuario'@'localhost' IDENTIFIED BY 'contraseña';

#GRANT ALL PRIVILEGES ON *.* TO 'nombre_usuario'@'localhost';

# Ejecutamos las sentencias SQL
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%'"

mkdir -p /var/www/html/adminer

wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

chown -R www-data:www-data /var/www/html

apt install goaccess -y

# vamos a crear un directorio para meter las estadisticas

mkdir -p /var/www/html/stats

# uwu

goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

htpasswd -bc /etc/apache2/.htpasswd $STATS_USERNAME $STATS_PASSWORD

# cp ../conf/000-default-stats.conf /etc/apache2/sites-available/000-default.conf

cp ../conf/000-default-htaccess.conf /etc/apache2/sites-available/000-default.conf

cp ../htaccess/.htaccess /var/www/html/stats 

systemctl restart apache2

