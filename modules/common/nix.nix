{ pkgs, ... }:
{
  # Enable flake support
  nix.package = pkgs.nixFlakes;
  
  # Options for enabling proper flake and direnv usage
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
    keep-derivations = true
    keep-outputs = true
  '';
  nix.allowedUsers = [ "@wheel" ];
  nix.trustedUsers = [ "root" "@wheel" ];

  # Forgive me Stallman
  nixpkgs.config = { allowUnfree = true; };

  # Auto garbage collect generations older than 10 days
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d";
}
