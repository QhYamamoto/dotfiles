# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update

# install yazi via cargo
cargo install --locked yazi-fm yazi-cli

# install ondark flavor
git clone https://github.com/BennyOe/onedark.yazi.git ~/.config/yazi/flavors/onedark.yazi
