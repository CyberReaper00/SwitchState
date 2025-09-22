{ config, lib, pkgs, ... }:

{
    imports =
	[
	    ./hardware-configuration.nix
	    ./nix_configs/user_settings.nix
	    ./nix_configs/nix_settings.nix
	    ./nix_configs/defaults.nix
	    ./nix_configs/system_settings.nix
	    ./nix_configs/env_settings.nix
	    ./nix_configs/security_settings.nix
    ];

	programs.dconf.enable = true;

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
	services.gnome.gnome-keyring.enable = true;

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [
			intel-media-driver
			libva-utils
		];
	};

	services.libinput.enable = true;
    services.xserver = {
		enable = true;
		videoDrivers = [ "intel" ];
		deviceSection = ''
			Option "TearFree" "true"
			Option "DRI" "3"
		'';

		/*
			sudo systemctl stop gdm
			startx
		*/

		displayManager = {
			gdm.enable = true;
			# gdm.wayland = false;
			sessionCommands = ''
				find '/home/nixos/Pictures/Backgrounds/landscape/' -type f | shuf -n 1 | xargs feh --bg-fill
				pwsh /home/nixos/.brightness_controller.ps1 &

				if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
					eval $(dbus-launch --sh-syntax --exit-with-session)
				fi
				systemctl --user import-environment DISPLAY XDG_CURRENT_DESKTOP XDG_VTNR DBUS_SESSION_BUS_ADDRESS
				systemctl --user start gvfs-daemon.service || true
			'';
		};
		desktopManager.gnome.enable = true; 
    };

	environment = {
		systemPackages = with pkgs // pkgs.lxqt // pkgs.xorg; [
			feh
			qterminal
			xinit
		];
	};
}

