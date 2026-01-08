#!/usr/bin/env bash
# shellcheck shell=bash

###############################################################################
# Strict mode — fail fast, fail loud
###############################################################################
set -Eeuo pipefail
IFS=$'\n\t'

###############################################################################
# Defaults (only used if env vars are missing)
###############################################################################
readonly DEFAULT_WORKSPACE_DIR="/workspace"

###############################################################################
# Logging helpers
###############################################################################
log() {
  printf '[entrypoint] %s\n' "$*" >&2
}

die() {
  log "ERROR: $*"
  exit 1
}

###############################################################################
# Cleanup & error handling
###############################################################################
cleanup() {
  # Reserved for future cleanup logic
  :
}

on_error() {
  local exit_code=$?
  die "Entrypoint failed with exit code ${exit_code}"
}

trap cleanup EXIT
trap on_error ERR

###############################################################################
# Nix initialization
###############################################################################
init_nix() {
  if [[ -z "${NIX_DEFAULT_PROFILE_SCRIPT:-}" ]]; then
    die "NIX_DEFAULT_PROFILE_SCRIPT is not set"
  fi

  if [[ ! -f "${NIX_DEFAULT_PROFILE_SCRIPT}" ]]; then
    die "Nix profile script not found at ${NIX_DEFAULT_PROFILE_SCRIPT}"
  fi

  # shellcheck disable=SC1090
  . "${NIX_DEFAULT_PROFILE_SCRIPT}"
}

###############################################################################
# Enter flake-based dev environment
###############################################################################
enter_flake_shell() {
  local workspace_dir="${WORKSPACE_DIR:-${DEFAULT_WORKSPACE_DIR}}"
  local flake_dir="${UBI_NIX_FLAKE_DIR:-${workspace_dir}}"

  if [[ ! -d "${flake_dir}" ]]; then
    die "Flake directory does not exist: ${flake_dir}"
  fi

  if [[ ! -f "${flake_dir}/flake.nix" ]]; then
    die "flake.nix not found in ${flake_dir}"
  fi

  log "Using workspace directory: ${workspace_dir}"
  log "Using Nix flake directory: ${flake_dir}"
  log "Entering Nix devShell"

  exec "${NIX_BIN:-}" develop "${flake_dir}"
}

###############################################################################
# Main
###############################################################################
main() {
  init_nix

  if [[ $# -eq 0 ]]; then
    # No command provided → default to flake dev environment
    enter_flake_shell
  else
    # Command provided → behave like a normal container
    log "Executing command: $*"
    exec "$@"
  fi
}

main "$@"
