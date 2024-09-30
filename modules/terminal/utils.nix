{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    chafa
    killall
    libgen-cli
    neofetch
    p7zip
    pandoc
    pavucontrol
    pfetch
    ripgrep
    trash-cli
    waybackpack
    yt-dlp

    # Editors
    neovim
    neovide

    # System tools
    pciutils

    # Nix
    nixfmt-classic
    # nixfmt-rfc-style
    nixpkgs-fmt
    nixpkgs-review
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    #rnix-lsp  # LSP
    #nil       # LSP

    # TUI apps
    lazygit
    ncpamixer
    yewtube
  ];
}
