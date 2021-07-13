{ pkgs, ... }:

{
  # Enable support for the NTFS filesystem
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  environment.systemPackages = with pkgs; [
    # Free exFAT implementation and utils
    exfat
    # NTFS FUSE drivers
    ntfs3g
  ];
}
