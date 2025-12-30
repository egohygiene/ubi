#!/usr/bin/env bash
set -euo pipefail

NIX_VERSION="${NIX_VERSION:-2.33.0}"
INSTALL_URL="https://releases.nixos.org/nix/nix-${NIX_VERSION}/install"

echo "Installing Nix ${NIX_VERSION} (multi-user daemon mode)"

apt-get update
apt-get install --yes --no-install-recommends \
    curl \
    ca-certificates \
    gnupg2 \
    dirmngr \
    xz-utils \
    git \
    findutils

curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --proto '=https' --tlsv1.2 \
    "${INSTALL_URL}" \
| sh -s -- --daemon

rm -rf /var/lib/apt/lists/*
