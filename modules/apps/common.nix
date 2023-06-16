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
    filezilla
    gimp
    imhex
    libreoffice-fresh
    remmina
    qbittorrent
    qdirstat
    vlc
  ];
}
