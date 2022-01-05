{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    fractal
    nheko
    signal-desktop
    tdesktop
    teams
  ];
}
