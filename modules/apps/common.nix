{ pkgs, ... }:
{
  home.packages = with pkgs; [
    authy
    libreoffice-fresh
    remmina
    qbittorrent
  ];
}
