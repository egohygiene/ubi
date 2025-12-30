#!/usr/bin/env bash
set -e

if ! pgrep nix-daemon > /dev/null; then
    echo "Starting nix-daemon..."
    /nix/var/nix/profiles/default/bin/nix-daemon &
fi

exec "$@"
