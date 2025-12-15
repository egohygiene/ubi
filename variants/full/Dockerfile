######################################################################
# UBI Full Variant
#
# This is the full-featured "kitchen sink" version of UBI combining
# Python and Node.js development tools.
# Includes Python 3.13, Node.js v20, and their package managers.
#
# Use this variant when:
# - Working in polyglot environments
# - Need maximum flexibility for heavy workflows
# - Building devcontainers for large, multi-language projects
######################################################################

######################################################################
# BASE IMAGE VERSION PINNING
#
# CURRENT VERSION: 2.1.2
# CURRENT DIGEST: sha256:36751f1ee2f30745a649afc2b2061f321bacdaa0617159901fe6725b34c93df4
# LAST UPDATED: 2025-12-12
######################################################################
FROM mcr.microsoft.com/devcontainers/base:2.1.2@sha256:36751f1ee2f30745a649afc2b2061f321bacdaa0617159901fe6725b34c93df4 AS base

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

FROM environment AS python-tools

######################################################################
# INSTALL PYTHON DEVELOPMENT TOOLS
######################################################################

# Install Python build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Poetry for Python package management via pip
# Note: This may fail in restricted environments (e.g., externally-managed-environment error)
# Core Python tooling (python3, pip, venv) is always available
RUN python3 -m pip install --user poetry 2>/dev/null || echo "Poetry installation skipped (restricted environment)" \
  && if [ -f /root/.local/bin/poetry ]; then ln -s /root/.local/bin/poetry ${UNIVERSAL_BIN}/poetry; fi

# Set up pyenv environment variables for future manual installation
# Users can install pyenv manually using: curl https://pyenv.run | bash
ENV PYENV_ROOT="${UNIVERSAL_TOOLBOX}/pyenv"
ENV PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

FROM python-tools AS node-tools

######################################################################
# INSTALL NODE.JS DEVELOPMENT TOOLS
######################################################################

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
# Validates container health by checking bash, python3, and node availability.
# This ensures the shell environment and both language runtimes are operational.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD test -x /bin/bash && command -v python3 >/dev/null 2>&1 && command -v node >/dev/null 2>&1 || exit 1

######################################################################
# Final container command
######################################################################
CMD ["bash", "-lc", "sleep infinity"]
