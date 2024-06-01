{
  programs.alacritty.enable = true;

  # Enable true color support
  programs.alacritty.settings.env.TERM = "alacritty";

  programs.alacritty.settings.window.padding = {
    x = 12;
    y = 0;
  };

  # Don't show any window decorations
  programs.alacritty.settings.window.decorations = "none";

  programs.alacritty.settings.window.startup_mode = "Windowed";

  programs.alacritty.settings.scrolling = {
    history = 10000;
    multiplier = 3;
  };

  programs.alacritty.settings.font = {
    normal = {
      family = "JetBrainsMono Nerd Font";
      style = "Regular";
    };
    bold = {
      family = "JetBrainsMono Nerd Font";
      style = "Bold";
    };
    italic = {
      family = "JetBrainsMono Nerd Font";
      style = "Italic";
    };
    bold_italic = {
      family = "JetBrainsMono Nerd Font";
      style = "Bold Italic";
    };
  };
 
  # Conventient keybindings
  programs.alacritty.settings.keyboard.bindings = [
    {
      key = "V";
      mods = "Control|Shift";
      action = "Paste";
    }
    {
      key = "C";
      mods = "Control|Shift";
      action = "Copy";
    }
    {
      key = "Up";
      mods = "Control|Shift";
      action = "ScrollPageUp";
    }
    {
      key = "Down";
      mods = "Control|Shift";
      action = "ScrollPageDown";
    }
  ];
  
  # Nord theme
  programs.alacritty.settings.colors = {
    # Default colors
    primary = {
      background = "#2e3440";
      foreground = "#d8dee9";
      dim_foreground = "#a5abb6";
    };
    cursor = {
      text = "#2e3440";
      cursor = "#d8dee9";
    };
    vi_mode_cursor = {
      text = "#2e3440";
      cursor = "#d8dee9";
    };
    selection = {
      text = "CellForeground";
      background = "#4c566a";
    };
    search = {
      matches = {
        foreground = "CellBackground";
        background = "#88c0d0";
      };
      focused_match = {
        foreground = "#d8dee9";
        background = "#434c5e";
      };
    };
    # Normal colors
    normal = {
      black = "#3b4252";
      red = "#bf616a";
      green = "#a3be8c";
      yellow = "#ebcb8b";
      blue = "#81a1c1";
      magenta = "#b48ead";
      cyan = "#88c0d0";
      white = "#e5e9f0";
    };
    # Bright colors
    bright = {
      black = "#4c566a";
      red = "#bf616a";
      green = "#a3be8c";
      yellow = "#ebcb8b";
      blue = "#81a1c1";
      magenta = "#b48ead";
      cyan = "#8fbcbb";
      white = "#eceff4";
    };
    # Dim colors
    dim = {
      black = "#373e4d";
      red = "#94545d";
      green = "#809575";
      yellow = "#b29e75";
      blue = "#68809a";
      magenta = "#8c738c";
      cyan = "#6d96a5";
      white = "#aeb3bb";
    };
  };
}
