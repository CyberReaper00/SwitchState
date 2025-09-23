{ config, lib, pkgs, ... }:

{
    # Define a user account and its settings
    users = {
		defaultUserShell = pkgs.powershell;

		users = {
			# Define root settings
			root = { shell = pkgs.powershell; };

			# Define nixos-user settings
			nixos = {
				isNormalUser = true;
				extraGroups = [ "input" "wheel" "networkmanager" "libvirtd" "kvm" ];
				useDefaultShell = true;
				linger = true;
			};
		};
    };
}
