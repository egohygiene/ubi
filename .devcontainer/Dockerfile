######################################################################
# Development container image
#
# This Dockerfile builds the image used by the VS Code devcontainer.
# It extends the official devcontainers base image and installs a
# collection of common build tools, language runtimes and utilities.
######################################################################

######################################################################
# BASE IMAGE VERSION PINNING
######################################################################
FROM mcr.microsoft.com/devcontainers/base:ubuntu@sha256:c1613dbcdafe28e4b36ede9f3cb84a96e76765f50b3aeee87cb589eeb4c6dbca AS base

# Safer shell defaults
SHELL ["/bin/bash", "-o", "errexit", "-o", "errtrace", "-o", "functrace", "-o", "nounset", "-o", "pipefail", "-c"]

FROM base AS environment

######################################################################
# ARG DEFINITIONS
######################################################################

ARG TMPDIR=/tmp
ARG LANG=en_US.UTF-8
ARG LANGUAGE=en_US:en
ARG LC_ALL=en_US.UTF-8
ARG TZ=UTC

ARG UBI_USER=vscode
ARG UBI_GROUP=vscode
ARG UBI_UID=1000
ARG UBI_GID=1000

ENV UBI_USER="${UBI_USER}" \
    UBI_GROUP="${UBI_GROUP}" \
    UBI_UID="${UBI_UID}" \
    UBI_GID="${UBI_GID}"

######################################################################
# UX / TOOLING / TELEMETRY SETTINGS
######################################################################

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
ARG NODE_OPTIONS="--max-old-space-size=4096 --max-semi-space-size=512"
ARG CARGO_TERM_COLOR=always

ARG DO_NOT_TRACK=1
ARG TELEMETRY_ENABLED=0
ARG NEXT_TELEMETRY_DISABLED=1
ARG YARN_ENABLE_TELEMETRY=false
ARG DOTNET_CLI_TELEMETRY_OPTOUT=1
ARG GATSBY_TELEMETRY_DISABLED=1
ARG NUXT_TELEMETRY_DISABLED=1
ARG CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true
ARG STRIPE_CLI_TELEMETRY_OPTOUT=1

ARG PYTHONWARNINGS=ignore
ARG PYTHONFAULTHANDLER=1
ARG PYTHONHASHSEED=random
ARG PYTHONUNBUFFERED=1
ARG PYTHONUTF8=1
ARG PYTHONIOENCODING=UTF-8
ARG PYTHONDONTWRITEBYTECODE=1
ARG PYTHONNOUSERSITE=1
ARG PIP_DEFAULT_TIMEOUT=200
ARG PIP_DISABLE_PIP_VERSION_CHECK=on
ARG PIP_NO_CACHE_DIR=1
ARG PIP_NO_WARN_SCRIPT_LOCATION=on

##################################################################
# C / C++ compiler noise
##################################################################
ARG NIX_CFLAGS_COMPILE="-w"
ARG CFLAGS="-w"
ARG CXXFLAGS="-w"
ARG CPPFLAGS="-w"

######################################################################
# UNIVERSAL FILESYSTEM LAYOUT
######################################################################
ENV WORKSPACE_HOME=/workspace

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
# BASE ENVIRONMENT VARIABLES
######################################################################
ENV \
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
    PYTHONUNBUFFERED=${PYTHONUNBUFFERED} \
    PYTHONIOENCODING=${PYTHONIOENCODING} \
    PYTHONUTF8=${PYTHONUTF8} \
    PYTHONHASHSEED=${PYTHONHASHSEED} \
    PYTHONFAULTHANDLER=${PYTHONFAULTHANDLER} \
    PYTHONWARNINGS=${PYTHONWARNINGS} \
    PYTHONDONTWRITEBYTECODE=${PYTHONDONTWRITEBYTECODE} \
    PYTHONNOUSERSITE=${PYTHONNOUSERSITE} \
    PIP_NO_CACHE_DIR=${PIP_NO_CACHE_DIR} \
    PIP_DISABLE_PIP_VERSION_CHECK=${PIP_DISABLE_PIP_VERSION_CHECK} \
    PIP_NO_WARN_SCRIPT_LOCATION=${PIP_NO_WARN_SCRIPT_LOCATION} \
    PIP_DEFAULT_TIMEOUT=${PIP_DEFAULT_TIMEOUT} \
    NODE_OPTIONS="${NODE_OPTIONS}" \
    CARGO_TERM_COLOR=${CARGO_TERM_COLOR} \
    DO_NOT_TRACK=${DO_NOT_TRACK} \
    TELEMETRY_ENABLED=${TELEMETRY_ENABLED} \
    NEXT_TELEMETRY_DISABLED=${NEXT_TELEMETRY_DISABLED} \
    YARN_ENABLE_TELEMETRY=${YARN_ENABLE_TELEMETRY} \
    DOTNET_CLI_TELEMETRY_OPTOUT=${DOTNET_CLI_TELEMETRY_OPTOUT} \
    GATSBY_TELEMETRY_DISABLED=${GATSBY_TELEMETRY_DISABLED} \
    NUXT_TELEMETRY_DISABLED=${NUXT_TELEMETRY_DISABLED} \
    CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=${CLOUDSDK_CORE_DISABLE_USAGE_REPORTING} \
    STRIPE_CLI_TELEMETRY_OPTOUT=${STRIPE_CLI_TELEMETRY_OPTOUT} \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_PRIORITY=critical \
    NIX_CFLAGS_COMPILE=${NIX_CFLAGS_COMPILE} \
    CFLAGS=${CFLAGS} \
    CXXFLAGS=${CXXFLAGS} \
    CPPFLAGS=${CPPFLAGS}

