{ pkgs, ... }:
{
  home.packages = with pkgs; [
    chafa
    killall
    neofetch
    p7zip
    pandoc
    pfetch
    ripgrep
    trash-cli
    yt-dlp

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
