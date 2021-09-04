# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/e3bc00e6-9b21-4e6d-aaae-d425920e5f6f";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6b9bbe6c-408b-4fa2-9a9b-dcd836b1d645";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/6b9bbe6c-408b-4fa2-9a9b-dcd836b1d645";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

 fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/FC86-D307";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/79476089-be84-4878-ab1f-11977f82a63c"; }
    ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
