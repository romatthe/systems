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
  };
  
  gtk = {
    enable = true;
    theme.package = pkgs.nordic;
    theme.name = "Nordic";
  };
  
  home.packages = [
    pkgs.gnome.dconf-editor
    pkgs.gnome.gnome-tweak-tool
  ];
}
