# ===============> Custom scripts for all users
mkdir -p /home/nixos/.local/share/applications/
ln -sf /etc/nixos/scripts/launcher_scripts /home/nixos/.local/share/applications/

# ===============> Configs for the root user
# Nvim config
mkdir -p /root/.config/nvim
ln -sf /etc/nixos/configs/init.lua /root/.config/nvim/init.lua

# Ghostty config
mkdir -p /root/.config/ghostty
ln -sf /etc/nixos/configs/ghostty-config.toml /root/.config/ghostty/ghostty-config.toml

# Powershell config
mkdir -p /root/.config/powershell
ln -sf /etc/nixos/configs/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# ===============> Configs for the nixos user
# Nvim config
mkdir -p /home/nixos/.config/nvim
ln -sf /etc/nixos/configs/init.lua /home/nixos/.config/nvim/init.lua
chown nixos:users /home/nixos/.config/nvim/init.lua

# Ghostty config
mkdir -p /home/nixos/.config/ghostty
ln -sf /etc/nixos/configs/ghostty-config.toml /home/nixos/.config/ghostty/ghostty-config.toml
chown nixos:users /home/nixos/.config/ghostty/ghostty-config.toml

# Powershell config
mkdir -p /home/nixos/.config/powershell
ln -sf /etc/nixos/configs/Microsoft.PowerShell_profile.ps1 /home/nixos/.config/powershell/Microsoft.PowerShell_profile.ps1
chown nixos:users /home/nixos/.config/powershell/Microsoft.PowerShell_profile.ps1

# Bashrc
ln -sf /etc/nixos/scripts/.bashrc /home/nixos/.bashrc
chown nixos:users /home/nixos/.bashrc

# Xsetroot
ln -sf /etc/nixos/scripts/xsession /home/nixos/.xsession
chown nixos:users /home/nixos/.xsession

ln -sf /etc/nixos/scripts/dwm_status.sh /home/nixos/.dwm_status.sh
chown nixos:users /home/nixos/.dwm_status.sh
