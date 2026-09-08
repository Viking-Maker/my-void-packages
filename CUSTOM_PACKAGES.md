# Viking-Maker's my-void-packages Templates

Source: https://github.com/Viking-Maker/my-void-packages  
Branch: my-custom-packages

## Repository Information
- Total templates: 7 unique custom templates (not in official void-packages)
- Binary packages: Pre-built packages available in `hostdir/binpkgs/my-custom-packages/`

## Unique Custom Templates

These are packages unique to your repository (not in the official void-packages):

### Source Templates (Build from Source)
- `fresh-editor` - Fast terminal-based LSP editor (cargo build)
- `zf` - Commandline fuzzy finder (zig build)
- `OrcaSlicer` - 3D slicer for Voron printers (cmake build)

### Binary Templates (Pre-built Upstream Binaries)
- `helium-browser-bin` - Chromium-based browser
- `librewolf-bin` - Privacy-focused Firefox fork
- `lightpanda` - Headless browser for AI agents
- `brave-origin-bin` - Brave browser nightly

## Binary Package Repository

Pre-built binaries are stored in:
```
hostdir/binpkgs/my-custom-packages/
├── *.xbps              # Built binary packages
└── x86_64-repodata     # Repository index (auto-generated)
```

### Installation from Binary Repo

```bash
# Add repository to your system
echo 'repository=https://raw.githubusercontent.com/Viking-Maker/my-void-packages/refs/heads/my-custom-packages/hostdir/binpkgs/my-custom-packages' | sudo tee /usr/share/xbps.d/10-viking-maker.conf

# Or install directly from local path
sudo xbps-install -Sy -R /home/hermes/my-void-packages/hostdir/binpkgs/my-custom-packages <package-name>
```

### Publishing New Binaries

After building a package:
```bash
cd /home/hermes/my-void-packages
./publish-binpkgs.sh --all    # Copy all and update repodata
./publish-binpkgs.sh <pkg>    # Copy specific package
```

## Available Binaries (Current)

| Package | Version | Size | Arch |
|---------|---------|------|------|
| fresh-editor | 0.4.10 | 9.9M | x86_64 |
| lightpanda | 0.4.0 | 21M | x86_64 |
| zf | 0.10.2 | 181K | x86_64 |
| helium-browser-bin | 0.15.4.1 | 145M | x86_64 |

## Build Scripts

- `publish-binpkgs.sh` - Copy built packages to binary repo & update repodata
- `install-binrepo.sh` - Install the binary repository on a workstation
- `TEMPLATES.md` - Full documentation for template types

## Setup for Maintenance

1. Navigate to the repo:
   ```bash
   cd /home/hermes/my-void-packages
   ```

2. Ensure you're on the correct branch:
   ```bash
   git checkout my-custom-packages
   ```

3. Update from remote:
   ```bash
   git fetch origin && git pull --ff-only origin my-custom-packages
   ```

4. Build a package:
   ```bash
   /home/hermes/void-packages/xbps-src pkg <package-name>
   ```

5. Publish binaries:
   ```bash
   ./publish-binpkgs.sh --all
   ```

6. Commit and push changes:
   ```bash
   git add .
   git commit -m "Build and publish: <package-name>"
   git push origin my-custom-packages
   ```

## Cleanup Log

- 2026-09-06: Removed `void-repo-jl-settings` and `gofer` templates
  - Deleted 4 files
  - Commit: c4cac948 "Remove void-repo-jl-settings and gofer templates"
- 2026-09-08: Added binary repository structure and publish scripts