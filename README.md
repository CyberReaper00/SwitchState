# Overview
This is my NixOS configuration that I have built it in the most nix way as I possibly could

In this config I can switch my system state to be any DE or WM with just one command by defining the configurations in the main system flake, currently I have only defined three systems that the config can use but with the architecture I have defined it can be increased to handle and switch between infinite system configs - they would just need to be defined appropriately

I have made it as simple as possible so that anyone who wants to try using this as their system, whether new or old, can do so. However, the system uses flakes and a very spreadout config of over a dozen files, so it must be advised that people new to NixOS read through everything very carefully, if you are not already familiar with the nix way of doing things then going through this config will be next to impossible

I will try to do my best to explain the purpose of each file and its contents and how someone might update it, but if any confusion is still there in the README then any suggestion of improvement is welcome
## What is a Flake
A flake in NixOS can be considered as a main hub for all files, configurations and modules that you might want to use, for example if you are building a school then it would be wise to have a principal at the top telling coordinators what to do and when to do them, then they will tell teachers in their departments or sections of the school to do things this way by this time and in the end the teachers will do their job and this system ensures, as it should, that the students at the end get the result that they expect, to be bored out of their minds

In the same way a flake is the main link in any architecture you might want to setup on your system with many branching paths and sources of truth and so you give the flake something pivotal or trivial to control based on your narrative to take care of its task of branching things out, while the branches take care of the tasks that they are supposed to

But due to the modular and connected nature of flakes these can be used for other things as well such as getting the source code of a program from github, gitlab etc and then compiling it on your system or defining and setting up a docker container among other extensible things

## The Nix Language
In nix, the language, there are many nuances and differences compared to other more imperitive or procedural type of languages that many people are familiar with. Since it is a functional language the way of implementing code and furthermore can be quite alien to someone coming from a more normal background, a few examples have been given below to help you understand how things work here

### Normal file syntax
```
{ config, lib, pkgs, ... }:

{
	users.users.nixos = {
		isNormalUser = true;
		extraGroups = [ "wheel" "libvrtd" "lp" ]
		shell = pkgs.fish;
	};
}
```

**Libraries**
`{ config, lib, pkgs, ... }:`
- In the above example the first line is just a list of libraries that will be used in the code block below

**Global Scope**
` `
- The empty space is actually not useless, it is the global scope in which all variables and functions are declared and then used in the code block below as i will show later

**The main function**
```
{
	...
}
```
- This is where all the functionality of the nix file is executed, it helps to think of it as the main function in C or GO, where if the code is not in here then it will not be executed

### An in-depth configuration
The following is a more detailed example of the syntax, it can get a bit trippy so be sure to read thoroughly and take time understanding it
```
{ config, lib, pkgs, ... }
let
	t_val = true;
	path1 = /home/nixos/Documents/file.sh;
	
	final_path = if builtins.pathExists path1 then
		path1;
	else
		/home/nixos/Documents/new_file.sh;
	
	function_name = param1: param2: {
		networking = {
			hostName = param1;
			networkManager.enable = param2;
		};
	};
in
{
	boot.loader = {
		systemd-boot.enable = t_val;
	}

	function_name "nixos" t_val

	system.activationScripts = {
		script1.text = builtins.readFile final_path;
	}
}
```
- The above example shows a more in-depth configuration more akin to something that you would write to define the settings of programs and services on you system

**Libraries**
` { config, lib, pkgs, ... } `
- All the libraries go at the top as discussed before

**Global Scope**
` let ... in `
- The `let ... in` expression is an interesting bit of functional syntax since it allows for the declaration of almost anything from variables to code snippets to entire functions
- The way this works is, is the user defined values that will be used later on in the main function
- In a normal language it would take the values, store them in the variables and wait until it is called and needs to be used, at that point the language will get the data and use it wherever needed
- In nix however and in the `let ... in` expression, the value is saved to the variable that is defined and then it is immediately passed to the main function where it is used, the storage step is completely skipped, that is why the `let ... in` expression is phrased as such
- Let, these values be placed, in, here as the variable names have been defined for them

**Variables**
` t_val = true; `
- It just contains the value `true` in the variable `t_val`

