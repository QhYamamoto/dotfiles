#compdef my-cli-tool

autoload -U is-at-least

_my-cli-tool() {
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
    ":: :_my-cli-tool_commands" \
    "*::: :->my-cli-tool" \
    && ret=0
  case $state in
      (my-cli-tool)
      words=($line[1] "${words[@]}")
      (( CURRENT += 1 ))
      curcontext="${curcontext%:*:*}:my-cli-tool-command-$line[1]:"
      case $line[1] in
          (init)
          _arguments "${_arguments_options[@]}" : \
            '-h[Print help]' \
            '--help[Print help]' \
            && ret=0
          ;;
          (git)
          _arguments "${_arguments_options[@]}" : \
            '-h[Print help]' \
            '--help[Print help]' \
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
            ":: :_my-cli-tool__help_commands" \
            "*::: :->help" \
            && ret=0

          case $state in
              (help)
              words=($line[1] "${words[@]}")
              (( CURRENT += 1 ))
              curcontext="${curcontext%:*:*}:my-cli-tool-help-command-$line[1]:"
              case $line[1] in
                  (init)
                  _arguments "${_arguments_options[@]}" : \
                    && ret=0
                  ;;
                  (git)
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

(( $+functions[_my-cli-tool_commands] )) ||
_my-cli-tool_commands() {
  local commands; commands=(
    'init:Initialize dotfiles settings.' \
      'git:Add ssh setting for git service.' \
      'completion:Generate shell completion scripts' \
      'help:Print this message or the help of the given subcommand(s)' \
    )
  _describe -t commands 'my-cli-tool commands' commands "$@"
}
(( $+functions[_my-cli-tool__completion_commands] )) ||
_my-cli-tool__completion_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool completion commands' commands "$@"
}
(( $+functions[_my-cli-tool__git_commands] )) ||
_my-cli-tool__git_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool git commands' commands "$@"
}
(( $+functions[_my-cli-tool__help_commands] )) ||
_my-cli-tool__help_commands() {
  local commands; commands=(
    'init:Initialize dotfiles settings.' \
      'git:Add ssh setting for git service.' \
      'completion:Generate shell completion scripts' \
      'help:Print this message or the help of the given subcommand(s)' \
    )
  _describe -t commands 'my-cli-tool help commands' commands "$@"
}
(( $+functions[_my-cli-tool__help__completion_commands] )) ||
_my-cli-tool__help__completion_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool help completion commands' commands "$@"
}
(( $+functions[_my-cli-tool__help__git_commands] )) ||
_my-cli-tool__help__git_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool help git commands' commands "$@"
}
(( $+functions[_my-cli-tool__help__help_commands] )) ||
_my-cli-tool__help__help_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool help help commands' commands "$@"
}
(( $+functions[_my-cli-tool__help__init_commands] )) ||
_my-cli-tool__help__init_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool help init commands' commands "$@"
}
(( $+functions[_my-cli-tool__init_commands] )) ||
_my-cli-tool__init_commands() {
  local commands; commands=()
  _describe -t commands 'my-cli-tool init commands' commands "$@"
}

if [ "$funcstack[1]" = "_my-cli-tool" ]; then
  _my-cli-tool "$@"
else
  compdef _my-cli-tool my-cli-tool
fi
