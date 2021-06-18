# TODO: Set various color themes, see https://btwiusegentoo.github.io/nixconfig/#org157ee38

{
  description = "NixOS system configurations for all my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    overlays = {
      # Community maintained bleeding-edge Emacs packages
      emacs = inputs.emacs-overlay;
      # Unstable nixpkgs
      unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config = {
            allowUnfree = true;
          };
        };
      };
    };

    nixosConfigurations = {
      nixpkgs.overlays = self.overlays;

      # Main home workstation
      yokohama = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = [
          # System modules
          ./machines/yokohama.nix
          ./modules/system/common/console.nix
          ./modules/system/common/nix.nix
          ./modules/system/common/xorg.nix
          ./modules/system/hardware/bluetooth.nix
          ./modules/system/hardware/pulseaudio.nix
          ./modules/system/hardware/ssd.nix
          ./modules/system/services/oom.nix
            
          # Home manager modules
          home-manager.nixosModules.home-manager
          ({
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.romatthe = { ... }: {
              imports = [
                ./machines/yokohama-home.nix
                ./modules/home/apps/alacritty.nix
                ./modules/home/apps/utils.nix
              ];
            };
          })
        ];
      };
    };
  };
}
