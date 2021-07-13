{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    #navidrome
    spotify
    sublime-music
  ];
}
