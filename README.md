# pve-tools
Scripts and tools for Proxmox 

## post-install usage
Copy SSH keys to host
```bash
ssh-copy-id root@<hostname>
```

Connect to the host
```bash
ssh root@<hostname>
```

Download and run post-install script
```bash
# download and set execute bit
wget https://github.com/KimmoHernborg/pve-tools/raw/main/post-install.sh && chmod +x post-install.sh

# (inspect and verify) 
nano post-install.sh

# run and remove the script if succesful
./post-install.sh && rm post-install.sh
```
Disconnect and reconnect to the host to verify that the changes have been implemented

