# functions/ssh.sh
#
# SSH-related helper functions.
#
# This file defines operational helpers and is intended to be sourced.
# It must not exit, exec, or modify global shell options.

# ------------------------------------------------------------------------------
# ssh::add_known_hosts
#
# Adds SSH host keys for one or more domains to ~/.ssh/known_hosts.
#
# Usage:
#   ssh::add_known_hosts github.com gitlab.com
#
# Behavior:
# - Creates ~/.ssh if it does not exist
# - Ensures correct permissions
# - Appends keys if scanning succeeds
# - Continues on per-host failures
#
# Returns:
# - 0 if function completes
# - Non-zero only for fatal setup errors
# ------------------------------------------------------------------------------

ssh::add_known_hosts() {
  local domains=("$@")

  if [[ "${#domains[@]}" -eq 0 ]]; then
    log::warn "ssh::add_known_hosts called with no domains"
    return 0
  fi

  # Ensure ssh-keyscan exists
  if ! guard::has_command ssh-keyscan; then
    log::error "ssh-keyscan is not available"
    return 1
  fi

  # Ensure ~/.ssh exists with correct permissions
  if [[ ! -d "${HOME}/.ssh" ]]; then
    log::info "Creating ~/.ssh directory"
    mkdir -p "${HOME}/.ssh" || return 1
    chmod 700 "${HOME}/.ssh" || return 1
  fi

  local known_hosts="${HOME}/.ssh/known_hosts"

  for domain in "${domains[@]}"; do
    log::info "Adding SSH host key for ${domain}"

    if ssh-keyscan "${domain}" >> "${known_hosts}" 2>/dev/null; then
      log::success "Added SSH key for ${domain}"
    else
      log::warn "Failed to scan SSH key for ${domain}"
    fi
  done
}
