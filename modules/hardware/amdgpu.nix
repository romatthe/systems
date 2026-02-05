{ pkgs, config, ... }:
{
  # Enable the AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    # Enable Vulkan support
    enable = true;
    enable32Bit = true;

    # Enable extra packages for ROCm support
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
    ];
  };

  # Explictly enable OpenCL
  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];

  # A lot of applications hardcode HIP libraries to /opt/rocm.
  # This is a workaround:
  systemd.tmpfiles.rules = 
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
}
