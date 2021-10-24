{ pkgs, ... }:
{
  # VSCodium
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        matklad.rust-analyzer
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
      ];
    };
  };
}
