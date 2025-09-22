# Edit this configuration file to define what should be installed on your system.
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
	sets = pkgs // pkgs.xorg // pkgs.xfce;
in
{
    imports =
	[   # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    ./nix_configs/user_settings.nix
	    ./nix_configs/nix_settings.nix
	    ./nix_configs/defaults.nix
	    ./nix_configs/system_settings.nix
	    ./nix_configs/env_settings.nix
	    ./nix_configs/security_settings.nix
	];

	environment = {
		systemPackages = with sets; [
			alsa-utils
			blueman
			cloudflared
			dconf-editor
			dwm
			feh
			gradience
			icu
			libXinerama
			mesa
			mousepad
			nautilus
			nginx
			rofi
			slock
			udev
			unzip
			xbindkeys
			xdpyinfo
			xlsfonts
			xinit
			xsetroot
			xprintidle
		];
	};

	virtualisation.virtualbox.host.enable = true;

	services = {
		xserver = {
			enable = true;
			displayManager = {
				lightdm.enable = true;
				sessionCommands = ''
					find '/home/nixos/Pictures/Backgrounds/landscape/' -type f | shuf -n 1 | xargs feh --bg-fill
					pwsh /home/nixos/.sysinfo.ps1 &
					pwsh /home/nixos/.brightness_controller.ps1 &
					xterm -fullscreen -e nvim &
					easyeffects &

					if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
						eval $(dbus-launch --sh-syntax --exit-with-session)
					fi
					systemctl --user import-environment DISPLAY XDG_CURRENT_DESKTOP XDG_VTNR DBUS_SESSION_BUS_ADDRESS
					systemctl --user start gvfs-daemon.service || true
				'';
			};
			windowManager.dwm.enable = true;
		};
	};

    # Extract config information from its source folder
    nixpkgs.overlays = [

		(final: prev: {
			dwm = prev.dwm.overrideAttrs (old: {
				src = ./user_configs/dwm-minimal;
			});
		})

		(final: prev: {
			slock = prev.slock.overrideAttrs (old: {
				 src = ./user_configs/slock;
				 buildInputs = (old.buildInputs or []) ++ [
					prev.xorg.libXinerama
					prev.xorg.libXft
				 ];
			});
		})
    ];
}
