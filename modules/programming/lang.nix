{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Golang
    go
    gopls
    delve
  ];
}
