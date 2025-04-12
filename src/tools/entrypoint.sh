#!/bin/bash
# First-time setup (only runs once)
if [ ! -f /var/traccar_installed ]; then
    # Run installer
    ./traccar.run
    
    # Enable service for future starts
    systemctl enable traccar
    
    # Create marker file
    touch /var/traccar_installed
fi

# Start systemd (this will persist as PID 1)
exec "$@"