{ config, lib, pkgs, ... }:

let
	xsessionSource = pkgs.writeText "system-script" ''
		eval $(dbus-launch --sh-syntax --exit-with-session)
		exec dwm
	'';
in
{
    # Packages that didnt work automatically
    nixpkgs.config = {
		allowUnfree = true;
		permittedInsecurePackages = [ "electron-27.3.11" ];
    };

    # New path for the nixos config
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.activationScripts = {
		user-xsession-link.text = ''
			# Place xsession file for user
			install -m 644 -o nixos -g users "${xsessionSource}" /home/nixos/.xsession
			echo -------------------------------------------------------------
			echo  "Successfully created the startup file for the main system"
			echo -------------------------------------------------------------
		'';
		startup.text = builtins.readFile ../scripts/scripts.nix;
	};
}
