FROM ghcr.io/ublue-os/base-main:41

# Copy your scripts and assets
COPY scripts /tmp/scripts
COPY assets /tmp/assets

# 1. Make scripts executable
# 2. Run the scripts (Added 04-flatpak-setup.sh)
# 3. Cleanup
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/00-install-basics.sh && \
    /tmp/scripts/01-remove-bloat.sh && \
    /tmp/scripts/02-branding.sh && \
    /tmp/scripts/03-flatpak-setup.sh && \
    /tmp/scripts/04-install-extensions.sh && \
    /tmp/scripts/05-setup-defaults.sh && \
    rm -rf /tmp/scripts /tmp/assets

RUN bootc container lint
