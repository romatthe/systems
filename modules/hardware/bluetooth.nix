{ pkgs, ... }:
{
  # Enable the Linux bluetooth stack
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.settings = {
      General = {
          ControllerMode = "bredr";
      };
  };

  # Blueman is a GTK bluetooth management utility
  services.blueman.enable = true;
}
