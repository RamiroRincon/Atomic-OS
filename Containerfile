# 1. Context Stage: Gathers your custom files
FROM scratch AS ctx
COPY scripts /scripts
COPY assets /assets

# 2. Base Image Stage
FROM ghcr.io/ublue-os/base-main:latest

# 3. Execution Stage
# We use mounts to keep caches and bind the scripts temporarily
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    cp -r /ctx/assets /tmp/assets && \
    chmod +x /ctx/scripts/*.sh && \
    /ctx/scripts/00-install-gnome.sh && \
    /ctx/scripts/01-remove-bloat.sh && \
    /ctx/scripts/02-branding.sh && \
    /ctx/scripts/03-setup-firstboot.sh

# 4. Linting Stage
RUN bootc container lint
