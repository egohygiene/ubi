######################################################################
# UBI Minimal Variant
#
# This is the minimal version of UBI with only foundational
# environment variables and XDG directory structure.
# No heavy tools or language runtimes included.
#
# Use this variant when:
# - You need the smallest possible image size
# - You want to add only specific tools you need
# - Security surface reduction is a priority
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
ARG LANG=en_US.utf8
ARG LANGUAGE=en_US:en
ARG LC_ALL=en_US.utf8
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

# Telemetry controls
ARG DO_NOT_TRACK=1
ARG TELEMETRY_ENABLED=0

# Debian noninteractive
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
ARG DEBIAN_PRIORITY=critical
ARG DEBCONF_NOWARNINGS=yes

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
    # Telemetry toggles
    ##################################################################
    DO_NOT_TRACK=${DO_NOT_TRACK} \
    TELEMETRY_ENABLED=${TELEMETRY_ENABLED} \
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

FROM environment AS final

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
