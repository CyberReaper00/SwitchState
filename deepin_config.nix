{ config, lib, pkgs, ... }:
{
    imports = [
	./nix_settings.nix
	./user_settings.nix
	./container_settings.nix
	./defaults.nix
	./system_settings.nix
	./env_settings.nix
	./security_settings.nix
    ];
}
