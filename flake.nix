{
  description = "NixOS system configurations for all my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
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
          permittedInsecurePackages = [
            "electron-9.4.4"
          ];
        };
        overlays = [
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
            pcsx2-staging = import inputs.nixpkgs-pcsx2-staging {
              system = final.system;
              config = {
                allowUnfree = true;
              };
            };
            luxtorpeda = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/luxtorpeda { };
            nuvie = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/nuvie { };
            ps3-disc-dumper = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/ps3-disc-dumper { };
            samrewritten = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/samrewritten { };
            steam-metadata-editor = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/steam-metadata-editor { };
            wlogoutbar = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/wlogoutbar { };
          })
        ];
      };

      # Common modules
      modules-common = [
        # Cache configuration
        ./cache.nix
	    # Modules configuration
        ./modules/apps/emacs.nix
        ./modules/common/console.nix
        ./modules/common/nix.nix
        ./modules/common/xdg.nix
        ./modules/common/xorg.nix
        ./modules/hardware/bluetooth.nix
        ./modules/hardware/ntfs.nix
        ./modules/services/dbus.nix
        ./modules/services/oom.nix
        ./modules/services/openssh.nix
        ./modules/services/pipewire.nix
        ./modules/services/virt.nix
      ];

      # Common home modules
      modules-common-home = [
        ./modules/apps/chat.nix
        ./modules/apps/common.nix
        ./modules/apps/firefox.nix
        ./modules/apps/jetbrains.nix
        ./modules/apps/media.nix
        ./modules/apps/vscode.nix
        ./modules/apps/zathura.nix
        ./modules/common/fonts.nix
        ./modules/common/gtk.nix
        ./modules/services/direnv.nix
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
          system = "x86_64-linux";

          modules = modules-common ++ [
            # System modules
            ./machines/yokohama.nix
            ./modules/apps/emulation.nix
            ./modules/apps/games.nix
            ./modules/hardware/amdgpu.nix
            ./modules/hardware/ssd.nix
            ./modules/services/clam.nix
            # ./modules/wm/sway.nix

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
          system = "x86_64-linux";

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
          system = "x86_64-linux";

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
          system = "x86_64-linux";

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
