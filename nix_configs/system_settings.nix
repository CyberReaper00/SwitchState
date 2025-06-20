{ config, lib, pkgs, ... }:

{
    # Use the systemd-boot EFI boot loader.
    boot.loader = {
	systemd-boot = {
	    enable = true;
	};

	efi = {
	    canTouchEfiVariables = true;
	};
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
	    displayManager.lightdm.enable = true;

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
    };

    hardware = {
	bluetooth.enable = true;
    };

    # System fonts
    fonts = {
	packages = with pkgs; [
	    hasklig
	    cascadia-code
	];

	fontconfig = {
	    enable = true;
	    defaultFonts = {
		monospace = [ "Cascadia Code PL" "Cascadia Code Mono" "Hasklig" ];
	    };
	};
    };
}
