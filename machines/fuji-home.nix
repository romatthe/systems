{ config, pkgs, lib, ... }:
{
  # Keyboard configuration
  home.keyboard = {
    layout = "us";
    variant = "qwerty";
  };

  # TODO: Is this necessary?
  home.stateVersion = "22.11";
}