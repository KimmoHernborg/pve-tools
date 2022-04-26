#!/bin/bash

# Log oneliner
log () { LOG_LEVEL=$2; if [ ! $LOG_LEVEL ]; then LOG_LEVEL="info"; fi; echo -e "\033[38;5;131m[${LOG_LEVEL}] \033[38;5;147m$1\033[0m"; }


log "Disable Enterprize repo"
sed -i "s/^deb/#deb/g" /etc/apt/sources.list.d/pve-enterprise.list

log "Add No-subscription repo"
cat <<EOF >/etc/apt/sources.list.d/pve-no-subscription.list
# PVE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
EOF

