{ nixpkgs, pkgs, ... }:
let
  retroarch = pkgs.unstable.retroarch.override {
    cores = with pkgs.unstable; [
      libretro.beetle-pcfx
      libretro.beetle-psx
      libretro.beetle-psx-hw
      libretro.beetle-saturn
      libretro.beetle-supergrafx
      libretro.bsnes
      libretro.desmume
      libretro.dosbox-pure
      libretro.flycast
      libretro.gambatte
      libretro.genesis-plus-gx
      libretro.melonds
      libretro.mesen
      libretro.mgba
      libretro.mupen64plus
      libretro.np2kai
      libretro.ppsspp
      libretro.sameboy
      libretro.snes9x
      libretro.swanstation
    ];
  };
in {
  # TODO: Disabled due to issues with the VHBA kernel module on `23.11` :(
  # For dealing with ISOs
  # programs.cdemu = {
  #   enable = true;
  #   gui = true;
  # };

  # Note: most cutting edge emulators almost never get their versions backported to stable
  environment.systemPackages = with pkgs; [
    # Standalone emulators
    unstable.cemu
    # unstable.citra-nightly
    unstable.dolphin-emu
    unstable.dolphin-emu-primehack
    unstable.fsuae
    unstable.fsuae-launcher
    unstable.pcsx2
    unstable.ppsspp
    # unstable.rpcs3 #TODO: Broken on unstable, hopefully fixed soon.
    unstable.ryujinx
    unstable.xemu
    # unstable.yuzu-mainline # TODO: Two versions of Yuzu cannot be installed at the same time

    # DOS/x86 emulation
    unstable._86Box
    unstable.dosbox-staging
    unstable.pcem
    # TODO: Package DBGL?
    
    # RetroArch
    retroarch

    # Tools
    aaru
    binaryobjectscanner
    fusee-interfacee-tk   # For sending RCM payloads to Switch
    hactool               # For verifying Switch cart dumps 
    mame.tools            # Primarily for chdman
    mpf-check             # Helper tool for creating preservation submissions
    ps3-disc-dumper       # For dumping PS3 blu-rays
    redumper              # All purpose disc-dumping tool
    xdvdfs-cli            # For dealing with OG Xbox ISOs
  ];
}