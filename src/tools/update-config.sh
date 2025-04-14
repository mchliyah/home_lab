#!/bin/bash

# Variables and command paths
CONFIG_DIR="/var/www/html/config"
OCC_CMD="/var/www/html/occ"
PHP_CMD="/usr/local/bin/php"
MARKER_FILE="/var/www/html/.config_done"

echo "Starting Nextcloud configuration script..."

# Check if the configuration has already been applied
if [ ! -f "$MARKER_FILE" ]; then
    echo "Applying initial Nextcloud configuration..."

    # Run occ commands as www-data
    run_occ_once() {
        su www-data -s /bin/bash -c "$PHP_CMD $OCC_CMD $*"
    }

    # Configure trusted domain, Redis, maintenance window and repair
    run_occ_once "config:system:set" "trusted_domains" "1" "--value=$DOMAIN_NAME"
    run_occ_once "config:system:set" "memcache.local" "--value" "\OC\Memcache\Redis"
    run_occ_once "config:system:set" "redis" "host" "--value" "$REDIS_HOST"
    run_occ_once "config:system:set" "redis" "port" "--value" "$REDIS_HOST_PORT" "--type" "integer"
    run_occ_once "config:system:set" "maintenance_window_start" "--value" "1" "--type" "integer"
    run_occ_once "maintenance:repair" "--include-expensive"

    # Create marker file to avoid re-running these commands in subsequent startups
    touch "$MARKER_FILE"
    echo "Initial configuration applied."
else
    echo "Configuration already applied. Skipping."
fi

# Add ServerName directive to fix Apache warnings if not already present
if ! grep -q "ServerName localhost" /etc/apache2/apache2.conf; then
    echo "Adding 'ServerName localhost' to Apache configuration."
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
    apachectl graceful || true
fi

echo "Nextcloud configuration script completed successfully."

