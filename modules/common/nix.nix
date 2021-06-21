{ pkgs, ... }:
{
  # Enable flake support
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
  '';
  nix.allowedUsers = [ "@wheel" ];
  nix.trustedUsers = [ "root" "@wheel" ];

  # Forgive me Stallman
  nixpkgs.config = { allowUnfree = true; };
}