` path1 = /home/nixos/Documents/file.sh; `
- This shows the true purpose of using nix over another language
- Nix allows for the direct usage of paths as first-class citizens such as variables, conditionals etc and gets the data of the file specified to be used within the configuration directly
- When declaring a path, there is no need to place it in `'` or `"`, they are written as is in the form of either an absolute or relative path, in a nix file you shouldnt define a path, you should define a nix-path

**Conditionals**
` final_path = if builtins.pathExists path1 then `
- This shows how an `if ... else if ... else` statement is handled within nix
- In the statement a `builtins` function is used, these functions are provided by nix by default to aid in the usage of paths throughout a nix file, you can look at the list of all the `builtins` available in nix [here](https://nix.dev/manual/nix/2.28/language/builtins) and [here](https://noogle.dev/q?limit=100&page=1)

**Functions**
` function_name = param1: param2: { `
- In nix a function always returns (or is supposed to return) an `attribute set`
	- An `attribute set`, as defined beforehand, is just a `key-value pair`
	- Also because of this necessity of a valid output, there are two ways a function can be written in nix
	- The first method is what is shown above and explained below
- If you structure the function incorrectly then nix will give an error because the returned output was not in the form of an `attribute set`
- The way to make sure this occurs is really simple, look at what the function body looks like
- If you function, as shown above, has a single key with many values then the final result will be an attribute set and all you have to do is to place it all in one encompassing body with this `{...}` just like you would for a normal function in any other language
- However, if you are placing another function inside of this function, then the encompassing `{...}` should not be used as the interior function should return an attribute set, which in turn will be passed to the parent function, henceforth returning a valid output
- The second type of function will discussed later on in `Font Settings`

**The main function**
` { ... } `
- The main function code block is pretty self explanatory
- The `boot.loader` sets the boot loader settings
- The network setting function is executed pretty cleanly as `function_name "nixos" t_val(true)` which would then expand out to be the code defined in the function beforehand
- The `system.activationScripts` function just takes in a file and then executes it on startup before the user logs into the system

### Options and Modules
- The actual methodology of when to place `equal_braces` and when to use a `.` is pretty simple
- In nix, there is a system of options and sub-modules that is used to get and assign the settings and configurations of all programs and services on your system
- A simple example of how these module trees can be structured is given below

```
option.module1.module1_1 = value;

or

option = {
	module1 = {
		module1_1 = value;
	}
}
```

- Both of these methods of defining an option are correct and I have done so the second way so that I can reduce redundant code
- For example, if we take the code below,

```
option.module1.module1_1 = value;
option.module1.module1_2 = 'value';
option.module1.module1_3 = 12;
option.module2.module2_1 = true;
option.module2.module2_2 = false;
option.module2.module2_3 = ./new_folder/some_file.c;
```

Then the above is correct, but it can also be concisely written as such,

```
option = {
	module1 = {
		module1_1 = value;
		module1_2 = 'value';
		module1_3 = 12;
	}
	module2 = {
		module2_1 = true;
		module2_2 = false;
		module2_3 = ./new_folder/some_file.c;
	}
}
```

- Some options have modules and some dont, like the description option as it only takes in a string value
- If you ever need to figure out how to change a setting for a specific program then you can always check ` man configuration.nix ` in your terminal and then search for the program or setting with `/` or you can go check out [mynixos](mynixos.com) or ask someone on the [nixos discourse](discourse.nixos.org)
- If even still you require a more deeper understanding of how all of this works and connects to eachother, i highly recommend watching this [video](https://www.youtube.com/watch?v=5D3nUU1OVx8&pp=ygUNbml4IGV4cGxhaW5lZA%3D%3D) on youtube as it explains everything that you will need to know to use nix in any capacity
## Nix Specific Files
Below is an overview on the main flake I use for my system and the list of all the files and how they are structured,
### System Flake [flake.nix]
 ```
{ # this is like the main function in C, everything goes in here
	 description = "Main Flake";
	 inputs = { nixpkgs.url = "nixpkgs/nixos-25.05"; };
	 outputs = { self, nixpkgs, ... }:
	 
    let
		lib = nixpkgs.lib;
    in {
		nixosConfigurations = {
			dwm-config = lib.nixosSystem {
				system = "x84_64-linux";
				modules = [ /home/nixos/nixos/dwm_config.nix ];
			};

			lxqt-config = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./lxqt_config.nix ];
			};

			gnome-config = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./gnome_config.nix ];
			};

			deepin-config = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./deepin_config.nix ];
			};
		};
	};
}
```

` description = "Main Flake"; `
- In the flake, it is not necessary, but you can define simple description of what it is supposed to do
- As you can see, I defined nothing

` inputs = { nixpkgs.url = "nixpkgs/nixos-25.05"; }; `
- This is the inputs attribute set where you can define all the inputs that the system might need to complete its function flow
- An attribute set is basically like a defined dictionary in python, you have key-value pairs in `{}`, by a defined dictionary i mean that in python you can define a variable and place a dictionary in there and then use it throughout your code, but in nix the variable is pre-defined such as `inputs` and all you have to do is define its settings for the flake to use
- In an attribute set the pairs put in must all be concluded with `;`, if that is not placed then nix will give an error on build or execution of any nix file
- In a flake, many options are available and you can go through them in the following places at your leisure
	- [NixOS Wiki](https://nixos.wiki/wiki/Flakes)
	- [Flakes Handbook](https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/intro)
	- You could also use the `nix flake` command in the terminal to test different ways of running flakes
- In the config you see the option of `nixpkgs.url` and what that is, is a method of the nixpkgs class which points to the specific url from which NixOS will be pulling all repos from which all your packages will be installed
	- This specific option however is not necessary and if you dont know what to get then you can just do the following
		` inputs = { nixpkgs; }; `
		and it will just grab the latest versions of the packages you want to install

` outputs = { self, nixpkgs, ... }: `
- This option is here to take in all the inputs defined above to be used in the execution of the flake
- As it is defined,
	- `self` executes any flake related functions that might be deemed necessary upon a rebuild of the system, so basically the flake takes care of its own libraries and dependencies
	
	- `nixpkgs` gets all the packages that you have defined and then grabs those packages from the nixpkgs repo online and then compiles them on your system
	
	- `...` is there for posterity, if there is something else that is needed but you didnt know that it was needed, the `...` acts as a permission command to give NixOS control of the system to deal with any missing dependencies or modules on your behalf
	
	- `}:` at the end is how the output set is concluded

`nixosConfigurations`
- This does just as you would assume and handles all configurations on your system
- As it is defined,
	- `dwm-config` is the header that holds the config for my dwm setup
		- `system` is the system architecture of your CPU whether it be
			`x86_64`, `x86_32`, `aarch64`, `i686`, `powerpc64`, `riscv32`, `riscv64`, etc.
		- `modules` holds all the files for my dwm config
			- The module holds only one file because i have defined my entire config in that file and connected all other files/imports to that file so that I can keep my flake minimal and clean, but if you wish to do so then you can define the entire config for multiple configs all in this one flake, I have just seperated everything because thats what I want
	- In the same fashion, I have defined the other configs
### Dotfile Management [scripts.nix]
```
# ===============> Configs for the root user
# Powershell config
mkdir -p /root/.config/powershell
ln -sf /home/nixos/nixos/user_configs/pwsh_config /root/.config/powershell
chown -h root:root /root/.config/powershell

# Nvim config
mkdir -p /root/.config/nvim
ln -sf /home/nixos/nixos/user_configs/nvim_config /root/.config/nvim
chown -h root:root /root/.config/nvim

# GTK config 
mkdir -p /root/.config/gtk-3.0
ln -sf /home/nixos/nixos/user_configs/settings.ini /root/.config/gtk-3.0/settings.ini
chown root:root /root/.config/gtk-3.0/settings.ini

# ===============> Configs for the nixos user
# Powershell config
rm -rf /home/nixos/.config/powershell
ln -sf /home/nixos/nixos/user_configs/pwsh_config /home/nixos/.config/powershell
chown -h nixos:users /home/nixos/.config/powershell

# Nvim config
rm -rf /home/nixos/.config/nvim
ln -sf /home/nixos/nixos/user_configs/nvim_config /home/nixos/.config/nvim
chown -h nixos:users /home/nixos/.config/nvim

# Ghostty config
mkdir -p /home/nixos/.config/ghostty
ln -sf /home/nixos/nixos/user_configs/config /home/nixos/.config/ghostty/config
chown nixos:users /home/nixos/.config/ghostty/config

# Rofi config
mkdir -p /home/nixos/.config/rofi
ln -sf /home/nixos/nixos/user_configs/config.rasi /home/nixos/.config/rofi/config.rasi
chown nixos:users /home/nixos/.config/rofi/config.rasi

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
- In the case of my powershell profile
	- `mkdir -p /root/.config/powershell`
		- This checks if this directory exists, if it does not then it is created
	- `ln -sf /home/nixos/nixos/user_configs/pwsh_config /root/.config/powershell`
		- This links the powershell dir in my nixos dir, which I keep there so that all of my configuration is in one dir, to the correct dir where powershell looks for its profile
	- `chown -h root:root /root/.config/powershell`
		- This makes sure that the permissions for this dir and everything in it belong only to the user that this config is for

- If you wish to seperate multiple nix-paths in the same line then you can just place a space in between them as I have done above, donot use `,` to seperate them as that is not accepted and will throw an error

The rest of the management file or `scripts.nix` is written in the same manner, linking and placing configs to the correct dirs so that every program can find its config

**The rest of the configs are too big to be placed as is and so i will only be writing snippets from each and defining them as simply as i can**
### DWM System Config [dwm_config.nix]
```
let
	sets = pkgs // pkgs.xorg // pkgs.lxqt // pkgs.xfce;
in
```
- This is defining the global variable `sets` which holds all the attribute sets for package names which are part of a sub-module and is used later in the `systemPackages` configuration to mainly reduce boilerplate

```
    imports =
	[   # Include the results of the hardware scan.
	    ./hardware-configuration.nix
	    ./nix_configs/user_settings.nix
	    ./nix_configs/nix_settings.nix
	    ./nix_configs/container_settings.nix
	    ./nix_configs/defaults.nix
	    ./nix_configs/system_settings.nix
	    ./nix_configs/env_settings.nix
	    ./nix_configs/security_settings.nix
	];
```
- In this I am importing many files into this one config, all of these imports are just settings that typically would be in one configuration file but I have seperated them to make it easier to find a specific setting
- Each files will be explained in detail later on

` sessionVariables.ENVIRONMENT = "DWM"; `
- This is placed here so that I have a way of knowing which environment I am switching to, this allows me to set specific settings for each system while the conversion is happening
- The actual option in this line is `environment.sessionVariables`, the `ENVIRONMENT` keyword is the name for the environment variable that will be stored on my machine
- If this variable exists then NixOS will update its value to be `DWM` if it does not exist then the variable will be created and its value will be set, this name can be anything from `HOME` to `cUsToM` there is no specific list of variables that you are allowed to use
- I have just set the custom variable to be `ENVIRONMENT` because it made sense

` systemPackages = with sets; [...]; `
- This is a list of packages that will only be installed when i activate the `dwm-config` and in other configs none of these packages will be activated but they will be kept around for future use in the nix-store until garbage collection is run
- Some of the packages are, `alsa-utils` `blueman` `feh` among others which you can check by going to the file

```
	services.xserver.enable = true;
	services.xserver = {
			displayManager = {
				lightdm.enable = true;
				sessionCommands = ''
					find '/home/nixos/Pictures/Backgrounds/landscape/' -type f | shuf -n 1 | xargs feh --bg-fill
					#sh xwinwrap -fs -fdt -b -nf -- mpv --no-border --loop --vo=x11 --wid=%WID /home/nixos/Downloads/live-bridge.mp4 &
					pwsh /home/nixos/.sysinfo.ps1 &
					pwsh /home/nixos/.brightness_controller.ps1 &

					if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
						eval $(dbus-launch --sh-syntax --exit-with-session)
					fi
					systemctl --user import-environment DISPLAY XDG_CURRENT_DESKTOP XDG_VTNR DBUS_SESSION_BUS_ADDRESS
					systemctl --user start gvfs-daemon.service || true
				'';
			};
			windowManager.dwm.enable = true;
		};
	};
```
- This is quite a simple command and it just states the following

` services.xserver.enable = true; `
- Enable xserver

` services.xserver = { `
- On xserver enable the following

` displayManager.lightdm.enable = true; `
- Enable lightdm

` sessionCommands = '' `
- When the display manager starts up, run these commands

` windowManager.dwm.enable = true; `
- Set the window manager to be dwm
- It will now use dwm as the default environment when you login

`   nixpkgs.overlays = [ `
- This is used to edit the source code of a program by adding patches or removing code

```
		(final: prev: {
			dwm = prev.dwm.overrideAttrs (old: {
				src = ./user_configs/dwm;
			});
		})
```
- This is used to get the libraries needed to compile dwm and then override the source code that is already present in NixOS with your own customized source code, whether locally or from an online repo

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
- This is used to do the same as the dwm override but for slock
- The `buildInputs` method is used because when compiling slock, it kept throwing errors that these libraries were not present on the system even though they were
- This is a problem that is common on NixOS, just because you have something installed, does not mean that everything else on your system can detect it and so because of that, you have to use the `prev` keyword in the `buildInputs` method to explicitly attach some libraries, modules etc to the tool list that is to be used by the binary
- In the example above I have used `xorg.libXinerama` and `xorg.libXft` because those were the things that slock wasnt detecting
- Also as you might know, the names of packages can differ from distro to distro and the package names used for NixOS can be found [here](mynixos.com) or from the terminal with `nix search nixpkgs <pkgname>`, but the terminal method needs to be enabled in your configuration file
### LXQT System Config [lxqt_config.nix]
This config is pretty similar compared to the previous config except for the following changes
` environment.sessionVariables.ENVIRONMENT = "LXQT"; `
- The variable value is set to `LXQT` instead of `DWM`

` desktopManager.lxqt.enable = true;  `
- The `windowManager` option is replaced with the `desktopManager` option and set to be `lxqt`
### GNOME System Config [gnome_config.nix]
This also has similar settings as lxqt except for the following changes
` environment.sessionVariables.ENVIRONMENT = "GNOME"; `
- The variable is set to `GNOME` instead of `LXQT`

` displayManager.gdm.enable = true; `
- The `displayManager` is set to `gdm` instead of `lightdm`

` desktopManager.gnome.enable = true; `
- The `desktopManager` is set to `gnome` instead of `lxqt`
### DEEPIN System Config [deepin_config.nix]
This is pretty much the same as the gnome config except for one change
` desktopManager.deepin.enable = true; `
- The `desktopManager` is changed to `deepin` and everything else stays the same
### Environment Settings [env_settings.nix]
As this is a simple file with a few settings i'll only provide some snippets and examples
` environment.variables = {...} `
- This option for the `environment` method allows for the creation and assigning values of environment variables
- If you have a variable named `Something` then you can just define the variable and its settings as such
	```
	environment.variables = {
		Something = "value";
		SomeThingElse = "value";
	}
	```
- The name is case-sensitive and the value should always be a string as defined by `man configuration.nix`

> The value of each variable can be either a string or a list of strings. The latter is concatenated, interspersed with colon characters.

` systemPackages = with pkgs; [ `
- `systemPackages` is how you define the packages that you want to install on your system, the `with pkgs` parameter is written to reduce boilerplate within the actual array that contains the list of packages
- The default method to declare packages is as such
```
	environment.systemPackages = [
		pkgs.nvim
		pkgs.git
		pkgs.gimp
		pkgs.firfox
	];
```

- But this can get annoying and because of that you can, as i have done so, use the `with` keyword to pass the `pkgs` attribute set to all the internal package names that need them which makes the final list look like this
```
environment.systemPackages = with pkgs; [
	nvim
	git
	gimp
	firefox
];
```
### Defaults [defaults.nix]
This file holds all the default settings for programs that dont have their own custom configs which i can edit seperately

```
let
	mimeapp-list = pkgs.writeText "mimeapps.txt" ''
	...
```
- In this the `let` expression is holding a variable `mimeapp-list` which will be used later
- The `pkgs.writeText` package is used to create a nix-file, a nix-file is a file that is created and placed in the immutable nix-store where the binaries, libraries and other files for the programs on you system are stored
- The nix-store itself is read-only due to its immutable nature and the nix philosophy which states, and i am paraphrasing,
>The user of the system should never handle and maintain the files on the system
>But the system itself should handle everything
>This way of thinking allows for more comprehensive levels of automation in software deployment through and to multiple architectures and systems alike
- At the end of the code example you can see `''`, these are written to define a multi-line string in nix and i have simply used them to define the entire mimeapps file right here in my configuration instead of creating a new file, defining everything there and then linking that file to my configuration

```
xdg = {
	...
}
```
- I've also defined some xdg settings to keep things working nice and clean

```
system.activationScripts.set-mimetypes.text = ''
	install -m 644 -o nixos -g users "${mimeapp-list}" /home/nixos/.config/mimeapps.list
'';
```
- I've used the `activationScripts` option again to create a simple symlink of the mimetypes i have defined here to my `.config` folder, which is where the system looks for the file

```
programs = {
	chromium = {
		enable = true;
		...
	};
};
```
- In the nix configuration if you want to define some settings for a specific program then you do it through the `programs` option
- I have defined some settings in here that pre-install or install on first setup some extensions and web-apps that i use all the time
- There are some other settings defined, but those are of no consequence so i wont mention them here, if you wish see all the specific settings then you can just go to the file
### Font Settings [font_settings.nix]
```
{ pkgs }:

/*  
	Instructions:

	truetype --> ttf
	opentype --> otf
	type1	 	--> pfb
*/
let
	new_font = font_name: font_type:
		pkgs.stdenv.mkDerivation {
			pname	= font_name;
			version = "1";
			src		= ../fonts/${font_name};
			installPhase = ''
				mkdir -p $out/share/fonts/${font_type}
				cp -r $src/* $out/share/fonts/${font_type}/
			'';
		};
in
{
	monkey		= new_font "monkey"		"opentype";
	vandria		= new_font "vandria"		"opentype";
	winking		= new_font "winking"		"opentype";
	dm_serif		= new_font "dm_serif"	"truetype";
	quicksand	= new_font "quicksand"	"truetype";
}
```
- This is one of the more complicated sections of the code/configuration, it might look simple but theres more going on because this file only holds the initialization of the font settings, the actual implementation is done in another file
- Here we will only talk about how the font data is collected and in `System Settings` we'll discuss how the fonts are actually used

` new_font = font_name: font_type: `
- As explained above there are two methods of defining a function in nix, here we look at the second method
- In this method a function is already defined and being used to create a file with the content that we want, the font folder path, and is placing that in the nix-store and then passing it onto our main function which we then use to pass it onto the global variable
- This variable is used later to actually load the fonts onto our system
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

```
let
	custom_fonts = pkgs.callPackage /home/nixos/nixos/nix_configs/font_settings.nix { inherit pkgs; };
in
```
- This shows a simple expression that creates a package through the use of the `callPackage` package and getting the contents of the `font_settings.nix` file and then compiling that into a simple nix-path and then storing that path in the `custom_fonts` variable

```
    fonts = {
		packages = with pkgs; [
			hasklig
			cascadia-code
			custom-fonts.vandria
			...
		];
```
- The `custom-fonts` variable then gets used here in the `fonts` option
- In this option you can download fonts that are already pre-defined as packages just by typing their name
- But since i wanted fonts that dont exist in the nixpkgs repo, that is why i needed to create the `font_settings.nix` file to be able to download them from wherever and then define their location
- Which allows me to pass them as a package sourced from the `custom-fonts` library

```
	fontconfig = {
		...
	};
```
- I have also defined some default font settings system wide using the `fontconfig` module within the `fonts` option

There are many other settings that are pretty trivial so i'll just mention them below and you can just look at the file itself if you want more details
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
I have just changed a few settings for the users on this system, my user and root
```
{
    # Define a user account and its settings
    users = {
		defaultUserShell = pkgs.powershell;

		users = {
			# Define root settings
			root = {
				shell = pkgs.powershell;
			};

			# Define nixos-user settings
			nixos = {
				isNormalUser = true;
				extraGroups = [ "wheel" "networkmanager" "libvirtd" "kvm" "lp" "video" "render" ];
				useDefaultShell = true;
				linger = true;
			};
		};
    };
}
```
` defaultUserShell = pkgs.powershell; `
- I use powershell as my main shell just because i've built a habit of using it for a long time on windows

```
		users = {
			# Define root settings
			root = {
				shell = pkgs.powershell;
				...
			};
```
- Because of this familiarity i have just switched the main shell to be powershell for both users, i might change it later - but its just a shell, it doesnt really matter

` extraGroups = [ "wheel" "networkmanager" "libvirtd" "kvm" "lp" "video" "render" ]; `
- I've also added my user to some extra groups
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