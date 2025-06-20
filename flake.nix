{
    description = "Main Flake";

    inputs = {
	nixpkgs.url = "nixpkgs/nixos-25.05";
    };

    outputs = { self, nixpkgs, ... }:
    let
	lib = nixpkgs.lib;
    in {
	nixosConfigurations = {
	    main-config = lib.nixosSystem {
		system = "x84_64-linux";
		modules = [ ./configuration.nix ];
	    };

	    deepin-config = lib.nixosSystem {
		system = "x86_64-linux";
		modules = [ ./deepin_config.nix ];
	    };

	    lxqt-config = lib.nixosSystem {
		system = "x86_64-linux";
		modules = [ ./lxqt_config.nix ];
	    };
	};
    };
}
