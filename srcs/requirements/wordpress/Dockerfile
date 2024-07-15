FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-client \
	netcat \
	php \
	php-fpm \
	php-mysql \
	wget

RUN mkdir -p /var/www/html/wordpress

RUN adduser --system --no-create-home --group nginx
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN	wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& cp wp-cli.phar /usr/bin/wp

WORKDIR /var/www/html/wordpress

COPY tools/init.sh /tmp/init.sh
RUN chmod 755 /tmp/init.sh
ENTRYPOINT ["/tmp/init.sh"]
