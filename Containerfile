FROM ghcr.io/ublue-os/base-main:41

# Copy your scripts and assets
COPY scripts /tmp/scripts
COPY assets /tmp/assets

# 1. Make scripts executable
# 2. Run the scripts (Added 04-flatpak-setup.sh)
# 3. Cleanup
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/00-Install-Basics.sh && \
    /tmp/scripts/01-Remove-Bloat.sh && \
    /tmp/scripts/02-Remove-Branding.sh && \
    /tmp/scripts/03-Setup-Defaults.sh && \
    rm -rf /tmp/scripts /tmp/assets

RUN bootc container lint
