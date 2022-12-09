{ pkgs, ...}:
{
  programs.emacs.enable = true;
  # TODO: Doom Emacs does not work with Emacs 29+, so Pgtk cannot be used for now
  #programs.emacs.package = pkgs.emacsPgtkNativeComp;
  # programs.emacs.package = pkgs.emacsNativeComp;
  programs.emacs.package = pkgs.emacsUnstable;
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

    unzip # Believe it or not, this is required for nov.el

    # Required by Doom Emacs
    git
    (ripgrep.override {withPCRE2 = true;})
    gnutls              # for TLS connectivity
    fd                  # faster projectile indexing
    imagemagick         # for image-dired
    pinentry_emacs      # in-emacs gnupg prompts
    zstd                # for undo-fu-session/undo-tree compression

    # Spell Checker
    (aspellWithDicts (ds: with ds; [
      en en-computers en-science
    ]))

    editorconfig-core-c # per-project style config
    sqlite              # for org-roam

    shellcheck          # for shell script linting 
  ];
}
