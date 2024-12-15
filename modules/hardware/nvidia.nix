{ config, pkgs, ... }:
{
  # Enable the proprietary Nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    # Required
    modesetting.enable = true;

    # Enable this if you have graphical corruption issues or application crashes after waking from sleep
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module. Currently alpha-quality/buggy.
    open = false;

    # Enable `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };
}
