FROM ghcr.io/ublue-os/bazzite:latest

# Copy your scripts and assets
COPY scripts /tmp/scripts
COPY assets /tmp/assets

# 1. Make scripts executable
# 2. Run the scripts
# 3. Cleanup
RUN chmod +x /tmp/scripts/*.sh && \
    mkdir -p /usr/share/fonts/custom && \
    cp -r /tmp/assets/fonts/* /usr/share/fonts/custom/ && \
    fc-cache -f /usr/share/fonts/custom && \
    /tmp/scripts/00-Install-Basics.sh && \
    /tmp/scripts/01-Remove-Bloat.sh && \
    /tmp/scripts/02-Remove-Branding.sh && \
    /tmp/scripts/03-Setup-Defaults.sh && \
    rm -rf /tmp/scripts /tmp/assets

# Set the default hostname
RUN echo "Atomic-OS" > /etc/hostname

RUN bootc container lint
