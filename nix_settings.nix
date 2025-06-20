{ config, lib, pkgs, ... }:

{
    # Packages that didnt work automatically
    nixpkgs.config = {
	allowUnfree = true;
	permittedInsecurePackages = [
	    "electron-27.3.11"
	];
    };

    # New path for the nixos config
    nix = {
	settings = {
	    experimental-features = [ "nix-command" "flakes" ];
	};
    };

    # Simple script to place dotfiles per user
    system.activationScripts = {

	user-config = {
	    text = builtins.readFile ./scripts/scripts.nix;
	};
    };
}
