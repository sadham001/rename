#!/bin/bash

# Set the installation directory
install_dir="/usr/local/bin"

# Define the alias names
aliases=("rename" "rn")

# Initialize the overriding choice
override_choice="n"

# Check if any of the aliases already exist
for alias in "${aliases[@]}"; do
  if [ -f "$install_dir/$alias" ]; then
    echo "The program '$alias' already exists."
    read -p "Do you want to override and reinstall it? (y/n): " choice
    if [ "$choice" = "y" ]; then
      override_choice="y"
      break
    else
      echo "Installation aborted."
      exit 1
    fi
  fi
done

# Create the aliases and define their behavior
for alias in "${aliases[@]}"; do
  cat > "$install_dir/$alias" <<EOF
#!/bin/bash

if [ "\$#" -ne 2 ]; then
  echo "Usage: $alias <old_name> <new_name>"
  exit 1
fi

old_name="\$1"
new_name="\$2"

if [ -e "\$new_name" ]; then
  echo "Error: The new name '\$new_name' already exists."
  exit 1
fi

mv "\$old_name" "\$new_name"
if [ \$? -eq 0 ]; then
  echo "Renamed '\$old_name' to '\$new_name'"
else
  echo "Error: Renaming failed."
fi
EOF

  # Make the alias executable
  chmod +x "$install_dir/$alias"
done

if [ "$override_choice" = "y" ]; then
  echo "Installation complete. You can now use 'rename' or 'rn' to rename files and directories."
else
  echo "Installation aborted."
fi
