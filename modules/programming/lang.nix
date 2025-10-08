{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # AWS
    awscli2
    amazon-ecr-credential-helper

    # Tools
    infracost
    localstack
    opentofu
    opentofu-ls
    terraform
    terraform-local
    terraform-ls
    terraformer
    
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
