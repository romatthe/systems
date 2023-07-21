{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify

    # Subsonic clients
    sonixd
    sublime-music

    # Transcoding
    freac

    # Tagging
    picard
    puddletag

    # Jellyfin
    jellyfin-media-player
  ];
}
