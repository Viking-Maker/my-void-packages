#!/bin/bash
# publish-binpkgs.sh - Publish built .xbps packages to the binary repo
# Usage: ./publish-binpkgs.sh [pkg-name]  (copies and repodata for specific pkg)
#        ./publish-binpkgs.sh --all      (copies all matching pkgs from void-packages)
#        ./publish-binpkgs.sh --clean    (clears all .xbps and repodata)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINPKGS_DIR="${SCRIPT_DIR}/hostdir/binpkgs/my-custom-packages"
REPO_DIR="${BINPKGS_DIR}"
SOURCE_DIR="/home/hermes/void-packages/hostdir/binpkgs"

# Your custom template packages
CUSTOM_PKGS="lightpanda fresh-editor zf helium-browser-bin librewolf-bin brave-origin-bin OrcaSlicer"

if [ ! -d "$REPO_DIR" ]; then
    echo "Creating binpkgs repo directory: $REPO_DIR"
    mkdir -p "$REPO_DIR"
fi

# Handle --clean
if [ "${1:-}" = "--clean" ]; then
    echo "Cleaning all .xbps files and repodata from $REPO_DIR"
    rm -f "${REPO_DIR}"/*.xbps
    rm -f "${REPO_DIR}"/x86_64-repodata
    echo "Cleaned. (x86_64-repodata removed too)"
    exit 0
fi

# Handle --all (copy all custom packages)
if [ "${1:-}" = "--all" ]; then
    echo "Copying all built packages from $SOURCE_DIR to $REPO_DIR..."
    for pkg in $CUSTOM_PKGS; do
        for f in "${SOURCE_DIR}"/${pkg}-*.xbps; do
            if [ -f "$f" ]; then
                cp -v "$f" "$REPO_DIR/"
            else
                echo "  (no ${pkg}*.xbps found)"
            fi
        done
    done
else
    # Copy specific package if specified
    if [ -n "${1:-}" ]; then
        PKG="$1"
        echo "Looking for ${PKG}* in ${SOURCE_DIR}..."
        FOUND=$(ls "${SOURCE_DIR}"/${PKG}-*.xbps 2>/dev/null || true)
        if [ -z "$FOUND" ]; then
            echo "ERROR: No .xbps file matching ${PKG}-* found in ${SOURCE_DIR}"
            echo "Build it first with: ./xbps-src pkg ${PKG}"
            exit 1
        fi
        cp -v $FOUND "$REPO_DIR/"
    fi
fi

# Rebuild the repository index (repodata)
echo ""
echo "Updating repository index (x86_64-repodata)..."
cd "$REPO_DIR"
xbps-rindex -a *.xbps 2>&1 || {
    echo "ERROR: xbps-rindex failed"
    exit 1
}

echo ""
echo "Repository contents:"
ls -lh *.xbps 2>/dev/null || echo "(no .xbps files)"
echo ""
echo "Repodata updated successfully."
