{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # AWS
    #awscli
    awscli2
    amazon-ecr-credential-helper
    
    # Golang
    go
    gopls
    delve

    # Java tools
    jdk21_headless
    jdk23_headless
    unstable.jdk25_headless
    helidon-cli
    maven
    quarkus

    # Rust (primarily for use with RustRover)
    rustup
    gcc
  ];
}
