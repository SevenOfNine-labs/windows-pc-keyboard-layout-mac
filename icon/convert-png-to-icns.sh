#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_ICON="$SCRIPT_DIR/layout-icon.png"
TARGET_ICON="$SCRIPT_DIR/../root/pc-win-de-keyboard.bundle/Contents/Resources/German - PC.icns"

if [ ! -f "$SOURCE_ICON" ]; then
    echo "Fehler: '$SOURCE_ICON' nicht gefunden."
    exit 1
fi

if head -n 1 "$SOURCE_ICON" | grep -q "^version https://git-lfs.github.com/spec/v1$"; then
    echo "Fehler: '$SOURCE_ICON' ist ein Git-LFS-Pointer."
    echo "Bitte zuerst 'git lfs pull' ausfuehren."
    exit 1
fi

sips -s format icns "$SOURCE_ICON" --out "$TARGET_ICON"
