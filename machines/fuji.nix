{ config, lib, pkgs, ... }:

{
  imports = [
    ./fuji-hardware.nix
  ];

  # Get the latest stable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable splash screen on boot
  boot.plymouth.enable = true;
  boot.plymouth.theme = "spinner";

  # Update CPU microcode
  hardware.cpu.amd.updateMicrocode = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Set your time zone
  time.timeZone = "Europe/Brussels";

  networking.hostName = "fuji";

  # Pick only one of the below networking options.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.layout = "us";

  # Enable touchpad support
  services.xserver.libinput.enable = true;
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.romatthe = {
    description = "Robin Mattheussen";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "podman" "cdrom" "libvirtd" ];
    hashedPassword = "$6$3jnb5.ogAjaHO7t$.bz.QVZVPTPUe75.0HuTPhThVgrH9GFyuvqUwyTvtNvKFumw3WckiOnEfmoy/Ojewf2HwH0PLnc4Hc7bKqw57/";
  };
  
  # We need to add our chosen shell to /etc/shells, otherwise AccountService
  # will think we're a system user and not list us on the GDM login screen
  environment.shells = [ pkgs.fish ];

  # Looks like we also need to enable fish here to make sure we set some env variables correctly
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
