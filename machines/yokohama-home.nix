{ config, pkgs, lib, ... }:
{
  # Keyboard configuration
  home.keyboard = {
    layout = "us";
    variant = "qwerty";
  };

  # TODO: Is this necessary?
  home.stateVersion = "22.11";

  # Display configuration
  #xsession.profileExtra = "xrandr --output HDMI-0 --off --output DP-4 --primary --mode 3440x1440 --rate 100";
}
