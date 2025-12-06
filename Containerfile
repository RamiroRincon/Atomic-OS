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
    # Copy files to /tmp so they are writable (ctx is read-only)
    cp -r /ctx/scripts /tmp/scripts && \
    cp -r /ctx/assets /tmp/assets && \
    # Execute with bash explicitly (bypasses "Permission denied" / chmod issues)
    bash /tmp/scripts/00-install-gnome.sh && \
    bash /tmp/scripts/01-remove-bloat.sh && \
    bash /tmp/scripts/02-branding.sh && \
    bash /tmp/scripts/03-setup-firstboot.sh

# 4. Linting Stage
RUN bootc container lint
