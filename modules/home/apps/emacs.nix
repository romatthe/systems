{ pkgs, ...}:
{
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtkGcc;
  programs.emacs.extraPackages = (epkgs: [ epkgs.vterm ]);

  # Enable the Emacs daemon
  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
    socketActivation.enable = false;
  };
}
