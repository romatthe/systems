{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify

    # Subsonic clients
    sonixd
    sublime-music
    supersonic

    # Transcoding
    flacon
    freac

    # Tagging
    picard
    puddletag

    # Jellyfin
    jellyfin-media-player
  ];
}
