FROM ubuntu:22.04

# Install dependencies with systemd
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      wget systemd unzip openjdk-11-jre-headless tzdata && \
    ln -fs /usr/share/zoneinfo/Africa/Casablanca /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean

# Download and install Traccar
RUN wget https://github.com/traccar/traccar/releases/download/v5.2/traccar-linux-64-5.2.zip && \
    unzip traccar-linux-64-5.2.zip && \
    chmod +x traccar.run && \
    ./traccar.run --quiet && \
    rm traccar-linux-64-5.2.zip

# Fix systemd paths
RUN ln -s /lib/systemd/systemd /usr/sbin/init

# Entrypoint
COPY src/tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Start systemd
CMD ["/usr/sbin/init"]