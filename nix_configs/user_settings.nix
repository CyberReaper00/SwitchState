{ config, lib, pkgs, ... }:

{
    # Define a user account and its settings
    users = {
		defaultUserShell = pkgs.powershell;

		users = {
			# Define root settings
			root = {
				shell = pkgs.powershell;
			};

			# Define nixos-user settings
			nixos = {
				isNormalUser = true;
				extraGroups = [ "wheel" "networkmanager" "libvirtd" "kvm" "lp"];
				useDefaultShell = true;
				linger = true;
			};
		};
    };
}
