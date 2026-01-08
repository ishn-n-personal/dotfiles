# Scripts

This folder contains the install and uninstall scripts for this dotfiles repository.

Both scripts are designed to be safe, reversible, and non-destructive.
They do not install packages, modify macOS system settings, or require sudo.

---

## install.sh

### What It Does

The install script sets up the dotfiles by creating symbolic links from this
repository into standard configuration locations.

Specifically, it:

- Creates symlinks into:
  - $HOME
  - $HOME/.config
- Automatically backs up any existing files or directories before linking
- Uses timestamped backup directories to avoid overwrites
- Skips missing or optional components without failing
- Never deletes user data
- Never requires elevated privileges

All backups are stored in:

$HOME/.dotfiles-backup/YYYYMMDD-HHMMSS/

---

### What It Does Not Do

- Does not install Homebrew or other packages
- Does not enable yabai scripting addition
- Does not modify macOS defaults or system files
- Does not overwrite files without backing them up first

These steps are intentionally left manual.

---

## uninstall.sh

### What It Does

The uninstall script cleanly reverses the changes made by install.sh.

It:

- Removes only symlinks created by the installer
- Never deletes real files or directories
- Leaves unrelated files untouched
- Optionally restores the most recent backup, if one exists
- Exits cleanly if no backups are found

The script is safe to run even if:

- The dotfiles were partially installed
- Some files were already removed
- No backups exist

---

### What It Does Not Do

- Does not remove user-created files
- Does not uninstall packages
- Does not modify system configuration
- Does not require confirmation for safe operations

---

## Usage

Install:

```bash
./install.sh
```

Uninstall:

```bash
./uninstall.sh
```
---

## Testing Without Risk

Both scripts can be tested safely using a temporary home directory:

```bash
mkdir -p /tmp/dotfiles-test-home
HOME=/tmp/dotfiles-test-home ./install.sh
HOME=/tmp/dotfiles-test-home ./uninstall.sh
```

This ensures zero impact on your real system.

---

## Supported Platforms

- macOS only (Darwin)

Other platforms are intentionally unsupported.
