{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = { 
      KbdInteractiveAuthentication = true;
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };
}
