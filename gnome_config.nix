{ config, lib, pkgs, ... }:

{
    imports =
	[ # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    ./nix_configs/user_settings.nix
	    ./nix_configs/nix_settings.nix
	    ./nix_configs/container_settings.nix
	    ./nix_configs/defaults.nix
	    ./nix_configs/system_settings.nix
	    ./nix_configs/env_settings.nix
	    ./nix_configs/security_settings.nix
    ];

	environment.sessionVariables = { ENVIRONMENT = "GNOME"; };

    services.xserver = {
		enable = true;
		displayManager.gdm.enable = true;
		desktopManager.gnome.enable = true; 
    };
}

