    # Edit this configuration file to define what should be installed on
    # your system. Help is available in the configuration.nix(5) man page, on
    # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports =
	[   # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    <home-manager/nixos>
	];

    home-manager = {
	useGlobalPkgs = true;
	useUserPackages = true;
	users.nixos = {
	    programs = {
		home-manager.enable = true;
		neovim = {
		    enable = true;
		    configure = {
			customRC = builtins.readFile ./configs/nvim-config/init.lua;
		    };
		};
	    };
	};
    };

    nixpkgs.config = {
	allowUnfree = true;
	permittedInsecurePackages = [
	    "electron-27.3.11"
	];
    };

    nix = {
	nixPath = [
	    "nixos-config=/home/nixos/nixos/configuration.nix"
	    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
	];
	settings = {
	    experimental-features = [ "nix-command" "flakes" ];
	};
    };

    system.activationScripts = {
	user-configs = {
	    text = builtins.readFile ./scripts/scripts.nix;
	};
    };

    # Define root settings
    users.users.root = {
	shell = pkgs.powershell;
    };

    # Define a user account and its settings
    users.users.nixos = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "libvirtd" "kvm" ];
	packages = with pkgs; [
	    tree
	];
	shell = pkgs.powershell;
    };

    # Default applications for specific file types
    xdg.portal.enable = true;
    xdg.mime.defaultApplications = {
	"text/plain" = "org.xfce.mousepad.desktop";
	"application/pdf" = "chromium.desktop";
	"image/png" = "pureref.desktop";
    };

    # Define program specific settings
    programs = {
	chromium = {
	    enable = true;
	    defaultSearchProviderEnabled = true;
	    defaultSearchProviderSearchURL = "https://sybil.com/search?q={searchTerms}";
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

	# (final: prev: let
	#     unstable = import <nixpkgs-unstable> { };
	# in {
	#     ollama = prev.ollama.overrideAttrs (oldAttrs: rec {
	# 	src = prev.fetchFromGitHub {
	# 	    owner = "ollama";
	# 	    repo = "ollama";
	# 	    rev = "v0.6.5";
	# 	    sha256 = "sha256-l+JYQjl6A0fKONxtgCtc0ztT18rmArGKcO2o+p4H95M=";
	#     };
	# 
	# 	buildPhase = ''
	# 	    export GOFLAGS=-mod=mod
	# 	    ${oldAttrs.buildPhase or "go build"}
	# 	'';
	# 	nativeBuildInputs = [ unstable.go_1_24 ];
	# 	patches = [];
	#     });
	# })
    ];
    # buildInputs = (oldAttrs.buildInputs or []) ++ [ prev.go_1_24 ];
    # https://github.com/ollama/ollama/archive/refs/tags/v0.6.5.tar.gz;

    # Enable the X11 windowing system
    services = {
	xserver = {
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

	# Enable touchpad support (enabled default in most desktopManagers)
	libinput.enable = true;
    };

    # Enable audio settings
    hardware.pulseaudio.enable = false;


    # System font
    fonts = {
	packages = with pkgs; [
	    hasklig
	    cascadia-code
	];
    };

    # Virtual Console font
    console.font = "solar24x32";

    # List packages installed in system profile. To search, run:
    environment = {
	# Define the system shell
	shells = with pkgs; [ powershell ];

	# Default Applications
	variables = {
	    EDITOR = "nvim";
	    VISUAL = "nvim";
	    BROWSER = "/run/current-system/sw/bin/chromium";
	    TERMINAL = "ghostty";
	};

	systemPackages = with pkgs; [
	    OVMF
	    audacity
	    brightnessctl
	    btop
	    copyq
	    dolphin
	    discord
	    discordo
	    dwm
	    fd
	    firefox
	    flameshot
	    gh
	    ghostty
	    git
	    go
	    gost
	    gucharmap
	    home-manager
	    icu
	    libreoffice
	    mpv
	    neovim
	    nodejs_23
	    obsidian
	    ollama
	    pamixer
	    pavucontrol
	    powershell
	    pulseaudio
	    pureref
	    qemu
	    rofi
	    tmux
	    tradingview
	    tldr
	    ungoogled-chromium
	    virt-manager
	    vlc
	    xdotool
	    xclip
	    xfce.mousepad
	    xorg.xsetroot
	    xprintidle
	    xwinwrap

	    # Python packages
	    python312Full
	    python312Packages.pip
	    python312Packages.tzdata
	    python312Packages.nuitka
	    python312Packages.xxhash
	    python312Packages.aiohttp
	    python312Packages.datetime
	    python312Packages.openpyxl
	    python312Packages.requests
	    python312Packages.openpyxl
	    python312Packages.discordpy

	    # C Packages
	    gcc
	    gdb
	    pkg-config
	    clang-tools
	];
    };

    # xwinwrap -fs -fdt -b -nf -- mpv --no-border --loop --vo=x11 --wid=%WID /path/to/video.mp4 &

    security.sudo = {
	enable = true;
	wheelNeedsPassword = false;
	extraRules = [
	    {
		users = [ "nixos" ];
		commands = [{
		    command = "/run/current-system/sw/bin/neovide";
		    options = [ "SETENV" "NOPASSWD" ];
		}];
	    }
	];
    };

    # System version
    system.stateVersion = "24.11";
}
