# ===============> Custom scripts for all users

# This places all custom .desktop files in the home folder
mkdir -p /usr/share/applications/
ln -sf /home/nixos/nixos/scripts/launcher_scripts /usr/share/applications/

# ===============> Configs for the root user
# Nvim config
mkdir -p /root/.config/nvim
ln -sf /home/nixos/nixos/configs/init.lua /root/.config/nvim/init.lua

# Ghostty config
mkdir -p /root/.config/ghostty
ln -sf /home/nixos/nixos/configs/config /root/.config/ghostty/config

# Powershell config
mkdir -p /root/.config/powershell
ln -sf /home/nixos/nixos/configs/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# ===============> Configs for the nixos user
# Nvim config
mkdir -p /home/nixos/.config/nvim
ln -sf /home/nixos/nixos/configs/init.lua /home/nixos/.config/nvim/init.lua
chown nixos:users /home/nixos/.config/nvim/init.lua

# Ghostty config
mkdir -p /home/nixos/.config/ghostty
ln -sf /home/nixos/nixos/configs/config /home/nixos/.config/ghostty/config
chown nixos:users /home/nixos/.config/ghostty/config

# Powershell config
mkdir -p /home/nixos/.config/powershell
ln -sf /home/nixos/nixos/configs/Microsoft.PowerShell_profile.ps1 /home/nixos/.config/powershell/Microsoft.PowerShell_profile.ps1
chown nixos:users /home/nixos/.config/powershell/Microsoft.PowerShell_profile.ps1

# Bashrc
ln -sf /home/nixos/nixos/scripts/.bashrc /home/nixos/.bashrc
chown nixos:users /home/nixos/.bashrc

#Xsetroot
ln -sf /home/nixos/nixos/scripts/launcher_scripts/xsession /home/nixos/.xsession
ln -sf /home/nixos/nixos/scripts/launcher_scripts/dwm_status.sh /home/nixos/.dwm_status.sh

chown nixos:users /home/nixos/.xsession /home/nixos/.dwm_status.sh
