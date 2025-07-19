{ config, lib, pkgs, ... }:

let
	xsessionSource =
		if config.environment.sessionVariables.ENVIRONMENT == "DWM" then pkgs.writeText "dwm_script"
			''
				find '/home/nixos/Pictures/Backgrounds/landscape/' -type f | shuf -n 1 | xargs feh --bg-fill
				#sh xwinwrap -fs -fdt -b -nf -- mpv --no-border --loop --vo=x11 --wid=%WID /home/nixos/Downloads/live-bridge.mp4 &
				pwsh /home/nixos/.sysinfo.ps1 &
				pwsh /home/nixos/.brightness_controller.ps1 &
				exec dwm
			''

		else if config.environment.sessionVariables.ENVIRONMENT == "LXQT" then pkgs.writeText "lxqt_script"
			''
				#pwsh /home/nixos/.brightness_controller.ps1 &
				exec lxqt-session
			''

		else if config.environment.sessionVariables.ENVIRONMENT == "DEEPIN" then pkgs.writeText "deepin_script"
			''
				#pwsh /home/nixos/.brightness_controller.ps1 &
				exec startdde
			''
		
		else if config.environment.sessionVariables.ENVIRONMENT == "GNOME" then pkgs.writeText "gnome_script"
			""

		else throw "Invalid ENVIRONMENT variable in configuration: ${config.environment.sessionVariable.ENVIRONMENT}";
in
{
    # Packages that didnt work automatically
    nixpkgs.config = {
		allowUnfree = true;
		permittedInsecurePackages = [
			"electron-27.3.11"
		];
    };

    # New path for the nixos config
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.activationScripts = {
		user-xsession-link.text = ''
			install -m 755 -o nixos -g users "${xsessionSource}" /home/nixos/.xsession
			echo --------------------------------------------------------------------------
			echo "Successfully created the startup file for the ${config.environment.sessionVariables.ENVIRONMENT} system"
			echo --------------------------------------------------------------------------
		'';
	};
}
