{ pkgs, ... }:
{
  # PA needs to be explicitly disabled in order for the PA server
  # to run under PipeWire
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    config.pipewire = {
      "context.properties" = {
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
      };
    };
  };

  environment.systemPackages = with pkgs; [
    helvum      # Patchbay for PipeWire
    pulseaudio  # Only for cli tools
  ];
}