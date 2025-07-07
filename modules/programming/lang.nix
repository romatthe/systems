{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Golang
    go
    gopls
    delve

    # Java tools
    jdk21_headless
    jdk23_headless
    helidon-cli
    maven
    quarkus

    # Rust (primarily for use with RustRover)
    rustup
    gcc
  ];
}
