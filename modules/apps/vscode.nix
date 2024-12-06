{ pkgs, ... }:
{
  # VSCodium
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      keybindings = builtins.fromJSON (builtins.readFile ../../configs/vscode/keybindings.json);
      userSettings = builtins.fromJSON (builtins.readFile ../../configs/vscode/settings.json);
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        editorconfig.editorconfig
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ayu";
          publisher = "teabyii";
          version = "1.0.5";
          sha256 = "f8816a8169622abfaa8c12e6425cc5e385cd6cdec1af96b5d7dbfd5809d93aee";
        }
        {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.4.5";
          sha256 = "dd04e5fce50f94b8fd5387253802043254bdc5d488c19a207fe56262fddd7c71";
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
