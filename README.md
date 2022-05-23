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

## post-install (lazy) usage
- Disable Enterprise repo
- Add No-subscription repo
- Setup .bashrc
  - enable `ls` color
  - setup *fancy* color prompt (Ubuntu like)

```bash
curl https://github.com/KimmoHernborg/pve-tools/raw/main/post-install.sh | bash
```
Disconnect and reconnect to the host to verify that the changes have been implemented


## nvme-trim (lazy) usage
- Setup a cron job to run fstrim to keep local m.2 ssd trimmed

```bash
curl https://github.com/KimmoHernborg/pve-tools/raw/main/nvme-trim.sh | bash
```
