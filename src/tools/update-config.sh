#!/bin/bash

# Variables and command paths
CONFIG_DIR="/var/www/html/config"
OCC_CMD="/var/www/html/occ"
PHP_CMD="/usr/local/bin/php"
MARKER_FILE="/var/www/html/.config_done"

echo "Starting Nextcloud configuration script..."

# Check if the configuration has already been applied
echo "Applying initial Nextcloud configuration..."
# Run occ commands as www-data
run_occ_once() {
    su www-data -s /bin/bash -c "$PHP_CMD $OCC_CMD $*"
}
# Configure trusted domain, Redis, maintenance window and repair
run_occ_once config:system:set trusted_domains 1 --value="$DOMAIN_NAME"
run_occ_once config:system:set memcache.local --value="\OC\Memcache\Redis"
run_occ_once config:system:set redis host --value="$REDIS_HOST"
run_occ_once config:system:set redis port --value="$REDIS_HOST_PORT" --type=integer
run_occ_once config:system:set maintenance_window_start --value=1 --type=integer

# Phone region configuration
run_occ_once config:system:set default_phone_region --value="$DEFAULT_PHONE_REGION"

# Email server configuration
run_occ_once config:system:set mail_smtpmode --value=smtp
run_occ_once config:system:set mail_smtpauthtype --value=LOGIN
run_occ_once config:system:set mail_smtpsecure --value=ssl
run_occ_once config:system:set mail_smtpauth --value=true --type=boolean
run_occ_once config:system:set mail_smtphost --value="$EMAIL_SMTP_HOST"
run_occ_once config:system:set mail_smtpport --value="$EMAIL_SMTP_PORT" --type=integer
run_occ_once config:system:set mail_smtpname --value="$EMAIL_SMTP_USER"
run_occ_once config:system:set mail_smtppassword --value="$EMAIL_SMTP_PASSWORD"
run_occ_once config:system:set mail_from_address --value="$(echo $EMAIL_SMTP_USER | cut -d@ -f1)"
run_occ_once config:system:set mail_domain --value="$(echo $EMAIL_SMTP_USER | cut -d@ -f2)"

# Language configuration
run_occ_once config:system:set default_language --value="$DEFAULT_LANG"
run_occ_once config:system:set default_locale --value="$DEFAULT_LANG"
run_occ_once config:system:set force_language --value="$DEFAULT_LANG"

# Security enhancements
run_occ_once config:system:set hsts --value=true --type=boolean
run_occ_once config:system:set csp.allowedFrameAncestors --value="'self'"

# System maintenance
run_occ_once maintenance:repair --include-expensive
run_occ_once db:add-missing-indices
run_occ_once app:enable twofactor_totp
echo "Initial configuration applied."

# Add ServerName directive to fix Apache warnings
if ! grep -q "ServerName localhost" /etc/apache2/apache2.conf; then
    echo "Adding 'ServerName localhost' to Apache configuration."
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
    apachectl graceful || true
fi

echo "Nextcloud configuration script completed successfully."