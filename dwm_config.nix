# Edit this configuration file to define what should be installed on your system.
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports =
	[   # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    ./nix_configs/user_settings.nix
	    ./nix_configs/nix_settings.nix
	    ./nix_configs/container_settings.nix
	    ./nix_configs/defaults.nix
	    ./nix_configs/system_settings.nix
	    ./nix_configs/env_settings.nix
	    ./nix_configs/security_settings.nix
	];

	environment.sessionVariables = { ENVIRONMENT = "DWM"; };

	services = {
		xserver = {
			enable = true;
			displayManager.lightdm.enable = true;
			windowManager.dwm.enable = true;
		};

		dwm-status = {
			enable = true;
			order = [ "time" ];
			extraConfig = ''
				wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d ':' -f 2)
				wifi_name="$${wifi:-N/A}"

				day=$(date +"%a")
				date_=$(date +"%d-%m-%y")
				time_=$(date +"%I:%M:%S")

				xsetroot -name "  ╠═══ $${wifi_name} ═══╬═══ $${day} ▊ $${date_} ▊ $${time_} ═══╣ "
			'';
		};

	};
    # Extract config information from its source folder
    nixpkgs.overlays = [

		(final: prev: {
			dwm = prev.dwm.overrideAttrs (old: {
				src = ./user_configs/dwm;
			});
		})

		(final: prev: {
			slock = prev.slock.overrideAttrs (old: {
				 src = ./user_configs/slock;
				 buildInputs = (old.buildInputs or []) ++ [
					prev.xorg.libXinerama
				 ];
			});
		})
    ];
}
