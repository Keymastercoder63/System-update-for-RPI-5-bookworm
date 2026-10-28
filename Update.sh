#!/bin/bash
echo "Checking for updates..."
UPDATE=$(sudo apt update)
UPDATES=$(npx npm-check-updates -u)

echo "Updating System/Packages..."
echo "Updating apt packages..."
if echo "$UPDATE" | grep "All packages are up to date"; then
    echo "All packages are already up to date."
else
    echo "Updates found. Updating packages"
    sudo apt full-upgrade -y
fi
echo "Done"
echo "Updating flatpak packages..."
sudo flatpak update
echo "Done"
echo "Updating npm packages..."
if echo "$UPDATES" | grep -q "All dependencies match the latest package versions"; then
    echo "All packages are already up to date."
else
    echo "Updates found. Updating package.json..."
    npx npm-check-updates -u
    echo "Installing updated packages..."
    npm install
    echo "Update complete."
fi
echo "Done"
echo "Updating pipx packages..."
sudo pipx upgrade-all
echo "Cleaning up..."
sudo apt autoclean
sync

echo "System update complete"
