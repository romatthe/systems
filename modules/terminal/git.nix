{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;

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

      # Use libsecret as the credential helper
      credential = {
        helper = "libsecret";
      };
    };

    # PGG signing
    signing = {
      signByDefault = true;
      key = "8DC3890E89EDE9DF";
    };
  };
}
