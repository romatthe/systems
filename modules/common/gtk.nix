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
    # theme.name = "Adwaita-dark";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  
  home.packages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-tweaks
    # gnome.gnome-themes-extra
  ];
}
