{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.rider
  ];
}
