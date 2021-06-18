{ pkgs, config, ...  } :
{
  # Keyboard repeat intervals
  # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;

  # Keyboard layout
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "qwerty";
}
