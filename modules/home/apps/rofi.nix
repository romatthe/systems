{ pkgs, ... }:
{
  programs.rofi.enable = true;
  programs.rofi.extraConfig = {
    modi = "window,drun,run,ssh";
    show-icons = true;
  };
  # TOOD: Set the proper font
  #programs.rofi.font = "Droid Sans Mono 14";
  programs.rofi.lines = 10;
  programs.rofi.location = "center";
  programs.rofi.terminal = "${pkgs.alacritty}/bin/alacritty";
  programs.rofi.theme = "../../../configs/rofi/nord.rasi"
}
