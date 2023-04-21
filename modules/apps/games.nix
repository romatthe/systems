{ nixpkgs, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    # extraCompatPackages = with pkgs; [
      # luxtorpeda
    # ];
  };

  # Make luxtorpeda available for Steam to detect
  # environment.sessionVariables = {
  #   STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.luxtorpeda}/bin";
  #   STEAM_EXTRA_COMPAT_TOOLS_PATHS2 = "\${STEAM_EXTRA_COMPAT_TOOLS_PATHS}:${pkgs.steam}";
  # };

  environment.systemPackages = with pkgs; [
    # Clients
    unstable.bottles # A lot of fixes are landing in unstable atm
    heroic
    lutris
    minigalaxy
    prism

    # Steam    
    steam
    luxtorpeda

    # Open source games and engines
    unstable.fheroes2 # Heroes of Might and Magic II engine
    gemrb             # Infinity Engine
    gzdoom
    openmw            # Morrowind engine 
    openttd
    openxcom          # X-Com engine
    runelite          # Runescape client
    scummvm
    uqm               # The Ur-Quan Masters
    unstable.vcmi     # Heroes of Might and Magic III engine
    wesnoth
    widelands

    # Roguelikes
    angband
    brogue
    cataclysm-dda
    crawl
    ivan

    # Dwarf Fotress
    # See https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/dwarf-fortress/default.nix for more information
    (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
      dfVersion = "0.47.04";
      theme = "vettlingr";
      enableDFHack = true;
      enableTWBT = true;
      enableSoundSense = false;
      enableStoneSense = true;
      enableDwarfTherapist = true;
      enableLegendsBrowser = true;
      enableIntro = true;
      enableFPS = true;
    })

    # Tools
    fluidsynth  # For games requiring MIDI playback
    glxinfo
    handbrake   # For gameplay videos
    gamemode
    gamescope
    mangohud
    protonup
    protontricks
    samrewritten
    unstable.steamtinkerlaunch
    unstable.vkbasalt
    unstable.vkbasalt-cli
    vulkan-tools
    winetricks

    # OBS plus plugins
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        obs-vkcapture
      ];
    })

    # GPU monitoring and control
    corectrl
    nvtop
    psensor
    radeon-profile
    radeontop

    # DOSBox
    dosbox-staging
    # TODO: Package DBGL?

    # Emulators
    cemu
    dolphin-emu
    pcsx2
    rpcs3
    (unstable.retroarch.override {
      cores = [
        libretro.beetle-psx
        libretro.beetle-psx-hw
        libretro.beetle-saturn
        libretro.bsnes
        libretro.desmume
        libretro.flycast
        libretro.genesis-plus-gx
        libretro.melonds
        libretro.mesen
        libretro.mgba
        libretro.parallel-n64
        libretro.ppsspp
        libretro.sameboy
        libretro.snes9x
        libretro.swanstation
      ];
    })
    # TODO: Two versions of Yuzu cannot be installed at the same time
    # yuzu-early-access
    yuzu-mainline
  ];
}
