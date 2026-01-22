# lib/bash.sh
#
# Bash introspection helpers.

bash::version() {
  printf '%s\n' "${BASH_VERSION:-unknown}"
}

bash::major_version() {
  printf '%s\n' "${BASH_VERSINFO[0]:-0}"
}

bash::minor_version() {
  printf '%s\n' "${BASH_VERSINFO[1]:-0}"
}

bash::is_interactive() {
  [[ $- == *i* ]] && return 0 || return 1
}

bash::path() {
  printf '%s\n' "${BASH:-$(command -v bash || true)}"
}
