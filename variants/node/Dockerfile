######################################################################
# UBI Node Variant
#
# This variant extends UBI Minimal with Node.js development tools.
# Includes Node.js v20 (LTS) runtime and npm.
# pnpm and yarn are installed when possible; nvm can be installed manually.
#
# Use this variant when:
# - Building JavaScript/TypeScript applications
# - Require Node package management (npm, pnpm, yarn)
# - Need Node.js build tools
######################################################################

######################################################################
# BASE IMAGE VERSION PINNING
#
# CURRENT VERSION: 2.1.3
# CURRENT DIGEST: sha256:30b0a0c004ca94d36c323ee993361a7e0ae25ea255ea125201e8a9587501c324
# LAST UPDATED: 2025-12-19
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

# Telemetry controls
ARG DO_NOT_TRACK=1
ARG TELEMETRY_ENABLED=0
ARG NEXT_TELEMETRY_DISABLED=1
ARG YARN_ENABLE_TELEMETRY=false

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
    # Node
    ##################################################################
    NODE_OPTIONS="${NODE_OPTIONS}" \
    ##################################################################
    # Telemetry toggles
    ##################################################################
    DO_NOT_TRACK=${DO_NOT_TRACK} \
    TELEMETRY_ENABLED=${TELEMETRY_ENABLED} \
    NEXT_TELEMETRY_DISABLED=${NEXT_TELEMETRY_DISABLED} \
    YARN_ENABLE_TELEMETRY=${YARN_ENABLE_TELEMETRY} \
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

FROM environment AS node-tools

######################################################################
# INSTALL NODE.JS DEVELOPMENT TOOLS
######################################################################

# Install Node.js build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm via apt
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install pnpm and yarn globally
# Note: This may fail in restricted environments (e.g., certificate issues)
# Core Node.js tooling (node, npm) is always available
RUN npm install -g pnpm yarn 2>/dev/null || echo "pnpm/yarn installation skipped (restricted environment)"

# Set up nvm environment variables for future manual installation
# Users can install nvm manually using: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR="${UNIVERSAL_TOOLBOX}/nvm"

FROM node-tools AS final

######################################################################
# HEALTHCHECK
######################################################################
# Validates container health by checking bash and node availability.
# This ensures both the shell environment and Node.js runtime are operational.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD test -x /bin/bash && command -v node >/dev/null 2>&1 || exit 1

######################################################################
# Final container command
######################################################################
CMD ["bash", "-lc", "sleep infinity"]
