![Badge](https://img.shields.io/badge/version-0.01-blue)
# System Update
System-update is a APT, NPM and PIPX updater Bash script. 

It's only one file but can has a pre-included Desktop entry file if you want to just have a 2-click launcher and thats it no distractions just a updater. Target: Raspberry Pi OS Bookworm (English). Checks if packages are outdated for *apt* and *npm* but just updates *pipx* and *flatpak* Packages. also zip file for download.

For *apt* packages there’s the -y flag so you don’t need to respond to “Do you want to continue? [Y/n]” but be cautious as it could secretly install malware.

It's also recommended to add a alias to `.bashrc` so you can open a terminal in run `system-update` later in this **README** I'll tell you how to do that (Linux only)

System Update is also protected by the GNU General Public License v3.0 so it's open source as long as you follow the rules


## Tested hardware

System-update has been tested on a 4GB Raspberry Pi 5 Running Raspberry Pi OS Bookworm
and tested on a 16GB Raspberry Pi 5 running the same OS.

## bashrc alias
To configure your system to run `Update.sh` when you enter `system-update` in your terminal you'll need to add a alias into the file `.bashrc` Note that .bashrc is only in Linux. For example you can add the alias like this `alias system-update='~/Update.sh'` and that while work if Update.sh is in your home folder.
