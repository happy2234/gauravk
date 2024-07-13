
# z0mbi3 Dotfiles Uninstallation Script

## Description

This script, `uninstall_dotfiles.sh`, is designed to cleanly uninstall the z0mbi3 dotfiles and revert any changes made during their installation. It performs the following actions:

1. Uninstalls the packages installed by the original z0mbi3 dotfiles installation script.
2. Restores the original configuration files from the `.RiceBackup` directory.
3. Removes the dotfiles from the respective directories.
4. Provides feedback on the success or failure of each operation.

## Prerequisites

- The script assumes that a backup of the original configuration files exists in the `.RiceBackup` directory within the user's home directory.

## Usage

1. **Download the Script:**

   Save the script as `uninstall_dotfiles.sh`:

   ```bash
   wget https://path-to-your-script/uninstall_dotfiles.sh
   ```

2. **Make the Script Executable:**

   Ensure the script has execute permissions:

   ```bash
   chmod +x uninstall_dotfiles.sh
   ```

3. **Run the Script:**

   Execute the script:

   ```bash
   ./uninstall_dotfiles.sh
   ```

## What the Script Does

1. **Uninstalls Packages:**

   The script will attempt to uninstall the following packages:

   ```bash
   sudo apt-get remove --purge -y i3 dunst feh alacritty rofi polybar picom nitrogen flameshot lxappearance neofetch cava neovim font-manager
   ```

2. **Restores Configuration Files:**

   The script will restore the original configuration files from the `.RiceBackup` directory if they exist:

   ```bash
   if [ -d "$HOME/.RiceBackup" ]; then
       for dir in $(ls "$HOME/.RiceBackup"); do
           if [ -d "$HOME/.RiceBackup/$dir" ]; then
               cp -r "$HOME/.RiceBackup/$dir/." "$HOME/$dir"
           fi
       done
   else
       echo "No backup directory found. Skipping restoration of original files."
   fi
   ```

3. **Removes Dotfiles:**

   The script will remove the dotfiles from the following directories:

   ```bash
   rm -rf ~/.config/{i3,polybar,dunst,rofi,picom,alacritty,nitrogen,flameshot,neofetch,cava,nvim,gtk-3.0}
   rm -rf ~/dotfiles/home
   ```

## Log File

Any errors encountered during the uninstallation process will be logged to `RiceError.log` in the user's home directory:

```bash
exec 2>>"$HOME/RiceError.log"
```

## Output

The script will provide feedback in the terminal indicating the success or failure of each operation:

```bash
if [ $? -eq 0 ]; then
    echo "Successfully uninstalled [package name]."
else
    echo "Failed to uninstall [package name]." >>"$HOME/RiceError.log"
fi
```

## Acknowledgements

Thank you for using z0mbi3 Dotfiles. If you have any questions or need further assistance, please refer to the original documentation or contact the maintainers.

---

**Note:** This script is intended for users who have installed the z0mbi3 dotfiles and wish to uninstall them. It is recommended to review the script and backup any important data before proceeding with the



#chmod +x uninstall_dotfiles.sh
#./uninstall_dotfiles.sh