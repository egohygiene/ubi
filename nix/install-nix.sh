#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Configuration (environment-driven with safe defaults)
###############################################################################

readonly DEFAULT_NIX_VERSION="2.33.0"
readonly DEFAULT_NIX_INSTALL_MODE="daemon"

NIX_VERSION="${NIX_VERSION:-${DEFAULT_NIX_VERSION}}"
NIX_INSTALL_MODE="${NIX_INSTALL_MODE:-${DEFAULT_NIX_INSTALL_MODE}}"

readonly INSTALL_URL="https://releases.nixos.org/nix/nix-${NIX_VERSION}/install"

###############################################################################
# Logging helpers
###############################################################################

log_info() {
    printf "[INFO] %s\n" "$1"
}

log_error() {
    printf "[ERROR] %s\n" "$1" >&2
}

###############################################################################
# Dependency installation
###############################################################################

install_system_dependencies() {
    log_info "Installing system dependencies required for Nix installation"

    apt-get update

    apt-get install \
        --yes \
        --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        findutils \
        git \
        gnupg2 \
        xz-utils
}

###############################################################################
# Nix installation
###############################################################################

install_nix() {
    log_info "Installing Nix ${NIX_VERSION}"
    log_info "Installation mode: ${NIX_INSTALL_MODE}"
    log_info "Download URL: ${INSTALL_URL}"

    case "${NIX_INSTALL_MODE}" in
        daemon)
            curl \
                --fail \
                --location \
                --silent \
                --show-error \
                --proto "=https" \
                --tlsv1.2 \
                "${INSTALL_URL}" \
                | sh -s -- --daemon
            ;;
        single-user)
            curl \
                --fail \
                --location \
                --silent \
                --show-error \
                --proto "=https" \
                --tlsv1.2 \
                "${INSTALL_URL}" \
                | sh -s --
            ;;
        *)
            log_error "Invalid NIX_INSTALL_MODE: ${NIX_INSTALL_MODE}"
            log_error "Valid values: daemon | single-user"
            exit 1
            ;;
    esac
}

###############################################################################
# Cleanup
###############################################################################

cleanup_package_manager_cache() {
    log_info "Cleaning up apt package lists"

    rm -rf /var/lib/apt/lists/*
}

###############################################################################
# Main entrypoint
###############################################################################

main() {
    log_info "Starting Nix installation"
    log_info "Effective configuration:"
    log_info "  NIX_VERSION=${NIX_VERSION}"
    log_info "  NIX_INSTALL_MODE=${NIX_INSTALL_MODE}"

    install_system_dependencies
    install_nix
    cleanup_package_manager_cache

    log_info "Nix installation completed successfully"
}

###############################################################################
# Script execution
###############################################################################

main "$@"
