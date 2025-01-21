{ pkgs, config, ... }:
{
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Here we're adding Mutter so the schema gets picked up for use in dconf
  services.xserver.desktopManager.gnome.sessionPath =
    [ pkgs.mutter ];

  # Keyboard repeat intervals
  # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;

  services.gnome.gnome-remote-desktop.enable = true;

  # Automatically set profile picture
  boot.postBootCommands = let
    gdm_user_conf = ''
      [User]
      Session=
      XSession=
      Icon=${../../assets/ness.png}
      SystemAccount=false
    '';
  in ''
    echo '${gdm_user_conf}' > /var/lib/AccountsService/users/romatthe
  '';

  # Required for desktop sharing and capturing on wayland
  # xdg.portal = { 
  #   enable = true;
  #   extraPortals = [ 
  #     pkgs.xdg-desktop-portal-gtk 
  #     # pkgs.xdg-desktop-portal-wlr 
  #   ];
  #   # gtkUsePortal = true;
  # };
}
