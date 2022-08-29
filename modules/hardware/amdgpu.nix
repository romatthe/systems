{ pkgs, config, ... }:
{
  # Enable the proprietary AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

    # Enable Vulkan support
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];

  hardware.opengl.extraPackages = [ pkgs.mesa.drivers pkgs.amdvlk ];
  hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
}
