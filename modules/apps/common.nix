{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Tools
    file
    git
    glances
    htop
    jq
    procs
    vim
    wget
    cmake
    gnumake
    pciutils
    usbutils

    # Apps
    bitwarden-cli
    # bitwarden-desktop # Packaged with insecure Electron because of course lol
    filezilla
    gimp
    imhex
    libreoffice-fresh
    onlyoffice-desktopeditors
    proton-vpn
    remmina
    qbittorrent
    qdirstat
    vlc
    xclicker
    zed-editor
  ];
}
