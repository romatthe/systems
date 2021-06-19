{ pkgs, ... }:
{
  programs.fish.enable = true;

  # Shell aliases
  # Make sure to make the required utilities available!
  programs.fish.shellAbbrs = {
    # Requires 'bat' to be installed
    "cat" = "bat";
    # Requires 'lsd' to be installed
    "ls" = "lsd";
    "lsa" = "lsd -a";
    "ll" = "lsd -al";
    "tree" = "lsd --tree";
    # Requires 'delta' to be installed
    "diff" = "delta";
    # Requires 'emacs' to be installed
    "emacs" = "emacsclient -c -nw";
    # Requires 'neovim' to be installed
    "vi" = "nvim";
    "vim" = "nvim";
    # Requires 'bottom' to be installed
    "top" = "btm";
    "htop" = "btm";
  };
}
