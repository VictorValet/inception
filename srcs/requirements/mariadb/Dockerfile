FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-client \
	mariadb-server

RUN mkdir -p /var/lib/mysql

COPY ./tools/init.sh /tmp/init.sh
RUN chmod 755 /tmp/init.sh

ENTRYPOINT ["/tmp/init.sh"]
