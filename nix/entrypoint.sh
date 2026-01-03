#!/usr/bin/env bash
set -e

# Source Nix profile so commands are available
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

# Since you want to use flakes, we can default the shell to your flake
if [[ $# -eq 0 ]]; then
    exec nix develop /opt/nix --command bash
else
    exec "$@"
fi
