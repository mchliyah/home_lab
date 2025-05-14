FROM nextcloud:latest

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    openssl \
    nano \
    libheif1 \
    cron \
    && apt-get clean \
    && chown -R www-data:www-data /var/www/html \
    && a2enmod ssl

# Configurer le cron
RUN echo "*/5 * * * * www-data php -f /var/www/html/cron.php" > /etc/cron.d/nextcloud \
    && chmod 0644 /etc/cron.d/nextcloud

# Copier les configurations
COPY src/conf/nextcloud-ssl.conf /etc/apache2/sites-available/
COPY src/tools/update-config.sh /update-config.sh
COPY src/tools/users.csv /users.csv

# Configurer Apache
RUN sed -i 's/Listen 80/# Listen 80/g' /etc/apache2/ports.conf \
    && echo "Listen 8443" >> /etc/apache2/ports.conf \
    && a2dissite 000-default.conf \
    && a2ensite nextcloud-ssl.conf

# Appliquer les permissions et exécuter le script de configuration
RUN chmod +x /update-config.sh
# RUN  /update-config.sh

# Corriger les warnings Apache
RUN grep -q "ServerName localhost" /etc/apache2/apache2.conf || echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 8443

CMD ["apache2-foreground"]
