{ pkgs, ... }:
{
  # bat, a cat replacement
  programs.bat.enable = true;
  programs.bat.config.theme = "nord";

  # lsd, an ls replacement
  programs.lsd.enable = true;
  programs.lsd.enableAliases = false;

  # delta, a fancier diff viewer
  programs.git.delta.enable = true;

  # bottom, a top/htop replacement
  home.packages = [
    pkgs.bottom
  ];
}
