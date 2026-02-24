#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLE="$SRC_DIR/pc-win-de-keyboard.bundle"

if [[ ! -d "$BUNDLE" ]]; then
    echo "ERROR: Bundle not found at: $BUNDLE"
    exit 1
fi

echo "Installing to /Library/Keyboard Layouts (requires sudo)..."
sudo mkdir -p "/Library/Keyboard Layouts"
sudo cp -R "$BUNDLE" "/Library/Keyboard Layouts/"

echo "Done. Log out/in (or reboot) and enable: System Settings -> Keyboard -> Input Sources."
