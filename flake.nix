{
  description = "NixOS system configurations for all my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
          # Community packages
          inputs.nur.overlays.default
          # Personal packages
          (import ./pkgs/overlay.nix)
          (final: prev: {
            # Unstable nixpkgs
            unstable = import inputs.nixpkgs-unstable {
              system = final.stdenv.hostPlatform.system;
              config = {
                allowUnfree = true;
              };
            };
            # Insecure nixpkgs
            insecure = import inputs.nixpkgs-unstable {
              system = final.stdenv.hostPlatform.system;
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "dotnet-runtime-7.0.20"
                  "dotnet-runtime-wrapped-7.0.20"
                ];
              };
            };
            # Old NixOS on 23.11
            old = import inputs.nixpkgs-old {
              system = final.stdenv.hostPlatform.system;
              config = {
                allowUnfree = true;
              };
            };
          })
        ];
      };

      # Common modules
      modules-common = [
        # Cache configuration
        ./cache.nix
	      # Modules configuration
        ./modules/apps/chat.nix
        ./modules/apps/common.nix
        ./modules/apps/emacs.nix
        ./modules/apps/media.nix
        ./modules/common/console.nix
        ./modules/common/nix.nix
        ./modules/common/qt.nix
        ./modules/common/xdg.nix
        ./modules/dev
        ./modules/dev/jetbrains.nix
        ./modules/common/xorg.nix
        ./modules/hardware/bluetooth.nix
        ./modules/hardware/ntfs.nix
        ./modules/services/direnv.nix
        ./modules/services/dbus.nix
        ./modules/services/oom.nix
        ./modules/services/openssh.nix
        ./modules/services/pipewire.nix
        ./modules/services/virt.nix
      ];

      # Common home modules
      modules-common-home = [
        ./modules/apps/firefox.nix
        ./modules/apps/vscode.nix
        ./modules/apps/zathura.nix
        ./modules/common/gtk.nix
        ./modules/services/gpg.nix
        ./modules/terminal/alacritty.nix
        ./modules/terminal/fish.nix
        ./modules/terminal/git.nix
        ./modules/terminal/starship.nix
        ./modules/terminal/utils.nix
      ];
    in {

      nixosConfigurations = {

        # Main home workstation
        yokohama = nixpkgs.lib.nixosSystem {
          inherit pkgs;

          modules = modules-common ++ [
            # System modules
            ./machines/yokohama.nix
            ./modules/apps/emulation.nix
            ./modules/apps/games.nix
            ./modules/dev/llm.nix
            ./modules/hardware/amdgpu.nix
            ./modules/hardware/ssd.nix
            ./modules/services/clam.nix

            # Home manager modules
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.romatthe = { ... }: {
                imports = modules-common-home ++ [
                  ./machines/yokohama-home.nix
                ];
              };
            })
          ];
        };

        # Personal dev laptop
        matsumoto = nixpkgs.lib.nixosSystem {
          inherit pkgs;

          modules = modules-common ++ [
            # System modules
            ./machines/matsumoto.nix
            ./modules/apps/emulation.nix
            ./modules/apps/games.nix
            ./modules/hardware/ssd.nix
            ./modules/services/clam.nix

            # Home manager modules
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.romatthe = { ... }: {
                imports = modules-common-home ++ [
                  ./machines/matsumoto-home.nix
                ];
              };
            })
          ];
        };

        # Gaming laptop 
        sapporo = nixpkgs.lib.nixosSystem {
          inherit pkgs;

          modules = modules-common ++ [
            # System modules
            ./machines/sapporo.nix
            ./modules/apps/emulation.nix
            ./modules/apps/games.nix
            ./modules/hardware/nvidia.nix
            ./modules/hardware/ssd.nix
            ./modules/services/clam.nix

            # Home manager modules
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.romatthe = { ... }: {
                imports = modules-common-home ++ [
                  ./machines/sapporo-home.nix
                ];
              };
            })
          ];
        };

        # AMD Gaming laptop 
        fuji = nixpkgs.lib.nixosSystem {
          inherit pkgs;

          modules = modules-common ++ [
            # System modules
            ./machines/fuji.nix
            ./modules/apps/emulation.nix
            ./modules/apps/games.nix
            ./modules/hardware/amdgpu.nix
            ./modules/hardware/asus.nix
            ./modules/hardware/ssd.nix
            ./modules/services/clam.nix

            # Home manager modules
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.romatthe = { ... }: {
                imports = modules-common-home ++ [
                  ./machines/fuji-home.nix
                ];
              };
            })
          ];
        };
      };
    };

}
