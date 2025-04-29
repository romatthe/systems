{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    fractal
    # nheko
    signal-desktop
    tdesktop
    teams-for-linux
  ];
}
