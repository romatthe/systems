{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;

    
    
    config = {
      # Set the super key as the main mod key
      modifier = "Mod4";

      # Set Alacritty as the default browser
      terminal = "alacritty";

      # Set the default font
      # TODO: Fix this font stuff
      font = "font pango:monospace 12px";

      window.border = 2;

      gaps = {
        inner = 5;
        outer = 5;
      };

      colors.focused = {
        
      };

      colors.focusedInactive = {

      };
    };
  };
}
