{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    nheko
    signal-desktop
    tdesktop
  ];
}
