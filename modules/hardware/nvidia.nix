{ pkgs, ... }:
{
  # Enable the proprietary Nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };
}