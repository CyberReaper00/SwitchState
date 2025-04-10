    # Edit this configuration file to define what should be installed on
    # your system. Help is available in the configuration.nix(5) man page, on
    # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports =
	[   # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	];

    nixpkgs.config = {
	allowUnfree = true;
	permittedInsecurePackages = [
	    "electron-27.3.11"
	];
    };

    nix.nixPath = [
	"nixos-config=/home/nixos/nixos/configuration.nix"
	"nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    ];

    system.activationScripts = {
	user-configs = {
	    text = builtins.readFile ./scripts/scripts.nix;
	};
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
	loader = {
	    systemd-boot = {
		enable = true;
	    };
	    efi = {
		canTouchEfiVariables = true;
	    };
	};
    };

    # Set networking settings
    networking = {
	hostName = "nixos";
	networkmanager = {
	    enable = true;
	};
    };

    # Set your time zone.
    time.timeZone = "Asia/Karachi";

    # Extract dwm confg information from its source folder
    nixpkgs.overlays = [
	(final: prev: {
	 dwm = prev.dwm.overrideAttrs (old: {
		 src = ./configs/dwm;
		 });
	 })
    ];

    # Enable the X11 windowing system
    services.xserver = {
	enable = true;
	windowManager = {
	    dwm = {
		enable = true;
	    };
	};
	displayManager = {
	    lightdm = {
		enable = true;
	    };
	};
	desktopManager = {
	    lxqt = {
		enable = true;
	    };
	};

    # Configure keymap in X11
	xkb = {
	    layout = "us";
	    options = "caps:escape";
	};

    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound.
    services.pipewire = {
	enable = true;
	pulse.enable = true;
    };

    # Enable audio settings
    hardware.pulseaudio.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Define a user account and its settings
    users.users.nixos = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "libvirtd" "kvm" ];
	packages = with pkgs; [
	    tree
	];
	shell = pkgs.powershell;
    };

    # Define program specific settings
    programs = {
	chromium = {
	    enable = true;
	    defaultSearchProviderEnabled = true;
	    defaultSearchProviderSearchURL = "https://sybil.com/search?q={searchTerms}";
	};
    };

    # System font
    fonts = {
	packages = with pkgs; [
	    hasklig
	    cascadia-code
	];
    };

    # List packages installed in system profile. To search, run:
    environment = {
	systemPackages = with pkgs; [
	    OVMF
	    audacity
	    dolphin
	    discord
	    dwm
	    firefox
	    flameshot
	    gh
	    ghostty
	    git
	    go
	    gost
	    icu
	    libreoffice
	    mpv
	    neovim
	    neovide
	    nodejs_23
	    obsidian
	    ollama
	    pamixer
	    pavucontrol
	    powershell
	    pureref
	    qemu
	    rofi
	    tmux
	    tradingview
	    tldr
	    ungoogled-chromium
	    virt-manager
	    vlc
	    xfce.mousepad
	    xclip
	    xorg.xsetroot
	    xwinwrap

	    # Python packages
	    python312Full
	    python312Packages.pip
	    python312Packages.nuitka
	    python312Packages.xxhash
	    python312Packages.datetime
	    python312Packages.openpyxl
	    python312Packages.discordpy
	    python312Packages.requests
	    python312Packages.aiohttp
	    python312Packages.openpyxl
	    python312Packages.tzdata

	    # C Packages
	    gcc
	    gdb
	    clang-tools
	    pkg-config
	];

	# Default Applications
	variables = {
	    EDITOR = "nvim";
	    VISUAL = "nvim";
	    BROWSER = "/run/current-system/sw/bin/chromium";
	};
    };

    # Default applications for specific file types
    xdg.portal.enable = true;
    xdg.mime.defaultApplications = {
	"text/plain" = "org.xfce.mousepad.desktop";
	"application/pdf" = "chromium.desktop";
	"image/png" = "pureref.desktop";
    };

    # xwinwrap -fs -fdt -b -nf -- mpv --no-border --loop --vo=x11 --wid=%WID /path/to/video.mp4 &

    # System version
    system.stateVersion = "24.11";
}
