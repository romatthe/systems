{ pkgs, ... }:
{
  home.packages = with pkgs; [
    authy
    remmina
    qbittorrent
  ];
}
