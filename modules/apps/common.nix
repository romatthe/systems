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
    authy
    bitwarden
    bitwarden-cli
    filezilla
    gimp
    imhex
    libreoffice-fresh
    protonvpn-gui
    remmina
    qbittorrent
    qdirstat
    vlc
  ];
}
