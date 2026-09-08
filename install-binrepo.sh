#!/bin/bash
# install-binrepo.sh - Install the Viking-Maker binary repository
# Usage: curl -fsSL ... | bash

set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/Viking-Maker/my-void-packages/refs/heads/my-custom-packages/hostdir/binpkgs/my-custom-packages"
CONF_FILE="/usr/share/xbps.d/10-viking-maker.conf"

echo "Installing Viking-Maker binary repository..."

# Backup existing config if present
if [ -f "$CONF_FILE" ]; then
    echo "Backing up existing config to ${CONF_FILE}.bak"
    sudo cp "$CONF_FILE" "${CONF_FILE}.bak"
fi

# Add the repository
echo "Adding repository: $REPO_URL"
echo "repository=${REPO_URL}" | sudo tee "$CONF_FILE"

# Update repository index
echo ""
echo "Updating repository index..."
sudo xbps-install -S

echo ""
echo "Installation complete!"
echo ""
echo "Available packages:"
sudo xbps-query -Rs '^lightpanda$|^fresh-editor$|^zf$|^helium-browser-bin$|^librewolf-bin$|^brave-origin-bin$|^OrcaSlicer$' 2>/dev/null || echo "(run 'sudo xbps-install -S' to refresh)"

echo ""
echo "Install a package with:"
echo "  sudo xbps-install <package-name>"