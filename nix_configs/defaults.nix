{ config, lib, pkgs, ... }:

{
    # Default applications for specific file types
    xdg = {
	portal = {
	    enable = true;
	    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};

	mime.defaultApplications = {
	    "text/plain"		= "org.xfce.mousepad.desktop";
	    "application/pdf"	= "chromium.desktop";
	    "image/png"		= "pureref.desktop";
	    "image/jpg"		= "pureref.desktop";
	    "image/jpeg"	= "pureref.desktop";
	    "image/gif"		= "pureref.desktop";
	};
    };

    # Define program specific settings
    programs = {
	chromium = {
	    enable = true;
	    defaultSearchProviderEnabled = true;
	    defaultSearchProviderSearchURL = "https://sybil.com/search?q={searchTerms}";
	};
	nix-ld = {
	    enable = true;
	    libraries = with pkgs; [
		glibc
		zlib
		openssl
	    ];
	};
    };

}
