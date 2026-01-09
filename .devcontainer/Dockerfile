######################################################################
# UBI — Universal Base Image (Devcontainer)
#
# Philosophy:
# - Docker provides OS isolation + snapshotting
# - Nix provides deterministic toolchains
# - /opt/universal owns runtime state & policy
# - flake.nix is the toolchain contract
######################################################################

######################################################################
# BASE IMAGE (PINNED)
######################################################################
FROM mcr.microsoft.com/devcontainers/base:ubuntu@sha256:c1613dbcdafe28e4b36ede9f3cb84a96e76765f50b3aeee87cb589eeb4c6dbca AS base

# Safer shell defaults for all RUN steps
SHELL ["/bin/bash", "-o", "errexit", "-o", "errtrace", "-o", "functrace", "-o", "nounset", "-o", "pipefail", "-c"]

######################################################################
# ENVIRONMENT STAGE — base runtime configuration
######################################################################
FROM base AS environment

######################################################################
# USER / LOCALE / TIMEZONE
######################################################################
ARG UBI_USER=vscode
ARG UBI_GROUP=vscode
ARG UBI_UID=1000
ARG UBI_GID=1000

ARG LANG=en_US.utf8
ARG LANGUAGE=en_US:en
# ARG LC_ALL=en_US.utf8
ARG TZ=UTC
ARG TMPDIR=/tmp

ENV \
  UBI_USER="${UBI_USER}" \
  UBI_GROUP="${UBI_GROUP}" \
  UBI_UID="${UBI_UID}" \
  UBI_GID="${UBI_GID}" \
  LANG="${LANG}" \
  LANGUAGE="${LANGUAGE}" \
  # LC_ALL="${LC_ALL}" \
  TZ="${TZ}" \
  TMPDIR="${TMPDIR}"

######################################################################
# WORKSPACE & UNIVERSAL FILESYSTEM CONTRACT
######################################################################
ENV \
  WORKSPACE_DIR="/workspace" \
  UNIVERSAL_HOME="/opt/universal" \
  UNIVERSAL_BIN="/opt/universal/bin" \
  UNIVERSAL_TOOLBOX="/opt/universal/toolbox" \
  UNIVERSAL_CACHE="/opt/universal/cache" \
  UNIVERSAL_LOGS="/opt/universal/logs" \
  UNIVERSAL_CONFIG="/opt/universal/config" \
  UNIVERSAL_LIB="/opt/universal/lib" \
  UNIVERSAL_LOCKS="/opt/universal/locks" \
  UNIVERSAL_FONTS="/opt/universal/fonts" \
  UNIVERSAL_RUNTIME="/opt/universal/runtime" \
  UNIVERSAL_APPS="/opt/universal/apps" \
  UNIVERSAL_REPORTS="/opt/universal/reports" \
  UNIVERSAL_SHELL="/opt/universal/shell" \
  UBI_HOME="/home/${UBI_USER}"

######################################################################
# XDG OVERRIDES (runtime state control)
######################################################################
ENV \
  XDG_CONFIG_HOME="${UNIVERSAL_CONFIG}" \
  XDG_CACHE_HOME="${UNIVERSAL_CACHE}" \
  XDG_DATA_HOME="${UNIVERSAL_TOOLBOX}" \
  XDG_STATE_HOME="${UNIVERSAL_RUNTIME}" \
  XDG_CONFIG_DIRS="${UNIVERSAL_CONFIG}:/etc/xdg" \
  XDG_DATA_DIRS="${UNIVERSAL_APPS}:/usr/local/share:/usr/share"

ENV PATH=${UNIVERSAL_BIN}:$PATH

######################################################################
# UX / TELEMETRY / TOOLING SANITY
######################################################################
ENV \
  TERM="xterm-256color" \
  COLORTERM="truecolor" \
  CLICOLOR=1 \
  CLICOLOR_FORCE=1 \
  FORCE_COLOR=1 \
  GCC_COLORS="error=01;31:warning=01;35:note=01;36" \
  LESS="-R" \
  EDITOR="code" \
  VISUAL="code" \
  PAGER="less" \
  GIT_PAGER="less" \
  NODE_OPTIONS="--max-old-space-size=4096 --max-semi-space-size=512" \
  CARGO_TERM_COLOR="always" \
  DO_NOT_TRACK=1 \
  TELEMETRY_ENABLED=0 \
  NEXT_TELEMETRY_DISABLED=1 \
  YARN_ENABLE_TELEMETRY=false \
  DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  GATSBY_TELEMETRY_DISABLED=1 \
  NUXT_TELEMETRY_DISABLED=1 \
  CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true \
  STRIPE_CLI_TELEMETRY_OPTOUT=1

