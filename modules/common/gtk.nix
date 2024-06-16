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

    # Disable the touchpad whenever an external mouse gets connected
    "org/gnome/desktop/peripherals/touchpad" = {
      send-events = "disabled-on-external-mouse";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  
  home.packages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-tweaks

    # Compatibility packes for Awaita with QT5/QT6
    qadwaitadecorations
    qadwaitadecorations-qt6
  ];

  home.sessionVariables = {
    # Use the decoration plugin from QAdwairaDecorations
    QT_WAYLAND_DECORATION = "adwaita";
  };
}
