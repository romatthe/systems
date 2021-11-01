{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify

    # Subsonic clients
    sublime-music

    # Transcoding
    freac

    # Tagging
    picard
    puddletag
  ];
}
