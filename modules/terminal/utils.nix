{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    chafa
    fastfetch
    killall
    libgen-cli
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
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
    nix-index
    nix-prefetch-git
    nix-prefetch-github

    # TUI apps
    lazygit
    ncpamixer
    yewtube
  ];
}
