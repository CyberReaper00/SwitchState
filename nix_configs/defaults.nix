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
			defaultSearchProviderSearchURL = "https://www.startpage.com/sp/search?query={searchTerms}";
			homepageLocation = "https://www.startpage.com/";
			extensions = [
				"fnpbehpgglbfnpimkachnpnecjncndgm;https://clients2.google.com/service/update2/crx" # chromium web store ocaahdebbfolfmndjeplogmgcagdmblk
				"eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx" # dark reader
				"fofhikdigdjbhphnekoglnjkoifoldhj;https://clients2.google.com/service/update2/crx" # fuzzy tab finder
				"aapbdbdomjkkjkaonfhkkikfgjllcleb;https://clients2.google.com/service/update2/crx" # google translate
				"fefodpegbocmidnfphgggnjcicipaibk;https://clients2.google.com/service/update2/crx" # notepad
				"cmgdpmlhgjhoadnonobjeekmfcehffco;https://clients2.google.com/service/update2/crx" # ollama-ui
				#"cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx" # ublock origin
				"nbhcbdghjpllgmfilhnhkllmkecfmpld;https://clients2.google.com/service/update2/crx" # user javascript and css
				"hfjbmagddngcpeloejdejnfgbamkjaeg;https://clients2.google.com/service/update2/crx" # vimium c
			];

			extraOpts = {
				"WebAppInstallForceList" = [
					{
						"custom_name" = "Youtube";
						"create_desktop_shortcut" = false;
						"default_launch_container" = "window";
						"url" = "https://youtube.com";
					} {
						"custom_name" = "Gemini";
						"create_desktop_shortcut" = false;
						"default_launch_container" = "window";
						"url" = "https://gemini.google.com";
					} {
						"custom_name" = "MonkeyType";
						"create_desktop_shortcut" = false;
						"default_launch_container" = "window";
						"url" = "https://monkeytype.com";
					} {
						"custom_name" = "Gmail";
						"create_desktop_shortcut" = false;
						"default_launch_container" = "window";
						"url" = "https://mail.google.com/mail/u/0/#inbox";
					} {
						"custom_name" = "Discord";
						"create_desktop_shortcut" = false;
						"default_launch_container" = "window";
						"url" = "https://discord.com";
					} {
						"custom_name" = "WhatsApp";
						"create_desktop_shortcut" = false;
						"default_launch_container" = "window";
						"url" = "https://web.whatsapp.com";
					}
				];
			};
		};

		nix-ld = {
			enable = true;
			libraries = with pkgs; [
				glibc
				zlib
				openssl
			];
		};
		
		kdeconnect.enable = true;
    };

}
