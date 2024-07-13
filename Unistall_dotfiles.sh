#!/bin/bash

# Script to uninstall specific packages and remove dotfiles

# Define packages to uninstall
packages_to_remove=(
    package1
    package2
    package3
)

# Define dotfiles to remove
dotfiles=(
    ~/.config/dotfile1
    ~/.config/dotfile2
    ~/.dotfile3
)

# Backup dotfiles
backup_dir="$HOME/.RiceBackup"
mkdir -p "$backup_dir"
for file in "${dotfiles[@]}"; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        cp -r "$file" "$backup_dir/"
    fi
done

# Function to uninstall packages
uninstall_packages() {
    for pkg in "${packages_to_remove[@]}"; do
        if dpkg -l | grep -q "$pkg"; then
            sudo apt-get remove --purge -y "$pkg"
        else
            echo "Package $pkg is not installed."
        fi
    done
}

# Function to remove dotfiles
remove_dotfiles() {
    for file in "${dotfiles[@]}"; do
        if [ -f "$file" ] || [ -d "$file" ]; then
            rm -rf "$file"
        fi
    done
}

# Execute uninstallation
echo "Starting uninstallation process..."

# Try to uninstall packages
uninstall_packages

# Remove dotfiles
remove_dotfiles

# Check if dotfiles are removed
for file in "${dotfiles[@]}"; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        echo "Error: Failed to remove $file"
        echo "$(date) - Error: Failed to remove $file" >> "$HOME/RiceError.log"
    fi
done

echo "Uninstallation process completed."