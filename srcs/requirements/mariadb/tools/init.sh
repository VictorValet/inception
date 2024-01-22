#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/.installed" ]
then
	echo "No previous installation of mariadb. Processing to installation..."
	service mariadb start
	sleep 10

	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "USE mysql;"
	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "FLUSH PRIVILEGES;"
	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';"
	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "CREATE DATABASE $MYSQL_DB CHARACTER SET utf8 COLLATE utf8_general_ci;"
	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "CREATE USER '$WP_ADMIN_USR'@'%' IDENTIFIED by '$WP_ADMIN_PWD';"
	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$WP_ADMIN_USR'@'%' IDENTIFIED by '$WP_ADMIN_PWD';"
	mariadb -hlocalhost -uroot -p$MYSQL_ROOT_PWD -e "FLUSH PRIVILEGES;"

	mysqladmin -hlocalhost -uroot -p$MYSQL_ROOT_PWD shutdown
	touch .installed
fi

sed -i "s|skip-networking|# skip-networking|g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

mysqld_safe --user=mysql
