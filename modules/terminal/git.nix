{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.git;
    
    # Identity and configuration
    settings = {
      user = {
        name = "Robin Mattheussen";
        email = "me@romatthe.dev";
      };
      
      # Use libsecret as the credential helper
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";

      # Default branch name
      init = {
        defaultBranch = "master";
      };
    };

    # Enable git-lfs
    lfs.enable = true;

    # PGP signing
    signing = {
      signByDefault = true;
      key = "8DC3890E89EDE9DF";
    };
  };

  # delta, a fancier diff viewer
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}

