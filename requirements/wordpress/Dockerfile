FROM debian:buster

#Install necessary package from php

RUN apt update -y \
    && apt install curl php php-mysql php-fpm mariadb-client -y
	
RUN apt-get -y install \
wget \
php \
php-cgi \
php-mysql \
php-fpm \
php-pdo \
php-gd php-cli \
php-mbstring \
&& rm -rf /var/lib/apt/lists/*

#Create the folder to enable php start
RUN mkdir -p /run/php
COPY src/conf/www.conf /etc/php/7.3/fpm/pool.d



#Launch script
WORKDIR /var/www/html

COPY src/tools/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh
EXPOSE 9000

ENTRYPOINT ["start.sh"]

CMD ["php-fpm7.3", "-F"]