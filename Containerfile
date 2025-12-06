# 1. Context Stage: Gathers your custom files
FROM scratch AS ctx
COPY scripts /scripts
COPY assets /assets

# 2. Base Image Stage
FROM ghcr.io/ublue-os/base-main:latest

# 3. Execution Stage
# We copy scripts to /tmp so we can chmod them (ctx is read-only)
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    cp -r /ctx/scripts /tmp/scripts && \
    cp -r /ctx/assets /tmp/assets && \
    chmod -R +x /tmp/scripts && \
    /tmp/scripts/00-install-gnome.sh && \
    /tmp/scripts/01-remove-bloat.sh && \
    /tmp/scripts/02-branding.sh && \
    /tmp/scripts/03-setup-firstboot.sh

# 4. Linting Stage
RUN bootc container lint
