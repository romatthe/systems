{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # AWS CLI
    awscli2
    amazon-ecr-credential-helper  # Credentional helper for interacting with docker tooling and AWS ECR
    ssm-session-manager-plugin    # Session manager plugin for AWS CLI

    # Tools
    awscli-local
    dynamodb-local
    dynein
    infracost
    localstack
    nosql-workbench
    opentofu
    terraform
    terraform-local
    terraform-ls
    terraformer
    tofu-ls
    
    # Golang
    go
    gopls
    delve

    # Java tools
    jdk21_headless # Switch completely to JDK25 for easier use
    # jdk23_headless # Switch completely to JDK25 for easier use
    jdk25_headless
    maven
    quarkus

    # Rust (primarily for use with RustRover)
    rustup
    gcc
  ];
}
