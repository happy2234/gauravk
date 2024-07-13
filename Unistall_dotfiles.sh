#!/usr/bin/env bash
# Uninstall script for dotfiles setup

# ANSI color codes for colored output
CRE=$(tput setaf 1)    # Red color
CNC=$(tput sgr0)       # Reset color

# Function to display a logo or header
logo() {
    local text="${1:?}"
    echo -en "
        ██████╗ ██╗ ██████╗███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
        ██╔══██╗██║██╔════╝██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
        ██████╔╝██║██║     █████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
        ██╔══██╗██║██║     ██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
        ██║  ██║██║╚██████╗███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
        ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
        Script to uninstall my dotfiles
        Author: z0mbi3\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

# Display logo/header
logo "Uninstalling dotfiles"

# Check if running as root (not recommended)
if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root user."
    exit 1
fi

# Directory paths
home_dir="$HOME"
backup_folder="$HOME/.RiceBackup"

# Check if backup folder exists
if [ ! -d "$backup_folder" ]; then
    echo "Backup folder $backup_folder not found. Exiting."
    exit 1
fi

# Remove dotfiles directory
echo "Removing dotfiles..."
rm -rf "$home_dir/dotfiles"

# Restore backed up files
echo "Restoring backed up files..."
for folder in "$backup_folder"/*; do
    if [ -d "$folder" ]; then
        dir_name=$(basename "$folder")
        if [ -d "$home_dir/.config/$dir_name" ]; then
            rm -rf "$home_dir/.config/$dir_name"
        fi
        mv "$folder" "$home_dir/.config/"
        echo "Restored $dir_name"
    fi
done

# Clean up backup folder
echo "Cleaning up..."
rm -rf "$backup_folder"

echo "Dotfiles uninstallation complete."