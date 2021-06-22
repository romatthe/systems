{ pkgs, ... }:
{
  home.packages = with pkgs; [
    trash-cli
    ripgrep
    killall
    neofetch
    pfetch
    pandoc
    chafa

    # System tools
    pciutils

    # Nix
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
    nix-prefetch-git
    nix-prefetch-github
    rnix-lsp
 
    # TUI apps
    ncpamixer
    mps-youtube
    lazygit
    
    pavucontrol
  ];
}
