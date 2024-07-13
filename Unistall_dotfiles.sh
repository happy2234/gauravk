#!/usr/bin/env bash

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
current_dir=$(pwd)

if [ "$current_dir" != "$home_dir" ]; then
    printf "%s%sThe script must be executed from the HOME directory.%s\n" "${BLD}" "${CYE}" "${CNC}"
    exit 1
fi

########## ---------- Welcome ---------- ##########

logo "Uninstalling Dotfiles"
printf '%s%sThis script will remove the dotfiles and dependencies installed by the original script.%s\n\n' "${BLD}" "${CRE}" "${CNC}"

while true; do
    read -rp "Do you wish to continue? [y/N]: " yn
    case $yn in
        [Yy]* ) break ;;
        [Nn]* ) exit ;;
        * ) printf "Error: just write 'y' or 'n'\n\n" ;;
    esac
done
clear

########## ---------- Remove installed packages ---------- ##########

logo "Removing installed packages.."

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

printf "%s%sChecking for installed packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
for paquete in "${dependencias[@]}"; do
    if is_installed "$paquete"; then
        if sudo pacman -Rns "$paquete" --noconfirm >/dev/null 2>> RiceError.log; then
            printf "%s%s%s %shas been removed successfully.%s\n" "${BLD}" "${CYE}" "$paquete" "${CBL}" "${CNC}"
            sleep 1
        else
            printf "%s%s%s %shas not been removed correctly. See %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "$paquete" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
            sleep 1
        fi
    else
        printf '%s%s%s %sis not installed on your system!%s\n' "${BLD}" "${CYE}" "$paquete" "${CGR}" "${CNC}"
        sleep 1
    fi
done
sleep 5
clear

########## ---------- Restore Backup files ---------- ##########

logo "Restoring backup files"

printf "Restoring files from backup directory %s%s%s/.RiceBackup%s\n\n" "${BLD}" "${CRE}" "$HOME" "${CNC}"

for folder in bspwm alacritty picom rofi eww sxhkd dunst kitty polybar ncmpcpp ranger tmux zsh mpd paru; do
    if [ -d "$backup_folder/${folder}_$date" ]; then
        if mv "$backup_folder/${folder}_$date" "$HOME/.config/$folder" 2>> RiceError.log; then
            printf "%s%s%s folder restored successfully.%s\n" "${BLD}" "${CGR}" "$folder" "${CNC}"
            sleep 1
        else
            printf "%s%sFailed to restore %s folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "$folder" "${CBL}" "${CNC}"
            sleep 1
        fi
    else
        printf "%s%s%s folder backup does not exist, %sno restore needed%s\n" "${BLD}" "${CGR}" "$folder" "${CYE}" "${CNC}"
        sleep 1
    fi
done

if [ -d "$backup_folder/nvim_$date" ]; then
    if mv "$backup_folder/nvim_$date" "$HOME/.config/nvim" 2>> RiceError.log; then
        printf "%s%snvim folder restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
        sleep 1
    else
        printf "%s%sFailed to restore nvim folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
        sleep 1
    fi
else
    printf "%s%snvim folder backup does not exist, %sno restore needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    sleep 1
fi

for folder in "$backup_folder"/chrome_*; do
    if [ -d "$folder" ]; then
        if mv "$folder" "$HOME/.mozilla/firefox/*.default-release/" 2>> RiceError.log; then
            printf "%s%sChrome folder restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
        else
            printf "%s%sFailed to restore Chrome folder. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
        fi
    else
        printf "%s%sThe folder Chrome backup does not exist, %sno restore needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    fi
done

for file in "$backup_folder"/user.js_*; do
    if [ -f "$file" ]; then
        if mv "$file" "$HOME/.mozilla/firefox/*.default-release/" 2>> RiceError.log; then
            printf "%s%suser.js file restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
        else
            printf "%s%sFailed to restore user.js file. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
        fi
    else
        printf "%s%sThe file user.js backup does not exist, %sno restore needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
    fi
done

if [ -f "$backup_folder"/.zshrc_"$date" ]; then
    if mv "$backup_folder"/.zshrc_"$date" ~/.zshrc 2>> RiceError.log; then
        printf "%s%s.zshrc file restored successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
    else
        printf "%s%sFailed to restore .zshrc file. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${CBL}" "${CNC}"
    fi
else
    printf "%s%sThe file .zshrc backup does not exist, %sno restore needed%s\n" "${BLD}" "${CGR}" "${CYE}" "${CNC}"
fi

printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
sleep 5

########## ---------- Remove dotfiles ---------- ##########

logo "Removing dotfiles.."
printf "Removing files from respective directories..\n"

for dirs in ~/dotfiles/config/*; do
    dir_name=$(basename "$dirs")
    if rm -rf ~/.config/"${dir_name}" 2>> RiceError.log; then
        printf "%s%s%s %sconfiguration removed successfully%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CGR}" "${CNC}"
    else
        printf "%s%sFailed to remove %s configuration. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${dir_name}" "${CBL}" "${CNC}"
    fi
done

for files in ~/dotfiles/home/.*; do
    file_name=$(basename "$files")
    if [ -f ~/"${file_name}" ] || [ -d ~/"${file_name}" ]; then
        if rm -rf ~/"${file_name}" 2>> RiceError.log; then
            printf "%s%s%s %sremoved successfully%s\n" "${BLD}" "${CYE}" "${file_name}" "${CGR}" "${CNC}"
        else
            printf "%s%sFailed to remove %s. See %sRiceError.log%s\n" "${BLD}" "${CRE}" "${file_name}" "${CBL}" "${CNC}"
        fi
    fi
done

printf "%s%sDotfiles removal completed.%s\n\n" "${BLD}" "${CGR}" "${CNC}"

########## ---------- Uninstallation Completed ---------- ##########

logo "Uninstallation Completed"
printf "%s%sThe dotfiles and dependencies have been removed successfully.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
printf "%s%sThank you for using z0mbi3 Dotfiles.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
