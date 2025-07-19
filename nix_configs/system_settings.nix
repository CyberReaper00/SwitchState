{ config, lib, pkgs, ... }:

let
	custom_fonts = pkgs.callPackage /home/nixos/nixos/nix_configs/font_settings.nix { inherit pkgs; };
in
{
    # Use the systemd-boot EFI boot loader
    boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
    };

    # Set networking settings
    networking = {
		hostName = "nixos";
		networkmanager.enable = true;
    };

    # Set your time zone.
    time.timeZone = "Asia/Karachi";

    # Enable the X11 windowing system
    services = {
		# Xserver Settings
		xserver = {
			enable = true;
			videoDrivers = ["modesetting"];

			# Configure keymap in X11
			xkb = {
				options = "caps:escape";
			#	 layout = lib.mkForce "custom";
			#    model = "";
			#    extraLayouts = {
			#        custom = {
			#    	description = "New BS";
			#    	languages = [ "eng" ];
			#    	symbolsFile = /etc/xkb/symbols/custom;
			#        };
			#    };
			};
		};

		cloudflared = {
			enable = true;
		};

		# Enable CUPS to print documents
		printing.enable = true;

		# Enable sound
		pipewire = {
			enable = true;
			pulse.enable = true;
		};

		# Enable Blueman
		blueman.enable = true;

		# Enable touchpad support (enabled default in most desktopManagers)
		libinput.enable = true;

		# Automatic detection of new media being attached
		udisks2.enable = true;

		# Starting compositor
		picom = {
			enable = true;

			settings = {
				#frame-opacity = 1.0;
				opacity-rule = [
					"70:class_g = 'qterminal'"
				];
			};
		};
    };

    hardware = {
		bluetooth.enable = true;
		graphics = {
			enable = true;
			extraPackages = with pkgs; [
				vaapiIntel
				libva-utils
			];
		};
    };

    # System fonts
    fonts = {
		packages = with pkgs; [
			hasklig
			cascadia-code
			custom_fonts.monkey
			custom_fonts.vandria
			custom_fonts.winking
			custom_fonts.dm_serif
		];

		fontconfig = {
			enable = true;
			defaultFonts = {
				monospace = [ "Cascadia Code PL" "Cascadia Code Mono" "Hasklig" ];
			};
		};
    };
}
