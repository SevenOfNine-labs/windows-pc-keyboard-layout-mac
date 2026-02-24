# Contributing

## Scope

Contributions are welcome for docs, metadata, scripts, and review tooling.

## Safe to Edit

- `README.md`
- `docs/*.md`
- `AGENTS.md`
- `.openpackage/rules/*.md`
- `root/pc-win-de-keyboard.bundle/Contents/Info.plist`
- `root/pc-win-de-keyboard.bundle/Contents/version.plist`
- `root/pc-win-de-keyboard.bundle/Contents/Resources/{de,en}.lproj/InfoPlist.strings`
- `icon/convert-png-to-icns.sh`

## OpenPackage Folders

- Commit `.openpackage/rules/` because it is your canonical agent-guideline source.
- Do not commit `.openpackage/packages/` or `.openpackage/openpackage*.yml`; these are local/generated workspace artifacts.

## Edit with Caution

- `root/pc-win-de-keyboard.bundle/Contents/Resources/German - PC.keylayout`

Use **Ukulele** for layout edits. Do not hand-edit XML unless you fully understand the Apple Keyboard Layout state machine and accept breakage risk.

## Do Not Edit Manually

- `root/pc-win-de-keyboard.bundle/Contents/Resources/German - PC.icns`

This icon is generated from `icon/layout-icon.png` via:

```bash
bash icon/convert-png-to-icns.sh
```

## Validation Commands

```bash
plutil -lint root/pc-win-de-keyboard.bundle/Contents/Info.plist
plutil -lint root/pc-win-de-keyboard.bundle/Contents/version.plist
```

## Manual Test Checklist

- Install and enable `Deutsch - PC`
- Verify base typing and special characters
- Verify dead-keys: `^`, acute accent key, grave accent key
- Verify `~` is immediate output
- Compare Alt layer with `images/keyboard-alt.png`
