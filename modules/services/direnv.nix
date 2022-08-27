{ pkgs, ... }:
{
    programs.direnv.enable = true;
    # programs.direnv.enableFishIntegration = true;
    programs.direnv.nix-direnv.enable = true;
}