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

    # Editors
    neovim
    neovide

    # System tools
    pciutils

    # Nix
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    rnix-lsp  # LSP
    nil       # LSP

    # TUI apps
    lazygit
    ncpamixer
    yewtube
    
    pavucontrol
  ];
}
