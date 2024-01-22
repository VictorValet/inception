FROM debian:bullseye

RUN apt-get update; apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl /run/nginx
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=vvalet/CN=vvalet/UID=vvalet"
RUN chmod 644 /etc/nginx/ssl/*

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
