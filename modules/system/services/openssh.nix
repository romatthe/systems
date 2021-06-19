{
  services.openssh.enable = true;
  services.openssh.challengeResponseAuthentication = true;
  services.openssh.forwardX11 = false;
  services.openssh.openFirewall = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";
}
