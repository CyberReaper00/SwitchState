# ===============> Configs for the root user
# Powershell config
rm -rf /root/.config/powershell
ln -sf /home/nixos/nixos/configs/pwsh-config /root/.config/powershell
chown -h root:root /root/.config/powershell

# Ghostty config
mkdir -p /root/.config/ghostty
ln -sf /home/nixos/nixos/configs/config /root/.config/ghostty/config

# ===============> Configs for the nixos user
# Powershell config
rm -rf /home/nixos/.config/powershell
ln -sf /home/nixos/nixos/configs/pwsh-config /home/nixos/.config/powershell
chown -h nixos:users /home/nixos/.config/powershell

# Ghostty config
mkdir -p /home/nixos/.config/ghostty
ln -sf /home/nixos/nixos/configs/config /home/nixos/.config/ghostty/config
chown nixos:users /home/nixos/.config/ghostty/config

# Rofi config
mkdir -p /home/nixos/.config/rofi
ln -sf /home/nixos/nixos/configs/config.rasi /home/nixos/.config/rofi/config.rasi
chown nixos:users /home/nixos/.config/rofi/config.rasi

# Xsetroot Scripts
install -m 755 -o nixos -g users /home/nixos/nixos/scripts/xsession /home/nixos/.xsession
install -m 755 -o nixos -g users /home/nixos/nixos/scripts/startup.sh /home/nixos/.startup.sh
install -m 755 -o nixos -g users /home/nixos/nixos/scripts/sysinfo.ps1 /home/nixos/.sysinfo.ps1
install -m 755 -o nixos -g users /home/nixos/nixos/scripts/brightness_controller.ps1 /home/nixos/.brightness_controller.ps1

# Custom .desktop files
mkdir -p /home/nixos/.local/share/applications/
ln -sf /home/nixos/nixos/scripts/launcher_scripts /home/nixos/.local/share/applications/
chown nixos:users /home/nixos/.local/share/applications
