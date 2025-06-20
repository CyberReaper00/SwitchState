{ config, lib, pkgs, ... }:

{
    security = {
	sudo = {
	    enable = true;
	    wheelNeedsPassword = false;

	    extraRules = [{
		users = [ "nixos" ];

		commands = [{
		    command = "/run/current-system/sw/bin/neovide";
		    options = [ "SETENV" "NOPASSWD" ];
		}];
	    }];
	};
	
	wrappers = {

	    slock = {
	       owner = "root";
	       group = "root";
	       setuid = true;
	       source = "${pkgs.slock}/bin/slock";
	   };
	};
    };

    # System install version
    system.stateVersion = "24.11";
}
