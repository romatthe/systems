{ pkgs, ... }:
{
  services.dbus.packages = [ pkgs.gcr ];
}
