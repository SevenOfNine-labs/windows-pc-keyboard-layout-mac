# Known Limitations

This project intentionally focuses on layout mapping, not system-level keyboard behavior. The following limitations currently apply:

## Explicitly Not Working / Not Fully Reproducible

- Custom input sources are **not available on macOS login/lock screen**.
- There is **no true Windows-style NumLock toggle mode** in custom `.keylayout` files.
- Windows numpad dual-mode behavior (for example `EINFG` / `ENTF` secondary legends) is not fully reproducible as native key events in every app.
- Layout installation does **not auto-activate** the input source; activation must be done manually in System Settings.

## Dead-Key Scope

Current active dead-keys in this layout are:

- `^`
- acute accent key
- grave accent key

`~` is intentionally immediate output and not a dead-key.
