{ pkgs, config, ... }:
{
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Keyboard repeat intervals
  # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;

  # Enable Vulkan support
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
}
