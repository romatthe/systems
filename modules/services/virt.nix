{
  virtualisation = {
    libvirtd.enable = true;
    
    # Podman
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    oci-containers.backend = "podman";
  };
  
  programs.virt-manager.enable = true;
}
