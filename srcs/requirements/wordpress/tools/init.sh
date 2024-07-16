#!/bin/bash

echo "Waiting for MariaDB service to start..."
until nc -z -w 2 mariadb 3306; do
    sleep 1
done

if [ ! -f "/var/www/html/wordpress/.installed" ]; then

	echo "Processing to clean installation of Wordpress..."
	rm -rf /var/www/html/wordpress/*

	wp core download --allow-root
	wp config create --dbname="$MYSQL_DB" --dbuser="$(cat $WP_ADMIN_USR_FILE)" --dbpass="$(cat $WP_ADMIN_PWD_FILE)" --dbhost=mariadb --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$(cat $WP_ADMIN_USR_FILE)" --admin_password="$(cat $WP_ADMIN_PWD_FILE)" --admin_email="$(cat $WP_ADMIN_EMAIL_FILE)" --skip-email --allow-root
	wp user create "$(cat $WP_USER_USR_FILE)" "$(cat $WP_USER_EMAIL_FILE)" --role=author --user_pass="$(cat $WP_USER_PWD_FILE)" --allow-root
	wp plugin update --all --allow-root

	touch /var/www/html/wordpress/.installed
fi

mkdir -p /run/php/

echo "Wordpress started!"
exec /usr/sbin/php-fpm7.4 -F
