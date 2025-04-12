<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'upgrade.disable-web' => true,
  'passwordsalt' => getenv('NEXTCLOUD_SALT') ?: 'default_salt',
  'secret' => getenv('NEXTCLOUD_SECRET') ?: 'default_secret',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => getenv('DOMAIN_NAME') ?: 'example.com',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '31.0.0.18',
  'overwrite.cli.url' => 'https://' . (getenv('DOMAIN_NAME') ?: 'localhost'),
  'dbname' => getenv('DB_NAME') ?: 'nextcloud_traccar_db',
  'dbhost' => 'mariadb',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => getenv('DB_USER') ?: 'admin',
  'dbpassword' => getenv('DB_PASS') ?: 'password1234',
  'installed' => true,
  'instanceid' => 'ocaus461m8wf',
);
