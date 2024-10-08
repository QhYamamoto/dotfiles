# Prerequisites

- Windows 11

- WSL

  - Distributions
    - Ubuntu 22.04 (LTS)
    - Ubuntu 24.04 (LTS)

- Wezterm (recommended)

  ```powershell
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

7. Run git setup command. (Please name your key pair `github_id_rsa`)

```sh
cd ~/dotfiles && dotfiles git
```

7. Copy generated public key to your clipboard.

```sh
cat ~/.ssh/github_id_rsa.pub | pbcopy
```

7. Please and the public key to [your github account](https://github.com/settings/keys).

8. Remove dotfiles directory and clone the repository again via git.

```sh
cd && rm -rf ~/dotfiles && git clone git@github.com:QhYamamoto/dotfiles.git
```
