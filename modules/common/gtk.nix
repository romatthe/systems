{ pkgs, ... }:
{
  dconf.settings = {
    # Disable common navigating keys in Jetbrains IDEs
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-left = [ "" ];
      switch-to-workspace-right = [ "" ];
    };

    # Sane alt-tab behavior
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    # Extend the screen with virtual desktops via RDP screen sharing
    "org.gnome.desktop.remote-desktop.rdp" = {
      screen-share-mode = "extend";
    };
  };
  
  gtk = {
    enable = true;
    # Let's disable the GTK Nord-theme for now.
    # theme.package = pkgs.nordic;
    theme.name = "Adwaita-dark";
  };
  
  home.packages = [
    pkgs.gnome.dconf-editor
    pkgs.gnome.gnome-tweaks
  ];
}
