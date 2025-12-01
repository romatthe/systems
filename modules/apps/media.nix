{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    spotify

    # Subsonic clients
    sonixd
    #sublime-music # No longer maintained :(
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
    # jellyfin-media-player # Multitude of CVEs for Qt5 qtwebengine

    # Video editing and transcoding
    ffmpeg
    flowblade
    handbrake
    kdePackages.kdenlive
  ];
}
