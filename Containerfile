FROM ghcr.io/ublue-os/base-main:latest

# Copy your scripts and assets
COPY scripts /tmp/scripts
COPY assets /tmp/assets

# 1. Make scripts executable (Crucial for GitHub Web created files)
# 2. Run the scripts
# 3. Cleanup
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/00-install-gnome.sh && \
    /tmp/scripts/01-remove-bloat.sh && \
    /tmp/scripts/02-branding.sh && \
    /tmp/scripts/03-setup-firstboot.sh && \
    rm -rf /tmp/scripts /tmp/assets

RUN bootc container lint
