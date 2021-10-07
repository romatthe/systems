{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Two-factor authentication
    authy

    # BitTorrent
    qbittorrent
  ];
}
