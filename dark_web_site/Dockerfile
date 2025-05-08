# Base Image
FROM debian:bullseye-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
    tor \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY siteweb /var/www/html


RUN mkdir -p /var/lib/tor/hidden_service && \
    # chown -R debian-tor:debian-tor /var/lib/tor/hidden_service && \
    chmod 700 /var/lib/tor/hidden_service

COPY torrc /etc/tor/torrc

# Expose Nginx and Tor ports
EXPOSE 80 9050

# Start services
CMD ["sh", "-c", "tor & nginx -g 'daemon off;'"]
