# ===============> Configs for the root user
# Powershell config
rm -rf /root/.config/powershell
ln -sf /home/nixos/nixos/configs/pwsh-config /root/.config/powershell
chown -h root:root /root/.config/powershell

# GTK config 
rm -rf /root/.config/gtk-3.0/settings.ini
ln -sf /home/nixos/nixos/configs/gtk/settings.ini /root/.config/gtk-3.0/settings.ini

# ===============> Configs for the nixos user
# Powershell config
rm -rf /home/nixos/.config/powershell
ln -sf /home/nixos/nixos/configs/pwsh_config /home/nixos/.config/powershell
chown -h nixos:users /home/nixos/.config/powershell

# Nvim config
rm -rf /home/nixos/.config/nvim
ln -sf /home/nixos/nixos/configs/nvim_config /home/nixos/.config/nvim
chown -h nixos:users /home/nixos/.config/nvim

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
mkdir -p /home/nixos/.local/share/applications
ln -sf /home/nixos/nixos/scripts/launcher_scripts /home/nixos/.local/share/applications
chown nixos:users /home/nixos/.local/share/applications
