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
  # For dealing with ISOs
  programs.cdemu = {
    enable = true;
    gui = true;
  };

  # Note: most cutting edge emulators almost never get their versions backported to stable
  environment.systemPackages = with pkgs; [
    # Standalone emulators
    unstable.cemu
    unstable.dolphin-emu
    unstable.dolphin-emu-primehack
    unstable.duckstation
    unstable.fsuae
    # unstable.fsuae-launcher # TODO: Restore
    unstable.lime3ds
    unstable.pcsx2
    unstable.ppsspp
    unstable.rpcs3
    unstable.ryujinx
    unstable.xemu

    # Final available release, legally available and
    # fetched and built from the Software Heritage Archive
    yuzu 

    # DOS/x86 emulation
    _86Box
    dosbox-staging
    nuked-sc55 # Roland SC-55 emulation
    pcem
    # TODO: Package DBGL?
    
    # RetroArch
    retroarch

    # Tools
    aaru
    #binaryobjectscanner # TODO: restore
    fusee-interfacee-tk   # For sending RCM payloads to Switch
    hactool               # For verifying Switch cart dumps 
    mame.tools            # Primarily for chdman
    mpf-check             # Helper tool for creating preservation submissions
    ps3-disc-dumper       # For dumping PS3 blu-rays
    redumper              # All purpose disc-dumping tool
    xdvdfs-cli            # For dealing with OG Xbox ISOs
  ];
}
