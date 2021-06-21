{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = true;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
    # Might be necessary to set `services.dbus.packages = [ pkgs.gcr ]`
    pinentryFlavor = "gnome3";
  };
  
  programs.gpg = {
    enable = true;
    settings = {
    };
  };
}
