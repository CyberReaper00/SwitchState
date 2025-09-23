{ config, lib, pkgs, ... }:

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

    # Enable the X11 services
	services = {

		# Xserver Settings
		xserver = {
			enable = true;

			# Configure keymap in X11
			xkb = {
				layout = "us,pk(urd-phonetic)";
				options = "caps:ctrl_modifier, grp:alts_toggle";
				# extraLayouts = {
				# 	basic = {
				# 		description = "Remaps that make it easier to use qwerty";
				# 		languages = [ "eng" ];
				# 		symbolsFile = /home/nixos/nixos/user_configs/better_maps;
				# 	};
				# };
			};
		};

		# Enable flatpak
		flatpak.enable = true;

		# Enable cloudflared for tunnelling
		cloudflared.enable = true;

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
				opacity-rule = [ "80:class_g = 'XTerm'" ];
			};
		};

		dbus.enable = true;
		kubo.enable = true;
	};

	# Enable bluetooth support
    hardware = {
		bluetooth.enable = true;
		graphics = {
			enable = true;
			enable32Bit = true;
			# package32 = pkgs.intel-vaapi-drive;
		};
	};
}
