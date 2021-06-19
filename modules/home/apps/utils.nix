{ pkgs, ... }:
{
  # bat, a cat replacement
  programs.bat = {
    enable = true;
    config.theme = "nord";
    config.italic-text = "always";
    # Show line numbers, git modifications and file header 
    config.style = "numbers,changes,header";
  };

  # lsd, an ls replacement
  programs.lsd.enable = true;
  programs.lsd.enableAliases = false;
}
