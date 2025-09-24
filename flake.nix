{
    description = "Main Flake";
    inputs = { nixpkgs.url = "nixpkgs/nixos-25.05"; };

    outputs = { self, nixpkgs, ... }:
    let
		lib = nixpkgs.lib;
    in
	{
		nixosConfigurations = {
			main-config = lib.nixosSystem {
				system = "x84_64-linux";
				modules = [ /home/nixos/nixos/dwm_config.nix ];
			};
		};
    };
}
