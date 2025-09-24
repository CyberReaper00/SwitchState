# Overview
This is my NixOS configuration that I have built it in the most nix way as I possibly could

In this config I can switch my system state to be any DE or WM with just one command, admittedly through an alias in my shell config

Currently I have defined five seperate system states that the config can use but with the architecture of nixos and the simplistic design of my setup the number of states (configurations) can be increased to handle and switch between infinite system configs and a new one can be create in about five minutes - they would just need to be defined appropriately

I have made it as simple as possible so that anyone who wants to try using this as their system, whether new or old, can do so. However, the system uses flakes and a very spreadout config of over a dozen files, so it must be advised that people new to NixOS check out the [wiki](https://github.com/CyberReaper00/SwitchState/wiki) that ive made, which goes over how a configuration is setup in nixos and how to use it

If you are not already familiar with the nix way of doing things then going through this config will be next to impossible

I have done my best to explain the purpose of each file and its contents and how someone might update it, but if any confusion is still there in the README then as was said before you should go read the wiki
## Nix Specific Files
This is my system flake, it is as simple and barren as i couldve possibly made it
### System Flake [flake.nix]
 ```
{
	 description = "Main Flake";
	 inputs = { nixpkgs.url = "nixpkgs/nixos-25.05"; };
	 outputs = { self, nixpkgs, ... }:
	 
    let
		lib = nixpkgs.lib;
    in {
		nixosConfigurations = {
			main-config = lib.nixosSystem {
				system = "x84_64-linux";
				modules = [ ./dwm_config.nix ];
			};
		};
	};
}
```

There are some simple settings that tell nixos
- The name of the flake
- Which version of the system i am using and the packages i should be able to install on my system
- The output configurations that will passed to the system once it has parsed the configuration
- The `let ... in` expression just defines the `lib` module from which i am using the `nixosSystem` sub-module
- In the `nixosConfigurations` set i define,
	- The name of my system config
	- The type of architecture its supposed to run on
	- The path(s) that point to the configuration for the system that i want to build
### Dotfile Management [scripts.nix]
```
# ===============> Configs for the nixos user
# Nvim config
rm -rf /home/nixos/.config/nvim
ln -sf /home/nixos/nixos/user_configs/nvim_config /home/nixos/.config/nvim
chown -h nixos:users /home/nixos/.config/nvim

install -m 755 -o nixos -g users /home/nixos/nixos/scripts/startup.sh /home/nixos/.startup.sh
install -m 755 -o nixos -g users /home/nixos/nixos/scripts/sysinfo.ps1 /home/nixos/.sysinfo.ps1
install -m 755 -o nixos -g users /home/nixos/nixos/scripts/brightness_controller.ps1 /home/nixos/.brightness_controller.ps1

# Custom .desktop files
mkdir -p /home/nixos/.local/share/applications
ln -sf /home/nixos/nixos/scripts/launcher_scripts /home/nixos/.local/share/applications
chown nixos:users /home/nixos/.local/share/applications
```

I have heard of home-manager and I can see the utility in that but I dont really have that many configs to take care of so I didnt really want to spend time configuring a system in my system to manage some file for some packages in my system, so I just wrote a simple script that runs on startup

It is the simplest nix script that I could think of and in it I have just divided the file into seperate sections for the different users of the system, this is how it functions
- I just have my configs for my programs, like for nvim and powershell, in my nixos folder and they are just symlinked to the "correct" folders that application expects them to be in
- If you wish to seperate multiple nix-paths in the same line then you can just place a space in between them as I have done above, donot use `,` to seperate them as that is not accepted and will throw an error

- If you wish to seperate multiple nix-paths in the same line then you can just place a space in between them as I have done above, donot use `,` to seperate them as that is not accepted and will throw an error

The rest of the management file or `scripts.nix` is written in the same manner, linking and placing configs to the correct dirs so that every program can find its config
### DWM System Config [dwm_config.nix]
In this file i have defined the configuration for dwm with all the systemPackages that i want to use in there

Ive also integrated a simple xsession file that ive placed in there as a startup script for apps that i want open on startup

```
		(final: prev: {
			dwm = prev.dwm.overrideAttrs (old: {
				src = ./user_configs/dwm;
			});
		})
```
- This is used to get the libraries needed to compile dwm and then override the source code that is already present in NixOS with your own customized source code, whether locally or from an online repo
- I have done it locally, since it is easier to manage

```
		(final: prev: {
			slock = prev.slock.overrideAttrs (old: {
				 src = ./user_configs/slock;
				 buildInputs = (old.buildInputs or []) ++ [
					prev.xorg.libXinerama
					prev.xorg.libXft
				 ];
			});
		})
```
- I have done the same here for slock as i have done for dwm
- The `buildInputs` method is used because when compiling slock, it kept throwing errors that these libraries were not present on the system even though they were
- This is a problem that is common on NixOS, just because you have something installed, does not mean that everything else on your system can detect it and so because of that, you have to use the `prev` keyword in the `buildInputs` method to explicitly attach some libraries, modules etc to the tool list that is to be used by the binary
- In the example above I have used `xorg.libXinerama` and `xorg.libXft` because those were the things that slock wasnt detecting
- Also as you might know, the names of packages can differ from distro to distro and the package names used for NixOS can be found [here](mynixos.com) or from the terminal with `nix search nixpkgs <pkgname>`, but the terminal method needs to be enabled in your configuration file
### Other System Configs
I have defined a bunch of other configs for different systems and they all pretty much the same but have different packages that i tried on the different systems, i'll just mention those other files here

- LXQT [lxqt_config.nix]
- Gnome [gnome_config.nix]
- Deepin [deepin_config.nix]
- BSPWM [bspwm_config.nix]
- TWM [twm_config.nix]
### Environment Settings [env_settings.nix]
I have only setup two things in this file
- environment variables
- global packages

It really isnt used for anything else, makes it very simple to remove or add apps from my system
### Defaults [defaults.nix]
In nixos there are two ways of editing the settings of a program, through its config file that is in the `~/.config` folder and through the `configuration.nix` file

Sometimes both options are available and sometimes only one, this file is for the programs that can be edited through the `configuration.nix`, for the other files, i just create their config files in this repo and then symlink them to their respective folders

- In the configuration you edit the settings for these prestigious programs by using the `programs` option
- I have defined some settings in this file that setup some of the settings on a few apps
- There are some other settings defined, but those are of no consequence so i wont mention them here, if you wish to see all the specific settings then you can just go to the file
### Font Settings [font_settings.nix]
- In this file i just define some default fonts for my system
- I also downloaded some fonts from the internet and obviously theres no right-click menu to just install these random fonts onto the system so i built a function that checks the `fonts` folder and installs a each font to the system one by one, after that i just let the system know that these fonts are now installed
### Nix Settings [nix_settings.nix]
- In this file there are only a few settings that have been declared and these settings are special since they are executed only when the system is being rebuilt

```
	xsessionSource =
		if config.environment.sessionVariables.ENVIRONMENT == "DWM" then pkgs.writeText "dwm_script"
			''
				eval $(dbus-launch --sh-syntax --exit-with-session)
				exec dwm
			''
			...
```
- The main setting is the `xsessionSource` variable which contains the commands that are written to a temp file and then placed into the nix-store for later referral

```
nixpkgs.config = {
	allowUnfree = true;
	permittedInsecurePackages = [
		"electron-27.3.11"
	];
};
```
- Then in the main function it can be seen that some settings have been defined to allow special permissions to specific programs

` nix.settings.experimental-features = [ "nix-command" "flakes" ]; `
- This setting allows for the use features that are not activated by default in nix

` system.activationScripts = { `
- This is another startup script, but it runs while the system is being rebuilt so i can get it to display a message as to if the system has been built properly or not
- This script also uses the `xsessionSource` variable from before to determine which data needs to be taken, based on the system that was being built, to place in the new `.xsession` for that specific system to use
### Security Settings [security_settings.nix]
- Just a file for some security-related settings that i changed
- In this file i have disabled the password for sudo and wheel group users, so that i can install, change and move stuff around my system without having to put in a password all the time
- I also placed security-wrapper on slock since it wasnt working properly with the default permissions
### System Settings [system_settings.nix]
This is the file that handles all the background tasks for users and services, the main ones at least

There are many settings that are pretty trivial so i'll just mention them below and you can just look at the file itself if you want more details
**Misc. Settings**
- Setting boot loader options
- Setting the timezone
- Setting custom hotkeys
- Setting up picom

**Enabling Settings**
- The networking
- Xserver
- Cloudflared (web tunneling for local ports)
- Printing
- Pipewire (audio setup)
- Bluetooth
- Touchpad support
- New media detection (detecting new usbs or drives connecting to the system)
- dbus
- kubo
### User Settings [user_settings.nix]
In this file ive just defined the most basic config for the root user and my user, ive just added powershell as the default shell for both users and added my user to some user-groups
## User Specific Files
I have other configs that are more software specific which are in their own repos, if you want to check them out as well then you can do so below

**[DWM Config](https://github.com/CyberReaper00/dwm-minimal)**

**[Nvim Config](https://github.com/CyberReaper00/GreaterVim)**

**[Powershell Config](https://github.com/CyberReaper00/pwsh-config)**

**[Slock Config](https://github.com/CyberReaper00/slock-config)**

**[Rofi Config](https://github.com/CyberReaper00/rofi-config)**

### Brightness Controller [brightness_controller.ps1]
- This is just a shell script that acts as a brightness management system to detect if any movement has occurred in the last 5min
- If there is no movement then the brightness goes to 10%
- When there is movement again, the brightness goes to 100%