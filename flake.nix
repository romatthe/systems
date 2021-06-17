{
  description = "NixOS system configurations for all my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";

      pkgs = (import nixpkgs) {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in {

      nixosConfigurations = {
        yokohama = lib.nixosSystem {
          inherit system;

          modules = [
            # System modules
            ./machines/yokohama.nix
            ./modules/system/common/nix.nix
            
            # Home manager modules
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.romatthe = { ... }: {
                imports = [ ];
              };
            })
          ];
        };
      };

    };
}
