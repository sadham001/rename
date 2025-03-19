#!/bin/bash

# Set the installation directory
install_dir="/usr/local/bin"

# Define the alias names
aliases=("rename" "rn")

# Check write permissions before proceeding
if [ ! -w "$install_dir" ]; then
  echo "Error: You do not have permission to write to $install_dir. Try running with sudo."
  exit 1
fi

# Check if any of the aliases already exist
for alias in "${aliases[@]}"; do
  if [ -e "$install_dir/$alias" ] || [ -L "$install_dir/$alias" ]; then
    echo "Warning: The program '$alias' already exists."
    read -p "Do you want to override and reinstall it? (y/n): " choice
    if [ "$choice" != "y" ]; then
      echo "Installation aborted."
      exit 1
    fi
  fi

done

# Create the aliases and define their behavior
for alias in "${aliases[@]}"; do
  tmp_file=$(mktemp)
  cat > "$tmp_file" <<EOF
#!/bin/bash

if [ "\$#" -ne 2 ]; then
  echo "Usage: $alias <old_name> <new_name>"
  exit 1
fi

old_name="\$1"
new_name="\$2"

# Prevent overwriting existing files
touch "\$new_name" 2>/dev/null && rm "\$new_name"
if [ -e "\$new_name" ]; then
  echo "Error: The new name '\$new_name' already exists."
  exit 1
fi

mv -- "\$old_name" "\$new_name"
if [ \$? -eq 0 ]; then
  echo "Renamed '\$old_name' to '\$new_name'"
else
  echo "Error: Renaming failed."
  exit 1
fi
EOF

  # Move the file atomically and set correct permissions
  mv "$tmp_file" "$install_dir/$alias"
  chmod +x "$install_dir/$alias"
done

echo "Installation complete. You can now use 'rename' or 'rn' to rename files and directories."
