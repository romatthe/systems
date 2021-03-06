{ nixpkgs, pkgs, ... }:
{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    # Steam
    steam

    # Lutris
    lutris

    # DOSBox
    dosbox-staging
    # TODO: Package DBGL?

    # Emulators
    unstable.retroarch
    unstable.pcsx2
    
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
    crawl # Dungeon Crawl Stone Soup
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
