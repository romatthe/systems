{ pkgs, config, ... }:
{
  services.xserver.enable = true;
  services.xserver.autorun = true;
  
  # Keyboard repeat intervals
  # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;
}
