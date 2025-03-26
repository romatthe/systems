{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify

    # Subsonic clients
    sonixd
    sublime-music
    supersonic-wayland

    # Transcoding
    flacon
    freac

    # Tagging
    picard
    puddletag

    # Jellyfin
    jellyfin-media-player

    # Video editing and transcoding
    flowblade
    handbrake
    kdenlive
  ];
}
