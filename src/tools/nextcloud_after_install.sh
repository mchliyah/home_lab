
./occ config:system:set maintenance_window_start --type=integer --value=1
./occ maintenance:repair --include-expensive


# we add this after install for the https security 

    Header onsuccess unset X-Robots-Tag
    Header always set X-Robots-Tag "noindex, nofollow"

    Header onsuccess unset X-XSS-Protection
    Header always set X-XSS-Protection "1; mode=block"

    Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"

    SetEnv modHeadersAvailable true
  </IfModule>

