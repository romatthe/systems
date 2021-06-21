{ pkgs, ... }:
{
  dconf.settings = {
    # Disable common navigating keys in Jetbrains IDEs
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-left = [ "" ];
      switch-to-workspace-right = [ "" ];
    };
  };
  
  gtk = {
    enable = true;
    theme.package = pkgs.nordic;
    theme.name = "Nordic";
  };
  
  home.packages = [
    pkgs.gnome.gnome-tweak-tool
  ];
}
