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
    bottles
    heroic
    lutris
    minigalaxy

    # Steam    
    steam
    luxtorpeda

    # Tools
    vulkan-tools
    glxinfo
  
    # Linux gaming
    gamemode
    mangohud
    protontricks
    protonup
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        obs-vkcapture
      ];
    })

    # GPU monitoring
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
    retroarch
    yuzu-early-access
    yuzu-mainline
    
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

    # Roguelikes
    angband
    brogue
    cataclysm-dda
    crawl
    ivan

    # Infinit Engine
    gemrb

    # Other
    openttd
    openxcom
    runelite
    wesnoth
    widelands
  ];

  # Configure the desired RetroArch cores
  # TODO: I don not think this even works...
  nixpkgs.config.retroarch.enableBeetlePSX = true;
  nixpkgs.config.retroarch.enableBeetlePSXHW = true;
  nixpkgs.config.retroarch.enableBeetleSaturn = true;
  nixpkgs.config.retroarch.enableBeetleSaturnHW = true;
  nixpkgs.config.retroarch.enableDesmume = true;
  nixpkgs.config.retroarch.enableGenesisPlusGX = true;
  nixpkgs.config.retroarch.enableMesen = true;
  nixpkgs.config.retroarch.enableMGBA = true;
  nixpkgs.config.retroarch.enableMupen64Plus = true;
  nixpkgs.config.retroarch.enablePPSSPP = true;
  nixpkgs.config.retroarch.enableSameBoy = true;
  nixpkgs.config.retroarch.enableSnes9x = true;
}
