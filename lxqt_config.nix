{ config, lib, pkgs, ... }:

{
    imports = [
	./hardware-configuration.nix
	./nix-configs/nix_settings.nix
	./nix-configs/user_settings.nix
	./nix-configs/container_settings.nix
	./nix-configs/defaults.nix
	./nix-configs/system_settings.nix
	./nix-configs/env_settings.nix
	./nix-configs/security_settings.nix
    ];

    services.xserver = {
	enable = true;
	desktopManager.lxqt.enable = true; 
    };
}
