# ===============> Configs for the root user
# Nvim config
mkdir -p /root/.config/nvim
ln -sf /home/nixos/nixos/configs/nvim-config/init.lua /root/.config/nvim/init.lua

# Ghostty config
mkdir -p /root/.config/ghostty
ln -sf /home/nixos/nixos/configs/config /root/.config/ghostty/config

# Powershell config
mkdir -p /root/.config/powershell
ln -sf /home/nixos/nixos/configs/pwsh-config/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# ===============> Configs for the nixos user
# Nvim config
mkdir -p /home/nixos/.config/nvim
ln -sf /home/nixos/nixos/configs/nvim-config/init.lua /home/nixos/.config/nvim/init.lua
chown nixos:users /home/nixos/.config/nvim/init.lua

# Ghostty config
mkdir -p /home/nixos/.config/ghostty
ln -sf /home/nixos/nixos/configs/config /home/nixos/.config/ghostty/config
chown nixos:users /home/nixos/.config/ghostty/config

# Powershell config
mkdir -p /home/nixos/.config/powershell
ln -sf /home/nixos/nixos/configs/pwsh-config/Microsoft.PowerShell_profile.ps1 /home/nixos/.config/powershell/Microsoft.PowerShell_profile.ps1
chown nixos:users /home/nixos/.config/powershell/Microsoft.PowerShell_profile.ps1

# Xsetroot
ln -sf /home/nixos/nixos/scripts/xsession /home/nixos/.xsession
ln -sf /home/nixos/nixos/scripts/sysinfo.ps1 /home/nixos/.sysinfo.ps1
ln -sf /home/nixos/nixos/scripts/brightness_controller.ps1 /home/nixos/.brightness_controller.ps1
ln -sf /home/nixos/nixos/scripts/remaps.xkb /home/nixos/remaps.xkb
chown nixos:users \
/home/nixos/.xsession \
/home/nixos/.sysinfo.ps1 \
/home/nixos/.brightness_controller.ps1 \
/home/nixos/remaps.xkb

# Custom .desktop files
mkdir -p /home/nixos/.local/share/applications/
ln -sf /home/nixos/nixos/scripts/launcher_scripts /home/nixos/.local/share/applications/
chown nixos:users /home/nixos/.local/share/applications
