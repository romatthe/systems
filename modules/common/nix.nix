{ pkgs, ... }:
{
  # Enable flake support
  nix.package = pkgs.nixVersions.stable;
  
  # Options for enabling proper flake and direnv usage
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
    keep-derivations = true
    keep-outputs = true
  '';

  nix.settings.allowed-users = [ "@wheel" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  # Auto garbage collect generations older than 10 days
  nix.gc.automatic = true;
  
  # Service to automaticall invalidate GC roots of direnv projects
  services.angrr = {
    enable = true;
    period = "3weeks";
  };
}
