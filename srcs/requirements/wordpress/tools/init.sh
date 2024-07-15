#!/bin/bash

echo "Waiting for MariaDB service to start..."
until nc -z -w 2 mariadb 3306; do
    sleep 1
done

if [ ! -f "/var/www/html/wordpress/.installed" ]; then

	echo "No previous installation of wordpress. Processing to installation..."
	rm -rf /var/www/html/wordpress/*

	wp core download --allow-root
	wp config create --dbname="$MYSQL_DB" --dbuser="$WP_ADMIN_USR" --dbpass="$WP_ADMIN_PWD" --dbhost=mariadb --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email --allow-root
	wp user create "$WP_USER" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PWD" --allow-root
	wp plugin update --all --allow-root

	touch /var/www/html/wordpress/.installed
fi

mkdir -p /run/php/

echo "Wordpress started!"
exec /usr/sbin/php-fpm7.4 -F
