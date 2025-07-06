{ config, lib, pkgs, ... }:

{
    # Default applications for specific file types
    xdg = {
		mime.defaultApplications = {
			"text/plain"	= "org.xfce.mousepad.desktop";
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
			extensions = [
				"ocaahdebbfolfmndjeplogmgcagdmblk" # chromium web store
				"eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
				"fofhikdigdjbhphnekoglnjkoifoldhj" # fuzzy tab finder
				"aapbdbdomjkkjkaonfhkkikfgjllcleb" # google translate
				"fefodpegbocmidnfphgggnjcicipaibk" # notepad
				"cmgdpmlhgjhoadnonobjeekmfcehffco" # ollama-ui
				"cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
				"nbhcbdghjpllgmfilhnhkllmkecfmpld" # user javascript and css
				"hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium c
			];
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
