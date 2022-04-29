{ pkgs, ...}:
{
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsNativeComp;
  programs.emacs.extraPackages = (epkgs: [
    epkgs.vterm
    epkgs.pdf-tools
    # TODO: currently fails to build
    #epkgs.org-pdftools
  ]);

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
    ia-writer-duospace
    jetbrains-mono
    office-code-pro
    roboto
    roboto-mono

    # Emoji font
    twitter-color-emoji

    # Believe it or not, this is required for nov.el
    unzip
  ];
}
