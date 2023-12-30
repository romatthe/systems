{ nixpkgs, pkgs, ... }:
{
  # Note: most cutting edge emulators almost never get their versions backported to stable
  environment.systemPackages = with pkgs.unstable; [
    # Standalone emulators
    cemu
    citra-nightly
    dolphin-emu
    dolphin-emu-primehack
    fsuae
    fsuae-launcher
    pcsx2
    ppsspp
    rpcs3
    ryujinx
    xemu
    yuzu-mainline # TODO: Two versions of Yuzu cannot be installed at the same time

    # DOS/x86 emulation
    _86Box
    dosbox-staging
    pcem
    # TODO: Package DBGL?

    # RetroArch
    (retroarch.override {
      cores = [
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
    })
  ];
}