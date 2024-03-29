# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/041fb979-5d17-44f8-ac8b-a4bd64fe0f04";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f6b16d38-e353-4979-aea6-42165ececafa";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/f6b16d38-e353-4979-aea6-42165ececafa";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/39B3-5029";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/03f294ab-484c-48be-8efb-253ac8f5a393"; }
    ];

}
