#!/bin/bash

echo "Starting installation of KDE 6 desktop environment..."

# List of KDE 6 packages to install
kde_packages=(
    "plasma-desktop"
    "kde-applications"
    "sddm"
    "konsole"
    # Add other KDE 6-related packages as needed
)

# List of known desktop environment components to remove
desktop_components=(
    "gnome-shell"
    "xfce4"
    "lxqt"
    "hyprland"
    # Add other desktop environment components as needed
)

# Function to check if package is installed
package_installed() {
    pacman -Q "$1" &>/dev/null
}

# Function to prompt user before removal
confirm_removal() {
    read -rp "Do you want to proceed with removing $1? [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            echo "Operation canceled."
            exit 1
            ;;
    esac
}

# Function to remove desktop environment components
remove_desktop_environment() {
    echo "Removing existing desktop environment components..."
    for component in "${desktop_components[@]}"; do
        if package_installed "$component"; then
            confirm_removal "$component"
            sudo pacman -Rns --noconfirm "$component"
        fi
    done

    # Remove any leftover configuration files
    echo "Cleaning up leftover configuration files..."
    sudo find /etc -type f -iname '*gnome*' -delete
    sudo find /etc -type f -iname '*xfce*' -delete
    sudo find /etc -type f -iname '*lxqt*' -delete
    sudo find /etc -type f -iname '*hyprland*' -delete
    # Add more cleanup commands as needed for other desktop environment remnants

    # Clean up orphaned packages
    echo "Cleaning up orphaned packages..."
    orphans=$(pacman -Qtdq)
    if [ -n "$orphans" ]; then
        sudo pacman -Rns --noconfirm $orphans
    else
        echo "No orphaned packages to remove."
    fi
}

# Function to install KDE 6 packages
install_kde() {
    echo "Installing KDE 6 packages..."
    sudo pacman -S --noconfirm "${kde_packages[@]}"

    # Enable and start SDDM
    echo "Enabling and starting SDDM..."
    sudo systemctl enable sddm.service
    sudo systemctl start sddm.service

    echo "KDE 6 installation complete."
}

# Main script execution
remove_desktop_environment
install_kde

# Prompt for reboot
read -rp "Installation complete. Do you want to reboot now? [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "Rebooting system..."
        sudo reboot
        ;;
    *)
        echo "Please reboot your system later to start using KDE 6."
        ;;
esac