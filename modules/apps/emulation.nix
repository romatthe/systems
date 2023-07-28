{ nixpkgs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # DOS/x86 emulation
    _86Box
    dosbox-staging
    pcem
    # TODO: Package DBGL?

    # Emulators
    # Note: most cutting edge emulators almost never get their versions backported to stable
    cemu
    citra-nightly
    dolphin-emu
    dolphin-emu-primehack
    fsuae
    fsuae-launcher
    unstable.pcsx2
    ppsspp
    (retroarch.override {
      cores = [
        libretro.beetle-psx
        libretro.beetle-psx-hw
        libretro.beetle-saturn
        libretro.beetle-supergrafx
        libretro.bsnes
        libretro.desmume
        libretro.flycast
        libretro.genesis-plus-gx
        libretro.melonds
        libretro.mesen
        libretro.mgba
        libretro.mupen64plus
        libretro.np2kai
        libretro.parallel-n64
        libretro.ppsspp
        libretro.sameboy
        libretro.snes9x
        libretro.swanstation
      ];
    })
    rpcs3
    ryujinx
    xemu
    # TODO: Two versions of Yuzu cannot be installed at the same time
    # yuzu-early-access
    yuzu-mainline
  ];
}