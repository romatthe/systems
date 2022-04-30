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

    extraConfig = {
      # Always use SSH for Github repos
      #url."git@github.com:" = {
      #  insteadOf = "https://github.com/";
      #};

      core.editor = "emacsclient -t -a=\"\"";

      # Use libsecret as the credential helper
      credential = {
        helper = "libsecret";
      };

      # Default branch name
      init = {
        defaultBranch = "master";
      };
    };

    # PGG signing
    signing = {
      signByDefault = true;
      key = "8DC3890E89EDE9DF";
    };
  };
}
