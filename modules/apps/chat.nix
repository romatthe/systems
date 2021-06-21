{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.discord
    pkgs.nheko
    pkgs.signal-desktop
  ];
}
