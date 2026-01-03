#!/usr/bin/env bash
set -euo pipefail

readonly DEFAULT_NIX_VERSION="2.33.0"
readonly DEFAULT_NIX_INSTALL_MODE="single-user"

NIX_VERSION="${NIX_VERSION:-${DEFAULT_NIX_VERSION}}"
NIX_INSTALL_MODE="${NIX_INSTALL_MODE:-${DEFAULT_NIX_INSTALL_MODE}}"

readonly INSTALL_URL="https://releases.nixos.org/nix/nix-${NIX_VERSION}/install"

log_info() {
    printf "[INFO] %s\n" "$1"
}

install_nix() {
    log_info "Installing Nix ${NIX_VERSION} (${NIX_INSTALL_MODE})"

    case "${NIX_INSTALL_MODE}" in
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
            echo "[ERROR] Only single-user install supported in this image"
            exit 1
            ;;
    esac
}

install_nix
log_info "Nix installation complete"
