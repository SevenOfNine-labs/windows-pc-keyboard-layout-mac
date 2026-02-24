# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

German Windows-PC keyboard layout for macOS — maps special characters (`{`, `}`, `[`, `]`, etc.) to the same positions as on a Windows PC keyboard. The layout is a non-executable XML bundle, not software.

**Primary editor tool**: [Ukulele](https://software.sil.org/ukelele/) (GUI only — never hand-edit the `.keylayout` file)

## Key Commands

```bash
# Validate plist files
plutil -lint root/pc-win-de-keyboard.bundle/Contents/Info.plist
plutil -lint root/pc-win-de-keyboard.bundle/Contents/version.plist

# Rebuild icon from source PNG
bash icon/convert-png-to-icns.sh

# Install for current user (manual testing)
git lfs pull
cp -R root/pc-win-de-keyboard.bundle ~/Library/Keyboard\ Layouts/

# Install system-wide
sudo cp -R root/pc-win-de-keyboard.bundle "/Library/Keyboard Layouts/"
```

There is no automated build system, test framework, or CI pipeline. Testing is manual: install the bundle, enable "Deutsch - PC" in System Settings → Keyboard → Input Sources, and verify key output.

## Critical Constraint

**`German - PC.keylayout` must only be edited with Ukulele, never by hand.** XML structural errors break the entire layout, key code mismatches cause wrong characters, and dead-key state machine errors corrupt accent composition.

## Architecture

- `root/pc-win-de-keyboard.bundle/` — standard macOS `.bundle` package
  - `Contents/Resources/German - PC.keylayout` — Apple Keyboard Layout XML (the core file, ~484 lines)
  - `Contents/Info.plist` / `version.plist` — bundle metadata (version `1.0.3`)
  - `Contents/Resources/{de,en}.lproj/` — localization strings
- `icon/convert-png-to-icns.sh` — converts `icon/layout-icon.png` → `.icns` via macOS `sips`
- `docs/security-audit.md` — security analysis confirming zero vulnerabilities
- `images/keyboard-alt.png` — reference image for Alt-layer special character mappings

The keylayout XML contains: key-to-character maps for base/Shift/Option layers, and a finite state machine for dead-keys (circumflex, acute, grave, diaeresis). Tilde `~` is intentionally **not** a dead-key.

## Conventions

- Follow `.editorconfig`: Markdown uses UTF-8 + 4-space indent; JSON uses tabs; YAML uses 2-space indent; LF line endings everywhere
- Commit messages: short, imperative, German (e.g., `Layout Icon angepasst`). One logical change per commit
- New scripts/assets: lowercase kebab-case naming
- Git LFS is used for binary files (icons, images) — run `git lfs pull` after cloning
- DMG installers are created via Ukulele GUI (`File → Export Installer Disk Image...`), not committed to the repo

## Detailed Agent Guidelines

See [AGENTS.md](AGENTS.md) for comprehensive file-level editing rules, safe/unsafe task lists, and PR guidelines.

<!-- package: gh@sevenofnine-ai/windows-pc-keyboard-layout-mac -->
# Repository Guidelines

> **Note**: AI agent guidelines are maintained in `.openpackage/rules/keyboard-layout-agent-guidelines.md` and synchronized across platforms (Cursor, Claude, Codex, OpenCode) via [OpenPackage](https://openpackage.dev/). For the authoritative agent instructions, see that file.

## Project Overview

This repository distributes a German Windows-PC keyboard layout for macOS. The layout maps keys to the same positions as Windows PC keyboards, enabling smooth cross-platform switching. The keyboard layout is **cryptographically transparent** and poses no security risk; see [`docs/security-audit.md`](docs/security-audit.md) for a comprehensive security analysis.

**Key Technology**: Apple Keyboard Layout XML format (DTD: `System/Library/DTDs/KeyboardLayout.dtd`)
**Primary Editor**: [Ukulele](https://software.sil.org/ukelele/) (SIL tool for keyboard layout design)
**Platform**: macOS (Sierra and later)
**Installation**: Copies bundle to `~/Library/Keyboard Layouts/` or `/Library/Keyboard Layouts/`

## Project Structure & Module Organization

- `root/pc-win-de-keyboard.bundle/` — distributable macOS bundle containing all keyboard layout resources
  - `Contents/Info.plist` — bundle metadata, identifiers, and language info
  - `Contents/version.plist` — version tracking (currently `1.0.3`)
  - `Contents/Resources/German - PC.keylayout` — **primary XML layout definition** (edit via Ukulele, not by hand)
  - `Contents/Resources/German - PC.icns` — bundle icon (generated from `icon/layout-icon.png`)
  - `Contents/Resources/de.lproj/InfoPlist.strings` — German UI strings
  - `Contents/Resources/en.lproj/InfoPlist.strings` — English UI strings
- `images/` — README screenshots and visual documentation (`keyboard-alt.png` shows special character mappings)
- `icon/` — source icon and conversion script (`layout-icon.png` → `German - PC.icns`)
- `docs/` — documentation including security audit
- `openpackage.yml` — OpenPackage package metadata for `opkg install gh@...`
- `root/install-macos.sh` — helper script copied by OpenPackage for system installation
- `.editorconfig` — formatting and indentation rules for all file types
- `.vscode/` — VS Code workspace settings and extension recommendations

## Build, Test, and Development Commands

- `sudo cp -R root/pc-win-de-keyboard.bundle "/Library/Keyboard Layouts/"`: install locally for manual verification.
- `bash icon/convert-png-to-icns.sh`: rebuild the icon from `icon/layout-icon.png` into bundle resources.
- `plutil -lint root/pc-win-de-keyboard.bundle/Contents/Info.plist`: validate main bundle plist.
- `plutil -lint root/pc-win-de-keyboard.bundle/Contents/version.plist`: validate version plist.
- `git lfs pull`: ensure binary files (icons, images) are downloaded from Git LFS
- DMG export is done in Ukulele (`File -> Export Installer Disk Image...`); no CLI build pipeline is maintained in this repo.

## Architecture & Design Decisions

### Keyboard Layout Format

- **Technology**: Apple Keyboard Layout XML (`KeyboardLayout.dtd`)
- **Why XML**: Standard-compliant, human-auditable, no execution risk
- **Layout Structure**:
  - **keyMapSet id="fb0"**: main layout containing all key codes
  - **keyMap index="0"**: unmodified keys (base layer)
  - **keyMap index="1"**: Shift-modified keys
  - **keyMap index="2"**: Option/Alt-modified keys (AltGr layer)
  - **actions**: define dead-key behavior and composition rules

### Dead-Key Implementation

- Active dead-key triggers: circumflex `^`, acute `´`, grave `` ` ``, diaeresis `¨`
- Tilde `~` is **not** a dead-key trigger—pressing it produces `~` immediately
- State 5 remains explicitly represented in actions/terminators for transparent composition handling
- All dead-key outputs documented in `<terminators>` section
- Dead-key composition uses finite state machine explicitly visible in XML

### Bundle Structure

- Follows Apple's standard `.bundle` convention (macOS package format)
- Two localization variants: `de.lproj` (German) and `en.lproj` (English)
- Version tracking in both `Info.plist` (`CFBundleVersion`) and `version.plist` (now `1.0.3`)
- Unique bundle identifier: `org.sil.ukelele.keyboardlayout.pc-win-de-keyboard`

### Platform Target

- **Minimum macOS**: Sierra (10.12) and later
- **Bundle installation**: system recognizes bundles in `~/Library/Keyboard Layouts/` or `/Library/Keyboard Layouts/`
- **Activation**: via System Settings → Keyboard → Input Sources (no auto-activation)
- **Lock screen limitation**: Custom layouts unavailable on login/lock screen (macOS system restriction)

## Security & Safety

**⚠️ SECURITY CERTIFICATION**: This keyboard layout poses **NO data security risk**. See [`docs/security-audit.md`](docs/security-audit.md) for full analysis.

### Security Model

- **XML format is non-executable**: keylayout files are parsed data structures, not code
- **All mappings are transparent**: every key-to-character mapping is visible in plain-text XML
- **No I/O capabilities**: keylayout files cannot read, write, or transmit data
- **Deterministic output**: same key press always produces the same character (no conditional logic)
- **No hidden characters**: all Unicode outputs are standard, commonly-used characters

### Audit Scope

Verified safe against:

- ✅ Hidden character injection (zero-width spaces, Unicode exploits)
- ✅ Keylogging or recording functionality
- ✅ Network exfiltration
- ✅ Code execution paths
- ✅ Malicious dead-key behavior
- ✅ Privilege escalation in installation

### Installation Safety

- Simple file copy operation—no scripts or daemons execute
- No post-install hooks or background processes
- User must manually select layout in System Settings
- Sudo only needed for system-wide installation (standard privilege escalation)

## Coding Style & Naming Conventions

- Follow `.editorconfig` exactly: default 4-space indentation, LF line endings, trailing-whitespace trimming.
- Markdown files use UTF-8 and 4-space indentation; JSON files use tabs; YAML uses 2 spaces.
- Prefer editing `German - PC.keylayout` with Ukulele to avoid accidental structural regressions.
- Keep existing bundle/resource naming stable (for example, `German - PC.keylayout`, `de.lproj`, `en.lproj`).
- Name new scripts and image assets descriptively with lowercase kebab-case where possible.

## File-Level Guidelines for AI Agents

### Safe to Edit

- ✅ `README.md` — documentation (follow UTF-8 + 4-space indentation per `.editorconfig`)
- ✅ `docs/*.md` — new documentation, including security or architectural notes
- ✅ `AGENTS.md` — this file, including task guidelines and architecture notes
- ✅ `.editorconfig` — formatting rules for the project
- ✅ Plist metadata (`Info.plist`, `version.plist`) — strings, version numbers, identifiers
- ✅ String resource files (`de.lproj/`, `en.lproj/`) — localization UI strings
- ✅ Shell scripts (e.g., `icon/convert-png-to-icns.sh`) — icon generation and utilities

### Dangerous to Edit Without Caution

- ⚠️ `German - PC.keylayout` — DO NOT edit by hand; use Ukulele only
  - Any XML structural error breaks the entire layout
  - Key code mismatch causes wrong characters to output
  - Dead-key state machine misconfiguration corrupts accent composition
- ⚠️ Binary files (`*.icns`, `*.png`) — use GUI tools (Ukulele for icons, image editor for PNGs)

### Off-Limits (Automation-Generated)

- ❌ `German - PC.icns` — auto-generated from `icon/layout-icon.png` via `bash icon/convert-png-to-icns.sh`
- ❌ `.git/` and `.gitattributes` — version control configuration
- ❌ `.gitignore` — ignore patterns (update only if new generated artifacts need exclusion)

## Common AI-Assisted Tasks

### Documentation & Analysis

- ✅ Write or update `README.md` with usage instructions
- ✅ Create security audits and technical documentation in `docs/`
- ✅ Review and analyze keyboard layout mappings for correctness
- ✅ Generate architectural diagrams or workflow documentation

### Configuration Management

- ✅ Update version numbers in `Info.plist` and `version.plist`
- ✅ Update localization strings in `de.lproj/` and `en.lproj/`
- ✅ Modify `.editorconfig` rules and VS Code settings
- ✅ Update build/test command documentation

### Code/Script Maintenance

- ✅ Review and enhance shell scripts for robustness
- ✅ Add error handling to `convert-png-to-icns.sh`
- ✅ Create new utility scripts for development workflows
- ✅ Document CLI validation commands (e.g., `plutil -lint` procedures)

### NOT Suitable for AI (Manual-Only Tasks)

- ❌ Editing `.keylayout` XML directly—requires Ukulele GUI
- ❌ Creating or modifying `.dmg` installers—requires Ukulele GUI
- ❌ Icon design or PNG manipulation—requires image editor
- ❌ Testing layout behavior on macOS—requires human on target platform

## Testing Guidelines

- There is no automated test framework; validation is manual on macOS.
- After changes, install the bundle, enable **Deutsch - PC**, and verify key output in normal typing and with `Alt`.
- Confirm dead-key behavior for `^`, `` ` ``, and `´`, and ensure `~` remains a non-dead key.
- Compare special-character mappings against `images/keyboard-alt.png`.
- Record tested macOS version and test scope in your PR.

## Commit & Pull Request Guidelines

- Keep commit messages short and imperative; repository history is mostly German (for example, `Layout Icon angepasst`).
- Make one logical change per commit; avoid mixing keylayout, docs, and icon updates unless tightly coupled.
- PRs should include: purpose, changed files, manual test notes, and updated screenshots when mappings or setup steps change.
- Do not commit generated release artifacts such as `pc-win-de-keyboard.dmg` (already ignored).

## OpenPackage Integration

AI agent instructions are maintained in **`.openpackage/rules/keyboard-layout-agent-guidelines.md`** as a universal format and are automatically synchronized across multiple platforms via [OpenPackage](https://openpackage.dev/).

### Synced Platforms

- **Cursor** → `.cursor/rules/`
- **Claude** → `.claude/rules/`
- **Codex** → `.codex/`
- **OpenCode** → `.opencode/rules/`

### Applying Updates

After modifying `.openpackage/rules/keyboard-layout-agent-guidelines.md`, sync to all platforms:

```bash
opkg apply --platforms cursor,claude,codex,opencode
```

If your installed OpenPackage CLI does not support `apply` yet, use:

```bash
opkg install . --platforms cursor claude codex opencode --force
```

This ensures all AI agents (Cursor, Claude, Codex, OpenCode) have consistent project guidelines.
<!-- -->
