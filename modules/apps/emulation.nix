{ pkgs, ... }:
let
  retroarch = (pkgs.unstable.retroarch.withCores (cores: with cores; [
    beetle-pcfx
    beetle-psx
    beetle-psx-hw
    beetle-saturn
    beetle-supergrafx
    bsnes
    desmume
    dosbox-pure
    flycast
    gambatte
    genesis-plus-gx
    melonds
    mesen
    mgba
    mupen64plus
    neocd
    np2kai
    ppsspp
    sameboy
    snes9x
    swanstation
  ]));
in {
  # For dealing with ISOs
  programs.cdemu = {
    enable = true;
    gui = true;
  };

  # Note: most cutting edge emulators almost never get their versions backported to stable
  environment.systemPackages = with pkgs; [
    # Standalone emulators
    unstable.ares
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
    _86Box-with-roms
    dosbox-staging
    nuked-sc55 # Roland SC-55 emulation
    pcem
    # TODO: Package DBGL?
    
    # RetroArch
    retroarch

    # Tools
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
