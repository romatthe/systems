{ config, pkgs, inputs, ... }:

{
  imports = [
    ./matsumoto-hardware.nix
  ];

  # Forgive me Stallman
  nixpkgs.config = { allowUnfree = true; };

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

  networking.hostName = "matsumoto"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.romatthe = {
    description = "Robin Mattheussen";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$3jnb5.ogAjaHO7t$.bz.QVZVPTPUe75.0HuTPhThVgrH9GFyuvqUwyTvtNvKFumw3WckiOnEfmoy/Ojewf2HwH0PLnc4Hc7bKqw57/";
  };

  # We need to add our chosen shell to /etc/shells, otherwise AccountService
  # will think we're a system user and not list us on the GDM login screen
  environment.shells = [ pkgs.fish ];

  # Enable sound.
  sound.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim git htop cmake
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Tuxedo specific configurations
  hardware.tuxedo-keyboard.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
