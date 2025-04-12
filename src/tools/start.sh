#!/bin/sh

# Set ownership for WordPress files
chown -R www-data:www-data /var/www/html

# Install WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && apt clean && rm -rf /var/lib/apt/lists/*

mv wp-cli.phar /usr/local/bin/wp
chmod +x /usr/local/bin/wp

# Download WordPress core
wp core download --allow-root

# Create WordPress configuration file
wp config create --dbname=$DB_NAME \
    --dbuser=$DB_USER --dbpass=$DB_PASS \
    --dbhost=$DB_HOST --allow-root

# Add WP_HOME and WP_SITEURL to wp-config.php
sed -i "/define('WP_DEBUG', false);/a\
define('WP_HOME', 'https://134.209.242.96/');\n\
define('WP_SITEURL', 'https://134.209.242.96/');" /var/www/html/wp-config.php

# Install WordPress
wp core install --url=$DOMAIN_NAME \
    --title=$SITE_TITLE \
    --admin_user=$ADMIN_USER \
    --admin_password=$ADMIN_PASS \
    --admin_email=$ADMIN_EMAIL \
    --allow-root

# Update plugins
wp plugin update --all --allow-root

# Install and activate a theme
wp theme install twentytwentytwo --activate --allow-root

# Modify PHP-FPM configuration
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Create PHP runtime directory
mkdir /run/php

# Execute the command passed to the container
exec "$@"