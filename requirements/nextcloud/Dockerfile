FROM nextcloud:latest

# Update and install the HEIC needed packages
RUN apt-get update && apt-get install -y \
    openssl \
    nano \
    libheif1 \
    && a2enmod ssl

# Copy the custom Apache SSL configuration file
COPY src/conf/nextcloud-ssl.conf /etc/apache2/sites-available/nextcloud-ssl.conf
COPY src/tools/update-config.sh /update-config.sh

# 🔥 Critical Changes Start Here:
# 1. Completely disable port 80 by commenting it out
# 2. Only enable port 8443
RUN sed -i 's/Listen 80/# Listen 80/g' /etc/apache2/ports.conf && \
    echo "Listen 8443" >> /etc/apache2/ports.conf && \
    a2dissite 000-default.conf && \
    a2ensite nextcloud-ssl.conf

RUN chmod +x /update-config.sh

# Expose port 8443 (the internal HTTPS port for Nextcloud)
EXPOSE 8443

ENTRYPOINT [ "/update-config.sh" ]