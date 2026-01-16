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
    pcsx2
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
    unstable.ares                   # Mutli-system emulator
    unstable.azahar                 # 3DS emulator
    unstable.basiliskii             # Macintosh 68k emulator
    unstable.cemu                   # Wii U emulator
    unstable.deniseemu              # C64 Emulator
    unstable.dolphin-emu            # Wii emulator
    unstable.dolphin-emu-primehack  # Wii emulator Metroid Prime-specific fixes 
    #unstable.duckstation            # PS1 emulator, currently unavailable because of Stenzek drama
    unstable.fsuae                  # Commodore Amiga emulator
    unstable.fsuae-launcher         # Commodore Amige emulator (GUI)
    unstable.fuse-emulator          # ZX Spectrum emulator
    unstable.hatari                 # Atari ST-line emulator
    unstable.openmsx                # MSX and MSX2 emulator
    unstable.pcsx2                  # PS2 emulator
    unstable.ppsspp                 # PSP emulator
    unstable.rpcs3                  # PS3 emulator
    unstable.ryubing                # Ryujinx fork with updated features
    unstable.shadps4                # Experimental PS4 emulator
    unstable.vice                   # C64-line emulator
    unstable.xemu                   # OG Xbox emulator
    unstable.xenia-canary           # Fork of Xenia, Xbox 360 emulator

    # DOS/x86 emulation
    _86Box-with-roms  # Low-level retro PC emulator
    dosbox-staging    # Modern continuation of DOSBox
    pcem              # Low-level retro PC emulator
    # TODO: Package DBGL?
    
    # RetroArch
    retroarch

    # Custom packages
    # pcsx2-pgs   # PCSX2 build with ParaLLEl-GS
    nuked-sc55  # Roland SC-55 emulation
    yuzu        # Final available release, legally available and fetched and built from the Software Heritage Archive

    # Tools
    #binaryobjectscanner # TODO: restore
    fusee-interfacee-tk   # For sending RCM payloads to Switch
    hactool               # For verifying Switch cart dumps 
    mame.tools            # Primarily for chdman
    mpf-check             # Helper tool for creating preservation submissions
    nxdumpclient          # Client for dumping Switch games directly to a PC
    ps3-disc-dumper       # For dumping PS3 blu-rays
    redumper              # All purpose disc-dumping tool
    xdvdfs-cli            # For dealing with OG Xbox ISOs
  ];

  # NXDumpClient needs to wire up USB udev rules
  services.udev.packages = with pkgs; [
    nxdumpclient
  ];
}
