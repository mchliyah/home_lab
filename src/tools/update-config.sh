#!/bin/bash

# Variables and command paths
CONFIG_DIR="/var/www/html/config"
OCC_CMD="/var/www/html/occ"
PHP_CMD="/usr/local/bin/php"
USER_LIST="/users.csv"

echo "Starting Nextcloud configuration script..."

# Check if the configuration has already been applied
echo "Applying initial Nextcloud configuration..."

# Run occ commands as www-data
run_occ_once() {
    su www-data -s /bin/bash -c "$PHP_CMD $OCC_CMD $*"
}

# Configure trusted domain, Redis, maintenance window, and repair
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

# Applying trusted_proxies ip range
echo "Applying trusted_proxies ip range..."
run_occ_once config:system:set trusted_proxies 1 --value="172.17.0.1/16"

# Enforce group-based sharing and visibility
echo "Applying group-based sharing restrictions..."
run_occ_once config:app:set core shareapi_only_share_with_group_members --value=true
run_occ_once config:app:set core shareapi_allow_resharing --value=false
run_occ_once config:app:set core shareapi_allow_links --value=false
run_occ_once config:system:set disable_user_list --value=true --type=boolean

# Automated user creation from CSV
# if [[ -f "$USER_LIST" ]]; then
#   echo "Creating users from $USER_LIST..."
#   while IFS=',' read -r username password email displayname group; do
#     # Skip header or empty lines
#     [[ "$username" == "username" || -z "$username" ]] && continue

#     # Skip admin if included by mistake
#     if [[ "$username" == "$NEXTCLOUD_ADMIN_USER" ]]; then
#       echo "Skipping admin user $username"
#       continue
#     fi

#     echo "Creating user: $username"

#     # Check if group exists and create if not
#     if [[ -n "$group" && $(run_occ_once group:info "$group" &>/dev/null; echo $?) -ne 0 ]]; then
#       echo "Creating group $group"
#       run_occ_once group:add "$group"
#     fi

#     # Create user if not exists
#     if ! run_occ_once user:info "$username" &>/dev/null; then
#       export OC_PASS="$password" # Password from CSV
#       run_occ_once user:add --display-name "$displayname" --email "$email" --password-from-env "$username"
#       unset OC_PASS
#     else
#       echo "User $username already exists. Skipping creation."
#     fi

#     # Add to group
#     if [[ -n "$group" ]]; then
#       run_occ_once group:adduser "$group" "$username"
#     fi
#   done < <(tail -n +2 "$USER_LIST")  # Skip CSV header
# else
#   echo "User list file $USER_LIST not found. Skipping user creation."
# fi

# Configure TURN and STUN Servers
run_occ_once config:system:set turns --value="turn:coturn:3478"
run_occ_once config:system:set stun --value="stun:coturn:3478"

echo "Nextcloud configuration script completed successfully."
