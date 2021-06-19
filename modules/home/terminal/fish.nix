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
    # Requires 'fd' to be installed
    "find" = "fd";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    # Use 'fd' instead of 'find', make sure to install it
    defaultCommand = "fd --type f";
    # TODO: Set proper colors, preferable Nord
    defaultOptions = [
      "--color=bg+:0,bg:#292D3E,spinner:#89DDFF,hl:#82AAFF,fg:#8796B0,header:#82AAFF,info:#FFCB6B,pointer:#89DDFF,marker:#89DDFF,fg+:#959DCB,prompt:#c792ea,hl+:#82AAFF"
    ];
  };

  # bottom, a top/htop replacement
  home.packages = [
    # 'bottom', a system monitor
    pkgs.bottom
    # 'fd', a friendly find replacement
    pkgs.fd
  ];
}
