{ config, lib, pkgs, ... }:

{
    # System-wide packages
    environment = {
		# Default Applications
		variables = {
			EDITOR		= "${pkgs.neovim}/bin/nvim";
			VISUAL		= "${pkgs.neovim}/bin/nvim";
			BROWSER		= "${pkgs.chromium}/bin/chromium";
			TERMINAL	= "xterm";
			NIXPKGS_ALLOW_UNFREE = "1";
		};

		systemPackages = with pkgs // pkgs.xorg; [
			# OVMF
			# audacity
			bc
			brightnessctl
			btop
			copycat
			easyeffects
			evtest
			fastfetch
			fd
			# ffmpeg
			# firefox
			flameshot
			gh
			git
			gimp
			# glib
			gnome-characters
			go
			gpick
			gvfs
			kid3
			killall
			libreoffice
			# libnotify
			# mediawriter
			# mpv
			neovim
			# nodePackages.nodejs
			ntfs3g
			obsidian
			ollama
			pandoc
			pamixer
			pavucontrol
			pciutils
			linuxKernel.packages.linux_6_12.perf
			picom
			pulseaudio
			pureref
			qalculate-gtk
			qbittorrent-enhanced
			ripgrep
			steam
			syncthing
			# sxhkd
			tldr
			# tmux
			tor-browser
			tree
			ungoogled-chromium
			vlc
			xclip
			xev
			xdotool

			# Games
			_20kly
			superTuxKart
			zaz

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
