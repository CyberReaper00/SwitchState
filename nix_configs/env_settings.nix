{ config, lib, pkgs, ... }:

{
    # System-wide packages
    environment = {
		# Default Applications
		variables = {
			EDITOR	= "${pkgs.neovim}/bin/nvim";
			VISUAL	= "${pkgs.neovim}/bin/nvim";
			BROWSER	= "${pkgs.chromium}/bin/chromium";
			TERMINAL	= "${pkgs.lxqt.qterminal}/bin/qterminal";
			NIXPKGS_ALLOW_UNFREE = "1";
		};

		systemPackages = with pkgs; [
			_20kly
			OVMF
			abuse
			alsa-utils
			audacity
			blueman
			brightnessctl
			btop
			copyq
			discord
			dwm
			easyeffects
			fd
			feh
			firefox
			flameshot
			gh
			#ghostty
			git
			gimp
			go
			gost
			gpick
			gucharmap
			home-manager
			hugo
			icu
			libreoffice
			lxqt.qterminal
			kdePackages.dolphin
			kdePackages.kcalc
			mediawriter
			mpv
			neovim
			neovide
			nodePackages.nodejs
			ntfs3g
			obsidian
			ollama
			pamixer
			pavucontrol
			pciutils
			picom
			powershell
			pulseaudio
			pureref
			qbittorrent-enhanced
			qemu
			ripgrep
			rofi
			rofi-calc
			slock
			slstatus
			st
			steam
			superTuxKart
			tree
			tldr
			tmux
			tor-browser
			ungoogled-chromium
			unzip
			virt-manager
			vlc
			xclip
			xdotool
			xfce.mousepad
			xlsfonts
			xorg.libXinerama
			xorg.xdpyinfo
			xorg.xsetroot
			xprintidle
			xwinwrap
			zaz

			# Zig Packages
			zig

			# python packages
			python312Full
			/*
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
			*/

			# C Packages
			gcc
			gdb
			pkg-config
			clang-tools
		];
    };
}
