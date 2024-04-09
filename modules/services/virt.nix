{ pkgs, ... }:
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
  
  # Mostly to run Windows in case it's absolutely necessary
  programs.virt-manager.enable = true;

  # Speaking of which...
  environment.systemPackages = with pkgs; [
    wine-staging
    unstable.seabird
  ];
}
