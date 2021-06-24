{ pkgs, ...}:
{
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtkGcc;
  programs.emacs.extraPackages = (epkgs: [ 
    #epkgs.vterm
    #epkgs.haskell-mode
    #epkgs.nix-mode
  ]);

  home.file.".doom.d/" = { 
    source = ../../configs/doom; 
    recursive = true; 
  };

  # Enable the Emacs daemon
  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
    socketActivation.enable = false;
  };

  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    fira-code
  ];
}
