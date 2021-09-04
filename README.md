# Systems

## Get a working system with Nix Flakes

Get a Nix shell with flakes support: `nix-shell -p nixFlakes`

## Format the system

[nix-shell:~/systems]$ sudo gdisk /dev/nvme1n1
GPT fdisk (gdisk) version 1.0.7

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): o
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): Y

Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-1953525134, default = 2048) or {+-}size{KMGTP}: +1024M
Last sector (2099200-1953525134, default = 1953525134) or {+-}size{KMGTP}: +1024M
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): ef00
Changed type of partition to 'EFI system partition'

Command (? for help): n
Partition number (2-128, default 2): 
First sector (34-1953525134, default = 4196352) or {+-}size{KMGTP}: +16GB
Last sector (37750784-1953525134, default = 1953525134) or {+-}size{KMGTP}: +16GB
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 8200
Changed type of partition to 'Linux swap'

Command (? for help): n
Partition number (3-128, default 3): 
First sector (34-1953525134, default = 71305216) or {+-}size{KMGTP}: 
Last sector (71305216-1953525134, default = 1953525134) or {+-}size{KMGTP}: 
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 
Changed type of partition to 'Linux filesystem'

Command (? for help): p
Disk /dev/nvme1n1: 1953525168 sectors, 931.5 GiB
Model: WDC WDS100T2B0C-00PXH0                  
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): C414FC0B-2D9F-4461-8D68-212FE5A0EAEE
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 1953525134
Partitions will be aligned on 2048-sector boundaries
Total free space is 35653598 sectors (17.0 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1         2099200         4196351   1024.0 MiB  EF00  EFI system partition
   2        37750784        71305215   16.0 GiB    8200  Linux swap
   3        71305216      1953525134   897.5 GiB   8300  Linux filesystem

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): Y
OK; writing new GUID partition table (GPT) to /dev/nvme1n1.
The operation has completed successfully.

## LUKS/LVM

[nix-shell:~/systems]$ sudo cryptsetup --verify-passphrase -v luksFormat --type luks1 /dev/nvme1n1p3

WARNING!
========
This will overwrite data on /dev/nvme1n1p3 irrevocably.

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for /dev/nvme1n1p3: 
Verify passphrase: 
Key slot 0 created.
Command successful.

[nix-shell:~/systems]$ sudo cryptsetup open /dev/nvme1n1p3 nixos
Enter passphrase for /dev/nvme1n1p3: 

[nix-shell:~/systems]$ sudo mkfs.vfat -n boot /dev/nvme1n1p1
mkfs.fat 4.1 (2017-01-24)
mkfs.fat: warning - lowercase labels might not work properly with DOS or Windows

[nix-shell:~/systems]$ sudo mkfs.btrfs /dev/mapper/nixos
btrfs-progs v5.11.1 
See http://btrfs.wiki.kernel.org for more information.

Detected a SSD, turning off metadata duplication.  Mkfs with -m dup if you want to force metadata duplication.
Label:              (null)
UUID:               6b9bbe6c-408b-4fa2-9a9b-dcd836b1d645
Node size:          16384
Sector size:        4096
Filesystem size:    897.51GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         single            8.00MiB
  System:           single            4.00MiB
SSD detected:       yes
Incompat features:  extref, skinny-metadata
Runtime features:   
Checksum:           crc32c
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   897.51GiB  /dev/mapper/nixos


[nix-shell:~/systems]$ sudo mkswap /dev/nvme1n1p2
Setting up swapspace version 1, size = 16 GiB (17179865088 bytes)
no label, UUID=79476089-be84-4878-ab1f-11977f82a63c

[nix-shell:~/systems]$ sudo swapon /dev/nvme1n1p2

## Subvolumes

[nix-shell:~/systems]$ sudo mount -t btrfs /dev/mapper/nixos /mnt

[nix-shell:~/systems]$ sudo btrfs subvolume create /mnt/nixos
Create subvolume '/mnt/nixos'

[nix-shell:~/systems]$ sudo btrfs subvolume create /mnt/home
Create subvolume '/mnt/home'

[nix-shell:~/systems]$ sudo btrfs subvolume snapshot -r /mnt/nixos /mnt/nixos-blank
Create a readonly snapshot of '/mnt/nixos' in '/mnt/nixos-blank'

[nix-shell:~/systems]$ sudo umount /mnt

[nix-shell:~/systems]$ sudo mkdir /mnt/home

[nix-shell:~/systems]$ sudo mkdir -p /mnt/boot/efi

[nix-shell:~/systems]$ sudo mount -o subvol=nixos,compress=zstd,noatime /dev/mapper/nixos /mnt

[nix-shell:~/systems]$ sudo mount -o subvol=home,compress=zstd,noatime /dev/mapper/nixos /mnt/home

[nix-shell:~/systems]$ sudo mount /dev/nvme1n1p1 /mnt/boot/efi

## Generating and changing the config

[nix-shell:~/systems]$ sudo nixos-generate-config --root /mnt

The generated hardware config will not have detected the required BTRFS mount options, so we need to add these manually. For example, change

```
fileSystems."/" =
    { device = "/dev/disk/by-uuid/6b9bbe6c-408b-4fa2-9a9b-dcd836b1d645";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };
```

to

```
fileSystems."/" =
    { device = "/dev/disk/by-uuid/6b9bbe6c-408b-4fa2-9a9b-dcd836b1d645";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" "noatime" ];
    };
```

## Building the system

[nix-shell:~/systems]$ nix --experimental-features 'nix-command flakes' build .#nixosConfigurations.yokohama.config.system.build.toplevel
[nix-shell:~/systems]$ sudo nixos-install --system ./result --root /mnt


