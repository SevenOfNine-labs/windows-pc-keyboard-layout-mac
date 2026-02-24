# Why It Is Secure to Use

## Short Answer

The keyboard layout is data, not executable code.

## Security Model

- `German - PC.keylayout` is XML parsed by macOS.
- The file defines static key-to-character mappings.
- It cannot execute scripts or binaries.
- It has no network, file-write, or keylogging capability.

## Installation Safety

Installation is a file copy operation only:

- No post-install scripts
- No daemon/background process
- No startup hooks

## Transparency

All mappings are visible in plain text and can be audited in:

- `root/pc-win-de-keyboard.bundle/Contents/Resources/German - PC.keylayout`

## Full Audit

For a detailed threat review and audit notes, read:

- [security-audit.md](security-audit.md)
