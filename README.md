# German Windows-PC Keyboard Layout for macOS

German keyboard layout for macOS with Windows-PC-like special-character key positions.

## Quick Start

### OpenPackage

```bash
npm install -g opkg
opkg install gh@SevenOfNine-ai/windows-pc-keyboard-layout-mac@v1.0.3
bash install-macos.sh
```

Note: In `gh@...` syntax, the version is a Git ref. This repository tags releases as `vX.Y.Z`, so use `@v1.0.3` (not `@1.0.3`).

### Clone and Install

```bash
git clone https://github.com/SevenOfNine-ai/windows-pc-keyboard-layout-mac.git
cd windows-pc-keyboard-layout-mac
# Required: fetch Git LFS binary assets (images/icon files)
git lfs pull
mkdir -p ~/Library/Keyboard\ Layouts
cp -R root/pc-win-de-keyboard.bundle ~/Library/Keyboard\ Layouts/
```

## Documentation

Full documentation is in `docs/`:

- [Docs Home](docs/readme.md)
- [Installation](docs/installation.md)
- [Known Limitations](docs/limitations.md)
- [Security](docs/security.md)
- [OpenPackage Publishing](docs/openpackage-publishing.md)
- [Contributing](docs/contributing.md)
- [Full Security Audit](docs/security-audit.md)
