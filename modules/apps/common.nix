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
    bitwarden
    bitwarden-cli
    filezilla
    gimp
    imhex
    libreoffice-fresh
    unstable.protonvpn-gui
    remmina
    qbittorrent
    qdirstat
    vlc
    xclicker
    unstable.zed-editor
  ];
}
