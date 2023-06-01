{ pkgs, ... }:
{
  # PA needs to be explicitly disabled in order for the PA server
  # to run under PipeWire
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    helvum      # Patchbay for PipeWire
    pulseaudio  # Only for cli tools
  ];
}