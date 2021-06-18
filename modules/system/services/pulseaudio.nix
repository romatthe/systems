{ pkgs, ... }:
{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
}
