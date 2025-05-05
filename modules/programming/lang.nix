{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Golang
    go
    gopls
    delve

    # Java tools
    helidon-cli
    quarkus

    # Rust (primarily for use with RustRover)
    rustup
    gcc
  ];
}
