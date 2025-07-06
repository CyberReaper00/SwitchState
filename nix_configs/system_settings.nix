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
			displayManager = {

				lightdm = {
					enable = true;
					greeters.slick = {
						enable = true;
						theme.name = "Nordic";
					};
				};
			};

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
    };

    hardware = {
		bluetooth.enable = true;
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
