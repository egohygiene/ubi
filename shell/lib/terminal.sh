# lib/terminal.sh
#
# Terminal / TTY detection helpers.

terminal::is_tty() {
  [[ -t 1 ]]
}

terminal::has_term() {
  [[ -n "${TERM:-}" ]]
}

terminal::is_interactive_term() {
  terminal::is_tty && terminal::has_term
}
