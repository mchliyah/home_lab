FROM debian:buster

RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org/|g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y nginx openssl

COPY requirements/nginx/default /etc/nginx/sites-available/default

EXPOSE 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
