{ pkgs, ... }:
{
  # VSCodium
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        JakeBecker.elixir-ls
      ];
    };
  };
}
