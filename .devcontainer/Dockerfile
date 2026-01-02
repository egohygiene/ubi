######################################################################
# Development container image
#
# This Dockerfile builds the image used by the VS Code devcontainer.
# It extends the official devcontainers base image and installs a
# collection of common build tools, language runtimes and utilities.
######################################################################

######################################################################
# BASE IMAGE VERSION PINNING
#
# WHY: The base image is pinned to a specific version and digest to ensure:
#      - Reproducible builds across all environments
#      - Protection against breaking changes from upstream
#      - Stable CI/CD pipelines without unexpected drift
#      - Security traceability and audit compliance
#
# UPDATING: To update the base image version:
#   1. Check for new releases at:
#      https://github.com/devcontainers/images/releases
#      Or query available tags:
#      curl -s https://mcr.microsoft.com/v2/devcontainers/base/tags/list | \
#        jq -r '.tags[] | select(. | test("^[0-9]+\\.[0-9]+"))' | sort -V
#   2. Pull the new version locally:
#      docker pull mcr.microsoft.com/devcontainers/base:<version>
#   3. Get the digest:
#      docker inspect mcr.microsoft.com/devcontainers/base:<version> \
#        --format='{{index .RepoDigests 0}}'
#   4. Update the FROM line below with the new version and digest
#   5. Test the build thoroughly before committing
#   6. Document the change in your PR description
#
# CURRENT VERSION: 2.1.2
# CURRENT DIGEST: sha256:36751f1ee2f30745a649afc2b2061f321bacdaa0617159901fe6725b34c93df4
# LAST UPDATED: 2025-12-12
######################################################################
FROM mcr.microsoft.com/devcontainers/base:2.1.3@sha256:30b0a0c004ca94d36c323ee993361a7e0ae25ea255ea125201e8a9587501c324 AS base

# Safer shell defaults
SHELL ["/bin/bash", "-o", "errexit", "-o", "errtrace", "-o", "functrace", "-o", "nounset", "-o", "pipefail", "-c"]

FROM base AS environment

######################################################################
# ARG DEFINITIONS
######################################################################

# System + locale
ARG TMPDIR=/tmp
ARG LANG=en_US.UTF-8
ARG LANGUAGE=en_US:en
ARG LC_ALL=en_US.UTF-8
ARG TZ=UTC

# UX Preferences
ARG EDITOR=code
ARG VISUAL=code
ARG PAGER=less
ARG GIT_PAGER=less
ARG TERM=xterm-256color
ARG COLORTERM=truecolor
ARG CLICOLOR=1
ARG CLICOLOR_FORCE=1
ARG FORCE_COLOR=1
ARG GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
ARG LESS="-R"

# Node memory config
ARG NODE_OPTIONS="--max-old-space-size=4096 --max-semi-space-size=512"

# Rust UX
ARG CARGO_TERM_COLOR=always

# Telemetry controls
ARG DO_NOT_TRACK=1
ARG TELEMETRY_ENABLED=0
ARG NEXT_TELEMETRY_DISABLED=1
ARG YARN_ENABLE_TELEMETRY=false
ARG DOTNET_CLI_TELEMETRY_OPTOUT=1
ARG GATSBY_TELEMETRY_DISABLED=1
ARG NUXT_TELEMETRY_DISABLED=1
ARG CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true
ARG STRIPE_CLI_TELEMETRY_OPTOUT=1

# Python behavior
ARG PYTHONWARNINGS=default
ARG PYTHONFAULTHANDLER=1
ARG PYTHONHASHSEED=random
ARG PYTHONUNBUFFERED=1
ARG PYTHONUTF8=1
ARG PYTHONIOENCODING=UTF-8
ARG PIP_DEFAULT_TIMEOUT=200
ARG PIP_DISABLE_PIP_VERSION_CHECK=on
ARG PIP_NO_CACHE_DIR=1
ARG PIP_NO_WARN_SCRIPT_LOCATION=on

