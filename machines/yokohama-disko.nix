disko.devices = {
  disk = {
    nvme-root = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "boot";
            name = "ESP";
            size = "1024M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
            };
          };
          luks-root = {
            size = "100%";
            label = "nixos";
            content = {
              type = "luks";
              name = "nixos";
              settings = {
                allowDiscards = true;  
              };
              content = {
                type = "btrfs";
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };
    nvme-storage = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          luks-storage = {
            size = "100%";
            label = "storage";
            content = {
              type = "luks";
              name = "storage";
              settings = {
                allowDiscards = true;  
              };
              content = {
                type = "btrfs";
                subvolumes = {
                  "/steam" = {
                    mountpoint = "/home/romatthe/.local/share/Steam";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/games" = {
                    mountpoint = "/home/romatthe/Games";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/vms" = {
                    mountpoint = "/home/romatthe/VMs";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}
