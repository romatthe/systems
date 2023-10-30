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
    rpcs3
    ryujinx
    xemu
    # TODO: Two versions of Yuzu cannot be installed at the same time
    # yuzu-early-access
    yuzu-mainline

    # RetroArch
    (unstable.retroarch.override {
      cores = [
        unstable.libretro.beetle-psx
        unstable.libretro.beetle-psx-hw
        unstable.libretro.beetle-saturn
        unstable.libretro.beetle-supergrafx
        unstable.libretro.bsnes
        unstable.libretro.desmume
        unstable.libretro.dosbox
        unstable.libretro.dosbox-pure
        unstable.libretro.flycast
        unstable.libretro.gambatte
        unstable.libretro.genesis-plus-gx
        unstable.libretro.melonds
        unstable.libretro.mesen
        unstable.libretro.mgba
        unstable.libretro.mupen64plus
        unstable.libretro.np2kai
        unstable.libretro.ppsspp
        unstable.libretro.sameboy
        unstable.libretro.snes9x
        unstable.libretro.swanstation
      ];
    })
  ];
}