######################################################################
# FIXED PLATFORM-LEVEL ENVIRONMENT VARIABLES
######################################################################

# Workspace home
ENV WORKSPACE_HOME=/workspace

# Universal filesystem layout
ENV UNIVERSAL_HOME=/opt/universal \
    UNIVERSAL_BIN=/opt/universal/bin \
    UNIVERSAL_TOOLBOX=/opt/universal/toolbox \
    UNIVERSAL_CACHE=/opt/universal/cache \
    UNIVERSAL_LOGS=/opt/universal/logs \
    UNIVERSAL_CONFIG=/opt/universal/config \
    UNIVERSAL_LIB=/opt/universal/lib \
    UNIVERSAL_LOCKS=/opt/universal/locks \
    UNIVERSAL_FONTS=/opt/universal/fonts \
    UNIVERSAL_RUNTIME=/opt/universal/runtime \
    UNIVERSAL_APPS=/opt/universal/apps \
    UNIVERSAL_REPORTS=/opt/universal/reports \
    APT_CACHE_DIR=/opt/universal/cache/apt

######################################################################
# BASE ENVIRONMENT
######################################################################
ENV \
    ##################################################################
    # Locale + system
    ##################################################################
    LANG=${LANG} \
    LANGUAGE=${LANGUAGE} \
    LC_ALL=${LC_ALL} \
    TZ=${TZ} \
    TMPDIR=${TMPDIR} \
    TERM=${TERM} \
    COLORTERM=${COLORTERM} \
    LESS=${LESS} \
    CLICOLOR=${CLICOLOR} \
    CLICOLOR_FORCE=${CLICOLOR_FORCE} \
    FORCE_COLOR=${FORCE_COLOR} \
    GCC_COLORS=${GCC_COLORS} \
    EDITOR=${EDITOR} \
    VISUAL=${VISUAL} \
    PAGER=${PAGER} \
    GIT_PAGER=${GIT_PAGER} \
    ##################################################################
    # Python defaults
    ##################################################################
    PYTHONUNBUFFERED=${PYTHONUNBUFFERED} \
    PYTHONIOENCODING=${PYTHONIOENCODING} \
    PYTHONUTF8=${PYTHONUTF8} \
    PYTHONHASHSEED=${PYTHONHASHSEED} \
    PYTHONFAULTHANDLER=${PYTHONFAULTHANDLER} \
    PYTHONWARNINGS=${PYTHONWARNINGS} \
    PIP_NO_CACHE_DIR=${PIP_NO_CACHE_DIR} \
    PIP_DISABLE_PIP_VERSION_CHECK=${PIP_DISABLE_PIP_VERSION_CHECK} \
    PIP_NO_WARN_SCRIPT_LOCATION=${PIP_NO_WARN_SCRIPT_LOCATION} \
    PIP_DEFAULT_TIMEOUT=${PIP_DEFAULT_TIMEOUT} \
    PIP_ROOT_USER_ACTION=ignore \
    ##################################################################
    # Node / Rust
    ##################################################################
    NODE_OPTIONS="${NODE_OPTIONS}" \
    CARGO_TERM_COLOR=${CARGO_TERM_COLOR} \
    ##################################################################
    # Telemetry toggles
    ##################################################################
    DO_NOT_TRACK=${DO_NOT_TRACK} \
    TELEMETRY_ENABLED=${TELEMETRY_ENABLED} \
    NEXT_TELEMETRY_DISABLED=${NEXT_TELEMETRY_DISABLED} \
    YARN_ENABLE_TELEMETRY=${YARN_ENABLE_TELEMETRY} \
    DOTNET_CLI_TELEMETRY_OPTOUT=${DOTNET_CLI_TELEMETRY_OPTOUT} \
    GATSBY_TELEMETRY_DISABLED=${GATSBY_TELEMETRY_DISABLED} \
    NUXT_TELEMETRY_DISABLED=${NUXT_TELEMETRY_DISABLED} \
    CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=${CLOUDSDK_CORE_DISABLE_USAGE_REPORTING} \
    STRIPE_CLI_TELEMETRY_OPTOUT=${STRIPE_CLI_TELEMETRY_OPTOUT} \
    ##################################################################
    # Debian noninteractive install behavior
    ##################################################################
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_PRIORITY=critical \
    DEBCONF_NOWARNINGS=yes \
    APT_LISTCHANGES_FRONTEND=none \
    APT_LISTBUGS_FRONTEND=none

