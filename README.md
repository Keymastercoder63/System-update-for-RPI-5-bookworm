![Badge](https://img.shields.io/badge/version-0.1.0-blue)
# System Update

System Update is a single Bash script that updates your **apt**, **flatpak**, **npm (global)** and **pipx** packages in one go. It includes an installer that adds a `system-update` terminal command and an app-menu launcher, so updating is a two-click job with no distractions.

Target: Raspberry Pi OS Bookworm (English).

## Install

```bash
git clone https://github.com/Keymastercoder63/System-update-for-RPI-5-bookworm.git
cd System-update-for-RPI-5-bookworm
./install.sh
```

This installs:

- `~/.local/bin/system-update`, the command you run from any terminal
- a **System Update** entry in your app menu

If `~/.local/bin` isn't on your `PATH` yet, log out and back in (or add it in `~/.bashrc`).

## Usage

```bash
system-update            # run all updates
system-update --dry-run  # show what would run, change nothing
```

Run it as your normal user, not with `sudo`. It uses `sudo` itself where needed, because pipx and npm packages are per-user.

What it does:

1. **apt**: runs `apt-get update`, then `full-upgrade -y` if anything is upgradable, then `autoremove` and `autoclean`.
2. **flatpak**: runs `flatpak update -y` (skipped if flatpak isn't installed).
3. **npm**: runs `npm update -g` for global packages (skipped if npm isn't installed). To update a project, run `npm update` inside it yourself.
4. **pipx**: runs `pipx upgrade-all` (skipped if pipx isn't installed).

If one step fails the rest still run, and a summary at the end lists what failed. It also tells you when a reboot is required.

**Note:** apt runs with `-y`, so you won't be asked to confirm. Only use it on systems and software sources you trust.

## Tested hardware

Tested on a 4GB Raspberry Pi 5 and a 16GB Raspberry Pi 5, both running Raspberry Pi OS Bookworm.

## Recent updates

- The script now runs as your normal user and no longer rewrites `package.json` in the current folder.
- Added `--dry-run`, per-step error handling and a reboot notice.
- Added `install.sh`, which replaces the manual `.bashrc` alias and fixes the desktop launcher.
- The repository was renamed to System-update-for-RPI-5-bookworm.

## License

GNU General Public License v3.0. See `LICENSE`.
