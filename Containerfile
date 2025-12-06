FROM ghcr.io/ublue-os/base-main:latest

# Copy scripts and assets directly into the image layer
COPY scripts /tmp/scripts
COPY assets /tmp/assets

# Run the scripts
# We use a single RUN instruction to keep layers efficient
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/00-install-gnome.sh && \
    /tmp/scripts/01-remove-bloat.sh && \
    /tmp/scripts/02-branding.sh && \
    /tmp/scripts/03-setup-firstboot.sh && \
    # Cleanup to save space
    rm -rf /tmp/scripts /tmp/assets

RUN bootc container lint
