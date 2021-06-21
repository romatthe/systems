{
  services.dunst.enable = true;

  # Global settings
  services.dunst.settings = {
    global = {
      follow = "mouse";
      geometry = "350x5-20+45";
      indicate_hidden = "yes";
      shrink = false;
      transparency = 0;
      notification_height = 75;
      separator_height = 2;
      padding = 10;
      horizontal_padding = 10;
      frame_width = 2;
      sort = "yes";
      idle_threshold = 120;
      line_height = 5;
      markup = "full";
      format = "<b>%s</b>\n%b";
      alignment = "left";
      show_age_threshold = 60;
      word_wrap = "yes";
      ignore_newline = "no";
      stack_duplicates = true;
      hide_duplicate_count = false;
      show_indicators = "yes";
      icon_position = "right";
      max_icon_size = 64;

      # History
      sticky_history = "yes";
      history_length = 20;

      browser = "firefox -new-tab";
      always_run_script = true;
      title = "Dunst";
      class = "Dunst";
      
      # TODO: Ensure that these icons is installed
      icon_folders = "/home/romatthe/.icons/";
    };
  };

  # Font settings
  # TODO: Ensure that this font is installed or use another one
  services.dunst.settings.global.font = "JetBrains Mono 10";

  # Colors
  services.dunst.settings.global.frame_color = "#4C566A";
  services.dunst.settings.global.separator_color = "frame";

  services.dunst.settings.urgency_low = {
    background = "#3b4252";
    foreground = "#eceff4";
    frame_color = "#4c566a";
    timeout = 10;
  };

  services.dunst.settings.urgency_normal = {
    background = "#3b4252";
    foreground = "#eceff4";
    timeout = 10;
  };

  services.dunst.settings.urgency_critical = {
    background = "#3b4252";
    foreground = "#eceff4";
    frame_color = "#bf616a";
    timeout = 0;
  };
 
  # Scripting
  services.dunst.settings = {
    
    brightness = {
      summary = "󰃞 Light";
	    set_stack_tag = "brightness";
    };

    music = {
      summary = "*Now Playing*";
	    set_stack_tag = "music";
    };

    DND = {
      summary = "*Do Not Disturb*";
	    set_stack_tag = "dnd";
    };
    
  };
}
