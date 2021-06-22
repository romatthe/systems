{ config, pkgs, lib, ... }:
{
  # Keyboard configuration
  home.keyboard = {
    layout = "us";
    variant = "qwerty";
  };

  # Display configuration
  xsession.profileExtra = "xrandr --output HDMI-1 --off --output DP-4 --primary --mode 3440x1440 --rate 100";
}
