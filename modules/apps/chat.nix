{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    fractal
    # nheko
    signal-desktop
    telegram-desktop
    teams-for-linux
  ];
}
