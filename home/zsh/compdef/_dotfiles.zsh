#compdef dotfiles

autoload -U is-at-least

_dotfiles() {
  typeset -A opt_args
  typeset -a _arguments_options
  local ret=1

  if is-at-least 5.2; then
    _arguments_options=(-s -S -C)
  else
    _arguments_options=(-s -C)
  fi

  local context curcontext="$curcontext" state line
  _arguments "${_arguments_options[@]}" : \
    '-h[Print help]' \
    '--help[Print help]' \
    ":: :_dotfiles_commands" \
    "*::: :->dotfiles" \
    && ret=0
  case $state in
      (dotfiles)
      words=($line[1] "${words[@]}")
      (( CURRENT += 1 ))
      curcontext="${curcontext%:*:*}:dotfiles-command-$line[1]:"
      case $line[1] in
          (init)
          _arguments "${_arguments_options[@]}" : \
            '-h[Print help]' \
            '--help[Print help]' \
            && ret=0
          ;;
          (ahk)
          _arguments "${_arguments_options[@]}" : \
            '-h[Print help]' \
            '--help[Print help]' \
            && ret=0
          ;;
          (git)
          _arguments "${_arguments_options[@]}" : \
            '-H+[The Git host]:HOST:_default' \
            '--host=[The Git host]:HOST:_default' \
            '-u+[The Git username]:USER:_default' \
            '--user=[The Git username]:USER:_default' \
            '-e+[The Git user email]:EMAIL:_default' \
            '--email=[The Git user email]:EMAIL:_default' \
            '-k+[The SSH key pair name]:KEY:_default' \
            '--key=[The SSH key pair name]:KEY:_default' \
            '--overwrite-global-config[Overwrite global Git configuration (user.name and user.email)]' \
            '-h[Print help]' \
            '--help[Print help]' \
            && ret=0
          ;;
          (config)
          _arguments "${_arguments_options[@]}" : \
            '-h[Print help]' \
            '--help[Print help]' \
            ':tool -- The app name to configure:(broot lazydocker lazygit nvim wezterm)' \
            && ret=0
          ;;
          (completion)
          _arguments "${_arguments_options[@]}" : \
            '-h[Print help]' \
            '--help[Print help]' \
            ':shell -- The shell to generate the script for:(bash elvish fish powershell zsh)' \
            && ret=0
          ;;
          (help)
          _arguments "${_arguments_options[@]}" : \
            ":: :_dotfiles__help_commands" \
            "*::: :->help" \
            && ret=0

          case $state in
              (help)
              words=($line[1] "${words[@]}")
              (( CURRENT += 1 ))
              curcontext="${curcontext%:*:*}:dotfiles-help-command-$line[1]:"
              case $line[1] in
                  (init)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
                  (ahk)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
                  (git)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
                  (config)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
                  (completion)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
                  (help)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
              esac
              ;;
          esac
          ;;
      esac
      ;;
  esac
}

(( $+functions[_dotfiles_commands] )) ||
_dotfiles_commands() {
  local commands; commands=(
    'init:Initialize dotfiles settings.' \
      'ahk:Install ahk and reset its settings.' \
      'git:Add ssh setting for git service.' \
      'config:Open config directory of a specific tool in neovim.' \
      'completion:Generate shell completion scripts' \
      'help:Print this message or the help of the given subcommand(s)' \
    )
  _describe -t commands 'dotfiles commands' commands "$@"
}
(( $+functions[_dotfiles__ahk_commands] )) ||
_dotfiles__ahk_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles ahk commands' commands "$@"
}
(( $+functions[_dotfiles__completion_commands] )) ||
_dotfiles__completion_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles completion commands' commands "$@"
}
(( $+functions[_dotfiles__config_commands] )) ||
_dotfiles__config_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles config commands' commands "$@"
}
(( $+functions[_dotfiles__git_commands] )) ||
_dotfiles__git_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles git commands' commands "$@"
}
(( $+functions[_dotfiles__help_commands] )) ||
_dotfiles__help_commands() {
  local commands; commands=(
    'init:Initialize dotfiles settings.' \
      'ahk:Install ahk and reset its settings.' \
      'git:Add ssh setting for git service.' \
      'config:Open config directory of a specific tool in neovim.' \
      'completion:Generate shell completion scripts' \
      'help:Print this message or the help of the given subcommand(s)' \
    )
  _describe -t commands 'dotfiles help commands' commands "$@"
}
(( $+functions[_dotfiles__help__ahk_commands] )) ||
_dotfiles__help__ahk_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles help ahk commands' commands "$@"
}
(( $+functions[_dotfiles__help__completion_commands] )) ||
_dotfiles__help__completion_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles help completion commands' commands "$@"
}
(( $+functions[_dotfiles__help__config_commands] )) ||
_dotfiles__help__config_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles help config commands' commands "$@"
}
(( $+functions[_dotfiles__help__git_commands] )) ||
_dotfiles__help__git_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles help git commands' commands "$@"
}
(( $+functions[_dotfiles__help__help_commands] )) ||
_dotfiles__help__help_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles help help commands' commands "$@"
}
(( $+functions[_dotfiles__help__init_commands] )) ||
_dotfiles__help__init_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles help init commands' commands "$@"
}
(( $+functions[_dotfiles__init_commands] )) ||
_dotfiles__init_commands() {
  local commands; commands=()
  _describe -t commands 'dotfiles init commands' commands "$@"
}

if [ "$funcstack[1]" = "_dotfiles" ]; then
  _dotfiles "$@"
else
  compdef _dotfiles dotfiles
fi
