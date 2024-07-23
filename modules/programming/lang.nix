{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Golang
    go
    gopls
    delve

    # Rust (primarily for use with RustRover)
    rustup
    gcc
  ];
}
