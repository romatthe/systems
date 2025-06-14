{ lib, pkgs, ... }:

let 
  customEmacs = pkgs.emacs30-pgtk.overrideAttrs (attrs: {
    # Remove the Emacs (Client) desktop entries
    postInstall = pkgs.emacs30-pgtk.postInstall + ''
      rm $out/share/applications/emacsclient*.desktop
    '';
  });

  # Custom Emacs with extra packages requires native binaries
  customEmacsWithPackages = customEmacs.pkgs.withPackages (epkgs: with epkgs.melpaPackages; [
    org-pdftools
    pdf-tools
    # tree-sitter
    # tree-sitter-langs
    vterm
  ]);

  # Base Doom Emacs files
  doomEmacs = pkgs.stdenvNoCC.mkDerivation {
    name = "doom-emacs";

    dontBuild = true;
    dontFixup = true;

    src = pkgs.fetchgit {
      url = "https://github.com/doomemacs/doomemacs.git";  
      rev = "24601b300e87e909340524476713dcaaa5d095cd";
      sha256 = "TbKFxrjMWBN3ViW1lmzwq4Y6rNg1455PUDR3RO/lRbg=";
      leaveDotGit = true;
    };

    installPhase = ''
      mkdir $out
      cp -a $src/. $out/
    '';
  };

in {
  # Runs each time a new configuration is actived. Primarily just clones doom emacs if necessary.
  # TODO: This is definitely abusing this feature. Maybe take Doom as an input to this flake and copy the files over from /nix/store in the activationscript?
  # That should allow for quick population of the directories without the disgusting/non-idempotent clone here. However, that also makes the flake input redundant after the
  # first copy actually happens. It could also be possible to check if the current git HEAD is a lower version that the input rev and copy over it if necessary?
  system.userActivationScripts = {
    installDoomEmacs = ''
      if [ ! -d "$XDG_CONFIG_HOME/emacs" ] || [ ! -d "$XDG_CONFIG_HOME/emacs/.git" ]; then
        ${pkgs.git}/bin/git clone --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "$XDG_CONFIG_HOME/emacs"
      fi
    '';
  };

  # Make sure that the Doom command-line helper tool is on our path
  # TODO: Make sure we somehow get this on our path. One option is to use the flake input mentioned above and put the doom-bin as out an output of a derivation
  # or something along those lines? I'm not entirely sure yet. Or use hlissner's technique for setting up the envs via extraInit.
  # env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
  environment.sessionVariables = {
    # TODO: Refer to the actual value of $XDG_CONFIG_HOME instead of hardcoded. Maybe through a custom XDG module? And refer to the values from there?
    # See hlissner's xdg module.
    PATH = [
      "~/.config/emacs/bin"
    ];
  };

  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono 
    nerd-fonts.roboto-mono
    noto-fonts
  ];

  # home.packages = with pkgs; [
  users.users.romatthe.packages = with pkgs; [
    # Our 'custom' emacs
    customEmacsWithPackages

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
    (ripgrep.override { withPCRE2 = true; })
    gnutls              # for TLS connectivity
    fd                  # faster projectile indexing
    imagemagick         # for image-dired
    pinentry-emacs      # in-emacs gnupg prompts
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
