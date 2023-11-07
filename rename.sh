#!/bin/bash

# Define the script name and aliases
script_name="rename.sh"
aliases=("rename" "rn")

# Set the installation directory
install_dir="/usr/local/bin"

# Check if the script already exists
if [ -e "$install_dir/$script_name" ]; then
  echo "The script '$script_name' already exists in '$install_dir'."
  exit 1
fi

# Copy the script to the installation directory
cp "$script_name" "$install_dir/$script_name"

# Create aliases for the script
for alias in "${aliases[@]}"; do
  echo "alias $alias='$install_dir/$script_name'" >> "$HOME/.bashrc"
done

# Source the .bashrc file to make the aliases available
source "$HOME/.bashrc"

echo "Installation complete. You can now use 'rename' or 'rn' to rename files and directories."
