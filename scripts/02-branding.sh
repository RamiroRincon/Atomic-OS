#!/usr/bin/env bash
set -eox pipefail

# Swap Fedora branding for Generic
# This changes the logo in "About", boot splash, etc.
rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    generic-logos \
    generic-release

# Optional: Overwrite OS-Release to your own name
# Be careful here, some scripts rely on ID=fedora
sed -i 's/PRETTY_NAME="Fedora Linux"/PRETTY_NAME="Atomic-OS"/g' /usr/lib/os-release
