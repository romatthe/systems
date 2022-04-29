let
  caches = [ 
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://nixpkgs-wayland.cachix.org"
  ];
in
{
  nix = {
    trustedBinaryCaches = caches;
    binaryCaches = caches;
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };
}
