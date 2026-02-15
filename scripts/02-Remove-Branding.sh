#!/usr/bin/env bash
set -eox pipefail

## Fedora → Generic branding swap
## We use 'generic-logos' (Desktop assets) instead of 'generic-logos-httpd'
REPLACEMENTS=(
  "fedora-logos generic-logos"
  "fedora-release generic-release"
)

for pair in "${REPLACEMENTS[@]}"; do
    old_pkg=$(echo "$pair" | cut -d' ' -f1)
    new_pkg=$(echo "$pair" | cut -d' ' -f2)

    rpm-ostree override replace \
      --experimental \
      "$old_pkg" \
      "$new_pkg" \
      || echo "Skipping branding replace: $old_pkg → $new_pkg (not present)"
done

## Optional: override PRETTY_NAME
if grep -q 'PRETTY_NAME="Fedora' /usr/lib/os-release; then
    sed -i 's/PRETTY_NAME="Fedora[^"]*"/PRETTY_NAME="Atomic-OS"/g' /usr/lib/os-release
fi

echo "Atomic-OS \n \l" > /etc/issue
echo "Atomic-OS \n \l" > /etc/issue.net