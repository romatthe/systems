{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    grabKeyboardAndMouse = true;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
    pinentryFlavor = "gnome3";
  };

  # Might be necessary to enable the Gnome3 pinetry program
  services.dbus.packages = [ pkgs.gcr ];
  
  programs.gpg = {
    enable = true;
    settings = {
    };
  };
}
