{
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
  services.clamav.updater.frequency = 24;
  services.clamav.updater.interval = "hourly";
}
