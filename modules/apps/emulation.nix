{ nixpkgs, pkgs, fetchFromGitHub, ... }:
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
  dolphin-emu = pkgs.unstable.dolphin-emu.overrideAttrs (old: {
    version = "2407-61";
    src = pkgs.fetchFromGitHub {
      owner = "dolphin-emu";  
      repo = "dolphin";
      rev = "549b16d442dba0d87406a2e5a79c1e576fa7f725";
      hash = "sha256-ZeYUitiiAugGgkegYHmxkGD+/UoOIvbmA1uoA/RxRO4=";
      fetchSubmodules = true;
    };
    postInstall = old.postInstall + ''
      # Remove the .svg icon to prevent it from resulting in a stretched look.
      # This should make it use the .png icon instead.
      rm -Rf $out/share/icons/hicolor/scalable/
    '';
  });
  pcsx2 = pkgs.unstable.pcsx2.overrideAttrs (old: {
    version = "2.0.2";
    src = pkgs.fetchFromGitHub {
      owner = "PCSX2";
      repo = "pcsx2";
      rev = "v2.0.2";
      hash = "sha256-RrgVVG+n3+uGMqxSfJJU4h+ukEJL0kfV+gmzt/Hdyvo=";
    };
  });
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
    # unstable.dolphin-emu
    unstable.dolphin-emu-primehack
    unstable.duckstation
    unstable.fsuae
    # unstable.fsuae-launcher # TODO: Restore
    unstable.lime3ds
    # unstable.pcsx2
    unstable.ppsspp
    unstable.rpcs3
    unstable.ryujinx
    unstable.xemu

    # Altered packages
    dolphin-emu
    pcsx2

    # Final available release, legally available and
    # fetched and built from the Software Heritage Archive
    # yuzu

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
