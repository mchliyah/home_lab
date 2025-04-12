FROM debian:buster

RUN apt-get update
RUN apt-get install -y nginx openssl

COPY requirements/nginx/default /etc/nginx/sites-available/default

EXPOSE 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
