{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.clion
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.rider
    unstable.jetbrains.rust-rover # Still in EAP at the moment
  ];
}
