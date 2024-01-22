FROM debian:bullseye

RUN apt-get update; apt-get install -y	wget\
										netcat\
										mariadb-client\
										php\
										php-fpm\
										php-mysql

RUN mkdir -p /var/www/html/wordpress

RUN adduser --system --no-create-home --group nginx
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html/wordpress

COPY tools/init.sh /tmp/init.sh
RUN chmod 755 /tmp/init.sh
ENTRYPOINT ["bash", "/tmp/init.sh"]
