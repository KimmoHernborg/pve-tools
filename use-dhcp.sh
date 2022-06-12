#!/bin/bash

# Log oneliner
log () { LOG_LEVEL=$2; if [ ! $LOG_LEVEL ]; then LOG_LEVEL="info"; fi; echo -e "\033[38;5;131m[${LOG_LEVEL}] \033[38;5;147m$1\033[0m"; }

log "Changing network to use DHCP for IP address"
cd /etc/network

log "Backing up current 'interfaces' file"
name="interfaces"
ext="bak"
if [[ -e "$name.$ext" || -L "$name.$ext" ]] ; then
    i=0
    while [[ -e "$name.$i.$ext" || -L "$name.$i.$ext" ]] ; do
        let i++
    done
    name="$name.$i"
fi
log "'interfaces' --> '$name.$ext'"
cp "interfaces" "$name.$ext"

log "Changing iface from static to dhcp"
sed -i "s/iface vmbr0 inet static/iface vmbr0 inet dhcp/" interfaces

log "Removing 'address'"
sed -i "s/address/#address/" interfaces

log "Removing 'gateway'"
sed -i "s/gateway/#gateway/" interfaces

log "Restarting network"
ifdown vmbr0 && ifup vmbr0

log "Done"
