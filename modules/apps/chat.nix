{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    fractal
    #nheko #TODO: Has serious security issues
    signal-desktop
    tdesktop
  ];
}
