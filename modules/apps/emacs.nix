{ pkgs, ...}:
{
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtkGcc;
  programs.emacs.extraPackages = (epkgs: [
    epkgs.vterm
    epkgs.pdf-tools
    epkgs.org-pdftools
  ]);

  #home.file.".doom.d/" = {
  #  source = ../../configs/doom;
  #  recursive = true;
  #};

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
    # Specify all nerd-fonts here
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "JetBrainsMono" "RobotoMono" ]; })

    # Regular fonts
    emacs-all-the-icons-fonts
    fira-code
    jetbrains-mono
    roboto
    roboto-mono

    # Believe it or not, this is required for nov.el
    unzip
  ];
}
