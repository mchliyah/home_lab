#!/bin/bash
set -e

CONFIG_DIR="/var/www/html/config"
CONFIG_FILE="$CONFIG_DIR/config.php"

echo "Starting Nextcloud setup..."

# Run the Nextcloud entrypoint to initialize config.php
/entrypoint.sh apache2-foreground &
ENTRYPOINT_PID=$!

echo "Waiting for config.php to be created..."
while [ ! -f "$CONFIG_FILE" ]; do
    sleep 2
done

echo "Config.php found! Updating trusted domains..."

# Fix the 'trusted_domains' typo if it exists
sed -i "s/'trusted_domains'/'trusted_domains'/" "$CONFIG_FILE"

# Add DOMAIN_NAME to 'trusted_domains' if not already present
if ! grep -q "'$DOMAIN_NAME'" "$CONFIG_FILE"; then
    awk -v domain="$DOMAIN_NAME" '
        /trusted_domains/ {inside=1} 
        inside && /\)/ {print "    1 => '\''" domain "'\'',"; inside=0} 
        {print}
    ' "$CONFIG_FILE" > /tmp/config.php && mv /tmp/config.php "$CONFIG_FILE"
fi

# chown -R root:root /var/www/html/config
# chown -R root:root /var/www/html/occ


# /var/www/html/occ config:system:set maintenance_window_start --type=integer --value=1
# /var/www/html/occ maintenance:repair --include-expensive

echo "Configuration update complete. Restarting Nextcloud..."

# # Restart Nextcloud to apply changes
kill $ENTRYPOINT_PID
exec /entrypoint.sh apache2-foreground