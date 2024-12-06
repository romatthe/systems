{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.jetbrains.clion
    unstable.jetbrains.idea-ultimate
    unstable.jetbrains.goland
    unstable.jetbrains.rider
    unstable.jetbrains.rust-rover # Still in EAP at the moment
  ];
}