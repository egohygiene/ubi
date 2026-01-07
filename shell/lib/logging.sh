# lib/logging.sh
#
# Structured logging helpers.
# Depends on: terminal.sh, colors.sh, time.sh

log::__print() {
  local level="$1" emoji="$2" color="$3"
  shift 3
  local message="$*"

  local timestamp
  timestamp="$(time::timestamp)"

  local label
  label="$(printf '%s' "${level}" | tr '[:lower:]' '[:upper:]')"

  if terminal::is_interactive_term; then
    printf '%s %b%-10s%b %s\n' \
      "${timestamp}" \
      "${color}" "${emoji} ${label}:" "$(color::reset)" \
      "${message}" >&2
  else
    printf '%s %-10s %s\n' \
      "${timestamp}" "${emoji} ${label}:" \
      "${message}" >&2
  fi
}

log::info()    { log::__print info    "🔹" "$(color::blue)"   "$@"; }
log::warn()    { log::__print warn    "⚠️"  "$(color::yellow)" "$@"; }
log::error()   { log::__print error   "❌"  "$(color::red)"    "$@"; }
log::success() { log::__print success "✅"  "$(color::green)"  "$@"; }

log::debug() {
  [[ "${UBI_DEBUG:-0}" == "1" ]] || return 0
  log::__print debug "🐞" "$(color::gray)" "$@"
}
