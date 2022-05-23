#!/bin/bash
set -e

# !NOTE! 
# This script is for moving VMs not CTs 
# and only on local LVM storage!


# Log oneliner
log () { LOG_LEVEL=$2; if [ ! $LOG_LEVEL ]; then LOG_LEVEL="info"; fi; echo -e "\033[38;5;131m[${LOG_LEVEL}] \033[38;5;147m$1\033[0m"; }

# Get old/current VMID
if [ -z "$1" ]; then
    log "Enter the VMID to change:" "input"
    read OLD_VMID
else
    OLD_VMID="$1"
fi
case $OLD_VMID in
    ''|*[!0-9]*)
        log "Bad input. Exiting..." "error"
        exit;;
    *)
    log "Old VMID: $OLD_VMID";;
esac

# Get new VMID
if [ -z "$2" ]; then
    log "Enter the new VMID:" "input"
    read NEW_VMID
else
    NEW_VMID="$2"
fi
case $NEW_VMID in
    ''|*[!0-9]*)
        log "Bad input. Exiting..." "error"
        exit;;
    *)
    log "New VMID: $NEW_VMID";;
esac

# Check status of (old) VMID
log "Getting status of VM"
VM_STATUS=$(qm status $OLD_VMID | awk '{print $2}')
log "VM status: $VM_STATUS"
if [ $VM_STATUS != 'stopped' ]; then
    log "Shutting down $OLD_VMID"
    qm shutdown $OLD_VMID
    log "Waiting for $OLD_VMID to complete shutdown"
    qm wait $OLD_VMID
fi

# Get volume group name
VG_NAME="$(lvs --noheadings -o lv_name,vg_name | grep -w $OLD_VMID | awk -F ' ' '{print $2}' | uniq)"
case $VG_NAME in
    "")
        log "Machine not in Volume Group. Exiting..." "error"
        exit;;
    *)
    log "Volume Group: $VG_NAME";;
esac

# Move storage, config and change config file
for i in $(lvs -a | grep $VG_NAME | awk '{print $1}' | grep $OLD_VMID); do
    OLD_DISK="vm-$OLD_VMID-disk-$(echo $i | awk '{print substr($0,length,1)}')"
    NEW_DISK="vm-$NEW_VMID-disk-$(echo $i | awk '{print substr($0,length,1)}')"
    log "Moving LVS storage: $VG_NAME/$OLD_DISK -> $NEW_DISK"
    #echo lvrename $VG_NAME/$OLD_DISK $NEW_DISK
    lvrename $VG_NAME/$OLD_DISK $NEW_DISK

    log "Updating storage ref in qemu config file ($OLD_VMID.conf): $OLD_DISK -> $NEW_DISK"
    #sed "s/$OLD_DISK/$NEW_DISK/g" /etc/pve/qemu-server/$OLD_VMID.conf | diff --color /etc/pve/qemu-server/$OLD_VMID.conf -
    grep --color=always "$OLD_DISK" /etc/pve/qemu-server/$OLD_VMID.conf
    #echo sed -i "s/$OLD_DISK/$NEW_DISK/g" /etc/pve/qemu-server/$OLD_VMID.conf
    sed -i "s/$OLD_DISK/$NEW_DISK/g" /etc/pve/qemu-server/$OLD_VMID.conf
done
log "Move config file: $OLD_VMID.conf -> $NEW_VMID.conf"
#echo mv /etc/pve/qemu-server/$OLD_VMID.conf /etc/pve/qemu-server/$NEW_VMID.conf
mv /etc/pve/qemu-server/$OLD_VMID.conf /etc/pve/qemu-server/$NEW_VMID.conf

# Restore state if it was running
if [ $VM_STATUS == 'running' ]; then
    log "Restoring state: $NEW_VMID"
    qm start $NEW_VMID
fi

log "Complete!"
