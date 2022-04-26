#!/bin/bash

# Log oneliner
log () { LOG_LEVEL=$2; if [ ! $LOG_LEVEL ]; then LOG_LEVEL="info"; fi; echo -e "\033[38;5;131m[${LOG_LEVEL}] \033[38;5;147m$1\033[0m"; }


log "Disable Enterprise repo"
sed -i "s/^deb/#deb/g" /etc/apt/sources.list.d/pve-enterprise.list

log "Add No-subscription repo"
cat <<EOF >/etc/apt/sources.list.d/pve-no-subscription.list
# PVE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
EOF

log "Setup .bashrc"
cat <<EOF >/root/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want 'ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -la'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Setup Fancy color prompt (Ubuntu like)
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

EOF
