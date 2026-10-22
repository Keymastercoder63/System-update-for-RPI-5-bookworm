#!/usr/bin/env bash
# System Update for Raspberry Pi OS (Bookworm)
# Updates apt, flatpak, global npm and pipx packages.
#
# Usage: Update.sh [--dry-run] [--pause]
#   --dry-run  show what would run without changing anything
#   --pause    wait for Enter at the end (used by the desktop launcher)

set -uo pipefail

DRY_RUN=0
PAUSE=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --pause)   PAUSE=1 ;;
        -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; exit 2 ;;
    esac
done

# pipx and npm installs are per-user, so don't run the whole script as root.
if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as your normal user, not root. It uses sudo where needed." >&2
    exit 1
fi

have() { command -v "$1" >/dev/null 2>&1; }

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

failed=()

# step "Name" function  -> runs the function, records a failure but keeps going
step() {
    local name=$1 fn=$2
    printf '\n==> %s\n' "$name"
    if ! "$fn"; then
        failed+=("$name")
        echo "!! $name failed"
    fi
}

update_apt() {
    run sudo apt-get update || return 1
    local count
    count=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)
    if [ "$count" -eq 0 ]; then
        echo "All apt packages are already up to date."
    else
        echo "$count package(s) can be upgraded."
        run sudo apt-get full-upgrade -y || return 1
    fi
    run sudo apt-get autoremove -y
    run sudo apt-get autoclean
}

update_flatpak() {
    if ! have flatpak; then
        echo "flatpak is not installed, skipping."
        return 0
    fi
    run flatpak update -y
}

update_npm() {
    if ! have npm; then
        echo "npm is not installed, skipping."
        return 0
    fi
    # Global packages only. Run 'npm update' yourself inside a project to update that project.
    local root
    root="$(npm root -g)"
    if [ -w "$root" ]; then
        run npm update -g
    else
        run sudo npm update -g
    fi
}

update_pipx() {
    if ! have pipx; then
        echo "pipx is not installed, skipping."
        return 0
    fi
    run pipx upgrade-all
}

step "Updating apt packages"    update_apt
step "Updating flatpak packages" update_flatpak
step "Updating global npm packages" update_npm
step "Updating pipx packages"   update_pipx

sync

printf '\n'
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required to finish some updates."
fi

status=0
if [ "${#failed[@]}" -gt 0 ]; then
    echo "System update finished with problems in: ${failed[*]}"
    status=1
else
    echo "System update complete."
fi

if [ "$PAUSE" -eq 1 ]; then
    read -r -p "Press Enter to close..."
fi
exit "$status"