######################################################################
# XDG OVERRIDES
######################################################################
ENV \
    XDG_CONFIG_HOME=${UNIVERSAL_CONFIG} \
    XDG_CACHE_HOME=${UNIVERSAL_CACHE} \
    XDG_DATA_HOME=${UNIVERSAL_TOOLBOX} \
    XDG_STATE_HOME=${UNIVERSAL_RUNTIME} \
    XDG_CONFIG_DIRS="${UNIVERSAL_CONFIG}:/etc/xdg" \
    XDG_DATA_DIRS="${UNIVERSAL_APPS}:/usr/local/share:/usr/share"

######################################################################
# NIX BOOTSTRAP ENVIRONMENT
######################################################################
ENV NIX_CONF_DIR="${XDG_CONFIG_HOME}/nix" \
    NIX_DISABLE_SECCOMP="1"

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
  && chown -R ${UBI_USER}:${UBI_GROUP} ${UNIVERSAL_HOME}

######################################################################
# NIX INSTALLATION STAGE (single-user, correct ownership)
######################################################################
FROM environment AS nix

# Install prerequisites
USER root
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Prepare /nix so installer won't fail
RUN mkdir -p /nix && chown ${UBI_UID}:${UBI_GID} /nix

# Copy your repo-provided nix config folder
COPY --chown=${UBI_UID}:${UBI_GID} nix /opt/nix

# Install Nix (Determinate Systems Installer — safer & stable in Docker)
USER ${UBI_USER}

RUN curl --proto '=https' --tlsv1.2 --silent --show-error --location \
      https://install.determinate.systems/nix \
    | sh -s -- install linux \
        --init none \
        --no-confirm \
        --extra-conf "sandbox = false" \
        --extra-conf "filter-syscalls = false"

# Apply your custom nix.conf overrides
RUN mkdir -p "${NIX_CONF_DIR}" && \
    cp /opt/nix/nix.conf "${NIX_CONF_DIR}/nix.conf"


######################################################################
# FINAL IMAGE — this is what the devcontainer will run inside
######################################################################
FROM environment AS final

# Bring the initialized Nix store + installation forward
COPY --from=nix /nix /nix
COPY --from=nix /opt/nix /opt/nix

# FIX 1 — give your UBI user full ownership of the store
RUN chown -R ${UBI_UID}:${UBI_GID} /nix

# Remove incorrect directory if it exists, Nix requires a symlink
RUN rm -rf /home/${UBI_USER}/.nix-profile && \
    mkdir -p /nix/var/nix/profiles/per-user/${UBI_USER} && \
    ln -s /nix/var/nix/profiles/per-user/${UBI_USER}/profile /home/${UBI_USER}/.nix-profile && \
    chown -h ${UBI_UID}:${UBI_GID} /home/${UBI_USER}/.nix-profile && \
    chown -R ${UBI_UID}:${UBI_GID} /nix/var/nix/profiles/per-user/${UBI_USER}

# FIX 3 — activate Nix in all main shells (bash + zsh)
RUN echo ". /nix/var/nix/profiles/default/etc/profile.d/nix.sh" >> /etc/bash.bashrc && \
    echo ". /nix/var/nix/profiles/default/etc/profile.d/nix.sh" >> /etc/zsh/zshrc

# FIX 4 — correct PATH (default profile + user profile)
ENV PATH="/nix/var/nix/profiles/default/bin:/home/${UBI_USER}/.nix-profile/bin:${PATH}"

######################################################################
# HEALTHCHECK (lightweight)
######################################################################
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD test -x /bin/bash || exit 1

######################################################################
# Default command for devcontainer
######################################################################
USER ${UBI_USER}
CMD ["sleep", "infinity"]
