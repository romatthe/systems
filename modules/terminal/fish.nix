{ pkgs, ... }:
{
  programs.fish.enable = true;

  # Shell aliases
  # Make sure to make the required utilities available!
  programs.fish.shellAliases = {
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

  programs.fish.shellInit = ''
    set -U fish_color_cancel \x2dr
    set -U fish_color_command 81a1c1
    set -U fish_color_comment 434c5e
    set -U fish_color_cwd green
    set -U fish_color_cwd_root red
    set -U fish_color_end 88c0d0
    set -U fish_color_error ebcb8b
    set -U fish_color_escape 00a6b2
    set -U fish_color_history_current \x2d\x2dbold
    set -U fish_color_host normal
    set -U fish_color_host_remote yellow
    set -U fish_color_match \x2d\x2dbackground\x3dbrblue
    set -U fish_color_normal normal
    set -U fish_color_operator 00a6b2
    set -U fish_color_param eceff4
    set -U fish_color_quote a3be8c
    set -U fish_color_redirection b48ead
    set -U fish_color_search_match bryellow\x1e\x2d\x2dbackground\x3dbrblack
    set -U fish_color_selection white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
    set -U fish_color_status red
    set -U fish_color_user brgreen
    set -U fish_color_valid_path \x2d\x2dunderline
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description B3A06D\x1eyellow
    set -U fish_pager_color_prefix white\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
    set -U fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan
  '';

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

  # bat, a cat replacement
  programs.bat = {
    enable = true;
    config.theme = "Nord";
    config.italic-text = "always";
    # Show line numbers, git modifications and file header 
    config.style = "numbers,changes,header";
  };

  # lsd, an ls replacement
  programs.lsd.enable = true;
  programs.lsd.enableAliases = false;

  # bottom, a top/htop replacement
  home.packages = [
    # 'bottom', a system monitor
    pkgs.bottom
    # 'fd', a friendly find replacement
    pkgs.fd
  ];
}
