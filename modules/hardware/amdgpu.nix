{ pkgs, config, ... }:
{
  # Enable the proprietary AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
  hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
}
