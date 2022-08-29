{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    extensions =
      with pkgs.nur.repos.rycee.firefox-addons; [
        pkgs.nur.repos.rycee.firefox-addons.bitwarden
        pkgs.nur.repos.rycee.firefox-addons.privacy-badger
        pkgs.nur.repos.rycee.firefox-addons.ublock-origin
      ];
    profiles.default = {
      id = 0;
      userChrome = ''
        #contentAreaContextMenu {
          margin-left: 4px;
        } 
      '';
    };
  };

  home = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
