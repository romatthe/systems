{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Tools
    file
    git
    htop
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
    libreoffice-fresh
    remmina
    qbittorrent
    qdirstat
  ];
}
