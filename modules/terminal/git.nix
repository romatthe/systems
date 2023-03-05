{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git;

    # Identity
    userName = "Robin Mattheussen";
    userEmail = "me@romatthe.dev";

    # delta, a fancier diff viewer
    delta.enable = true;

    # Enable git-lfs
    lfs.enable = true;

    extraConfig = {
      core.editor = "emacsclient -t -a=\"\"";

      # Use libsecret as the credential helper
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";

      # Default branch name
      init = {
        defaultBranch = "master";
      };
    };

    # PGP signing
    signing = {
      signByDefault = true;
      key = "8DC3890E89EDE9DF";
    };
  };
}
