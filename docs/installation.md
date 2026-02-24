# Installation

## Option 1: Clone Repository

```bash
git clone https://github.com/SevenOfNine-ai/windows-pc-keyboard-layout-mac.git
cd windows-pc-keyboard-layout-mac
git lfs pull
```

### Why `git lfs pull` Is Needed

This repository stores binary assets with Git LFS (configured in `.gitattributes`), including:

- screenshots in `images/`
- icon files such as `.icns`

Without `git lfs pull`, those files remain small text pointers instead of the real binaries, which can break visual docs and icon-generation workflows.

Install for current user:

```bash
mkdir -p ~/Library/Keyboard\ Layouts
cp -R root/pc-win-de-keyboard.bundle ~/Library/Keyboard\ Layouts/
```

Install system-wide:

```bash
sudo cp -R root/pc-win-de-keyboard.bundle "/Library/Keyboard Layouts/"
```

## Option 2: Install with OpenPackage

```bash
npm install -g opkg
opkg install gh@SevenOfNine-ai/windows-pc-keyboard-layout-mac@v1.0.3
bash install-macos.sh
```

Note: In `gh@...` syntax, the version is a Git ref. This repository tags releases as `vX.Y.Z`, so use `@v1.0.3` (not `@1.0.3`).

## Enable in macOS

1. Open `System Settings -> Keyboard -> Input Sources`
2. Click `+`
3. Choose language `Deutsch`
4. Select layout `Deutsch - PC`

Reference:

![Add keyboard layout step 1](../images/add-keyboard-layout1.png)

![Add keyboard layout step 2](../images/add-keyboard-layout2.png)

## Quick Verification

- Basic letters and umlauts
- Alt layer special characters (see image below)
- Dead-keys: `^`, acute accent key, grave accent key
- `~` outputs directly (not a dead-key)

![Alt-layer reference](../images/keyboard-alt.png)
