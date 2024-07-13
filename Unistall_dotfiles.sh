#!/usr/bin/env bash

# This script is to uninstall the dotfiles installed by the z0mbi3 dotfiles installer script

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

backup_folder=~/.RiceBackup

logo () {
    local text="${1:?}"
    echo -en "
                       %%%
                %%%%%//%%%%%
              %%************%%%
          (%%//############*****%%
        %%%%%**###&&&&&&&&&###**//
        %%(**##&&&#########&&&##**
        %%(**##*****#####*****##**%%%
        %%(**##     *****     ##**
           //##   @@**   @@   ##//
             ##     **###     ##
             #######     #####//
               ###**&&&&&**###
               &&&         &&&
               &&&////   &&
                  &&//@@@**
                    ..***
    z0mbi3 Dotfiles\n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

########## ---------- You must not run this as root ---------- ##########

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root user."
    exit 1
fi

home_dir=$HOME

########## ---------- Welcome ---------- ##########

logo "Welcome to Dotfiles Uninstaller!"
printf '%s%sThis script will uninstall z0mbi3 dotfiles from your system. It will restore your backed-up configuration files and remove installed packages.%s\n\n' "${BLD}" "${CRE}" "${CNC}"

while true; do
    read -rp "Do you wish to continue with uninstallation? [y/N]: " yn
    case $yn in
        [Yy]* ) break ;;
        [Nn]* ) exit ;;
        * ) printf "Error: just write 'y' or 'n'\n\n" ;;
    esac
done
clear

########## ---------- Restoring Backups ---------- ##########

logo "Restoring Backup"

printf "%s%sRestoring backed-up configuration files...%s\n" "${BLD}" "${CBL}" "${CNC}"

if [ ! -d "$backup_folder" ]; then
    printf "%s%sNo backup folder found. Exiting...%s\n" "${BLD}" "${CRE}" "${CNC}"
    exit 1
fi

# Restore backed-up configuration files
for folder in bspwm alacritty picom rofi eww sxhkd dunst kitty polybar ncmpcpp ranger tmux zsh mpd paru; do
    if [ -d "$backup_folder/${folder}_*" ]; then
        if mv "$backup_folder/${folder}_*" "$HOME/.config/$folder" 2>> UninstallRiceError.log; then
            printf "%s%s%s folder restored successfully.%s\n" "${BLD}" "${CGR}" "${folder}" "${CNC}"
            sleep 1
        else
            printf "%s%sFailed to restore %s folder. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${folder}" "${CBL}" "${CRE}" "${CNC}"
            sleep 1
        fi
    else
        printf "%s%s%s backup folder not found, %sno restoration needed.%s\n" "${BLD}" "${CGR}" "${folder}" "${CYE}" "${CNC}"
        sleep 1
    fi
done

if [ -d "$backup_folder/nvim_*" ]; then
    if mv "$backup_folder/nvim_*" "$HOME/.config/nvim" 2>> UninstallRiceError.log; then
        printf "%s%snvim folder restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
        sleep 1
    else
        printf "%s%sFailed to restore nvim folder. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 1
    fi
else
    printf "%s%snvim backup folder not found, %sno restoration needed.%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    sleep 1
fi

if [ -d "$backup_folder/chrome_*" ]; then
    if mv "$backup_folder/chrome_*" "$HOME/.mozilla/firefox/*.default-release/chrome" 2>> UninstallRiceError.log; then
        printf "%s%sChrome folder restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
    else
        printf "%s%sFailed to restore Chrome folder. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
    fi
else
    printf "%s%sChrome backup folder not found, %sno restoration needed.%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
fi

if [ -f "$backup_folder/user.js_*" ]; then
    if mv "$backup_folder/user.js_*" "$HOME/.mozilla/firefox/*.default-release/user.js" 2>> UninstallRiceError.log; then
        printf "%s%suser.js file restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
    else
        printf "%s%sFailed to restore user.js file. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
    fi
else
    printf "%s%suser.js backup file not found, %sno restoration needed.%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
fi

if [ -f "$backup_folder/.zshrc_*" ]; then
    if mv "$backup_folder/.zshrc_*" "$HOME/.zshrc" 2>> UninstallRiceError.log; then
        printf "%s%.zshrc file restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
    else
        printf "%s%sFailed to restore .zshrc file. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
    fi
else
    printf "%s%s.zshrc backup file not found, %sno restoration needed.%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
fi

sleep 5

########## ---------- Removing Installed Packages ---------- ##########

logo "Removing Installed Packages"

printf "%s%sRemoving installed packages...%s\n" "${BLD}" "${CRE}" "${CNC}"

dependencias=(alacritty base-devel bat brightnessctl bspwm dunst eza feh gvfs-mtp firefox geany git kitty imagemagick jq \
                                jgmenu libwebp maim mpc mpd neovim ncmpcpp npm pamixer pacman-contrib \
                                papirus-icon-theme physlock picom playerctl polybar polkit-gnome python-gobject ranger \
                                redshift rofi rustup sxhkd tmux ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd \
                                ttf-joypixels ttf-terminus-nerd ueberzug webp-pixbuf-loader xclip xdg-user-dirs \
                                xdo xdotool xorg-xdpyinfo xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot \
                                xorg-xwininfo zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

is_installed() {
    pacman -Q "$1" &> /dev/null
}

printf "%s%sChecking installed packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
for paquete in "${dependencias[@]}"; do
    if is_installed "$paquete"; then
        if sudo pacman -Rs --noconfirm "$paquete" >/dev/null 2>> UninstallRiceError.log; then
            printf "%s%s%s %shas been uninstalled successfully.%s\n" "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
            sleep 1
        else
            printf "%s%s%s %sfailed to uninstall. See %sUninstallRiceError.log %sfor more details.%s\n" "${BLD}" "${CRE}" "$paquete" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
            sleep 1
        fi
    else
        printf "%s%s%s %sis not installed on your system.%s\n" "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
        sleep 1
    fi
done

sleep 5

########## ---------- Cleaning Up ---------- ##########

logo "Cleaning Up"

printf "%s%sCleaning up residual files...%s\n" "${BLD}" "${CBL}" "${CNC}"

# Remove dotfiles repository
printf "%s%sRemoving z0mbi3 dotfiles repository...%s\n" "${BLD}" "${CRE}" "${CNC}"
if rm -rf "$HOME/.config/dotfiles" 2>> UninstallRiceError.log; then
    printf "%s%sDotfiles repository removed successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "%s%sFailed to remove dotfiles repository. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
fi

# Remove zsh history file
printf "%s%sRemoving zsh history file...%s\n" "${BLD}" "${CRE}" "${CNC}"
if rm -rf "$HOME/.zsh_history" 2>> UninstallRiceError.log; then
    printf "%s%s.zsh_history file removed successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "%s%sFailed to remove .zsh_history file. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
fi

# Remove backup folder
printf "%s%sRemoving backup folder...%s\n" "${BLD}" "${CRE}" "${CNC}"
if rm -rf "$backup_folder" 2>> UninstallRiceError.log; then
    printf "%s%sBackup folder removed successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
else
    printf "%s%sFailed to remove backup folder. See %sUninstallRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
fi

sleep 5

########## ---------- Finalizing ---------- ##########

logo "Uninstallation Completed"

printf "%s%sz0mbi3 dotfiles have been successfully uninstalled from your system.%s\n" "${BLD}" "${CGR}" "${CNC}"

printf "%s%sThank you for using z0mbi3 dotfiles!%s\n" "${BLD}" "${CBL}" "${CNC}"
