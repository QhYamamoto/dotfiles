#!/bin/bash

WSL_HOME="$HOME"
WIN_HOME=$(wslpath "$(cmd.exe /C 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null | tr -d '\r')")
ZENHAN_EXE="$WIN_HOME/AppData/Local/zenhan.exe"

##################################################
# Copy or create symbolic link for config files
##################################################
# function to copy files/directories
copy_item() {
  local source="$1"
  local destination="$2"

  if [ -d "$destination" ]; then
    rm -rf "$destination"
  elif [ -f "$destination" ]; then
    rm "$destination"
  fi

  if [ -d $source ]; then
    cp -r "$source" "$destination"
  elif [ -f $source ]; then
    cp "$source" "$destination"
  fi

  if [ $? -eq 0 ]; then
    echo "Copied: $source -> $destination"
  else
    echo "Error: Failed to copy from $source to $destination"
    exit 1
  fi
}

# function to create symbolic link
create_symlink() {
  local target="$1"
  local link_name="$2"

  # check if link_name directory if the target is directory
  local link_dir=$(dirname "$link_name")
  if [ -d "$target" ] && [ ! -d "$link_dir" ]; then
    mkdir -p "$link_dir"
    echo "Directory created: $link_dir"
  fi

  # remove already existing symlink
  if [ -L "$link_name" ]; then
    rm "$link_name"
  fi

  # create new symlink
  if ln -sfn "$target" "$link_name"; then
    echo "Symlink created: $link_name -> $target"
  else
    echo "Error: Failed to create symlink: $link_name -> $target"
    exit 1
  fi
}

# associative array for config paths
declare -A config_paths=(
  ["$WSL_HOME/dotfiles/.zshrc"]="$WSL_HOME/.zshrc"
  ["$WSL_HOME/dotfiles/zsh/p10k.zsh"]="$WSL_HOME/.p10k.zsh"
  ["$WSL_HOME/dotfiles/zsh/zenhan.zsh"]="$WSL_HOME/.zenhan.zsh"
  ["$WSL_HOME/dotfiles/.config/nvim"]="$WSL_HOME/.config/nvim"
  ["$WSL_HOME/dotfiles/.config/lazygit"]="$WSL_HOME/.config/lazygit"
  ["$WSL_HOME/dotfiles/.config/lazydocker"]="$WSL_HOME/.config/lazydocker"
  ["$WSL_HOME/dotfiles/.config/wezterm"]="$WIN_HOME/.config/wezterm"
)

# Copy configuration files to Windows
for config_path_key in "${!config_paths[@]}"; do
  config_path_value="${config_paths[$config_path_key]}"
  if [[ "$config_path_value" == "$WIN_HOME/"* ]]; then
    # if config_path starts with $WIN_HOME, copy it to windows home directory
    copy_item "$config_path_key" "$config_path_value"
  else
    # else create symbolic link
    create_symlink "$config_path_key" "$config_path_value"
  fi
done

verify_installation() {
  local verification_cmd="$1"

  if [ -z "$verification_cmd" ]; then
    continue
  fi
  output=$($verification_cmd 2>&1)
  if [[ "$output" != *"command not found"* ]]; then
    echo "The package '$package_name' installed successfully."
  else
    echo "Error: The package '$package_name' isn't insalled."
    exit 1
  fi
}

##################################################
# Install packages
##################################################
# installation by apt
# packages associative array (["packagename"]="verification cmd")
declare -A packages=(
  ["bat"]="ln -s /usr/bin/batcat ~/.local/bin/bat && bat --version"
  ["curl"]="curl --version"
  ["fd-find"]="ln -s $(which fdfind) ~/.local/bin/fd && fd --version"
  ["lua5.4"]="lua -v"
  ["liblua5.4-dev"]=""
  ["git"]="git --version"
  ["neovim"]="nvim --version"
  ["npm"]="npm --version"
  ["ripgrep"]="rg --version"
  ["yarn"]="yarn --version"
  ["zsh"]="zsh -version"
  ["zsh-autosuggestions"]=""
  ["zsh-syntax-highlighting"]=""
)

IFS=" "

for package_name in "${!packages[@]}"; do
  # install
  sudo apt update -qq && sudo apt install -y $package_name

  # check if the installations have been succeeded
  verification_cmd=${packages[$package_name]}
  verify_installation "$verification_cmd"
done

cd

# install eza
sudo apt update
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

verify_installation "eza --version"

# installation by curl
# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# git-completion
curl -o ~/.zsh/git-completion.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

# git-prompt
curl -o ~/.zsh/git-prompt.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Nerd font
local fonts_dir="$WSL_HOME/.fonts"
local font_zip_name="0xProto_2_100.zip"
curl -fLO "https://github.com/0xType/0xProto/releases/download/2.100/$font_zip_name"
sudo unzip "$font_zip_name" -d "$fonts_dir"
rm "$font_zip_name"
fc-cache -fv

# zenhan
[[ ! -f zenhan.zip ]] || rm zenhan.zip
[[ ! -d zenhan ]] || rm -rf zenhan
curl -fLO https://github.com/iuchim/zenhan/releases/download/v0.0.1/zenhan.zip
unzip zenhan.zip
chmod u+x zenhan/bin64/zenhan.exe
[[ ! -d $(dirname "$ZENHAN_EXE") ]] || copy_item zenhan/bin64/zenhan.exe "$ZENHAN_EXE"
rm zenhan.zip
rm -rf zenhan

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install build-essential
brew install gcc

# installation by git
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# install fzf
git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

##################################################
# Set default shell to Zsh
##################################################
echo "We'll set your default shell to Zsh. Please input your password."
chsh -s $(which zsh)

echo "If authentication fails, please execute the following command to set your default shell to Zsh: \`chsh -s \$(which zsh)\`."
