{ pkgs, ... }:
{
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}