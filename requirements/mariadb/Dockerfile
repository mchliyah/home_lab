FROM mariadb:10.6

COPY .env .env

# Copy Configuration Files
COPY src/conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy and Set Permissions for Init Script
COPY src/tools/init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

EXPOSE 3306

CMD ["mysqld"]