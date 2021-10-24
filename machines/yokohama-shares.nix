{ pkgs, ... }:
{
  fileSystems."/mnt/share/media" = {
    device = "//192.168.0.116/media";
    fsType = "cifs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
    # this line prevents hanging on network split
    #options = let
    #  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    #in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };
}
