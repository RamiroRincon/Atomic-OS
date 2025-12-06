# 1. Context Stage: Gathers your custom files
FROM scratch AS ctx
# Copy your specific folders into this temporary stage
COPY scripts /scripts
COPY assets /assets

# 2. Base Image Stage
FROM ghcr.io/ublue-os/base-main:latest

# 3. Execution Stage
# We use mounts to keep dnf/rpm-ostree caches between builds for speed
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    # A. Move assets to /tmp so your scripts can find them where they expect
    cp -r /ctx/assets /tmp/assets && \
    # B. Ensure scripts are executable
    chmod +x /ctx/scripts/*.sh && \
    # C. Run your modular scripts in order
    /ctx/scripts/00-install-gnome.sh && \
    /ctx/scripts/01-remove-bloat.sh && \
    /ctx/scripts/02-branding.sh && \
    /ctx/scripts/03-setup-firstboot.sh

# 4. Linting Stage (Optional but recommended)
RUN bootc container lint
