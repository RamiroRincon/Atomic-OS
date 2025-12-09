FROM ghcr.io/ublue-os/base-main:41

# Copy your scripts and assets
COPY scripts /tmp/scripts

# 1. Make scripts executable
# 2. Run the scripts (Added 04-flatpak-setup.sh)
# 3. Cleanup
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/00-Install-Basics.sh && \
    /tmp/scripts/01-Remove-Bloat.sh && \
    /tmp/scripts/02-Remove-Branding.sh && \
    /tmp/scripts/03-Setup-Defaults.sh && \
    rm -rf /tmp/scripts /tmp/assets

# 1. Copy the "install-setup.sh" script to a system bin location (Safe & Executable)
COPY scripts/install-setup.sh /usr/bin/install-setup
RUN chmod +x /usr/bin/install-setup

# 2. Create the Desktop Launcher in /etc/skel
# This creates the "One-Click" installer icon on the desktop for new users.
RUN mkdir -p /etc/skel/Desktop && \
    echo "[Desktop Entry]" > /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Version=1.0" >> /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Type=Application" >> /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Name=Complete Setup" >> /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Comment=Installs Terminal and App Store System-Wide" >> /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Exec=/usr/bin/install-setup" >> /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Icon=system-software-install" >> /etc/skel/Desktop/Install-Apps.desktop && \
    echo "Terminal=false" >> /etc/skel/Desktop/Install-Apps.desktop && \
    chmod +x /etc/skel/Desktop/Install-Apps.desktop

# Set the default hostname
RUN echo "Atomic-OS" > /etc/hostname

RUN bootc container lint
