FROM debian:bullseye

RUN apt-get update; apt-get install -y mariadb-server mariadb-client

RUN mkdir -p /var/lib/mysql

COPY ./tools/init.sh /tmp/init.sh

ENTRYPOINT ["bash", "/tmp/init.sh"]
