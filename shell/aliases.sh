#!/usr/bin/env bash
# aliases.sh — Universal shell aliases (safe, readable, modern)

# Guard: only load in interactive shells
[[ $- == *i* ]] || return 0

###############################################################################
# Environment / Introspection
###############################################################################

alias envs='printenv | sort'
alias path='echo "$PATH" | tr ":" "\n"'

###############################################################################
# Filesystem / Navigation
###############################################################################

alias ll='ls --all --human-readable --color=auto --group-directories-first --format=long'
alias la='ls --almost-all --human-readable --color=auto'
alias tree1='tree -L 1'
alias du1='du --human-readable --max-depth=1'
alias dfh='df --human-readable --print-type'
alias mkdirp='mkdir --parents'

###############################################################################
# Safer coreutils (interactive by default)
###############################################################################

alias cp='cp --interactive --verbose'
alias mv='mv --interactive --verbose'
alias rm='rm --interactive'
alias rmf='rm --recursive --force'

###############################################################################
# Search / Text
###############################################################################

alias grepv='grep --invert-match'
alias rgc='rg --context=2'
alias lessc='less --RAW-CONTROL-CHARS'

###############################################################################
# Git
###############################################################################

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gl='git log --oneline --decorate --graph --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpl='git pull'

###############################################################################
# Process / System
###############################################################################

alias psg='ps --no-headers --format=pid,ppid,cmd --sort=-pid'
alias freeh='free --human'
alias htop='btop'   # prefer modern tool if present

###############################################################################
# Networking
###############################################################################

alias ports='ss --listening --numeric --tcp --udp'
alias ipaddr='hostname -I | tr " " "\n"'

###############################################################################
# Convenience
###############################################################################

alias cls='clear'
alias reload='exec "$SHELL" --login'

###############################################################################
# Nix helpers (non-invasive)
###############################################################################

alias nd='nix develop'
alias ns='nix shell'
alias nf='nix flake'
alias nfu='nix flake update'

###############################################################################
# UBI helpers
###############################################################################

alias ubi='ubi'
alias ubid='ubi doctor'
alias ubis='ubi system test'
