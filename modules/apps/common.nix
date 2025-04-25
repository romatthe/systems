{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Tools
    file
    git
    glances
    htop
    procs
    vim
    wget
    cmake
    gnumake
    pciutils
    usbutils

    # Apps
    bitwarden
    bitwarden-cli
    filezilla
    gimp
    imhex
    libreoffice-fresh
    # unstable.protonvpn-gui # TODO: Broken as usual, restore
    remmina
    qbittorrent
    qdirstat
    vlc
    unstable.zed-editor
  ];
}
