{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    spotify

    # Subsonic clients
    sonixd
    sublime-music
    # Uses a bizarre toolkit that cannot be compiled for both X11 and Wayland at the same time.
    # The Wayland build seems to be very, very broken for now?
    supersonic
    # supersonic-wayland 

    # Transcoding
    flacon
    freac

    # Tagging
    picard
    puddletag

    # Jellyfin
    jellyfin-media-player

    # Video editing and transcoding
    ffmpeg
    flowblade
    handbrake
    kdenlive
  ];
}
