# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

##################################################
# history settings
##################################################
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY


##################################################
# powerlevel10k settings
##################################################
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] || source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ ! -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] || source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

##################################################
# make PATH
##################################################
export PATH="$HOME/.local/bin:$PATH"

##################################################
# enable self-made commands
##################################################
DOTFILES_DIR="$HOME/dotfiles"
export PATH="$DOTFILES_DIR/command:$PATH"
declare cmds=("dotfiles")
for cmd in "${cmds[@]}"; do
  source "$DOTFILES_DIR/zsh/compdef/_$cmd.zsh"
done

##################################################
# zsh-syntax-highlighting and zsh-autosuggestions
##################################################
[[ ! -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] || source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] || source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


##################################################
# fzf
##################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

##################################################
# better ls by eza
##################################################
alias ls="eza --color=always --icons=always --git --no-filesize --no-time --no-user --no-permissions --group-directories-first --sort=type"

##################################################
# better cd by zoxide
##################################################
eval "$(zoxide init zsh)"
alias cd=z

##################################################
# brew
##################################################
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


##################################################
# xsel
##################################################
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

##################################################
# other minor settings
##################################################
# make less more friendly for non-text input files, see lesspipe(1)
if (( $+commands[lesspipe] )); then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

# terraform cmd compleition and alias
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
alias tf="terraform"
compdef tf="terraform"

source $HOME/.config/broot/launcher/bash/br
