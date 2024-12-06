{ pkgs, config, ... }:
{
  # Enable the AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

    # Enable Vulkan support
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Disable AMDVLK for now, as I use an RX 6800 XT, which seems to work very well with RADV
  #hardware.opengl.extraPackages = [ pkgs.mesa.drivers pkgs.amdvlk ];
  #hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
}
