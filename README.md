# pve-tools
Scripts and tools for Proxmox 

## pre usage setup
Copy SSH keys to host
```bash
ssh-copy-id root@<hostname>
```

Connect to the proxmox host
```bash
ssh root@<hostname>
```

## general usage instructions
Download and run script
```bash
# download script
wget https://github.com/KimmoHernborg/pve-tools/raw/main/<script-name>

# (inspect and verify) 
nano <script-name>

# set execute bit
chmod +x <script-name>

# run and remove the script if succesful
./<script-name> && rm <script-name>
```

## use-dhcp (lazy) usage
- Change network interface from static to dhcp
```bash
curl -L https://github.com/KimmoHernborg/pve-tools/raw/main/use-dhcp.sh | bash
```
No need to restart, since the script restarts the interface


## post-install (lazy) usage
- Disable Enterprise repo
- Add No-subscription repo
- Setup .bashrc
  - enable `ls` color
  - setup *fancy* color prompt (Ubuntu like)
- Turn down swappiness

```bash
curl -L https://github.com/KimmoHernborg/pve-tools/raw/main/post-install.sh | bash
```
Disconnect and reconnect to the host to verify that the changes have been implemented


## nvme-trim (lazy) usage
- Setup a cron job to run fstrim to keep local m.2 ssd trimmed

```bash
curl -L https://github.com/KimmoHernborg/pve-tools/raw/main/nvme-trim.sh | bash
```


## change-lvm-wmid usage
- Change WM ID (only for LVM local storage)
- Can be run interactivly (will prompt for old ID and new ID)
- or by providing ID's to the script directly: `./change-lvm-wmid.sh <oldid> <newid>`

```bash
wget https://github.com/KimmoHernborg/pve-tools/raw/main/change-lvm-wmid.sh && chmod +x change-lvm-wmid.sh
```
