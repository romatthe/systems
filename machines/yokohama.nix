# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./yokohama-hardware.nix
  ];

  # Get the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable splash screen on boot
  boot.plymouth.enable = true;
  boot.plymouth.theme = "spinner";

  # Update CPU microcode
  hardware.cpu.amd.updateMicrocode = true;


  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostName = "yokohama"; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.interfaces.enp7s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.romatthe = {
    description = "Robin Mattheussen";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "podman" "cdrom" "libvirtd" ];
    hashedPassword = "$6$3jnb5.ogAjaHO7t$.bz.QVZVPTPUe75.0HuTPhThVgrH9GFyuvqUwyTvtNvKFumw3WckiOnEfmoy/Ojewf2HwH0PLnc4Hc7bKqw57/";
  };

  # We need to add our chosen shell to /etc/shells, otherwise AccountService
  # will think we're a system user and not list us on the login screen
  environment.shells = [ pkgs.fish ];

  # Looks like we also need to enable fish here to make sure we set some env variables correctly
  programs.fish.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 
    3389 # Gnome Remote Desktop / RDP
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
