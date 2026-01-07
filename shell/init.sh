# init.sh
#
# Universal Shell Framework Entry Point
#
# Rules:
# - Safe to source multiple times
# - Core libs load unconditionally
# - UX features load only in interactive shells
# - Never exit or exec

# ------------------------------------------------------------------------------
# Guard against double initialization
# ------------------------------------------------------------------------------

if [ -n "${UBI_SHELL_INITIALIZED:-}" ]; then
  return
fi
export UBI_SHELL_INITIALIZED=1

# ------------------------------------------------------------------------------
# Allow disabling the framework entirely
# ------------------------------------------------------------------------------

if [ "${UBI_SHELL_DISABLE:-0}" = "1" ]; then
  return
fi

# ------------------------------------------------------------------------------
# Resolve shell root
# ------------------------------------------------------------------------------

UNIVERSAL_SHELL="${UNIVERSAL_SHELL:-/opt/universal/shell}"

# ------------------------------------------------------------------------------
# Core libraries (ALWAYS LOADED)
# ------------------------------------------------------------------------------

# Guards must come first
[ -f "${UNIVERSAL_SHELL}/lib/guards.sh" ] && . "${UNIVERSAL_SHELL}/lib/guards.sh"

# Logging next
[ -f "${UNIVERSAL_SHELL}/lib/logging.sh" ] && . "${UNIVERSAL_SHELL}/lib/logging.sh"

# Utilities last
[ -f "${UNIVERSAL_SHELL}/lib/utils.sh" ] && . "${UNIVERSAL_SHELL}/lib/utils.sh"

# ------------------------------------------------------------------------------
# Stop here for non-interactive shells
# ------------------------------------------------------------------------------

guard::is_interactive || return

# ------------------------------------------------------------------------------
# Interactive-only features
# ------------------------------------------------------------------------------

# Environment (safe exports only)
[ -f "${UNIVERSAL_SHELL}/env.sh" ] && . "${UNIVERSAL_SHELL}/env.sh"

# Functions
for fn in "${UNIVERSAL_SHELL}/functions/"*.sh; do
  [ -f "$fn" ] && . "$fn"
done

# Aliases
[ -f "${UNIVERSAL_SHELL}/aliases.sh" ] && . "${UNIVERSAL_SHELL}/aliases.sh"

# Prompt (last)
[ -f "${UNIVERSAL_SHELL}/prompt/prompt.sh" ] && . "${UNIVERSAL_SHELL}/prompt/prompt.sh"