######################################################################
# PYTHON / COMPILER NOISE REDUCTION
######################################################################
ENV \
  PYTHONUNBUFFERED=1 \
  PYTHONUTF8=1 \
  PYTHONHASHSEED=random \
  PYTHONFAULTHANDLER=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONNOUSERSITE=1 \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_NO_CACHE_DIR=1 \
  PIP_NO_WARN_SCRIPT_LOCATION=on \
  PIP_DEFAULT_TIMEOUT=200 \
  NIX_CFLAGS_COMPILE="-w" \
  CFLAGS="-w" \
  CXXFLAGS="-w" \
  CPPFLAGS="-w"

######################################################################
# IMAGE MAGICK / GHOSTSCRIPT RUNTIME CONTROL
######################################################################
ENV \
  GS_OPTIONS="-dSAFER -dBATCH -dNOPAUSE -dNOPROMPT -dQUIET" \
  MAGICK_HOME="${UNIVERSAL_LIB}/ImageMagick" \
  MAGICK_CACHE_PATH="${UNIVERSAL_CACHE}/imagemagick" \
  MAGICK_CONFIGURE_PATH="${UNIVERSAL_CONFIG}/imagemagick" \
  MAGICK_TEMPORARY_PATH="${UNIVERSAL_RUNTIME}/imagemagick" \
  GIT_CONFIG_GLOBAL="${UNIVERSAL_CONFIG}/git/gitconfig" \
  GIT_GLOBAL_IGNORE_FILE="${UNIVERSAL_CONFIG}/git/gitignore" \
  TEXLIVE_INSTALL_PREFIX="${UNIVERSAL_APPS}/texlive" \
  TEXMFCONFIG="${UNIVERSAL_CONFIG}/texlive" \
  TASKFILE_HOME_DIR="${UNIVERSAL_CONFIG}/taskfile" \
  CALIBRE_SHOW_DEPRECATION_WARNINGS=0 \
  CALIBRE_CONFIG_DIRECTORY="${UNIVERSAL_CONFIG}/calibre" \
  CALIBRE_CACHE_DIRECTORY="${UNIVERSAL_CACHE}/calibre" \
  CALIBRE_TEMP_DIR="${UNIVERSAL_RUNTIME}/calibre" \
  GEM_HOME="${XDG_DATA_HOME}/ruby/gems" \
  YARN_GLOBAL_FOLDER="${XDG_DATA_HOME}/yarn" \
  ANSIBLE_HOME="${XDG_DATA_HOME}/ansible" \
  FFMPEG_DATADIR="${XDG_DATA_HOME}/ffmpeg" \
  GOPATH="${XDG_DATA_HOME}/go"

ENV \
  TEXMFHOME="${TEXLIVE_INSTALL_PREFIX}/texmf" \
  TEXMFVAR="${TEXLIVE_INSTALL_PREFIX}/.texlive/texmf-var"

######################################################################
# CREATE UNIVERSAL DIRECTORIES (authoritative runtime state)
######################################################################
RUN mkdir -p \
    "${UNIVERSAL_BIN}" \
    "${UNIVERSAL_TOOLBOX}" \
    "${UNIVERSAL_CACHE}" \
    "${UNIVERSAL_LOGS}" \
    "${UNIVERSAL_CONFIG}" \
    "${UNIVERSAL_LIB}" \
    "${UNIVERSAL_LOCKS}" \
    "${UNIVERSAL_FONTS}" \
    "${UNIVERSAL_RUNTIME}" \
    "${UNIVERSAL_APPS}" \
    "${UNIVERSAL_REPORTS}" \
    "${UNIVERSAL_SHELL}" \
    "${MAGICK_CACHE_PATH}" \
    "${MAGICK_TEMPORARY_PATH}" \
 && chown --recursive "${UBI_UID}:${UBI_GID}" "${UNIVERSAL_HOME}"

