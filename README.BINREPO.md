# Binary Package Repository

This directory contains pre-built binary packages for templates in the `my-custom-packages` branch. Users can install these without recompiling from source.

## Structure

```
my-void-packages/
├── srcpkgs/          # Template recipes (source of truth)
├── hostdir/
│   ├── binpkgs/
│   │   └── my-custom-packages/
│   │       ├── *.xbps           # Built binary packages
│   │       └── x86_64-repodata  # Repository metadata (auto-generated)
│   ├── ccache/      # Compiler cache (shared with void-packages)
│   └── sources/     # Downloaded source tarballs
```

## Installation

Users can install from this binary repo without rebuilding:

```bash
# Add this repo to your XBPS configuration
echo 'repository=https://raw.githubusercontent.com/Viking-Maker/my-void-packages/refs/heads/my-custom-packages/hostdir/binpkgs/my-custom-packages' | sudo tee /usr/share/xbps.d/10-viking-maker.conf

# Update and install
sudo xbps-install -S
sudo xbps-install <package-name>
```

Or install directly from the local/repo path:

```bash
# From a local clone or checkout
sudo xbps-install -S -R /path/to/my-void-packages/hostdir/binpkgs/my-custom-packages <package-name>
```

## Building and Publishing

1. Build a package:
   ```bash
   cd /home/hermes/my-void-packages
   ./xbps-src pkg <package-name>
   ```

2. The resulting `.xbps` file lands in `hostdir/binpkgs/my-custom-packages/`.

3. Update the repodata:
   ```bash
   xbps-rindex -a hostdir/binpkgs/my-custom-packages/*.xbps
   ```

4. Commit and push the `.xbps` + `x86_64-repodata` to the `my-custom-packages` branch.
```