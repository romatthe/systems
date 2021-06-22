{ pkgs, config, ... }:
{
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable the proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Keyboard repeat intervals
  # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;
}
