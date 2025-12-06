# 1. Context Stage: Gathers your custom files
FROM scratch AS ctx
COPY scripts /scripts
COPY assets /assets

# 2. Base Image Stage
FROM ghcr.io/ublue-os/base-main:latest

# 3. Execution Stage
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    # Copy assets to /tmp (writable) in case scripts need to move them
    cp -r /ctx/assets /tmp/assets && \
    # Run scripts directly with bash to avoid permission issues
    bash /ctx/scripts/00-install-gnome.sh && \
    bash /ctx/scripts/01-remove-bloat.sh && \
    bash /ctx/scripts/02-branding.sh && \
    bash /ctx/scripts/03-setup-firstboot.sh

# 4. Linting Stage
RUN bootc container lint
