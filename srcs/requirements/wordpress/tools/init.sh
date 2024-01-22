#!/bin/bash

echo "Waiting for MariaDB service to start..."
until nc -z -w 2 mariadb 3306; do
    sleep 1
done
echo "Starting Wordpress..."

if [ ! -f "/var/www/html/wordpress/.installed" ]; then

	echo "No previous installation of wordpress. Processing to installation..."
	wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	cp wp-cli.phar /usr/bin/wp
	#check first if they exists
	# echo "Removing old users..."
	# wp user list --field=ID --format=csv --allow-root | xargs -I {} wp user delete {} --reassign=1 --allow-root --yes
	rm -rf /var/www/html/wordpress/*

	wp core download --allow-root
	wp config create --dbname=$MYSQL_DB --dbuser=$WP_ADMIN_USR --dbpass=$WP_ADMIN_PWD --dbhost=mariadb --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PWD --allow-root
	wp plugin update --all --allow-root

	touch .installed
fi

#???
mkdir -p /run/php/

/usr/sbin/php-fpm7.4 -F
