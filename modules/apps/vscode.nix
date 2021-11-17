{ pkgs, ... }:
{
  # VSCodium
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ayu";
          publisher = "teabyii";
          version = "1.0.5";
          sha256 = "f8816a8169622abfaa8c12e6425cc5e385cd6cdec1af96b5d7dbfd5809d93aee";
        }
        {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.8.1";
          sha256 = "2f5e5ffd484ac74438c0dc4f3dda6617384ca07b96dbb684a44411fdc3317ea2";
        }
        {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.4.5";
          sha256 = "dd04e5fce50f94b8fd5387253802043254bdc5d488c19a207fe56262fddd7c71";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.1.18";
          sha256 = "7669b1feefa14507d8fcc08869275c56d6d89dfe5c2c20d4c2bef985e43172ec";
        }
        {
          name = "nix-env-selector";
          publisher = "arrterian";
          version = "1.0.7";
          sha256 = "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
        }
        {
          name = "rust-analyzer";
          publisher = "matklad";
          version = "0.2.809";
          sha256 = "cd9fb06e0f97f8e4b399bb7a03ed4ef84e79be3b81e1318026b59d27b535a3ce";
        }
        {
          name = "toml";
          publisher = "be5invis";
          version = "0.6.0";
          sha256 = "ca4edbb84c90230e9a8948b3026fac81a956c5489b22e3fd72b87205a3a30b61";
        }
      ];
    };
  };
}
