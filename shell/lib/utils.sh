# lib/utils.sh
#
# Small utility helpers shared across the shell framework.

# ------------------------------------------------------------------------------
# util::join_by
#
# Joins arguments by a delimiter.
# Example: util::join_by ":" a b c
# ------------------------------------------------------------------------------
util::join_by() {
  local delimiter="$1"
  shift
  local first="$1"
  shift
  printf '%s' "${first}"
  for item in "$@"; do
    printf '%s%s' "${delimiter}" "${item}"
  done
  printf '\n'
}

# ------------------------------------------------------------------------------
# util::trim
#
# Trims leading and trailing whitespace.
# ------------------------------------------------------------------------------
util::trim() {
  local var="$*"
  # shellcheck disable=SC2001
  printf '%s\n' "$(echo "${var}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
}

# ------------------------------------------------------------------------------
# util::lower
# ------------------------------------------------------------------------------
util::lower() {
  printf '%s\n' "$*" | tr '[:upper:]' '[:lower:]'
}

# ------------------------------------------------------------------------------
# util::upper
# ------------------------------------------------------------------------------
util::upper() {
  printf '%s\n' "$*" | tr '[:lower:]' '[:upper:]'
}
