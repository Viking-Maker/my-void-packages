#!/bin/bash
# publish-bin-payload.sh - Publish a pre-built payload tarball for a "-bin" template.
#
# Use this for packages where upstream (GitHub Releases) ships NO prebuilt Linux
# binaries, so the "-bin" variant has to be built from source on agent-node and
# self-hosted as a GitHub Release asset. The generated tarball is the distfile
# consumed by srcpkgs/<pkg>-bin/template.
#
# Usage: ./publish-bin-payload.sh <pkgname> <version> [revision]
#   e.g. ./publish-bin-payload.sh noctalia 5.1.0 1
#
# Requires the source template to have been built first:
#   cd /home/hermes/void-packages && ./xbps-src -j6 pkg <pkgname>

set -euo pipefail

PKG_NAME="${1:?usage: $0 <pkgname> <version> [revision]}"
PKG_VERSION="${2:?usage: $0 <pkgname> <version> [revision]}"
PKG_REVISION="${3:-1}"
REPO="Viking-Maker/my-void-packages"
RELEASE_TAG="v${PKG_VERSION}-bin"
SRC_BINPKGS="/home/hermes/void-packages/hostdir/binpkgs"
WORK_DIR="/tmp/${PKG_NAME}-bin-publish"
PAYLOAD_NAME="${PKG_NAME}-bin-${PKG_VERSION}-x86_64.tar.xz"

echo "=== Locating built ${PKG_NAME}-${PKG_VERSION}_${PKG_REVISION} package ==="
XBP_FILE=$(find "${SRC_BINPKGS}" -name "${PKG_NAME}-${PKG_VERSION}_${PKG_REVISION}.x86_64.xbps" | head -1)
if [ -z "${XBP_FILE}" ]; then
    echo "ERROR: no ${PKG_NAME}-${PKG_VERSION}_${PKG_REVISION}.x86_64.xbps in ${SRC_BINPKGS}" >&2
    echo "Build it first: cd /home/hermes/void-packages && ./xbps-src -j6 pkg ${PKG_NAME}" >&2
    exit 1
fi
echo "Found: ${XBP_FILE}"

echo "=== Extracting package payload ==="
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}"
tar -C "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}" --zstd -xf "${XBP_FILE}"
# xbps metadata files are not part of the installed tree
rm -rf "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}/.xbps"* \
       "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}/INSTALL" \
       "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}/REMOVE" \
       "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}/props.plist" \
       "${WORK_DIR}/${PKG_NAME}-bin-${PKG_VERSION}/files.plist"

echo "=== Creating payload tarball ==="
cd "${WORK_DIR}"
tar -cJf "${PAYLOAD_NAME}" "${PKG_NAME}-bin-${PKG_VERSION}/"
CHECKSUM=$(sha256sum "${PAYLOAD_NAME}" | awk '{print $1}')
SIZE=$(du -h "${PAYLOAD_NAME}" | awk '{print $1}')

echo
echo "payload : ${PAYLOAD_NAME} (${SIZE})"
echo "sha256  : ${CHECKSUM}"
echo
echo "=== Publishing to GitHub Release ${RELEASE_TAG} ==="
if gh release view "${RELEASE_TAG}" --repo "${REPO}" >/dev/null 2>&1; then
    gh release upload "${RELEASE_TAG}" "${PAYLOAD_NAME}" --repo "${REPO}" --clobber
else
    gh release create "${RELEASE_TAG}" "${PAYLOAD_NAME}" \
        --repo "${REPO}" \
        --title "${PKG_NAME} ${PKG_VERSION} binary release" \
        --notes "Pre-built binaries for ${PKG_NAME} ${PKG_VERSION} on x86_64 Linux (built from source on agent-node)."
fi

echo
echo "=== NEXT STEP ==="
echo "Put this checksum into srcpkgs/${PKG_NAME}-bin/template:"
echo "  checksum=${CHECKSUM}"
echo "Download URL: https://github.com/${REPO}/releases/download/${RELEASE_TAG}/${PAYLOAD_NAME}"