# Edit this configuration file to define what should be installed on your system.
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports =
	[   # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    /home/nixos/nixos/nix-configs/user_settings.nix
	    /home/nixos/nixos/nix-configs/nix_settings.nix
	    /home/nixos/nixos/nix-configs/container_settings.nix
	    /home/nixos/nixos/nix-configs/defaults.nix
	    /home/nixos/nixos/nix-configs/system_settings.nix
	    /home/nixos/nixos/nix-configs/env_settings.nix
	    /home/nixos/nixos/nix-configs/security_settings.nix
	];

    services.xserver = {
	enable = true;
	windowManager.dwm.enable = true;
    };

    # Extract config information from its source folder
    nixpkgs.overlays = [

	(final: prev: {
	    dwm = prev.dwm.overrideAttrs (old: {
		 src = /home/nixos/nixos/user-configs/dwm;
	    });
	})

	(final: prev: {
	    slock = prev.slock.overrideAttrs (old: {
		 src = /home/nixos/nixos/user-configs/slock;
		 buildInputs = (old.buildInputs or []) ++ [
		    prev.xorg.libXinerama
		 ];
	    });
	})
    ];

    # xwinwrap -fs -fdt -b -nf -- mpv --no-border --loop --vo=x11 --wid=%WID /path/to/video.mp4 &

}
