{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    bitwarden-cli
    bitwarden-desktop
    filezilla
    gimp
    imhex
    libreoffice-fresh
    onlyoffice-desktopeditors
    protonvpn-gui
    remmina
    qbittorrent
    qdirstat
    vlc
    xclicker
    zed-editor
  ];
}
