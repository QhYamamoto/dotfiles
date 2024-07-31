# .zshrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc

# powerlevel10k
ln -sf ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh

# nvim config directory
if [ ! -d "~/.config" ]; then
  mkdir -p ~/.config
fi
ln -sfn ~/dotfiles/.config/nvim ~/.config
