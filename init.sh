#!/bin/bash

scripts_dir="./bash"

mapfile -t scripts < <(find "$scripts_dir" -type f -name "*.sh" | sort)

for script in "${scripts[@]}"; do
  base_name=$(basename "$script")

  # Check if the base name starts with two digits
  if [[ $base_name =~ ^[0-9]{2} ]]; then
    source "$script"
  fi
done

# Set Zsh as default shell
echo "We are about to set Zsh as your default shell. Please enter your password."
chsh -s $(which zsh)

echo "If authentication fails, please run the following command manually to set Zsh as your default shell: \`chsh -s \$(which zsh)\`."
