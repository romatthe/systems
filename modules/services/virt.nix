{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    
    # Podman
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    oci-containers.backend = "podman";
  };
  
  # Mostly to run Windows in case it's absolutely necessary
  programs.virt-manager.enable = true;

  # Enable UEFI firmware support in Virt-Manager, Libvirt, Gnome-Boxes etc
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  # Speaking of which...
  environment.systemPackages = with pkgs; [
    wine-staging
    unstable.seabird

    qemu
    unstable.quickemu
  ];
}