USER root
RUN apt-get update && apt-get install --yes --no-install-recommends \
      ca-certificates \
      curl \
      xz-utils \
      tzdata \
      systemd \
      locales-all \
      locales \
      fontconfig \
      bash-completion \
 && rm -rf /var/lib/apt/lists/*

# Copy ubi early
COPY shell/bin/ubi "${UNIVERSAL_BIN}/ubi"
RUN chmod +x "${UNIVERSAL_BIN}/ubi"

# System invariants (must run as root)
RUN ubi system timezone && \
    ubi system locale

######################################################################
# IMAGE MAGICK POLICY (explicit, user-owned)
######################################################################
COPY --chown=${UBI_UID}:${UBI_GID} config/imagemagick/ "${UNIVERSAL_CONFIG}/imagemagick/"

######################################################################
# GIT GLOBAL CONFIGURATION (policy-owned)
######################################################################
COPY --chown=${UBI_UID}:${UBI_GID} config/git/ "${UNIVERSAL_CONFIG}/git/"

######################################################################
# NIX BOOTSTRAP CONFIGURATION
######################################################################
ENV NIX_ROOT="/nix"
ENV NIX_PROFILES_ROOT="${NIX_ROOT}/var/nix/profiles"

ENV \
  NIX_CONF_DIR="${XDG_CONFIG_HOME}/nix" \
  NIX_DISABLE_SECCOMP="1" \
  NIX_DETERMINATE_URL="https://install.determinate.systems/nix" \
  NIX_DEFAULT_PROFILE_SCRIPT="${NIX_PROFILES_ROOT}/default/etc/profile.d/nix.sh" \
  UBI_NIX_FLAKE_DIR="${WORKSPACE_DIR}" \
  NIX_BIN="${NIX_PROFILES_ROOT}/default/bin/nix" \
  NIX_USER_PROFILE_TARGET="${NIX_PROFILES_ROOT}/per-user/${UBI_USER}/profile" \
  NIX_USER_PROFILE_LINK=${UBI_HOME}/.nix-profile

######################################################################
# NIX INSTALL STAGE (single-user, deterministic)
######################################################################
FROM environment AS nix

USER root
RUN apt-get update && apt-get install --yes --no-install-recommends \
      ca-certificates \
      curl \
      xz-utils \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${NIX_ROOT} && chown ${UBI_UID}:${UBI_GID} ${NIX_ROOT}

# Ensure workspace directory exists
RUN mkdir -p "${WORKSPACE_DIR}" \
 && chown "${UBI_UID}:${UBI_GID}" "${WORKSPACE_DIR}"

# Copy flake.nix into workspace
COPY flake.nix "${WORKSPACE_DIR}/flake.nix"

# Copy flake.lock only if it exists
COPY flake.lock ${WORKSPACE_DIR}/flake.lock

USER ${UBI_USER}

RUN curl --proto '=https' --tlsv1.2 --silent --show-error --location \
    "${NIX_DETERMINATE_URL}" \
  | sh -s -- install linux \
      --init none \
      --no-confirm \
      --extra-conf "sandbox = false" \
      --extra-conf "filter-syscalls = false"

# Copy Nix configuration (policy-owned, not flake-owned)
COPY --chown=${UBI_UID}:${UBI_GID} config/nix/nix.conf "${NIX_CONF_DIR}/nix.conf"

# Fix Nix DB ownership for single-user mode (CRITICAL)
USER root
RUN chown --recursive ${UBI_UID}:${UBI_GID} ${NIX_ROOT}/var/nix

######################################################################
# PRE-WARM NIX STORE (flake realization only)
######################################################################
USER ${UBI_USER}
WORKDIR "${WORKSPACE_DIR}"
RUN if [ -f "${WORKSPACE_DIR}/flake.lock" ]; then \
      "${NIX_BIN}" develop --command bash -c 'echo "Nix flake realized"'; \
    else \
      echo "Skipping Nix pre-warm (flake.lock not present)"; \
    fi

######################################################################
# FINAL IMAGE
######################################################################
FROM environment AS final

# Nix store and installation
COPY --from=nix --chown=${UBI_UID}:${UBI_GID} ${NIX_ROOT} ${NIX_ROOT}

# Workspace (flake, repo contents)
COPY --from=nix --chown=${UBI_UID}:${UBI_GID} "${WORKSPACE_DIR}" "${WORKSPACE_DIR}"

# Nix policy / configuration (CRITICAL)
COPY --from=nix --chown=${UBI_UID}:${UBI_GID} ${UNIVERSAL_CONFIG} ${UNIVERSAL_CONFIG}

# Ensure Nix store ownership (authoritative)
RUN chown --recursive ${UBI_UID}:${UBI_GID} ${NIX_ROOT}

# Symlink user profile to Nix per-user profile (authoritative)
RUN rm -rf "${NIX_USER_PROFILE_LINK}" \
 && mkdir -p "${NIX_USER_PROFILE_TARGET}" \
 && ln -s "${NIX_USER_PROFILE_TARGET}" "${NIX_USER_PROFILE_LINK}" \
 && chown -h "${UBI_UID}:${UBI_GID}" "${NIX_USER_PROFILE_LINK}"

ENV PATH=${NIX_PROFILES_ROOT}/default/bin/:${PATH}

######################################################################
# ENTRYPOINT (authoritative activation)
######################################################################
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER ${UBI_USER}
WORKDIR "${WORKSPACE_DIR}"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]
