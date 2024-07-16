#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

if [ ! -f "/var/lib/mysql/.installed" ]
then
	echo "Processing to clean installation of MariaDB..."
	rm -Rf /var/lib/mysql/*
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
	
	mysqld_safe --datadir='/var/lib/mysql' & pid="$!"
	for i in {10..0}; do
        if mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "status" &> /dev/null;
		then
            break
        fi
        echo 'MariaDB init process in progress...'
        sleep 1
    done

	if [ "$i" = 0 ]; then
        echo >&2 'MariaDB init process failed.'
        exit 1
    fi

	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "USE mysql;"
	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "FLUSH PRIVILEGES;"
	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat $MYSQL_ROOT_PWD_FILE)';"
	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "CREATE DATABASE $MYSQL_DB CHARACTER SET utf8 COLLATE utf8_general_ci;"
	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "CREATE USER '$(cat WP_ADMIN_USR_FILE)'@'%' IDENTIFIED by '$(cat WP_ADMIN_PWD_FILE)';"
	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$(cat WP_ADMIN_USR_FILE)'@'%' IDENTIFIED by '$(cat $WP_ADMIN_USR_FILE)';"
	mariadb -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) -e "FLUSH PRIVILEGES;"

	mysqladmin -hlocalhost -uroot -p$(cat $MYSQL_ROOT_PWD_FILE) shutdown
	touch /var/lib/mysql/.installed

	wait "$pid"
fi

sed -i "s|skip-networking|# skip-networking|g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

exec mysqld_safe --user=mysql
