# Viking-Maker's Void Linux Package Templates

This repository contains two types of package templates: **source templates** (that rebuild from upstream source) and **binary templates** (that repackage pre-built upstream binaries).

---

## Source Templates

These templates build packages from official upstream source code:

| Package | Build Style | Description |
|---------|-------------|-------------|
| `fresh-editor` | cargo | Fast terminal-based LSP editor with TypeScript plugins |
| `zf` | zig-build | Commandline fuzzy finder for filtering filepaths |
| `OrcaSlicer` | cmake | 3D slicer for Voron printers |

### Building Source Templates

```bash
cd /home/hermes/void-packages
./xbps-src pkg fresh-editor
./xbps-src pkg zf
./xbps-src pkg OrcaSlicer
```

---

## Binary Templates

These templates repackage pre-built upstream binaries (no compilation):

| Package | Source | Build Style | Notes |
|---------|--------|-------------|-------|
| `lightpanda` | GitHub releases | fetch | Headless browser for AI agents |
| `helium-browser-bin` | GitHub releases | default | Chromium-based browser |
| `librewolf-bin` | Codeberg packages | default | Privacy-focused Firefox fork |
| `brave-origin-bin` | GitHub releases | binary | Brave browser nightly (RPM) |

### Building Binary Templates

```bash
cd /home/hermes/void-packages
./xbps-src pkg lightpanda
./xbps-src pkg helium-browser-bin
./xbps-src pkg librewolf-bin
./xbps-src pkg brave-origin-bin
```

Binary templates are faster (no compilation) but you must wait for upstream releases.

---

## Publishing Binaries (GitHub Releases)

Binary packages are published to GitHub Releases for workstation installation.

### Workflow

1. **Build** the package in void-packages chroot:
   ```bash
   cd /home/hermes/void-packages
   ./xbps-src pkg <package-name>
   ```

2. **Locate the binary**:
   ```bash
   ls /home/hermes/void-packages/hostdir/binpkgs/<package-name>-*.xbps
   ```

3. **Create a GitHub Release** and upload the `.xbps` file.

4. **Update the binary repo** (copy from void-packages):
   ```bash
   cd /home/hermes/my-void-packages
   ./publish-binpkgs.sh --all
   ```

5. **Push changes** (only repodata, not the .xbps files):
   ```bash
   git add hostdir/binpkgs/my-custom-packages/x86_64-repodata
   git commit -m "Update binary repo for <package-name> v<version>"
   git push origin my-custom-packages
   ```

### Automated Publishing via GitHub Actions

See `.github/workflows/publish-binpkgs.yml` (to be configured) for CI/CD automation.

---

## Installing from Binary Repository

### On your workstation:

```bash
# Add this repository to your system
curl -fsSL https://raw.githubusercontent.com/Viking-Maker/my-void-packages/refs/heads/my-custom-packages/install-binrepo.sh | bash

# Or manually:
echo 'repository=https://raw.githubusercontent.com/Viking-Maker/my-void-packages/refs/heads/my-custom-packages/hostdir/binpkgs/my-custom-packages' | sudo tee /usr/share/xbps.d/10-viking-maker.conf

# Update and install
sudo xbps-install -S
sudo xbps-install <package-name>
```

---

## Available Binaries

| Package | Version | Size | Architecture |
|---------|---------|------|--------------|
| `fresh-editor` | 0.4.10 | 9.9M | x86_64 |
| `lightpanda` | 0.4.0 | 21M | x86_64 |
| `zf` | 0.10.2 | 181K | x86_64 |
| `helium-browser-bin` | 0.15.4.1 | 145M | x86_64 |

---

## Quick Reference

```bash
# Build a package
cd /home/hermes/void-packages && ./xbps-src pkg <pkg-name>

# Publish binaries to GitHub and update repo
./publish-binpkgs.sh --all
git add hostdir/binpkgs/my-custom-packages/x86_64-repodata
git commit -m "Update binary repo for <package-name>"
git push

# Install from binary repo (on workstation)
curl -fsSL https://raw.githubusercontent.com/Viking-Maker/my-void-packages/refs/heads/my-custom-packages/install-binrepo.sh | bash
sudo xbps-install <package-name>
```