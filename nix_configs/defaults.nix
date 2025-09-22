{ config, lib, pkgs, ... }:

let
	mimeapp-list = pkgs.writeText "mimeapps.txt" ''
[Default Applications]
text/plain=org.xfce.mousepad.desktop;
application/pdf=chromium.desktop;
image/png=pureref.desktop;
image/jpg=pureref.desktop;
image/jpeg=pureref.desktop;
image/gif=pureref.desktop;
x-scheme-handler/http=chromium.desktop;
x-scheme-handler/https=chromium.desktop;

[Added Associations]

[Removed Associations]
image/gif=vlc.desktop;
	'';
in
{

    # Default applications for specific file types
	xdg = {
		menus.enable = true;
		autostart.enable = true;
		portal = {
			enable = true;
			config.common.default = "gtk";
			extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		};
	};

	system.activationScripts.set-mimetypes.text = ''
		install -m 644 -o nixos -g users "${mimeapp-list}" /home/nixos/.config/mimeapps.list
	'';

    # Define program specific settings
    programs = {
		dconf.enable = true;
		kdeconnect.enable = true;
		steam.enable = true;

		chromium = {
			enable = true;
			defaultSearchProviderEnabled = true;
			defaultSearchProviderSearchURL = "https://www.startpage.com/sp/search?query={searchTerms}";
			homepageLocation = "https://www.startpage.com/";

			extraOpts = {
				"WebAppInstallForceList" = [
					#{
					#	"custom_name" = "Youtube";
					#	"create_desktop_shortcut" = false;
					#	"default_launch_container" = "window";
					#	"url" = "https://youtube.com";
					#}
					{
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
    };

}
