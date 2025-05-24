{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      userChrome = ''
        #contentAreaContextMenu {
          margin-left: 4px;
        } 
      '';
      extensions.packages =
        with pkgs.nur.repos.rycee.firefox-addons; [
          pkgs.nur.repos.rycee.firefox-addons.bitwarden
          pkgs.nur.repos.rycee.firefox-addons.privacy-badger
          pkgs.nur.repos.rycee.firefox-addons.ublock-origin
        ];
    };
  };

  home = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
