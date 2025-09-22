{ config, lib, pkgs, ... }:

{
    imports =
	[ # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    ./nix_configs/user_settings.nix
	    ./nix_configs/nix_settings.nix
	    ./nix_configs/defaults.nix
	    ./nix_configs/system_settings.nix
	    ./nix_configs/env_settings.nix
	    ./nix_configs/security_settings.nix
    ];

	environment.sessionVariables.ENVIRONMENT = "LXQT";

	services.xserver = {
		enable = true;
		displayManager.lightdm.enable = true;
		desktopManager.lxqt.enable = true; 
	};
}
