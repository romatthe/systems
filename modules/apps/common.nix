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
    unstable.protonvpn-gui # The old app is deprecated
    remmina
    qbittorrent
    qdirstat
    vlc
  ];
}
