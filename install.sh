#!/usr/bin/env bash
# Installs System Update for the current user:
#   ~/.local/bin/system-update           (run "system-update" from any terminal)
#   ~/.local/share/applications/...      (app menu / desktop launcher)
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="$HOME/.local/bin"
app_dir="$HOME/.local/share/applications"
icon_dir="$HOME/.local/share/icons"

mkdir -p "$bin_dir" "$app_dir" "$icon_dir"

install -m 755 "$src_dir/Update.sh" "$bin_dir/system-update"
install -m 644 "$src_dir/update-logo.png" "$icon_dir/system-update.png"

# .desktop files don't expand ~ or $HOME, so write absolute paths.
cat > "$app_dir/system-update.desktop" <<EOF
[Desktop Entry]
Name=System Update
Comment=Update apt, flatpak, npm and pipx packages
Exec=$bin_dir/system-update --pause
Icon=$icon_dir/system-update.png
Terminal=true
Type=Application
Categories=System;Utility;
StartupNotify=false
EOF
chmod 644 "$app_dir/system-update.desktop"

echo "Installed. Run 'system-update' or find 'System Update' in your app menu."
case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) echo "Note: $bin_dir is not on your PATH yet. Log out and back in, or add it to ~/.bashrc." ;;
esac