######################################################################
# XDG DIRECTORY OVERRIDES
# - https://wiki.archlinux.org/title/XDG_Base_Directory
# - https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# Add user application .desktop files to gnome.
# https://help.gnome.org/admin//system-admin-guide/2.32/menustructure-desktopentry.html.en
######################################################################
ENV \
    XDG_CONFIG_HOME=${UNIVERSAL_CONFIG} \
    XDG_CACHE_HOME=${UNIVERSAL_CACHE} \
    XDG_DATA_HOME=${UNIVERSAL_TOOLBOX} \
    XDG_STATE_HOME=${UNIVERSAL_RUNTIME} \
    XDG_CONFIG_DIRS="${UNIVERSAL_CONFIG}:/etc/xdg" \
    XDG_DATA_DIRS="${UNIVERSAL_APPS}:/usr/local/share:/usr/share"

######################################################################
# CREATE UNIVERSAL DIRECTORIES
######################################################################
RUN mkdir -p \
    ${UNIVERSAL_BIN} \
    ${UNIVERSAL_TOOLBOX} \
    ${UNIVERSAL_CACHE} \
    ${UNIVERSAL_LOGS} \
    ${UNIVERSAL_CONFIG} \
    ${UNIVERSAL_LIB} \
    ${UNIVERSAL_LOCKS} \
    ${UNIVERSAL_FONTS} \
    ${UNIVERSAL_RUNTIME} \
    ${UNIVERSAL_APPS} \
    ${UNIVERSAL_REPORTS} \
  && chown -R vscode:vscode ${UNIVERSAL_HOME}

FROM environment AS nix-setup

######################################################################
# INSTALL NIX PACKAGE MANAGER (SINGLE-USER MODE)
######################################################################
# Install Nix in single-user mode for the vscode user.
# Single-user mode is appropriate for devcontainers where:
# - Only one user (vscode) needs access to Nix
# - We want to avoid the complexity of the Nix daemon
# - File ownership needs to be clear and simple
#
# Reference: https://nixos.org/download.html#nix-install-linux
######################################################################

# Dependencies (curl, ca-certificates, xz-utils) are already present in base image

# Create /nix directory and set ownership to vscode user
RUN mkdir -p /nix \
  && chown -R vscode:vscode /nix

# Switch to vscode user to install Nix in single-user mode
USER vscode

# Download and run Nix installer in single-user mode
# Using a specific version for reproducibility and security
# Version 2.18.1 is a stable release
# Alternative: Pin to latest stable via https://releases.nixos.org/nix/nix-2.18.1/install
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# Add Nix to PATH for all shells
RUN echo 'if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.bashrc \
  && echo 'if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.profile

# Switch back to root for final setup
USER root

# Ensure /nix ownership is correct after installation
# This is critical because:
# 1. The Nix installer creates subdirectories under /nix
# 2. If the vscode user's UID changes (via updateRemoteUserUID), ownership must be fixed
# 3. This ensures Nix commands can write to the store
RUN chown -R vscode:vscode /nix

FROM nix-setup AS final

######################################################################
# HEALTHCHECK
######################################################################
# Validates container health by checking bash executable availability.
# This ensures the container's fundamental shell environment is operational.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD test -x /bin/bash || exit 1

######################################################################
# Final container command
######################################################################
CMD ["bash", "-lc", "sleep infinity"]
