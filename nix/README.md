# Nix Toolchain (Universal Devcontainer)

This directory defines the Nix-based toolchain for the Universal devcontainer.

## Files

- `flake.nix`
  Defines all pinned tools and runtimes.

- `flake.lock`
  Locks exact versions. Must be committed.

- `nix.conf`
  System-level Nix configuration for containers.

- `install-nix.sh`
  Build-time installer (multi-user daemon).

- `entrypoint.sh`
  Starts nix-daemon at runtime if needed.

## Design Principles

- No `nix-env`
- No single-user installs
- No runtime mutation
- Deterministic builds
- Works for any user

## Updating Tools

1. Edit `flake.nix`
2. Run `nix flake update`
3. Commit `flake.lock`
4. Rebuild container
