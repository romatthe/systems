{ pkgs, config, ... }:
{
  # Enable the AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

    # Enable Vulkan support
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Disable AMDVLK for now, as I use an RX 6800 XT, which seems to work very well with RADV
  #hardware.opengl.extraPackages = [ pkgs.mesa.drivers pkgs.amdvlk ];
  #hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
}
