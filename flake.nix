# TODO: Set various color themes, see https://btwiusegentoo.github.io/nixconfig/#org157ee38
# TODO: Set the various fonts to use, see https://btwiusegentoo.github.io/nixconfig/#orgd80d820
# TODO: Basically go over the entire look and feel entry, see https://btwiusegentoo.github.io/nixconfig/#org157ee83
# TODO: Configure fish to work with emacs-vterm, see https://btwiusegentoo.github.io/nixconfig/#orgee21e48
# TODO: Entire Doom config, see https://btwiusegentoo.github.io/nixconfig/#org1695984
# TODO: Enable lightdm, see https://btwiusegentoo.github.io/nixconfig/#orgc64bf2b

{
  description = "NixOS system configurations for all my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let      
      pkgs = (import nixpkgs) {
        system = "x86_64-linux";
        config = {
          # Forgive me Stallman
          allowUnfree = true;
        };
        overlays = [
          # Community maintained bleeding-edge Emacs
          inputs.emacs-overlay.overlay
          # Community packages
          inputs.nur.overlay
          # Unstable nixpkgs
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              system = final.system;
              config = {
                allowUnfree = true;
              };
            };
          })
        ];
      };
    in {
      
      nixosConfigurations = {
        
        # Main home workstation
        yokohama = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          
          modules = [
            # System modules
            ./machines/yokohama.nix
            ./modules/apps/games.nix
            ./modules/common/console.nix
            ./modules/common/nix.nix
            ./modules/common/xorg.nix
            ./modules/hardware/bluetooth.nix
            ./modules/hardware/pulseaudio.nix
            ./modules/hardware/ssd.nix
            ./modules/services/clam.nix
            ./modules/services/dbus.nix
            ./modules/services/oom.nix
            ./modules/services/openssh.nix
            
            # Home manager modules
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.romatthe = { ... }: {
                imports = [
                  ./machines/yokohama-home.nix
                  ./machines/yokohama-randr.nix
                  ./modules/apps/chat.nix
                  ./modules/apps/emacs.nix
                  ./modules/apps/firefox.nix
                  ./modules/apps/jetbrains.nix
                  ./modules/apps/zathura.nix
                  ./modules/common/fonts.nix
                  ./modules/common/gtk.nix
                  ./modules/services/gpg.nix
                  ./modules/terminal/alacritty.nix
                  ./modules/terminal/fish.nix
                  ./modules/terminal/git.nix
                  ./modules/terminal/starship.nix
                  ./modules/terminal/utils.nix
                ];
              };
            })
          ];
        };
      };
      
    };
}
