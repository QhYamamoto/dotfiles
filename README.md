# Prerequisites

- Windows 11

- WSL

  - Distributions
    - Ubuntu 22.04 (LTS)
    - Ubuntu 24.04 (LTS)

- Wezterm (recommended)

  ```sh
  winget install wez.wezterm
  ```

# Installation

1. Install curl and unzip

   ```sh
   sudo apt update && sudo apt install -y curl unzip
   ```

2. Download main branch of this repository by curl.

   ```sh
   curl -OL https://github.com/QhYamamoto/dotfiles/archive/refs/heads/main.zip
   ```

3. Unzip the downloaded file.

   ```sh
   unzip main.zip && mv ~/dotfiles-main ~/dotfiles
   ```

4. Run init.sh and follow the instructions.

   ```sh
   cd ~/dotfiles && bash ./init.sh
   ```

5. Please exit and re-open the terminal.

   ```sh
   exit
   ```

6. Run git setup command and follow the instructions.

   ```sh
   dtf git -H github.com -e {your_email_address} -u {your_git_account_name} -k id_github_rsa
   ```

7. Register the public key to [your github account](https://github.com/settings/keys).

8. Remove dotfiles directory and clone the repository again via git.

   ```sh
   rm -rf ~/dotfiles && git clone git@github.com:QhYamamoto/dotfiles.git
   ```

# Custom commands

Note that these commands are available after initialization.

1. `dotfiles` (alias: `dtf`)

   ```sh
   dotfiles -h
   ________________________________________
   Custom dotfiles command.

   Usage: dotfiles [COMMAND]

   Commands:
     init        Initialize dotfiles settings.
     relink      Recreate dotfile symlinks only.
     ahk         Install ahk and reset its settings.
     git         Add ssh setting for git service.
     config      Open config directory of a specific tool in neovim.
     sync        Synchronize dotfiles command.
     completion  Generate shell completion scripts.
     help        Print this message or the help of the given subcommand(s)

   Options:
     -h, --help  Print help
   ```

# tmux

- Attach or create the default session with `tmuxa`.
- Attach or create a named session with `tmuxa <session-name>`.
- Detach from tmux with `Ctrl-b d`.
- Re-load config with `Ctrl-b r`.
- Split panes with `Ctrl-b v` for left/right and `Ctrl-b h` for top/bottom.
- Move panes with `Ctrl-h/j/k/l`.
